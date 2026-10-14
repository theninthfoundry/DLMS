<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<aside class="sidebar">
    <div class="sidebar-header">
        <div class="rounded-3 p-2 d-flex align-items-center justify-content-center" style="background: var(--dlms-gradient-primary); width: 40px; height: 40px;">
            <i class="bi bi-book-half text-white fs-4"></i>
        </div>
        <div>
            <div class="fw-bold text-white fs-6" style="letter-spacing: -0.01em;">DLMS PORTAL</div>
            <small class="text-info fw-medium" style="font-size: 0.72rem; letter-spacing: 0.05em;">ADMINISTRATION</small>
        </div>
    </div>

    <ul class="sidebar-menu">
        <li class="sidebar-item">
            <a href="${pageContext.request.contextPath}/admin/dashboard" class="sidebar-link ${activePage == 'dashboard' ? 'active' : ''}">
                <i class="bi bi-grid-1x2-fill"></i>
                <span>Dashboard</span>
            </a>
        </li>
        <li class="sidebar-item">
            <a href="${pageContext.request.contextPath}/admin/books" class="sidebar-link ${activePage == 'books' ? 'active' : ''}">
                <i class="bi bi-book"></i>
                <span>Book Management</span>
            </a>
        </li>
        <li class="sidebar-item">
            <a href="${pageContext.request.contextPath}/admin/members" class="sidebar-link ${activePage == 'members' ? 'active' : ''}">
                <i class="bi bi-people"></i>
                <span>Members Directory</span>
            </a>
        </li>
        <li class="sidebar-item">
            <a href="${pageContext.request.contextPath}/admin/issue" class="sidebar-link ${activePage == 'issue' ? 'active' : ''}">
                <i class="bi bi-arrow-up-right-circle"></i>
                <span>Issue Book</span>
            </a>
        </li>
        <li class="sidebar-item">
            <a href="${pageContext.request.contextPath}/admin/return" class="sidebar-link ${activePage == 'return' ? 'active' : ''}">
                <i class="bi bi-arrow-down-left-circle"></i>
                <span>Return Book</span>
            </a>
        </li>
        <li class="sidebar-item">
            <a href="${pageContext.request.contextPath}/admin/reservations" class="sidebar-link ${activePage == 'reservations' ? 'active' : ''}">
                <i class="bi bi-bookmark-check"></i>
                <span>Waitlist Reservations</span>
            </a>
        </li>
        <li class="sidebar-item">
            <a href="${pageContext.request.contextPath}/admin/fines" class="sidebar-link ${activePage == 'fines' ? 'active' : ''}">
                <i class="bi bi-currency-rupee"></i>
                <span>Overdue Fines</span>
            </a>
        </li>
        <li class="sidebar-item">
            <a href="${pageContext.request.contextPath}/admin/transactions" class="sidebar-link ${activePage == 'transactions' ? 'active' : ''}">
                <i class="bi bi-clock-history"></i>
                <span>Circulation History</span>
            </a>
        </li>
        <li class="sidebar-item">
            <a href="${pageContext.request.contextPath}/admin/reports" class="sidebar-link ${activePage == 'reports' ? 'active' : ''}">
                <i class="bi bi-bar-chart-line"></i>
                <span>Reports & Analytics</span>
            </a>
        </li>
    </ul>

    <div class="sidebar-footer">
        <div class="p-2 rounded-3 mb-2" style="background: rgba(255, 255, 255, 0.05); font-size: 0.75rem;">
            <div class="text-white fw-bold mb-1"><i class="bi bi-code-slash text-info me-1"></i>PBL Team No: 1</div>
            <div class="text-muted">Siddhartha • Aman • Jashwanth</div>
        </div>
        <a href="${pageContext.request.contextPath}/logout" class="sidebar-link text-danger">
            <i class="bi bi-box-arrow-left"></i>
            <span>Sign Out</span>
        </a>
    </div>
</aside>
