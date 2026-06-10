<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageCss" value="cart.css" scope="request"/>
<jsp:include page="common/header.jsp"/>

<section class="section soft">
    <div class="container">
        <div class="success-panel panel reveal-on-scroll">
            <div class="success-icon">
                <svg class="icon" viewBox="0 0 24 24" aria-hidden="true">
                    <path d="M20 6 9 17l-5-5"></path>
                </svg>
            </div>
            <span class="eyebrow">Đặt món thành công</span>
            <h1>Box Healthy đã nhận đơn</h1>
            <p>${message}</p>
            <div class="success-actions">
                <a class="btn" href="<c:url value='/orders'/>">Xem đơn hàng</a>
                <a class="btn secondary" href="<c:url value='/products'/>">Tiếp tục xem thực đơn</a>
            </div>
        </div>
    </div>
</section>

<jsp:include page="common/footer.jsp"/>
