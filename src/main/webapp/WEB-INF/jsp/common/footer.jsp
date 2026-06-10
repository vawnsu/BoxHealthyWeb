<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<footer class="footer" id="contact">
    <div class="container footer-inner">
        <strong>Box Healthy</strong>
        <span>Nhanh - Tiện - Khỏe</span>
    </div>
</footer>
<div class="ai-chat-widget" data-ai-chat>
    <button class="ai-chat-toggle" type="button" aria-label="Mở trợ lý AI" data-ai-chat-toggle>
        <svg class="icon" viewBox="0 0 24 24" aria-hidden="true">
            <path d="M21 11.5a8.4 8.4 0 0 1-8.8 8.3 9.3 9.3 0 0 1-4-.9L3 20l1.4-4.5A8 8 0 0 1 3 11.5C3 6.8 7 3 12 3s9 3.8 9 8.5Z"/>
            <path d="M8 10h8M8 14h5"/>
        </svg>
    </button>
    <section class="ai-chat-panel" aria-label="Trợ lý AI Box Healthy" hidden>
        <div class="ai-chat-head">
            <div>
                <strong>Trợ lý Box Healthy</strong>
                <span>Gợi ý món, macro và TDEE</span>
            </div>
            <button class="ai-chat-close" type="button" aria-label="Đóng trợ lý AI" data-ai-chat-close>×</button>
        </div>
        <div class="ai-chat-messages" data-ai-chat-messages>
            <div class="ai-chat-message bot">Chào bạn, mình có thể gợi ý món healthy theo mục tiêu của bạn.</div>
        </div>
        <form class="ai-chat-form" data-ai-chat-form>
            <input type="text" name="message" maxlength="600" autocomplete="off" placeholder="Nhập câu hỏi của bạn...">
            <button type="submit" aria-label="Gửi tin nhắn">
                <svg class="icon" viewBox="0 0 24 24" aria-hidden="true">
                    <path d="M22 2 11 13"/>
                    <path d="m22 2-7 20-4-9-9-4 20-7Z"/>
                </svg>
            </button>
        </form>
    </section>
</div>
<script src="${pageContext.request.contextPath}/js/app.js"></script>
</body>
</html>
