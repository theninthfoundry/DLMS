<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="pageTitle" value="Return Book - DLMS" />
<c:set var="activePage" value="return" />
<jsp:include page="/includes/header.jsp" />

<div class="dashboard-wrapper">
    <jsp:include page="/includes/admin-sidebar.jsp" />

    <main class="main-content">
        <jsp:include page="/includes/navbar.jsp" />

        <div class="mb-4">
            <h2 class="fw-bold mb-1">Return & Check-in Book</h2>
            <p class="text-muted small mb-0">Record volume returns, recalculate overdue penalties, and replenish library inventory.</p>
        </div>

        <c:if test="${not empty errorMessage}">
            <div class="alert alert-danger py-2 px-3 rounded-3 small mb-4 d-flex align-items-center gap-2">
                <i class="bi bi-exclamation-octagon-fill fs-5"></i>
                <div>${errorMessage}</div>
            </div>
        </c:if>

        <div class="row">
            <div class="col-lg-8">
                <div class="glass-card p-4 mb-4">
                    <!-- Quick Select Active Loan -->
                    <form action="${pageContext.request.contextPath}/admin/return" method="GET" class="mb-4 pb-3 border-bottom">
                        <label class="form-label small fw-semibold">Select Issued Transaction to Return</label>
                        <div class="input-group">
                            <select name="txId" class="form-select" onchange="this.form.submit()">
                                <option value="">-- Choose Active Loan --</option>
                                <c:forEach var="tx" items="${activeLoans}">
                                    <option value="${tx.transactionId}" ${selectedTransaction != null && selectedTransaction.transactionId == tx.transactionId ? 'selected' : ''}>
                                        ${tx.transactionId} — ${tx.memberName} (${tx.bookTitle}) [Due: ${tx.formattedDueDate}]
                                    </option>
                                </c:forEach>
                            </select>
                            <button type="submit" class="btn btn-outline-custom">Load Details</button>
                        </div>
                    </form>

                    <!-- Transaction Inspection and Return Process -->
                    <c:choose>
                        <c:when test="${selectedTransaction != null}">
                            <form action="${pageContext.request.contextPath}/admin/return" method="POST">
                                <input type="hidden" name="transactionId" value="${selectedTransaction.transactionId}">

                                <div class="p-3 rounded-3 bg-light border mb-4">
                                    <div class="row g-3">
                                        <div class="col-md-6">
                                            <small class="text-muted d-block">Transaction ID</small>
                                            <span class="font-monospace fw-bold text-primary">${selectedTransaction.transactionId}</span>
                                        </div>
                                        <div class="col-md-6">
                                            <small class="text-muted d-block">Patron / Member</small>
                                            <span class="fw-bold text-dark">${selectedTransaction.memberName} (${selectedTransaction.memberId})</span>
                                        </div>
                                        <div class="col-md-6">
                                            <small class="text-muted d-block">Book Title</small>
                                            <span class="fw-semibold">${selectedTransaction.bookTitle} (${selectedTransaction.bookId})</span>
                                        </div>
                                        <div class="col-md-6">
                                            <small class="text-muted d-block">Circulation Dates</small>
                                            <span>Issued: ${selectedTransaction.formattedIssueDate} | Due: <strong class="${selectedTransaction.overdue ? 'text-danger' : ''}">${selectedTransaction.formattedDueDate}</strong></span>
                                        </div>
                                    </div>
                                </div>

                                <!-- Overdue and Fine Calculation Breakdown -->
                                <div class="row g-3 mb-4">
                                    <div class="col-md-4">
                                        <div class="p-3 rounded-3 text-center ${selectedTransaction.daysOverdue > 0 ? 'bg-danger-subtle border border-danger-subtle' : 'bg-success-subtle border border-success-subtle'}">
                                            <small class="text-muted d-block fw-semibold">Days Overdue</small>
                                            <div class="fs-3 fw-extrabold ${selectedTransaction.daysOverdue > 0 ? 'text-danger' : 'text-success'}">
                                                ${selectedTransaction.daysOverdue} Days
                                            </div>
                                        </div>
                                    </div>
                                    <div class="col-md-4">
                                        <div class="p-3 rounded-3 text-center bg-light border">
                                            <small class="text-muted d-block fw-semibold">Daily Penalty Rate</small>
                                            <div class="fs-3 fw-bold text-dark">₹5.00 / day</div>
                                        </div>
                                    </div>
                                    <div class="col-md-4">
                                        <div class="p-3 rounded-3 text-center ${selectedTransaction.daysOverdue > 0 ? 'bg-warning-subtle border border-warning-subtle' : 'bg-light border'}">
                                            <small class="text-muted d-block fw-semibold">Calculated Late Fine</small>
                                            <div class="fs-3 fw-extrabold text-warning">
                                                ₹${selectedTransaction.daysOverdue * 5.0}
                                            </div>
                                        </div>
                                    </div>
                                </div>

                                <div class="mb-3">
                                    <label class="form-label small fw-semibold">Condition / Return Remarks</label>
                                    <input type="text" name="remarks" class="form-control" placeholder="e.g. Returned in excellent condition" value="Returned on time">
                                </div>

                                <div class="d-flex gap-2">
                                    <button type="submit" class="btn btn-gradient-primary px-4 py-2" data-confirm="Confirm return of this volume?">
                                        <i class="bi bi-check-circle-fill me-1"></i> Confirm & Complete Return
                                    </button>
                                    <a href="${pageContext.request.contextPath}/admin/return" class="btn btn-outline-custom">Cancel</a>
                                </div>
                            </form>
                        </c:when>
                        <c:otherwise>
                            <div class="text-center py-5 text-muted">
                                <i class="bi bi-inbox fs-1 d-block mb-2 text-secondary"></i>
                                <div class="fw-bold">No Loan Transaction Selected</div>
                                <p class="small">Choose an issued volume from the dropdown above to audit return status and fines.</p>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>

            <!-- Return Policies -->
            <div class="col-lg-4">
                <div class="glass-card p-4">
                    <h6 class="fw-bold mb-3"><i class="bi bi-shield-check text-primary me-2"></i>Return Automation</h6>
                    <ul class="text-muted small ps-3 mb-0">
                        <li class="mb-2"><strong>Inventory Restocked:</strong> Available copy count increases by +1 automatically.</li>
                        <li class="mb-2"><strong>Automatic Overdue Fine:</strong> Late returns automatically generate an UNPAID fine entry in the fines ledger.</li>
                        <li class="mb-2"><strong>Waitlist Notification:</strong> If patrons are waiting in queue for this volume, the first patron is immediately alerted.</li>
                    </ul>
                </div>
            </div>
        </div>
    </main>
</div>

<jsp:include page="/includes/footer.jsp" />
