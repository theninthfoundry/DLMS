<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="pageTitle" value="Browse Books - DLMS" />
<c:set var="activePage" value="browse" />
<jsp:include page="/includes/header.jsp" />

<div class="dashboard-wrapper">
    <jsp:include page="/includes/student-sidebar.jsp" />

    <main class="main-content">
        <jsp:include page="/includes/navbar.jsp" />

        <div class="d-flex flex-column flex-md-row justify-content-between align-items-md-center gap-3 mb-4">
            <div>
                <h2 class="fw-bold mb-1">Library Catalog Search</h2>
                <p class="text-muted small mb-0">Discover print volumes, check real-time shelf availability, or reserve waitlist copies.</p>
            </div>
        </div>

        <!-- Search & Filter Bar -->
        <div class="glass-card p-3 mb-4">
            <form action="${pageContext.request.contextPath}/student/browse" method="GET" class="row g-3 align-items-center">
                <div class="col-md-6">
                    <div class="search-input-group">
                        <i class="bi bi-search"></i>
                        <input type="text" name="q" class="form-control" placeholder="Search by book title, author, ISBN..." value="${paramQuery}">
                    </div>
                </div>
                <div class="col-md-4">
                    <select name="category" class="form-select">
                        <option value="ALL">All Categories</option>
                        <c:forEach var="c" items="${categories}">
                            <option value="${c}" ${paramCategory == c ? 'selected' : ''}>${c}</option>
                        </c:forEach>
                    </select>
                </div>
                <div class="col-md-2 d-flex gap-2 justify-content-end">
                    <button type="submit" class="btn btn-primary px-3">Search</button>
                    <a href="${pageContext.request.contextPath}/student/browse" class="btn btn-outline-custom" title="Reset">
                        <i class="bi bi-arrow-counterclockwise"></i>
                    </a>
                </div>
            </form>
        </div>

        <!-- Catalog Grid -->
        <div class="row g-4 mb-4">
            <c:choose>
                <c:when test="${not empty books}">
                    <c:forEach var="book" items="${books}">
                        <div class="col-sm-6 col-lg-4 col-xl-3">
                            <div class="glass-card h-100 card-hover-lift d-flex flex-column overflow-hidden">
                                <img src="${book.coverUrl}" alt="${book.title}" class="book-card-cover">
                                <div class="p-3 d-flex flex-column flex-grow-1">
                                    <div class="d-flex justify-content-between align-items-center mb-1">
                                        <span class="badge badge-soft-info small">${book.category}</span>
                                        <small class="text-muted font-monospace"><i class="bi bi-geo-alt me-1"></i>${book.shelfNumber}</small>
                                    </div>
                                    <h6 class="fw-bold mb-1 text-truncate" title="${book.title}">${book.title}</h6>
                                    <p class="text-muted small mb-2 text-truncate">${book.author}</p>

                                    <div class="mt-auto pt-2 border-top">
                                        <div class="d-flex justify-content-between align-items-center mb-2">
                                            <small class="text-muted font-monospace">#${book.bookId}</small>
                                            <c:choose>
                                                <c:when test="${book.availableCopies > 0}">
                                                    <span class="badge badge-soft-success">${book.availableCopies} Available</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="badge badge-soft-danger">On Loan (0 Available)</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </div>

                                        <!-- Action Buttons -->
                                        <c:choose>
                                            <c:when test="${book.availableCopies > 0}">
                                                <button type="button" class="btn btn-sm btn-gradient-primary w-100" onclick="alert('Book ID: ${book.bookId} is available at Shelf: ${book.shelfNumber}. Please present your student ID at the circulation desk to collect this volume.')">
                                                    <i class="bi bi-check-circle me-1"></i> Available at Desk
                                                </button>
                                            </c:when>
                                            <c:otherwise>
                                                <form action="${pageContext.request.contextPath}/student/reserve" method="POST">
                                                    <input type="hidden" name="bookId" value="${book.bookId}">
                                                    <button type="submit" class="btn btn-sm btn-warning w-100 text-dark fw-semibold" data-confirm="Join the waitlist queue for '${book.title}'?">
                                                        <i class="bi bi-bookmark-plus me-1"></i> Reserve Waitlist
                                                    </button>
                                                </form>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </c:when>
                <c:otherwise>
                    <div class="col-12">
                        <div class="glass-card p-5 text-center">
                            <i class="bi bi-search fs-1 text-muted d-block mb-3"></i>
                            <h5 class="fw-bold">No Books Found</h5>
                            <p class="text-muted small">No volumes matched your search terms. Try searching by topic, author, or reset filters.</p>
                        </div>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>

        <!-- Pagination -->
        <c:if test="${totalPages > 1}">
            <div class="d-flex justify-content-between align-items-center mb-4">
                <small class="text-muted">Showing page ${currentPage} of ${totalPages} (${totalCount} books total)</small>
                <nav>
                    <ul class="pagination pagination-sm mb-0">
                        <li class="page-item ${currentPage <= 1 ? 'disabled' : ''}">
                            <a class="page-link" href="${pageContext.request.contextPath}/student/browse?page=${currentPage - 1}&q=${paramQuery}&category=${paramCategory}">Previous</a>
                        </li>
                        <c:forEach begin="1" end="${totalPages}" var="p">
                            <li class="page-item ${p == currentPage ? 'active' : ''}">
                                <a class="page-link" href="${pageContext.request.contextPath}/student/browse?page=${p}&q=${paramQuery}&category=${paramCategory}">${p}</a>
                            </li>
                        </c:forEach>
                        <li class="page-item ${currentPage >= totalPages ? 'disabled' : ''}">
                            <a class="page-link" href="${pageContext.request.contextPath}/student/browse?page=${currentPage + 1}&q=${paramQuery}&category=${paramCategory}">Next</a>
                        </li>
                    </ul>
                </nav>
            </div>
        </c:if>
    </main>
</div>

<jsp:include page="/includes/footer.jsp" />
