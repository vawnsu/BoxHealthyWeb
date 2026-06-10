<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<c:set var="pageCss" value="cart.css" scope="request"/>
<jsp:include page="common/header.jsp"/>

<section class="section soft checkout-page">
    <div class="container">
        <div class="section-title checkout-title reveal-on-scroll">
            <span class="eyebrow">Hoàn tất đơn hàng</span>
            <h2>Thanh toán</h2>
            <p>Nhập thông tin giao hàng để Box Healthy chuẩn bị bữa ăn đúng giờ cho bạn.</p>
        </div>

        <div class="checkout-layout">
            <form class="checkout-form panel reveal-on-scroll" action="<c:url value='/checkout'/>" method="post">
                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}">
                <div class="panel-heading">
                    <div>
                        <span class="eyebrow">Thông tin nhận hàng</span>
                        <h3>Giao đến đâu?</h3>
                    </div>
                    <div class="panel-icon">
                        <svg class="icon" viewBox="0 0 24 24" aria-hidden="true">
                            <path d="M20 10c0 6-8 12-8 12S4 16 4 10a8 8 0 1 1 16 0Z"></path>
                            <circle cx="12" cy="10" r="3"></circle>
                        </svg>
                    </div>
                </div>

                <c:if test="${not empty error}"><div class="alert">${error}</div></c:if>

                <div class="form-grid">
                    <div>
                        <label>Họ tên</label>
                        <input name="customerName" value="${checkoutRequest.customerName}" placeholder="Nguyễn Văn A" required>
                    </div>
                    <div>
                        <label>Số điện thoại</label>
                        <input name="phone" value="${checkoutRequest.phone}" placeholder="0909123456" required>
                    </div>
                    <div>
                        <label>Email</label>
                        <input type="email" name="email" value="${checkoutRequest.email}" placeholder="you@email.com">
                    </div>
                    <div>
                        <label>Thời gian giao hàng</label>
                        <input name="deliveryTime" value="${checkoutRequest.deliveryTime}" placeholder="VD: 11:30 hôm nay">
                    </div>
                    <div class="full">
                        <label>Địa chỉ</label>
                        <input name="address" value="${checkoutRequest.address}" placeholder="Số nhà, đường, phường/xã..." required>
                    </div>
                    <div class="full">
                        <label>Ghi chú</label>
                        <textarea name="note" rows="4" placeholder="Ít cay, thêm muỗng, gọi trước khi giao...">${checkoutRequest.note}</textarea>
                    </div>
                    <div class="full">
                        <label>Phương thức thanh toán</label>
                        <select name="paymentMethod">
                            <option value="COD">Thanh toán khi nhận hàng</option>
                            <option value="BANK_TRANSFER">Chuyển khoản ngân hàng</option>
                        </select>
                    </div>
                </div>

                <button class="checkout-submit" type="submit">
                    Đặt hàng
                    <svg class="icon" viewBox="0 0 24 24" aria-hidden="true">
                        <path d="M5 12h14"></path>
                        <path d="m12 5 7 7-7 7"></path>
                    </svg>
                </button>
            </form>

            <aside class="checkout-summary panel reveal-on-scroll">
                <div class="panel-heading">
                    <div>
                        <span class="eyebrow">Đơn hàng của bạn</span>
                        <h3>Bữa ăn đã chọn</h3>
                    </div>
                    <div class="panel-icon">
                        <svg class="icon" viewBox="0 0 24 24" aria-hidden="true">
                            <path d="M6 2 3 6v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2V6l-3-4Z"></path>
                            <path d="M3 6h18"></path>
                            <path d="M16 10a4 4 0 0 1-8 0"></path>
                        </svg>
                    </div>
                </div>

                <div class="summary-items">
                    <c:forEach items="${items}" var="item" varStatus="loop">
                        <c:set var="productImage" value="${item.product.imageUrl}"/>
                        <c:if test="${not fn:startsWith(item.product.imageUrl, 'http')}">
                            <c:set var="productImage" value="${pageContext.request.contextPath}${item.product.imageUrl}"/>
                        </c:if>
                        <div class="summary-item" style="--delay:${loop.index * 70}ms">
                            <img src="${productImage}" alt="${item.product.name}">
                            <div>
                                <strong>${item.product.name}</strong>
                                <small>x ${item.quantity} · ${item.product.calories} kcal</small>
                            </div>
                            <span><fmt:formatNumber value="${item.subtotal}" type="number"/>đ</span>
                        </div>
                    </c:forEach>
                </div>

                <div class="checkout-benefits">
                    <span>Đóng gói sạch</span>
                    <span>Đủ macro</span>
                    <span>Giao đúng giờ</span>
                </div>

                <div class="summary-total">
                    <span>Tổng thanh toán</span>
                    <strong><fmt:formatNumber value="${total}" type="number"/>đ</strong>
                </div>
            </aside>
        </div>
    </div>
</section>

<jsp:include page="common/footer.jsp"/>
