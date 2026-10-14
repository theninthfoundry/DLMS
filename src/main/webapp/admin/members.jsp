<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="pageTitle" value="Members Directory - DLMS" />
<c:set var="activePage" value="members" />
<jsp:include page="/includes/header.jsp" />

<div class="dashboard-wrapper">
    <jsp:include page="/includes/admin-sidebar.jsp" />

    <main class="main-content">
        <jsp:include page="/includes/navbar.jsp" />

        <!-- Header -->
        <div class="d-flex flex-column flex-md-row justify-content-between align-items-md-center gap-3 mb-4">
            <div>
                <h2 class="fw-bold mb-1">Members & Patrons Directory</h2>
                <p class="text-muted small mb-0">Manage registered students, faculty scholars, borrowing privileges, and status.</p>
            </div>
            <div class="d-flex gap-2">
                <a href="${pageContext.request.contextPath}/admin/members?action=new" class="btn btn-gradient-primary">
                    <i class="bi bi-person-plus-fill"></i> Register New Member
                </a>
            </div>
        </div>

        <!-- Filter Toolbar -->
        <div class="glass-card p-3 mb-4">
            <form action="${pageContext.request.contextPath}/admin/members" method="GET" class="row g-3 align-items-center">
                <!-- Search -->
                <div class="col-md-5">
                    <div class="search-input-group">
                        <i class="bi bi-search"></i>
                        <input type="text" name="q" class="form-control" placeholder="Search by name, ID, email, phone..." value="${paramQuery}">
                    </div>
                </div>

                <!-- Department Filter -->
                <div class="col-md-3">
                    <select name="dept" class="form-select">
                        <option value="ALL">All Departments</option>
                        <c:forEach var="d" items="${departments}">
                            <option value="${d}" ${paramDept == d ? 'selected' : ''}>${d}</option>
                        </c:forEach>
                    </select>
                </div>

                <!-- Member Type -->
                <div class="col-md-2">
                    <select name="type" class="form-select">
                        <option value="ALL">All Types</option>
                        <option value="STUDENT" ${paramType == 'STUDENT' ? 'selected' : ''}>Student</option>
                        <option value="FACULTY" ${paramType == 'FACULTY' ? 'selected' : ''}>Faculty</option>
                        <option value="SCHOLAR" ${paramType == 'SCHOLAR' ? 'selected' : ''}>Scholar</option>
                    </select>
                </div>

                <!-- Submit / Reset -->
                <div class="col-md-2 d-flex gap-2 justify-content-end">
                    <button type="submit" class="btn btn-primary px-3">Filter</button>
                    <a href="${pageContext.request.contextPath}/admin/members" class="btn btn-outline-custom" title="Reset">
                        <i class="bi bi-arrow-counterclockwise"></i>
                    </a>
                </div>
            </form>
        </div>

        <!-- Members Table -->
        <div class="glass-card p-0 mb-4 overflow-hidden">
            <div class="table-responsive">
                <table class="table-custom">
                    <thead>
                        <tr>
                            <th>Member ID</th>
                            <th>Full Name & Role</th>
                            <th>Contact Information</th>
                            <th>Department & Year</th>
                            <th>Quota</th>
                            <th>Status</th>
                            <th class="text-end">Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:choose>
                            <c:when test="${not empty members}">
                                <c:forEach var="m" items="${members}">
                                    <tr>
                                        <td><span class="font-monospace fw-semibold text-primary">${m.memberId}</span></td>
                                        <td>
                                            <div class="fw-bold">${m.name}</div>
                                            <c:choose>
                                                <c:when test="${m.memberType == 'FACULTY'}">
                                                    <span class="badge bg-purple text-dark border small" style="background: #E9D5FF;">Faculty</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="badge bg-light text-dark border small">Student</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td>
                                            <div><i class="bi bi-envelope me-1 text-muted"></i><small>${m.email}</small></div>
                                            <div><i class="bi bi-telephone me-1 text-muted"></i><small>${m.phone}</small></div>
                                        </td>
                                        <td>
                                            <div class="fw-medium">${m.department}</div>
                                            <small class="text-muted">${m.roleDescription}</small>
                                        </td>
                                        <td>
                                            <span class="badge badge-soft-info">${m.maxBorrowLimit} Books</span>
                                        </td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${m.status == 'ACTIVE'}">
                                                    <span class="badge badge-soft-success">ACTIVE</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="badge badge-soft-danger">${m.status}</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td class="text-end">
                                            <div class="d-inline-flex gap-1">
                                                <a href="${pageContext.request.contextPath}/admin/issue?memberId=${m.memberId}" class="btn btn-sm btn-primary p-1 px-2" title="Issue Book to Member">
                                                    <i class="bi bi-arrow-up-right"></i>
                                                </a>
                                                <a href="${pageContext.request.contextPath}/admin/members?action=edit&id=${m.id}" class="btn btn-sm btn-outline-custom p-1 px-2" title="Edit Member">
                                                    <i class="bi bi-pencil"></i>
                                                </a>
                                                <a href="${pageContext.request.contextPath}/admin/members?action=delete&id=${m.id}" class="btn btn-sm btn-outline-danger p-1 px-2" title="Delete Member" data-confirm="Are you sure you want to remove member '${m.name}'?">
                                                    <i class="bi bi-trash"></i>
                                                </a>
                                            </div>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <tr>
                                    <td colspan="7">
                                        <div class="empty-state">
                                            <i class="bi bi-people empty-state-icon"></i>
                                            <div class="fw-bold">No Members Found</div>
                                            <p class="text-muted small">No patrons match the selected criteria.</p>
                                        </div>
                                    </td>
                                </tr>
                            </c:otherwise>
                        </c:choose>
                    </tbody>
                </table>
            </div>
        </div>

        <!-- Pagination -->
        <c:if test="${totalPages > 1}">
            <div class="d-flex justify-content-between align-items-center mb-4">
                <small class="text-muted">Showing page ${currentPage} of ${totalPages} (${totalCount} members total)</small>
                <nav>
                    <ul class="pagination pagination-sm mb-0">
                        <li class="page-item ${currentPage <= 1 ? 'disabled' : ''}">
                            <a class="page-link" href="${pageContext.request.contextPath}/admin/members?page=${currentPage - 1}&q=${paramQuery}&dept=${paramDept}&type=${paramType}">Previous</a>
                        </li>
                        <c:forEach begin="1" end="${totalPages}" var="p">
                            <li class="page-item ${p == currentPage ? 'active' : ''}">
                                <a class="page-link" href="${pageContext.request.contextPath}/admin/members?page=${p}&q=${paramQuery}&dept=${paramDept}&type=${paramType}">${p}</a>
                            </li>
                        </c:forEach>
                        <li class="page-item ${currentPage >= totalPages ? 'disabled' : ''}">
                            <a class="page-link" href="${pageContext.request.contextPath}/admin/members?page=${currentPage + 1}&q=${paramQuery}&dept=${paramDept}&type=${paramType}">Next</a>
                        </li>
                    </ul>
                </nav>
            </div>
        </c:if>
    </main>
</div>

<jsp:include page="/includes/footer.jsp" />
