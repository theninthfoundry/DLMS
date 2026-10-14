<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="pageTitle" value="Book Management - DLMS" />
<c:set var="activePage" value="books" />
<jsp:include page="/includes/header.jsp" />

<div class="dashboard-wrapper">
    <jsp:include page="/includes/admin-sidebar.jsp" />

    <main class="main-content">
        <jsp:include page="/includes/navbar.jsp" />

        <!-- Header & Action Bar -->
        <div class="d-flex flex-column flex-md-row justify-content-between align-items-md-center gap-3 mb-4">
            <div>
                <h2 class="fw-bold mb-1">Catalog & Book Management</h2>
                <p class="text-muted small mb-0">Manage physical and digital library inventory, shelf locations, and availability.</p>
            </div>
            <div class="d-flex gap-2">
                <a href="${pageContext.request.contextPath}/admin/books?action=new" class="btn btn-gradient-primary">
                    <i class="bi bi-plus-lg"></i> Add New Book
                </a>
            </div>
        </div>

        <!-- Filter & Search Toolbar -->
        <div class="glass-card p-3 mb-4">
            <form action="${pageContext.request.contextPath}/admin/books" method="GET" class="row g-3 align-items-center">
                <input type="hidden" name="view" value="${viewMode}">

                <!-- Search Input -->
                <div class="col-md-4">
                    <div class="search-input-group">
                        <i class="bi bi-search"></i>
                        <input type="text" name="q" class="form-control" placeholder="Search by title, author, ISBN..." value="${paramQuery}">
                    </div>
                </div>

                <!-- Category Filter -->
                <div class="col-md-3">
                    <select name="category" class="form-select">
                        <option value="ALL">All Categories</option>
                        <c:forEach var="cat" items="${categories}">
                            <option value="${cat}" ${paramCategory == cat ? 'selected' : ''}>${cat}</option>
                        </c:forEach>
                    </select>
                </div>

                <!-- Sort Filter -->
                <div class="col-md-3">
                    <select name="sort" class="form-select">
                        <option value="recent" ${paramSort == 'recent' ? 'selected' : ''}>Sort by: Recently Added</option>
                        <option value="title_asc" ${paramSort == 'title_asc' ? 'selected' : ''}>Title (A - Z)</option>
                        <option value="title_desc" ${paramSort == 'title_desc' ? 'selected' : ''}>Title (Z - A)</option>
                        <option value="author" ${paramSort == 'author' ? 'selected' : ''}>Author Name</option>
                        <option value="year_desc" ${paramSort == 'year_desc' ? 'selected' : ''}>Publication Year</option>
                        <option value="available" ${paramSort == 'available' ? 'selected' : ''}>Copies Available</option>
                    </select>
                </div>

                <!-- Filter Buttons & View Mode Toggle -->
                <div class="col-md-2 d-flex gap-2 justify-content-end">
                    <button type="submit" class="btn btn-primary px-3">
                        <i class="bi bi-filter"></i> Filter
                    </button>
                    <a href="${pageContext.request.contextPath}/admin/books" class="btn btn-outline-custom" title="Reset Filters">
                        <i class="bi bi-arrow-counterclockwise"></i>
                    </a>
                    <div class="btn-group" role="group">
                        <a href="${pageContext.request.contextPath}/admin/books?view=table&q=${paramQuery}&category=${paramCategory}&sort=${paramSort}" class="btn btn-outline-custom ${viewMode == 'table' ? 'active' : ''}" title="Table View">
                            <i class="bi bi-table"></i>
                        </a>
                        <a href="${pageContext.request.contextPath}/admin/books?view=cards&q=${paramQuery}&category=${paramCategory}&sort=${paramSort}" class="btn btn-outline-custom ${viewMode == 'cards' ? 'active' : ''}" title="Card Grid View">
                            <i class="bi bi-grid-fill"></i>
                        </a>
                    </div>
                </div>
            </form>
        </div>

        <!-- Catalog Display -->
        <c:choose>
            <c:when test="${viewMode == 'cards'}">
                <!-- CARD VIEW -->
                <div class="row g-4 mb-4">
                    <c:forEach var="book" items="${books}">
                        <div class="col-sm-6 col-lg-4 col-xl-3">
                            <div class="glass-card h-100 card-hover-lift d-flex flex-column overflow-hidden">
                                <img src="${book.coverUrl}" alt="${book.title}" class="book-card-cover">
                                <div class="p-3 d-flex flex-column flex-grow-1">
                                    <div class="d-flex justify-content-between align-items-center mb-1">
                                        <span class="badge badge-soft-info small">${book.category}</span>
                                        <small class="text-muted font-monospace">${book.shelfNumber}</small>
                                    </div>
                                    <h6 class="fw-bold mb-1 text-truncate" title="${book.title}">${book.title}</h6>
                                    <p class="text-muted small mb-2 text-truncate">${book.author}</p>
                                    <div class="mt-auto pt-2 border-top d-flex justify-content-between align-items-center">
                                        <div>
                                            <c:choose>
                                                <c:when test="${book.availableCopies > 0}">
                                                    <span class="badge badge-soft-success">${book.availableCopies} / ${book.quantity} Available</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="badge badge-soft-danger">Out of Stock</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </div>
                                        <div class="dropdown">
                                            <button class="btn btn-sm btn-outline-custom py-1 px-2" data-bs-toggle="dropdown">
                                                <i class="bi bi-three-dots-vertical"></i>
                                            </button>
                                            <ul class="dropdown-menu dropdown-menu-end shadow-sm">
                                                <li><a class="dropdown-item" href="${pageContext.request.contextPath}/admin/books?action=view&id=${book.id}"><i class="bi bi-eye me-2"></i>View Details</a></li>
                                                <li><a class="dropdown-item" href="${pageContext.request.contextPath}/admin/books?action=edit&id=${book.id}"><i class="bi bi-pencil me-2"></i>Edit Book</a></li>
                                                <c:if test="${book.availableCopies > 0}">
                                                    <li><a class="dropdown-item text-primary" href="${pageContext.request.contextPath}/admin/issue?bookId=${book.bookId}"><i class="bi bi-arrow-up-right me-2"></i>Issue Book</a></li>
                                                </c:if>
                                                <li><hr class="dropdown-divider"></li>
                                                <li><a class="dropdown-item text-danger" href="${pageContext.request.contextPath}/admin/books?action=delete&id=${book.id}" data-confirm="Are you sure you want to delete '${book.title}'?"><i class="bi bi-trash me-2"></i>Delete</a></li>
                                            </ul>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </c:when>
            <c:otherwise>
                <!-- TABLE VIEW -->
                <div class="glass-card p-0 mb-4 overflow-hidden">
                    <div class="table-responsive">
                        <table class="table-custom">
                            <thead>
                                <tr>
                                    <th>Book ID</th>
                                    <th>Cover & Title</th>
                                    <th>Author</th>
                                    <th>Category</th>
                                    <th>Shelf</th>
                                    <th>Copies</th>
                                    <th>Status</th>
                                    <th class="text-end">Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:choose>
                                    <c:when test="${not empty books}">
                                        <c:forEach var="book" items="${books}">
                                            <tr>
                                                <td><span class="font-monospace fw-semibold text-primary">${book.bookId}</span></td>
                                                <td>
                                                    <div class="d-flex align-items-center gap-3">
                                                        <img src="${book.coverUrl}" alt="cover" class="book-thumb">
                                                        <div>
                                                            <a href="${pageContext.request.contextPath}/admin/books?action=view&id=${book.id}" class="fw-bold text-dark hover-text-primary text-truncate d-block" style="max-width: 250px;">
                                                                ${book.title}
                                                            </a>
                                                            <small class="text-muted font-monospace">ISBN: ${book.isbn}</small>
                                                        </div>
                                                    </div>
                                                </td>
                                                <td><div class="text-truncate" style="max-width: 150px;">${book.author}</div></td>
                                                <td><span class="badge badge-soft-info">${book.category}</span></td>
                                                <td><span class="font-monospace text-muted small">${book.shelfNumber}</span></td>
                                                <td><strong>${book.availableCopies}</strong> / ${book.quantity}</td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${book.availableCopies > 0}">
                                                            <span class="badge badge-soft-success">AVAILABLE</span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="badge badge-soft-danger">OUT OF STOCK</span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td class="text-end">
                                                    <div class="d-inline-flex gap-1">
                                                        <a href="${pageContext.request.contextPath}/admin/books?action=view&id=${book.id}" class="btn btn-sm btn-outline-custom p-1 px-2" title="View Details">
                                                            <i class="bi bi-eye"></i>
                                                        </a>
                                                        <a href="${pageContext.request.contextPath}/admin/books?action=edit&id=${book.id}" class="btn btn-sm btn-outline-custom p-1 px-2" title="Edit Book">
                                                            <i class="bi bi-pencil"></i>
                                                        </a>
                                                        <c:if test="${book.availableCopies > 0}">
                                                            <a href="${pageContext.request.contextPath}/admin/issue?bookId=${book.bookId}" class="btn btn-sm btn-primary p-1 px-2" title="Issue Book">
                                                                <i class="bi bi-arrow-up-right"></i>
                                                            </a>
                                                        </c:if>
                                                        <a href="${pageContext.request.contextPath}/admin/books?action=delete&id=${book.id}" class="btn btn-sm btn-outline-danger p-1 px-2" title="Delete Book" data-confirm="Are you sure you want to delete '${book.title}'?">
                                                            <i class="bi bi-trash"></i>
                                                        </a>
                                                    </div>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </c:when>
                                    <c:otherwise>
                                        <tr>
                                            <td colspan="8">
                                                <div class="empty-state">
                                                    <i class="bi bi-book empty-state-icon"></i>
                                                    <div class="fw-bold">No Books Found</div>
                                                    <p class="text-muted small">No books match your current query or category filter.</p>
                                                    <a href="${pageContext.request.contextPath}/admin/books?action=new" class="btn btn-gradient-primary btn-sm mt-2">
                                                        <i class="bi bi-plus-lg"></i> Add a Book Now
                                                    </a>
                                                </div>
                                            </td>
                                        </tr>
                                    </c:otherwise>
                                </c:choose>
                            </tbody>
                        </table>
                    </div>
                </div>
            </c:otherwise>
        </c:choose>

        <!-- Pagination Controls -->
        <c:if test="${totalPages > 1}">
            <div class="d-flex justify-content-between align-items-center mb-4">
                <small class="text-muted">Showing page ${currentPage} of ${totalPages} (${totalCount} books total)</small>
                <nav aria-label="Book page navigation">
                    <ul class="pagination pagination-sm mb-0">
                        <li class="page-item ${currentPage <= 1 ? 'disabled' : ''}">
                            <a class="page-link" href="${pageContext.request.contextPath}/admin/books?page=${currentPage - 1}&q=${paramQuery}&category=${paramCategory}&sort=${paramSort}&view=${viewMode}">Previous</a>
                        </li>
                        <c:forEach begin="1" end="${totalPages}" var="p">
                            <li class="page-item ${p == currentPage ? 'active' : ''}">
                                <a class="page-link" href="${pageContext.request.contextPath}/admin/books?page=${p}&q=${paramQuery}&category=${paramCategory}&sort=${paramSort}&view=${viewMode}">${p}</a>
                            </li>
                        </c:forEach>
                        <li class="page-item ${currentPage >= totalPages ? 'disabled' : ''}">
                            <a class="page-link" href="${pageContext.request.contextPath}/admin/books?page=${currentPage + 1}&q=${paramQuery}&category=${paramCategory}&sort=${paramSort}&view=${viewMode}">Next</a>
                        </li>
                    </ul>
                </nav>
            </div>
        </c:if>
    </main>
</div>

<jsp:include page="/includes/footer.jsp" />
