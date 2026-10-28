<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<c:set var="pageTitle" value="Your Shopping Cart - FoodZone" />
<c:set var="activePage" value="cart" />

<jsp:include page="/WEB-INF/views/common/header.jsp" />
<jsp:include page="/WEB-INF/views/common/navbar.jsp" />

<main class="container" style="padding-top: 36px; padding-bottom: 60px;">
    <div style="margin-bottom: 24px;">
        <span style="color: var(--primary); font-weight: 700; font-size: 0.88rem; text-transform: uppercase;">Checkout Step 1</span>
        <h1 style="font-size: 2.2rem; margin-top: 4px;">Shopping Cart</h1>
    </div>

    <c:choose>
        <c:when test="${not empty sessionScope.cart and sessionScope.cart.itemCount > 0}">
            <div class="cart-layout">
                <!-- Cart Items List (Left Column) -->
                <div>
                    <div class="cart-card">
                        <div style="display: flex; justify-content: space-between; align-items: center; border-bottom: 1px solid var(--gray-200); padding-bottom: 16px; margin-bottom: 12px;">
                            <h2 style="font-size: 1.25rem;">Cart Items (${sessionScope.cart.itemCount})</h2>
                            <form action="${pageContext.request.contextPath}/cart" method="post" onsubmit="return confirm('Clear all items from your cart?');">
                                <input type="hidden" name="action" value="clear">
                                <button type="submit" class="btn btn-outline btn-sm" style="color: var(--danger); border-color: var(--gray-300);">
                                    <i class="fa-regular fa-trash-can"></i> Clear Cart
                                </button>
                            </form>
                        </div>

                        <!-- Item Rows -->
                        <c:forEach var="item" items="${sessionScope.cart.items}">
                            <div class="cart-item">
                                <img src="${item.foodItem.imageUrl}" alt="${item.foodItem.foodName}" class="cart-item-img"
                                     onerror="this.src='https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=600';">

                                <div class="cart-item-details">
                                    <div style="display: flex; align-items: center; gap: 8px;">
                                        <c:choose>
                                            <c:when test="${item.foodItem.veg}">
                                                <div class="veg-badge" style="width: 16px; height: 16px; position: static;" title="Vegetarian">
                                                    <div class="veg-dot" style="width: 7px; height: 7px;"></div>
                                                </div>
                                            </c:when>
                                            <c:otherwise>
                                                <div class="veg-badge nonveg-badge" style="width: 16px; height: 16px; position: static;" title="Non-Vegetarian">
                                                    <div class="veg-dot nonveg-dot" style="width: 7px; height: 7px;"></div>
                                                </div>
                                            </c:otherwise>
                                        </c:choose>
                                        <h3 class="cart-item-title">${item.foodItem.foodName}</h3>
                                    </div>
                                    <p class="cart-item-price">₹<fmt:formatNumber value="${item.foodItem.price}" pattern="#,##0.00"/> each</p>
                                </div>

                                <!-- Quantity Control Form -->
                                <div class="qty-control">
                                    <!-- Decrement Button -->
                                    <form action="${pageContext.request.contextPath}/cart" method="post" style="margin: 0;">
                                        <input type="hidden" name="action" value="update">
                                        <input type="hidden" name="foodId" value="${item.foodItem.foodId}">
                                        <input type="hidden" name="quantity" value="${item.quantity - 1}">
                                        <button type="submit" class="qty-btn" title="Decrease Quantity">
                                            <i class="fa-solid fa-minus" style="font-size: 0.75rem;"></i>
                                        </button>
                                    </form>

                                    <span class="qty-number">${item.quantity}</span>

                                    <!-- Increment Button -->
                                    <form action="${pageContext.request.contextPath}/cart" method="post" style="margin: 0;">
                                        <input type="hidden" name="action" value="update">
                                        <input type="hidden" name="foodId" value="${item.foodItem.foodId}">
                                        <input type="hidden" name="quantity" value="${item.quantity + 1}">
                                        <button type="submit" class="qty-btn" title="Increase Quantity">
                                            <i class="fa-solid fa-plus" style="font-size: 0.75rem;"></i>
                                        </button>
                                    </form>
                                </div>

                                <!-- Subtotal for line item -->
                                <div style="min-width: 90px; text-align: right; font-weight: 700; font-size: 1.1rem; color: var(--dark);">
                                    ₹<fmt:formatNumber value="${item.subtotal}" pattern="#,##0.00"/>
                                </div>

                                <!-- Remove Item Button -->
                                <form action="${pageContext.request.contextPath}/cart" method="post" style="margin: 0;">
                                    <input type="hidden" name="action" value="remove">
                                    <input type="hidden" name="foodId" value="${item.foodItem.foodId}">
                                    <button type="submit" class="btn btn-outline btn-sm" style="padding: 6px 10px; border: none; color: var(--gray-600);" title="Remove Item">
                                        <i class="fa-regular fa-trash-can"></i>
                                    </button>
                                </form>
                            </div>
                        </c:forEach>
                    </div>

                    <div style="margin-top: 20px;">
                        <a href="${pageContext.request.contextPath}/menu" class="btn btn-outline btn-sm">
                            <i class="fa-solid fa-arrow-left"></i> Add More Dishes
                        </a>
                    </div>
                </div>

                <!-- Order Summary (Right Column) -->
                <div>
                    <div class="summary-card">
                        <h2 style="font-size: 1.25rem; margin-bottom: 20px; border-bottom: 1px solid var(--gray-200); padding-bottom: 12px;">Order Summary</h2>

                        <!-- Free Delivery Banner / Threshold Calculator -->
                        <c:choose>
                            <c:when test="${sessionScope.cart.deliveryFee == 0}">
                                <div style="background: #D1FAE5; color: #047857; padding: 10px 14px; border-radius: var(--radius-md); font-size: 0.88rem; font-weight: 600; margin-bottom: 20px; display: flex; align-items: center; gap: 8px;">
                                    <i class="fa-solid fa-circle-check"></i> You've unlocked FREE Delivery!
                                </div>
                            </c:when>
                            <c:otherwise>
                                <div style="background: var(--primary-light); color: var(--primary); padding: 10px 14px; border-radius: var(--radius-md); font-size: 0.88rem; font-weight: 600; margin-bottom: 20px; display: flex; align-items: center; gap: 8px;">
                                    <i class="fa-solid fa-tag"></i> Free delivery on orders over ₹500!
                                </div>
                            </c:otherwise>
                        </c:choose>

                        <div style="display: flex; justify-content: space-between; margin-bottom: 12px; color: var(--gray-600); font-size: 0.95rem;">
                            <span>Items Subtotal</span>
                            <span style="font-weight: 600; color: var(--dark);">₹<fmt:formatNumber value="${sessionScope.cart.subtotal}" pattern="#,##0.00"/></span>
                        </div>

                        <div style="display: flex; justify-content: space-between; margin-bottom: 12px; color: var(--gray-600); font-size: 0.95rem;">
                            <span>GST & Taxes (5%)</span>
                            <span style="font-weight: 600; color: var(--dark);">₹<fmt:formatNumber value="${sessionScope.cart.taxAmount}" pattern="#,##0.00"/></span>
                        </div>

                        <div style="display: flex; justify-content: space-between; margin-bottom: 20px; color: var(--gray-600); font-size: 0.95rem;">
                            <span>Delivery Partner Fee</span>
                            <c:choose>
                                <c:when test="${sessionScope.cart.deliveryFee == 0}">
                                    <span style="font-weight: 700; color: var(--secondary);">FREE</span>
                                </c:when>
                                <c:otherwise>
                                    <span style="font-weight: 600; color: var(--dark);">₹<fmt:formatNumber value="${sessionScope.cart.deliveryFee}" pattern="#,##0.00"/></span>
                                </c:otherwise>
                            </c:choose>
                        </div>

                        <div style="display: flex; justify-content: space-between; border-top: 2px dashed var(--gray-200); padding-top: 16px; margin-bottom: 24px; font-size: 1.25rem; font-family: var(--font-heading); font-weight: 800; color: var(--dark);">
                            <span>Total Payable</span>
                            <span style="color: var(--primary);">₹<fmt:formatNumber value="${sessionScope.cart.totalAmount}" pattern="#,##0.00"/></span>
                        </div>

                        <a href="${pageContext.request.contextPath}/checkout" class="btn btn-primary" style="width: 100%; padding: 14px 20px; font-size: 1.05rem;" id="checkout-btn">
                            Proceed to Checkout <i class="fa-solid fa-arrow-right"></i>
                        </a>

                        <div style="text-align: center; margin-top: 16px; font-size: 0.8rem; color: var(--gray-600);">
                            <i class="fa-solid fa-lock" style="color: var(--secondary);"></i> Safe & Secure Checkout
                        </div>
                    </div>
                </div>
            </div>
        </c:when>
        <c:otherwise>
            <!-- Empty Cart State -->
            <div style="text-align: center; padding: 80px 20px; background: var(--white); border-radius: var(--radius-lg); border: 1px solid var(--gray-200); max-width: 600px; margin: 40px auto;">
                <div style="width: 88px; height: 88px; border-radius: 50%; background: var(--primary-light); color: var(--primary); display: flex; align-items: center; justify-content: center; font-size: 2.5rem; margin: 0 auto 24px;">
                    <i class="fa-solid fa-bag-shopping"></i>
                </div>
                <h2 style="font-size: 1.7rem; margin-bottom: 10px;">Your Cart is Empty</h2>
                <p style="color: var(--gray-600); max-width: 420px; margin: 0 auto 28px; line-height: 1.6;">
                    Looks like you haven't added any dishes yet. Discover our fresh artisanal pizzas, burgers, and biryanis!
                </p>
                <a href="${pageContext.request.contextPath}/menu" class="btn btn-primary" id="browse-menu-empty-cart">
                    <i class="fa-solid fa-utensils"></i> Browse Food Menu
                </a>
            </div>
        </c:otherwise>
    </c:choose>
</main>

<jsp:include page="/WEB-INF/views/common/footer.jsp" />
