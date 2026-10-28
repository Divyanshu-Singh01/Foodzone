<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<c:set var="pageTitle" value="Our Menu - FoodZone" />
<c:set var="activePage" value="menu" />

<jsp:include page="/WEB-INF/views/common/header.jsp" />
<jsp:include page="/WEB-INF/views/common/navbar.jsp" />

<main class="container" style="padding-top: 36px; padding-bottom: 60px;">
    <!-- Welcome Alert or Notification -->
    <c:if test="${param.msg == 'welcome'}">
        <div class="alert alert-success">
            <i class="fa-solid fa-circle-check"></i> Welcome to FoodZone! Explore our menu and start building your meal.
        </div>
    </c:if>
    <c:if test="${param.msg == 'cart_empty'}">
        <div class="alert alert-danger">
            <i class="fa-solid fa-circle-exclamation"></i> Your cart is currently empty. Please add items before checking out.
        </div>
    </c:if>

    <!-- Header & Search Bar -->
    <div style="display: flex; justify-content: space-between; align-items: center; flex-wrap: wrap; gap: 20px; margin-bottom: 28px;">
        <div>
            <span style="color: var(--primary); font-weight: 700; font-size: 0.88rem; text-transform: uppercase;">Explore Deliciousness</span>
            <h1 style="font-size: 2.2rem; margin-top: 4px;">Our Handcrafted Menu</h1>
        </div>

        <!-- Search Form -->
        <form action="${pageContext.request.contextPath}/menu" method="get" style="display: flex; gap: 10px; width: 100%; max-width: 420px;">
            <c:if test="${not empty selectedCategoryId}">
                <input type="hidden" name="category" value="${selectedCategoryId}">
            </c:if>
            <div style="position: relative; flex: 1;">
                <i class="fa-solid fa-magnifying-glass" style="position: absolute; left: 16px; top: 50%; transform: translateY(-50%); color: var(--gray-600);"></i>
                <input type="text" name="q" value="<c:out value='${searchQuery}'/>" placeholder="Search by name or dish..." class="form-control" style="padding-left: 42px; border-radius: var(--radius-full);">
            </div>
            <button type="submit" class="btn btn-primary btn-sm" style="border-radius: var(--radius-full); padding: 0 20px;">
                Search
            </button>
            <c:if test="${not empty searchQuery or not empty selectedCategoryId}">
                <a href="${pageContext.request.contextPath}/menu" class="btn btn-secondary btn-sm" style="border-radius: var(--radius-full);" title="Clear Filters">
                    <i class="fa-solid fa-xmark"></i>
                </a>
            </c:if>
        </form>
    </div>

    <!-- Category Pills Filter -->
    <div class="categories-bar">
        <a href="${pageContext.request.contextPath}/menu<c:if test='${not empty searchQuery}'>?q=<c:out value='${searchQuery}'/></c:if>"
           class="cat-pill ${empty selectedCategoryId ? 'active' : ''}">
            <i class="fa-solid fa-border-all"></i> All Dishes
        </a>
        <c:forEach var="cat" items="${categories}">
            <a href="${pageContext.request.contextPath}/menu?category=${cat.categoryId}<c:if test='${not empty searchQuery}'>&q=<c:out value='${searchQuery}'/></c:if>"
               class="cat-pill ${selectedCategoryId == cat.categoryId ? 'active' : ''}">
                <i class="fa-solid ${cat.iconClass}"></i> ${cat.categoryName}
            </a>
        </c:forEach>
    </div>

    <!-- Menu Grid -->
    <c:choose>
        <c:when test="${not empty foodItems}">
            <div class="food-grid">
                <c:forEach var="item" items="${foodItems}">
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

                                <c:choose>
                                    <c:when test="${item.available}">
                                        <form action="${pageContext.request.contextPath}/cart" method="post" style="margin: 0;">
                                            <input type="hidden" name="action" value="add">
                                            <input type="hidden" name="foodId" value="${item.foodId}">
                                            <input type="hidden" name="quantity" value="1">
                                            <button type="submit" class="btn btn-primary btn-sm add-to-cart-btn" data-food-id="${item.foodId}">
                                                <i class="fa-solid fa-cart-plus"></i> Add
                                            </button>
                                        </form>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="badge badge-cancelled" style="font-size: 0.85rem;">Sold Out</span>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </c:when>
        <c:otherwise>
            <!-- Empty Search / Filter State -->
            <div style="text-align: center; padding: 60px 20px; background: var(--white); border-radius: var(--radius-lg); border: 1px solid var(--gray-200); margin: 30px 0;">
                <div style="width: 72px; height: 72px; border-radius: 50%; background: var(--gray-100); color: var(--gray-600); display: flex; align-items: center; justify-content: center; font-size: 2rem; margin: 0 auto 18px;">
                    <i class="fa-solid fa-utensils"></i>
                </div>
                <h3 style="font-size: 1.4rem; margin-bottom: 8px;">No Food Items Found</h3>
                <p style="color: var(--gray-600); max-width: 420px; margin: 0 auto 24px;">
                    We couldn't find any dishes matching your query. Try searching for pizza, biryani, or burger.
                </p>
                <a href="${pageContext.request.contextPath}/menu" class="btn btn-primary btn-sm">
                    View Full Menu
                </a>
            </div>
        </c:otherwise>
    </c:choose>
</main>

<jsp:include page="/WEB-INF/views/common/footer.jsp" />
