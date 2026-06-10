<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<jsp:include page="common/admin-header.jsp"/>

<section class="admin-page">
    <div class="admin-page-head">
        <div>
            <span class="admin-kicker">Orders</span>
            <h1>Quản lý đơn hàng</h1>
            <p>Theo dõi thông tin giao hàng, tổng tiền và cập nhật trạng thái xử lý.</p>
        </div>
    </div>

    <div class="admin-panel">
        <div class="admin-table-wrap">
            <table class="admin-table">
                <thead>
                <tr>
                    <th>Mã</th>
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
                        <td>#${order.id}</td>
                        <td>
                            <strong>${order.customerName}</strong>
                        </td>
                        <td>
                            <span>${order.phone}</span>
                            <small>${order.email}</small>
                        </td>
                        <td><strong><fmt:formatNumber value="${order.totalAmount}" type="number"/>đ</strong></td>
                        <td><span class="admin-status status-${order.orderStatus}">${order.orderStatus}</span></td>
                        <td><a class="admin-link" href="<c:url value='/admin/orders/${order.id}'/>">Chi tiết</a></td>
                    </tr>
                </c:forEach>
                <c:if test="${empty orders}">
                    <tr>
                        <td colspan="6" class="admin-empty-row">Chưa có đơn hàng nào.</td>
                    </tr>
                </c:if>
                </tbody>
            </table>
        </div>
    </div>
</section>

<jsp:include page="common/admin-footer.jsp"/>
