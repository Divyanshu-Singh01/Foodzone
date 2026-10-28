<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<c:set var="pageTitle" value="Your Cart — FoodZone" />
<c:set var="activePage" value="cart" />

<jsp:include page="/WEB-INF/views/common/header.jsp" />
<jsp:include page="/WEB-INF/views/common/navbar.jsp" />

<!-- Page Header -->
<div class="page-header">
    <div class="container" style="position:relative;z-index:1;">
        <div class="page-header-label">Checkout Step 1 of 2</div>
        <h1>Shopping Cart</h1>
        <p class="page-header-sub">Review your items and proceed when ready</p>
    </div>
</div>

<main style="background:var(--ink-50);padding-bottom:var(--sp-16);">
<div class="container">

<c:choose>
    <c:when test="${not empty sessionScope.cart and sessionScope.cart.itemCount > 0}">

        <!-- Checkout Progress -->
        <div class="checkout-steps" style="margin:var(--sp-8) 0 var(--sp-6);">
            <div class="checkout-step active">
                <div class="checkout-step-num">1</div>
                <span>Cart</span>
            </div>
            <div class="checkout-step-sep"></div>
            <div class="checkout-step">
                <div class="checkout-step-num">2</div>
                <span>Address & Payment</span>
            </div>
            <div class="checkout-step-sep"></div>
            <div class="checkout-step">
                <div class="checkout-step-num">3</div>
                <span>Confirmation</span>
            </div>
        </div>

        <div class="cart-layout">
            <!-- ── LEFT: Cart Items ── -->
            <div>
                <div class="cart-card">
                    <div class="cart-card-header">
                        <h2 style="font-family:var(--font-display);font-size:1.1rem;font-weight:800;">
                            Cart Items
                            <span style="font-size:.82rem;font-weight:600;color:var(--ink-400);margin-left:6px;">
                                (${sessionScope.cart.itemCount} item${sessionScope.cart.itemCount != 1 ? 's' : ''})
                            </span>
                        </h2>
                        <form action="${pageContext.request.contextPath}/cart" method="post"
                              onsubmit="return confirm('Clear all items from cart?');">
                            <input type="hidden" name="action" value="clear">
                            <button type="submit" class="btn btn-ghost btn-sm"
                                    style="color:var(--red);font-size:.83rem;" id="clear-cart-btn">
                                <i class="fa-regular fa-trash-can"></i> Clear Cart
                            </button>
                        </form>
                    </div>

                    <c:forEach var="item" items="${sessionScope.cart.items}">
                        <div class="cart-item">
                            <img src="${item.foodItem.imageUrl}" alt="${item.foodItem.foodName}"
                                 class="cart-item-img"
                                 onerror="this.src='https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=200&q=80';">

                            <div class="cart-item-details">
                                <div style="display:flex;align-items:center;gap:6px;margin-bottom:3px;">
                                    <c:choose>
                                        <c:when test="${item.foodItem.veg}">
                                            <div class="veg-badge" style="width:16px;height:16px;position:static;">
                                                <div class="veg-dot" style="width:7px;height:7px;"></div>
                                            </div>
                                        </c:when>
                                        <c:otherwise>
                                            <div class="veg-badge nonveg-badge" style="width:16px;height:16px;position:static;">
                                                <div class="veg-dot nonveg-dot" style="width:7px;height:7px;"></div>
                                            </div>
                                        </c:otherwise>
                                    </c:choose>
                                    <h3 class="cart-item-title">${item.foodItem.foodName}</h3>
                                </div>
                                <p class="cart-item-price">₹<fmt:formatNumber value="${item.foodItem.price}" pattern="#,##0"/> × ${item.quantity}</p>
                            </div>

                            <!-- Qty Control -->
                            <div class="qty-control">
                                <form action="${pageContext.request.contextPath}/cart" method="post" style="margin:0;">
                                    <input type="hidden" name="action" value="update">
                                    <input type="hidden" name="foodId" value="${item.foodItem.foodId}">
                                    <input type="hidden" name="quantity" value="${item.quantity - 1}">
                                    <button type="submit" class="qty-btn" title="Decrease">
                                        <i class="fa-solid fa-minus" style="font-size:.7rem;"></i>
                                    </button>
                                </form>
                                <span class="qty-number">${item.quantity}</span>
                                <form action="${pageContext.request.contextPath}/cart" method="post" style="margin:0;">
                                    <input type="hidden" name="action" value="update">
                                    <input type="hidden" name="foodId" value="${item.foodItem.foodId}">
                                    <input type="hidden" name="quantity" value="${item.quantity + 1}">
                                    <button type="submit" class="qty-btn" title="Increase">
                                        <i class="fa-solid fa-plus" style="font-size:.7rem;"></i>
                                    </button>
                                </form>
                            </div>

                            <!-- Subtotal -->
                            <div class="cart-item-subtotal">
                                ₹<fmt:formatNumber value="${item.subtotal}" pattern="#,##0"/>
                            </div>

                            <!-- Remove -->
                            <form action="${pageContext.request.contextPath}/cart" method="post" style="margin:0;">
                                <input type="hidden" name="action" value="remove">
                                <input type="hidden" name="foodId" value="${item.foodItem.foodId}">
                                <button type="submit" class="btn-ghost btn btn-icon"
                                        style="color:var(--ink-300);font-size:.95rem;" title="Remove item">
                                    <i class="fa-regular fa-trash-can"></i>
                                </button>
                            </form>
                        </div>
                    </c:forEach>

                    <div style="padding:var(--sp-4) var(--sp-6);">
                        <a href="${pageContext.request.contextPath}/menu" class="btn btn-outline btn-sm">
                            <i class="fa-solid fa-arrow-left"></i> Add More Dishes
                        </a>
                    </div>
                </div>

                <!-- Upsell strip -->
                <c:if test="${not empty upsellItems}">
                    <div class="card card-p" style="margin-top:var(--sp-5);">
                        <div style="display:flex;justify-content:space-between;align-items:center;margin-bottom:var(--sp-4);">
                            <div>
                                <div style="font-size:.72rem;text-transform:uppercase;font-weight:800;letter-spacing:.08em;color:var(--brand);margin-bottom:3px;">Complete Your Meal</div>
                                <h3 style="font-size:1rem;font-weight:800;">Customers Also Loved</h3>
                            </div>
                        </div>
                        <div style="display:grid;grid-template-columns:repeat(auto-fit,minmax(200px,1fr));gap:var(--sp-3);">
                            <c:forEach items="${upsellItems}" var="up" end="3">
                                <div style="border:1.5px solid var(--ink-100);border-radius:var(--r-lg);padding:var(--sp-3);display:flex;gap:var(--sp-3);align-items:center;background:var(--ink-50);">
                                    <img src="${up.imageUrl}" alt="${up.foodName}"
                                         style="width:52px;height:52px;border-radius:var(--r-md);object-fit:cover;flex-shrink:0;">
                                    <div style="flex:1;min-width:0;">
                                        <div style="font-weight:700;font-size:.85rem;white-space:nowrap;overflow:hidden;text-overflow:ellipsis;">${up.foodName}</div>
                                        <div style="color:var(--brand);font-weight:800;font-size:.82rem;">₹<fmt:formatNumber value="${up.price}" pattern="#,##0"/></div>
                                    </div>
                                    <form action="${pageContext.request.contextPath}/cart" method="POST" style="margin:0;">
                                        <input type="hidden" name="action" value="add">
                                        <input type="hidden" name="foodId" value="${up.foodId}">
                                        <input type="hidden" name="quantity" value="1">
                                        <button type="submit" class="add-btn" title="Add">
                                            <i class="fa-solid fa-plus"></i>
                                        </button>
                                    </form>
                                </div>
                            </c:forEach>
                        </div>
                    </div>
                </c:if>
            </div>

            <!-- ── RIGHT: Order Summary ── -->
            <div>
                <div class="summary-card">
                    <div class="summary-title">Order Summary</div>

                    <!-- Free delivery banner -->
                    <c:choose>
                        <c:when test="${sessionScope.cart.deliveryFee == 0}">
                            <div class="alert alert-success" style="margin-bottom:var(--sp-4);">
                                <i class="fa-solid fa-circle-check alert-icon"></i>
                                <span>🎉 You've unlocked <strong>FREE Delivery!</strong></span>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div style="background:var(--brand-100);border:1px solid rgba(255,77,0,.2);border-radius:var(--r-md);padding:var(--sp-3) var(--sp-4);margin-bottom:var(--sp-4);font-size:.83rem;font-weight:600;color:var(--brand);display:flex;align-items:center;gap:6px;">
                                <i class="fa-solid fa-tag"></i> Add ₹<fmt:formatNumber value="${500 - sessionScope.cart.subtotal}" pattern="#,##0"/> more for FREE delivery!
                            </div>
                        </c:otherwise>
                    </c:choose>

                    <!-- Promo code -->
                    <div style="background:var(--ink-50);border:1.5px dashed var(--ink-200);border-radius:var(--r-lg);padding:var(--sp-4);margin-bottom:var(--sp-5);">
                        <div style="font-size:.72rem;font-weight:800;text-transform:uppercase;letter-spacing:.08em;color:var(--ink-400);margin-bottom:var(--sp-2);">
                            <i class="fa-solid fa-ticket" style="color:var(--brand);margin-right:4px;"></i> Promo Code
                        </div>

                        <c:choose>
                            <c:when test="${not empty sessionScope.cart.couponCode}">
                                <div style="background:var(--emerald-light);border:1px solid rgba(0,196,140,.25);border-radius:var(--r-md);padding:var(--sp-3);display:flex;justify-content:space-between;align-items:center;">
                                    <div>
                                        <span style="font-weight:800;color:var(--emerald);font-size:.95rem;">${sessionScope.cart.couponCode}</span>
                                        <span style="font-size:.78rem;color:#047857;display:block;">Saved ₹<fmt:formatNumber value="${sessionScope.cart.discountAmount}" pattern="#,##0"/></span>
                                    </div>
                                    <form action="${pageContext.request.contextPath}/cart" method="POST" style="margin:0;">
                                        <input type="hidden" name="action" value="remove-coupon">
                                        <button type="submit" class="btn btn-ghost btn-xs" style="color:var(--red);">
                                            <i class="fa-solid fa-xmark"></i> Remove
                                        </button>
                                    </form>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <form action="${pageContext.request.contextPath}/cart" method="POST"
                                      style="display:flex;gap:var(--sp-2);">
                                    <input type="hidden" name="action" value="apply-coupon">
                                    <input type="text" name="couponCode" placeholder="WELCOME50"
                                           class="form-control" style="text-transform:uppercase;font-size:.85rem;padding:8px 12px;" required
                                           id="coupon-input">
                                    <button type="submit" class="btn btn-secondary btn-sm" id="apply-coupon-btn">Apply</button>
                                </form>
                                <c:if test="${not empty activeCoupons}">
                                    <div style="display:flex;gap:6px;margin-top:var(--sp-2);flex-wrap:wrap;">
                                        <c:forEach items="${activeCoupons}" var="cp">
                                            <form action="${pageContext.request.contextPath}/cart" method="POST" style="margin:0;">
                                                <input type="hidden" name="action" value="apply-coupon">
                                                <input type="hidden" name="couponCode" value="${cp.code}">
                                                <button type="submit" style="background:var(--ink-0);border:1.5px dashed var(--emerald);color:var(--emerald);padding:3px 10px;border-radius:var(--r-full);font-size:.72rem;font-weight:800;cursor:pointer;font-family:var(--font-body);">
                                                    ${cp.code}
                                                </button>
                                            </form>
                                        </c:forEach>
                                    </div>
                                </c:if>
                            </c:otherwise>
                        </c:choose>
                    </div>

                    <!-- Price breakdown -->
                    <div class="summary-row">
                        <span>Subtotal</span>
                        <span style="font-weight:700;color:var(--ink-900);">₹<fmt:formatNumber value="${sessionScope.cart.subtotal}" pattern="#,##0"/></span>
                    </div>
                    <div class="summary-row">
                        <span>GST & Taxes (5%)</span>
                        <span style="font-weight:700;color:var(--ink-900);">₹<fmt:formatNumber value="${sessionScope.cart.taxAmount}" pattern="#,##0"/></span>
                    </div>
                    <div class="summary-row">
                        <span>Delivery Fee</span>
                        <c:choose>
                            <c:when test="${sessionScope.cart.deliveryFee == 0}">
                                <span style="font-weight:800;color:var(--emerald);">FREE</span>
                            </c:when>
                            <c:otherwise>
                                <span style="font-weight:700;color:var(--ink-900);">₹<fmt:formatNumber value="${sessionScope.cart.deliveryFee}" pattern="#,##0"/></span>
                            </c:otherwise>
                        </c:choose>
                    </div>
                    <c:if test="${sessionScope.cart.discountAmount > 0}">
                        <div class="summary-row" style="color:var(--emerald);">
                            <span>Coupon Discount</span>
                            <span style="font-weight:800;">−₹<fmt:formatNumber value="${sessionScope.cart.discountAmount}" pattern="#,##0"/></span>
                        </div>
                    </c:if>

                    <div class="summary-total">
                        <span class="summary-total-label">Total Payable</span>
                        <span class="summary-total-val">₹<fmt:formatNumber value="${sessionScope.cart.totalAmount}" pattern="#,##0"/></span>
                    </div>

                    <a href="${pageContext.request.contextPath}/checkout" class="btn btn-primary btn-block btn-lg" style="margin-top:var(--sp-4);" id="checkout-btn">
                        Proceed to Checkout <i class="fa-solid fa-arrow-right"></i>
                    </a>

                    <div style="text-align:center;margin-top:var(--sp-4);font-size:.78rem;color:var(--ink-400);display:flex;align-items:center;justify-content:center;gap:5px;">
                        <i class="fa-solid fa-lock" style="color:var(--emerald);"></i>
                        SSL encrypted · Safe & Secure checkout
                    </div>
                </div>
            </div>
        </div><!-- /cart-layout -->

    </c:when>
    <c:otherwise>
        <!-- Empty Cart -->
        <div style="padding:var(--sp-12) 0;">
            <div class="empty-state" style="max-width:520px;margin:0 auto;">
                <div class="empty-state-icon" style="background:var(--brand-100);color:var(--brand);">
                    <i class="fa-solid fa-bag-shopping"></i>
                </div>
                <h3>Your Cart is Empty</h3>
                <p>Looks like you haven't added anything yet. Explore our fresh artisanal pizzas, gourmet burgers, and authentic biryanis!</p>
                <a href="${pageContext.request.contextPath}/menu" class="btn btn-primary" id="browse-menu-empty-cart">
                    <i class="fa-solid fa-utensils"></i> Browse Menu
                </a>
            </div>
        </div>
    </c:otherwise>
</c:choose>

</div><!-- /container -->
</main>

<jsp:include page="/WEB-INF/views/common/footer.jsp" />
