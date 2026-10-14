<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="pageTitle" value="Overdue Fines - DLMS" />
<c:set var="activePage" value="fines" />
<jsp:include page="/includes/header.jsp" />

<div class="dashboard-wrapper">
    <jsp:include page="/includes/admin-sidebar.jsp" />

    <main class="main-content">
        <jsp:include page="/includes/navbar.jsp" />

        <div class="d-flex flex-column flex-md-row justify-content-between align-items-md-center gap-3 mb-4">
            <div>
                <h2 class="fw-bold mb-1">Overdue Fines & Penalties</h2>
                <p class="text-muted small mb-0">Track outstanding late fines, process patron fee payments, and audit revenue collection.</p>
            </div>
            <div class="d-flex gap-2">
                <a href="${pageContext.request.contextPath}/admin/export?type=fines" class="btn btn-outline-custom">
                    <i class="bi bi-download me-1"></i> Export Fines CSV
                </a>
            </div>
        </div>

        <!-- Filter Toolbar -->
        <div class="glass-card p-3 mb-4">
            <form action="${pageContext.request.contextPath}/admin/fines" method="GET" class="row g-3 align-items-center">
                <div class="col-md-6">
                    <div class="search-input-group">
                        <i class="bi bi-search"></i>
                        <input type="text" name="q" class="form-control" placeholder="Search by Fine ID, Member, or Tx ID..." value="${paramQuery}">
                    </div>
                </div>
                <div class="col-md-3">
                    <select name="status" class="form-select">
                        <option value="ALL">All Payment Statuses</option>
                        <option value="UNPAID" ${paramStatus == 'UNPAID' ? 'selected' : ''}>Unpaid Dues</option>
                        <option value="PAID" ${paramStatus == 'PAID' ? 'selected' : ''}>Paid in Full</option>
                    </select>
                </div>
                <div class="col-md-3 d-flex gap-2 justify-content-end">
                    <button type="submit" class="btn btn-primary px-3">Filter</button>
                    <a href="${pageContext.request.contextPath}/admin/fines" class="btn btn-outline-custom" title="Reset">
                        <i class="bi bi-arrow-counterclockwise"></i>
                    </a>
                </div>
            </form>
        </div>

        <!-- Fines Table -->
        <div class="glass-card p-0 mb-4 overflow-hidden">
            <div class="table-responsive">
                <table class="table-custom">
                    <thead>
                        <tr>
                            <th>Fine ID</th>
                            <th>Transaction</th>
                            <th>Patron</th>
                            <th>Book Volume</th>
                            <th>Days Late</th>
                            <th>Fine Amount</th>
                            <th>Payment Mode</th>
                            <th>Status</th>
                            <th class="text-end">Action</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:choose>
                            <c:when test="${not empty fines}">
                                <c:forEach var="f" items="${fines}">
                                    <tr>
                                        <td><span class="font-monospace fw-semibold text-danger">${f.fineId}</span></td>
                                        <td><span class="font-monospace text-muted small">${f.transactionId}</span></td>
                                        <td>
                                            <div class="fw-bold">${f.memberName}</div>
                                            <small class="text-muted font-monospace">${f.memberId}</small>
                                        </td>
                                        <td><div class="text-truncate" style="max-width: 180px;" title="${f.bookTitle}">${f.bookTitle}</div></td>
                                        <td><span class="fw-semibold text-danger">${f.daysLate} Days</span></td>
                                        <td><strong class="fs-6 text-dark">₹${f.amount}</strong></td>
                                        <td><span class="badge bg-light text-dark border">${not empty f.paymentMode ? f.paymentMode : "-"}</span></td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${f.paid}">
                                                    <span class="badge badge-soft-success">PAID</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="badge badge-soft-danger">UNPAID</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td class="text-end">
                                            <c:if test="${!f.paid}">
                                                <button type="button" class="btn btn-sm btn-success py-1 px-2" data-bs-toggle="modal" data-bs-target="#payModal_${f.id}">
                                                    <i class="bi bi-cash me-1"></i> Pay Fine
                                                </button>

                                                <!-- Pay Fine Modal -->
                                                <div class="modal fade" id="payModal_${f.id}" tabindex="-1" aria-hidden="true">
                                                    <div class="modal-dialog modal-dialog-centered text-start">
                                                        <div class="modal-content border-0 shadow-lg rounded-4">
                                                            <div class="modal-header border-bottom">
                                                                <h5 class="modal-title fw-bold">Collect Fine Payment</h5>
                                                                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                                                            </div>
                                                            <form action="${pageContext.request.contextPath}/admin/fines" method="POST">
                                                                <input type="hidden" name="action" value="pay">
                                                                <input type="hidden" name="fineId" value="${f.fineId}">

                                                                <div class="modal-body p-4">
                                                                    <div class="p-3 rounded-3 bg-light mb-3 text-center">
                                                                        <small class="text-muted d-block">Amount Due</small>
                                                                        <div class="display-6 fw-extrabold text-danger">₹${f.amount}</div>
                                                                        <small class="text-muted">Patron: ${f.memberName} (${f.memberId})</small>
                                                                    </div>
                                                                    <div class="mb-3">
                                                                        <label class="form-label small fw-semibold">Payment Mode</label>
                                                                        <select name="paymentMode" class="form-select">
                                                                            <option value="UPI">UPI / QR Code</option>
                                                                            <option value="CASH">Cash Over-the-Counter</option>
                                                                            <option value="CARD">Debit / Credit Card</option>
                                                                            <option value="WAIVED">Waived by Librarian</option>
                                                                        </select>
                                                                    </div>
                                                                </div>
                                                                <div class="modal-footer border-top">
                                                                    <button type="button" class="btn btn-outline-custom" data-bs-dismiss="modal">Cancel</button>
                                                                    <button type="submit" class="btn btn-gradient-primary">
                                                                        <i class="bi bi-check-lg me-1"></i> Confirm & Mark Paid
                                                                    </button>
                                                                </div>
                                                            </form>
                                                        </div>
                                                    </div>
                                                </div>
                                            </c:if>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <tr>
                                    <td colspan="9">
                                        <div class="empty-state">
                                            <i class="bi bi-currency-rupee empty-state-icon"></i>
                                            <div class="fw-bold">No Overdue Fines Recorded</div>
                                            <p class="text-muted small">All returned books are settled with zero outstanding fines.</p>
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

<jsp:include page="/includes/footer.jsp" />
