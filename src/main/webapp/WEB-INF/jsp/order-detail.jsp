<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<c:set var="pageCss" value="cart.css" scope="request"/>
<jsp:include page="common/header.jsp"/>

<c:set var="statusClass" value="status-${fn:toLowerCase(order.orderStatus)}"/>
<c:set var="statusLabel" value="${order.orderStatus}"/>
<c:choose>
    <c:when test="${order.orderStatus == 'PENDING'}"><c:set var="statusLabel" value="Chờ xác nhận"/></c:when>
    <c:when test="${order.orderStatus == 'CONFIRMED'}"><c:set var="statusLabel" value="Đã xác nhận"/></c:when>
    <c:when test="${order.orderStatus == 'SHIPPING'}"><c:set var="statusLabel" value="Đang giao"/></c:when>
    <c:when test="${order.orderStatus == 'COMPLETED'}"><c:set var="statusLabel" value="Hoàn tất"/></c:when>
    <c:when test="${order.orderStatus == 'CANCELLED'}"><c:set var="statusLabel" value="Đã hủy"/></c:when>
</c:choose>

<section class="section soft order-detail-page">
    <div class="container">
        <div class="order-detail-shell reveal-on-scroll">
            <div class="order-detail-hero ${statusClass}">
                <div>
                    <a class="back-link" href="<c:url value='/orders'/>">
                        <svg class="icon" viewBox="0 0 24 24" aria-hidden="true">
                            <path d="m15 18-6-6 6-6"></path>
                        </svg>
                        Quay lại đơn hàng
                    </a>
                    <span class="eyebrow">Chi tiết đơn hàng</span>
                    <h1>Đơn hàng #${order.id}</h1>
                    <p>Kiểm tra trạng thái xử lý, địa chỉ giao hàng và từng món trong đơn.</p>
                </div>
                <div class="status-orb ${statusClass}">
                    <span>${statusLabel}</span>
                    <strong><fmt:formatNumber value="${order.totalAmount}" type="number"/>đ</strong>
                </div>
            </div>

            <div class="order-detail-layout refined">
                <main class="panel order-track-panel">
                    <div class="panel-heading">
                        <div>
                            <span class="eyebrow">Theo dõi trạng thái</span>
                            <h2>${statusLabel}</h2>
                        </div>
                        <span class="status-badge ${statusClass}">${statusLabel}</span>
                    </div>

                    <div class="status-timeline ${statusClass}">
                        <div class="timeline-step step-pending">
                            <span>
                                <svg class="icon" viewBox="0 0 24 24" aria-hidden="true">
                                    <path d="M8 2h8"></path>
                                    <path d="M12 6v6l4 2"></path>
                                    <circle cx="12" cy="14" r="8"></circle>
                                </svg>
                            </span>
                            <strong>Chờ xác nhận</strong>
                            <small>Box Healthy đã nhận đơn</small>
                        </div>
                        <div class="timeline-step step-confirmed">
                            <span>
                                <svg class="icon" viewBox="0 0 24 24" aria-hidden="true">
                                    <path d="M20 6 9 17l-5-5"></path>
                                </svg>
                            </span>
                            <strong>Đã xác nhận</strong>
                            <small>Đang chuẩn bị bữa ăn</small>
                        </div>
                        <div class="timeline-step step-shipping">
                            <span>
                                <svg class="icon" viewBox="0 0 24 24" aria-hidden="true">
                                    <path d="M14 18V6a2 2 0 0 0-2-2H4v14"></path>
                                    <path d="M15 18H9"></path>
                                    <path d="M19 18h1a2 2 0 0 0 2-2v-3.6a1 1 0 0 0-.3-.7L19 9h-5"></path>
                                    <circle cx="7" cy="18" r="2"></circle>
                                    <circle cx="17" cy="18" r="2"></circle>
                                </svg>
                            </span>
                            <strong>Đang giao</strong>
                            <small>Shipper đang trên đường</small>
                        </div>
                        <div class="timeline-step step-completed">
                            <span>
                                <svg class="icon" viewBox="0 0 24 24" aria-hidden="true">
                                    <path d="M6 2 3 6v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2V6l-3-4Z"></path>
                                    <path d="M3 6h18"></path>
                                    <path d="M16 10a4 4 0 0 1-8 0"></path>
                                </svg>
                            </span>
                            <strong>Hoàn tất</strong>
                            <small>Bữa ăn đã được giao</small>
                        </div>
                    </div>

                    <div class="delivery-card ${statusClass}">
                        <div class="delivery-icon">
                            <svg class="icon" viewBox="0 0 24 24" aria-hidden="true">
                                <path d="M20 10c0 6-8 12-8 12S4 16 4 10a8 8 0 1 1 16 0Z"></path>
                                <circle cx="12" cy="10" r="3"></circle>
                            </svg>
                        </div>
                        <div>
                            <span>Địa chỉ giao hàng</span>
                            <strong>${order.address}</strong>
                            <small>
                                Người nhận: ${order.customerName}
                                <c:if test="${not empty order.phone}"> · ${order.phone}</c:if>
                            </small>
                        </div>
                    </div>

                    <div class="detail-section-head">
                        <div>
                            <span class="eyebrow">Sản phẩm trong đơn</span>
                            <h2>Meal prep đã chọn</h2>
                        </div>
                        <strong>${fn:length(details)} món</strong>
                    </div>

                    <div class="detail-products refined">
                        <c:forEach items="${details}" var="detail" varStatus="loop">
                            <c:set var="productImage" value="${detail.product.imageUrl}"/>
                            <c:if test="${empty productImage}">
                                <c:set var="productImage" value="/images/product-1.svg"/>
                            </c:if>
                            <c:if test="${not fn:startsWith(productImage, 'http')}">
                                <c:set var="productImage" value="${pageContext.request.contextPath}${productImage}"/>
                            </c:if>
                            <article class="detail-product refined" style="--delay:${loop.index * 80}ms">
                                <a class="detail-product-image" href="<c:url value='/products/${detail.product.id}'/>">
                                    <img src="${productImage}" alt="${detail.product.name}">
                                </a>
                                <div class="detail-product-info">
                                    <a href="<c:url value='/products/${detail.product.id}'/>">${detail.product.name}</a>
                                    <p>${detail.product.calories} kcal · ${detail.product.protein}g protein · ${detail.product.carbs}g carbs · ${detail.product.fat}g fat</p>
                                    <div class="macro-chips">
                                        <span>${detail.product.calories} kcal</span>
                                        <span>${detail.product.protein}g protein</span>
                                        <span>x ${detail.quantity}</span>
                                    </div>
                                </div>
                                <div class="detail-product-money">
                                    <small>Đơn giá</small>
                                    <span><fmt:formatNumber value="${detail.price}" type="number"/>đ</span>
                                    <strong><fmt:formatNumber value="${detail.subtotal}" type="number"/>đ</strong>
                                </div>
                            </article>
                        </c:forEach>
                    </div>
                </main>

                <aside class="panel order-info refined">
                    <span class="eyebrow">Thông tin nhận hàng</span>
                    <h3>${order.customerName}</h3>

                    <div class="info-row">
                        <span>Số điện thoại</span>
                        <strong>${order.phone}</strong>
                    </div>
                    <div class="info-row">
                        <span>Email</span>
                        <strong>${order.email}</strong>
                    </div>
                    <div class="info-row address-row">
                        <span>Địa chỉ</span>
                        <strong>${order.address}</strong>
                    </div>
                    <div class="info-row">
                        <span>Thời gian giao</span>
                        <strong>${order.deliveryTime}</strong>
                    </div>
                    <div class="info-row">
                        <span>Thanh toán</span>
                        <strong>${order.paymentMethod}</strong>
                    </div>
                    <c:if test="${not empty order.note}">
                        <div class="order-note">
                            <span>Ghi chú</span>
                            <p>${order.note}</p>
                        </div>
                    </c:if>

                    <div class="summary-total">
                        <span>Tổng đơn</span>
                        <strong><fmt:formatNumber value="${order.totalAmount}" type="number"/>đ</strong>
                    </div>
                </aside>
            </div>
        </div>
    </div>
</section>

<jsp:include page="common/footer.jsp"/>
