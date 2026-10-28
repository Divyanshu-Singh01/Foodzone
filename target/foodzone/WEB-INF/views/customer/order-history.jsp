<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<c:set var="pageTitle" value="My Orders — FoodZone" />
<c:set var="activePage" value="orders" />

<jsp:include page="/WEB-INF/views/common/header.jsp" />
<jsp:include page="/WEB-INF/views/common/navbar.jsp" />

<!-- Page Header -->
<div class="page-header">
    <div class="container" style="position:relative;z-index:1;">
        <div class="page-header-label">Account Activity</div>
        <h1>Your Orders</h1>
        <p class="page-header-sub">Track live deliveries and review your order history</p>
    </div>
</div>

<main style="background:var(--ink-50);padding:var(--sp-8) 0 var(--sp-16);">
<div class="container">

    <c:if test="${param.msg == 'order_cancelled'}">
        <div class="alert alert-success" style="margin-bottom:var(--sp-6);">
            <i class="fa-solid fa-circle-check alert-icon"></i>
            <span>Order cancelled successfully. Any pending charges have been voided.</span>
        </div>
    </c:if>

    <c:choose>
        <c:when test="${not empty orders}">
            <div class="table-responsive">
                <table class="data-table">
                    <thead>
                        <tr>
                            <th>Order</th>
                            <th>Date & Time</th>
                            <th>Delivery Address</th>
                            <th>OTP</th>
                            <th>Amount</th>
                            <th>Status</th>
                            <th style="text-align:right;">Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="ord" items="${orders}">
                            <tr>
                                <td>
                                    <span style="font-family:var(--font-display);font-weight:800;color:var(--brand);font-size:.95rem;">#FZ-${ord.orderId}</span>
                                    <div style="font-size:.75rem;color:var(--ink-400);font-weight:600;margin-top:2px;text-transform:uppercase;letter-spacing:.04em;">${ord.orderType}</div>
                                </td>
                                <td style="white-space:nowrap;font-size:.85rem;color:var(--ink-400);">
                                    <fmt:formatDate value="${ord.orderDate}" pattern="dd MMM yyyy" /><br>
                                    <fmt:formatDate value="${ord.orderDate}" pattern="hh:mm a" />
                                </td>
                                <td style="max-width:200px;">
                                    <div style="font-size:.85rem;color:var(--ink-700);overflow:hidden;text-overflow:ellipsis;white-space:nowrap;">
                                        ${ord.deliveryAddress}
                                    </div>
                                </td>
                                <td>
                                    <c:choose>
                                        <c:when test="${ord.orderStatus == 'COMPLETED'}">
                                            <span style="color:var(--emerald);font-size:.83rem;font-weight:700;display:flex;align-items:center;gap:4px;">
                                                <i class="fa-solid fa-check-circle"></i> Verified
                                            </span>
                                        </c:when>
                                        <c:when test="${ord.orderStatus == 'CANCELLED'}">
                                            <span style="color:var(--ink-300);font-size:.85rem;">—</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span style="background:var(--amber-light);color:#78350F;border:1px solid rgba(245,158,11,.3);padding:4px 12px;border-radius:var(--r-sm);font-weight:800;font-size:.9rem;letter-spacing:.08em;white-space:nowrap;">
                                                🔑 ${ord.deliveryOtp}
                                            </span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td style="white-space:nowrap;">
                                    <span style="font-family:var(--font-display);font-weight:800;font-size:1rem;color:var(--ink-900);">₹<fmt:formatNumber value="${ord.totalAmount}" pattern="#,##0"/></span>
                                </td>
                                <td>
                                    <span class="badge badge-${ord.orderStatus.toLowerCase()}">${ord.orderStatus}</span>
                                </td>
                                <td style="text-align:right;white-space:nowrap;">
                                    <div style="display:inline-flex;gap:var(--sp-2);">
                                        <a href="${pageContext.request.contextPath}/order-details?id=${ord.orderId}"
                                           class="btn btn-outline btn-xs">
                                            <i class="fa-solid fa-satellite-dish"></i> Track
                                        </a>
                                        <c:if test="${ord.orderStatus == 'PENDING'}">
                                            <form action="${pageContext.request.contextPath}/orders" method="POST"
                                                  style="display:inline;" onsubmit="return confirm('Cancel this order?');">
                                                <input type="hidden" name="action" value="cancel">
                                                <input type="hidden" name="orderId" value="${ord.orderId}">
                                                <button type="submit" class="btn btn-xs"
                                                        style="background:var(--red-light);color:var(--red);border:1px solid rgba(239,68,68,.25);">
                                                    <i class="fa-solid fa-xmark"></i> Cancel
                                                </button>
                                            </form>
                                        </c:if>
                                    </div>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
        </c:when>
        <c:otherwise>
            <div class="empty-state" style="max-width:540px;margin:0 auto;">
                <div class="empty-state-icon">
                    <i class="fa-solid fa-receipt"></i>
                </div>
                <h3>No Orders Placed Yet</h3>
                <p>You haven't ordered anything yet. Explore our fresh artisan pizzas, gourmet burgers, and authentic biryanis!</p>
                <a href="${pageContext.request.contextPath}/menu" class="btn btn-primary">
                    <i class="fa-solid fa-utensils"></i> Browse Menu
                </a>
            </div>
        </c:otherwise>
    </c:choose>

</div>
</main>

<jsp:include page="/WEB-INF/views/common/footer.jsp" />
