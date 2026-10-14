package com.dlms.controller;

import com.dlms.dao.TransactionDAO;
import com.dlms.exception.DatabaseOperationException;
import com.dlms.model.Transaction;
import com.google.gson.Gson;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.HashMap;
import java.util.Map;
import java.util.Stack;

/**
 * Controller for Admin Dashboard and dynamic Chart.js JSON APIs.
 * Aggregates real-time database metrics without any hardcoding.
 */
@WebServlet(name = "AdminDashboardServlet", urlPatterns = {"/admin/dashboard", "/admin/api/stats", "/admin/settings"})
public class AdminDashboardServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private final TransactionDAO transactionDAO = new TransactionDAO();
    private final Gson gson = new Gson();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String path = req.getServletPath();

        try {
            if ("/admin/settings".equals(path)) {
                req.getRequestDispatcher("/admin/settings.jsp").forward(req, resp);
                return;
            }
            if ("/admin/api/stats".equals(path)) {
                handleApiStats(req, resp);
                return;
            }

            // Standard Dashboard View Request
            Map<String, Object> stats = transactionDAO.getDashboardStats();
            req.setAttribute("stats", stats);

            // Fetch recent activities using Stack data structure
            Stack<Transaction> recentStack = transactionDAO.getRecentActivitiesStack(6);
            req.setAttribute("recentActivities", recentStack);

            // Category breakdown
            Map<String, Integer> categories = transactionDAO.getCategoryDistribution();
            req.setAttribute("categories", categories);

            req.getRequestDispatcher("/admin/dashboard.jsp").forward(req, resp);

        } catch (DatabaseOperationException e) {
            req.setAttribute("dbError", e.getMessage());
            req.getRequestDispatcher("/admin/dashboard.jsp").forward(req, resp);
        }
    }

    private void handleApiStats(HttpServletRequest req, HttpServletResponse resp) throws IOException, DatabaseOperationException {
        resp.setContentType("application/json");
        resp.setCharacterEncoding("UTF-8");

        Map<String, Object> stats = transactionDAO.getDashboardStats();
        Map<String, Integer> categories = transactionDAO.getCategoryDistribution();
        Map<String, Integer> trends = transactionDAO.getMonthlyTransactionTrends();

        Map<String, Object> responseData = new HashMap<>();
        responseData.put("summary", stats);
        responseData.put("categories", categories);
        responseData.put("monthlyTrends", trends);

        resp.getWriter().write(gson.toJson(responseData));
    }
}
