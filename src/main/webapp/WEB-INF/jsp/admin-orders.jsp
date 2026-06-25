<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<jsp:include page="common/admin-header.jsp"/>

<section class="admin-page">
    <div class="admin-page-head">
        <div>
            <span class="admin-kicker">Orders</span>
            <h1>Quản lý đơn hàng</h1>
            <p>Theo dõi thông tin giao hàng, tổng tiền và cập nhật trạng thái xử lý.</p>
        </div>
    </div>

    <section class="admin-panel admin-filter-panel">
        <form class="admin-filter-bar compact" method="get" action="<c:url value='/admin/orders'/>">
            <div>
                <label for="orderKeyword">Tìm kiếm</label>
                <input id="orderKeyword" type="search" name="keyword" value="${fn:escapeXml(keyword)}" placeholder="Tên khách hàng hoặc số điện thoại">
            </div>
            <div class="admin-filter-actions">
                <button class="admin-submit" type="submit">Tìm</button>
                <a class="admin-secondary-action" href="<c:url value='/admin/orders'/>">Đặt lại</a>
            </div>
        </form>
    </section>

    <div class="admin-panel">
        <div class="admin-table-wrap">
            <table class="admin-table">
                <thead>
                <tr>
                    <th>Khách hàng</th>
                    <th>Liên hệ</th>
                    <th>Tổng tiền</th>
                    <th>Trạng thái</th>
                    <th></th>
                </tr>
                </thead>
                <tbody>
                <c:forEach items="${orders}" var="order">
                    <tr>
                        <td>
                            <strong>${order.customerName}</strong>
                        </td>
                        <td>
                            <span>
                                <c:choose>
                                    <c:when test="${not empty order.phone}">${order.phone}</c:when>
                                    <c:otherwise>Chưa có SĐT</c:otherwise>
                                </c:choose>
                            </span>
                        </td>
                        <td><strong><fmt:formatNumber value="${order.totalAmount}" type="number"/>đ</strong></td>
                        <td><span class="admin-status status-${order.orderStatus}">${order.orderStatus}</span></td>
                        <td><a class="admin-link" href="<c:url value='/admin/orders/${order.id}'/>">Chi tiết</a></td>
                    </tr>
                </c:forEach>
                <c:if test="${empty orders}">
                    <tr>
                        <td colspan="5" class="admin-empty-row">Không tìm thấy đơn hàng phù hợp.</td>
                    </tr>
                </c:if>
                </tbody>
            </table>
        </div>
    </div>
</section>

<jsp:include page="common/admin-footer.jsp"/>
