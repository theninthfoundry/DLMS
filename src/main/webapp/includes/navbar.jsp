<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<div class="top-navbar">
    <div class="d-flex align-items-center gap-3">
        <!-- Mobile Sidebar Toggle -->
        <button id="sidebarToggleBtn" class="btn btn-sm btn-outline-custom d-lg-none" type="button" aria-label="Toggle Sidebar">
            <i class="bi bi-list fs-5"></i>
        </button>

        <!-- Quick Search -->
        <form class="d-none d-md-flex align-items-center" action="${sessionScope.currentUser.admin ? pageContext.request.contextPath.concat('/admin/books') : pageContext.request.contextPath.concat('/student/browse')}" method="GET">
            <div class="search-input-group">
                <i class="bi bi-search"></i>
                <input type="text" name="q" class="form-control" placeholder="Search catalog by title, author, ISBN..." aria-label="Search">
            </div>
        </form>
    </div>

    <!-- Actions & Profile -->
    <div class="d-flex align-items-center gap-3">
        <!-- Theme Toggle Button -->
        <button id="themeToggleBtn" class="btn btn-sm btn-outline-custom rounded-circle p-2" type="button" title="Toggle Light/Dark Theme" style="width: 40px; height: 40px;">
            <i id="themeToggleIcon" class="bi bi-moon-stars-fill"></i>
        </button>

        <!-- User Profile Dropdown -->
        <div class="dropdown">
            <button class="btn btn-sm btn-outline-custom d-flex align-items-center gap-2 py-1 px-2 border-0" type="button" data-bs-toggle="dropdown" aria-expanded="false">
                <div class="rounded-circle bg-primary text-white d-flex align-items-center justify-content-center fw-bold" style="width: 36px; height: 36px;">
                    ${sessionScope.currentUser != null ? sessionScope.currentUser.username.substring(0, 1).toUpperCase() : "U"}
                </div>
                <div class="d-none d-sm-block text-start leading-tight">
                    <div class="fw-bold fs-7">${sessionScope.currentUser != null ? sessionScope.currentUser.username : "Guest"}</div>
                    <small class="text-muted" style="font-size: 0.75rem;">${sessionScope.currentUser != null ? sessionScope.currentUser.role : "Patron"}</small>
                </div>
                <i class="bi bi-chevron-down fs-8 text-muted ms-1"></i>
            </button>
            <ul class="dropdown-menu dropdown-menu-end shadow-lg border-0 rounded-3">
                <c:choose>
                    <c:when test="${sessionScope.currentUser.admin}">
                        <li><a class="dropdown-item py-2" href="${pageContext.request.contextPath}/admin/dashboard"><i class="bi bi-speedometer2 me-2 text-primary"></i>Admin Dashboard</a></li>
                        <li><a class="dropdown-item py-2" href="${pageContext.request.contextPath}/admin/reports"><i class="bi bi-file-earmark-bar-graph me-2 text-info"></i>Library Reports</a></li>
                    </c:when>
                    <c:otherwise>
                        <li><a class="dropdown-item py-2" href="${pageContext.request.contextPath}/student/profile"><i class="bi bi-person me-2 text-primary"></i>My Profile</a></li>
                        <li><a class="dropdown-item py-2" href="${pageContext.request.contextPath}/student/my-books"><i class="bi bi-book me-2 text-success"></i>Borrowed Books</a></li>
                    </c:otherwise>
                </c:choose>
                <li><hr class="dropdown-divider"></li>
                <li><a class="dropdown-item py-2 text-danger" href="${pageContext.request.contextPath}/logout"><i class="bi bi-box-arrow-right me-2"></i>Sign Out</a></li>
            </ul>
        </div>
    </div>
</div>
