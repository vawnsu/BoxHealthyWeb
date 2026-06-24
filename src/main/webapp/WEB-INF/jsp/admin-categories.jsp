<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<jsp:include page="common/admin-header.jsp"/>

<section class="admin-page">
    <div class="admin-page-head">
        <div>
            <h1>Quản lý danh mục</h1>
        </div>
    </div>

    <div class="admin-two-column">
        <form class="admin-panel" action="<c:url value='/admin/categories/save'/>" method="post">
            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}">
            <input type="hidden" name="id" value="${category.id}">
            <div class="admin-panel-head">
                <div>
                    <h2>${category.id == null ? 'Thêm danh mục' : 'Sửa danh mục'}</h2>
                </div>
            </div>
            <label>Tên danh mục</label>
            <input name="name" value="${category.name}" required>
            <label>Mô tả</label>
            <textarea name="description" rows="4">${category.description}</textarea>
            <label>Trạng thái</label>
            <select name="status">
                <option value="ACTIVE" ${category.status == 'ACTIVE' ? 'selected' : ''}>ACTIVE</option>
                <option value="INACTIVE" ${category.status == 'INACTIVE' ? 'selected' : ''}>INACTIVE</option>
            </select>
            <button class="admin-submit" type="submit">Lưu danh mục</button>
        </form>

        <section class="admin-panel">
            <div class="admin-panel-head">
                <div>
                    <h2>Danh sách danh mục</h2>
                </div>
            </div>
            <div class="admin-table-wrap">
                <table class="admin-table">
                    <thead>
                    <tr>
                        <th>Tên</th>
                        <th>Trạng thái</th>
                        <th></th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:forEach items="${categories}" var="item">
                        <tr>
                            <td>${item.name}</td>
                            <td><span class="admin-status product-${item.status}">${item.status}</span></td>
                            <td>
                                <div class="admin-row-actions">
                                    <a class="admin-link" href="<c:url value='/admin/categories/${item.id}/edit'/>">Sửa</a>
                                    <form action="<c:url value='/admin/categories/${item.id}/delete'/>" method="post" data-confirm="Xóa danh mục này?">
                                        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}">
                                        <button class="admin-danger" type="submit">Xóa</button>
                                    </form>
                                </div>
                            </td>
                        </tr>
                    </c:forEach>
                    <c:if test="${empty categories}">
                        <tr>
                            <td colspan="3" class="admin-empty-row">Chưa có danh mục nào.</td>
                        </tr>
                    </c:if>
                    </tbody>
                </table>
            </div>
        </section>
    </div>
</section>

<jsp:include page="common/admin-footer.jsp"/>
