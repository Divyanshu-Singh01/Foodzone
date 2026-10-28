<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<c:set var="pageTitle" value="Order History - FoodZone" />
<c:set var="activePage" value="orders" />

<jsp:include page="/WEB-INF/views/common/header.jsp" />
<jsp:include page="/WEB-INF/views/common/navbar.jsp" />

<main class="container" style="padding-top: 36px; padding-bottom: 60px;">
    <div style="margin-bottom: 28px;">
        <span style="color: var(--primary); font-weight: 700; font-size: 0.88rem; text-transform: uppercase;">Account Activity</span>
        <h1 style="font-size: 2.2rem; margin-top: 4px;">Your Past Orders</h1>
    </div>

    <c:choose>
        <c:when test="${not empty orders}">
            <div class="table-responsive">
                <table class="data-table">
                    <thead>
                        <tr>
                            <th>Order ID</th>
                            <th>Date & Time</th>
                            <th>Delivery Address</th>
                            <th>Payment</th>
                            <th>Total</th>
                            <th>Status</th>
                            <th style="text-align: right;">Action</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="ord" items="${orders}">
                            <tr>
                                <td style="font-weight: 800; font-family: var(--font-heading); color: var(--primary);">
                                    #FZ-${ord.orderId}
                                </td>
                                <td style="color: var(--gray-600); font-size: 0.88rem; white-space: nowrap;">
                                    <fmt:formatDate value="${ord.orderDate}" pattern="dd MMM yyyy, hh:mm a" />
                                </td>
                                <td style="max-width: 220px; font-size: 0.88rem; color: var(--gray-800); overflow: hidden; text-overflow: ellipsis; white-space: nowrap;">
                                    ${ord.deliveryAddress}
                                </td>
                                <td style="font-size: 0.88rem; color: var(--gray-600);">
                                    ${ord.paymentMethod}
                                </td>
                                <td style="font-weight: 700; font-size: 1.05rem; color: var(--dark); white-space: nowrap;">
                                    ₹<fmt:formatNumber value="${ord.totalAmount}" pattern="#,##0.00"/>
                                </td>
                                <td>
                                    <span class="badge badge-${ord.orderStatus.toLowerCase()}">
                                        ${ord.orderStatus}
                                    </span>
                                </td>
                                <td style="text-align: right; white-space: nowrap;">
                                    <a href="${pageContext.request.contextPath}/order-details?id=${ord.orderId}" class="btn btn-outline btn-sm">
                                        <i class="fa-regular fa-file-lines"></i> Details
                                    </a>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
        </c:when>
        <c:otherwise>
            <!-- No Orders State -->
            <div style="text-align: center; padding: 70px 20px; background: var(--white); border-radius: var(--radius-lg); border: 1px solid var(--gray-200); max-width: 580px; margin: 30px auto;">
                <div style="width: 80px; height: 80px; border-radius: 50%; background: var(--gray-100); color: var(--gray-600); display: flex; align-items: center; justify-content: center; font-size: 2.2rem; margin: 0 auto 20px;">
                    <i class="fa-solid fa-receipt"></i>
                </div>
                <h2 style="font-size: 1.6rem; margin-bottom: 8px;">No Orders Yet</h2>
                <p style="color: var(--gray-600); max-width: 400px; margin: 0 auto 24px; line-height: 1.5;">
                    You haven't placed any orders with us yet. Explore our handcrafted menu to treat yourself!
                </p>
                <a href="${pageContext.request.contextPath}/menu" class="btn btn-primary" id="explore-menu-btn">
                    <i class="fa-solid fa-utensils"></i> Explore Menu
                </a>
            </div>
        </c:otherwise>
    </c:choose>
</main>

<jsp:include page="/WEB-INF/views/common/footer.jsp" />
