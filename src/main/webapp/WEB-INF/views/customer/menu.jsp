<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>

<c:set var="pageTitle" value="Our Menu — FoodZone" />
<c:set var="activePage" value="menu" />

<jsp:include page="/WEB-INF/views/common/header.jsp" />
<jsp:include page="/WEB-INF/views/common/navbar.jsp" />

<!-- Page Header -->
<div class="page-header">
    <div class="container" style="position:relative;z-index:1;">
        <c:if test="${param.msg == 'welcome'}">
            <div class="alert alert-success" style="margin-bottom:var(--sp-5);max-width:520px;">
                <i class="fa-solid fa-circle-check alert-icon"></i>
                <span>Welcome to FoodZone! Browse our menu and build your perfect meal.</span>
            </div>
        </c:if>
        <c:if test="${param.msg == 'cart_empty'}">
            <div class="alert alert-warning" style="margin-bottom:var(--sp-5);max-width:520px;">
                <i class="fa-solid fa-circle-exclamation alert-icon"></i>
                <span>Your cart is empty. Add items before checking out.</span>
            </div>
        </c:if>

        <div style="display:flex;align-items:flex-start;justify-content:space-between;flex-wrap:wrap;gap:var(--sp-6);">
            <div>
                <div class="page-header-label">Explore Deliciousness</div>
                <h1>Our Handcrafted Menu</h1>
                <p class="page-header-sub">Fresh ingredients · Chef-crafted · Delivered in 30 min</p>
            </div>

            <!-- Search Form -->
            <form action="${pageContext.request.contextPath}/menu" method="get"
                  style="display:flex;gap:var(--sp-2);width:100%;max-width:400px;align-self:flex-end;">
                <c:if test="${not empty selectedCategoryId}">
                    <input type="hidden" name="category" value="${selectedCategoryId}">
                </c:if>
                <div class="input-icon-wrap" style="flex:1;">
                    <i class="fa-solid fa-magnifying-glass input-icon"></i>
                    <input type="text" name="q" value="<c:out value='${searchQuery}'/>"
                           placeholder="Search dishes…"
                           class="form-control" style="border-radius:var(--r-full);background:rgba(255,255,255,.1);border-color:rgba(255,255,255,.15);color:#fff;"
                           id="menu-search-input">
                </div>
                <button type="submit" class="btn btn-primary btn-sm" style="border-radius:var(--r-full);" id="menu-search-btn">
                    Search
                </button>
                <c:if test="${not empty searchQuery or not empty selectedCategoryId}">
                    <a href="${pageContext.request.contextPath}/menu" class="btn btn-sm"
                       style="border-radius:var(--r-full);background:rgba(255,255,255,.1);color:#fff;border:1.5px solid rgba(255,255,255,.15);"
                       title="Clear Filters">
                        <i class="fa-solid fa-xmark"></i>
                    </a>
                </c:if>
            </form>
        </div>
    </div>
</div>

<main style="background:var(--ink-50);padding-bottom:var(--sp-16);">
    <div class="container" style="padding-top:var(--sp-8);">

        <!-- Category Pills -->
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

        <!-- Results count / label -->
        <c:if test="${not empty foodItems}">
            <div style="display:flex;align-items:center;justify-content:space-between;margin-bottom:var(--sp-6);">
                <span style="font-size:.85rem;color:var(--ink-400);font-weight:600;">
                    <c:out value="${fn:length(foodItems)}" default=""/>
                    <c:if test="${not empty searchQuery}">
                        results for "<strong style="color:var(--ink-700);"><c:out value='${searchQuery}'/></strong>"
                    </c:if>
                    <c:if test="${empty searchQuery}"> items available</c:if>
                </span>
                <div style="display:flex;align-items:center;gap:6px;font-size:.83rem;color:var(--ink-400);">
                    <i class="fa-solid fa-circle" style="font-size:.4rem;color:var(--emerald);"></i>
                    Sorted by popularity
                </div>
            </div>
        </c:if>

        <!-- Menu Grid -->
        <c:choose>
            <c:when test="${not empty foodItems}">
                <div class="food-grid">
                    <c:forEach var="item" items="${foodItems}" varStatus="loop">
                        <div class="food-card">
                            <div class="food-image-box">
                                <img src="${item.imageUrl}" alt="${item.foodName}" loading="lazy"
                                     onerror="this.src='https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=600&q=80';">

                                <!-- Veg / Non-Veg -->
                                <c:choose>
                                    <c:when test="${item.veg}">
                                        <div class="veg-badge" title="Vegetarian"><div class="veg-dot"></div></div>
                                    </c:when>
                                    <c:otherwise>
                                        <div class="veg-badge nonveg-badge" title="Non-Vegetarian"><div class="veg-dot nonveg-dot"></div></div>
                                    </c:otherwise>
                                </c:choose>

                                <c:if test="${loop.index < 4}">
                                    <div class="bestseller-ribbon"><i class="fa-solid fa-fire" style="margin-right:3px;"></i>Popular</div>
                                </c:if>

                                <c:if test="${not item.available}">
                                    <div style="position:absolute;inset:0;background:rgba(12,13,15,.6);display:flex;align-items:center;justify-content:center;backdrop-filter:blur(3px);">
                                        <span style="background:var(--ink-900);color:var(--ink-300);padding:8px 18px;border-radius:var(--r-full);font-weight:800;font-size:.82rem;letter-spacing:.05em;text-transform:uppercase;border:1px solid rgba(255,255,255,.1);">Sold Out</span>
                                    </div>
                                </c:if>

                                <div class="price-tag">₹<fmt:formatNumber value="${item.price}" pattern="#,##0"/></div>
                            </div>

                            <div class="food-info">
                                <div class="food-rating">
                                    <i class="fa-solid fa-star"></i> 4.${loop.index % 4 + 5}
                                    <span class="text-muted text-xs font-bold" style="margin-left:2px;">(${98 + loop.index * 17})</span>
                                </div>
                                <h3 class="food-title">${item.foodName}</h3>
                                <p class="food-desc">${item.description}</p>

                                <div class="food-footer">
                                    <span class="food-price">₹<fmt:formatNumber value="${item.price}" pattern="#,##0"/></span>
                                    <c:choose>
                                        <c:when test="${item.available}">
                                            <form action="${pageContext.request.contextPath}/cart" method="post" style="margin:0;">
                                                <input type="hidden" name="action" value="add">
                                                <input type="hidden" name="foodId" value="${item.foodId}">
                                                <input type="hidden" name="quantity" value="1">
                                                <button type="submit" class="add-btn add-to-cart-btn"
                                                        data-food-id="${item.foodId}" title="Add to Cart">
                                                    <i class="fa-solid fa-plus"></i>
                                                </button>
                                            </form>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="badge badge-unavailable">Unavailable</span>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </c:when>
            <c:otherwise>
                <div class="empty-state">
                    <div class="empty-state-icon">
                        <i class="fa-solid fa-bowl-food"></i>
                    </div>
                    <h3>No Dishes Found</h3>
                    <p>We couldn't find dishes matching your query. Try searching for pizza, biryani, or burger.</p>
                    <a href="${pageContext.request.contextPath}/menu" class="btn btn-primary btn-sm">
                        <i class="fa-solid fa-arrow-left"></i> View Full Menu
                    </a>
                </div>
            </c:otherwise>
        </c:choose>
    </div>
</main>

<jsp:include page="/WEB-INF/views/common/footer.jsp" />
