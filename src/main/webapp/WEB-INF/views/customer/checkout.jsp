<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<c:set var="pageTitle" value="Secure Checkout - FoodZone" />
<c:set var="activePage" value="cart" />

<jsp:include page="/WEB-INF/views/common/header.jsp" />
<jsp:include page="/WEB-INF/views/common/navbar.jsp" />

<main class="container" style="padding-top: 36px; padding-bottom: 60px;">
    <div style="margin-bottom: 28px;">
        <span style="color: var(--primary); font-weight: 700; font-size: 0.88rem; text-transform: uppercase;">Checkout Step 2 of 2</span>
        <h1 style="font-size: 2.2rem; margin-top: 4px;">Confirm Delivery & Place Order</h1>
    </div>

    <!-- Error Message Alert -->
    <c:if test="${not empty errorMessage}">
        <div class="alert alert-danger">
            <i class="fa-solid fa-triangle-exclamation"></i> ${errorMessage}
        </div>
    </c:if>

    <div class="cart-layout">
        <!-- Delivery Details Form (Left Column) -->
        <div class="cart-card">
            <h2 style="font-size: 1.3rem; margin-bottom: 20px; border-bottom: 1px solid var(--gray-200); padding-bottom: 12px;">
                <i class="fa-solid fa-truck-ramp-box" style="color: var(--primary); margin-right: 8px;"></i> Delivery Information
            </h2>

            <form action="${pageContext.request.contextPath}/checkout" method="post" id="checkout-form">
                <!-- Customer Name -->
                <div class="form-group">
                    <label class="form-label">Ordering As</label>
                    <input type="text" class="form-control" value="${sessionScope.currentUser.fullName} (${sessionScope.currentUser.email})" readonly style="background: var(--gray-50); color: var(--gray-600); cursor: not-allowed;">
                </div>

                <!-- Contact Phone -->
                <div class="form-group">
                    <label class="form-label" for="contactPhone">Contact Phone Number <span style="color: var(--danger);">*</span></label>
                    <input type="tel" id="contactPhone" name="contactPhone" class="form-control" required placeholder="e.g. 9876543210"
                           value="${not empty param.contactPhone ? param.contactPhone : sessionScope.currentUser.phone}">
                </div>

                <!-- Delivery Address -->
                <div class="form-group">
                    <label class="form-label" for="deliveryAddress">Complete Delivery Address <span style="color: var(--danger);">*</span></label>
                    <textarea id="deliveryAddress" name="deliveryAddress" class="form-control" rows="3" required placeholder="Flat/House No, Building, Street, Landmark, Pincode">${not empty param.deliveryAddress ? param.deliveryAddress : sessionScope.currentUser.address}</textarea>
                </div>

                <!-- Payment Method Selection -->
                <div class="form-group" style="margin-top: 24px;">
                    <label class="form-label">Payment Method</label>
                    <div style="display: flex; flex-direction: column; gap: 12px; margin-top: 10px;">
                        <label style="display: flex; align-items: center; gap: 12px; padding: 14px 18px; border: 1.5px solid var(--primary); border-radius: var(--radius-md); background: var(--primary-light); cursor: pointer;">
                            <input type="radio" name="paymentMethod" value="Cash on Delivery" checked style="accent-color: var(--primary);">
                            <div>
                                <strong style="color: var(--dark); display: block;">Cash on Delivery (COD)</strong>
                                <span style="font-size: 0.85rem; color: var(--gray-600);">Pay cash or scan QR at your doorstep upon arrival</span>
                            </div>
                        </label>

                        <label style="display: flex; align-items: center; gap: 12px; padding: 14px 18px; border: 1.5px solid var(--gray-200); border-radius: var(--radius-md); background: var(--white); cursor: pointer;">
                            <input type="radio" name="paymentMethod" value="UPI / Online Demo" style="accent-color: var(--primary);">
                            <div>
                                <strong style="color: var(--dark); display: block;">UPI / Online Instant (Demo)</strong>
                                <span style="font-size: 0.85rem; color: var(--gray-600);">Instant simulated payment via GooglePay, PhonePe, or Paytm</span>
                            </div>
                        </label>
                    </div>
                </div>

                <!-- Special Cooking or Delivery Notes -->
                <div class="form-group" style="margin-top: 20px;">
                    <label class="form-label" for="specialNotes">Special Delivery / Kitchen Instructions (Optional)</label>
                    <input type="text" id="specialNotes" name="specialNotes" class="form-control" placeholder="e.g. Please ring doorbell twice, make food less spicy" value="${param.specialNotes}">
                </div>

                <div style="display: flex; justify-content: space-between; align-items: center; margin-top: 32px;">
                    <a href="${pageContext.request.contextPath}/cart" class="btn btn-outline btn-sm">
                        <i class="fa-solid fa-arrow-left"></i> Review Cart
                    </a>
                    <button type="submit" class="btn btn-primary" id="confirm-order-btn" style="padding: 12px 28px;">
                        <i class="fa-solid fa-bag-shopping"></i> Place Order (₹<fmt:formatNumber value="${sessionScope.cart.totalAmount}" pattern="#,##0.00"/>)
                    </button>
                </div>
            </form>
        </div>

        <!-- Order Summary Mini Card (Right Column) -->
        <div>
            <div class="summary-card">
                <h3 style="font-size: 1.15rem; margin-bottom: 16px; border-bottom: 1px solid var(--gray-200); padding-bottom: 10px;">
                    Items in Order (${sessionScope.cart.itemCount})
                </h3>

                <div style="max-height: 240px; overflow-y: auto; margin-bottom: 20px;">
                    <c:forEach var="item" items="${sessionScope.cart.items}">
                        <div style="display: flex; justify-content: space-between; align-items: center; padding: 8px 0; border-bottom: 1px dashed var(--gray-100); font-size: 0.9rem;">
                            <div>
                                <span style="font-weight: 600;">${item.foodItem.foodName}</span>
                                <span style="color: var(--gray-600); font-size: 0.8rem; display: block;">Qty: ${item.quantity} × ₹<fmt:formatNumber value="${item.foodItem.price}" pattern="#,##0.00"/></span>
                            </div>
                            <span style="font-weight: 700;">₹<fmt:formatNumber value="${item.subtotal}" pattern="#,##0.00"/></span>
                        </div>
                    </c:forEach>
                </div>

                <div style="display: flex; justify-content: space-between; margin-bottom: 8px; color: var(--gray-600); font-size: 0.9rem;">
                    <span>Subtotal</span>
                    <span>₹<fmt:formatNumber value="${sessionScope.cart.subtotal}" pattern="#,##0.00"/></span>
                </div>

                <div style="display: flex; justify-content: space-between; margin-bottom: 8px; color: var(--gray-600); font-size: 0.9rem;">
                    <span>GST (5%)</span>
                    <span>₹<fmt:formatNumber value="${sessionScope.cart.taxAmount}" pattern="#,##0.00"/></span>
                </div>

                <div style="display: flex; justify-content: space-between; margin-bottom: 16px; color: var(--gray-600); font-size: 0.9rem;">
                    <span>Delivery Fee</span>
                    <c:choose>
                        <c:when test="${sessionScope.cart.deliveryFee == 0}">
                            <span style="color: var(--secondary); font-weight: 700;">FREE</span>
                        </c:when>
                        <c:otherwise>
                            <span>₹<fmt:formatNumber value="${sessionScope.cart.deliveryFee}" pattern="#,##0.00"/></span>
                        </c:otherwise>
                    </c:choose>
                </div>

                <div style="display: flex; justify-content: space-between; border-top: 2px dashed var(--gray-200); padding-top: 14px; font-size: 1.2rem; font-family: var(--font-heading); font-weight: 800; color: var(--dark);">
                    <span>Total Amount</span>
                    <span style="color: var(--primary);">₹<fmt:formatNumber value="${sessionScope.cart.totalAmount}" pattern="#,##0.00"/></span>
                </div>
            </div>
        </div>
    </div>
</main>

<jsp:include page="/WEB-INF/views/common/footer.jsp" />
