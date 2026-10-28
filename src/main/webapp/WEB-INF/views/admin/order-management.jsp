<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<c:set var="pageTitle" value="Live Order Management - FoodZone Admin" />
<c:set var="activeAdminTab" value="orders" />

<jsp:include page="/WEB-INF/views/common/header.jsp" />
<jsp:include page="/WEB-INF/views/common/navbar.jsp" />

<main class="container">
    <div class="admin-grid">
        <!-- Admin Sidebar Navigation -->
        <aside class="admin-sidebar">
            <div class="admin-sidebar-header">
                <div class="admin-sidebar-eyebrow">Management Console</div>
                <div class="admin-sidebar-title">Admin Portal</div>
            </div>
            <ul class="admin-nav">
                <li>
                    <a href="${pageContext.request.contextPath}/admin/dashboard">
                        <i class="fa-solid fa-chart-pie"></i> Dashboard
                    </a>
                </li>
                <li>
                    <a href="${pageContext.request.contextPath}/admin/orders" class="active">
                        <i class="fa-solid fa-clipboard-list"></i> Live Orders
                    </a>
                </li>
                <li>
                    <a href="${pageContext.request.contextPath}/admin/menu">
                        <i class="fa-solid fa-burger"></i> Menu Catalog
                    </a>
                </li>
                <li>
                    <a href="${pageContext.request.contextPath}/admin/users">
                        <i class="fa-solid fa-users"></i> Customers
                    </a>
                </li>
                <li>
                    <a href="${pageContext.request.contextPath}/admin/profile">
                        <i class="fa-solid fa-user-gear"></i> My Profile
                    </a>
                </li>
            </ul>

            <!-- Quick status bar -->
            <div style="margin:var(--sp-4) 0 0;padding:var(--sp-3) var(--sp-4);background:var(--ink-50);border-radius:var(--r-md);border:1px solid var(--ink-100);">
                <div style="font-size:.68rem;text-transform:uppercase;letter-spacing:.08em;font-weight:800;color:var(--ink-400);margin-bottom:2px;">System Status</div>
                <div style="display:flex;align-items:center;gap:6px;font-size:.8rem;font-weight:600;color:var(--ink-700);">
                    <span class="status-pill-dot" style="width:7px;height:7px;border-radius:50%;background:var(--emerald);display:inline-block;"></span>
                    Live Dispatching
                </div>
            </div>
        </aside>

        <!-- Main Content Area -->
        <section>
            <div style="display: flex; justify-content: space-between; align-items: center; flex-wrap: wrap; gap: 16px; margin-bottom: 24px;">
                <div>
                    <span style="color: var(--primary); font-weight: 700; font-size: 0.85rem; text-transform: uppercase;">Kitchen & Delivery Pipeline</span>
                    <h1 style="font-size: 2rem; margin-top: 2px;">Order Management</h1>
                </div>

                <!-- Status Filter Dropdown / Form -->
                <form action="${pageContext.request.contextPath}/admin/orders" method="get" style="display: flex; gap: 10px; align-items: center;">
                    <label style="font-size: 0.88rem; font-weight: 600; color: var(--gray-600);">Filter Status:</label>
                    <select name="status" class="form-control" onchange="this.form.submit();" style="padding: 8px 14px; width: auto; font-size: 0.9rem;">
                        <option value="ALL" ${empty filterStatus or filterStatus == 'ALL' ? 'selected' : ''}>All Orders</option>
                        <option value="PENDING" ${filterStatus == 'PENDING' ? 'selected' : ''}>Pending</option>
                        <option value="PREPARING" ${filterStatus == 'PREPARING' ? 'selected' : ''}>Preparing</option>
                        <option value="OUT_FOR_DELIVERY" ${filterStatus == 'OUT_FOR_DELIVERY' ? 'selected' : ''}>Out for Delivery</option>
                        <option value="COMPLETED" ${filterStatus == 'COMPLETED' ? 'selected' : ''}>Completed</option>
                        <option value="CANCELLED" ${filterStatus == 'CANCELLED' ? 'selected' : ''}>Cancelled</option>
                    </select>
                </form>
            </div>

            <!-- Notification Banner -->
            <c:if test="${param.msg == 'status_updated'}">
                <div class="alert alert-success">
                    <i class="fa-solid fa-circle-check"></i> Order status successfully updated.
                </div>
            </c:if>
            <c:if test="${param.msg == 'rider_assigned'}">
                <div class="alert alert-success">
                    <i class="fa-solid fa-circle-check"></i> Delivery partner successfully assigned & dispatched! The order is now live on the rider portal.
                </div>
            </c:if>
            <c:if test="${param.error == 'select_rider'}">
                <div class="alert alert-danger">
                    <i class="fa-solid fa-triangle-exclamation"></i> Please select a valid delivery partner from the dropdown list.
                </div>
            </c:if>
            <c:if test="${param.error == 'rider_already_busy'}">
                <div class="alert alert-danger" style="background: #FEE2E2; color: #991B1B; border: 1px solid #F87171; padding: 14px 18px; border-radius: var(--r-xl); display: flex; align-items: center; gap: 10px;">
                    <i class="fa-solid fa-lock" style="font-size: 1.2rem;"></i>
                    <div>
                        <strong>Selected Rider is Currently Busy!</strong> FoodZone policy strictly enforces that a delivery rider can only handle 1 active order at a time until completed.
                    </div>
                </div>
            </c:if>

            <!-- Orders Table Card -->
            <div style="background: var(--white); border-radius: var(--radius-lg); border: 1px solid var(--gray-200); padding: 24px; box-shadow: var(--shadow-sm);">
                <div class="table-responsive">
                    <table class="data-table">
                        <thead>
                            <tr>
                                <th>Order & Type</th>
                                <th>Customer & Contact</th>
                                <th>Address & Notes</th>
                                <th>Total & Promo</th>
                                <th>Time</th>
                                <th>Status</th>
                                <th>Delivery Partner</th>
                                <th style="text-align: right;">Update Status</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="ord" items="${orders}">
                                <tr>
                                    <td>
                                        <div style="font-weight: 800; font-family: var(--font-heading); color: var(--primary);">
                                            #FZ-${ord.orderId}
                                        </div>
                                        <span class="badge ${ord.orderType == 'TAKEAWAY' ? 'badge-primary' : 'badge-secondary'}" style="font-size: 0.72rem; margin-top: 4px; display: inline-block;">
                                            <i class="fa-solid ${ord.orderType == 'TAKEAWAY' ? 'fa-bag-shopping' : 'fa-motorcycle'}"></i> ${ord.orderType}
                                        </span>
                                        <c:if test="${ord.orderType == 'DELIVERY' and not empty ord.deliveryOtp}">
                                            <div style="font-size: 0.72rem; color: #b45309; font-weight: 700; margin-top: 3px; font-family: monospace; background: #fef3c7; padding: 1px 5px; border-radius: 4px; display: inline-block;" title="Delivery Verification OTP">
                                                OTP: ${ord.deliveryOtp}
                                            </div>
                                        </c:if>
                                    </td>
                                    <td>
                                        <div style="font-weight: 600; color: var(--dark);">${ord.customerName}</div>
                                        <div style="font-size: 0.8rem; color: var(--gray-600);"><i class="fa-solid fa-phone" style="font-size: 0.75rem;"></i> ${ord.contactPhone}</div>
                                    </td>
                                    <td style="max-width: 200px; font-size: 0.85rem; color: var(--gray-800);">
                                        <div style="line-height: 1.3;">${ord.deliveryAddress}</div>
                                        <c:if test="${not empty ord.specialNotes}">
                                            <div style="font-size: 0.78rem; color: var(--primary); font-style: italic; margin-top: 4px;">
                                                "${ord.specialNotes}"
                                            </div>
                                        </c:if>
                                    </td>
                                    <td>
                                        <div style="font-weight: 700; color: var(--dark);">₹<fmt:formatNumber value="${ord.totalAmount}" pattern="#,##0.00"/></div>
                                        <div style="font-size: 0.8rem; color: var(--gray-600);">${ord.paymentMethod}</div>
                                        <c:if test="${ord.discountAmount > 0}">
                                            <div style="font-size: 0.74rem; color: #059669; font-weight: 600; margin-top: 2px;">
                                                <i class="fa-solid fa-tag"></i> ${ord.couponCode} (-₹<fmt:formatNumber value="${ord.discountAmount}" pattern="#,##0.00"/>)
                                            </div>
                                        </c:if>
                                    </td>
                                    <td style="font-size: 0.85rem; color: var(--gray-600); white-space: nowrap;">
                                        <fmt:formatDate value="${ord.orderDate}" pattern="dd MMM, hh:mm a" />
                                    </td>
                                    <td>
                                        <span class="badge badge-${ord.orderStatus.toLowerCase()}">
                                            ${ord.orderStatus}
                                        </span>
                                    </td>
                                    <td style="font-size: 0.85rem; min-width: 220px;">
                                        <c:choose>
                                            <c:when test="${ord.orderType == 'TAKEAWAY'}">
                                                <span class="badge badge-primary" style="font-size: 0.78rem; padding: 4px 8px;">
                                                    <i class="fa-solid fa-store"></i> Counter Pickup (No Rider)
                                                </span>
                                            </c:when>
                                            <c:when test="${ord.orderStatus != 'COMPLETED' and ord.orderStatus != 'CANCELLED'}">
                                                <!-- Active Order Rider Assignment Form -->
                                                <form action="${pageContext.request.contextPath}/admin/orders" method="post" style="margin: 0;">
                                                    <input type="hidden" name="action" value="assign-rider">
                                                    <input type="hidden" name="orderId" value="${ord.orderId}">
                                                    
                                                    <c:if test="${ord.riderId > 0}">
                                                        <div style="font-size: 0.8rem; color: #059669; font-weight: 700; margin-bottom: 4px;">
                                                            <i class="fa-solid fa-circle-check"></i> Assigned: ${ord.riderName}
                                                            <c:if test="${not empty ord.riderPhone}"><span style="font-weight: 400; color: var(--gray-600); font-size: 0.75rem;">(${ord.riderPhone})</span></c:if>
                                                        </div>
                                                    </c:if>

                                                    <div style="display: flex; gap: 4px; align-items: center;">
                                                        <select name="riderId" class="form-control" required style="padding: 4px 6px; font-size: 0.8rem; height: 32px; width: 140px;">
                                                            <option value="" disabled ${ord.riderId == null || ord.riderId <= 0 ? 'selected' : ''}>-- Select Rider --</option>
                                                            <c:forEach var="rider" items="${deliveryRiders}">
                                                                <option value="${rider.userId}" ${ord.riderId == rider.userId ? 'selected' : ''}>
                                                                    ${rider.fullName} (${rider.vehicleNo})
                                                                </option>
                                                            </c:forEach>
                                                        </select>
                                                        <button type="submit" class="btn btn-primary btn-sm" style="background: #059669; border-color: #059669; height: 32px; padding: 4px 8px; font-size: 0.78rem; font-weight: 600; white-space: nowrap;" title="Assign & Dispatch Rider">
                                                            <i class="fa-solid fa-motorcycle"></i> ${ord.riderId > 0 ? 'Change' : 'Dispatch'}
                                                        </button>
                                                    </div>
                                                </form>
                                            </c:when>
                                            <c:when test="${ord.riderId > 0}">
                                                <div style="font-weight: 600; color: #059669;">
                                                    <i class="fa-solid fa-motorcycle"></i> ${ord.riderName}
                                                </div>
                                                <div style="font-size: 0.75rem; color: var(--gray-600);">
                                                    ${ord.riderPhone} <c:if test="${not empty ord.riderVehicle}">&bull; ${ord.riderVehicle}</c:if>
                                                </div>
                                            </c:when>
                                            <c:otherwise>
                                                <span style="color: var(--gray-500); font-size: 0.8rem;">—</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td style="text-align: right; white-space: nowrap;">
                                        <form action="${pageContext.request.contextPath}/admin/orders" method="post" style="display: inline-flex; align-items: center; gap: 6px; margin: 0;">
                                            <input type="hidden" name="orderId" value="${ord.orderId}">
                                            <select name="newStatus" class="form-control" style="padding: 4px 8px; font-size: 0.82rem; width: auto; height: 32px;">
                                                <option value="PENDING" ${ord.orderStatus == 'PENDING' ? 'selected' : ''}>Pending</option>
                                                <option value="PREPARING" ${ord.orderStatus == 'PREPARING' ? 'selected' : ''}>Preparing</option>
                                                <option value="OUT_FOR_DELIVERY" ${ord.orderStatus == 'OUT_FOR_DELIVERY' ? 'selected' : ''}>Out for Delivery</option>
                                                <option value="COMPLETED" ${ord.orderStatus == 'COMPLETED' ? 'selected' : ''}>Completed</option>
                                                <option value="CANCELLED" ${ord.orderStatus == 'CANCELLED' ? 'selected' : ''}>Cancelled</option>
                                            </select>
                                            <button type="submit" class="btn btn-primary btn-sm" style="padding: 4px 10px; height: 32px;" title="Save Status">
                                                <i class="fa-solid fa-check"></i>
                                            </button>
                                        </form>
                                        <a href="${pageContext.request.contextPath}/order-details?id=${ord.orderId}" class="btn btn-outline btn-sm" style="margin-left: 6px; padding: 4px 8px; height: 32px;" title="View Details">
                                            <i class="fa-regular fa-eye"></i>
                                        </a>
                                    </td>
                                </tr>
                            </c:forEach>
                            <c:if test="${empty orders}">
                                <tr>
                                    <td colspan="8" style="text-align: center; color: var(--gray-600); padding: 40px;">
                                        No orders found matching the selected filter.
                                    </td>
                                </tr>
                            </c:if>
                        </tbody>
                    </table>
                </div>
            </div>
        </section>
    </div>
</main>

<jsp:include page="/WEB-INF/views/common/footer.jsp" />
