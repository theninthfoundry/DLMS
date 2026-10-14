<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="isEdit" value="${book != null && book.id > 0}" />
<c:set var="pageTitle" value="${isEdit ? 'Edit Book' : 'Add New Book'} - DLMS" />
<c:set var="activePage" value="books" />
<jsp:include page="/includes/header.jsp" />

<div class="dashboard-wrapper">
    <jsp:include page="/includes/admin-sidebar.jsp" />

    <main class="main-content">
        <jsp:include page="/includes/navbar.jsp" />

        <div class="d-flex align-items-center justify-content-between mb-4">
            <div>
                <a href="${pageContext.request.contextPath}/admin/books" class="text-muted small text-decoration-none">
                    <i class="bi bi-arrow-left me-1"></i> Back to Catalog
                </a>
                <h2 class="fw-bold mt-1 mb-0">${isEdit ? 'Edit Book Details' : 'Register New Book in Catalog'}</h2>
            </div>
        </div>

        <div class="row">
            <div class="col-lg-9">
                <div class="glass-card p-4">
                    <form action="${pageContext.request.contextPath}/admin/books" method="POST">
                        <input type="hidden" name="action" value="${isEdit ? 'update' : 'save'}">
                        <c:if test="${isEdit}">
                            <input type="hidden" name="id" value="${book.id}">
                        </c:if>

                        <div class="row g-3">
                            <!-- Book ID -->
                            <div class="col-md-4">
                                <label class="form-label small fw-semibold">Book ID (Catalog Identifier)</label>
                                <input type="text" name="bookId" class="form-control font-monospace" placeholder="e.g. BK-1019" value="${book != null ? book.bookId : ''}" required>
                            </div>

                            <!-- ISBN -->
                            <div class="col-md-4">
                                <label class="form-label small fw-semibold">ISBN</label>
                                <input type="text" name="isbn" class="form-control font-monospace" placeholder="e.g. 978-0131103627" value="${book != null ? book.isbn : ''}" required>
                            </div>

                            <!-- Category -->
                            <div class="col-md-4">
                                <label class="form-label small fw-semibold">Subject / Category</label>
                                <input type="text" name="category" list="categoryList" class="form-control" placeholder="e.g. Computer Science" value="${book != null ? book.category : ''}" required>
                                <datalist id="categoryList">
                                    <c:forEach var="c" items="${categories}">
                                        <option value="${c}">
                                    </c:forEach>
                                </datalist>
                            </div>

                            <!-- Title -->
                            <div class="col-12">
                                <label class="form-label small fw-semibold">Book Title</label>
                                <input type="text" name="title" class="form-control" placeholder="Complete textbook or resource title" value="${book != null ? book.title : ''}" required>
                            </div>

                            <!-- Author -->
                            <div class="col-md-6">
                                <label class="form-label small fw-semibold">Author(s)</label>
                                <input type="text" name="author" class="form-control" placeholder="Author name(s)" value="${book != null ? book.author : ''}" required>
                            </div>

                            <!-- Publisher -->
                            <div class="col-md-6">
                                <label class="form-label small fw-semibold">Publisher</label>
                                <input type="text" name="publisher" class="form-control" placeholder="e.g. MIT Press, McGraw-Hill" value="${book != null ? book.publisher : ''}">
                            </div>

                            <!-- Publication Year -->
                            <div class="col-md-4">
                                <label class="form-label small fw-semibold">Publication Year</label>
                                <input type="number" name="publicationYear" class="form-control" min="1900" max="2099" placeholder="2023" value="${book != null ? book.publicationYear : 2023}">
                            </div>

                            <!-- Language -->
                            <div class="col-md-4">
                                <label class="form-label small fw-semibold">Language</label>
                                <input type="text" name="language" class="form-control" placeholder="English" value="${book != null ? book.language : 'English'}">
                            </div>

                            <!-- Shelf Number -->
                            <div class="col-md-4">
                                <label class="form-label small fw-semibold">Shelf Location Code</label>
                                <input type="text" name="shelfNumber" class="form-control font-monospace" placeholder="e.g. CS-B2-04" value="${book != null ? book.shelfNumber : ''}" required>
                            </div>

                            <!-- Quantity -->
                            <div class="col-md-4">
                                <label class="form-label small fw-semibold">Total Quantity (Copies)</label>
                                <input type="number" name="quantity" class="form-control" min="1" max="500" value="${book != null ? book.quantity : 1}" required>
                            </div>

                            <!-- Available Copies -->
                            <div class="col-md-4">
                                <label class="form-label small fw-semibold">Available Copies</label>
                                <input type="number" name="availableCopies" class="form-control" min="0" max="500" value="${book != null ? book.availableCopies : 1}">
                            </div>

                            <!-- Cover Image URL -->
                            <div class="col-md-4">
                                <label class="form-label small fw-semibold">Cover Image URL</label>
                                <input type="url" name="coverUrl" class="form-control" placeholder="https://..." value="${book != null ? book.coverUrl : ''}">
                            </div>

                            <!-- Description -->
                            <div class="col-12">
                                <label class="form-label small fw-semibold">Abstract / Description</label>
                                <textarea name="description" class="form-control" rows="4" placeholder="Brief summary of table of contents and topics covered...">${book != null ? book.description : ''}</textarea>
                            </div>
                        </div>

                        <div class="mt-4 pt-3 border-top d-flex gap-2">
                            <button type="submit" class="btn btn-gradient-primary px-4">
                                <i class="bi bi-check-lg me-1"></i> ${isEdit ? 'Save Changes' : 'Add to Catalog'}
                            </button>
                            <a href="${pageContext.request.contextPath}/admin/books" class="btn btn-outline-custom">Cancel</a>
                        </div>
                    </form>
                </div>
            </div>

            <!-- Help Sidebar -->
            <div class="col-lg-3">
                <div class="glass-card p-3 mb-3">
                    <h6 class="fw-bold mb-2"><i class="bi bi-info-circle text-primary me-2"></i>Cataloging Tips</h6>
                    <ul class="text-muted small ps-3 mb-0">
                        <li class="mb-2"><strong>Book ID:</strong> Unique catalog serial like <code>BK-1001</code>.</li>
                        <li class="mb-2"><strong>Shelf Code:</strong> Helps patrons quickly locate volumes (e.g. <code>CS-A1-04</code>).</li>
                        <li class="mb-2"><strong>Quantity:</strong> Total physical volume count. Copies available updates automatically when issued or returned.</li>
                    </ul>
                </div>
            </div>
        </div>
    </main>
</div>

<jsp:include page="/includes/footer.jsp" />
