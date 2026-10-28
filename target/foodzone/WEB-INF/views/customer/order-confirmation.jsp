<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<c:set var="pageTitle" value="Order Tracking #FZ-${order.orderId} - FoodZone" />
<c:set var="activePage" value="orders" />

<jsp:include page="/WEB-INF/views/common/header.jsp" />
<jsp:include page="/WEB-INF/views/common/navbar.jsp" />

<style>
/* Domino's Style 4-Stage Visual Tracker */
.pizza-tracker {
    display: flex;
    justify-content: space-between;
    position: relative;
    margin: 32px 0 24px;
}
.pizza-tracker::before {
    content: '';
    position: absolute;
    top: 24px;
    left: 40px;
    right: 40px;
    height: 6px;
    background: #E5E7EB;
    z-index: 1;
}
.tracker-progress-line {
    position: absolute;
    top: 24px;
    left: 40px;
    height: 6px;
    background: linear-gradient(90deg, #FF6B35, #10B981);
    z-index: 2;
    transition: width 0.6s cubic-bezier(0.4, 0, 0.2, 1);
}
.tracker-step {
    position: relative;
    z-index: 3;
    text-align: center;
    flex: 1;
}
.step-circle {
    width: 50px;
    height: 50px;
    border-radius: 50%;
    background: #FFFFFF;
    border: 4px solid #E5E7EB;
    color: #9CA3AF;
    display: flex;
    align-items: center;
    justify-content: center;
    font-size: 1.25rem;
    margin: 0 auto 10px;
    transition: all 0.3s ease;
}
.tracker-step.active .step-circle {
    border-color: #FF6B35;
    background: #FF6B35;
    color: #FFFFFF;
    box-shadow: 0 0 0 6px rgba(255, 107, 53, 0.2);
    animation: pulse 2s infinite;
}
.tracker-step.completed .step-circle {
    border-color: #10B981;
    background: #10B981;
    color: #FFFFFF;
}
.step-label {
    font-size: 0.85rem;
    font-weight: 700;
    color: #6B7280;
}
.tracker-step.active .step-label {
    color: #FF6B35;
}
.tracker-step.completed .step-label {
    color: #10B981;
}
@keyframes pulse {
    0% { box-shadow: 0 0 0 0 rgba(255, 107, 53, 0.4); }
    70% { box-shadow: 0 0 0 10px rgba(255, 107, 53, 0); }
    100% { box-shadow: 0 0 0 0 rgba(255, 107, 53, 0); }
}
</style>

<main class="container" style="padding-top: 36px; padding-bottom: 70px;">
    <!-- Live Domino's Style Visual Tracker Card -->
    <div style="background: var(--white); border-radius: var(--radius-lg); border: 1px solid var(--gray-200); padding: 32px; max-width: 800px; margin: 0 auto 30px; box-shadow: var(--shadow-md);">
        
        <div style="display: flex; justify-content: space-between; align-items: center; flex-wrap: wrap; gap: 12px; border-bottom: 1px solid var(--gray-200); padding-bottom: 16px;">
            <div>
                <span style="font-size: 0.78rem; text-transform: uppercase; font-weight: 800; color: var(--primary); letter-spacing: 0.05em;">
                    <i class="fa-solid fa-satellite-dish" style="color: var(--secondary);"></i> Live Order Tracking
                </span>
                <h1 style="font-size: 1.6rem; margin-top: 2px;">Order #FZ-${order.orderId}</h1>
            </div>
            <div style="display: flex; align-items: center; gap: 10px;">
                <span id="tracker-status-badge" class="badge badge-${order.orderStatus.toLowerCase()}" style="font-size: 0.9rem; padding: 6px 16px;">
                    <i class="fa-solid fa-clock-rotate-left"></i> ${order.orderStatus}
                </span>
                <span style="font-size: 0.75rem; color: var(--gray-600); background: var(--gray-100); padding: 4px 8px; border-radius: 4px;">
                    <i class="fa-solid fa-arrows-rotate fa-spin" style="color: var(--primary);"></i> Live Auto-Sync
                </span>
            </div>
        </div>

        <!-- 4-Stage Stepper -->
        <div class="pizza-tracker">
            <div id="progress-line" class="tracker-progress-line" style="width: 
                <c:choose>
                    <c:when test="${order.orderStatus == 'PENDING'}">12%</c:when>
                    <c:when test="${order.orderStatus == 'PREPARING'}">45%</c:when>
                    <c:when test="${order.orderStatus == 'OUT_FOR_DELIVERY'}">78%</c:when>
                    <c:when test="${order.orderStatus == 'COMPLETED'}">100%</c:when>
                    <c:otherwise>0%</c:otherwise>
                </c:choose>;">
            </div>

            <!-- Step 1: Order Placed -->
            <div id="step-pending" class="tracker-step ${order.orderStatus == 'PENDING' ? 'active' : (order.orderStatus != 'CANCELLED' ? 'completed' : '')}">
                <div class="step-circle"><i class="fa-solid fa-clipboard-check"></i></div>
                <div class="step-label">Order Placed</div>
            </div>

            <!-- Step 2: In Kitchen -->
            <div id="step-preparing" class="tracker-step ${order.orderStatus == 'PREPARING' ? 'active' : (order.orderStatus == 'OUT_FOR_DELIVERY' || order.orderStatus == 'COMPLETED' ? 'completed' : '')}">
                <div class="step-circle"><i class="fa-solid fa-fire-burner"></i></div>
                <div class="step-label">Baking in Oven</div>
            </div>

            <!-- Step 3: Out For Delivery -->
            <div id="step-delivery" class="tracker-step ${order.orderStatus == 'OUT_FOR_DELIVERY' ? 'active' : (order.orderStatus == 'COMPLETED' ? 'completed' : '')}">
                <div class="step-circle"><i class="fa-solid fa-motorcycle"></i></div>
                <div class="step-label">Out for Delivery</div>
            </div>

            <!-- Step 4: Delivered -->
            <div id="step-completed" class="tracker-step ${order.orderStatus == 'COMPLETED' ? 'completed' : ''}">
                <div class="step-circle"><i class="fa-solid fa-house-circle-check"></i></div>
                <div class="step-label">Delivered</div>
            </div>
        </div>

        <!-- 4-Digit Secure Delivery OTP Card -->
        <c:if test="${not empty order.deliveryOtp}">
            <div style="background: linear-gradient(135deg, #FFFBEB, #FEF3C7); border: 2px dashed #F59E0B; border-radius: var(--radius-md); padding: 18px 24px; margin-top: 24px; display: flex; justify-content: space-between; align-items: center; flex-wrap: wrap; gap: 16px;">
                <div style="display: flex; gap: 14px; align-items: center;">
                    <div style="width: 46px; height: 46px; border-radius: 50%; background: #F59E0B; color: #FFFFFF; display: flex; align-items: center; justify-content: center; font-size: 1.4rem;">
                        <i class="fa-solid fa-key"></i>
                    </div>
                    <div>
                        <h4 style="font-size: 1.05rem; color: #92400E; margin-bottom: 2px;">Your Secret Delivery OTP</h4>
                        <p style="font-size: 0.85rem; color: #B45309;">Share this code with your delivery partner at the doorstep to verify and receive your food.</p>
                    </div>
                </div>
                <div style="background: #FFFFFF; border: 2px solid #F59E0B; border-radius: var(--radius-md); padding: 8px 22px; font-size: 1.8rem; font-weight: 900; letter-spacing: 0.25em; color: #B45309; box-shadow: var(--shadow-sm);">
                    ${order.deliveryOtp}
                </div>
            </div>
        </c:if>

        <!-- 30-Minute Domino's Delivery Guarantee Countdown Banner -->
        <c:if test="${order.orderStatus != 'COMPLETED' && order.orderStatus != 'CANCELLED' && order.orderType == 'DELIVERY'}">
            <div style="background: #FFF7ED; border: 1px solid #FFEDD5; border-radius: var(--radius-md); padding: 14px 20px; margin-top: 20px; display: flex; justify-content: space-between; align-items: center; flex-wrap: wrap; gap: 12px;">
                <div style="display: flex; align-items: center; gap: 10px;">
                    <i class="fa-solid fa-stopwatch" style="font-size: 1.6rem; color: var(--primary);"></i>
                    <div>
                        <strong style="color: var(--dark); font-size: 0.95rem; display: block;">30-Minute Express Delivery Guarantee</strong>
                        <span style="font-size: 0.8rem; color: var(--gray-600);">Hot & fresh from oven to door, guaranteed.</span>
                    </div>
                </div>
                <div style="background: #111827; color: #10B981; font-family: monospace; font-size: 1.3rem; font-weight: 800; padding: 6px 16px; border-radius: 6px; letter-spacing: 0.1em;" id="guarantee-timer">
                    28:45
                </div>
            </div>
        </c:if>

        <!-- Delivery Partner Assigned Details (if assigned) -->
        <div id="rider-card" style="display: ${not empty order.riderName ? 'block' : 'none'}; margin-top: 20px; background: #ECFDF5; border: 1px solid #A7F3D0; border-radius: var(--radius-md); padding: 18px 22px;">
            <div style="display: flex; justify-content: space-between; align-items: center; flex-wrap: wrap; gap: 12px;">
                <div style="display: flex; gap: 14px; align-items: center;">
                    <div style="width: 44px; height: 44px; border-radius: 50%; background: #10B981; color: var(--white); display: flex; align-items: center; justify-content: center; font-size: 1.3rem;">
                        <i class="fa-solid fa-motorcycle"></i>
                    </div>
                    <div>
                        <div style="display: flex; align-items: center; gap: 8px;">
                            <span style="font-size: 0.72rem; text-transform: uppercase; font-weight: 800; color: #047857;">Assigned Delivery Executive</span>
                            <c:if test="${not empty order.tripStage}">
                                <span class="badge" style="background: #D1FAE5; color: #065F46; font-size: 0.7rem; font-weight: 700;">
                                    ${order.tripStage == 'ARRIVED' ? 'Arrived at Door' : (order.tripStage == 'PICKED_UP' ? 'En Route' : 'Assigned')}
                                </span>
                            </c:if>
                        </div>
                        <h4 id="rider-name-val" style="font-size: 1.1rem; color: #064E3B; margin-top: 2px;">${order.riderName}</h4>
                        <p id="rider-vehicle-val" style="font-size: 0.85rem; color: #047857; margin-top: 1px;">
                            Vehicle: ${order.riderVehicle != null ? order.riderVehicle : 'DL 04 AB 1234'}
                        </p>
                    </div>
                </div>
                <a id="rider-phone-link" href="tel:${order.riderPhone}" class="btn" style="background: #10B981; color: var(--white); border-radius: var(--radius-full); padding: 8px 18px; font-size: 0.88rem;">
                    <i class="fa-solid fa-phone"></i> Call Partner
                </a>
            </div>
        </div>

        <!-- Post-Delivery Review & Rating Card (Domino's Star Rating) -->
        <c:if test="${order.orderStatus == 'COMPLETED'}">
            <div style="margin-top: 24px; background: #FAF5FF; border: 1.5px solid #E9D5FF; border-radius: var(--radius-md); padding: 22px;">
                <c:choose>
                    <c:when test="${not empty existingReview}">
                        <div style="display: flex; justify-content: space-between; align-items: center;">
                            <div>
                                <h4 style="font-size: 1.05rem; color: #6B21A8; margin-bottom: 4px;">
                                    <i class="fa-solid fa-star" style="color: #F59E0B;"></i> You Rated This Order
                                </h4>
                                <p style="font-size: 0.88rem; color: #7E22CE; margin: 0;">
                                    Food: <strong>${existingReview.rating} / 5 Stars</strong> &bull; Delivery: <strong>${existingReview.deliveryRating} / 5 Stars</strong>
                                </p>
                                <c:if test="${not empty existingReview.reviewText}">
                                    <p style="font-size: 0.85rem; color: var(--gray-700); margin-top: 6px; font-style: italic;">
                                        "${existingReview.reviewText}"
                                    </p>
                                </c:if>
                            </div>
                            <span class="badge" style="background: #EDE9FE; color: #6B21A8; font-weight: 700;">Verified Feedback</span>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <h4 style="font-size: 1.1rem; color: #6B21A8; margin-bottom: 6px;">
                            <i class="fa-solid fa-award" style="color: var(--primary);"></i> How Was Your Experience?
                        </h4>
                        <p style="font-size: 0.85rem; color: #7E22CE; margin-bottom: 14px;">
                            Help us maintain 5-star Domino's quality standards by rating your food and delivery.
                        </p>
                        <form action="${pageContext.request.contextPath}/orders" method="POST">
                            <input type="hidden" name="action" value="review">
                            <input type="hidden" name="orderId" value="${order.orderId}">

                            <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 16px; margin-bottom: 12px;">
                                <div>
                                    <label style="font-size: 0.82rem; font-weight: 700; color: #6B21A8; display: block; margin-bottom: 4px;">Food Quality Rating</label>
                                    <select name="rating" class="form-control" style="font-size: 0.9rem;">
                                        <option value="5">⭐⭐⭐⭐⭐ Excellent (5/5)</option>
                                        <option value="4">⭐⭐⭐⭐ Good (4/5)</option>
                                        <option value="3">⭐⭐⭐ Average (3/5)</option>
                                        <option value="2">⭐⭐ Needs Improvement (2/5)</option>
                                        <option value="1">⭐ Poor (1/5)</option>
                                    </select>
                                </div>
                                <div>
                                    <label style="font-size: 0.82rem; font-weight: 700; color: #6B21A8; display: block; margin-bottom: 4px;">Delivery Partner Rating</label>
                                    <select name="deliveryRating" class="form-control" style="font-size: 0.9rem;">
                                        <option value="5">⭐⭐⭐⭐⭐ Super Fast & Polite (5/5)</option>
                                        <option value="4">⭐⭐⭐⭐ On Time (4/5)</option>
                                        <option value="3">⭐⭐⭐ Okay (3/5)</option>
                                        <option value="2">⭐⭐ Delayed (2/5)</option>
                                        <option value="1">⭐ Poor Experience (1/5)</option>
                                    </select>
                                </div>
                            </div>

                            <div style="margin-bottom: 12px;">
                                <input type="text" name="reviewText" placeholder="Write quick feedback (e.g. Pizza was piping hot, rider was polite)..." class="form-control" style="font-size: 0.88rem;">
                            </div>

                            <button type="submit" class="btn btn-sm" style="background: #7E22CE; color: #fff; font-weight: 700; padding: 8px 18px; border-radius: var(--radius-sm); border: none;">
                                <i class="fa-solid fa-paper-plane"></i> Submit Feedback
                            </button>
                        </form>
                    </c:otherwise>
                </c:choose>
            </div>
        </c:if>
    </div>

    <!-- Printable Official Tax Receipt -->
    <div id="printable-receipt" style="background: var(--white); border-radius: var(--radius-lg); border: 1px solid var(--gray-200); max-width: 800px; margin: 0 auto; padding: 36px; box-shadow: var(--shadow-sm);">
        <div style="display: flex; justify-content: space-between; align-items: flex-start; border-bottom: 2px solid var(--gray-100); padding-bottom: 20px; margin-bottom: 24px;">
            <div>
                <div class="logo" style="margin-bottom: 4px;">
                    <div class="logo-icon" style="width: 32px; height: 32px; font-size: 1rem;">
                        <i class="fa-solid fa-fire-burner"></i>
                    </div>
                    Food<span>Zone</span>
                </div>
                <p style="font-size: 0.85rem; color: var(--gray-600);">Tax Invoice & Delivery Manifest (${order.orderType})</p>
            </div>
            <div style="text-align: right;">
                <div style="font-family: var(--font-heading); font-size: 1.25rem; font-weight: 800; color: var(--primary);">
                    #FZ-${order.orderId}
                </div>
                <div style="font-size: 0.85rem; color: var(--gray-600); margin-top: 4px;">
                    <fmt:formatDate value="${order.orderDate}" pattern="dd MMM yyyy, hh:mm a" />
                </div>
            </div>
        </div>

        <!-- Details Grid -->
        <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(220px, 1fr)); gap: 20px; background: var(--gray-50); padding: 20px; border-radius: var(--radius-md); margin-bottom: 28px;">
            <div>
                <span style="font-size: 0.78rem; text-transform: uppercase; font-weight: 700; color: var(--gray-600);">Fulfillment:</span>
                <p style="font-weight: 700; color: var(--dark); margin-top: 4px;">
                    <i class="${order.orderType == 'TAKEAWAY' ? 'fa-solid fa-bag-shopping' : 'fa-solid fa-truck-ramp-box'}" style="color: var(--primary);"></i>
                    ${order.orderType}
                </p>
                <p style="font-size: 0.88rem; color: var(--gray-600); line-height: 1.4; margin-top: 2px;">${order.deliveryAddress}</p>
                <p style="font-size: 0.88rem; color: var(--gray-600); margin-top: 4px;">
                    <i class="fa-solid fa-phone" style="font-size: 0.8rem; margin-right: 4px;"></i> ${order.contactPhone}
                </p>
            </div>
            <div>
                <span style="font-size: 0.78rem; text-transform: uppercase; font-weight: 700; color: var(--gray-600);">Payment Details:</span>
                <p style="font-weight: 600; color: var(--dark); margin-top: 4px;">${order.paymentMethod}</p>
                <c:if test="${not empty order.couponCode}">
                    <p style="font-size: 0.85rem; color: var(--secondary); margin-top: 2px; font-weight: 600;">
                        <i class="fa-solid fa-tag"></i> Coupon Applied: ${order.couponCode}
                    </p>
                </c:if>
            </div>
        </div>

        <!-- Ordered Items Table -->
        <h3 style="font-size: 1.1rem; margin-bottom: 14px;">Itemized Breakdown</h3>
        <table class="data-table" style="margin-bottom: 24px; width: 100%;">
            <thead>
                <tr>
                    <th>Dish / Item</th>
                    <th style="text-align: center;">Price</th>
                    <th style="text-align: center;">Qty</th>
                    <th style="text-align: right;">Amount</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="item" items="${order.items}">
                    <tr>
                        <td style="font-weight: 600;">${item.foodName}</td>
                        <td style="text-align: center; color: var(--gray-600);">₹<fmt:formatNumber value="${item.unitPrice}" pattern="#,##0.00"/></td>
                        <td style="text-align: center; font-weight: 700;">${item.quantity}</td>
                        <td style="text-align: right; font-weight: 700;">₹<fmt:formatNumber value="${item.subtotal}" pattern="#,##0.00"/></td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>

        <!-- Total Calculation -->
        <div style="max-width: 320px; margin-left: auto; border-top: 1px solid var(--gray-200); padding-top: 14px;">
            <div style="display: flex; justify-content: space-between; margin-bottom: 8px; font-size: 0.9rem; color: var(--gray-600);">
                <span>Subtotal</span>
                <span>₹<fmt:formatNumber value="${order.subtotal}" pattern="#,##0.00"/></span>
            </div>
            <div style="display: flex; justify-content: space-between; margin-bottom: 8px; font-size: 0.9rem; color: var(--gray-600);">
                <span>GST (5%)</span>
                <span>₹<fmt:formatNumber value="${order.taxAmount}" pattern="#,##0.00"/></span>
            </div>
            <div style="display: flex; justify-content: space-between; margin-bottom: 8px; font-size: 0.9rem; color: var(--gray-600);">
                <span>Delivery Fee</span>
                <c:choose>
                    <c:when test="${order.deliveryFee == 0}">
                        <span style="color: var(--secondary); font-weight: 700;">FREE</span>
                    </c:when>
                    <c:otherwise>
                        <span>₹<fmt:formatNumber value="${order.deliveryFee}" pattern="#,##0.00"/></span>
                    </c:otherwise>
                </c:choose>
            </div>
            <c:if test="${order.discountAmount > 0}">
                <div style="display: flex; justify-content: space-between; margin-bottom: 8px; font-size: 0.9rem; color: #047857; font-weight: 600;">
                    <span>Coupon Discount (${order.couponCode})</span>
                    <span>-₹<fmt:formatNumber value="${order.discountAmount}" pattern="#,##0.00"/></span>
                </div>
            </c:if>
            <div style="display: flex; justify-content: space-between; border-top: 2px dashed var(--gray-200); padding-top: 12px; font-size: 1.25rem; font-family: var(--font-heading); font-weight: 800; color: var(--dark);">
                <span>Grand Total</span>
                <span style="color: var(--primary);">₹<fmt:formatNumber value="${order.totalAmount}" pattern="#,##0.00"/></span>
            </div>
        </div>

        <!-- Receipt Action Buttons -->
        <div style="display: flex; justify-content: space-between; align-items: center; margin-top: 36px; padding-top: 20px; border-top: 1px solid var(--gray-200); flex-wrap: wrap; gap: 12px;">
            <button onclick="window.print();" class="btn btn-secondary btn-sm" id="print-receipt-btn">
                <i class="fa-solid fa-print"></i> Print Receipt
            </button>
            <div style="display: flex; gap: 12px;">
                <a href="${pageContext.request.contextPath}/orders" class="btn btn-outline btn-sm">
                    <i class="fa-solid fa-clock-rotate-left"></i> My Orders
                </a>
                <a href="${pageContext.request.contextPath}/menu" class="btn btn-primary btn-sm">
                    <i class="fa-solid fa-utensils"></i> Order More
                </a>
            </div>
        </div>
    </div>
</main>

<script>
// Real-time Pizza Tracker polling every 4 seconds
const currentOrderId = ${order.orderId};
let currentStatus = '${order.orderStatus}';

function pollOrderStatus() {
    if (currentStatus === 'COMPLETED' || currentStatus === 'CANCELLED') return;

    fetch('${pageContext.request.contextPath}/order-status-api?id=' + currentOrderId)
        .then(res => res.json())
        .then(data => {
            if (data && data.status && data.status !== currentStatus) {
                currentStatus = data.status;
                // Reload to refresh the stepper, rider card and states
                window.location.reload();
            }
        })
        .catch(err => console.log('Tracker polling...', err));
}

setInterval(pollOrderStatus, 4000);

// 30-min guarantee countdown timer
let remainingSeconds = 28 * 60 + 45;
const timerEl = document.getElementById('guarantee-timer');
if (timerEl) {
    const timerInterval = setInterval(() => {
        if (remainingSeconds <= 0) {
            clearInterval(timerInterval);
            timerEl.innerText = "00:00 (On the House!)";
            return;
        }
        remainingSeconds--;
        const m = Math.floor(remainingSeconds / 60);
        const s = remainingSeconds % 60;
        timerEl.innerText = (m < 10 ? '0' : '') + m + ':' + (s < 10 ? '0' : '') + s;
    }, 1000);
}
</script>

<jsp:include page="/WEB-INF/views/common/footer.jsp" />
