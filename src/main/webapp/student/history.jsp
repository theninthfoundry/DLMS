<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="pageTitle" value="Borrowing History - DLMS" />
<c:set var="activePage" value="history" />
<jsp:include page="/includes/header.jsp" />

<div class="dashboard-wrapper">
    <jsp:include page="/includes/student-sidebar.jsp" />

    <main class="main-content">
        <jsp:include page="/includes/navbar.jsp" />

        <div class="d-flex flex-column flex-md-row justify-content-between align-items-md-center gap-3 mb-4">
            <div>
                <h2 class="fw-bold mb-1">My Borrowing History</h2>
                <p class="text-muted small mb-0">Complete historical circulation ledger of all volumes borrowed and returned.</p>
            </div>
        </div>

        <div class="glass-card p-0 mb-4 overflow-hidden">
            <div class="table-responsive">
                <table class="table-custom">
                    <thead>
                        <tr>
                            <th>Tx ID</th>
                            <th>Book Volume</th>
                            <th>Issue Date</th>
                            <th>Due Date</th>
                            <th>Return Date</th>
                            <th>Late Fine</th>
                            <th>Status</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:choose>
                            <c:when test="${not empty history}">
                                <c:forEach var="tx" items="${history}">
                                    <tr>
                                        <td><span class="font-monospace fw-semibold text-primary">${tx.transactionId}</span></td>
                                        <td>
                                            <div class="fw-bold text-dark text-truncate" style="max-width: 250px;">${tx.bookTitle}</div>
                                            <small class="text-muted font-monospace">${tx.bookId}</small>
                                        </td>
                                        <td>${tx.formattedIssueDate}</td>
                                        <td>${tx.formattedDueDate}</td>
                                        <td>${tx.formattedReturnDate}</td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${tx.fine > 0}">
                                                    <span class="badge badge-soft-warning">₹${tx.fine}</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="text-muted">₹0.00</span>
                                                </c:otherwise>
                                            </c:choose>
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
                                    </tr>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <tr>
                                    <td colspan="7">
                                        <div class="empty-state">
                                            <i class="bi bi-clock-history empty-state-icon"></i>
                                            <div class="fw-bold">No Circulation History</div>
                                            <p class="text-muted small">You have not borrowed any volumes yet.</p>
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
