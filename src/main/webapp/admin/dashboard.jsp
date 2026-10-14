<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="pageTitle" value="Admin Dashboard - DLMS" />
<c:set var="activePage" value="dashboard" />
<jsp:include page="/includes/header.jsp" />

<div class="dashboard-wrapper">
    <!-- Admin Sidebar -->
    <jsp:include page="/includes/admin-sidebar.jsp" />

    <!-- Main Content Area -->
    <main class="main-content">
        <!-- Top Navbar -->
        <jsp:include page="/includes/navbar.jsp" />

        <!-- Welcome Banner & Quick Action Buttons -->
        <div class="d-flex flex-column flex-md-row justify-content-between align-items-md-center gap-3 mb-4">
            <div>
                <h2 class="fw-bold mb-1">Administrative Overview</h2>
                <p class="text-muted small mb-0">Real-time catalog analytics, patron circulation status, and inventory metrics.</p>
            </div>
            <div class="d-flex flex-wrap gap-2">
                <a href="${pageContext.request.contextPath}/admin/issue" class="btn btn-gradient-primary">
                    <i class="bi bi-arrow-up-right-circle"></i> Issue Book
                </a>
                <a href="${pageContext.request.contextPath}/admin/return" class="btn btn-navy">
                    <i class="bi bi-arrow-down-left-circle"></i> Return Book
                </a>
                <a href="${pageContext.request.contextPath}/admin/books?action=new" class="btn btn-outline-custom">
                    <i class="bi bi-plus-lg"></i> Add Book
                </a>
            </div>
        </div>

        <!-- 6 Live Database Statistic Cards -->
        <div class="row g-3 mb-4">
            <!-- Total Books -->
            <div class="col-sm-6 col-xl-2">
                <div class="stat-card">
                    <div class="d-flex align-items-center justify-content-between mb-2">
                        <span class="text-muted small fw-semibold">Total Books</span>
                        <div class="stat-icon-wrapper bg-primary-subtle text-primary">
                            <i class="bi bi-book"></i>
                        </div>
                    </div>
                    <div class="stat-val text-primary animated-counter" data-target="${stats.totalBooks != null ? stats.totalBooks : 0}">${stats.totalBooks}</div>
                    <div class="small text-muted"><i class="bi bi-arrow-up-short text-success"></i> Across all shelves</div>
                </div>
            </div>

            <!-- Available Copies -->
            <div class="col-sm-6 col-xl-2">
                <div class="stat-card">
                    <div class="d-flex align-items-center justify-content-between mb-2">
                        <span class="text-muted small fw-semibold">Available</span>
                        <div class="stat-icon-wrapper bg-success-subtle text-success">
                            <i class="bi bi-check2-circle"></i>
                        </div>
                    </div>
                    <div class="stat-val text-success animated-counter" data-target="${stats.availableBooks != null ? stats.availableBooks : 0}">${stats.availableBooks}</div>
                    <div class="small text-success fw-medium">Ready to issue</div>
                </div>
            </div>

            <!-- Issued Copies -->
            <div class="col-sm-6 col-xl-2">
                <div class="stat-card">
                    <div class="d-flex align-items-center justify-content-between mb-2">
                        <span class="text-muted small fw-semibold">Issued</span>
                        <div class="stat-icon-wrapper bg-info-subtle text-info">
                            <i class="bi bi-box-arrow-up-right"></i>
                        </div>
                    </div>
                    <div class="stat-val text-info animated-counter" data-target="${stats.issuedBooks != null ? stats.issuedBooks : 0}">${stats.issuedBooks}</div>
                    <div class="small text-muted">Currently on loan</div>
                </div>
            </div>

            <!-- Total Members -->
            <div class="col-sm-6 col-xl-2">
                <div class="stat-card">
                    <div class="d-flex align-items-center justify-content-between mb-2">
                        <span class="text-muted small fw-semibold">Active Members</span>
                        <div class="stat-icon-wrapper bg-secondary-subtle text-secondary">
                            <i class="bi bi-people"></i>
                        </div>
                    </div>
                    <div class="stat-val text-dark animated-counter" data-target="${stats.totalMembers != null ? stats.totalMembers : 0}">${stats.totalMembers}</div>
                    <div class="small text-muted">Students & Faculty</div>
                </div>
            </div>

            <!-- Overdue Books -->
            <div class="col-sm-6 col-xl-2">
                <div class="stat-card">
                    <div class="d-flex align-items-center justify-content-between mb-2">
                        <span class="text-muted small fw-semibold">Overdue Loans</span>
                        <div class="stat-icon-wrapper bg-danger-subtle text-danger">
                            <i class="bi bi-clock-history"></i>
                        </div>
                    </div>
                    <div class="stat-val text-danger animated-counter" data-target="${stats.overdueBooks != null ? stats.overdueBooks : 0}">${stats.overdueBooks}</div>
                    <div class="small text-danger fw-semibold">Past due date</div>
                </div>
            </div>

            <!-- Overdue Fines Total -->
            <div class="col-sm-6 col-xl-2">
                <div class="stat-card">
                    <div class="d-flex align-items-center justify-content-between mb-2">
                        <span class="text-muted small fw-semibold">Pending Fines</span>
                        <div class="stat-icon-wrapper bg-warning-subtle text-warning">
                            <i class="bi bi-currency-rupee"></i>
                        </div>
                    </div>
                    <div class="stat-val text-warning animated-counter is-currency" data-target="${stats.unpaidFines != null ? stats.unpaidFines : 0}">₹${stats.unpaidFines}</div>
                    <div class="small text-muted">Uncollected dues</div>
                </div>
            </div>
        </div>

        <!-- Charts Row 1: Books Overview (Doughnut) & Monthly Transactions (Line) -->
        <div class="row g-4 mb-4">
            <div class="col-lg-5">
                <div class="glass-card p-4 h-100">
                    <div class="d-flex align-items-center justify-content-between mb-3">
                        <h5 class="fw-bold mb-0"><i class="bi bi-pie-chart text-primary me-2"></i>Books Overview</h5>
                        <span class="badge bg-light text-dark border">Real-time</span>
                    </div>
                    <div style="height: 280px; position: relative;">
                        <canvas id="booksOverviewChart"></canvas>
                    </div>
                </div>
            </div>

            <div class="col-lg-7">
                <div class="glass-card p-4 h-100">
                    <div class="d-flex align-items-center justify-content-between mb-3">
                        <h5 class="fw-bold mb-0"><i class="bi bi-graph-up text-cyan me-2"></i>Monthly Transactions Volume</h5>
                        <span class="badge badge-soft-info">Past 6 Months</span>
                    </div>
                    <div style="height: 280px; position: relative;">
                        <canvas id="transactionsTrendChart"></canvas>
                    </div>
                </div>
            </div>
        </div>

        <!-- Charts Row 2: Popular Categories & Fines Collection -->
        <div class="row g-4 mb-4">
            <div class="col-lg-7">
                <div class="glass-card p-4 h-100">
                    <div class="d-flex align-items-center justify-content-between mb-3">
                        <h5 class="fw-bold mb-0"><i class="bi bi-bar-chart-fill text-primary me-2"></i>Popular Subject Categories</h5>
                        <span class="badge bg-light text-dark border">Catalog Spread</span>
                    </div>
                    <div style="height: 260px; position: relative;">
                        <canvas id="categoriesChart"></canvas>
                    </div>
                </div>
            </div>

            <div class="col-lg-5">
                <div class="glass-card p-4 h-100">
                    <div class="d-flex align-items-center justify-content-between mb-3">
                        <h5 class="fw-bold mb-0"><i class="bi bi-cash-stack text-success me-2"></i>Fines Collection Audit</h5>
                        <span class="badge badge-soft-warning">Revenue vs Dues</span>
                    </div>
                    <div style="height: 260px; position: relative;">
                        <canvas id="finesChart"></canvas>
                    </div>
                </div>
            </div>
        </div>

        <!-- Recent Circulation Activities Table (LIFO Stack Demonstration) -->
        <div class="glass-card p-4 mb-4">
            <div class="d-flex align-items-center justify-content-between mb-3">
                <div>
                    <h5 class="fw-bold mb-0"><i class="bi bi-activity text-primary me-2"></i>Recent Circulation Activity</h5>
                    <small class="text-muted">Demonstrates Java LIFO Stack data structure for recent action tracking</small>
                </div>
                <a href="${pageContext.request.contextPath}/admin/transactions" class="btn btn-sm btn-outline-custom">View All Records</a>
            </div>

            <div class="table-responsive">
                <table class="table-custom">
                    <thead>
                        <tr>
                            <th>Tx ID</th>
                            <th>Patron</th>
                            <th>Book Title</th>
                            <th>Issue Date</th>
                            <th>Due Date</th>
                            <th>Status</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:choose>
                            <c:when test="${not empty recentActivities}">
                                <c:forEach var="tx" items="${recentActivities}">
                                    <tr>
                                        <td><span class="font-monospace fw-semibold text-primary">${tx.transactionId}</span></td>
                                        <td>
                                            <div class="fw-semibold">${tx.memberName != null ? tx.memberName : tx.memberId}</div>
                                            <small class="text-muted font-monospace">${tx.memberId}</small>
                                        </td>
                                        <td>
                                            <div class="d-flex align-items-center gap-2">
                                                <c:if test="${not empty tx.bookCoverUrl}">
                                                    <img src="${tx.bookCoverUrl}" alt="cover" class="book-thumb">
                                                </c:if>
                                                <div>
                                                    <div class="fw-medium text-truncate" style="max-width: 240px;">${tx.bookTitle != null ? tx.bookTitle : tx.bookId}</div>
                                                    <small class="text-muted font-monospace">${tx.bookId}</small>
                                                </div>
                                            </div>
                                        </td>
                                        <td>${tx.formattedIssueDate}</td>
                                        <td>
                                            <span class="${tx.overdue ? 'text-danger fw-bold' : ''}">
                                                ${tx.formattedDueDate}
                                                <c:if test="${tx.overdue}">
                                                    <span class="badge badge-soft-danger ms-1">Overdue</span>
                                                </c:if>
                                            </span>
                                        </td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${tx.status == 'RETURNED'}">
                                                    <span class="badge badge-soft-success">RETURNED</span>
                                                </c:when>
                                                <c:when test="${tx.status == 'OVERDUE' || tx.overdue}">
                                                    <span class="badge badge-soft-danger">OVERDUE</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="badge badge-soft-info">ISSUED</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td>
                                            <c:if test="${tx.status != 'RETURNED'}">
                                                <a href="${pageContext.request.contextPath}/admin/return?txId=${tx.transactionId}" class="btn btn-sm btn-outline-custom py-1 px-2" title="Return Book">
                                                    <i class="bi bi-arrow-down-left-circle me-1"></i> Return
                                                </a>
                                            </c:if>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <tr>
                                    <td colspan="7">
                                        <div class="empty-state">
                                            <i class="bi bi-inbox empty-state-icon"></i>
                                            <div class="fw-bold">No Circulation Records Found</div>
                                            <p class="text-muted small">Begin by issuing books to library patrons.</p>
                                        </div>
                                    </td>
                                </tr>
                            </c:otherwise>
                        </c:choose>
                    </tbody>
                </table>
            </div>
        </div>
    </main>
</div>

<!-- Chart.js Dynamic Loader Script -->
<script src="${pageContext.request.contextPath}/assets/js/admin-dashboard.js"></script>

<jsp:include page="/includes/footer.jsp" />
