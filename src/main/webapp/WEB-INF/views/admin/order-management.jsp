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
            <div style="padding-bottom: 16px; margin-bottom: 16px; border-bottom: 1px solid var(--gray-200);">
                <span style="font-size: 0.75rem; text-transform: uppercase; font-weight: 700; color: var(--gray-600); letter-spacing: 0.05em;">Management Console</span>
                <h3 style="font-size: 1.1rem; margin-top: 4px;">Admin Portal</h3>
            </div>
            <ul class="admin-nav">
                <li>
                    <a href="${pageContext.request.contextPath}/admin/dashboard">
                        <i class="fa-solid fa-chart-pie"></i> Dashboard
                    </a>
                </li>
                <li>
                    <a href="${pageContext.request.contextPath}/admin/menu">
                        <i class="fa-solid fa-burger"></i> Menu Catalog
                    </a>
                </li>
                <li>
                    <a href="${pageContext.request.contextPath}/admin/orders" class="active">
                        <i class="fa-solid fa-clipboard-list"></i> Live Orders
                    </a>
                </li>
                <li>
                    <a href="${pageContext.request.contextPath}/admin/users">
                        <i class="fa-solid fa-users"></i> Customers
                    </a>
                </li>
            </ul>
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

            <!-- Orders Table Card -->
            <div style="background: var(--white); border-radius: var(--radius-lg); border: 1px solid var(--gray-200); padding: 24px; box-shadow: var(--shadow-sm);">
                <div class="table-responsive">
                    <table class="data-table">
                        <thead>
                            <tr>
                                <th>Order ID</th>
                                <th>Customer & Contact</th>
                                <th>Address & Notes</th>
                                <th>Total & Payment</th>
                                <th>Time</th>
                                <th>Current Status</th>
                                <th style="text-align: right;">Update Status</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="ord" items="${orders}">
                                <tr>
                                    <td style="font-weight: 800; font-family: var(--font-heading); color: var(--primary);">
                                        #FZ-${ord.orderId}
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
                                    </td>
                                    <td style="font-size: 0.85rem; color: var(--gray-600); white-space: nowrap;">
                                        <fmt:formatDate value="${ord.orderDate}" pattern="dd MMM, hh:mm a" />
                                    </td>
                                    <td>
                                        <span class="badge badge-${ord.orderStatus.toLowerCase()}">
                                            ${ord.orderStatus}
                                        </span>
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
                                    <td colspan="7" style="text-align: center; color: var(--gray-600); padding: 40px;">
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
