<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="pageTitle" value="System Settings - DLMS" />
<c:set var="activePage" value="settings" />
<jsp:include page="/includes/header.jsp" />

<div class="dashboard-wrapper">
    <jsp:include page="/includes/admin-sidebar.jsp" />

    <main class="main-content">
        <jsp:include page="/includes/navbar.jsp" />

        <div class="mb-4">
            <h2 class="fw-bold mb-1">System Configuration & Policies</h2>
            <p class="text-muted small mb-0">Review circulation constants, daily overdue fine parameters, and environment settings.</p>
        </div>

        <div class="row g-4">
            <div class="col-lg-7">
                <div class="glass-card p-4">
                    <h5 class="fw-bold mb-3"><i class="bi bi-sliders text-primary me-2"></i>Circulation Policy Rules</h5>
                    <div class="mb-3">
                        <label class="form-label small fw-semibold">Overdue Fine Rate (per Day)</label>
                        <div class="input-group">
                            <span class="input-group-text">₹</span>
                            <input type="text" class="form-control" value="5.00" readonly>
                            <span class="input-group-text">per late calendar day</span>
                        </div>
                        <small class="text-muted">Defined in <code>db.properties</code> via property <code>library.finePerDay</code>.</small>
                    </div>

                    <div class="mb-3">
                        <label class="form-label small fw-semibold">Standard Student Loan Duration</label>
                        <div class="input-group">
                            <input type="text" class="form-control" value="14" readonly>
                            <span class="input-group-text">Days</span>
                        </div>
                    </div>

                    <div class="mb-3">
                        <label class="form-label small fw-semibold">Faculty / Researcher Loan Duration</label>
                        <div class="input-group">
                            <input type="text" class="form-control" value="30" readonly>
                            <span class="input-group-text">Days</span>
                        </div>
                    </div>

                    <div class="mb-3">
                        <label class="form-label small fw-semibold">Max Student Borrowing Quota</label>
                        <div class="input-group">
                            <input type="text" class="form-control" value="4" readonly>
                            <span class="input-group-text">Volumes Concurrently</span>
                        </div>
                    </div>
                </div>
            </div>

            <div class="col-lg-5">
                <div class="glass-card p-4">
                    <h5 class="fw-bold mb-3"><i class="bi bi-cpu text-info me-2"></i>Runtime Environment</h5>
                    <div class="p-3 rounded-3 bg-light mb-3">
                        <small class="text-muted d-block">Architecture Stack</small>
                        <strong class="text-dark">Java Servlets 4.0 + JSP + JDBC + MySQL</strong>
                    </div>
                    <div class="p-3 rounded-3 bg-light mb-3">
                        <small class="text-muted d-block">Database Engine</small>
                        <strong class="text-dark">MySQL 8.0+ (InnoDB)</strong>
                    </div>
                    <div class="p-3 rounded-3 bg-light mb-3">
                        <small class="text-muted d-block">PBL Team Submission</small>
                        <strong class="text-dark">Team No: 1</strong>
                        <div class="small text-muted">Md. Amanuddin, Jashwanth Chowdary</div>
                    </div>
                </div>
            </div>
        </div>
    </main>
</div>

<jsp:include page="/includes/footer.jsp" />
