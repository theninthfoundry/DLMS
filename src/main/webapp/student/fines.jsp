<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="pageTitle" value="My Fines & Dues - DLMS" />
<c:set var="activePage" value="fines" />
<jsp:include page="/includes/header.jsp" />

<div class="dashboard-wrapper">
    <jsp:include page="/includes/student-sidebar.jsp" />

    <main class="main-content">
        <jsp:include page="/includes/navbar.jsp" />

        <div class="d-flex flex-column flex-md-row justify-content-between align-items-md-center gap-3 mb-4">
            <div>
                <h2 class="fw-bold mb-1">My Fines & Overdue Penalties</h2>
                <p class="text-muted small mb-0">Review assessed late return charges and payment reconciliation history.</p>
            </div>
            <div class="p-3 rounded-3 bg-white border shadow-sm text-end">
                <small class="text-muted d-block fw-semibold">Outstanding Balance</small>
                <div class="fs-4 fw-extrabold text-danger">₹${totalUnpaid != null ? totalUnpaid : '0.00'}</div>
            </div>
        </div>

        <div class="glass-card p-0 mb-4 overflow-hidden">
            <div class="table-responsive">
                <table class="table-custom">
                    <thead>
                        <tr>
                            <th>Fine ID</th>
                            <th>Transaction ID</th>
                            <th>Book Volume</th>
                            <th>Days Late</th>
                            <th>Amount</th>
                            <th>Status</th>
                            <th>Payment Date</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:choose>
                            <c:when test="${not empty fines}">
                                <c:forEach var="f" items="${fines}">
                                    <tr>
                                        <td><span class="font-monospace fw-semibold text-danger">${f.fineId}</span></td>
                                        <td><span class="font-monospace text-muted small">${f.transactionId}</span></td>
                                        <td><div class="fw-bold text-dark text-truncate" style="max-width: 240px;">${f.bookTitle}</div></td>
                                        <td><span class="text-danger fw-semibold">${f.daysLate} Days</span></td>
                                        <td><strong class="fs-6 text-dark">₹${f.amount}</strong></td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${f.paid}">
                                                    <span class="badge badge-soft-success">PAID (${f.paymentMode})</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="badge badge-soft-danger">UNPAID DUES</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td><small class="text-muted">${f.paidAt != null ? f.paidAt : "-"}</small></td>
                                    </tr>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <tr>
                                    <td colspan="7">
                                        <div class="empty-state">
                                            <i class="bi bi-shield-check empty-state-icon text-success"></i>
                                            <div class="fw-bold">No Fines On Record</div>
                                            <p class="text-muted small">You have zero outstanding dues or historical late penalties. Excellent!</p>
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
