<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<c:set var="pageCss" value="product.css" scope="request"/>
<jsp:include page="common/header.jsp"/>

<section class="section soft product-page">
    <div class="container">
        <div class="section-title compact-title">
            <h2>Thực Đơn Healthy</h2>
            <p>Tìm món theo tên, danh mục và chọn nhanh vào giỏ hàng.</p>
        </div>
        <form class="filter-bar" method="get" action="<c:url value='/products'/>">
            <div class="search-field">
                <svg class="icon" viewBox="0 0 24 24" aria-hidden="true">
                    <circle cx="11" cy="11" r="7"/>
                    <path d="m20 20-3.5-3.5"/>
                </svg>
                <input type="text" name="keyword" value="${keyword}" placeholder="Tìm món ăn...">
            </div>
            <select name="categoryId">
                <option value="">Tất cả danh mục</option>
                <c:forEach items="${categories}" var="category">
                    <option value="${category.id}" ${category.id == categoryId ? 'selected' : ''}>${category.name}</option>
                </c:forEach>
            </select>
            <button type="submit">
                <svg class="icon" viewBox="0 0 24 24" aria-hidden="true">
                    <circle cx="11" cy="11" r="7"/>
                    <path d="m20 20-3.5-3.5"/>
                </svg>
                Tìm kiếm
            </button>
        </form>
        <div class="product-grid">
            <c:forEach items="${products}" var="product">
                <c:set var="productImage" value="${product.imageUrl}"/>
                <c:if test="${not fn:startsWith(product.imageUrl, 'http')}">
                    <c:set var="productImage" value="${pageContext.request.contextPath}${product.imageUrl}"/>
                </c:if>
                <div class="product-card">
                    <a class="product-image" href="<c:url value='/products/${product.id}'/>">
                        <img src="${productImage}" alt="${product.name}" onerror="this.onerror=null;this.src='${pageContext.request.contextPath}/images/product-1.svg';">
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
                        <div class="macro-row">
                            <div class="macro"><strong>${product.calories}</strong>kcal</div>
                            <div class="macro"><strong>${product.protein}g</strong>Protein</div>
                            <div class="macro"><strong>${product.carbs}g</strong>Carbs</div>
                            <div class="macro"><strong>${product.fat}g</strong>Fat</div>
                        </div>
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
