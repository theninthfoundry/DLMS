<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="pageTitle" value="Reports & Analytics - DLMS" />
<c:set var="activePage" value="reports" />
<jsp:include page="/includes/header.jsp" />

<div class="dashboard-wrapper">
    <jsp:include page="/includes/admin-sidebar.jsp" />

    <main class="main-content">
        <jsp:include page="/includes/navbar.jsp" />

        <div class="d-flex flex-column flex-md-row justify-content-between align-items-md-center gap-3 mb-4">
            <div>
                <h2 class="fw-bold mb-1">Library Reports & Analytical Audits</h2>
                <p class="text-muted small mb-0">Generate statistical summaries, export tabular datasets, and produce printable reports.</p>
            </div>
            <div class="d-flex flex-wrap gap-2">
                <button type="button" class="btn btn-outline-custom" onclick="window.print()">
                    <i class="bi bi-printer me-1"></i> Print Report
                </button>
                <div class="dropdown">
                    <button class="btn btn-gradient-primary dropdown-toggle" type="button" data-bs-toggle="dropdown">
                        <i class="bi bi-download me-1"></i> Export Data CSV
                    </button>
                    <ul class="dropdown-menu dropdown-menu-end shadow-lg border-0 rounded-3">
                        <li><a class="dropdown-item py-2" href="${pageContext.request.contextPath}/admin/export?type=books"><i class="bi bi-book me-2 text-primary"></i>Export Books Catalog (CSV)</a></li>
                        <li><a class="dropdown-item py-2" href="${pageContext.request.contextPath}/admin/export?type=members"><i class="bi bi-people me-2 text-success"></i>Export Members Directory (CSV)</a></li>
                        <li><a class="dropdown-item py-2" href="${pageContext.request.contextPath}/admin/export?type=transactions"><i class="bi bi-arrow-left-right me-2 text-info"></i>Export Transactions History (CSV)</a></li>
                        <li><a class="dropdown-item py-2" href="${pageContext.request.contextPath}/admin/export?type=fines"><i class="bi bi-currency-rupee me-2 text-warning"></i>Export Fines Ledger (CSV)</a></li>
                    </ul>
                </div>
            </div>
        </div>

        <!-- Analytical Metrics Grid -->
        <div class="row g-3 mb-4">
            <div class="col-md-3">
                <div class="stat-card">
                    <small class="text-muted fw-semibold d-block mb-1">Total Volumes</small>
                    <div class="fs-2 fw-extrabold text-primary">${summary.totalBooks}</div>
                    <small class="text-muted">Total physical inventory</small>
                </div>
            </div>
            <div class="col-md-3">
                <div class="stat-card">
                    <small class="text-muted fw-semibold d-block mb-1">Active Loans</small>
                    <div class="fs-2 fw-extrabold text-info">${summary.issuedBooks}</div>
                    <small class="text-muted">Volumes currently issued</small>
                </div>
            </div>
            <div class="col-md-3">
                <div class="stat-card">
                    <small class="text-muted fw-semibold d-block mb-1">Overdue Loans</small>
                    <div class="fs-2 fw-extrabold text-danger">${summary.overdueBooks}</div>
                    <small class="text-danger fw-semibold">Past borrowing window</small>
                </div>
            </div>
            <div class="col-md-3">
                <div class="stat-card">
                    <small class="text-muted fw-semibold d-block mb-1">Fine Collected</small>
                    <div class="fs-2 fw-extrabold text-success">₹${summary.paidFines}</div>
                    <small class="text-muted">₹${summary.unpaidFines} pending recovery</small>
                </div>
            </div>
        </div>

        <!-- Comprehensive Report Breakdown Cards -->
        <div class="row g-4 mb-4">
            <div class="col-lg-6">
                <div class="glass-card p-4 h-100">
                    <h5 class="fw-bold mb-3"><i class="bi bi-shield-check text-primary me-2"></i>Catalog Health & Utilization</h5>
                    <table class="table table-borderless small mb-0">
                        <tbody>
                            <tr class="border-bottom">
                                <td class="text-muted py-2">Catalog Utilization Rate:</td>
                                <td class="text-end fw-bold py-2">
                                    ${summary.utilizationRate != null ? summary.utilizationRate : 0}%
                                </td>
                            </tr>
                            <tr class="border-bottom">
                                <td class="text-muted py-2">Available Shelf Ratio:</td>
                                <td class="text-end fw-bold py-2">
                                    ${summary.availableRatio != null ? summary.availableRatio : 0}%
                                </td>
                            </tr>
                            <tr class="border-bottom">
                                <td class="text-muted py-2">Registered Patrons:</td>
                                <td class="text-end fw-bold py-2">${summary.totalMembers} Members</td>
                            </tr>
                            <tr>
                                <td class="text-muted py-2">Active Waitlist Requests:</td>
                                <td class="text-end fw-bold text-warning py-2">${summary.pendingReservations} Patrons</td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </div>

            <div class="col-lg-6">
                <div class="glass-card p-4 h-100">
                    <h5 class="fw-bold mb-3"><i class="bi bi-file-earmark-spreadsheet text-success me-2"></i>Dataset Quick Export</h5>
                    <p class="text-muted small mb-3">Download complete tabular CSV archives directly compatible with Excel, Google Sheets, and audit databases.</p>
                    <div class="d-flex flex-column gap-2">
                        <a href="${pageContext.request.contextPath}/admin/export?type=books" class="btn btn-sm btn-outline-custom text-start py-2">
                            <i class="bi bi-filetype-csv text-primary me-2 fs-5"></i> <strong>Books Catalog Dataset</strong>
                            <span class="float-end text-muted small">Download CSV</span>
                        </a>
                        <a href="${pageContext.request.contextPath}/admin/export?type=transactions" class="btn btn-sm btn-outline-custom text-start py-2">
                            <i class="bi bi-filetype-csv text-info me-2 fs-5"></i> <strong>Circulation Transactions Audit</strong>
                            <span class="float-end text-muted small">Download CSV</span>
                        </a>
                        <a href="${pageContext.request.contextPath}/admin/export?type=fines" class="btn btn-sm btn-outline-custom text-start py-2">
                            <i class="bi bi-filetype-csv text-warning me-2 fs-5"></i> <strong>Fines & Overdue Revenue Audit</strong>
                            <span class="float-end text-muted small">Download CSV</span>
                        </a>
                    </div>
                </div>
            </div>
        </div>
    </main>
</div>

<jsp:include page="/includes/footer.jsp" />
