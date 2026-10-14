<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="pageTitle" value="Student Portal - DLMS" />
<c:set var="activePage" value="dashboard" />
<jsp:include page="/includes/header.jsp" />

<div class="dashboard-wrapper">
    <jsp:include page="/includes/student-sidebar.jsp" />

    <main class="main-content">
        <jsp:include page="/includes/navbar.jsp" />

        <!-- Student Welcome Hero Card -->
        <div class="glass-card p-4 p-md-5 mb-4 position-relative overflow-hidden" style="background: linear-gradient(135deg, #1E3A8A 0%, #0F172A 100%); color: #FFFFFF;">
            <div class="row align-items-center">
                <div class="col-md-8">
                    <span class="badge badge-soft-info mb-2 text-white">Student Portal • ${member != null ? member.roleDescription : 'Patron'}</span>
                    <h2 class="fw-bold mb-2">Welcome Back, ${member != null ? member.name : sessionScope.currentUser.username}!</h2>
                    <p class="text-white-50 mb-3 small">
                        Department: <strong>${member != null ? member.department : "Engineering"}</strong> • ID: <code>${member != null ? member.memberId : "N/A"}</code>
                    </p>
                    <div class="d-flex flex-wrap gap-2">
                        <a href="${pageContext.request.contextPath}/student/browse" class="btn btn-gradient-primary btn-sm px-3 py-2">
                            <i class="bi bi-search me-1"></i> Browse Catalog
                        </a>
                        <a href="${pageContext.request.contextPath}/student/my-books" class="btn btn-outline-light btn-sm px-3 py-2">
                            <i class="bi bi-book me-1"></i> My Borrowed Books
                        </a>
                    </div>
                </div>
                <div class="col-md-4 text-center d-none d-md-block">
                    <div class="rounded-circle bg-primary-subtle text-primary d-inline-flex align-items-center justify-content-center p-4 shadow-lg" style="width: 100px; height: 100px;">
                        <i class="bi bi-mortarboard-fill display-5"></i>
                    </div>
                </div>
            </div>
        </div>

        <!-- Metric Stat Cards -->
        <div class="row g-3 mb-4">
            <div class="col-sm-6 col-xl-3">
                <div class="stat-card">
                    <div class="d-flex align-items-center justify-content-between mb-2">
                        <span class="text-muted small fw-semibold">Currently Borrowed</span>
                        <div class="stat-icon-wrapper bg-primary-subtle text-primary">
                            <i class="bi bi-book"></i>
                        </div>
                    </div>
                    <div class="stat-val text-primary">${activeLoans != null ? activeLoans.size() : 0}</div>
                    <div class="small text-muted">Quota: ${member != null ? member.maxBorrowLimit : 4} volumes max</div>
                </div>
            </div>

            <div class="col-sm-6 col-xl-3">
                <div class="stat-card">
                    <div class="d-flex align-items-center justify-content-between mb-2">
                        <span class="text-muted small fw-semibold">Overdue Books</span>
                        <div class="stat-icon-wrapper bg-danger-subtle text-danger">
                            <i class="bi bi-exclamation-triangle"></i>
                        </div>
                    </div>
                    <div class="stat-val ${overdueCount > 0 ? 'text-danger' : 'text-success'}">${overdueCount}</div>
                    <div class="small ${overdueCount > 0 ? 'text-danger fw-bold' : 'text-success'}">
                        ${overdueCount > 0 ? "Immediate return required" : "No overdue books"}
                    </div>
                </div>
            </div>

            <div class="col-sm-6 col-xl-3">
                <div class="stat-card">
                    <div class="d-flex align-items-center justify-content-between mb-2">
                        <span class="text-muted small fw-semibold">Pending Fines</span>
                        <div class="stat-icon-wrapper bg-warning-subtle text-warning">
                            <i class="bi bi-currency-rupee"></i>
                        </div>
                    </div>
                    <div class="stat-val text-warning">₹${unpaidFines != null ? unpaidFines : '0.00'}</div>
                    <div class="small text-muted">Overdue penalties due</div>
                </div>
            </div>

            <div class="col-sm-6 col-xl-3">
                <div class="stat-card">
                    <div class="d-flex align-items-center justify-content-between mb-2">
                        <span class="text-muted small fw-semibold">Active Waitlists</span>
                        <div class="stat-icon-wrapper bg-info-subtle text-info">
                            <i class="bi bi-bookmark-check"></i>
                        </div>
                    </div>
                    <div class="stat-val text-info">${reservations != null ? reservations.size() : 0}</div>
                    <div class="small text-muted">Queued for available copy</div>
                </div>
            </div>
        </div>

        <!-- Currently Borrowed Books Section -->
        <div class="glass-card p-4 mb-4">
            <div class="d-flex justify-content-between align-items-center mb-3">
                <div>
                    <h5 class="fw-bold mb-0"><i class="bi bi-book-half text-primary me-2"></i>Books Currently on Loan</h5>
                    <small class="text-muted">Return on or before due date to avoid automated late penalties (₹5.00/day)</small>
                </div>
                <a href="${pageContext.request.contextPath}/student/my-books" class="btn btn-sm btn-outline-custom">View All</a>
            </div>

            <c:choose>
                <c:when test="${not empty activeLoans}">
                    <div class="row g-3">
                        <c:forEach var="tx" items="${activeLoans}">
                            <div class="col-md-6 col-xl-4">
                                <div class="p-3 rounded-3 border bg-light h-100 d-flex flex-column">
                                    <div class="d-flex gap-3 align-items-center mb-2">
                                        <c:if test="${not empty tx.bookCoverUrl}">
                                            <img src="${tx.bookCoverUrl}" alt="cover" class="book-thumb">
                                        </c:if>
                                        <div>
                                            <h6 class="fw-bold mb-0 text-truncate" style="max-width: 200px;" title="${tx.bookTitle}">${tx.bookTitle}</h6>
                                            <small class="text-muted font-monospace">${tx.bookId}</small>
                                        </div>
                                    </div>
                                    <div class="mt-auto pt-2 border-top small d-flex justify-content-between align-items-center">
                                        <div>
                                            <span class="text-muted d-block" style="font-size: 0.75rem;">Due Date:</span>
                                            <strong class="${tx.overdue ? 'text-danger' : 'text-dark'}">${tx.formattedDueDate}</strong>
                                        </div>
                                        <c:choose>
                                            <c:when test="${tx.overdue}">
                                                <span class="badge badge-soft-danger">${tx.daysOverdue} Days Late</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="badge badge-soft-success">On Loan</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="empty-state py-4">
                        <i class="bi bi-book empty-state-icon"></i>
                        <div class="fw-bold">No Active Loans</div>
                        <p class="text-muted small">You currently have no borrowed books. Explore our catalog to request titles.</p>
                        <a href="${pageContext.request.contextPath}/student/browse" class="btn btn-sm btn-gradient-primary">
                            <i class="bi bi-search me-1"></i> Browse Library Catalog
                        </a>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>

        <!-- Recommended Library Titles -->
        <div class="glass-card p-4 mb-4">
            <h5 class="fw-bold mb-3"><i class="bi bi-stars text-warning me-2"></i>Recommended Academic Titles</h5>
            <div class="row g-3">
                <c:forEach var="book" items="${recommendedBooks}">
                    <div class="col-sm-6 col-lg-3">
                        <div class="card h-100 border rounded-3 overflow-hidden shadow-sm">
                            <img src="${book.coverUrl}" alt="${book.title}" style="height: 150px; object-fit: cover;">
                            <div class="p-3 d-flex flex-column flex-grow-1">
                                <span class="badge badge-soft-info mb-1 small text-truncate">${book.category}</span>
                                <h6 class="fw-bold mb-1 text-truncate" title="${book.title}">${book.title}</h6>
                                <small class="text-muted text-truncate mb-2">${book.author}</small>
                                <div class="mt-auto">
                                    <a href="${pageContext.request.contextPath}/student/browse?q=${book.title}" class="btn btn-sm btn-outline-custom w-100">
                                        View Details
                                    </a>
                                </div>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </div>
    </main>
</div>

<jsp:include page="/includes/footer.jsp" />
