<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<c:set var="pageTitle" value="Order Confirmation #FZ-${order.orderId} - FoodZone" />
<c:set var="activePage" value="orders" />

<jsp:include page="/WEB-INF/views/common/header.jsp" />
<jsp:include page="/WEB-INF/views/common/navbar.jsp" />

<main class="container" style="padding-top: 40px; padding-bottom: 70px;">
    <!-- Success Banner -->
    <div style="background: var(--white); border-radius: var(--radius-lg); border: 1px solid var(--gray-200); padding: 36px; text-align: center; max-width: 760px; margin: 0 auto 32px; box-shadow: var(--shadow-sm);">
        <div style="width: 76px; height: 76px; border-radius: 50%; background: #D1FAE5; color: #047857; display: flex; align-items: center; justify-content: center; font-size: 2.2rem; margin: 0 auto 16px;">
            <i class="fa-solid fa-circle-check"></i>
        </div>
        <span style="color: var(--secondary); font-weight: 700; font-size: 0.9rem; text-transform: uppercase; letter-spacing: 0.05em;">Payment & Order Verified</span>
        <h1 style="font-size: 2.2rem; margin-top: 6px; margin-bottom: 10px;">Thank You! Your Order is Confirmed</h1>
        <p style="color: var(--gray-600); max-width: 500px; margin: 0 auto; line-height: 1.6;">
            We've sent your order directly to the kitchen. Our chefs are preparing your meal fresh, and our delivery partner will be en route shortly.
        </p>

        <!-- Status Tracking Pill -->
        <div style="margin-top: 24px; display: inline-flex; align-items: center; gap: 12px; background: var(--gray-100); padding: 8px 20px; border-radius: var(--radius-full);">
            <span style="font-size: 0.9rem; font-weight: 600; color: var(--gray-600);">Current Live Status:</span>
            <span class="badge badge-${order.orderStatus.toLowerCase()}">
                <i class="fa-solid fa-clock-rotate-left" style="margin-right: 6px;"></i> ${order.orderStatus}
            </span>
        </div>
    </div>

    <!-- Printable Receipt / Order Card -->
    <div id="printable-receipt" style="background: var(--white); border-radius: var(--radius-lg); border: 1px solid var(--gray-200); max-width: 760px; margin: 0 auto; padding: 36px; box-shadow: var(--shadow-sm);">
        <div style="display: flex; justify-content: space-between; align-items: flex-start; border-bottom: 2px solid var(--gray-100); padding-bottom: 20px; margin-bottom: 24px;">
            <div>
                <div class="logo" style="margin-bottom: 4px;">
                    <div class="logo-icon" style="width: 32px; height: 32px; font-size: 1rem;">
                        <i class="fa-solid fa-fire-burner"></i>
                    </div>
                    Food<span>Zone</span>
                </div>
                <p style="font-size: 0.85rem; color: var(--gray-600);">Official Customer Order Tax Receipt</p>
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
                <span style="font-size: 0.78rem; text-transform: uppercase; font-weight: 700; color: var(--gray-600);">Delivery To:</span>
                <p style="font-weight: 600; color: var(--dark); margin-top: 4px;">${order.customerName}</p>
                <p style="font-size: 0.88rem; color: var(--gray-600); line-height: 1.4; margin-top: 2px;">${order.deliveryAddress}</p>
                <p style="font-size: 0.88rem; color: var(--gray-600); margin-top: 4px;">
                    <i class="fa-solid fa-phone" style="font-size: 0.8rem; margin-right: 4px;"></i> ${order.contactPhone}
                </p>
            </div>
            <div>
                <span style="font-size: 0.78rem; text-transform: uppercase; font-weight: 700; color: var(--gray-600);">Payment Info:</span>
                <p style="font-weight: 600; color: var(--dark); margin-top: 4px;">${order.paymentMethod}</p>
                <p style="font-size: 0.88rem; color: var(--gray-600); margin-top: 2px;">Status: Verified / Cash on Delivery</p>
                <c:if test="${not empty order.specialNotes}">
                    <span style="font-size: 0.78rem; text-transform: uppercase; font-weight: 700; color: var(--gray-600); display: block; margin-top: 8px;">Notes:</span>
                    <p style="font-size: 0.85rem; color: var(--gray-600); font-style: italic;">"${order.specialNotes}"</p>
                </c:if>
            </div>
        </div>

        <!-- Ordered Items Table -->
        <h3 style="font-size: 1.1rem; margin-bottom: 14px;">Itemized Breakdown</h3>
        <table class="data-table" style="margin-bottom: 24px;">
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
            <div style="display: flex; justify-content: space-between; margin-bottom: 12px; font-size: 0.9rem; color: var(--gray-600);">
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

<jsp:include page="/WEB-INF/views/common/footer.jsp" />
