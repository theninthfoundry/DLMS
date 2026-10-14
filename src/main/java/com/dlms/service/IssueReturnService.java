package com.dlms.service;

import com.dlms.dao.BookDAO;
import com.dlms.dao.FineDAO;
import com.dlms.dao.MemberDAO;
import com.dlms.dao.NotificationDAO;
import com.dlms.dao.ReservationDAO;
import com.dlms.dao.TransactionDAO;
import com.dlms.dao.UserDAO;
import com.dlms.exception.BookNotAvailableException;
import com.dlms.exception.BorrowingLimitExceededException;
import com.dlms.exception.DatabaseOperationException;
import com.dlms.exception.InvalidMemberException;
import com.dlms.model.Book;
import com.dlms.model.Fine;
import com.dlms.model.Member;
import com.dlms.model.Notification;
import com.dlms.model.Reservation;
import com.dlms.model.Transaction;
import com.dlms.model.User;
import com.dlms.util.AppConfig;
import com.dlms.util.DateUtils;

import java.time.LocalDate;
import java.util.Queue;

/**
 * Core Circulation Service enforcing strict business rules for issuing and returning books.
 * Handles automatic due date calculation, quota limits, fine assessment, and waitlist fulfillment.
 */
public class IssueReturnService {

    private final BookDAO bookDAO = new BookDAO();
    private final MemberDAO memberDAO = new MemberDAO();
    private final TransactionDAO transactionDAO = new TransactionDAO();
    private final FineDAO fineDAO = new FineDAO();
    private final ReservationDAO reservationDAO = new ReservationDAO();
    private final NotificationDAO notificationDAO = new NotificationDAO();
    private final UserDAO userDAO = new UserDAO();

    /**
     * Issues a book to a member.
     * Enforces: Member existence, Active status, Borrow limit check, Book availability check.
     */
    public Transaction issueBook(String memberId, String bookId, String issuedBy)
            throws InvalidMemberException, BookNotAvailableException, BorrowingLimitExceededException, DatabaseOperationException {

        // 1. Verify Member
        Member member = memberDAO.findByMemberId(memberId);
        if (member == null) {
            throw new InvalidMemberException("Member with ID '" + memberId + "' does not exist.");
        }
        if (!member.isActive()) {
            throw new InvalidMemberException("Member account is suspended or expired.");
        }

        // 2. Check Member Borrowing Quota Limit
        int activeLoans = transactionDAO.countActiveLoansByMember(memberId);
        if (activeLoans >= member.getMaxBorrowLimit()) {
            throw new BorrowingLimitExceededException("Borrowing limit exceeded. Member currently has " +
                    activeLoans + " issued books (Quota limit: " + member.getMaxBorrowLimit() + ").");
        }

        // 3. Verify Book and Availability
        Book book = bookDAO.findByBookId(bookId);
        if (book == null) {
            throw new BookNotAvailableException("Book with ID '" + bookId + "' was not found in the catalog.");
        }
        if (book.getAvailableCopies() <= 0) {
            throw new BookNotAvailableException("Book '" + book.getTitle() + "' is currently out of stock.");
        }

        // 4. Calculate Due Date polymorphically (14 days for students, 30 days for faculty)
        LocalDate issueDate = LocalDate.now();
        int allowedDays = member.getAllowedBorrowDays();
        LocalDate dueDate = DateUtils.calculateDueDate(issueDate, allowedDays);

        String transactionId = "TXN-" + System.currentTimeMillis();

        Transaction tx = new Transaction();
        tx.setTransactionId(transactionId);
        tx.setMemberId(memberId);
        tx.setBookId(bookId);
        tx.setIssueDate(issueDate);
        tx.setDueDate(dueDate);
        tx.setFine(0.0);
        tx.setStatus(Transaction.Status.ISSUED);
        tx.setIssuedBy(issuedBy != null ? issuedBy : "admin");
        tx.setRemarks("Issued for " + allowedDays + " days.");

        // 5. Decrement book available copies
        bookDAO.updateAvailableCopies(bookId, -1);

        // 6. Save Transaction
        transactionDAO.create(tx);

        return tx;
    }

    /**
     * Processes a book return.
     * Calculates overdue fines, increments book copy count, records fine if late,
     * and checks reservation queue to notify waiting patrons.
     */
    public Transaction returnBook(String transactionId, String returnRemarks)
            throws DatabaseOperationException, IllegalArgumentException {

        Transaction tx = transactionDAO.findByTransactionId(transactionId);
        if (tx == null) {
            throw new IllegalArgumentException("Transaction ID '" + transactionId + "' was not found.");
        }
        if (tx.getStatus() == Transaction.Status.RETURNED) {
            throw new IllegalArgumentException("Book has already been returned for this transaction.");
        }

        LocalDate returnDate = LocalDate.now();
        LocalDate dueDate = tx.getDueDate();
        int daysLate = DateUtils.calculateDaysLate(dueDate, returnDate);

        // Load member for fine policy rate
        Member member = memberDAO.findByMemberId(tx.getMemberId());
        double baseFineRate = AppConfig.getInstance().getDouble("library.finePerDay", 5.00);
        double fineRate = member != null ? member.calculateFineRate(baseFineRate) : baseFineRate;

        double fineAmount = DateUtils.calculateFine(daysLate, fineRate);

        // 1. Update Transaction record
        String remarks = (returnRemarks != null && !returnRemarks.trim().isEmpty()) ? returnRemarks.trim() :
                (daysLate > 0 ? "Returned " + daysLate + " days late" : "Returned on time");

        transactionDAO.updateReturn(transactionId, returnDate, fineAmount, remarks);
        tx.setReturnDate(returnDate);
        tx.setFine(fineAmount);
        tx.setStatus(Transaction.Status.RETURNED);
        tx.setRemarks(remarks);

        // 2. Increment book available copies
        bookDAO.updateAvailableCopies(tx.getBookId(), 1);

        // 3. Create Fine record if late
        if (fineAmount > 0) {
            Fine fine = new Fine();
            fine.setFineId("FN-" + System.currentTimeMillis());
            fine.setTransactionId(transactionId);
            fine.setMemberId(tx.getMemberId());
            fine.setAmount(fineAmount);
            fine.setDaysLate(daysLate);
            fine.setStatus(Fine.Status.UNPAID);
            fineDAO.create(fine);
        }

        // 4. Check Reservation Waitlist Queue for this book (FIFO)
        try {
            Queue<Reservation> waitlist = reservationDAO.getQueueForBook(tx.getBookId());
            if (!waitlist.isEmpty()) {
                Reservation topRes = waitlist.peek();
                // Send notification to the next member in the queue
                User resUser = userDAO.findByUsername(topRes.getMemberId());
                if (resUser != null) {
                    Notification notif = new Notification();
                    notif.setUserId(resUser.getId());
                    notif.setTitle("Reserved Book Available!");
                    notif.setMessage("A copy of '" + tx.getBookTitle() + "' is now available for collection.");
                    notif.setType(Notification.Type.SUCCESS);
                    notificationDAO.create(notif);
                }
            }
        } catch (Exception ignored) {
            // Non-blocking notification dispatch
        }

        return tx;
    }
}
