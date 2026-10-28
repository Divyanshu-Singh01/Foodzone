<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<c:set var="pageTitle" value="Customer Directory - FoodZone Admin" />
<c:set var="activeAdminTab" value="users" />

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
                    <a href="${pageContext.request.contextPath}/admin/orders">
                        <i class="fa-solid fa-clipboard-list"></i> Live Orders
                    </a>
                </li>
                <li>
                    <a href="${pageContext.request.contextPath}/admin/menu">
                        <i class="fa-solid fa-burger"></i> Menu Catalog
                    </a>
                </li>
                <li>
                    <a href="${pageContext.request.contextPath}/admin/users" class="active">
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
                <div style="font-size:.68rem;text-transform:uppercase;letter-spacing:.08em;font-weight:800;color:var(--ink-400);margin-bottom:2px;">User Directory</div>
                <div style="display:flex;align-items:center;gap:6px;font-size:.8rem;font-weight:600;color:var(--ink-700);">
                    <span class="status-pill-dot" style="width:7px;height:7px;border-radius:50%;background:var(--emerald);display:inline-block;"></span>
                    Active Registry
                </div>
            </div>
        </aside>

        <!-- Main Content Area -->
        <section>
            <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 24px;">
                <div>
                    <span style="color: var(--primary); font-weight: 700; font-size: 0.85rem; text-transform: uppercase;">Customer Directory</span>
                    <h1 style="font-size: 2rem; margin-top: 2px;">Registered Customers</h1>
                </div>
                <div style="font-size: 0.9rem; font-weight: 600; background: var(--white); padding: 8px 16px; border-radius: var(--radius-full); border: 1px solid var(--gray-200);">
                    Total: <span style="color: var(--primary); font-weight: 800;">${customers.size()}</span> Accounts
                </div>
            </div>

            <!-- Customer Table Card -->
            <div style="background: var(--white); border-radius: var(--radius-lg); border: 1px solid var(--gray-200); padding: 24px; box-shadow: var(--shadow-sm);">
                <div class="table-responsive">
                    <table class="data-table">
                        <thead>
                            <tr>
                                <th>User ID</th>
                                <th>Full Name</th>
                                <th>Email Address</th>
                                <th>Phone Number</th>
                                <th>Delivery Address</th>
                                <th>Registered On</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="cust" items="${customers}">
                                <tr>
                                    <td style="font-weight: 800; font-family: var(--font-heading); color: var(--primary);">
                                        #U-${cust.userId}
                                    </td>
                                    <td style="font-weight: 600; color: var(--dark);">
                                        <i class="fa-regular fa-user" style="color: var(--gray-600); margin-right: 6px;"></i>
                                        ${cust.fullName}
                                    </td>
                                    <td style="color: var(--gray-600);">
                                        <a href="mailto:${cust.email}" style="color: var(--gray-600);">
                                            ${cust.email}
                                        </a>
                                    </td>
                                    <td style="font-size: 0.9rem; color: var(--gray-800); white-space: nowrap;">
                                        <i class="fa-solid fa-phone" style="font-size: 0.75rem; color: var(--primary); margin-right: 4px;"></i>
                                        ${cust.phone}
                                    </td>
                                    <td style="max-width: 240px; font-size: 0.85rem; color: var(--gray-600);">
                                        ${not empty cust.address ? cust.address : '<span style="color: var(--gray-300);">None provided</span>'}
                                    </td>
                                    <td style="font-size: 0.85rem; color: var(--gray-600); white-space: nowrap;">
                                        <fmt:formatDate value="${cust.createdAt}" pattern="dd MMM yyyy" />
                                    </td>
                                </tr>
                            </c:forEach>
                            <c:if test="${empty customers}">
                                <tr>
                                    <td colspan="6" style="text-align: center; color: var(--gray-600); padding: 40px;">
                                        No registered customers found.
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
