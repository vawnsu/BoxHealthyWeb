<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<jsp:include page="common/admin-header.jsp"/>

<section class="admin-page">
    <div class="admin-page-head">
        <div>
            <span class="admin-kicker">Product Management</span>
            <h1>Quản lý sản phẩm</h1>
            <p>Thêm, sửa, ẩn hiện sản phẩm Box Healthy.</p>
        </div>
        <a class="admin-primary-action" href="<c:url value='/admin/products/new'/>">Thêm sản phẩm</a>
    </div>

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
                                <img src="${productImage}" alt="${product.name}">
                                <div>
                                    <strong>${product.name}</strong>
                                    <small>${product.calories} kcal · ${product.protein}g protein</small>
                                </div>
                            </div>
                        </td>
                        <td>${product.category.name}</td>
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
                </tbody>
            </table>
        </div>
    </section>
</section>

<jsp:include page="common/admin-footer.jsp"/>
