<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>

<c:set var="pageTitle" value="Admin Dashboard — FoodZone" />
<c:set var="activeAdminTab" value="dashboard" />

<jsp:include page="/WEB-INF/views/common/header.jsp" />
<jsp:include page="/WEB-INF/views/common/navbar.jsp" />

<div style="background:var(--ink-50);min-height:calc(100vh - 72px);padding-bottom:var(--sp-16);">
<div class="container">
<div class="admin-layout">

    <!-- ── Sidebar ── -->
    <aside class="admin-sidebar">
        <div class="admin-sidebar-header">
            <div class="admin-sidebar-eyebrow">Management Console</div>
            <div class="admin-sidebar-title">Admin Portal</div>
        </div>
        <ul class="admin-nav">
            <li>
                <a href="${pageContext.request.contextPath}/admin/dashboard" class="${activeAdminTab == 'dashboard' ? 'active' : ''}">
                    <i class="fa-solid fa-chart-pie"></i> Dashboard
                </a>
            </li>
            <li>
                <a href="${pageContext.request.contextPath}/admin/orders" class="${activeAdminTab == 'orders' ? 'active' : ''}">
                    <i class="fa-solid fa-receipt"></i> Live Orders
                </a>
            </li>
            <li>
                <a href="${pageContext.request.contextPath}/admin/menu" class="${activeAdminTab == 'menu' ? 'active' : ''}">
                    <i class="fa-solid fa-burger"></i> Menu Catalog
                </a>
            </li>
            <li>
                <a href="${pageContext.request.contextPath}/admin/users" class="${activeAdminTab == 'users' ? 'active' : ''}">
                    <i class="fa-solid fa-users"></i> Customers
                </a>
            </li>
            <li>
                <a href="${pageContext.request.contextPath}/admin/profile" class="${activeAdminTab == 'profile' ? 'active' : ''}">
                    <i class="fa-solid fa-user-gear"></i> My Profile
                </a>
            </li>
        </ul>

        <!-- Quick status bar -->
        <div style="margin:var(--sp-3) var(--sp-4) var(--sp-4);padding:var(--sp-4);background:var(--ink-50);border-radius:var(--r-lg);border:1px solid var(--ink-100);">
            <div style="font-size:.7rem;text-transform:uppercase;letter-spacing:.08em;font-weight:800;color:var(--ink-400);margin-bottom:var(--sp-2);">System Status</div>
            <div style="display:flex;align-items:center;gap:6px;font-size:.82rem;font-weight:600;color:var(--ink-700);">
                <span class="status-pill-dot" style="width:7px;height:7px;border-radius:50%;background:var(--emerald);display:inline-block;"></span>
                All Systems Operational
            </div>
        </div>
    </aside>

    <!-- ── Main Content ── -->
    <section>
        <!-- Page header -->
        <div style="display:flex;justify-content:space-between;align-items:flex-start;margin-bottom:var(--sp-8);flex-wrap:wrap;gap:var(--sp-4);">
            <div>
                <div style="font-size:.75rem;font-weight:800;text-transform:uppercase;letter-spacing:.1em;color:var(--brand);margin-bottom:4px;">Overview & Metrics</div>
                <h1 style="font-family:var(--font-display);font-size:2rem;font-weight:800;color:var(--ink-900);letter-spacing:-.03em;">Store Performance</h1>
            </div>
            <div style="display:flex;align-items:center;gap:8px;background:var(--ink-0);padding:8px 16px;border-radius:var(--r-full);border:1px solid var(--ink-100);font-size:.83rem;color:var(--ink-500);font-weight:600;box-shadow:var(--shadow-xs);">
                <span class="status-pill-dot" style="width:7px;height:7px;border-radius:50%;background:var(--emerald);display:inline-block;animation:pulse-dot 1.8s ease-in-out infinite;"></span>
                Live System Connected
            </div>
        </div>

        <!-- KPI Cards -->
        <div class="stats-grid">
            <div class="stat-card">
                <div class="stat-icon" style="background:#ECFDF5;color:#059669;">
                    <i class="fa-solid fa-indian-rupee-sign"></i>
                </div>
                <div>
                    <div class="stat-val">₹<fmt:formatNumber value="${not empty totalRevenue ? totalRevenue : 0}" pattern="#,##0"/></div>
                    <div class="stat-label">Total Revenue</div>
                    <div class="stat-trend stat-trend-up"><i class="fa-solid fa-arrow-trend-up"></i> Live</div>
                </div>
            </div>

            <div class="stat-card">
                <div class="stat-icon" style="background:#EFF6FF;color:#2563EB;">
                    <i class="fa-solid fa-receipt"></i>
                </div>
                <div>
                    <div class="stat-val">${totalOrders}</div>
                    <div class="stat-label">Total Orders</div>
                    <div class="stat-trend stat-trend-up"><i class="fa-solid fa-arrow-trend-up"></i> All time</div>
                </div>
            </div>

            <div class="stat-card">
                <div class="stat-icon" style="background:#FFFBEB;color:#D97706;">
                    <i class="fa-solid fa-hourglass-half"></i>
                </div>
                <div>
                    <div class="stat-val">${pendingOrders}</div>
                    <div class="stat-label">Pending in Kitchen</div>
                    <c:if test="${pendingOrders > 0}">
                        <div class="stat-trend" style="color:var(--amber);"><i class="fa-solid fa-triangle-exclamation"></i> Needs action</div>
                    </c:if>
                </div>
            </div>

            <div class="stat-card">
                <div class="stat-icon" style="background:#FDF2F8;color:#DB2777;">
                    <i class="fa-solid fa-utensils"></i>
                </div>
                <div>
                    <div class="stat-val">${totalItems}</div>
                    <div class="stat-label">Active Dishes</div>
                </div>
            </div>

            <div class="stat-card">
                <div class="stat-icon" style="background:#F5F3FF;color:#7C3AED;">
                    <i class="fa-solid fa-users"></i>
                </div>
                <div>
                    <div class="stat-val">${totalCustomers}</div>
                    <div class="stat-label">Customers</div>
                </div>
            </div>
        </div>

        <!-- Recent Orders Table -->
        <div class="card card-p-lg">
            <div style="display:flex;justify-content:space-between;align-items:center;margin-bottom:var(--sp-5);flex-wrap:wrap;gap:var(--sp-4);">
                <h2 style="font-family:var(--font-display);font-size:1.2rem;font-weight:800;color:var(--ink-900);">Recent Orders</h2>
                <a href="${pageContext.request.contextPath}/admin/orders" class="btn btn-outline btn-sm">
                    View All <i class="fa-solid fa-arrow-right" style="font-size:.75rem;"></i>
                </a>
            </div>

            <div class="table-responsive">
                <table class="data-table">
                    <thead>
                        <tr>
                            <th>Order</th>
                            <th>Customer</th>
                            <th>Date & Time</th>
                            <th>Amount</th>
                            <th>Status</th>
                            <th style="text-align:right;">Action</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="ord" items="${recentOrders}">
                            <tr>
                                <td>
                                    <span style="font-family:var(--font-display);font-weight:800;color:var(--brand);font-size:.95rem;">#FZ-${ord.orderId}</span>
                                </td>
                                <td>
                                    <div style="display:flex;align-items:center;gap:var(--sp-3);">
                                        <div style="width:32px;height:32px;border-radius:50%;background:linear-gradient(135deg,var(--brand),var(--brand-600));color:#fff;display:flex;align-items:center;justify-content:center;font-weight:800;font-size:.78rem;flex-shrink:0;">
                                            ${fn:substring(ord.customerName, 0, 1)}
                                        </div>
                                        <div>
                                            <div style="font-weight:700;font-size:.9rem;">${ord.customerName}</div>
                                            <div style="font-size:.78rem;color:var(--ink-400);">${ord.contactPhone}</div>
                                        </div>
                                    </div>
                                </td>
                                <td style="font-size:.83rem;color:var(--ink-400);white-space:nowrap;">
                                    <fmt:formatDate value="${ord.orderDate}" pattern="dd MMM, hh:mm a" />
                                </td>
                                <td style="font-family:var(--font-display);font-weight:800;font-size:1rem;color:var(--ink-900);">
                                    ₹<fmt:formatNumber value="${ord.totalAmount}" pattern="#,##0"/>
                                </td>
                                <td>
                                    <span class="badge badge-${ord.orderStatus.toLowerCase()}">${ord.orderStatus}</span>
                                </td>
                                <td style="text-align:right;">
                                    <a href="${pageContext.request.contextPath}/order-details?id=${ord.orderId}"
                                       class="btn btn-outline btn-xs">Receipt</a>
                                </td>
                            </tr>
                        </c:forEach>
                        <c:if test="${empty recentOrders}">
                            <tr>
                                <td colspan="6">
                                    <div style="text-align:center;padding:var(--sp-10);color:var(--ink-400);">
                                        <i class="fa-solid fa-receipt" style="font-size:2rem;margin-bottom:var(--sp-3);opacity:.4;display:block;"></i>
                                        No orders yet
                                    </div>
                                </td>
                            </tr>
                        </c:if>
                    </tbody>
                </table>
            </div>
        </div>
    </section>

</div><!-- admin-layout -->
</div><!-- container -->
</div><!-- bg wrapper -->

<jsp:include page="/WEB-INF/views/common/footer.jsp" />
