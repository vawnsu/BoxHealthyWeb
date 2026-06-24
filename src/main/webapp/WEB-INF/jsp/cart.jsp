<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<c:set var="pageCss" value="cart.css" scope="request"/>
<jsp:include page="common/header.jsp"/>

<section class="section soft cart-page">
    <div class="container">
        <div class="section-title checkout-title reveal-on-scroll">
            <span class="eyebrow">Giỏ món của bạn</span>
            <h2>Giỏ hàng</h2>
            <p>Kiểm tra khẩu phần, số lượng và tổng tiền trước khi đặt bữa.</p>
        </div>

        <c:choose>
            <c:when test="${empty items}">
                <div class="empty-cart-panel reveal-on-scroll">
                    <div class="empty-cart-icon">
                        <svg class="icon" viewBox="0 0 24 24" aria-hidden="true">
                            <circle cx="8" cy="21" r="1"></circle>
                            <circle cx="19" cy="21" r="1"></circle>
                            <path d="M2.05 2.05h2l2.66 12.42a2 2 0 0 0 2 1.58h8.95a2 2 0 0 0 1.95-1.57l1.35-6.43H5.12"></path>
                        </svg>
                    </div>
                    <h3>Giỏ hàng đang trống</h3>
                    <p>Chọn vài hộp cơm healthy để Box Healthy chuẩn bị bữa ăn cho bạn nhé.</p>
                    <a class="btn" href="<c:url value='/products'/>">Xem thực đơn</a>
                </div>
            </c:when>
            <c:otherwise>
                <div class="cart-layout">
                    <div class="cart-list reveal-on-scroll">
                        <div class="cart-list-head">
                            <span>Sản phẩm</span>
                            <span>Giá</span>
                            <span>Số lượng</span>
                            <span>Tạm tính</span>
                        </div>

                        <c:forEach items="${items}" var="item" varStatus="loop">
                            <c:set var="productImage" value="${item.product.imageUrl}"/>
                            <c:if test="${not fn:startsWith(item.product.imageUrl, 'http')}">
                                <c:set var="productImage" value="${pageContext.request.contextPath}${item.product.imageUrl}"/>
                            </c:if>
                            <article class="cart-item" style="--delay:${loop.index * 70}ms">
                                <a class="cart-product" href="<c:url value='/products/${item.product.id}'/>">
                                    <img src="${productImage}" alt="${item.product.name}" onerror="this.onerror=null;this.src='${pageContext.request.contextPath}/images/product-1.svg';">
                                    <span>
                                        <strong>${item.product.name}</strong>
                                        <small>${item.product.calories} kcal · ${item.product.protein}g protein</small>
                                    </span>
                                </a>

                                <div class="cart-price">
                                    <fmt:formatNumber value="${item.product.price}" type="number"/>đ
                                </div>

                                <form class="quantity-form" action="<c:url value='/cart/update/${item.product.id}'/>" method="post">
                                    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}">
                                    <input type="number" min="0" name="quantity" value="${item.quantity}" aria-label="Số lượng ${item.product.name}">
                                    <button class="cart-update-button" type="submit" aria-label="Cập nhật số lượng ${item.product.name}">
                                        <svg class="icon" viewBox="0 0 24 24" aria-hidden="true">
                                            <path d="M21 12a9 9 0 0 1-15.4 6.4L3 16"></path>
                                            <path d="M3 21v-5h5"></path>
                                            <path d="M3 12a9 9 0 0 1 15.4-6.4L21 8"></path>
                                            <path d="M21 3v5h-5"></path>
                                        </svg>
                                        <span>Cập nhật</span>
                                    </button>
                                </form>

                                <div class="cart-subtotal">
                                    <strong><fmt:formatNumber value="${item.subtotal}" type="number"/>đ</strong>
                                    <form action="<c:url value='/cart/remove/${item.product.id}'/>" method="post">
                                        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}">
                                        <button class="icon-danger-button" type="submit" title="Xóa khỏi giỏ" aria-label="Xóa ${item.product.name}">
                                            <svg class="icon" viewBox="0 0 24 24" aria-hidden="true">
                                                <path d="M3 6h18"></path>
                                                <path d="M8 6V4h8v2"></path>
                                                <path d="M19 6l-1 14H6L5 6"></path>
                                                <path d="M10 11v6"></path>
                                                <path d="M14 11v6"></path>
                                            </svg>
                                        </button>
                                    </form>
                                </div>
                            </article>
                        </c:forEach>
                    </div>

                    <aside class="order-summary reveal-on-scroll">
                        <span class="summary-badge">Sẵn sàng đặt món</span>
                        <h3>Tóm tắt giỏ hàng</h3>
                        <div class="summary-row">
                            <span>Số món</span>
                            <strong>${fn:length(items)}</strong>
                        </div>
                        <div class="summary-row">
                            <span>Phí giao hàng</span>
                            <strong>Miễn phí</strong>
                        </div>
                        <div class="summary-total">
                            <span>Tổng thanh toán</span>
                            <strong><fmt:formatNumber value="${total}" type="number"/>đ</strong>
                        </div>
                        <a class="btn summary-button" href="<c:url value='/checkout'/>">
                            Thanh toán
                            <svg class="icon" viewBox="0 0 24 24" aria-hidden="true">
                                <path d="M5 12h14"></path>
                                <path d="m12 5 7 7-7 7"></path>
                            </svg>
                        </a>
                        <a class="continue-link" href="<c:url value='/products'/>">Tiếp tục chọn món</a>
                    </aside>
                </div>
            </c:otherwise>
        </c:choose>
    </div>
</section>

<jsp:include page="common/footer.jsp"/>
