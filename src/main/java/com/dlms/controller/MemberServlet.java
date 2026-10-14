package com.dlms.controller;

import com.dlms.dao.MemberDAO;
import com.dlms.dao.UserDAO;
import com.dlms.exception.DatabaseOperationException;
import com.dlms.model.Faculty;
import com.dlms.model.Member;
import com.dlms.model.Student;
import com.dlms.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.time.LocalDate;
import java.util.List;

/**
 * Controller for Member Management (Register, Update, Delete, Search, and Filter).
 */
@WebServlet(name = "MemberServlet", urlPatterns = {"/admin/members", "/admin/members/*"})
public class MemberServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private final MemberDAO memberDAO = new MemberDAO();
    private final UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action");
        if (action == null) action = "list";

        try {
            switch (action) {
                case "new":
                    showAddForm(req, resp);
                    break;
                case "edit":
                    showEditForm(req, resp);
                    break;
                case "delete":
                    deleteMember(req, resp);
                    break;
                case "list":
                default:
                    listMembers(req, resp);
                    break;
            }
        } catch (Exception e) {
            req.setAttribute("errorMessage", "Error: " + e.getMessage());
            listMembers(req, resp);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action");
        try {
            if ("update".equals(action)) {
                updateMember(req, resp);
            } else {
                saveMember(req, resp);
            }
        } catch (Exception e) {
            req.setAttribute("errorMessage", "Error: " + e.getMessage());
            showAddForm(req, resp);
        }
    }

    private void listMembers(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        try {
            String query = req.getParameter("q");
            String department = req.getParameter("dept");
            String type = req.getParameter("type");

            int page = 1;
            int pageSize = 15;
            try {
                if (req.getParameter("page") != null) {
                    page = Math.max(1, Integer.parseInt(req.getParameter("page")));
                }
            } catch (NumberFormatException ignored) {}

            int offset = (page - 1) * pageSize;
            List<Member> members = memberDAO.findAll(query, department, type, offset, pageSize);
            int totalCount = memberDAO.count(query, department, type);
            int totalPages = (int) Math.ceil((double) totalCount / pageSize);
            List<String> departments = memberDAO.getDistinctDepartments();

            req.setAttribute("members", members);
            req.setAttribute("departments", departments);
            req.setAttribute("totalCount", totalCount);
            req.setAttribute("currentPage", page);
            req.setAttribute("totalPages", totalPages);
            req.setAttribute("paramQuery", query);
            req.setAttribute("paramDept", department);
            req.setAttribute("paramType", type);

            req.getRequestDispatcher("/admin/members.jsp").forward(req, resp);
        } catch (DatabaseOperationException e) {
            req.setAttribute("errorMessage", "Database error: " + e.getMessage());
            req.getRequestDispatcher("/admin/members.jsp").forward(req, resp);
        }
    }

    private void showAddForm(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        try {
            req.setAttribute("departments", memberDAO.getDistinctDepartments());
            req.getRequestDispatcher("/admin/member-form.jsp").forward(req, resp);
        } catch (DatabaseOperationException ignored) {}
    }

    private void showEditForm(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException, DatabaseOperationException {
        int id = Integer.parseInt(req.getParameter("id"));
        Member member = memberDAO.findById(id);
        req.setAttribute("member", member);
        req.setAttribute("departments", memberDAO.getDistinctDepartments());
        req.getRequestDispatcher("/admin/member-form.jsp").forward(req, resp);
    }

    private void saveMember(HttpServletRequest req, HttpServletResponse resp) throws Exception {
        Member m = extractMemberFromRequest(req);
        boolean saved = memberDAO.create(m);
        if (saved) {
            // Also create a student user account if requested or default
            String createAccount = req.getParameter("createAccount");
            if ("yes".equalsIgnoreCase(createAccount) || "on".equalsIgnoreCase(createAccount)) {
                String username = req.getParameter("username");
                if (username == null || username.trim().isEmpty()) {
                    username = m.getMemberId().toLowerCase().replace("-", "_");
                }
                User u = new User();
                u.setUsername(username.trim());
                u.setEmail(m.getEmail());
                u.setPasswordHash("student123"); // default initial password
                u.setRole(m instanceof Faculty ? User.Role.FACULTY : User.Role.STUDENT);
                u.setMemberId(m.getMemberId());
                u.setStatus("ACTIVE");
                userDAO.createUser(u);
            }
            resp.sendRedirect(req.getContextPath() + "/admin/members?success=Member '" + m.getName() + "' registered successfully!");
        } else {
            resp.sendRedirect(req.getContextPath() + "/admin/members?error=Failed to register member.");
        }
    }

    private void updateMember(HttpServletRequest req, HttpServletResponse resp) throws Exception {
        Member m = extractMemberFromRequest(req);
        m.setId(Integer.parseInt(req.getParameter("id")));
        memberDAO.update(m);
        resp.sendRedirect(req.getContextPath() + "/admin/members?success=Member updated successfully!");
    }

    private void deleteMember(HttpServletRequest req, HttpServletResponse resp) throws IOException, DatabaseOperationException {
        int id = Integer.parseInt(req.getParameter("id"));
        boolean deleted = memberDAO.delete(id);
        if (deleted) {
            resp.sendRedirect(req.getContextPath() + "/admin/members?success=Member removed successfully.");
        } else {
            resp.sendRedirect(req.getContextPath() + "/admin/members?error=Cannot delete member with active transactions.");
        }
    }

    private Member extractMemberFromRequest(HttpServletRequest req) {
        String typeStr = req.getParameter("memberType");
        Member.MemberType type = "FACULTY".equalsIgnoreCase(typeStr) ? Member.MemberType.FACULTY : Member.MemberType.STUDENT;

        Member m;
        if (type == Member.MemberType.FACULTY) {
            Faculty f = new Faculty();
            f.setDesignation(req.getParameter("yearOrDesignation"));
            m = f;
        } else {
            Student s = new Student();
            s.setYear(req.getParameter("yearOrDesignation"));
            m = s;
        }

        m.setMemberId(req.getParameter("memberId"));
        m.setName(req.getParameter("name"));
        m.setEmail(req.getParameter("email"));
        m.setPhone(req.getParameter("phone"));
        m.setDepartment(req.getParameter("department"));
        m.setMemberType(type);
        try {
            m.setMaxBorrowLimit(Integer.parseInt(req.getParameter("maxBorrowLimit")));
        } catch (Exception ignored) {
            m.setMaxBorrowLimit(type == Member.MemberType.FACULTY ? 8 : 4);
        }
        m.setRegistrationDate(LocalDate.now());
        m.setStatus(req.getParameter("status") != null ? req.getParameter("status") : "ACTIVE");
        return m;
    }
}
