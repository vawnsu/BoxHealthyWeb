<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<jsp:include page="common/admin-header.jsp"/>

<section class="admin-page">
    <div class="admin-page-head">
        <div>
            <span class="admin-kicker">Order Detail</span>
            <h1>Đơn hàng #${order.id}</h1>
            <p>${order.customerName} · ${order.phone}</p>
        </div>
        <a class="admin-secondary-action" href="<c:url value='/admin/orders'/>">Quay lại</a>
    </div>

    <div class="admin-order-layout">
        <section class="admin-panel">
            <div class="admin-panel-head">
                <div>
                    <h2>Sản phẩm trong đơn</h2>
                    <p>Kiểm tra món, số lượng và tạm tính.</p>
                </div>
                <span class="admin-status status-${order.orderStatus}">${order.orderStatus}</span>
            </div>
            <div class="admin-order-items">
                <c:forEach items="${details}" var="detail">
                    <c:set var="productImage" value="${detail.product.imageUrl}"/>
                    <c:if test="${not fn:startsWith(detail.product.imageUrl, 'http')}">
                        <c:set var="productImage" value="${pageContext.request.contextPath}${detail.product.imageUrl}"/>
                    </c:if>
                    <article class="admin-order-item">
                        <img src="${productImage}" alt="${detail.product.name}" onerror="this.onerror=null;this.src='${pageContext.request.contextPath}/images/product-1.svg';">
                        <div>
                            <strong>${detail.product.name}</strong>
                            <small>x ${detail.quantity}</small>
                        </div>
                        <span><fmt:formatNumber value="${detail.price}" type="number"/>đ</span>
                        <strong><fmt:formatNumber value="${detail.subtotal}" type="number"/>đ</strong>
                    </article>
                </c:forEach>
            </div>
        </section>

        <aside class="admin-panel">
            <div class="admin-panel-head">
                <div>
                    <h2>Cập nhật đơn</h2>
                    <p>Thông tin giao hàng và trạng thái.</p>
                </div>
            </div>
            <div class="admin-info-list">
                <div><span>Khách hàng</span><strong>${order.customerName}</strong></div>
                <div><span>Số điện thoại</span><strong>${order.phone}</strong></div>
                <div><span>Email</span><strong>${order.email}</strong></div>
                <div><span>Địa chỉ</span><strong>${order.address}</strong></div>
                <div><span>Tổng tiền</span><strong><fmt:formatNumber value="${order.totalAmount}" type="number"/>đ</strong></div>
            </div>
            <form class="admin-status-form" action="<c:url value='/admin/orders/${order.id}/status'/>" method="post">
                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}">
                <label>Trạng thái đơn</label>
                <select name="status">
                    <c:forEach items="${statuses}" var="status">
                        <option value="${status}" ${status == order.orderStatus ? 'selected' : ''}>${status}</option>
                    </c:forEach>
                </select>
                <button class="admin-submit" type="submit">Cập nhật trạng thái</button>
            </form>
        </aside>
    </div>
</section>

<jsp:include page="common/admin-footer.jsp"/>
