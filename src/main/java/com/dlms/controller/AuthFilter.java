package com.dlms.controller;

import com.dlms.model.User;

import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

/**
 * Security filter enforcing session authentication and role-based access control (RBAC).
 * Intercepts requests to /admin/* and /student/* protected routes.
 */
@WebFilter(urlPatterns = {"/admin/*", "/student/*"})
public class AuthFilter implements Filter {

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {}

    @Override
    public void doFilter(ServletRequest req, ServletResponse res, FilterChain chain) throws IOException, ServletException {
        HttpServletRequest request = (HttpServletRequest) req;
        HttpServletResponse response = (HttpServletResponse) res;

        String path = request.getRequestURI();
        HttpSession session = request.getSession(false);
        User currentUser = (session != null) ? (User) session.getAttribute("currentUser") : null;

        // If not logged in, redirect to login page
        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/login?error=Session expired. Please log in.");
            return;
        }

        // Role-based authorization rules:
        // Admin path: only ADMIN and LIBRARIAN allowed
        if (path.contains("/admin/")) {
            if (!currentUser.isAdmin()) {
                response.sendRedirect(request.getContextPath() + "/student/dashboard?error=Access denied: Admin privileges required.");
                return;
            }
        }

        // Student path: only STUDENT and FACULTY allowed (or Admin preview)
        if (path.contains("/student/")) {
            if (currentUser.isAdmin()) {
                // Allow admin to preview student views if needed or pass
                chain.doFilter(req, res);
                return;
            }
        }

        chain.doFilter(req, res);
    }

    @Override
    public void destroy() {}
}
