<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<jsp:include page="common/admin-header.jsp"/>

<section class="admin-page">
    <div class="admin-page-head">
        <div>
            <h1>Quản lý tài khoản</h1>
        </div>
    </div>

    <c:if test="${not empty adminUserMessage}">
        <div class="admin-alert success">${adminUserMessage}</div>
    </c:if>
    <c:if test="${not empty adminUserError}">
        <div class="admin-alert danger">${adminUserError}</div>
    </c:if>

    <div class="admin-stats-grid">
        <article class="admin-stat-card">
            <span>Tổng tài khoản</span>
            <strong>${totalUsers}</strong>
        </article>
        <article class="admin-stat-card">
            <span>Khách hàng</span>
            <strong>${customerCount}</strong>
        </article>
        <article class="admin-stat-card">
            <span>Admin</span>
            <strong>${adminCount}</strong>
        </article>
        <article class="admin-stat-card">
            <span>Đang hoạt động</span>
            <strong>${enabledUserCount}</strong>
        </article>
    </div>

    <section class="admin-panel admin-filter-panel">
        <form class="admin-filter-bar compact" method="get" action="<c:url value='/admin/users'/>">
            <div>
                <label for="roleFilter">Lọc theo vai trò</label>
                <select id="roleFilter" name="role">
                    <option value="">Tất cả vai trò</option>
                    <c:forEach items="${roles}" var="roleItem">
                        <option value="${roleItem}" ${roleItem == selectedRole ? 'selected' : ''}>${roleItem}</option>
                    </c:forEach>
                </select>
            </div>
            <div class="admin-filter-actions">
                <button class="admin-submit" type="submit">Lọc</button>
                <a class="admin-secondary-action" href="<c:url value='/admin/users'/>">Đặt lại</a>
            </div>
        </form>
    </section>

    <section class="admin-panel">
        <div class="admin-panel-head">
            <div>
                <h2>Danh sách tài khoản</h2>
            </div>
        </div>

        <div class="admin-table-wrap">
            <table class="admin-table admin-user-table">
                <thead>
                <tr>
                    <th>Người dùng</th>
                    <th>Liên hệ</th>
                    <th>Vai trò</th>
                    <th>Trạng thái</th>
                    <th>Ngày tạo</th>
                    <th></th>
                </tr>
                </thead>
                <tbody>
                <c:forEach items="${users}" var="user">
                    <tr>
                        <td>
                            <div class="admin-user-cell">
                                <span class="admin-user-avatar">
                                    <c:choose>
                                        <c:when test="${not empty user.fullName}">${fn:toUpperCase(fn:substring(user.fullName, 0, 1))}</c:when>
                                        <c:otherwise>${fn:toUpperCase(fn:substring(user.email, 0, 1))}</c:otherwise>
                                    </c:choose>
                                </span>
                                <div>
                                    <strong>
                                        <c:choose>
                                            <c:when test="${not empty user.fullName}">${user.fullName}</c:when>
                                            <c:otherwise>Chưa cập nhật tên</c:otherwise>
                                        </c:choose>
                                    </strong>
                                    <small>${user.email}</small>
                                </div>
                            </div>
                        </td>
                        <td>
                            <div class="admin-user-contact">
                                <span>
                                    <c:choose>
                                        <c:when test="${not empty user.phone}">${user.phone}</c:when>
                                        <c:otherwise>Chưa có SĐT</c:otherwise>
                                    </c:choose>
                                </span>
                                <small>
                                    <c:choose>
                                        <c:when test="${not empty user.address}">${user.address}</c:when>
                                        <c:otherwise>Chưa có địa chỉ</c:otherwise>
                                    </c:choose>
                                </small>
                            </div>
                        </td>
                        <td><span class="admin-role role-${user.role}">${user.role}</span></td>
                        <td>
                            <c:choose>
                                <c:when test="${user.enabled}"><span class="admin-status user-enabled">ACTIVE</span></c:when>
                                <c:otherwise><span class="admin-status user-disabled">LOCKED</span></c:otherwise>
                            </c:choose>
                        </td>
                        <td>${user.createdAt}</td>
                        <td>
                            <c:choose>
                                <c:when test="${user.role == 'CUSTOMER'}">
                                    <form action="<c:url value='/admin/users/${user.id}/status'/>" method="post">
                                        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}">
                                        <input type="hidden" name="enabled" value="${!user.enabled}">
                                        <c:if test="${not empty selectedRole}">
                                            <input type="hidden" name="role" value="${selectedRole}">
                                        </c:if>
                                        <button class="${user.enabled ? 'admin-danger' : 'admin-link-button'}" type="submit">
                                            ${user.enabled ? 'Khóa' : 'Mở khóa'}
                                        </button>
                                    </form>
                                </c:when>
                                <c:otherwise><span class="admin-muted">Quản trị</span></c:otherwise>
                            </c:choose>
                        </td>
                    </tr>
                </c:forEach>
                <c:if test="${empty users}">
                    <tr>
                        <td colspan="6" class="admin-empty-row">Không tìm thấy tài khoản phù hợp.</td>
                    </tr>
                </c:if>
                </tbody>
            </table>
        </div>
    </section>
</section>

<jsp:include page="common/admin-footer.jsp"/>