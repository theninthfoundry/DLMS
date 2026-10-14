package com.dlms.controller;

import com.dlms.exception.DatabaseOperationException;
import com.dlms.model.Fine;
import com.dlms.service.FineService;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

/**
 * Controller for Overdue Fines and Payment Tracking.
 */
@WebServlet(name = "FineServlet", urlPatterns = {"/admin/fines", "/admin/fines/*"})
public class FineServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private final FineService fineService = new FineService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        try {
            String query = req.getParameter("q");
            String status = req.getParameter("status");

            int page = 1;
            int pageSize = 15;
            try {
                if (req.getParameter("page") != null) {
                    page = Math.max(1, Integer.parseInt(req.getParameter("page")));
                }
            } catch (NumberFormatException ignored) {}

            List<Fine> fines = fineService.getFines(query, status, page, pageSize);
            req.setAttribute("fines", fines);
            req.setAttribute("paramQuery", query);
            req.setAttribute("paramStatus", status);

            req.getRequestDispatcher("/admin/fines.jsp").forward(req, resp);
        } catch (DatabaseOperationException e) {
            req.setAttribute("errorMessage", "Database error: " + e.getMessage());
            req.getRequestDispatcher("/admin/fines.jsp").forward(req, resp);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action");
        try {
            if ("pay".equals(action)) {
                String fineId = req.getParameter("fineId");
                String mode = req.getParameter("paymentMode");
                fineService.markFinePaid(fineId, mode);
                resp.sendRedirect(req.getContextPath() + "/admin/fines?success=Fine (" + fineId + ") marked as PAID via " + mode + ".");
            }
        } catch (DatabaseOperationException e) {
            resp.sendRedirect(req.getContextPath() + "/admin/fines?error=" + e.getMessage());
        }
    }
}
