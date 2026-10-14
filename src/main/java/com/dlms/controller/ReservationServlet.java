package com.dlms.controller;

import com.dlms.exception.DatabaseOperationException;
import com.dlms.model.Reservation;
import com.dlms.model.User;
import com.dlms.service.ReservationService;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

/**
 * Controller for Book Reservations and Queue Management.
 */
@WebServlet(name = "ReservationServlet", urlPatterns = {"/admin/reservations", "/student/reserve", "/student/cancel-reserve"})
public class ReservationServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private final ReservationService reservationService = new ReservationService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String path = req.getServletPath();

        try {
            if ("/admin/reservations".equals(path)) {
                String query = req.getParameter("q");
                String status = req.getParameter("status");
                List<Reservation> list = reservationService.getReservations(query, status, 1, 20);
                req.setAttribute("reservations", list);
                req.getRequestDispatcher("/admin/reservations.jsp").forward(req, resp);
            }
        } catch (DatabaseOperationException e) {
            req.setAttribute("errorMessage", "Error: " + e.getMessage());
            req.getRequestDispatcher("/admin/reservations.jsp").forward(req, resp);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String path = req.getServletPath();
        HttpSession session = req.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("currentUser") : null;

        try {
            if ("/student/reserve".equals(path)) {
                String bookId = req.getParameter("bookId");
                String memberId = (user != null && user.getMemberId() != null) ? user.getMemberId() : req.getParameter("memberId");

                Reservation res = reservationService.reserveBook(memberId, bookId);
                resp.sendRedirect(req.getContextPath() + "/student/reservations?success=Book reserved successfully! Your queue position is #" + res.getQueuePosition());
            } else if ("/student/cancel-reserve".equals(path) || "/admin/reservations".equals(path)) {
                String resId = req.getParameter("reservationId");
                reservationService.cancelReservation(resId);
                if (user != null && user.isAdmin()) {
                    resp.sendRedirect(req.getContextPath() + "/admin/reservations?success=Reservation cancelled.");
                } else {
                    resp.sendRedirect(req.getContextPath() + "/student/reservations?success=Reservation cancelled.");
                }
            }
        } catch (Exception e) {
            if (user != null && user.isAdmin()) {
                resp.sendRedirect(req.getContextPath() + "/admin/reservations?error=" + e.getMessage());
            } else {
                resp.sendRedirect(req.getContextPath() + "/student/browse?error=" + e.getMessage());
            }
        }
    }
}
