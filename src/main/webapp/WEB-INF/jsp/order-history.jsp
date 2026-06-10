<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<c:set var="pageCss" value="cart.css" scope="request"/>
<jsp:include page="common/header.jsp"/>

<section class="section soft orders-page">
    <div class="container">
        <div class="section-title checkout-title reveal-on-scroll">
            <span class="eyebrow">Theo dõi bữa ăn</span>
            <h2>Đơn hàng của tôi</h2>
            <p>Xem lại các đơn đã đặt và trạng thái xử lý hiện tại.</p>
        </div>

        <div class="orders-panel panel reveal-on-scroll">
            <c:choose>
                <c:when test="${empty orders}">
                    <div class="empty-cart-panel compact">
                        <h3>Bạn chưa có đơn hàng nào</h3>
                        <p>Chọn thực đơn healthy đầu tiên để bắt đầu nhé.</p>
                        <a class="btn" href="<c:url value='/products'/>">Xem thực đơn</a>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="orders-list">
                        <c:forEach items="${orders}" var="order" varStatus="loop">
                            <c:set var="statusClass" value="status-${fn:toLowerCase(order.orderStatus)}"/>
                            <article class="order-card" style="--delay:${loop.index * 70}ms">
                                <div class="order-card-main">
                                    <span class="order-code">#${order.id}</span>
                                    <div>
                                        <h3>${order.customerName}</h3>
                                        <p>${order.address}</p>
                                    </div>
                                </div>
                                <div class="order-card-total">
                                    <small>Tổng tiền</small>
                                    <strong><fmt:formatNumber value="${order.totalAmount}" type="number"/>đ</strong>
                                </div>
                                <span class="status-badge ${statusClass}">${order.orderStatus}</span>
                                <a class="btn small secondary" href="<c:url value='/orders/${order.id}'/>">Chi tiết</a>
                            </article>
                        </c:forEach>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</section>

<jsp:include page="common/footer.jsp"/>
