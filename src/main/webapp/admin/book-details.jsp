<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="pageTitle" value="${book.title} - Book Details" />
<c:set var="activePage" value="books" />
<jsp:include page="/includes/header.jsp" />

<div class="dashboard-wrapper">
    <jsp:include page="/includes/admin-sidebar.jsp" />

    <main class="main-content">
        <jsp:include page="/includes/navbar.jsp" />

        <div class="mb-3">
            <a href="${pageContext.request.contextPath}/admin/books" class="btn btn-sm btn-outline-custom">
                <i class="bi bi-arrow-left me-1"></i> Back to Catalog
            </a>
        </div>

        <div class="glass-card p-4 p-md-5 mb-4">
            <div class="row g-4 align-items-start">
                <!-- Book Cover Large -->
                <div class="col-md-4 col-lg-3 text-center">
                    <img src="${book.coverUrl}" alt="${book.title}" class="img-fluid rounded-4 shadow-lg mb-3" style="max-height: 380px; width: 100%; object-fit: cover;">
                    <div>
                        <c:choose>
                            <c:when test="${book.availableCopies > 0}">
                                <div class="badge-soft-success py-2 px-3 fw-bold rounded-3 mb-2 d-inline-block">
                                    <i class="bi bi-check-circle-fill me-1"></i> ${book.availableCopies} Copies Available
                                </div>
                            </c:when>
                            <c:otherwise>
                                <div class="badge-soft-danger py-2 px-3 fw-bold rounded-3 mb-2 d-inline-block">
                                    <i class="bi bi-x-circle-fill me-1"></i> Out of Stock
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>

                <!-- Book Meta & Specs -->
                <div class="col-md-8 col-lg-9">
                    <div class="d-flex flex-wrap justify-content-between align-items-start gap-2 mb-2">
                        <span class="badge badge-soft-info px-3 py-1 fs-7 fw-semibold">${book.category}</span>
                        <div class="d-flex gap-2">
                            <a href="${pageContext.request.contextPath}/admin/books?action=edit&id=${book.id}" class="btn btn-sm btn-outline-custom">
                                <i class="bi bi-pencil me-1"></i> Edit Book
                            </a>
                        </div>
                    </div>

                    <h2 class="fw-bold mb-2">${book.title}</h2>
                    <h5 class="text-muted fw-normal mb-4">By <span class="text-dark fw-semibold">${book.author}</span></h5>

                    <div class="row g-3 mb-4 p-3 rounded-3 bg-light">
                        <div class="col-6 col-sm-3">
                            <small class="text-muted d-block">Book ID</small>
                            <span class="font-monospace fw-bold text-primary">${book.bookId}</span>
                        </div>
                        <div class="col-6 col-sm-3">
                            <small class="text-muted d-block">ISBN</small>
                            <span class="font-monospace fw-bold">${book.isbn}</span>
                        </div>
                        <div class="col-6 col-sm-3">
                            <small class="text-muted d-block">Shelf Location</small>
                            <span class="font-monospace fw-bold text-info">${book.shelfNumber}</span>
                        </div>
                        <div class="col-6 col-sm-3">
                            <small class="text-muted d-block">Total Inventory</small>
                            <span class="fw-bold">${book.quantity} Volumes</span>
                        </div>
                        <div class="col-6 col-sm-3">
                            <small class="text-muted d-block">Publisher</small>
                            <span class="fw-medium">${book.publisher}</span>
                        </div>
                        <div class="col-6 col-sm-3">
                            <small class="text-muted d-block">Year</small>
                            <span class="fw-medium">${book.publicationYear}</span>
                        </div>
                        <div class="col-6 col-sm-3">
                            <small class="text-muted d-block">Language</small>
                            <span class="fw-medium">${book.language}</span>
                        </div>
                        <div class="col-6 col-sm-3">
                            <small class="text-muted d-block">Loan Status</small>
                            <span class="fw-semibold ${book.availableCopies > 0 ? 'text-success' : 'text-danger'}">${book.status}</span>
                        </div>
                    </div>

                    <div class="mb-4">
                        <h6 class="fw-bold mb-2">Synopsis & Description</h6>
                        <p class="text-muted" style="line-height: 1.8;">
                            ${not empty book.description ? book.description : "No description provided for this catalog volume."}
                        </p>
                    </div>

                    <div class="d-flex flex-wrap gap-2 pt-3 border-top">
                        <c:choose>
                            <c:when test="${book.availableCopies > 0}">
                                <a href="${pageContext.request.contextPath}/admin/issue?bookId=${book.bookId}" class="btn btn-gradient-primary px-4">
                                    <i class="bi bi-arrow-up-right me-1"></i> Issue to Member
                                </a>
                            </c:when>
                            <c:otherwise>
                                <a href="${pageContext.request.contextPath}/admin/reservations" class="btn btn-warning px-4">
                                    <i class="bi bi-bookmark-plus me-1"></i> View Waitlist Queue
                                </a>
                            </c:otherwise>
                        </c:choose>
                        <a href="${pageContext.request.contextPath}/admin/books" class="btn btn-outline-custom">Back</a>
                    </div>
                </div>
            </div>
        </div>
    </main>
</div>

<jsp:include page="/includes/footer.jsp" />
