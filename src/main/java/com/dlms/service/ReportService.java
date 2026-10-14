package com.dlms.service;

import com.dlms.dao.BookDAO;
import com.dlms.dao.FineDAO;
import com.dlms.dao.MemberDAO;
import com.dlms.dao.TransactionDAO;
import com.dlms.exception.DatabaseOperationException;
import com.dlms.model.Book;
import com.dlms.model.Fine;
import com.dlms.model.Member;
import com.dlms.model.Transaction;

import java.io.PrintWriter;
import java.util.List;
import java.util.Map;

/**
 * Service generating analytical summaries and CSV exports for library reporting.
 */
public class ReportService {

    private final TransactionDAO transactionDAO = new TransactionDAO();
    private final BookDAO bookDAO = new BookDAO();
    private final MemberDAO memberDAO = new MemberDAO();
    private final FineDAO fineDAO = new FineDAO();

    public Map<String, Object> getComprehensiveReportSummary() throws DatabaseOperationException {
        return transactionDAO.getDashboardStats();
    }

    public void exportBooksToCsv(PrintWriter writer) throws DatabaseOperationException {
        writer.println("Book ID,ISBN,Title,Author,Category,Publisher,Year,Shelf,Total Qty,Available,Status");
        List<Book> books = bookDAO.findAll(null, null, null, 0, 10000);
        for (Book b : books) {
            writer.printf("\"%s\",\"%s\",\"%s\",\"%s\",\"%s\",\"%s\",%d,\"%s\",%d,%d,\"%s\"%n",
                    escapeCsv(b.getBookId()), escapeCsv(b.getIsbn()), escapeCsv(b.getTitle()),
                    escapeCsv(b.getAuthor()), escapeCsv(b.getCategory()), escapeCsv(b.getPublisher()),
                    b.getPublicationYear(), escapeCsv(b.getShelfNumber()), b.getQuantity(),
                    b.getAvailableCopies(), b.getStatus());
        }
    }

    public void exportTransactionsToCsv(PrintWriter writer) throws DatabaseOperationException {
        writer.println("Transaction ID,Member ID,Member Name,Book ID,Book Title,Issue Date,Due Date,Return Date,Fine,Status");
        List<Transaction> txList = transactionDAO.findAll(null, null, null, 0, 10000);
        for (Transaction t : txList) {
            writer.printf("\"%s\",\"%s\",\"%s\",\"%s\",\"%s\",\"%s\",\"%s\",\"%s\",%.2f,\"%s\"%n",
                    escapeCsv(t.getTransactionId()), escapeCsv(t.getMemberId()), escapeCsv(t.getMemberName()),
                    escapeCsv(t.getBookId()), escapeCsv(t.getBookTitle()),
                    t.getIssueDate() != null ? t.getIssueDate().toString() : "",
                    t.getDueDate() != null ? t.getDueDate().toString() : "",
                    t.getReturnDate() != null ? t.getReturnDate().toString() : "",
                    t.getFine(), t.getStatus() != null ? t.getStatus().name() : "");
        }
    }

    public void exportMembersToCsv(PrintWriter writer) throws DatabaseOperationException {
        writer.println("Member ID,Name,Email,Phone,Department,Role,Max Limit,Registration Date,Status");
        List<Member> members = memberDAO.findAll(null, null, null, 0, 10000);
        for (Member m : members) {
            writer.printf("\"%s\",\"%s\",\"%s\",\"%s\",\"%s\",\"%s\",%d,\"%s\",\"%s\"%n",
                    escapeCsv(m.getMemberId()), escapeCsv(m.getName()), escapeCsv(m.getEmail()),
                    escapeCsv(m.getPhone()), escapeCsv(m.getDepartment()), escapeCsv(m.getRoleDescription()),
                    m.getMaxBorrowLimit(), m.getRegistrationDate() != null ? m.getRegistrationDate().toString() : "",
                    m.getStatus());
        }
    }

    public void exportFinesToCsv(PrintWriter writer) throws DatabaseOperationException {
        writer.println("Fine ID,Transaction ID,Member ID,Member Name,Book Title,Amount,Days Late,Status,Payment Mode");
        List<Fine> fines = fineDAO.findAll(null, null, 0, 10000);
        for (Fine f : fines) {
            writer.printf("\"%s\",\"%s\",\"%s\",\"%s\",\"%s\",%.2f,%d,\"%s\",\"%s\"%n",
                    escapeCsv(f.getFineId()), escapeCsv(f.getTransactionId()), escapeCsv(f.getMemberId()),
                    escapeCsv(f.getMemberName()), escapeCsv(f.getBookTitle()), f.getAmount(),
                    f.getDaysLate(), f.getStatus() != null ? f.getStatus().name() : "",
                    f.getPaymentMode() != null ? f.getPaymentMode() : "UNPAID");
        }
    }

    private String escapeCsv(String val) {
        if (val == null) return "";
        return val.replace("\"", "\"\"");
    }
}
