<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<c:set var="pageCss" value="home.css" scope="request"/>
<jsp:include page="common/header.jsp"/>

<section class="hero" data-hero-slider>
    <div class="hero-slider" aria-hidden="true">
        <img class="hero-slide is-active" src="https://images.unsplash.com/photo-1546069901-ba9599a7e63c?auto=format&fit=crop&w=1800&q=85" alt="">
        <img class="hero-slide" src="https://images.unsplash.com/photo-1490645935967-10de6ba17061?auto=format&fit=crop&w=1800&q=85" alt="">
        <img class="hero-slide" src="https://images.unsplash.com/photo-1505576399279-565b52d4ac71?auto=format&fit=crop&w=1800&q=85" alt="">
    </div>
    <div class="hero-overlay">
        <div class="container hero-content">
            <p class="hero-kicker">Meal prep healthy mỗi ngày</p>
            <h1>Box Healthy</h1>
            <p class="lead">Nhanh - Tiện - Khỏe</p>
            <p class="hero-copy">Bữa ăn đóng gói sẵn, đủ chất và dễ theo đuổi cho lịch bận rộn. Chọn món, đặt nhanh, nhận bữa ăn lành mạnh mỗi ngày.</p>
            <div class="hero-actions">
                <a class="btn" href="<c:url value='/products'/>">Xem thực đơn</a>
                <a class="btn secondary" href="<c:url value='/tdee'/>">Tính TDEE</a>
            </div>
            <div class="hero-tags">
                <span>Ăn lành</span>
                <span>Đủ macro</span>
                <span>Giao tiện lợi</span>
            </div>
        </div>
    </div>
</section>

<section class="section category-section">
    <div class="container">
        <div class="section-title">
            <h2>Danh Mục Sản Phẩm</h2>
            <p>Các nhóm sản phẩm đang ACTIVE trong database Box Healthy.</p>
        </div>
    </div>
    <div class="category-carousel" aria-label="Danh mục sản phẩm">
        <div class="category-track">
            <c:forEach items="${categories}" var="category" varStatus="loop">
                <c:url var="categoryUrl" value="/products">
                    <c:param name="categoryId" value="${category.id}"/>
                </c:url>

                <c:set var="categoryImage" value="https://images.unsplash.com/photo-1546069901-ba9599a7e63c?auto=format&fit=crop&w=900&q=80"/>
                <c:choose>
                    <c:when test="${fn:contains(category.name, 'Sáng') || fn:contains(category.name, 'sáng')}">
                        <c:set var="categoryImage" value="https://images.unsplash.com/photo-1494390248081-4e521a5940db?auto=format&fit=crop&w=900&q=80"/>
                    </c:when>
                    <c:when test="${fn:contains(category.name, 'Bánh') || fn:contains(category.name, 'bánh')}">
                        <c:set var="categoryImage" value="https://images.unsplash.com/photo-1590080875515-8a3a8dc5735e?auto=format&fit=crop&w=900&q=80"/>
                    </c:when>
                    <c:when test="${fn:contains(category.name, 'Gà') || fn:contains(category.name, 'Thịt') || fn:contains(category.name, 'Đạm')}">
                        <c:set var="categoryImage" value="https://images.unsplash.com/photo-1546069901-ba9599a7e63c?auto=format&fit=crop&w=900&q=80"/>
                    </c:when>
                    <c:when test="${fn:contains(category.name, 'Rau') || fn:contains(category.name, 'Salad')}">
                        <c:set var="categoryImage" value="https://images.unsplash.com/photo-1512621776951-a57141f2eefd?auto=format&fit=crop&w=900&q=80"/>
                    </c:when>
                    <c:when test="${fn:contains(category.name, 'Combo')}">
                        <c:set var="categoryImage" value="https://images.unsplash.com/photo-1511690656952-34342bb7c2f2?auto=format&fit=crop&w=900&q=80"/>
                    </c:when>
                </c:choose>

                <a class="category-card" href="${categoryUrl}">
                    <img src="${categoryImage}" alt="${category.name}">
                    <div class="category-content">
                        <div class="category-icon"><fmt:formatNumber value="${loop.index + 1}" pattern="00"/></div>
                        <h3>${category.name}</h3>
                    </div>
                </a>
            </c:forEach>
            <c:if test="${empty categories}">
                <div class="category-empty">
                    Chưa có danh mục ACTIVE trong database.
                </div>
            </c:if>
        </div>
    </div>
</section>

<section class="section soft">
    <div class="container">
        <div class="section-title">
            <h2>Sản Phẩm Nổi Bật</h2>
            <p>Các món healthy đang ACTIVE trong database Box Healthy.</p>
        </div>
        <div class="product-grid">
            <c:forEach items="${featuredProducts}" var="product">
                <c:set var="productImage" value="${product.imageUrl}"/>
                <c:if test="${not fn:startsWith(product.imageUrl, 'http')}">
                    <c:set var="productImage" value="${pageContext.request.contextPath}${product.imageUrl}"/>
                </c:if>
                <div class="product-card">
                    <a class="product-image" href="<c:url value='/products/${product.id}'/>">
                        <img src="${productImage}" alt="${product.name}" onerror="this.style.display='none'">
                    </a>
                    <button class="favorite-button" type="button" aria-label="Yêu thích">
                        <svg class="icon" viewBox="0 0 24 24" aria-hidden="true">
                            <path d="M20.8 4.6a5.4 5.4 0 0 0-7.6 0L12 5.8l-1.2-1.2a5.4 5.4 0 1 0-7.6 7.6L12 21l8.8-8.8a5.4 5.4 0 0 0 0-7.6Z"/>
                        </svg>
                    </button>
                    <div class="product-body">
                        <div class="rating-row">
                            <span class="stars">&#9733;&#9733;&#9733;&#9733;&#9733;</span>
                            <span>(5.0)</span>
                        </div>
                        <h3><a href="<c:url value='/products/${product.id}'/>">${product.name}</a></h3>
                        <p>${product.description}</p>
                        <div class="product-bottom">
                            <div class="price"><fmt:formatNumber value="${product.price}" type="number"/>đ</div>
                            <form action="<c:url value='/cart/add/${product.id}'/>" method="post">
                                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}">
                                <button class="cart-add-button" type="submit">
                                    <svg class="icon" viewBox="0 0 24 24" aria-hidden="true">
                                        <path d="M6.2 6h15l-1.7 8.4a2 2 0 0 1-2 1.6H9a2 2 0 0 1-2-1.6L5.4 3H2"/>
                                        <circle cx="9.5" cy="20" r="1.5"/>
                                        <circle cx="17.5" cy="20" r="1.5"/>
                                    </svg>
                                    Thêm
                                </button>
                            </form>
                        </div>
                    </div>
                </div>
            </c:forEach>
        </div>
    </div>
</section>

<jsp:include page="common/footer.jsp"/>
