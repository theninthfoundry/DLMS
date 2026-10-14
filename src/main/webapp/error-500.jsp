<%@ page contentType="text/html;charset=UTF-8" language="java" isErrorPage="true" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="pageTitle" value="500 - Server Error | DLMS" />
<jsp:include page="/includes/header.jsp" />

<div class="min-vh-100 d-flex align-items-center justify-content-center text-center p-4" style="background: var(--dlms-gradient-hero);">
    <div class="glass-card p-5 max-w-500 rounded-4 shadow-2xl" style="background: rgba(15, 23, 42, 0.85); border: 1px solid rgba(255, 255, 255, 0.12); max-width: 540px;">
        <div class="display-1 fw-extrabold text-danger mb-2">500</div>
        <h3 class="fw-bold text-white mb-2">Internal Server Error</h3>
        <p class="text-white-50 mb-3">
            Something went wrong while executing your library request.
        </p>
        <div class="p-3 bg-dark rounded-3 text-start text-danger-emphasis small font-monospace mb-4" style="border: 1px solid rgba(239, 68, 68, 0.3); word-break: break-all;">
            <%= exception != null ? exception.getMessage() : "Database connection or server internal execution error." %>
        </div>
        <div class="d-flex justify-content-center gap-3">
            <a href="${pageContext.request.contextPath}/" class="btn btn-gradient-primary">
                <i class="bi bi-house me-1"></i> Library Homepage
            </a>
            <a href="${pageContext.request.contextPath}/login" class="btn btn-outline-light">
                <i class="bi bi-person me-1"></i> Re-Authenticate
            </a>
        </div>
    </div>
</div>

<jsp:include page="/includes/footer.jsp" />
