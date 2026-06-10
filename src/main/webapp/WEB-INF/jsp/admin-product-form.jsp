<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<jsp:include page="common/admin-header.jsp"/>

<section class="admin-page">
    <div class="admin-page-head">
        <div>
            <span class="admin-kicker">Product Form</span>
            <h1>${productForm.id == null ? 'Thêm sản phẩm' : 'Sửa sản phẩm'}</h1>
            <p>Cập nhật thông tin bán hàng, ảnh, định lượng và tồn kho.</p>
        </div>
        <a class="admin-secondary-action" href="<c:url value='/admin/products'/>">Quay lại</a>
    </div>

    <form class="admin-panel admin-form-panel" action="<c:url value='/admin/products/save'/>" method="post" enctype="multipart/form-data">
        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}">
        <input type="hidden" name="id" value="${productForm.id}">
        <input type="hidden" name="imageUrl" value="${productForm.imageUrl}">

        <div class="form-grid">
            <div>
                <label>Tên sản phẩm</label>
                <input name="name" value="${productForm.name}" required>
            </div>
            <div>
                <label>Giá</label>
                <input type="number" name="price" value="${productForm.price}" required>
            </div>
            <div class="full">
                <label>Mô tả</label>
                <textarea name="description" rows="4">${productForm.description}</textarea>
            </div>
            <div class="full">
                <label>Ảnh sản phẩm</label>
                <div class="admin-upload-box">
                    <c:if test="${not empty productForm.imageUrl}">
                        <c:set var="previewImage" value="${productForm.imageUrl}"/>
                        <c:if test="${not fn:startsWith(productForm.imageUrl, 'http')}">
                            <c:set var="previewImage" value="${pageContext.request.contextPath}${productForm.imageUrl}"/>
                        </c:if>
                        <img src="${previewImage}" alt="Ảnh sản phẩm hiện tại">
                    </c:if>
                    <div>
                        <input type="file" name="imageFile" accept="image/*">
                        <small>Chọn ảnh từ máy. Hệ thống lưu file vào thư mục upload riêng và lưu đường dẫn ảnh vào DB.</small>
                    </div>
                </div>
            </div>
            <div>
                <label>Danh mục</label>
                <select name="categoryId">
                    <c:forEach items="${categories}" var="category">
                        <option value="${category.id}" ${category.id == productForm.categoryId ? 'selected' : ''}>${category.name}</option>
                    </c:forEach>
                </select>
            </div>
            <div>
                <label>Trạng thái</label>
                <select name="status">
                    <option value="ACTIVE" ${productForm.status == 'ACTIVE' ? 'selected' : ''}>ACTIVE</option>
                    <option value="INACTIVE" ${productForm.status == 'INACTIVE' ? 'selected' : ''}>INACTIVE</option>
                </select>
            </div>

            <div class="full admin-ingredient-builder" data-ingredient-builder>
                <div class="admin-form-section-head">
                    <div>
                        <h2>Thành phần & định lượng</h2>
                        <p>Chọn thực phẩm từ bảng dinh dưỡng, nhập khối lượng gram. Hệ thống tự tính macro cho sản phẩm.</p>
                    </div>
                    <button type="button" class="admin-mini-action" data-add-ingredient>Thêm thành phần</button>
                </div>

                <div class="admin-ingredient-head">
                    <span>Thực phẩm</span>
                    <span>Khối lượng</span>
                    <span>Ghi chú</span>
                    <span>Kcal</span>
                    <span>Protein</span>
                    <span>Carbs</span>
                    <span>Fat</span>
                    <span></span>
                </div>

                <div class="admin-ingredient-rows" data-ingredient-rows>
                    <c:forEach items="${productForm.ingredients}" var="ingredient" varStatus="loop">
                        <div class="admin-ingredient-row" data-ingredient-row>
                            <select name="ingredients[${loop.index}].nutritionItemId" data-nutrition-select>
                                <option value="">Chọn thực phẩm</option>
                                <c:forEach items="${nutritionItems}" var="food">
                                    <option value="${food.id}"
                                            data-calories="${food.calories}"
                                            data-protein="${food.protein}"
                                            data-carbs="${food.carbs}"
                                            data-fat="${food.fat}"
                                            ${food.id == ingredient.nutritionItemId ? 'selected' : ''}>
                                            ${food.foodName}
                                    </option>
                                </c:forEach>
                            </select>
                            <input type="number" min="1" name="ingredients[${loop.index}].weightGram" value="${ingredient.weightGram}" placeholder="g" data-ingredient-weight>
                            <input name="ingredients[${loop.index}].note" value="${ingredient.note}" placeholder="VD: protein chính">
                            <strong data-row-calories>0</strong>
                            <strong data-row-protein>0g</strong>
                            <strong data-row-carbs>0g</strong>
                            <strong data-row-fat>0g</strong>
                            <button type="button" class="admin-row-remove" data-remove-ingredient>×</button>
                        </div>
                    </c:forEach>
                </div>
            </div>

            <div><label>Calories</label><input type="number" name="calories" value="${productForm.calories}" data-total-calories></div>
            <div><label>Protein</label><input type="number" step="0.1" name="protein" value="${productForm.protein}" data-total-protein></div>
            <div><label>Carbs</label><input type="number" step="0.1" name="carbs" value="${productForm.carbs}" data-total-carbs></div>
            <div><label>Fat</label><input type="number" step="0.1" name="fat" value="${productForm.fat}" data-total-fat></div>
            <div><label>Tồn kho</label><input type="number" name="stockQuantity" value="${productForm.stockQuantity}"></div>
        </div>
        <button class="admin-submit" type="submit">Lưu sản phẩm</button>
    </form>

    <template id="ingredient-row-template">
        <div class="admin-ingredient-row" data-ingredient-row>
            <select name="ingredients[__index__].nutritionItemId" data-nutrition-select>
                <option value="">Chọn thực phẩm</option>
                <c:forEach items="${nutritionItems}" var="food">
                    <option value="${food.id}"
                            data-calories="${food.calories}"
                            data-protein="${food.protein}"
                            data-carbs="${food.carbs}"
                            data-fat="${food.fat}">
                            ${food.foodName}
                    </option>
                </c:forEach>
            </select>
            <input type="number" min="1" name="ingredients[__index__].weightGram" placeholder="g" data-ingredient-weight>
            <input name="ingredients[__index__].note" placeholder="VD: protein chính">
            <strong data-row-calories>0</strong>
            <strong data-row-protein>0g</strong>
            <strong data-row-carbs>0g</strong>
            <strong data-row-fat>0g</strong>
            <button type="button" class="admin-row-remove" data-remove-ingredient>×</button>
        </div>
    </template>
</section>

<jsp:include page="common/admin-footer.jsp"/>
