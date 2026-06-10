<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Box Healthy</title>
    <link rel="icon" type="image/png" href="<c:url value='/images/logo-boxhealthy.png'/>?v=3">
    <link rel="apple-touch-icon" href="<c:url value='/images/logo-boxhealthy.png'/>?v=3">
    <link rel="stylesheet" href="<c:url value='/css/common.css'/>">
    <c:if test="${not empty pageCss}">
        <link rel="stylesheet" href="<c:url value='/css/${pageCss}'/>">
    </c:if>
</head>
<body>
<header class="site-header">
    <div class="container nav">
        <a class="brand" href="<c:url value='/'/>" aria-label="Box Healthy">
            <img class="brand-logo" src="<c:url value='/images/logo-boxhealthy.png'/>" alt="Box Healthy">
            <span class="brand-text">Box Healthy</span>
        </a>

        <nav class="nav-links" aria-label="Điều hướng chính">
            <a href="<c:url value='/'/>">Trang chủ</a>
            <a href="<c:url value='/products'/>">Thực đơn</a>
            <a href="<c:url value='/tdee'/>">Tính TDEE</a>
            <a href="<c:url value='/nutrition'/>">Dinh dưỡng</a>
        </nav>

        <div class="nav-actions">
            <a class="nav-icon-btn" href="<c:url value='/cart'/>" title="Giỏ hàng" aria-label="Giỏ hàng">
                <svg class="icon" viewBox="0 0 24 24" aria-hidden="true">
                    <path d="M6.2 6h15l-1.7 8.4a2 2 0 0 1-2 1.6H9a2 2 0 0 1-2-1.6L5.4 3H2"/>
                    <circle cx="9.5" cy="20" r="1.5"/>
                    <circle cx="17.5" cy="20" r="1.5"/>
                </svg>
            </a>

            <c:choose>
                <c:when test="${pageContext.request.userPrincipal != null}">
                    <details class="account-menu">
                        <summary class="user-pill">
                            <span class="user-avatar">
                                <c:choose>
                                    <c:when test="${not empty currentUser.fullName}">
                                        ${fn:substring(currentUser.fullName, 0, 1)}
                                    </c:when>
                                    <c:otherwise>U</c:otherwise>
                                </c:choose>
                            </span>
                            <span class="user-meta">
                                <strong>
                                    <c:choose>
                                        <c:when test="${not empty currentUser.fullName}">${currentUser.fullName}</c:when>
                                        <c:otherwise>${pageContext.request.userPrincipal.name}</c:otherwise>
                                    </c:choose>
                                </strong>
                                <small>${currentUser.role}</small>
                            </span>
                            <svg class="icon chevron-icon" viewBox="0 0 24 24" aria-hidden="true">
                                <path d="m6 9 6 6 6-6"/>
                            </svg>
                        </summary>

                        <div class="account-dropdown">
                            <div class="account-card-head">
                                <span class="user-avatar large">
                                    <c:choose>
                                        <c:when test="${not empty currentUser.fullName}">
                                            ${fn:substring(currentUser.fullName, 0, 1)}
                                        </c:when>
                                        <c:otherwise>U</c:otherwise>
                                    </c:choose>
                                </span>
                                <div>
                                    <strong>
                                        <c:choose>
                                            <c:when test="${not empty currentUser.fullName}">${currentUser.fullName}</c:when>
                                            <c:otherwise>${pageContext.request.userPrincipal.name}</c:otherwise>
                                        </c:choose>
                                    </strong>
                                    <span>${currentUser.email}</span>
                                </div>
                            </div>

                            <div class="account-role">${currentUser.role}</div>

                            <c:choose>
                                <c:when test="${currentUser.role == 'ADMIN'}">
                                    <a class="account-dropdown-link" href="<c:url value='/admin'/>">
                                        <svg class="icon" viewBox="0 0 24 24" aria-hidden="true">
                                            <path d="M4 13h6V4H4v9Zm10 7h6V4h-6v16ZM4 20h6v-3H4v3Z"/>
                                        </svg>
                                        Trang quản trị
                                    </a>
                                </c:when>
                                <c:otherwise>
                                    <a class="account-dropdown-link" href="<c:url value='/orders'/>">
                                        <svg class="icon" viewBox="0 0 24 24" aria-hidden="true">
                                            <path d="M7 3h10l2 3v15l-3-2-2 2-2-2-2 2-3 2V6l2-3Z"/>
                                            <path d="M9 8h6M9 12h6"/>
                                        </svg>
                                        Đơn hàng của tôi
                                    </a>
                                </c:otherwise>
                            </c:choose>

                            <form class="account-logout-form" action="<c:url value='/logout'/>" method="post">
                                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}">
                                <button class="account-dropdown-link logout-link" type="submit">
                                    <svg class="icon" viewBox="0 0 24 24" aria-hidden="true">
                                        <path d="M10 17l5-5-5-5M15 12H3M20 4v16"/>
                                    </svg>
                                    Đăng xuất
                                </button>
                            </form>
                        </div>
                    </details>
                </c:when>
                <c:otherwise>
                    <a class="nav-action-link" href="<c:url value='/login'/>">
                        <svg class="icon" viewBox="0 0 24 24" aria-hidden="true">
                            <circle cx="12" cy="8" r="4"/>
                            <path d="M4 21a8 8 0 0 1 16 0"/>
                        </svg>
                        Đăng nhập
                    </a>
                    <a class="btn small register-btn" href="<c:url value='/register'/>">
                        <svg class="icon" viewBox="0 0 24 24" aria-hidden="true">
                            <path d="M12 5v14M5 12h14"/>
                        </svg>
                        Đăng ký
                    </a>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</header>
