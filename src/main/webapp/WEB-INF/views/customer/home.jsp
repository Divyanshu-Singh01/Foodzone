<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<c:set var="pageTitle" value="FoodZone - Fresh, Fast & Delicious Meals Delivered" />
<c:set var="activePage" value="home" />

<jsp:include page="/WEB-INF/views/common/header.jsp" />
<jsp:include page="/WEB-INF/views/common/navbar.jsp" />

<main>
    <!-- Hero Banner Section -->
    <section class="hero">
        <div class="container hero-grid">
            <div class="hero-content">
                <span class="hero-tag">
                    <i class="fa-solid fa-sparkles"></i> Hand-Crafted & Fresh Every Day
                </span>
                <h1>Crave It? Get It. <span>Delivered In Minutes.</span></h1>
                <p>
                    From sizzling wood-fired pizzas to authentic spiced biryanis and gourmet burgers, FoodZone brings culinary excellence straight to your doorstep.
                </p>
                <div style="display: flex; gap: 16px; align-items: center; flex-wrap: wrap;">
                    <a href="${pageContext.request.contextPath}/menu" class="btn btn-primary" id="hero-order-btn">
                        <i class="fa-solid fa-utensils"></i> Explore Full Menu
                    </a>
                    <a href="${pageContext.request.contextPath}/menu?category=1" class="btn btn-outline" style="color: var(--white); border-color: rgba(255,255,255,0.3);">
                        <i class="fa-solid fa-pizza-slice"></i> Artisan Pizzas
                    </a>
                </div>
            </div>

            <div class="hero-image-wrapper">
                <img src="https://images.unsplash.com/photo-1565299624946-b28f40a0ae38?w=700" alt="Delicious Pizza" class="hero-img">
            </div>
        </div>
    </section>

    <!-- Value Propositions Section -->
    <section style="padding: 48px 0; background: var(--white); border-bottom: 1px solid var(--gray-200);">
        <div class="container" style="display: grid; grid-template-columns: repeat(auto-fit, minmax(240px, 1fr)); gap: 28px;">
            <div style="display: flex; gap: 16px; align-items: center;">
                <div style="width: 52px; height: 52px; border-radius: var(--radius-md); background: var(--primary-light); color: var(--primary); display: flex; align-items: center; justify-content: center; font-size: 1.4rem;">
                    <i class="fa-solid fa-bolt"></i>
                </div>
                <div>
                    <h4 style="font-size: 1.05rem; margin-bottom: 4px;">Superfast Delivery</h4>
                    <p style="font-size: 0.88rem; color: var(--gray-600);">Hot & piping food delivered in 30 minutes</p>
                </div>
            </div>

            <div style="display: flex; gap: 16px; align-items: center;">
                <div style="width: 52px; height: 52px; border-radius: var(--radius-md); background: #E0E7FF; color: #4338CA; display: flex; align-items: center; justify-content: center; font-size: 1.4rem;">
                    <i class="fa-solid fa-award"></i>
                </div>
                <div>
                    <h4 style="font-size: 1.05rem; margin-bottom: 4px;">Top Quality Chefs</h4>
                    <p style="font-size: 0.88rem; color: var(--gray-600);">Fresh local ingredients & authentic recipes</p>
                </div>
            </div>

            <div style="display: flex; gap: 16px; align-items: center;">
                <div style="width: 52px; height: 52px; border-radius: var(--radius-md); background: #D1FAE5; color: #047857; display: flex; align-items: center; justify-content: center; font-size: 1.4rem;">
                    <i class="fa-solid fa-shield-heart"></i>
                </div>
                <div>
                    <h4 style="font-size: 1.05rem; margin-bottom: 4px;">100% Hygienic</h4>
                    <p style="font-size: 0.88rem; color: var(--gray-600);">Contactless packaging & safety verified</p>
                </div>
            </div>
        </div>
    </section>

    <!-- Categories Section -->
    <section class="container" style="padding-top: 50px;">
        <div style="display: flex; justify-content: space-between; align-items: flex-end; margin-bottom: 24px;">
            <div>
                <span style="color: var(--primary); font-weight: 700; font-size: 0.88rem; text-transform: uppercase;">Explore Categories</span>
                <h2 style="font-size: 1.85rem; margin-top: 4px;">What Are You Craving Today?</h2>
            </div>
            <a href="${pageContext.request.contextPath}/menu" class="btn btn-outline btn-sm">
                View All Categories <i class="fa-solid fa-chevron-right" style="font-size: 0.75rem;"></i>
            </a>
        </div>

        <div class="categories-bar">
            <a href="${pageContext.request.contextPath}/menu" class="cat-pill active">
                <i class="fa-solid fa-utensils"></i> All Categories
            </a>
            <c:forEach var="cat" items="${categories}">
                <a href="${pageContext.request.contextPath}/menu?category=${cat.categoryId}" class="cat-pill">
                    <i class="fa-solid ${cat.iconClass}"></i> ${cat.categoryName}
                </a>
            </c:forEach>
        </div>
    </section>

    <!-- Featured Food Items Grid -->
    <section class="container" style="padding-bottom: 60px;">
        <div style="display: flex; justify-content: space-between; align-items: flex-end; margin-bottom: 28px;">
            <div>
                <span style="color: var(--primary); font-weight: 700; font-size: 0.88rem; text-transform: uppercase;">Chef's Recommendations</span>
                <h2 style="font-size: 1.85rem; margin-top: 4px;">Popular Favorites</h2>
            </div>
        </div>

        <div class="food-grid">
            <c:forEach var="item" items="${featuredItems}">
                <div class="food-card">
                    <div class="food-image-box">
                        <img src="${item.imageUrl}" alt="${item.foodName}" loading="lazy"
                             onerror="this.src='https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=600';">
                        
                        <!-- Veg / Non-Veg Indicator -->
                        <c:choose>
                            <c:when test="${item.veg}">
                                <div class="veg-badge" title="Vegetarian">
                                    <div class="veg-dot"></div>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <div class="veg-badge nonveg-badge" title="Non-Vegetarian">
                                    <div class="veg-dot nonveg-dot"></div>
                                </div>
                            </c:otherwise>
                        </c:choose>

                        <div class="price-tag">
                            ₹<fmt:formatNumber value="${item.price}" pattern="#,##0.00"/>
                        </div>
                    </div>

                    <div class="food-info">
                        <h3 class="food-title">${item.foodName}</h3>
                        <p class="food-desc">${item.description}</p>
                        
                        <div class="food-footer">
                            <span class="food-price">₹<fmt:formatNumber value="${item.price}" pattern="#,##0.00"/></span>
                            <form action="${pageContext.request.contextPath}/cart" method="post" style="margin: 0;">
                                <input type="hidden" name="action" value="add">
                                <input type="hidden" name="foodId" value="${item.foodId}">
                                <input type="hidden" name="quantity" value="1">
                                <button type="submit" class="btn btn-primary btn-sm add-to-cart-btn" data-food-id="${item.foodId}">
                                    <i class="fa-solid fa-plus"></i> Add
                                </button>
                            </form>
                        </div>
                    </div>
                </div>
            </c:forEach>
        </div>
    </section>
</main>

<jsp:include page="/WEB-INF/views/common/footer.jsp" />
