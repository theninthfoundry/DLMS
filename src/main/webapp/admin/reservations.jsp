<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="pageTitle" value="Book Reservations Queue - DLMS" />
<c:set var="activePage" value="reservations" />
<jsp:include page="/includes/header.jsp" />

<div class="dashboard-wrapper">
    <jsp:include page="/includes/admin-sidebar.jsp" />

    <main class="main-content">
        <jsp:include page="/includes/navbar.jsp" />

        <div class="d-flex flex-column flex-md-row justify-content-between align-items-md-center gap-3 mb-4">
            <div>
                <h2 class="fw-bold mb-1">Waitlist Reservations Queue</h2>
                <p class="text-muted small mb-0">First-Come, First-Served (FIFO Queue) requests for currently unavailable titles.</p>
            </div>
            <div class="d-flex align-items-center gap-2">
                <span class="badge badge-soft-info py-2 px-3 fw-medium">
                    <i class="bi bi-diagram-2 me-1"></i> Java Queue (FIFO) Data Structure
                </span>
            </div>
        </div>

        <!-- Reservations Queue Table -->
        <div class="glass-card p-0 mb-4 overflow-hidden">
            <div class="table-responsive">
                <table class="table-custom">
                    <thead>
                        <tr>
                            <th>Queue Rank</th>
                            <th>Reservation ID</th>
                            <th>Book Volume</th>
                            <th>Waiting Patron</th>
                            <th>Reservation Date</th>
                            <th>Status</th>
                            <th class="text-end">Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:choose>
                            <c:when test="${not empty reservations}">
                                <c:forEach var="res" items="${reservations}">
                                    <tr>
                                        <td>
                                            <div class="rounded-circle ${res.queuePosition == 1 ? 'bg-warning text-dark' : 'bg-light text-muted border'} d-inline-flex align-items-center justify-content-center fw-bold" style="width: 34px; height: 34px;">
                                                #${res.queuePosition}
                                            </div>
                                        </td>
                                        <td><span class="font-monospace fw-semibold text-primary">${res.reservationId}</span></td>
                                        <td>
                                            <div class="fw-bold text-truncate" style="max-width: 240px;">${res.bookTitle}</div>
                                            <small class="text-muted font-monospace">${res.bookId}</small>
                                        </td>
                                        <td>
                                            <div class="fw-semibold">${res.memberName}</div>
                                            <small class="text-muted font-monospace">${res.memberId}</small>
                                        </td>
                                        <td><small class="text-muted">${res.reservationDate}</small></td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${res.status == 'PENDING'}">
                                                    <span class="badge badge-soft-warning">PENDING</span>
                                                </c:when>
                                                <c:when test="${res.status == 'NOTIFIED'}">
                                                    <span class="badge badge-soft-info">NOTIFIED</span>
                                                </c:when>
                                                <c:when test="${res.status == 'FULFILLED'}">
                                                    <span class="badge badge-soft-success">FULFILLED</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="badge bg-secondary">${res.status}</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td class="text-end">
                                            <c:if test="${res.status == 'PENDING'}">
                                                <form action="${pageContext.request.contextPath}/student/cancel-reserve" method="POST" class="d-inline">
                                                    <input type="hidden" name="reservationId" value="${res.reservationId}">
                                                    <button type="submit" class="btn btn-sm btn-outline-danger py-1 px-2" data-confirm="Cancel this waitlist reservation?">
                                                        <i class="bi bi-x-circle me-1"></i> Cancel
                                                    </button>
                                                </form>
                                            </c:if>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <tr>
                                    <td colspan="7">
                                        <div class="empty-state">
                                            <i class="bi bi-bookmark-check empty-state-icon"></i>
                                            <div class="fw-bold">No Active Reservations in Queue</div>
                                            <p class="text-muted small">All requested volumes have been fulfilled or have zero waitlist patrons.</p>
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
