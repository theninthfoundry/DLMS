<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="pageTitle" value="Sign In - Digital Library Management System" />
<jsp:include page="/includes/header.jsp" />

<div class="min-vh-100 d-flex flex-column justify-content-center py-5 position-relative" style="background: var(--dlms-gradient-hero); overflow: hidden;">
    <div class="hero-glow-1"></div>
    <div class="hero-glow-2"></div>

    <div class="container position-relative">
        <div class="row justify-content-center">
            <div class="col-md-8 col-lg-5">
                <!-- Back Link -->
                <div class="mb-3 text-center text-lg-start">
                    <a href="${pageContext.request.contextPath}/" class="text-white-50 small hover-text-white text-decoration-none">
                        <i class="bi bi-arrow-left me-1"></i> Back to Homepage
                    </a>
                </div>

                <!-- Glass Login Card -->
                <div class="glass-card p-4 p-sm-5 border-0 shadow-2xl rounded-4" style="background: rgba(15, 23, 42, 0.85); backdrop-filter: blur(20px); border: 1px solid rgba(255, 255, 255, 0.12) !important;">
                    <div class="text-center mb-4">
                        <div class="rounded-3 p-2 d-inline-flex align-items-center justify-content-center mb-2 shadow" style="background: var(--dlms-gradient-primary); width: 48px; height: 48px;">
                            <i class="bi bi-book-half text-white fs-3"></i>
                        </div>
                        <h3 class="fw-bold text-white mb-1">Welcome Back</h3>
                        <p class="text-white-50 small">Sign in to access your digital library portal</p>
                    </div>

                    <!-- Flash messages -->
                    <c:if test="${not empty errorMessage}">
                        <div class="alert alert-danger py-2 px-3 rounded-3 small d-flex align-items-center gap-2 mb-3" role="alert">
                            <i class="bi bi-exclamation-triangle-fill fs-5"></i>
                            <div>${errorMessage}</div>
                        </div>
                    </c:if>
                    <c:if test="${not empty param.msg}">
                        <div class="alert alert-info py-2 px-3 rounded-3 small d-flex align-items-center gap-2 mb-3" role="alert">
                            <i class="bi bi-info-circle-fill fs-5"></i>
                            <div>${param.msg}</div>
                        </div>
                    </c:if>

                    <!-- Login Form -->
                    <form action="${pageContext.request.contextPath}/login" method="POST" id="loginForm">
                        <div class="mb-3">
                            <label class="form-label text-white-50 small fw-semibold">Username or Email</label>
                            <div class="input-group">
                                <span class="input-group-text bg-dark border-secondary text-white-50"><i class="bi bi-person"></i></span>
                                <input type="text" name="username" id="usernameInput" class="form-control bg-dark text-white border-secondary" placeholder="e.g. admin or aman" value="${prevUsername != null ? prevUsername : (param.role == 'ADMIN' ? 'admin' : (param.role == 'STUDENT' ? 'aman' : ''))}" required>
                            </div>
                        </div>

                        <div class="mb-3">
                            <label class="form-label text-white-50 small fw-semibold d-flex justify-content-between">
                                <span>Password</span>
                                <a href="javascript:void(0)" onclick="alert('For PBL testing, use default demo credentials provided below.')" class="text-cyan small text-decoration-none" style="color: #38BDF8;">Forgot?</a>
                            </label>
                            <div class="input-group">
                                <span class="input-group-text bg-dark border-secondary text-white-50"><i class="bi bi-lock"></i></span>
                                <input type="password" name="password" id="passwordInput" class="form-control bg-dark text-white border-secondary" placeholder="Enter password" value="${param.role == 'ADMIN' ? 'admin123' : (param.role == 'STUDENT' ? 'student123' : '')}" required>
                                <button class="btn btn-outline-secondary text-white-50 border-secondary" type="button" id="togglePasswordBtn">
                                    <i class="bi bi-eye" id="passwordIcon"></i>
                                </button>
                            </div>
                        </div>

                        <div class="d-flex align-items-center justify-content-between mb-4">
                            <div class="form-check">
                                <input class="form-check-input bg-dark border-secondary" type="checkbox" name="remember" id="rememberMe" checked>
                                <label class="form-check-label text-white-50 small" for="rememberMe">Remember me</label>
                            </div>
                            <span class="badge bg-secondary text-white small">Secure SHA-256</span>
                        </div>

                        <button type="submit" class="btn btn-gradient-primary w-100 py-2 fw-semibold fs-6 shadow">
                            <i class="bi bi-box-arrow-in-right me-2"></i> Sign In to Account
                        </button>
                    </form>

                    <!-- Quick Demo Credentials Selector for Examiner Viva -->
                    <div class="mt-4 pt-3 border-top border-white-10">
                        <small class="text-white-50 d-block text-center mb-2 fw-medium">Quick Demo Credentials (1-Click Fill):</small>
                        <div class="row g-2">
                            <div class="col-6">
                                <button type="button" class="btn btn-sm btn-outline-light w-100 py-1" onclick="fillDemoCredentials('admin', 'admin123')">
                                    <i class="bi bi-shield-lock me-1 text-warning"></i> Admin Demo
                                </button>
                            </div>
                            <div class="col-6">
                                <button type="button" class="btn btn-sm btn-outline-light w-100 py-1" onclick="fillDemoCredentials('aman', 'student123')">
                                    <i class="bi bi-mortarboard me-1 text-info"></i> Student Demo
                                </button>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="text-center mt-3 text-white-50 small">
                    B.Tech PBL Project • Team: Md. Amanuddin & Jashwanth Chowdary
                </div>
            </div>
        </div>
    </div>
</div>

<script>
    // Password toggle visibility
    document.getElementById('togglePasswordBtn').addEventListener('click', function() {
        const passInput = document.getElementById('passwordInput');
        const passIcon = document.getElementById('passwordIcon');
        if (passInput.type === 'password') {
            passInput.type = 'text';
            passIcon.className = 'bi bi-eye-slash';
        } else {
            passInput.type = 'password';
            passIcon.className = 'bi bi-eye';
        }
    });

    // 1-Click Fill Demo Credentials
    function fillDemoCredentials(user, pass) {
        document.getElementById('usernameInput').value = user;
        document.getElementById('passwordInput').value = pass;
    }
</script>

<jsp:include page="/includes/footer.jsp" />
