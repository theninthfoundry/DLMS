<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="pageTitle" value="My Borrowed Books - DLMS" />
<c:set var="activePage" value="my-books" />
<jsp:include page="/includes/header.jsp" />

<div class="dashboard-wrapper">
    <jsp:include page="/includes/student-sidebar.jsp" />

    <main class="main-content">
        <jsp:include page="/includes/navbar.jsp" />

        <div class="mb-4">
            <h2 class="fw-bold mb-1">My Borrowed Volumes</h2>
            <p class="text-muted small mb-0">Volumes currently checked out under your library card. Be mindful of due dates.</p>
        </div>

        <div class="glass-card p-0 mb-4 overflow-hidden">
            <div class="table-responsive">
                <table class="table-custom">
                    <thead>
                        <tr>
                            <th>Book Volume</th>
                            <th>Issue Date</th>
                            <th>Due Date</th>
                            <th>Loan Status</th>
                            <th>Late Penalty</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:choose>
                            <c:when test="${not empty activeLoans}">
                                <c:forEach var="tx" items="${activeLoans}">
                                    <tr>
                                        <td>
                                            <div class="d-flex align-items-center gap-3">
                                                <c:if test="${not empty tx.bookCoverUrl}">
                                                    <img src="${tx.bookCoverUrl}" alt="cover" class="book-thumb">
                                                </c:if>
                                                <div>
                                                    <h6 class="fw-bold mb-0 text-dark">${tx.bookTitle}</h6>
                                                    <small class="text-muted font-monospace">Book ID: ${tx.bookId}</small>
                                                </div>
                                            </div>
                                        </td>
                                        <td>${tx.formattedIssueDate}</td>
                                        <td>
                                            <strong class="${tx.overdue ? 'text-danger' : 'text-primary'}">${tx.formattedDueDate}</strong>
                                        </td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${tx.overdue}">
                                                    <span class="badge badge-soft-danger">${tx.daysOverdue} Days Overdue</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="badge badge-soft-success">Active Loan</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${tx.overdue}">
                                                    <span class="fw-bold text-danger">₹${tx.daysOverdue * 5.0} (accruing)</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="text-muted">₹0.00</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <tr>
                                    <td colspan="5">
                                        <div class="empty-state">
                                            <i class="bi bi-book-half empty-state-icon"></i>
                                            <div class="fw-bold">No Volumes Currently Issued</div>
                                            <p class="text-muted small">You do not have any active book loans under your account.</p>
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
