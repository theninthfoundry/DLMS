<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="pageTitle" value="My Profile - DLMS" />
<c:set var="activePage" value="profile" />
<jsp:include page="/includes/header.jsp" />

<div class="dashboard-wrapper">
    <jsp:include page="/includes/student-sidebar.jsp" />

    <main class="main-content">
        <jsp:include page="/includes/navbar.jsp" />

        <div class="mb-4">
            <h2 class="fw-bold mb-1">Patron Account Profile</h2>
            <p class="text-muted small mb-0">View your library membership privileges and update account credentials.</p>
        </div>

        <c:if test="${not empty param.success}">
            <div class="alert alert-success py-2 px-3 rounded-3 small mb-4 d-flex align-items-center gap-2">
                <i class="bi bi-check-circle-fill fs-5"></i>
                <div>${param.success}</div>
            </div>
        </c:if>
        <c:if test="${not empty param.error}">
            <div class="alert alert-danger py-2 px-3 rounded-3 small mb-4 d-flex align-items-center gap-2">
                <i class="bi bi-exclamation-triangle-fill fs-5"></i>
                <div>${param.error}</div>
            </div>
        </c:if>

        <div class="row g-4">
            <!-- Profile Details Card -->
            <div class="col-lg-6">
                <div class="glass-card p-4 h-100">
                    <div class="d-flex align-items-center gap-3 mb-4 pb-3 border-bottom">
                        <div class="rounded-circle bg-primary text-white d-flex align-items-center justify-content-center fw-bold fs-3" style="width: 64px; height: 64px;">
                            ${member != null ? member.name.substring(0, 1) : "P"}
                        </div>
                        <div>
                            <h4 class="fw-bold mb-0">${member != null ? member.name : sessionScope.currentUser.username}</h4>
                            <span class="badge badge-soft-info">${member != null ? member.roleDescription : 'Library Patron'}</span>
                        </div>
                    </div>

                    <div class="row g-3">
                        <div class="col-sm-6">
                            <small class="text-muted d-block">Member ID</small>
                            <span class="font-monospace fw-bold text-primary">${member != null ? member.memberId : "N/A"}</span>
                        </div>
                        <div class="col-sm-6">
                            <small class="text-muted d-block">Department</small>
                            <span class="fw-semibold">${member != null ? member.department : "N/A"}</span>
                        </div>
                        <div class="col-sm-6">
                            <small class="text-muted d-block">Email</small>
                            <span>${member != null ? member.email : sessionScope.currentUser.email}</span>
                        </div>
                        <div class="col-sm-6">
                            <small class="text-muted d-block">Phone</small>
                            <span>${member != null ? member.phone : "N/A"}</span>
                        </div>
                        <div class="col-sm-6">
                            <small class="text-muted d-block">Borrowing Limit</small>
                            <span class="badge badge-soft-success">${member != null ? member.maxBorrowLimit : 4} Volumes Concurrently</span>
                        </div>
                        <div class="col-sm-6">
                            <small class="text-muted d-block">Loan Duration</small>
                            <span class="fw-semibold">${member != null ? member.allowedBorrowDays : 14} Days / Checkout</span>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Change Password Card -->
            <div class="col-lg-6">
                <div class="glass-card p-4 h-100">
                    <h5 class="fw-bold mb-3"><i class="bi bi-shield-lock text-primary me-2"></i>Change Security Password</h5>
                    <form action="${pageContext.request.contextPath}/student/change-password" method="POST">
                        <div class="mb-3">
                            <label class="form-label small fw-semibold">New Password</label>
                            <input type="password" name="newPassword" class="form-control" placeholder="Minimum 6 characters" minlength="6" required>
                        </div>
                        <div class="mb-3">
                            <label class="form-label small fw-semibold">Confirm New Password</label>
                            <input type="password" name="confirmPassword" class="form-control" placeholder="Repeat new password" minlength="6" required>
                        </div>
                        <div class="pt-2">
                            <button type="submit" class="btn btn-gradient-primary">
                                <i class="bi bi-key me-1"></i> Update Password
                            </button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </main>
</div>

<jsp:include page="/includes/footer.jsp" />
