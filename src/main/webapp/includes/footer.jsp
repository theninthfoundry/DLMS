<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!-- Global Toast Notification Container -->
<div id="toastContainer" class="toast-container position-fixed bottom-0 end-0 p-3" style="z-index: 1100;">
    <c:if test="${not empty param.success}">
        <div class="toast align-items-center text-white bg-success border-0 shadow-lg" role="alert" aria-live="assertive" aria-atomic="true">
            <div class="d-flex">
                <div class="toast-body fw-medium"><i class="bi bi-check-circle-fill me-2"></i>${param.success}</div>
                <button type="button" class="btn-close btn-close-white me-2 m-auto" data-bs-dismiss="toast"></button>
            </div>
        </div>
    </c:if>
    <c:if test="${not empty param.error}">
        <div class="toast align-items-center text-white bg-danger border-0 shadow-lg" role="alert" aria-live="assertive" aria-atomic="true">
            <div class="d-flex">
                <div class="toast-body fw-medium"><i class="bi bi-exclamation-triangle-fill me-2"></i>${param.error}</div>
                <button type="button" class="btn-close btn-close-white me-2 m-auto" data-bs-dismiss="toast"></button>
            </div>
        </div>
    </c:if>
    <c:if test="${not empty errorMessage}">
        <div class="toast align-items-center text-white bg-danger border-0 shadow-lg" role="alert" aria-live="assertive" aria-atomic="true">
            <div class="d-flex">
                <div class="toast-body fw-medium"><i class="bi bi-exclamation-triangle-fill me-2"></i>${errorMessage}</div>
                <button type="button" class="btn-close btn-close-white me-2 m-auto" data-bs-dismiss="toast"></button>
            </div>
        </div>
    </c:if>
</div>

<!-- Bootstrap 5 JS Bundle with Popper -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

<!-- DLMS Main UI Core JS -->
<script src="${pageContext.request.contextPath}/assets/js/main.js"></script>
</body>
</html>
