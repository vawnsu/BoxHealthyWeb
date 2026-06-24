<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Box Healthy Admin</title>
    <link rel="icon" type="image/png" href="<c:url value='/images/logo-boxhealthy.png'/>?v=3">
    <link rel="stylesheet" href="<c:url value='/css/common.css'/>">
    <link rel="stylesheet" href="<c:url value='/css/admin.css'/>">
</head>
<body class="admin-body">
<div class="admin-shell">
    <aside class="admin-sidebar">
        <a class="admin-brand" href="<c:url value='/admin'/>">
            <img src="<c:url value='/images/logo-boxhealthy.png'/>" alt="Box Healthy">
            <span>
                <strong>Box Healthy</strong>
                <small>Admin Panel</small>
            </span>
        </a>

        <nav class="admin-menu" aria-label="Admin menu">
            <a href="<c:url value='/admin'/>">
                <svg class="icon" viewBox="0 0 24 24" aria-hidden="true">
                    <path d="M4 13h6V4H4v9Zm10 7h6V4h-6v16ZM4 20h6v-3H4v3Z"/>
                </svg>
                Dashboard
            </a>
            <a href="<c:url value='/admin/products'/>">
                <svg class="icon" viewBox="0 0 24 24" aria-hidden="true">
                    <path d="M6 2 3 6v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2V6l-3-4Z"/>
                    <path d="M3 6h18"/>
                    <path d="M16 10a4 4 0 0 1-8 0"/>
                </svg>
                Quản lý sản phẩm
            </a>
            <a href="<c:url value='/admin/orders'/>">
                <svg class="icon" viewBox="0 0 24 24" aria-hidden="true">
                    <path d="M7 3h10l2 3v15l-3-2-2 2-2-2-2 2-3 2V6l2-3Z"/>
                    <path d="M9 8h6M9 12h6"/>
                </svg>
                Quản lý đơn hàng
            </a>
            <a href="<c:url value='/admin/notifications'/>" class="admin-menu-notification">
                <svg class="icon" viewBox="0 0 24 24" aria-hidden="true">
                    <path d="M18 8a6 6 0 0 0-12 0c0 7-3 7-3 9h18c0-2-3-2-3-9Z"/>
                    <path d="M10 21h4"/>
                </svg>
                Thông báo
                <c:if test="${adminUnreadNotificationCount > 0}">
                    <span class="admin-menu-badge">${adminUnreadNotificationCount}</span>
                </c:if>
            </a>
            <a href="<c:url value='/admin/users'/>">
                <svg class="icon" viewBox="0 0 24 24" aria-hidden="true">
                    <path d="M16 11a4 4 0 1 0-8 0 4 4 0 0 0 8 0Z"/>
                    <path d="M4 21a8 8 0 0 1 16 0"/>
                </svg>
                Quản lý tài khoản
            </a>
            <a href="<c:url value='/admin/categories'/>">
                <svg class="icon" viewBox="0 0 24 24" aria-hidden="true">
                    <path d="M4 7h16M4 12h16M4 17h16"/>
                </svg>
                Quản lý danh mục
            </a>
        </nav>

        <div class="admin-sidebar-footer">
            <a href="<c:url value='/'/>">Xem website</a>
            <form action="<c:url value='/logout'/>" method="post">
                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}">
                <button type="submit">Đăng xuất</button>
            </form>
        </div>
    </aside>

    <main class="admin-main">
        <header class="admin-topbar">
            <div>
                <span>Quản trị hệ thống</span>
                <strong>Box Healthy</strong>
            </div>
            <div class="admin-user-chip">
                <span>
                    <c:choose>
                        <c:when test="${not empty currentUser.fullName}">
                            ${fn:substring(currentUser.fullName, 0, 1)}
                        </c:when>
                        <c:otherwise>A</c:otherwise>
                    </c:choose>
                </span>
                <div>
                    <strong>
                        <c:choose>
                            <c:when test="${not empty currentUser.fullName}">${currentUser.fullName}</c:when>
                            <c:otherwise>${pageContext.request.userPrincipal.name}</c:otherwise>
                        </c:choose>
                    </strong>
                    <small>${currentUser.role}</small>
                </div>
            </div>
        </header>
