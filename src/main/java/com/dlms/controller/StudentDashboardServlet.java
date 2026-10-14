package com.dlms.controller;

import com.dlms.dao.BookDAO;
import com.dlms.dao.FineDAO;
import com.dlms.dao.MemberDAO;
import com.dlms.dao.NotificationDAO;
import com.dlms.dao.ReservationDAO;
import com.dlms.dao.TransactionDAO;
import com.dlms.dao.UserDAO;
import com.dlms.exception.DatabaseOperationException;
import com.dlms.model.Book;
import com.dlms.model.Fine;
import com.dlms.model.Member;
import com.dlms.model.Notification;
import com.dlms.model.Reservation;
import com.dlms.model.Transaction;
import com.dlms.model.User;
import com.dlms.service.BookService;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

/**
 * Controller for Student Portal (Personal Dashboard, Catalogue Search, My Books, Reservations, Fines, and Profile).
 */
@WebServlet(name = "StudentDashboardServlet", urlPatterns = {
        "/student/dashboard",
        "/student/browse",
        "/student/my-books",
        "/student/history",
        "/student/reservations",
        "/student/fines",
        "/student/profile",
        "/student/change-password"
})
public class StudentDashboardServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private final MemberDAO memberDAO = new MemberDAO();
    private final TransactionDAO transactionDAO = new TransactionDAO();
    private final BookDAO bookDAO = new BookDAO();
    private final FineDAO fineDAO = new FineDAO();
    private final ReservationDAO reservationDAO = new ReservationDAO();
    private final NotificationDAO notificationDAO = new NotificationDAO();
    private final UserDAO userDAO = new UserDAO();
    private final BookService bookService = new BookService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String path = req.getServletPath();
        HttpSession session = req.getSession(false);
        User currentUser = (session != null) ? (User) session.getAttribute("currentUser") : null;

        if (currentUser == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        String memberId = currentUser.getMemberId();
        // Fallback default member if unlinked (e.g. for testing)
        if (memberId == null || memberId.trim().isEmpty()) {
            memberId = "MEM-2024-001";
        }

        try {
            Member member = memberDAO.findByMemberId(memberId);
            req.setAttribute("member", member);

            // Fetch unread notifications
            List<Notification> notifications = notificationDAO.findByUserId(currentUser.getId(), 5);
            int unreadCount = notificationDAO.countUnread(currentUser.getId());
            req.setAttribute("notifications", notifications);
            req.setAttribute("unreadCount", unreadCount);

            switch (path) {
                case "/student/browse":
                    handleBrowse(req, resp);
                    break;
                case "/student/my-books":
                    handleMyBooks(req, resp, memberId);
                    break;
                case "/student/history":
                    handleHistory(req, resp, memberId);
                    break;
                case "/student/reservations":
                    handleReservations(req, resp, memberId);
                    break;
                case "/student/fines":
                    handleFines(req, resp, memberId);
                    break;
                case "/student/profile":
                    req.getRequestDispatcher("/student/profile.jsp").forward(req, resp);
                    break;
                case "/student/dashboard":
                default:
                    handleDashboard(req, resp, memberId);
                    break;
            }
        } catch (DatabaseOperationException e) {
            req.setAttribute("errorMessage", "Database error: " + e.getMessage());
            req.getRequestDispatcher("/student/dashboard.jsp").forward(req, resp);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String path = req.getServletPath();
        HttpSession session = req.getSession(false);
        User currentUser = (session != null) ? (User) session.getAttribute("currentUser") : null;

        if (currentUser == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        if ("/student/change-password".equals(path)) {
            String newPass = req.getParameter("newPassword");
            String confirmPass = req.getParameter("confirmPassword");
            if (newPass != null && newPass.equals(confirmPass) && newPass.length() >= 6) {
                try {
                    userDAO.updatePassword(currentUser.getId(), newPass);
                    resp.sendRedirect(req.getContextPath() + "/student/profile?success=Password updated successfully!");
                } catch (DatabaseOperationException e) {
                    resp.sendRedirect(req.getContextPath() + "/student/profile?error=" + e.getMessage());
                }
            } else {
                resp.sendRedirect(req.getContextPath() + "/student/profile?error=Passwords do not match or are too short (min 6 characters).");
            }
        }
    }

    private void handleDashboard(HttpServletRequest req, HttpServletResponse resp, String memberId)
            throws ServletException, IOException, DatabaseOperationException {

        List<Transaction> activeLoans = transactionDAO.findAll(null, "ISSUED", memberId, 0, 10);
        double unpaidFines = fineDAO.getTotalUnpaidForMember(memberId);
        List<Reservation> reservations = reservationDAO.findByMemberId(memberId);
        List<Book> recommended = bookDAO.findAll(null, null, "available", 0, 4);

        int overdueCount = 0;
        for (Transaction t : activeLoans) {
            if (t.isOverdue()) overdueCount++;
        }

        req.setAttribute("activeLoans", activeLoans);
        req.setAttribute("unpaidFines", unpaidFines);
        req.setAttribute("reservations", reservations);
        req.setAttribute("recommendedBooks", recommended);
        req.setAttribute("overdueCount", overdueCount);

        req.getRequestDispatcher("/student/dashboard.jsp").forward(req, resp);
    }

    private void handleBrowse(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException, DatabaseOperationException {

        String query = req.getParameter("q");
        String category = req.getParameter("category");
        String sortBy = req.getParameter("sort");

        int page = 1;
        int pageSize = 12;
        try {
            if (req.getParameter("page") != null) {
                page = Math.max(1, Integer.parseInt(req.getParameter("page")));
            }
        } catch (NumberFormatException ignored) {}

        List<Book> books = bookService.getBooks(query, category, sortBy, page, pageSize);
        int totalCount = bookService.getTotalBooksCount(query, category);
        int totalPages = (int) Math.ceil((double) totalCount / pageSize);

        req.setAttribute("books", books);
        req.setAttribute("categories", bookService.getCategories());
        req.setAttribute("totalCount", totalCount);
        req.setAttribute("currentPage", page);
        req.setAttribute("totalPages", totalPages);
        req.setAttribute("paramQuery", query);
        req.setAttribute("paramCategory", category);

        req.getRequestDispatcher("/student/browse-books.jsp").forward(req, resp);
    }

    private void handleMyBooks(HttpServletRequest req, HttpServletResponse resp, String memberId)
            throws ServletException, IOException, DatabaseOperationException {
        List<Transaction> activeLoans = transactionDAO.findAll(null, "ISSUED", memberId, 0, 50);
        req.setAttribute("activeLoans", activeLoans);
        req.getRequestDispatcher("/student/my-books.jsp").forward(req, resp);
    }

    private void handleHistory(HttpServletRequest req, HttpServletResponse resp, String memberId)
            throws ServletException, IOException, DatabaseOperationException {
        String status = req.getParameter("status");
        List<Transaction> history = transactionDAO.findAll(null, status, memberId, 0, 100);
        req.setAttribute("history", history);
        req.setAttribute("paramStatus", status);
        req.getRequestDispatcher("/student/history.jsp").forward(req, resp);
    }

    private void handleReservations(HttpServletRequest req, HttpServletResponse resp, String memberId)
            throws ServletException, IOException, DatabaseOperationException {
        List<Reservation> reservations = reservationDAO.findByMemberId(memberId);
        req.setAttribute("reservations", reservations);
        req.getRequestDispatcher("/student/reservations.jsp").forward(req, resp);
    }

    private void handleFines(HttpServletRequest req, HttpServletResponse resp, String memberId)
            throws ServletException, IOException, DatabaseOperationException {
        List<Fine> fines = fineDAO.findByMemberId(memberId);
        double totalUnpaid = fineDAO.getTotalUnpaidForMember(memberId);
        req.setAttribute("fines", fines);
        req.setAttribute("totalUnpaid", totalUnpaid);
        req.getRequestDispatcher("/student/fines.jsp").forward(req, resp);
    }
}
