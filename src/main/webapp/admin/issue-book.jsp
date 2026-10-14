<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="pageTitle" value="Issue Book - DLMS" />
<c:set var="activePage" value="issue" />
<jsp:include page="/includes/header.jsp" />

<div class="dashboard-wrapper">
    <jsp:include page="/includes/admin-sidebar.jsp" />

    <main class="main-content">
        <jsp:include page="/includes/navbar.jsp" />

        <div class="mb-4">
            <h2 class="fw-bold mb-1">Issue Book to Patron</h2>
            <p class="text-muted small mb-0">Record volume check-out, decrement available inventory, and initialize circulation timeline.</p>
        </div>

        <c:if test="${not empty errorMessage}">
            <div class="alert alert-danger py-2 px-3 rounded-3 small mb-4 d-flex align-items-center gap-2">
                <i class="bi bi-exclamation-octagon-fill fs-5"></i>
                <div>${errorMessage}</div>
            </div>
        </c:if>

        <div class="row">
            <div class="col-lg-8">
                <div class="glass-card p-4">
                    <form action="${pageContext.request.contextPath}/admin/issue" method="POST" id="issueForm">
                        <div class="row g-3">
                            <!-- Select Member -->
                            <div class="col-12">
                                <label class="form-label small fw-semibold">1. Select Patron / Member</label>
                                <select name="memberId" class="form-select" required>
                                    <option value="">-- Choose Member from Directory --</option>
                                    <c:forEach var="m" items="${members}">
                                        <option value="${m.memberId}" ${preselectedMember == m.memberId ? 'selected' : ''}>
                                            ${m.memberId} — ${m.name} (${m.department} • ${m.roleDescription})
                                        </option>
                                    </c:forEach>
                                </select>
                            </div>

                            <!-- Select Book -->
                            <div class="col-12">
                                <label class="form-label small fw-semibold">2. Select Catalog Volume (Book)</label>
                                <select name="bookId" class="form-select" required>
                                    <option value="">-- Choose Available Volume --</option>
                                    <c:forEach var="b" items="${books}">
                                        <option value="${b.bookId}" ${preselectedBook == b.bookId ? 'selected' : ''}>
                                            ${b.bookId} — ${b.title} [Shelf: ${b.shelfNumber}] (${b.availableCopies} available)
                                        </option>
                                    </c:forEach>
                                </select>
                            </div>

                            <!-- Automatic Dates Preview -->
                            <div class="col-md-6">
                                <label class="form-label small fw-semibold text-muted">Issue Date</label>
                                <input type="text" class="form-control bg-light" value="Today (Auto Recorded)" readonly>
                            </div>

                            <div class="col-md-6">
                                <label class="form-label small fw-semibold text-muted">Loan Duration & Due Date</label>
                                <input type="text" class="form-control bg-light text-primary fw-bold" value="+14 Days (Student) / +30 Days (Faculty)" readonly>
                            </div>
                        </div>

                        <div class="mt-4 pt-3 border-top d-flex gap-2">
                            <button type="submit" class="btn btn-gradient-primary px-4 py-2">
                                <i class="bi bi-arrow-up-right-circle me-1"></i> Confirm & Issue Book
                            </button>
                            <a href="${pageContext.request.contextPath}/admin/dashboard" class="btn btn-outline-custom">Cancel</a>
                        </div>
                    </form>
                </div>
            </div>

            <!-- Quick Guidelines -->
            <div class="col-lg-4">
                <div class="glass-card p-4">
                    <h6 class="fw-bold mb-3"><i class="bi bi-info-circle text-primary me-2"></i>Circulation Rules</h6>
                    <ul class="text-muted small ps-3 mb-0">
                        <li class="mb-2"><strong>Zero Stock Check:</strong> A book cannot be issued if available copy count is zero. Patrons can instead join the waitlist.</li>
                        <li class="mb-2"><strong>Quota Exceeded Check:</strong> System rejects issues if the patron exceeds their quota limit (4 for students, 8 for faculty).</li>
                        <li class="mb-2"><strong>Auto Inventory Sync:</strong> Available copies automatically decrement upon successful checkout.</li>
                    </ul>
                </div>
            </div>
        </div>
    </main>
</div>

<jsp:include page="/includes/footer.jsp" />
