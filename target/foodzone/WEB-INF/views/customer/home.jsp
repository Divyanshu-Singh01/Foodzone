<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<c:set var="pageTitle" value="FoodZone — Premium Food Delivered Fast" />
<c:set var="activePage" value="home" />

<jsp:include page="/WEB-INF/views/common/header.jsp" />
<jsp:include page="/WEB-INF/views/common/navbar.jsp" />

<main>

    <!-- ══════════════════════════ HERO ══════════════════════════ -->
    <section class="hero">
        <div class="container">
            <div class="hero-grid">
                <!-- Left: Text Content -->
                <div class="hero-content" style="position:relative;z-index:1;">
                    <span class="hero-eyebrow">
                        <i class="fa-solid fa-fire-burner"></i> Premium Food. Fast Delivery.
                    </span>

                    <h1>
                        Crave it. <span class="highlight">Order it.</span><br>Get it Fast.
                    </h1>

                    <p class="hero-desc">
                        From hand-crafted wood-fired pizzas to authentic spiced biryanis
                        and gourmet burgers — FoodZone brings culinary excellence to your door
                        in under 30 minutes.
                    </p>

                    <div class="hero-actions">
                        <a href="${pageContext.request.contextPath}/menu" class="btn btn-primary btn-lg" id="hero-order-btn">
                            <i class="fa-solid fa-utensils"></i> Explore Menu
                        </a>
                        <a href="${pageContext.request.contextPath}/menu?category=1" class="btn btn-lg"
                           style="background:rgba(255,255,255,.08);color:#fff;border:1.5px solid rgba(255,255,255,.2);">
                            <i class="fa-solid fa-pizza-slice"></i> Artisan Pizzas
                        </a>
                    </div>

                    <div class="hero-stats">
                        <div>
                            <div class="hero-stat-num">30<span style="font-size:1.1rem;">min</span></div>
                            <div class="hero-stat-label">Avg. Delivery</div>
                        </div>
                        <div>
                            <div class="hero-stat-num">50+</div>
                            <div class="hero-stat-label">Dishes on Menu</div>
                        </div>
                        <div>
                            <div class="hero-stat-num">4.8<i class="fa-solid fa-star" style="font-size:1rem;color:var(--amber);margin-left:4px;"></i></div>
                            <div class="hero-stat-label">Avg. Rating</div>
                        </div>
                    </div>
                </div>

                <!-- Right: Image with floating badges -->
                <div class="hero-image-side">
                    <div class="hero-img-ring"></div>

                    <div class="hero-img-wrapper">
                        <img src="https://images.unsplash.com/photo-1565299624946-b28f40a0ae38?w=700&q=85"
                             alt="Delicious Food from FoodZone"
                             loading="eager">
                    </div>

                    <!-- Floating badge 1 -->
                    <div class="hero-float-badge badge-1">
                        <div class="hero-float-badge-icon" style="background:var(--emerald-light);color:var(--emerald);">
                            <i class="fa-solid fa-shield-heart"></i>
                        </div>
                        <div class="hero-float-badge-text">
                            <strong>Hygienic & Safe</strong>
                            <span>FSSAI Certified</span>
                        </div>
                    </div>

                    <!-- Floating badge 2 -->
                    <div class="hero-float-badge badge-2">
                        <div class="hero-float-badge-icon" style="background:var(--amber-light);color:var(--amber);">
                            <i class="fa-solid fa-bolt"></i>
                        </div>
                        <div class="hero-float-badge-text">
                            <strong>Lightning Fast</strong>
                            <span>30-min guarantee</span>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- ════════════════════ FEATURE STRIP ════════════════════ -->
    <section class="features-strip">
        <div class="container">
            <div class="features-grid">
                <div class="feature-item">
                    <div class="feature-icon-wrap" style="background:var(--brand-100);color:var(--brand);">
                        <i class="fa-solid fa-bolt"></i>
                    </div>
                    <div>
                        <div class="feature-title">Superfast Delivery</div>
                        <div class="feature-desc">Hot & fresh in 30 minutes, guaranteed</div>
                    </div>
                </div>
                <div class="feature-item">
                    <div class="feature-icon-wrap" style="background:#EDE9FE;color:#7C3AED;">
                        <i class="fa-solid fa-award"></i>
                    </div>
                    <div>
                        <div class="feature-title">Master Chefs</div>
                        <div class="feature-desc">Locally sourced, authentically crafted</div>
                    </div>
                </div>
                <div class="feature-item">
                    <div class="feature-icon-wrap" style="background:var(--emerald-light);color:var(--emerald);">
                        <i class="fa-solid fa-shield-heart"></i>
                    </div>
                    <div>
                        <div class="feature-title">100% Hygienic</div>
                        <div class="feature-desc">Contactless packaging, safety verified</div>
                    </div>
                </div>
                <div class="feature-item">
                    <div class="feature-icon-wrap" style="background:var(--amber-light);color:var(--amber);">
                        <i class="fa-solid fa-tag"></i>
                    </div>
                    <div>
                        <div class="feature-title">Free Delivery</div>
                        <div class="feature-desc">On orders over ₹500</div>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- ════════════════════ CATEGORIES ════════════════════ -->
    <section class="section-sm" style="background:var(--ink-0);border-bottom:1px solid var(--ink-100);">
        <div class="container">
            <div class="section-header">
                <div>
                    <span class="section-label">Browse by Type</span>
                    <h2 class="section-title">What Are You Craving?</h2>
                </div>
                <a href="${pageContext.request.contextPath}/menu" class="btn btn-outline btn-sm">
                    All Categories <i class="fa-solid fa-arrow-right" style="font-size:.75rem;"></i>
                </a>
            </div>

            <div class="categories-bar">
                <a href="${pageContext.request.contextPath}/menu" class="cat-pill active">
                    <i class="fa-solid fa-border-all"></i> All Dishes
                </a>
                <c:forEach var="cat" items="${categories}">
                    <a href="${pageContext.request.contextPath}/menu?category=${cat.categoryId}" class="cat-pill">
                        <i class="fa-solid ${cat.iconClass}"></i> ${cat.categoryName}
                    </a>
                </c:forEach>
            </div>
        </div>
    </section>

    <!-- ════════════════════ FEATURED ITEMS ════════════════════ -->
    <section class="section" style="background:var(--ink-50);">
        <div class="container">
            <div class="section-header">
                <div>
                    <span class="section-label">Chef's Picks</span>
                    <h2 class="section-title">Popular Favorites</h2>
                </div>
                <a href="${pageContext.request.contextPath}/menu" class="btn btn-primary btn-sm">
                    Full Menu <i class="fa-solid fa-arrow-right" style="font-size:.75rem;"></i>
                </a>
            </div>

            <div class="food-grid">
                <c:forEach var="item" items="${featuredItems}" varStatus="loop">
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

                            <!-- Bestseller ribbon on first 3 -->
                            <c:if test="${loop.index < 3}">
                                <div class="bestseller-ribbon"><i class="fa-solid fa-fire" style="margin-right:3px;"></i>Popular</div>
                            </c:if>

                            <div class="price-tag">₹<fmt:formatNumber value="${item.price}" pattern="#,##0"/></div>
                        </div>

                        <div class="food-info">
                            <div class="food-rating">
                                <i class="fa-solid fa-star"></i> 4.${loop.index % 3 + 6}
                                <span class="text-muted text-xs font-bold" style="margin-left:2px;">(${120 + loop.index * 23})</span>
                            </div>
                            <h3 class="food-title">${item.foodName}</h3>
                            <p class="food-desc">${item.description}</p>

                            <div class="food-footer">
                                <span class="food-price">₹<fmt:formatNumber value="${item.price}" pattern="#,##0"/></span>
                                <form action="${pageContext.request.contextPath}/cart" method="post" style="margin:0;">
                                    <input type="hidden" name="action" value="add">
                                    <input type="hidden" name="foodId" value="${item.foodId}">
                                    <input type="hidden" name="quantity" value="1">
                                    <button type="submit" class="add-btn add-to-cart-btn" data-food-id="${item.foodId}" title="Add to Cart">
                                        <i class="fa-solid fa-plus"></i>
                                    </button>
                                </form>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </div>

            <!-- CTA Banner -->
            <div style="background:linear-gradient(135deg,var(--ink-900),var(--ink-800));border-radius:var(--r-2xl);padding:var(--sp-12) var(--sp-16);display:flex;align-items:center;justify-content:space-between;gap:var(--sp-8);flex-wrap:wrap;position:relative;overflow:hidden;">
                <div style="position:absolute;width:300px;height:300px;border-radius:50%;background:radial-gradient(circle,rgba(255,77,0,.18) 0%,transparent 70%);right:-60px;top:-60px;"></div>
                <div style="position:relative;z-index:1;">
                    <div style="font-size:.75rem;font-weight:800;text-transform:uppercase;letter-spacing:.1em;color:var(--brand-400);margin-bottom:var(--sp-2);">Limited Time Offer</div>
                    <h2 style="font-family:var(--font-display);font-size:1.9rem;color:#fff;font-weight:800;letter-spacing:-.03em;margin-bottom:var(--sp-2);">Free Delivery on First Order</h2>
                    <p style="color:var(--ink-300);font-size:.95rem;">Use code <strong style="color:var(--brand-400);font-family:monospace;font-size:1.1rem;letter-spacing:.05em;">WELCOME</strong> at checkout</p>
                </div>
                <a href="${pageContext.request.contextPath}/menu" class="btn btn-primary btn-xl" style="position:relative;z-index:1;">
                    <i class="fa-solid fa-bag-shopping"></i> Order Now
                </a>
            </div>
        </div>
    </section>

</main>

<jsp:include page="/WEB-INF/views/common/footer.jsp" />
