<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<c:set var="pageCss" value="tools.css" scope="request"/>
<jsp:include page="common/header.jsp"/>

<main class="nutrition-page">
    <section class="nutrition-hero">
        <div class="container">
            <div class="section-title tool-title reveal-on-scroll">
                <span class="eyebrow">Bảng dinh dưỡng</span>
                <h2>Tính chất dinh dưỡng & calo</h2>
                <p>Tra cứu calories, protein, carbs và fat của thực phẩm phổ biến để chọn bữa ăn hợp mục tiêu.</p>
            </div>

            <form class="nutrition-search reveal-on-scroll" method="get" action="<c:url value='/nutrition'/>">
                <svg class="icon" viewBox="0 0 24 24" aria-hidden="true">
                    <circle cx="11" cy="11" r="8"></circle>
                    <path d="m21 21-4.3-4.3"></path>
                </svg>
                <input name="keyword" value="${keyword}" placeholder="Tìm thực phẩm... ví dụ: gà, cơm, trứng">
                <button type="submit">Tìm</button>
            </form>

            <div class="chip-row reveal-on-scroll">
                <a class="chip ${empty keyword ? 'active' : ''}" href="<c:url value='/nutrition'/>">Tất cả</a>
                <a class="chip" href="<c:url value='/nutrition?keyword=gà'/>">Thịt & Cá</a>
                <a class="chip" href="<c:url value='/nutrition?keyword=cơm'/>">Tinh bột</a>
                <a class="chip" href="<c:url value='/nutrition?keyword=bông cải'/>">Rau củ</a>
                <a class="chip" href="<c:url value='/nutrition?keyword=trứng'/>">Protein nhanh</a>
                <a class="chip" href="<c:url value='/nutrition?keyword=khoai'/>">Meal prep</a>
            </div>
        </div>
    </section>

    <section class="section nutrition-results">
        <div class="container">
            <div class="nutrition-count reveal-on-scroll">
                <span>Hiển thị</span>
                <strong>${fn:length(items)}</strong>
                <span>thực phẩm</span>
            </div>

            <c:choose>
                <c:when test="${empty items}">
                    <div class="tool-panel empty-nutrition reveal-on-scroll">
                        <h3>Không tìm thấy thực phẩm phù hợp</h3>
                        <p>Thử tìm bằng tên ngắn hơn như “gà”, “cơm”, “trứng” hoặc “khoai”.</p>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="nutrition-grid">
                        <c:forEach items="${items}" var="item" varStatus="loop">
                            <article class="nutrition-card" style="--delay:${loop.index * 45}ms">
                                <div class="nutrition-card-head">
                                    <div>
                                        <h3>${item.foodName}</h3>
                                        <p>Khẩu phần tham chiếu 100g</p>
                                    </div>
                                    <span class="food-tag">Food</span>
                                </div>

                                <div class="calories">
                                    <svg class="icon" viewBox="0 0 24 24" aria-hidden="true">
                                        <path d="M8.5 14.5A3.5 3.5 0 1 0 12 11c0-2.5-2-4.5-2-7-2 1.5-4 4-4 7a6 6 0 1 0 12 0c0-1.8-.8-3.4-2-4.5"></path>
                                    </svg>
                                    <strong>${item.calories}</strong>
                                    <span>kcal</span>
                                </div>

                                <div class="nutrition-macros">
                                    <div><strong>${item.protein}g</strong><span>Protein</span></div>
                                    <div><strong>${item.carbs}g</strong><span>Carbs</span></div>
                                    <div><strong>${item.fat}g</strong><span>Fat</span></div>
                                    <div><strong>0g</strong><span>Fiber</span></div>
                                </div>

                                <button class="nutrition-detail-toggle" type="button" data-toggle-detail>
                                    Chi tiết dinh dưỡng
                                    <svg class="icon" viewBox="0 0 24 24" aria-hidden="true">
                                        <path d="m6 9 6 6 6-6"></path>
                                    </svg>
                                </button>
                                <div class="nutrition-detail">
                                    <p>Gợi ý: kết hợp thực phẩm này với rau xanh và nguồn tinh bột tốt để bữa ăn cân bằng hơn.</p>
                                </div>
                            </article>
                        </c:forEach>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </section>
</main>

<jsp:include page="common/footer.jsp"/>
