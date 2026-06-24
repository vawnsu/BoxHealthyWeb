<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<c:set var="pageCss" value="product.css" scope="request"/>
<jsp:include page="common/header.jsp"/>

<section class="section soft product-detail-page">
    <div class="container">
        <c:set var="productImage" value="${product.imageUrl}"/>
        <c:if test="${not fn:startsWith(product.imageUrl, 'http')}">
            <c:set var="productImage" value="${pageContext.request.contextPath}${product.imageUrl}"/>
        </c:if>

        <div class="product-detail-shell">
            <div class="product-detail-gallery">
                <div class="product-image product-detail-image">
                    <img src="${productImage}" alt="${product.name}" onerror="this.onerror=null;this.src='${pageContext.request.contextPath}/images/product-1.svg';">
                </div>
                <div class="detail-mini-grid">
                    <div><strong>1 hộp</strong><span>Khẩu phần</span></div>
                    <div><strong>${product.stockQuantity}</strong><span>Còn lại</span></div>
                    <div><strong>5.0</strong><span>Đánh giá</span></div>
                </div>
            </div>

            <div class="product-detail-content">
                <div class="rating-row">
                    <span class="stars">★★★★★</span>
                    <span>(5.0)</span>
                </div>
                <p class="product-category">${product.category.name}</p>
                <h1>${product.name}</h1>
                <p class="detail-description">${product.description}</p>

                <div class="macro-row detail-macros">
                    <div class="macro"><strong>${product.calories}</strong>Calories</div>
                    <div class="macro"><strong>${product.protein}g</strong>Protein</div>
                    <div class="macro"><strong>${product.carbs}g</strong>Carbs</div>
                    <div class="macro"><strong>${product.fat}g</strong>Fat</div>
                </div>

                <div class="detail-note-grid">
                    <div>
                        <span>Phù hợp</span>
                        <strong>Bữa trưa / bữa tối</strong>
                    </div>
                    <div>
                        <span>Bảo quản</span>
                        <strong>0-4°C trong 24h</strong>
                    </div>
                </div>

                <div class="detail-actions">
                    <div class="price"><fmt:formatNumber value="${product.price}" type="number"/>đ</div>
                    <button class="favorite-button" type="button" aria-label="Yêu thích">
                        <svg class="icon" viewBox="0 0 24 24" aria-hidden="true">
                            <path d="M20.8 4.6a5.4 5.4 0 0 0-7.6 0L12 5.8l-1.2-1.2a5.4 5.4 0 1 0-7.6 7.6L12 21l8.8-8.8a5.4 5.4 0 0 0 0-7.6Z"/>
                        </svg>
                    </button>
                    <form action="<c:url value='/cart/add/${product.id}'/>" method="post">
                        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}">
                        <button class="cart-add-button" type="submit">
                            <svg class="icon" viewBox="0 0 24 24" aria-hidden="true">
                                <path d="M6.2 6h15l-1.7 8.4a2 2 0 0 1-2 1.6H9a2 2 0 0 1-2-1.6L5.4 3H2"/>
                                <circle cx="9.5" cy="20" r="1.5"/>
                                <circle cx="17.5" cy="20" r="1.5"/>
                            </svg>
                            Thêm vào giỏ hàng
                        </button>
                    </form>
                </div>
            </div>
        </div>

        <div class="detail-lower-grid">
            <section class="panel ingredients-panel">
                <div class="detail-section-heading">
                    <div>
                        <p>Trong hộp có gì?</p>
                        <h2>Thành phần & khối lượng</h2>
                    </div>
                    <span>Tính theo 1 khẩu phần</span>
                </div>

                <div class="ingredient-table">
                    <div class="ingredient-row ingredient-head">
                        <span>Thành phần</span>
                        <span>Khối lượng</span>
                        <span>Kcal</span>
                        <span>Protein</span>
                        <span>Carbs</span>
                        <span>Fat</span>
                    </div>
                    <c:forEach items="${ingredientBreakdown}" var="item">
                        <div class="ingredient-row">
                            <div class="ingredient-name">
                                <strong>${item.name}</strong>
                                <small>${item.note}</small>
                            </div>
                            <span>${item.weightGram}g</span>
                            <span>${item.calories}</span>
                            <span>${item.protein}g</span>
                            <span>${item.carbs}g</span>
                            <span>${item.fat}g</span>
                        </div>
                    </c:forEach>
                    <c:if test="${empty ingredientBreakdown}">
                        <div class="ingredient-row ingredient-empty">
                            <div class="ingredient-name">
                                <strong>Chưa có dữ liệu thành phần</strong>
                                <small>Vui lòng thêm dữ liệu vào bảng product_ingredient trong database.</small>
                            </div>
                        </div>
                    </c:if>
                </div>
            </section>

            <aside class="panel detail-info-panel">
                <h2>Gợi ý sử dụng</h2>
                <div class="info-list">
                    <div>
                        <strong>Làm nóng</strong>
                        <span>Mở hé nắp, quay microwave 2-3 phút.</span>
                    </div>
                    <div>
                        <strong>Ăn ngon nhất</strong>
                        <span>Dùng trong ngày để rau và protein giữ vị tốt.</span>
                    </div>
                    <div>
                        <strong>Phù hợp mục tiêu</strong>
                        <span>Cân bằng protein, tinh bột tốt và rau xanh.</span>
                    </div>
                </div>
            </aside>
        </div>

        <section class="related-section">
            <div class="section-title compact-title">
                <h2>Món tương tự</h2>
                <p>Thêm lựa chọn healthy cho bữa tiếp theo</p>
            </div>
            <div class="related-grid">
                <c:forEach items="${relatedProducts}" var="related">
                    <c:if test="${related.id != product.id}">
                        <c:set var="relatedImage" value="${related.imageUrl}"/>
                        <c:if test="${not fn:startsWith(related.imageUrl, 'http')}">
                            <c:set var="relatedImage" value="${pageContext.request.contextPath}${related.imageUrl}"/>
                        </c:if>
                        <a class="related-card" href="<c:url value='/products/${related.id}'/>">
                            <img src="${relatedImage}" alt="${related.name}" onerror="this.onerror=null;this.src='${pageContext.request.contextPath}/images/product-1.svg';">
                            <div>
                                <strong>${related.name}</strong>
                                <span><fmt:formatNumber value="${related.price}" type="number"/>đ</span>
                            </div>
                        </a>
                    </c:if>
                </c:forEach>
            </div>
        </section>
    </div>
</section>

<jsp:include page="common/footer.jsp"/>
