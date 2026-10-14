package com.dlms.controller;

import com.dlms.dao.BookDAO;
import com.dlms.dao.MemberDAO;
import com.dlms.dao.TransactionDAO;
import com.dlms.exception.BookNotAvailableException;
import com.dlms.exception.BorrowingLimitExceededException;
import com.dlms.exception.DatabaseOperationException;
import com.dlms.exception.InvalidMemberException;
import com.dlms.model.Book;
import com.dlms.model.Member;
import com.dlms.model.Transaction;
import com.dlms.model.User;
import com.dlms.service.IssueReturnService;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

/**
 * Controller managing Circulation Workflows:
 * - Issue Book (/admin/issue)
 * - Return Book (/admin/return)
 * - Transaction History (/admin/transactions)
 */
@WebServlet(name = "IssueReturnServlet", urlPatterns = {"/admin/issue", "/admin/return", "/admin/transactions"})
public class IssueReturnServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private final IssueReturnService circulationService = new IssueReturnService();
    private final TransactionDAO transactionDAO = new TransactionDAO();
    private final BookDAO bookDAO = new BookDAO();
    private final MemberDAO memberDAO = new MemberDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String path = req.getServletPath();

        try {
            if ("/admin/issue".equals(path)) {
                showIssuePage(req, resp);
            } else if ("/admin/return".equals(path)) {
                showReturnPage(req, resp);
            } else if ("/admin/transactions".equals(path)) {
                showTransactionsHistory(req, resp);
            }
        } catch (Exception e) {
            req.setAttribute("errorMessage", "Error: " + e.getMessage());
            req.getRequestDispatcher("/admin/dashboard.jsp").forward(req, resp);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String path = req.getServletPath();

        try {
            if ("/admin/issue".equals(path)) {
                processIssueBook(req, resp);
            } else if ("/admin/return".equals(path)) {
                processReturnBook(req, resp);
            }
        } catch (Exception e) {
            req.setAttribute("errorMessage", e.getMessage());
            try {
                if ("/admin/issue".equals(path)) {
                    showIssuePage(req, resp);
                } else {
                    showReturnPage(req, resp);
                }
            } catch (DatabaseOperationException de) {
                throw new ServletException(de);
            }
        }
    }

    private void showIssuePage(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException, DatabaseOperationException {
        // Load active members and available books for quick dropdown selection
        List<Member> members = memberDAO.findAll(null, null, null, 0, 100);
        List<Book> books = bookDAO.findAll(null, null, "available", 0, 100);

        String preselectedBook = req.getParameter("bookId");
        String preselectedMember = req.getParameter("memberId");

        req.setAttribute("members", members);
        req.setAttribute("books", books);
        req.setAttribute("preselectedBook", preselectedBook);
        req.setAttribute("preselectedMember", preselectedMember);

        req.getRequestDispatcher("/admin/issue-book.jsp").forward(req, resp);
    }

    private void processIssueBook(HttpServletRequest req, HttpServletResponse resp) throws Exception {
        String memberId = req.getParameter("memberId");
        String bookId = req.getParameter("bookId");

        HttpSession session = req.getSession(false);
        User currentUser = (session != null) ? (User) session.getAttribute("currentUser") : null;
        String issuedBy = (currentUser != null) ? currentUser.getUsername() : "admin";

        try {
            Transaction tx = circulationService.issueBook(memberId, bookId, issuedBy);
            resp.sendRedirect(req.getContextPath() + "/admin/transactions?success=Book issued successfully! Due date is " + tx.getFormattedDueDate() + " (TXN: " + tx.getTransactionId() + ")");
        } catch (InvalidMemberException | BookNotAvailableException | BorrowingLimitExceededException e) {
            req.setAttribute("errorMessage", e.getMessage());
            showIssuePage(req, resp);
        }
    }

    private void showReturnPage(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException, DatabaseOperationException {
        String txId = req.getParameter("txId");
        if (txId != null && !txId.trim().isEmpty()) {
            Transaction tx = transactionDAO.findByTransactionId(txId.trim());
            req.setAttribute("selectedTransaction", tx);
        }

        // Active issued transactions list for return selection
        List<Transaction> activeLoans = transactionDAO.findAll(null, "ISSUED", null, 0, 100);
        req.setAttribute("activeLoans", activeLoans);

        req.getRequestDispatcher("/admin/return-book.jsp").forward(req, resp);
    }

    private void processReturnBook(HttpServletRequest req, HttpServletResponse resp) throws Exception {
        String transactionId = req.getParameter("transactionId");
        String remarks = req.getParameter("remarks");

        Transaction tx = circulationService.returnBook(transactionId, remarks);
        String msg = "Book returned successfully.";
        if (tx.getFine() > 0) {
            msg += " Late fine of ₹" + String.format("%.2f", tx.getFine()) + " calculated.";
        }
        resp.sendRedirect(req.getContextPath() + "/admin/transactions?success=" + msg);
    }

    private void showTransactionsHistory(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException, DatabaseOperationException {
        String query = req.getParameter("q");
        String status = req.getParameter("status");

        int page = 1;
        int pageSize = 15;
        try {
            if (req.getParameter("page") != null) {
                page = Math.max(1, Integer.parseInt(req.getParameter("page")));
            }
        } catch (NumberFormatException ignored) {}

        int offset = (page - 1) * pageSize;
        List<Transaction> transactions = transactionDAO.findAll(query, status, null, offset, pageSize);
        int totalCount = transactionDAO.count(query, status, null);
        int totalPages = (int) Math.ceil((double) totalCount / pageSize);

        req.setAttribute("transactions", transactions);
        req.setAttribute("totalCount", totalCount);
        req.setAttribute("currentPage", page);
        req.setAttribute("totalPages", totalPages);
        req.setAttribute("paramQuery", query);
        req.setAttribute("paramStatus", status);

        req.getRequestDispatcher("/admin/transactions.jsp").forward(req, resp);
    }
}
