package com.dlms.controller;

import com.dlms.exception.DatabaseOperationException;
import com.dlms.exception.InvalidLoginException;
import com.dlms.model.User;
import com.dlms.service.AuthService;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

/**
 * Servlet handling User Authentication, Login, and Session Termination (Logout).
 */
@WebServlet(name = "AuthServlet", urlPatterns = {"/login", "/logout"})
public class AuthServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private final AuthService authService = new AuthService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String path = req.getServletPath();

        if ("/logout".equals(path)) {
            HttpSession session = req.getSession(false);
            if (session != null) {
                session.invalidate();
            }
            resp.sendRedirect(req.getContextPath() + "/login?msg=You have been logged out securely.");
            return;
        }

        // Check if user is already logged in
        HttpSession session = req.getSession(false);
        if (session != null && session.getAttribute("currentUser") != null) {
            User user = (User) session.getAttribute("currentUser");
            if (user.isAdmin()) {
                resp.sendRedirect(req.getContextPath() + "/admin/dashboard");
            } else {
                resp.sendRedirect(req.getContextPath() + "/student/dashboard");
            }
            return;
        }

        req.getRequestDispatcher("/login.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String usernameOrEmail = req.getParameter("username");
        String password = req.getParameter("password");
        String rememberMe = req.getParameter("remember");

        try {
            User user = authService.login(usernameOrEmail, password);

            // Establish secure HTTP session
            HttpSession session = req.getSession(true);
            session.setAttribute("currentUser", user);
            session.setMaxInactiveInterval(rememberMe != null ? 7 * 24 * 3600 : 3600); // 7 days or 1 hour

            if (user.isAdmin()) {
                resp.sendRedirect(req.getContextPath() + "/admin/dashboard");
            } else {
                resp.sendRedirect(req.getContextPath() + "/student/dashboard");
            }
        } catch (InvalidLoginException e) {
            req.setAttribute("errorMessage", e.getMessage());
            req.setAttribute("prevUsername", usernameOrEmail);
            req.getRequestDispatcher("/login.jsp").forward(req, resp);
        } catch (DatabaseOperationException e) {
            req.setAttribute("errorMessage", "Database Connection Error: Please verify MySQL server is running and database.sql is imported.");
            req.setAttribute("prevUsername", usernameOrEmail);
            req.getRequestDispatcher("/login.jsp").forward(req, resp);
        }
    }
}
