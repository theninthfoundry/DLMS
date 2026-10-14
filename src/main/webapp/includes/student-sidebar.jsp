<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<aside class="sidebar">
    <div class="sidebar-header">
        <div class="rounded-3 p-2 d-flex align-items-center justify-content-center" style="background: var(--dlms-gradient-primary); width: 40px; height: 40px;">
            <i class="bi bi-mortarboard-fill text-white fs-4"></i>
        </div>
        <div>
            <div class="fw-bold text-white fs-6" style="letter-spacing: -0.01em;">DLMS PORTAL</div>
            <small class="text-info fw-medium" style="font-size: 0.72rem; letter-spacing: 0.05em;">STUDENT & FACULTY</small>
        </div>
    </div>

    <ul class="sidebar-menu">
        <li class="sidebar-item">
            <a href="${pageContext.request.contextPath}/student/dashboard" class="sidebar-link ${activePage == 'dashboard' ? 'active' : ''}">
                <i class="bi bi-grid-1x2-fill"></i>
                <span>My Dashboard</span>
            </a>
        </li>
        <li class="sidebar-item">
            <a href="${pageContext.request.contextPath}/student/browse" class="sidebar-link ${activePage == 'browse' ? 'active' : ''}">
                <i class="bi bi-search"></i>
                <span>Browse Catalogue</span>
            </a>
        </li>
        <li class="sidebar-item">
            <a href="${pageContext.request.contextPath}/student/my-books" class="sidebar-link ${activePage == 'my-books' ? 'active' : ''}">
                <i class="bi bi-book"></i>
                <span>Currently Borrowed</span>
            </a>
        </li>
        <li class="sidebar-item">
            <a href="${pageContext.request.contextPath}/student/reservations" class="sidebar-link ${activePage == 'reservations' ? 'active' : ''}">
                <i class="bi bi-bookmark-check"></i>
                <span>My Reservations</span>
            </a>
        </li>
        <li class="sidebar-item">
            <a href="${pageContext.request.contextPath}/student/fines" class="sidebar-link ${activePage == 'fines' ? 'active' : ''}">
                <i class="bi bi-currency-rupee"></i>
                <span>Fines & Dues</span>
            </a>
        </li>
        <li class="sidebar-item">
            <a href="${pageContext.request.contextPath}/student/history" class="sidebar-link ${activePage == 'history' ? 'active' : ''}">
                <i class="bi bi-clock-history"></i>
                <span>Borrowing History</span>
            </a>
        </li>
        <li class="sidebar-item">
            <a href="${pageContext.request.contextPath}/student/profile" class="sidebar-link ${activePage == 'profile' ? 'active' : ''}">
                <i class="bi bi-person-circle"></i>
                <span>Account Profile</span>
            </a>
        </li>
    </ul>

    <div class="sidebar-footer">
        <div class="p-2 rounded-3 mb-2" style="background: rgba(255, 255, 255, 0.05); font-size: 0.75rem;">
            <div class="text-white fw-bold mb-1"><i class="bi bi-code-slash text-info me-1"></i>PBL Team No: 1</div>
            <div class="text-muted">Aman • Jashwanth</div>
        </div>
        <a href="${pageContext.request.contextPath}/logout" class="sidebar-link text-danger">
            <i class="bi bi-box-arrow-left"></i>
            <span>Sign Out</span>
        </a>
    </div>
</aside>
