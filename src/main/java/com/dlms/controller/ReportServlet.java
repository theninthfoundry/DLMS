package com.dlms.controller;

import com.dlms.exception.DatabaseOperationException;
import com.dlms.service.ReportService;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.Map;

/**
 * Controller for Library Analytics Reports and CSV Data Exports.
 */
@WebServlet(name = "ReportServlet", urlPatterns = {"/admin/reports", "/admin/export"})
public class ReportServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private final ReportService reportService = new ReportService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String path = req.getServletPath();

        try {
            if ("/admin/export".equals(path)) {
                handleCsvExport(req, resp);
                return;
            }

            Map<String, Object> summary = reportService.getComprehensiveReportSummary();
            req.setAttribute("summary", summary);
            req.getRequestDispatcher("/admin/reports.jsp").forward(req, resp);

        } catch (DatabaseOperationException e) {
            req.setAttribute("errorMessage", "Error loading reports: " + e.getMessage());
            req.getRequestDispatcher("/admin/dashboard.jsp").forward(req, resp);
        }
    }

    private void handleCsvExport(HttpServletRequest req, HttpServletResponse resp) throws IOException, DatabaseOperationException {
        String type = req.getParameter("type");
        if (type == null) type = "books";

        resp.setContentType("text/csv");
        resp.setHeader("Content-Disposition", "attachment; filename=\"dlms_" + type + "_report_" + System.currentTimeMillis() + ".csv\"");

        PrintWriter writer = resp.getWriter();
        switch (type.toLowerCase()) {
            case "members":
                reportService.exportMembersToCsv(writer);
                break;
            case "transactions":
                reportService.exportTransactionsToCsv(writer);
                break;
            case "fines":
                reportService.exportFinesToCsv(writer);
                break;
            case "books":
            default:
                reportService.exportBooksToCsv(writer);
                break;
        }
        writer.flush();
    }
}
