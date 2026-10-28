<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<c:set var="pageTitle" value="Admin Dashboard - FoodZone" />
<c:set var="activeAdminTab" value="dashboard" />

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
                    <a href="${pageContext.request.contextPath}/admin/dashboard" class="${activeAdminTab == 'dashboard' ? 'active' : ''}">
                        <i class="fa-solid fa-chart-pie"></i> Dashboard
                    </a>
                </li>
                <li>
                    <a href="${pageContext.request.contextPath}/admin/menu" class="${activeAdminTab == 'menu' ? 'active' : ''}">
                        <i class="fa-solid fa-burger"></i> Menu Catalog
                    </a>
                </li>
                <li>
                    <a href="${pageContext.request.contextPath}/admin/orders" class="${activeAdminTab == 'orders' ? 'active' : ''}">
                        <i class="fa-solid fa-clipboard-list"></i> Live Orders
                    </a>
                </li>
                <li>
                    <a href="${pageContext.request.contextPath}/admin/users" class="${activeAdminTab == 'users' ? 'active' : ''}">
                        <i class="fa-solid fa-users"></i> Customers
                    </a>
                </li>
            </ul>
        </aside>

        <!-- Main Content Area -->
        <section>
            <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 24px;">
                <div>
                    <span style="color: var(--primary); font-weight: 700; font-size: 0.85rem; text-transform: uppercase;">Overview & Metrics</span>
                    <h1 style="font-size: 2rem; margin-top: 2px;">Store Performance Dashboard</h1>
                </div>
                <div style="font-size: 0.88rem; color: var(--gray-600); background: var(--white); padding: 8px 16px; border-radius: var(--radius-full); border: 1px solid var(--gray-200);">
                    <i class="fa-solid fa-circle-dot" style="color: var(--secondary); margin-right: 6px;"></i> Live System Connected
                </div>
            </div>

            <!-- KPI Summary Cards Grid -->
            <div class="stats-grid">
                <!-- Total Revenue -->
                <div class="stat-card">
                    <div class="stat-icon" style="background: #ECFDF5; color: #059669;">
                        <i class="fa-solid fa-indian-rupee-sign"></i>
                    </div>
                    <div>
                        <div class="stat-val">₹<fmt:formatNumber value="${not empty totalRevenue ? totalRevenue : 0}" pattern="#,##0.00"/></div>
                        <div class="stat-label">Total Revenue</div>
                    </div>
                </div>

                <!-- Total Orders -->
                <div class="stat-card">
                    <div class="stat-icon" style="background: #EFF6FF; color: #2563EB;">
                        <i class="fa-solid fa-receipt"></i>
                    </div>
                    <div>
                        <div class="stat-val">${totalOrders}</div>
                        <div class="stat-label">Total Orders Placed</div>
                    </div>
                </div>

                <!-- Pending Orders -->
                <div class="stat-card">
                    <div class="stat-icon" style="background: #FFFBEB; color: #D97706;">
                        <i class="fa-solid fa-hourglass-half"></i>
                    </div>
                    <div>
                        <div class="stat-val">${pendingOrders}</div>
                        <div class="stat-label">Pending In Kitchen</div>
                    </div>
                </div>

                <!-- Menu Items -->
                <div class="stat-card">
                    <div class="stat-icon" style="background: #FDF2F8; color: #DB2777;">
                        <i class="fa-solid fa-utensils"></i>
                    </div>
                    <div>
                        <div class="stat-val">${totalItems}</div>
                        <div class="stat-label">Active Dishes</div>
                    </div>
                </div>

                <!-- Customers Count -->
                <div class="stat-card">
                    <div class="stat-icon" style="background: #F5F3FF; color: #7C3AED;">
                        <i class="fa-solid fa-users"></i>
                    </div>
                    <div>
                        <div class="stat-val">${totalCustomers}</div>
                        <div class="stat-label">Registered Customers</div>
                    </div>
                </div>
            </div>

            <!-- Recent Orders Section -->
            <div style="background: var(--white); border-radius: var(--radius-lg); border: 1px solid var(--gray-200); padding: 24px; box-shadow: var(--shadow-sm);">
                <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 18px;">
                    <h2 style="font-size: 1.25rem;">Recent Incoming Orders</h2>
                    <a href="${pageContext.request.contextPath}/admin/orders" class="btn btn-outline btn-sm">
                        View All Orders <i class="fa-solid fa-arrow-right" style="font-size: 0.75rem;"></i>
                    </a>
                </div>

                <div class="table-responsive">
                    <table class="data-table">
                        <thead>
                            <tr>
                                <th>Order ID</th>
                                <th>Customer</th>
                                <th>Date & Time</th>
                                <th>Total</th>
                                <th>Status</th>
                                <th style="text-align: right;">Action</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="ord" items="${recentOrders}">
                                <tr>
                                    <td style="font-weight: 800; font-family: var(--font-heading); color: var(--primary);">
                                        #FZ-${ord.orderId}
                                    </td>
                                    <td>
                                        <div style="font-weight: 600;">${ord.customerName}</div>
                                        <div style="font-size: 0.8rem; color: var(--gray-600);">${ord.contactPhone}</div>
                                    </td>
                                    <td style="font-size: 0.88rem; color: var(--gray-600); white-space: nowrap;">
                                        <fmt:formatDate value="${ord.orderDate}" pattern="dd MMM, hh:mm a" />
                                    </td>
                                    <td style="font-weight: 700; color: var(--dark);">
                                        ₹<fmt:formatNumber value="${ord.totalAmount}" pattern="#,##0.00"/>
                                    </td>
                                    <td>
                                        <span class="badge badge-${ord.orderStatus.toLowerCase()}">
                                            ${ord.orderStatus}
                                        </span>
                                    </td>
                                    <td style="text-align: right; white-space: nowrap;">
                                        <a href="${pageContext.request.contextPath}/order-details?id=${ord.orderId}" class="btn btn-outline btn-sm">
                                            Receipt
                                        </a>
                                    </td>
                                </tr>
                            </c:forEach>
                            <c:if test="${empty recentOrders}">
                                <tr>
                                    <td colspan="6" style="text-align: center; color: var(--gray-600); padding: 30px;">
                                        No recent orders found.
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
