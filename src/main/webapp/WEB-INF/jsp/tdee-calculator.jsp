<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<c:set var="pageCss" value="tools.css" scope="request"/>
<jsp:include page="common/header.jsp"/>

<main class="tdee-page">
    <section class="tool-hero">
        <div class="container tool-hero-inner">
            <div class="tool-copy reveal-on-scroll">
                <span class="eyebrow">AI dinh dưỡng</span>
                <h1>Tính TDEE rõ ràng, dễ áp dụng</h1>
                <p>Nhập chỉ số cơ thể để ước tính BMR, TDEE và mức calories gợi ý cho giảm cân, giữ dáng hoặc tăng cơ.</p>
                <div class="tool-trust-row">
                    <span>Macro dễ hiểu</span>
                    <span>Gợi ý theo mục tiêu</span>
                    <span>Phù hợp meal prep</span>
                </div>
            </div>
            <div class="tool-visual reveal-on-scroll" aria-hidden="true">
                <div class="tool-orbit">
                    <span></span>
                    <span></span>
                    <span></span>
                </div>
                <div class="tool-meter">
                    <strong>AI</strong>
                    <small>Healthy target</small>
                </div>
            </div>
        </div>
    </section>

    <section class="section tool-workspace">
        <div class="container">
            <div class="tdee-grid">
                <form class="tool-panel tdee-form reveal-on-scroll" action="<c:url value='/tdee'/>" method="post">
                    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}">
                    <div class="panel-heading">
                        <span class="panel-icon">
                            <svg class="icon" viewBox="0 0 24 24" aria-hidden="true">
                                <path d="M12 2v20"></path>
                                <path d="M5 7h14"></path>
                                <path d="M7 17h10"></path>
                            </svg>
                        </span>
                        <div>
                            <h3>Thông tin của bạn</h3>
                            <p>Các chỉ số cơ bản để tính năng lượng tiêu hao mỗi ngày.</p>
                        </div>
                    </div>

                    <div class="form-section">
                        <label>Giới tính</label>
                        <div class="gender-tabs">
                            <label>
                                <input type="radio" name="gender" value="MALE" ${tdeeRequest.gender != 'FEMALE' ? 'checked' : ''}>
                                <span>Nam</span>
                            </label>
                            <label>
                                <input type="radio" name="gender" value="FEMALE" ${tdeeRequest.gender == 'FEMALE' ? 'checked' : ''}>
                                <span>Nữ</span>
                            </label>
                        </div>
                    </div>

                    <div class="tdee-fields">
                        <div class="form-section">
                            <label>Tuổi</label>
                            <input type="number" name="age" value="${tdeeRequest.age}" placeholder="VD: 25" min="12" max="90" required>
                        </div>
                        <div class="form-section">
                            <label>Cân nặng (kg)</label>
                            <input type="number" step="0.1" name="weight" value="${tdeeRequest.weight}" placeholder="VD: 65" min="25" required>
                        </div>
                        <div class="form-section">
                            <label>Chiều cao (cm)</label>
                            <input type="number" step="0.1" name="height" value="${tdeeRequest.height}" placeholder="VD: 170" min="120" required>
                        </div>
                        <div class="form-section">
                            <label>Mức độ vận động</label>
                            <select name="activityLevel">
                                <option value="1.2" ${tdeeRequest.activityLevel == 1.2 ? 'selected' : ''}>Ít vận động, làm văn phòng</option>
                                <option value="1.375" ${tdeeRequest.activityLevel == 1.375 ? 'selected' : ''}>Vận động nhẹ 1-3 buổi/tuần</option>
                                <option value="1.55" ${tdeeRequest.activityLevel == 1.55 ? 'selected' : ''}>Tập vừa 3-5 buổi/tuần</option>
                                <option value="1.725" ${tdeeRequest.activityLevel == 1.725 ? 'selected' : ''}>Tập nhiều 6-7 buổi/tuần</option>
                            </select>
                        </div>
                    </div>

                    <div class="form-section">
                        <label>Mục tiêu</label>
                        <select name="goal">
                            <option value="MAINTAIN" ${tdeeRequest.goal == 'MAINTAIN' ? 'selected' : ''}>Duy trì cân nặng</option>
                            <option value="LOSE" ${tdeeRequest.goal == 'LOSE' ? 'selected' : ''}>Giảm cân</option>
                            <option value="GAIN" ${tdeeRequest.goal == 'GAIN' ? 'selected' : ''}>Tăng cơ</option>
                        </select>
                    </div>

                    <button class="ai-submit" type="submit">
                        <svg class="icon" viewBox="0 0 24 24" aria-hidden="true">
                            <path d="M4 12h14"></path>
                            <path d="m13 6 6 6-6 6"></path>
                        </svg>
                        Tính toán với AI
                    </button>
                </form>

                <div class="tool-panel result-panel reveal-on-scroll">
                    <c:choose>
                        <c:when test="${empty result}">
                            <div class="result-empty">
                                <div class="result-icon">
                                    <svg class="icon" viewBox="0 0 24 24" aria-hidden="true">
                                        <path d="M4 4h16v16H4z"></path>
                                        <path d="M8 8h8"></path>
                                        <path d="M8 12h8"></path>
                                        <path d="M8 16h4"></path>
                                    </svg>
                                </div>
                                <h3>Sẵn sàng tính toán</h3>
                                <p>Điền thông tin bên trái rồi nhấn “Tính toán với AI” để xem BMR, TDEE và calories theo mục tiêu.</p>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div class="panel-heading">
                                <span class="panel-icon hot">
                                    <svg class="icon" viewBox="0 0 24 24" aria-hidden="true">
                                        <path d="M4 14h4l3-8 4 14 3-6h2"></path>
                                    </svg>
                                </span>
                                <div>
                                    <h3>Kết quả phân tích</h3>
                                    <p>Dựa trên chỉ số bạn vừa nhập.</p>
                                </div>
                            </div>

                            <div class="result-summary">
                                <div class="result-card">
                                    <span>BMR</span>
                                    <strong><fmt:formatNumber value="${result.bmr}" maxFractionDigits="0"/></strong>
                                    <small>kcal nền</small>
                                </div>
                                <div class="result-card primary">
                                    <span>TDEE mỗi ngày</span>
                                    <strong><fmt:formatNumber value="${result.tdee}" maxFractionDigits="0"/></strong>
                                    <small>kcal/ngày</small>
                                </div>
                            </div>

                            <div class="goal-calories">
                                <div>
                                    <small>Giảm cân</small>
                                    <strong><fmt:formatNumber value="${result.loseWeightCalories}" maxFractionDigits="0"/></strong>
                                    <span>kcal</span>
                                </div>
                                <div class="active">
                                    <small>Giữ dáng</small>
                                    <strong><fmt:formatNumber value="${result.maintainCalories}" maxFractionDigits="0"/></strong>
                                    <span>kcal</span>
                                </div>
                                <div>
                                    <small>Tăng cơ</small>
                                    <strong><fmt:formatNumber value="${result.gainMuscleCalories}" maxFractionDigits="0"/></strong>
                                    <span>kcal</span>
                                </div>
                            </div>

                            <div class="macro-guide">
                                <div><strong>Protein</strong><span>1.6 - 2.2g/kg</span></div>
                                <div><strong>Carbs</strong><span>Ưu tiên cơm gạo lứt, khoai</span></div>
                                <div><strong>Fat</strong><span>Giữ ở mức vừa phải</span></div>
                            </div>

                            <div class="ai-note">${result.recommendation}</div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </div>
    </section>
</main>

<jsp:include page="common/footer.jsp"/>
