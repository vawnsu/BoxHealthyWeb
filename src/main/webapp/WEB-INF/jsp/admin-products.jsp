<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<jsp:include page="common/admin-header.jsp"/>

<section class="admin-page">
    <div class="admin-page-head">
        <div>
            <h1>Quản lý sản phẩm</h1>
        </div>
        <a class="admin-primary-action" href="<c:url value='/admin/products/new'/>">Thêm sản phẩm</a>
    </div>

    <section class="admin-panel admin-filter-panel">
        <form class="admin-filter-bar" method="get" action="<c:url value='/admin/products'/>">
            <div>
                <label for="productKeyword">Tìm kiếm</label>
                <input id="productKeyword" type="search" name="keyword" value="${fn:escapeXml(keyword)}" placeholder="Tên món hoặc mô tả">
            </div>
            <div>
                <label for="productCategory">Danh mục</label>
                <select id="productCategory" name="categoryId">
                    <option value="">Tất cả danh mục</option>
                    <c:forEach items="${categories}" var="category">
                        <option value="${category.id}" ${category.id == categoryId ? 'selected' : ''}>${category.name}</option>
                    </c:forEach>
                </select>
            </div>
            <div class="admin-filter-actions">
                <button class="admin-submit" type="submit">Lọc</button>
                <a class="admin-secondary-action" href="<c:url value='/admin/products'/>">Đặt lại</a>
            </div>
        </form>
    </section>

    <section class="admin-panel">
        <div class="admin-table-wrap">
            <table class="admin-table">
                <thead>
                <tr>
                    <th>Sản phẩm</th>
                    <th>Danh mục</th>
                    <th>Giá</th>
                    <th>Tồn kho</th>
                    <th>Trạng thái</th>
                    <th></th>
                </tr>
                </thead>
                <tbody>
                <c:forEach items="${products}" var="product">
                    <c:set var="productImage" value="${product.imageUrl}"/>
                    <c:if test="${not fn:startsWith(product.imageUrl, 'http')}">
                        <c:set var="productImage" value="${pageContext.request.contextPath}${product.imageUrl}"/>
                    </c:if>
                    <tr>
                        <td>
                            <div class="admin-product-cell">
                                <img src="${productImage}" alt="${product.name}" onerror="this.onerror=null;this.src='${pageContext.request.contextPath}/images/product-1.svg';">
                                <div>
                                    <strong>${product.name}</strong>
                                    <small>${product.calories} kcal · ${product.protein}g protein</small>
                                </div>
                            </div>
                        </td>
                        <td>
                            <c:choose>
                                <c:when test="${not empty product.category}">${product.category.name}</c:when>
                                <c:otherwise>Chưa gán</c:otherwise>
                            </c:choose>
                        </td>
                        <td><fmt:formatNumber value="${product.price}" type="number"/>đ</td>
                        <td>${product.stockQuantity}</td>
                        <td><span class="admin-status product-${product.status}">${product.status}</span></td>
                        <td>
                            <div class="admin-row-actions">
                                <a class="admin-link" href="<c:url value='/admin/products/${product.id}/edit'/>">Sửa</a>
                                <form action="<c:url value='/admin/products/${product.id}/delete'/>" method="post" data-confirm="Xóa sản phẩm này?">
                                    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}">
                                    <button class="admin-danger" type="submit">Xóa</button>
                                </form>
                            </div>
                        </td>
                    </tr>
                </c:forEach>
                <c:if test="${empty products}">
                    <tr>
                        <td colspan="6" class="admin-empty-row">Không tìm thấy sản phẩm phù hợp.</td>
                    </tr>
                </c:if>
                </tbody>
            </table>
        </div>
    </section>
</section>

<jsp:include page="common/admin-footer.jsp"/>
