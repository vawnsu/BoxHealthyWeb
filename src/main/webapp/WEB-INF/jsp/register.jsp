<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageCss" value="auth.css" scope="request"/>
<jsp:include page="common/header.jsp"/>

<main class="auth-page">
    <section class="auth-left">
        <div class="auth-brand-panel">
            <div class="auth-logo-frame">
                <img class="auth-logo-image" src="${pageContext.request.contextPath}/images/logo-boxhealthy.png" alt="Box Healthy">
            </div>
            <p class="auth-kicker">Box Healthy meal prep</p>
            <h2>Ăn lành mỗi ngày</h2>
            <p class="auth-copy">Bữa ăn cân bằng, đóng gói tiện lợi và hợp với nhịp sống bận rộn.</p>
            <div class="auth-feature-grid">
                <div><strong>Nhanh</strong><span>Tiết kiệm thời gian</span></div>
                <div><strong>Tiện</strong><span>Dễ đặt, dễ dùng</span></div>
                <div><strong>Khỏe</strong><span>Dinh dưỡng cân bằng</span></div>
            </div>
        </div>
    </section>
    <section class="auth-main">
        <form class="auth-card" action="<c:url value='/register'/>" method="post">
            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}">
            <div class="auth-form-logo">
                <img src="${pageContext.request.contextPath}/images/logo-boxhealthy.png" alt="Box Healthy">
            </div>
            <h1>Đăng ký</h1>
            <p class="subtitle">Tạo tài khoản mới để bắt đầu!</p>
            <c:if test="${not empty error}"><div class="alert">${error}</div></c:if>
            <c:if test="${param.oauthError != null}"><div class="alert">Đăng nhập Google chưa thành công. Bạn thử lại nhé.</div></c:if>

            <label>Họ và tên</label>
            <input name="fullName" value="${registerRequest.fullName}" placeholder="Nguyễn Văn A" required>
            <div class="field-spacer"></div>

            <label>Email</label>
            <input type="email" name="email" value="${registerRequest.email}" placeholder="your@email.com" required>
            <div class="field-spacer"></div>

            <label>Số điện thoại</label>
            <input name="phone" value="${registerRequest.phone}" placeholder="0901234567">
            <div class="field-spacer"></div>

            <label>Địa chỉ</label>
            <input name="address" value="${registerRequest.address}" placeholder="Địa chỉ giao hàng">
            <div class="field-spacer"></div>

            <label>Mật khẩu</label>
            <input type="password" name="password" placeholder="••••••••" required>

            <div class="auth-row">
                <label class="inline-check">
                    <input type="checkbox" required>
                    Tôi đồng ý với Điều khoản dịch vụ và Chính sách bảo mật
                </label>
            </div>

            <button type="submit">Đăng ký</button>
            <c:if test="${googleLoginEnabled}">
                <div class="divider">Hoặc đăng ký với</div>
                <div class="social-row">
                    <a class="social google" href="<c:url value='/oauth2/authorization/google'/>">
                        <svg class="brand-icon" viewBox="0 0 24 24" aria-hidden="true">
                            <path fill="#4285F4" d="M21.6 12.2c0-.7-.1-1.4-.2-2H12v3.8h5.4a4.6 4.6 0 0 1-2 3v2.5h3.2c1.9-1.8 3-4.3 3-7.3Z"/>
                            <path fill="#34A853" d="M12 22c2.7 0 5-.9 6.6-2.5L15.4 17c-.9.6-2 .9-3.4.9-2.6 0-4.8-1.8-5.6-4.1H3.1v2.6A10 10 0 0 0 12 22Z"/>
                            <path fill="#FBBC05" d="M6.4 13.8a6 6 0 0 1 0-3.6V7.6H3.1a10 10 0 0 0 0 8.8l3.3-2.6Z"/>
                            <path fill="#EA4335" d="M12 6.1c1.5 0 2.8.5 3.8 1.5l2.9-2.9A9.8 9.8 0 0 0 12 2 10 10 0 0 0 3.1 7.6l3.3 2.6C7.2 7.9 9.4 6.1 12 6.1Z"/>
                        </svg>
                        Google
                    </a>
                </div>
            </c:if>
            <p class="form-note">Đã có tài khoản? <a href="<c:url value='/login'/>">Đăng nhập ngay</a></p>
        </form>
    </section>
</main>

<jsp:include page="common/footer.jsp"/>
