<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<jsp:include page="common/admin-header.jsp"/>

<section class="admin-page">
    <div class="admin-page-head">
        <div>
            <span class="admin-kicker">Notifications</span>
            <h1>Thông báo</h1>
            <p>Nhận nhanh đơn mới và xác nhận chuyển khoản từ khách hàng.</p>
        </div>
        <form action="<c:url value='/admin/notifications/read-all'/>" method="post">
            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}">
            <button class="admin-secondary-action" type="submit">Đánh dấu đã đọc</button>
        </form>
    </div>

    <section class="admin-panel">
        <div class="admin-notification-list">
            <c:forEach items="${notifications}" var="notification">
                <article class="admin-notification ${empty notification.readAt ? 'is-unread' : ''}">
                    <div class="admin-notification-dot"></div>
                    <div>
                        <div class="admin-notification-head">
                            <strong>${notification.title}</strong>
                            <time>${notification.createdAt}</time>
                        </div>
                        <p>${notification.message}</p>
                        <div class="admin-notification-actions">
                            <a class="admin-link" href="<c:url value='${notification.targetUrl}'/>">Xem đơn hàng</a>
                            <c:if test="${empty notification.readAt}">
                                <form action="<c:url value='/admin/notifications/${notification.id}/read'/>" method="post">
                                    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}">
                                    <button class="admin-link-button" type="submit">Đã đọc</button>
                                </form>
                            </c:if>
                        </div>
                    </div>
                </article>
            </c:forEach>
            <c:if test="${empty notifications}">
                <div class="admin-empty-row">Chưa có thông báo nào.</div>
            </c:if>
        </div>
    </section>
</section>

<jsp:include page="common/admin-footer.jsp"/>
