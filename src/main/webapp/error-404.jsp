<%@ page contentType="text/html;charset=UTF-8" language="java" isErrorPage="true" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="pageTitle" value="404 - Page Not Found | DLMS" />
<jsp:include page="/includes/header.jsp" />

<div class="min-vh-100 d-flex align-items-center justify-content-center text-center p-4" style="background: var(--dlms-gradient-hero);">
    <div class="glass-card p-5 max-w-500 rounded-4 shadow-2xl" style="background: rgba(15, 23, 42, 0.85); border: 1px solid rgba(255, 255, 255, 0.12); max-width: 500px;">
        <div class="display-1 fw-extrabold text-info mb-2">404</div>
        <h3 class="fw-bold text-white mb-3">Page Not Found</h3>
        <p class="text-white-50 mb-4">
            Oops! The library catalogue entry, resource, or page you are looking for does not exist or has been relocated.
        </p>
        <div class="d-flex justify-content-center gap-3">
            <a href="${pageContext.request.contextPath}/" class="btn btn-gradient-primary">
                <i class="bi bi-house me-1"></i> Return Home
            </a>
            <a href="javascript:history.back()" class="btn btn-outline-light">
                <i class="bi bi-arrow-left me-1"></i> Go Back
            </a>
        </div>
    </div>
</div>

<jsp:include page="/includes/footer.jsp" />
