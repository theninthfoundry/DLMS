<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="pageTitle" value="Circulation Transactions - DLMS" />
<c:set var="activePage" value="transactions" />
<jsp:include page="/includes/header.jsp" />

<div class="dashboard-wrapper">
    <jsp:include page="/includes/admin-sidebar.jsp" />

    <main class="main-content">
        <jsp:include page="/includes/navbar.jsp" />

        <div class="d-flex flex-column flex-md-row justify-content-between align-items-md-center gap-3 mb-4">
            <div>
                <h2 class="fw-bold mb-1">Circulation Transactions History</h2>
                <p class="text-muted small mb-0">Complete audit trail of book issues, returns, due dates, and fine assessments.</p>
            </div>
            <div class="d-flex gap-2">
                <a href="${pageContext.request.contextPath}/admin/export?type=transactions" class="btn btn-outline-custom">
                    <i class="bi bi-download me-1"></i> Export Transactions CSV
                </a>
            </div>
        </div>

        <!-- Filter Toolbar -->
        <div class="glass-card p-3 mb-4">
            <form action="${pageContext.request.contextPath}/admin/transactions" method="GET" class="row g-3 align-items-center">
                <div class="col-md-6">
                    <div class="search-input-group">
                        <i class="bi bi-search"></i>
                        <input type="text" name="q" class="form-control" placeholder="Search by Tx ID, student name, book title..." value="${paramQuery}">
                    </div>
                </div>
                <div class="col-md-3">
                    <select name="status" class="form-select">
                        <option value="ALL">All Statuses</option>
                        <option value="ISSUED" ${paramStatus == 'ISSUED' ? 'selected' : ''}>Currently Issued</option>
                        <option value="RETURNED" ${paramStatus == 'RETURNED' ? 'selected' : ''}>Returned</option>
                        <option value="OVERDUE" ${paramStatus == 'OVERDUE' ? 'selected' : ''}>Overdue</option>
                    </select>
                </div>
                <div class="col-md-3 d-flex gap-2 justify-content-end">
                    <button type="submit" class="btn btn-primary px-3">Filter</button>
                    <a href="${pageContext.request.contextPath}/admin/transactions" class="btn btn-outline-custom" title="Reset">
                        <i class="bi bi-arrow-counterclockwise"></i>
                    </a>
                </div>
            </form>
        </div>

        <!-- Transactions Table -->
        <div class="glass-card p-0 mb-4 overflow-hidden">
            <div class="table-responsive">
                <table class="table-custom">
                    <thead>
                        <tr>
                            <th>Tx ID</th>
                            <th>Patron</th>
                            <th>Book Volume</th>
                            <th>Issue Date</th>
                            <th>Due Date</th>
                            <th>Return Date</th>
                            <th>Fine</th>
                            <th>Status</th>
                            <th class="text-end">Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:choose>
                            <c:when test="${not empty transactions}">
                                <c:forEach var="tx" items="${transactions}">
                                    <tr>
                                        <td><span class="font-monospace fw-semibold text-primary">${tx.transactionId}</span></td>
                                        <td>
                                            <div class="fw-bold">${tx.memberName != null ? tx.memberName : tx.memberId}</div>
                                            <small class="text-muted font-monospace">${tx.memberId}</small>
                                        </td>
                                        <td>
                                            <div class="fw-medium text-truncate" style="max-width: 220px;" title="${tx.bookTitle}">${tx.bookTitle}</div>
                                            <small class="text-muted font-monospace">${tx.bookId}</small>
                                        </td>
                                        <td>${tx.formattedIssueDate}</td>
                                        <td>
                                            <span class="${tx.overdue ? 'text-danger fw-bold' : ''}">
                                                ${tx.formattedDueDate}
                                            </span>
                                        </td>
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
                                        <td class="text-end">
                                            <c:if test="${tx.status != 'RETURNED'}">
                                                <a href="${pageContext.request.contextPath}/admin/return?txId=${tx.transactionId}" class="btn btn-sm btn-outline-custom p-1 px-2" title="Process Return">
                                                    <i class="bi bi-arrow-down-left-circle me-1"></i> Return
                                                </a>
                                            </c:if>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <tr>
                                    <td colspan="9">
                                        <div class="empty-state">
                                            <i class="bi bi-clock-history empty-state-icon"></i>
                                            <div class="fw-bold">No Transactions Found</div>
                                            <p class="text-muted small">No transactions match your search query.</p>
                                        </div>
                                    </td>
                                </tr>
                            </c:otherwise>
                        </c:choose>
                    </tbody>
                </table>
            </div>
        </div>

        <!-- Pagination -->
        <c:if test="${totalPages > 1}">
            <div class="d-flex justify-content-between align-items-center mb-4">
                <small class="text-muted">Showing page ${currentPage} of ${totalPages} (${totalCount} transactions total)</small>
                <nav>
                    <ul class="pagination pagination-sm mb-0">
                        <li class="page-item ${currentPage <= 1 ? 'disabled' : ''}">
                            <a class="page-link" href="${pageContext.request.contextPath}/admin/transactions?page=${currentPage - 1}&q=${paramQuery}&status=${paramStatus}">Previous</a>
                        </li>
                        <c:forEach begin="1" end="${totalPages}" var="p">
                            <li class="page-item ${p == currentPage ? 'active' : ''}">
                                <a class="page-link" href="${pageContext.request.contextPath}/admin/transactions?page=${p}&q=${paramQuery}&status=${paramStatus}">${p}</a>
                            </li>
                        </c:forEach>
                        <li class="page-item ${currentPage >= totalPages ? 'disabled' : ''}">
                            <a class="page-link" href="${pageContext.request.contextPath}/admin/transactions?page=${currentPage + 1}&q=${paramQuery}&status=${paramStatus}">Next</a>
                        </li>
                    </ul>
                </nav>
            </div>
        </c:if>
    </main>
</div>

<jsp:include page="/includes/footer.jsp" />
