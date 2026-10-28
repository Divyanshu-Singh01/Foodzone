<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<c:set var="pageTitle" value="Secure Checkout - FoodZone" />
<c:set var="activePage" value="cart" />

<jsp:include page="/WEB-INF/views/common/header.jsp" />
<jsp:include page="/WEB-INF/views/common/navbar.jsp" />

<main class="container" style="padding-top: 36px; padding-bottom: 60px;">
    <div style="margin-bottom: 28px;">
        <span style="color: var(--primary); font-weight: 700; font-size: 0.88rem; text-transform: uppercase;">Final Step</span>
        <h1 style="font-size: 2.2rem; margin-top: 4px;">Confirm Order & Fulfillment</h1>
    </div>

    <!-- Error Message Alert -->
    <c:if test="${not empty errorMessage}">
        <div class="alert alert-danger" style="margin-bottom: 24px;">
            <i class="fa-solid fa-triangle-exclamation"></i> ${errorMessage}
        </div>
    </c:if>

    <div class="cart-layout">
        <!-- Delivery Details Form (Left Column) -->
        <div class="cart-card">
            <h2 style="font-size: 1.3rem; margin-bottom: 20px; border-bottom: 1px solid var(--gray-200); padding-bottom: 12px;">
                <i class="fa-solid fa-bag-shopping" style="color: var(--primary); margin-right: 8px;"></i> Fulfillment & Details
            </h2>

            <form action="${pageContext.request.contextPath}/checkout" method="post" id="checkout-form">
                
                <!-- 1. Delivery vs Takeaway Mode Toggle -->
                <div class="form-group" style="margin-bottom: 24px;">
                    <label class="form-label" style="font-weight: 700; color: var(--dark);">Choose How You Want Your Food</label>
                    <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 14px; margin-top: 8px;">
                        <!-- Option 1: Delivery -->
                        <label id="mode-delivery-label" style="display: flex; align-items: center; gap: 12px; padding: 14px; border: 2px solid var(--primary); border-radius: var(--radius-md); background: var(--primary-light); cursor: pointer; transition: all 0.2s;">
                            <input type="radio" name="orderType" value="DELIVERY" ${sessionScope.cart.orderType != 'TAKEAWAY' ? 'checked' : ''} onchange="toggleFulfillment('DELIVERY')" style="accent-color: var(--primary);">
                            <div>
                                <strong style="display: block; color: var(--dark); font-size: 0.95rem;"><i class="fa-solid fa-motorcycle" style="color: var(--primary);"></i> Home Delivery</strong>
                                <span style="font-size: 0.8rem; color: var(--gray-600);">Doorstep drop with 4-digit OTP</span>
                            </div>
                        </label>

                        <!-- Option 2: Takeaway / Self-Pickup -->
                        <label id="mode-takeaway-label" style="display: flex; align-items: center; gap: 12px; padding: 14px; border: 2px solid var(--gray-200); border-radius: var(--radius-md); background: var(--white); cursor: pointer; transition: all 0.2s;">
                            <input type="radio" name="orderType" value="TAKEAWAY" ${sessionScope.cart.orderType == 'TAKEAWAY' ? 'checked' : ''} onchange="toggleFulfillment('TAKEAWAY')" style="accent-color: var(--primary);">
                            <div>
                                <strong style="display: block; color: var(--dark); font-size: 0.95rem;"><i class="fa-solid fa-bag-shopping" style="color: var(--secondary);"></i> Store Takeaway</strong>
                                <span style="font-size: 0.8rem; color: #047857; font-weight: 700;">FREE (Save ₹40 delivery fee)</span>
                            </div>
                        </label>
                    </div>
                </div>

                <!-- Customer Details -->
                <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 16px;">
                    <div class="form-group">
                        <label class="form-label">Ordering As</label>
                        <input type="text" class="form-control" value="${sessionScope.currentUser.fullName}" readonly style="background: var(--gray-50); color: var(--gray-600); cursor: not-allowed;">
                    </div>

                    <div class="form-group">
                        <label class="form-label" for="contactPhone">Primary Phone <span style="color: var(--danger);">*</span></label>
                        <input type="tel" id="contactPhone" name="contactPhone" class="form-control" required placeholder="10-digit mobile"
                               value="${not empty param.contactPhone ? param.contactPhone : sessionScope.currentUser.phone}">
                    </div>
                </div>

                <!-- Enterprise Delivery Details Container -->
                <div id="delivery-details-container">
                    <!-- Address Type Badges -->
                    <div class="form-group" style="margin-top: 14px;">
                        <label class="form-label" style="font-weight: 700; font-size: 0.88rem;">Address Tag / Label</label>
                        <div style="display: flex; gap: 10px; margin-top: 4px;">
                            <label class="address-type-chip" style="cursor: pointer; display: flex; align-items: center; gap: 6px; padding: 6px 14px; border: 1.5px solid var(--primary); border-radius: 20px; font-size: 0.82rem; font-weight: 600; background: var(--primary-light); color: var(--primary);">
                                <input type="radio" name="addressType" value="HOME" checked style="accent-color: var(--primary);">
                                <i class="fa-solid fa-house"></i> Home
                            </label>
                            <label class="address-type-chip" style="cursor: pointer; display: flex; align-items: center; gap: 6px; padding: 6px 14px; border: 1.5px solid var(--gray-200); border-radius: 20px; font-size: 0.82rem; font-weight: 600; background: var(--white); color: var(--gray-700);">
                                <input type="radio" name="addressType" value="WORK" style="accent-color: var(--primary);">
                                <i class="fa-solid fa-briefcase"></i> Work
                            </label>
                            <label class="address-type-chip" style="cursor: pointer; display: flex; align-items: center; gap: 6px; padding: 6px 14px; border: 1.5px solid var(--gray-200); border-radius: 20px; font-size: 0.82rem; font-weight: 600; background: var(--white); color: var(--gray-700);">
                                <input type="radio" name="addressType" value="OTHER" style="accent-color: var(--primary);">
                                <i class="fa-solid fa-location-dot"></i> Other
                            </label>
                        </div>
                    </div>

                    <!-- Delivery Address -->
                    <div class="form-group" id="delivery-address-group" style="margin-top: 14px;">
                        <label class="form-label" for="deliveryAddress">
                            Street & Building Address <span style="color: var(--danger);">*</span>
                        </label>
                        <textarea id="deliveryAddress" name="deliveryAddress" class="form-control" rows="2" placeholder="Flat / House No, Floor, Building Name, Society, Street" required>${not empty param.deliveryAddress ? param.deliveryAddress : sessionScope.currentUser.address}</textarea>
                    </div>

                    <!-- Landmark and Alternate Phone Grid -->
                    <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 16px; margin-top: 14px;">
                        <div class="form-group">
                            <label class="form-label" for="landmark"><i class="fa-solid fa-map-pin" style="color: var(--secondary);"></i> Nearby Landmark</label>
                            <input type="text" id="landmark" name="landmark" class="form-control" placeholder="e.g. Near City Mall, Opp. Gate 2" value="${param.landmark}">
                        </div>

                        <div class="form-group">
                            <label class="form-label" for="alternatePhone"><i class="fa-solid fa-phone" style="color: var(--gray-600);"></i> Alternate Phone (Optional)</label>
                            <input type="tel" id="alternatePhone" name="alternatePhone" class="form-control" placeholder="Backup phone number" value="${param.alternatePhone}">
                        </div>
                    </div>

                    <!-- Rider Delivery Instructions (Domino's Style) -->
                    <div class="form-group" style="margin-top: 14px;">
                        <label class="form-label" style="font-weight: 700; font-size: 0.88rem;">
                            <i class="fa-solid fa-motorcycle" style="color: var(--primary);"></i> Delivery Instructions for Rider
                        </label>
                        <div style="display: flex; flex-wrap: wrap; gap: 8px; margin-bottom: 8px;">
                            <button type="button" class="preset-chip" onclick="setInstruction('Do Not Ring Bell')" style="padding: 5px 12px; font-size: 0.8rem; border: 1px solid var(--gray-300); border-radius: 16px; background: var(--white); cursor: pointer; color: var(--gray-700);">
                                🔕 Do Not Ring Bell
                            </button>
                            <button type="button" class="preset-chip" onclick="setInstruction('Leave at Door')" style="padding: 5px 12px; font-size: 0.8rem; border: 1px solid var(--gray-300); border-radius: 16px; background: var(--white); cursor: pointer; color: var(--gray-700);">
                                🚪 Leave at Door
                            </button>
                            <button type="button" class="preset-chip" onclick="setInstruction('Call Upon Arrival')" style="padding: 5px 12px; font-size: 0.8rem; border: 1px solid var(--gray-300); border-radius: 16px; background: var(--white); cursor: pointer; color: var(--gray-700);">
                                📞 Call Upon Arrival
                            </button>
                            <button type="button" class="preset-chip" onclick="setInstruction('Leave with Security Guard')" style="padding: 5px 12px; font-size: 0.8rem; border: 1px solid var(--gray-300); border-radius: 16px; background: var(--white); cursor: pointer; color: var(--gray-700);">
                                🛡️ Leave with Security
                            </button>
                        </div>
                        <input type="text" id="deliveryInstructions" name="deliveryInstructions" class="form-control" placeholder="Select a preset above or type specific rider instructions..." value="${param.deliveryInstructions}">
                    </div>
                </div>

                <!-- Takeaway Pickup Info (shown only when Takeaway is selected) -->
                <div id="takeaway-info-box" style="display: none; background: #ECFDF5; border: 1px solid #A7F3D0; border-radius: var(--radius-md); padding: 16px; margin-top: 14px; margin-bottom: 16px;">
                    <h4 style="font-size: 0.95rem; color: #064E3B; margin-bottom: 4px;">
                        <i class="fa-solid fa-store" style="color: #059669;"></i> Pickup Address:
                    </h4>
                    <p style="font-size: 0.88rem; color: #047857; line-height: 1.4;">
                        FoodZone Central Express Kitchen, Plot 42, Food Court Boulevard, Indirapuram, Ghaziabad. (Ready in 20 minutes)
                    </p>
                </div>

                <!-- Payment Method Selection -->
                <div class="form-group" style="margin-top: 24px;">
                    <label class="form-label" style="font-weight: 700;">Select Payment Method</label>
                    <div style="display: flex; flex-direction: column; gap: 10px; margin-top: 8px;">
                        <label style="display: flex; align-items: center; gap: 12px; padding: 14px 18px; border: 1.5px solid var(--primary); border-radius: var(--radius-md); background: var(--primary-light); cursor: pointer;">
                            <input type="radio" name="paymentMethod" value="Cash on Delivery" checked style="accent-color: var(--primary);">
                            <div>
                                <strong style="color: var(--dark); display: block;">Cash on Delivery (COD) / Pay at Counter</strong>
                                <span style="font-size: 0.82rem; color: var(--gray-600);">Pay cash or UPI scan at delivery doorstep or store pickup</span>
                            </div>
                        </label>

                        <label style="display: flex; align-items: center; gap: 12px; padding: 14px 18px; border: 1.5px solid var(--gray-200); border-radius: var(--radius-md); background: var(--white); cursor: pointer;">
                            <input type="radio" name="paymentMethod" value="UPI Instant (Simulated)" style="accent-color: var(--primary);">
                            <div>
                                <strong style="color: var(--dark); display: block;"><i class="fa-brands fa-google-pay" style="color: #4285F4;"></i> UPI / QR Code (Simulation)</strong>
                                <span style="font-size: 0.82rem; color: var(--gray-600);">Simulated instant payment via Google Pay, PhonePe, or Paytm</span>
                            </div>
                        </label>

                        <label style="display: flex; align-items: center; gap: 12px; padding: 14px 18px; border: 1.5px solid var(--gray-200); border-radius: var(--radius-md); background: var(--white); cursor: pointer;">
                            <input type="radio" name="paymentMethod" value="Debit / Credit Card (Simulated)" style="accent-color: var(--primary);">
                            <div>
                                <strong style="color: var(--dark); display: block;"><i class="fa-regular fa-credit-card"></i> Credit / Debit Card (Simulation)</strong>
                                <span style="font-size: 0.82rem; color: var(--gray-600);">Visa, MasterCard, RuPay (Test mode)</span>
                            </div>
                        </label>
                    </div>
                </div>

                <!-- Special Cooking or Delivery Notes -->
                <div class="form-group" style="margin-top: 18px;">
                    <label class="form-label" for="specialNotes">Kitchen or Delivery Instructions (Optional)</label>
                    <input type="text" id="specialNotes" name="specialNotes" class="form-control" placeholder="e.g. Ring bell twice, make spicy, leave with security" value="${param.specialNotes}">
                </div>

                <div style="display: flex; justify-content: space-between; align-items: center; margin-top: 32px;">
                    <a href="${pageContext.request.contextPath}/cart" class="btn btn-outline btn-sm">
                        <i class="fa-solid fa-arrow-left"></i> Edit Cart
                    </a>
                    <button type="submit" class="btn btn-primary" id="confirm-order-btn" style="padding: 12px 28px; font-size: 1.05rem;">
                        <i class="fa-solid fa-circle-check"></i> Place Order Now
                    </button>
                </div>
            </form>
        </div>

        <!-- Order Summary Mini Card (Right Column) -->
        <div>
            <div class="summary-card">
                <h3 style="font-size: 1.15rem; margin-bottom: 16px; border-bottom: 1px solid var(--gray-200); padding-bottom: 10px;">
                    Review Items (${sessionScope.cart.itemCount})
                </h3>

                <div style="max-height: 240px; overflow-y: auto; margin-bottom: 20px;">
                    <c:forEach var="item" items="${sessionScope.cart.items}">
                        <div style="display: flex; justify-content: space-between; align-items: center; padding: 8px 0; border-bottom: 1px dashed var(--gray-100); font-size: 0.9rem;">
                            <div>
                                <strong style="color: var(--dark);">${item.foodItem.foodName}</strong>
                                <span style="font-size: 0.8rem; color: var(--gray-600); display: block;">Qty: ${item.quantity}</span>
                            </div>
                            <span style="font-weight: 700;">₹<fmt:formatNumber value="${item.subtotal}" pattern="#,##0.00"/></span>
                        </div>
                    </c:forEach>
                </div>

                <div style="display: flex; justify-content: space-between; margin-bottom: 8px; font-size: 0.9rem; color: var(--gray-600);">
                    <span>Subtotal</span>
                    <span>₹<fmt:formatNumber value="${sessionScope.cart.subtotal}" pattern="#,##0.00"/></span>
                </div>

                <div style="display: flex; justify-content: space-between; margin-bottom: 8px; font-size: 0.9rem; color: var(--gray-600);">
                    <span>GST (5%)</span>
                    <span>₹<fmt:formatNumber value="${sessionScope.cart.taxAmount}" pattern="#,##0.00"/></span>
                </div>

                <div style="display: flex; justify-content: space-between; margin-bottom: 8px; font-size: 0.9rem; color: var(--gray-600);">
                    <span>Delivery Charge</span>
                    <span id="summary-del-fee">
                        <c:choose>
                            <c:when test="${sessionScope.cart.deliveryFee == 0}">
                                <strong style="color: var(--secondary);">FREE</strong>
                            </c:when>
                            <c:otherwise>
                                ₹<fmt:formatNumber value="${sessionScope.cart.deliveryFee}" pattern="#,##0.00"/>
                            </c:otherwise>
                        </c:choose>
                    </span>
                </div>

                <c:if test="${sessionScope.cart.discountAmount > 0}">
                    <div style="display: flex; justify-content: space-between; margin-bottom: 8px; font-size: 0.9rem; color: #047857; font-weight: 600;">
                        <span>Coupon Discount (${sessionScope.cart.couponCode})</span>
                        <span>-₹<fmt:formatNumber value="${sessionScope.cart.discountAmount}" pattern="#,##0.00"/></span>
                    </div>
                </c:if>

                <div style="display: flex; justify-content: space-between; border-top: 2px dashed var(--gray-200); padding-top: 14px; font-size: 1.25rem; font-family: var(--font-heading); font-weight: 800; color: var(--dark);">
                    <span>Total Payable</span>
                    <span id="summary-total-amt" style="color: var(--primary);">₹<fmt:formatNumber value="${sessionScope.cart.totalAmount}" pattern="#,##0.00"/></span>
                </div>
            </div>
        </div>
    </div>
</main>

<script>
function setInstruction(text) {
    const input = document.getElementById('deliveryInstructions');
    if (input) {
        if (!input.value.trim()) {
            input.value = text;
        } else if (!input.value.includes(text)) {
            input.value = input.value + ', ' + text;
        }
    }
}

document.querySelectorAll('input[name="addressType"]').forEach(radio => {
    radio.addEventListener('change', () => {
        document.querySelectorAll('.address-type-chip').forEach(chip => {
            chip.style.borderColor = 'var(--gray-200)';
            chip.style.background = 'var(--white)';
            chip.style.color = 'var(--gray-700)';
        });
        const parent = radio.closest('.address-type-chip');
        if (parent) {
            parent.style.borderColor = 'var(--primary)';
            parent.style.background = 'var(--primary-light)';
            parent.style.color = 'var(--primary)';
        }
    });
});

function toggleFulfillment(mode) {
    const deliveryContainer = document.getElementById('delivery-details-container');
    const addressText = document.getElementById('deliveryAddress');
    const takeawayInfo = document.getElementById('takeaway-info-box');
    const delLabel = document.getElementById('mode-delivery-label');
    const takLabel = document.getElementById('mode-takeaway-label');

    if (mode === 'TAKEAWAY') {
        if (deliveryContainer) deliveryContainer.style.display = 'none';
        if (addressText) addressText.removeAttribute('required');
        if (takeawayInfo) takeawayInfo.style.display = 'block';

        takLabel.style.borderColor = 'var(--primary)';
        takLabel.style.background = 'var(--primary-light)';
        delLabel.style.borderColor = 'var(--gray-200)';
        delLabel.style.background = 'var(--white)';
    } else {
        if (deliveryContainer) deliveryContainer.style.display = 'block';
        if (addressText) addressText.setAttribute('required', 'required');
        if (takeawayInfo) takeawayInfo.style.display = 'none';

        delLabel.style.borderColor = 'var(--primary)';
        delLabel.style.background = 'var(--primary-light)';
        takLabel.style.borderColor = 'var(--gray-200)';
        takLabel.style.background = 'var(--white)';
    }
}

// Initialize on page load
document.addEventListener('DOMContentLoaded', () => {
    const takeawayRadio = document.querySelector('input[name="orderType"][value="TAKEAWAY"]');
    if (takeawayRadio && takeawayRadio.checked) {
        toggleFulfillment('TAKEAWAY');
    }
});
</script>

<jsp:include page="/WEB-INF/views/common/footer.jsp" />
