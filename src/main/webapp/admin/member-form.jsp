<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="isEdit" value="${member != null && member.id > 0}" />
<c:set var="pageTitle" value="${isEdit ? 'Edit Member' : 'Register Member'} - DLMS" />
<c:set var="activePage" value="members" />
<jsp:include page="/includes/header.jsp" />

<div class="dashboard-wrapper">
    <jsp:include page="/includes/admin-sidebar.jsp" />

    <main class="main-content">
        <jsp:include page="/includes/navbar.jsp" />

        <div class="d-flex align-items-center justify-content-between mb-4">
            <div>
                <a href="${pageContext.request.contextPath}/admin/members" class="text-muted small text-decoration-none">
                    <i class="bi bi-arrow-left me-1"></i> Back to Directory
                </a>
                <h2 class="fw-bold mt-1 mb-0">${isEdit ? 'Edit Member Profile' : 'Register New Library Member'}</h2>
            </div>
        </div>

        <div class="row">
            <div class="col-lg-8">
                <div class="glass-card p-4">
                    <form action="${pageContext.request.contextPath}/admin/members" method="POST">
                        <input type="hidden" name="action" value="${isEdit ? 'update' : 'save'}">
                        <c:if test="${isEdit}">
                            <input type="hidden" name="id" value="${member.id}">
                        </c:if>

                        <div class="row g-3">
                            <div class="col-md-6">
                                <label class="form-label small fw-semibold">Member ID (Roll / Staff No.)</label>
                                <input type="text" name="memberId" class="form-control font-monospace" placeholder="e.g. MEM-2024-010" value="${member != null ? member.memberId : ''}" required>
                            </div>

                            <div class="col-md-6">
                                <label class="form-label small fw-semibold">Member Type</label>
                                <select name="memberType" id="memberTypeSelect" class="form-select" onchange="adjustQuota()">
                                    <option value="STUDENT" ${member != null && member.memberType == 'STUDENT' ? 'selected' : ''}>Undergraduate / PG Student</option>
                                    <option value="FACULTY" ${member != null && member.memberType == 'FACULTY' ? 'selected' : ''}>Faculty / Research Guide</option>
                                    <option value="SCHOLAR" ${member != null && member.memberType == 'SCHOLAR' ? 'selected' : ''}>Research Scholar</option>
                                </select>
                            </div>

                            <div class="col-12">
                                <label class="form-label small fw-semibold">Full Legal Name</label>
                                <input type="text" name="name" class="form-control" placeholder="e.g. Rahul Sharma" value="${member != null ? member.name : ''}" required>
                            </div>

                            <div class="col-md-6">
                                <label class="form-label small fw-semibold">Email Address</label>
                                <input type="email" name="email" class="form-control" placeholder="student@library.edu" value="${member != null ? member.email : ''}" required>
                            </div>

                            <div class="col-md-6">
                                <label class="form-label small fw-semibold">Phone Number</label>
                                <input type="tel" name="phone" class="form-control" placeholder="+91 98765 43210" value="${member != null ? member.phone : ''}" required>
                            </div>

                            <div class="col-md-6">
                                <label class="form-label small fw-semibold">Department / School</label>
                                <input type="text" name="department" list="deptList" class="form-control" placeholder="Computer Science & Engineering" value="${member != null ? member.department : ''}" required>
                                <datalist id="deptList">
                                    <c:forEach var="d" items="${departments}">
                                        <option value="${d}">
                                    </c:forEach>
                                </datalist>
                            </div>

                            <div class="col-md-6">
                                <label class="form-label small fw-semibold" id="yearLabel">Academic Year / Designation</label>
                                <input type="text" name="yearOrDesignation" class="form-control" placeholder="e.g. 3rd Year or Associate Professor" value="${member != null ? (member.memberType == 'FACULTY' ? member.roleDescription : '3rd Year') : '1st Year'}" required>
                            </div>

                            <div class="col-md-6">
                                <label class="form-label small fw-semibold">Max Borrowing Limit</label>
                                <input type="number" id="maxBorrowLimitInput" name="maxBorrowLimit" class="form-control" min="1" max="15" value="${member != null ? member.maxBorrowLimit : 4}" required>
                                <small class="text-muted" style="font-size: 0.75rem;">Standard: 4 for Students, 8 for Faculty</small>
                            </div>

                            <div class="col-md-6">
                                <label class="form-label small fw-semibold">Account Status</label>
                                <select name="status" class="form-select">
                                    <option value="ACTIVE" ${member != null && member.status == 'ACTIVE' ? 'selected' : ''}>ACTIVE</option>
                                    <option value="SUSPENDED" ${member != null && member.status == 'SUSPENDED' ? 'selected' : ''}>SUSPENDED</option>
                                    <option value="EXPIRED" ${member != null && member.status == 'EXPIRED' ? 'selected' : ''}>EXPIRED</option>
                                </select>
                            </div>

                            <c:if test="${!isEdit}">
                                <div class="col-12 mt-3 p-3 rounded-3 bg-light border">
                                    <div class="form-check">
                                        <input class="form-check-input" type="checkbox" name="createAccount" id="createAccountCheck" value="yes" checked>
                                        <label class="form-check-label fw-semibold small" for="createAccountCheck">
                                            Create Portal Login Account for this Member
                                        </label>
                                    </div>
                                    <div class="row g-2 mt-2">
                                        <div class="col-sm-6">
                                            <input type="text" name="username" class="form-control form-control-sm" placeholder="Username (optional, defaults to ID)">
                                        </div>
                                        <div class="col-sm-6 text-muted small d-flex align-items-center">
                                            Default temporary password: <code>student123</code>
                                        </div>
                                    </div>
                                </div>
                            </c:if>
                        </div>

                        <div class="mt-4 pt-3 border-top d-flex gap-2">
                            <button type="submit" class="btn btn-gradient-primary px-4">
                                <i class="bi bi-check-lg me-1"></i> ${isEdit ? 'Update Member' : 'Register Member'}
                            </button>
                            <a href="${pageContext.request.contextPath}/admin/members" class="btn btn-outline-custom">Cancel</a>
                        </div>
                    </form>
                </div>
            </div>

            <div class="col-lg-4">
                <div class="glass-card p-4">
                    <h6 class="fw-bold mb-3"><i class="bi bi-shield-check text-primary me-2"></i>Borrowing Policies</h6>
                    <div class="mb-3">
                        <strong class="d-block small text-dark">Student Quota:</strong>
                        <p class="text-muted small mb-0">Max 4 volumes concurrently for 14 calendar days. Automatic ₹5/day overdue penalty applies.</p>
                    </div>
                    <div class="mb-3">
                        <strong class="d-block small text-dark">Faculty Quota:</strong>
                        <p class="text-muted small mb-0">Max 8 volumes for 30 days. Fines waived for research reference material.</p>
                    </div>
                </div>
            </div>
        </div>
    </main>
</div>

<script>
    function adjustQuota() {
        const type = document.getElementById('memberTypeSelect').value;
        const limitInput = document.getElementById('maxBorrowLimitInput');
        if (type === 'FACULTY') {
            limitInput.value = 8;
        } else {
            limitInput.value = 4;
        }
    }
</script>

<jsp:include page="/includes/footer.jsp" />
