<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<jsp:include page="common/admin-header.jsp"/>

<section class="admin-page">
    <div class="admin-page-head">
        <div>
            <h1>Tổng quan vận hành</h1>
        </div>
        <a class="admin-primary-action" href="<c:url value='/admin/products/new'/>">Thêm sản phẩm</a>
    </div>

    <div class="admin-stats-grid dashboard-stats">
        <article class="admin-stat-card revenue">
            <span>Doanh thu hoàn tất</span>
            <strong><fmt:formatNumber value="${totalRevenue}" type="number"/>đ</strong>
        </article>
        <article class="admin-stat-card">
            <span>Người dùng</span>
            <strong>${userCount}</strong>
        </article>
        <article class="admin-stat-card">
            <span>Tổng đơn hàng</span>
            <strong>${orderCount}</strong>
        </article>
        <article class="admin-stat-card">
            <span>Thông báo mới</span>
            <strong>${adminUnreadNotificationCount}</strong>
        </article>
    </div>

    <section class="admin-panel revenue-panel">
        <div class="admin-panel-head revenue-head">
            <div>
                <h2>Doanh thu theo thời gian</h2>
            </div>
            <div class="admin-range-tabs">
                <a class="${period == 'week' ? 'active' : ''}" href="${pageContext.request.contextPath}/admin?period=week">Tuần</a>
                <a class="${period == 'month' ? 'active' : ''}" href="${pageContext.request.contextPath}/admin?period=month">Tháng</a>
                <a class="${period == 'year' ? 'active' : ''}" href="${pageContext.request.contextPath}/admin?period=year">Năm</a>
            </div>
        </div>

        <div class="revenue-summary-grid">
            <article>
                <span>Doanh thu kỳ này</span>
                <strong><fmt:formatNumber value="${periodRevenue}" type="number"/>đ</strong>
            </article>
            <article>
                <span>Đơn hoàn tất</span>
                <strong>${periodOrderCount}</strong>
            </article>
            <article>
                <span>Trung bình mỗi đơn</span>
                <strong><fmt:formatNumber value="${averageOrderValue}" type="number"/>đ</strong>
            </article>
        </div>

        <div class="revenue-chart-wrap">
            <div class="revenue-bars">
                <c:forEach items="${revenueChart}" var="point">
                    <div class="revenue-bar-item" title="${point.label}: ${point.revenue}">
                        <div class="revenue-bar-track">
                            <span style="height: ${point.percent}%"></span>
                        </div>
                        <small>${point.label}</small>
                    </div>
                </c:forEach>
            </div>
            <svg class="revenue-line-chart" viewBox="0 0 100 100" preserveAspectRatio="none" aria-hidden="true">
                <polyline points="${lineChartPoints}" />
            </svg>
        </div>
    </section>

    <div class="admin-dashboard-grid">
        <section class="admin-panel">
            <div class="admin-panel-head">
                <div>
                    <h2>Đơn hàng gần đây</h2>
                </div>
                <a href="<c:url value='/admin/orders'/>">Xem tất cả</a>
            </div>
            <div class="admin-table-wrap">
                <table class="admin-table">
                    <thead>
                    <tr>
                        <th>Mã</th>
                        <th>Khách hàng</th>
                        <th>Tổng tiền</th>
                        <th>Trạng thái</th>
                        <th></th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:forEach items="${recentOrders}" var="order">
                        <tr>
                            <td>#${order.id}</td>
                            <td>${order.customerName}</td>
                            <td><fmt:formatNumber value="${order.totalAmount}" type="number"/>đ</td>
                            <td><span class="admin-status status-${order.orderStatus}">${order.orderStatus}</span></td>
                            <td><a class="admin-link" href="<c:url value='/admin/orders/${order.id}'/>">Chi tiết</a></td>
                        </tr>
                    </c:forEach>
                    <c:if test="${empty recentOrders}">
                        <tr>
                            <td colspan="5" class="admin-empty-row">Chưa có đơn hàng nào.</td>
                        </tr>
                    </c:if>
                    </tbody>
                </table>
            </div>
        </section>

        <aside class="admin-panel">
            <div class="admin-panel-head">
                <div>
                    <h2>Tình trạng</h2>
                </div>
            </div>
            <div class="ops-list">
                <div><span>Đơn chờ xử lý</span><strong>${pendingOrderCount}</strong></div>
                <div><span>Đơn hoàn tất</span><strong>${completedOrderCount}</strong></div>
                <div><span>Danh mục</span><strong>${categoryCount}</strong></div>
                <div><span>Sản phẩm active</span><strong>${activeProductCount}</strong></div>
            </div>
        </aside>
    </div>
</section>

<jsp:include page="common/admin-footer.jsp"/>