<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<c:set var="pageTitle" value="System Administrator Profile - FoodZone Control" />
<c:set var="activePage" value="admin-profile" />

<jsp:include page="/WEB-INF/views/common/header.jsp" />
<jsp:include page="/WEB-INF/views/common/navbar.jsp" />

<main class="container" style="padding-top: 36px; padding-bottom: 70px;">
    <!-- Profile Header Banner -->
    <div style="background: linear-gradient(135deg, #0F172A 0%, #1E293B 100%); border-radius: var(--radius-lg); padding: 32px; color: var(--white); margin-bottom: 30px; box-shadow: var(--shadow-md); display: flex; justify-content: space-between; align-items: center; flex-wrap: wrap; gap: 20px;">
        <div style="display: flex; align-items: center; gap: 20px;">
            <div style="width: 76px; height: 76px; border-radius: 50%; background: linear-gradient(135deg, #3B82F6, #1D4ED8); color: var(--white); display: flex; align-items: center; justify-content: center; font-size: 2.2rem; font-weight: 800; box-shadow: 0 4px 14px rgba(59, 130, 246, 0.4);">
                <i class="fa-solid fa-user-shield"></i>
            </div>
            <div>
                <div style="display: flex; align-items: center; gap: 12px;">
                    <h1 style="font-size: 1.8rem; color: var(--white); margin: 0; font-family: var(--font-heading);">${admin.fullName}</h1>
                    <span class="badge" style="background: #1E3A8A; color: #93C5FD; font-weight: 700; border: 1px solid #3B82F6; font-size: 0.75rem;">
                        SYSTEM ADMINISTRATOR
                    </span>
                </div>
                <p style="color: var(--gray-400); font-size: 0.9rem; margin-top: 6px;">
                    <i class="fa-solid fa-envelope" style="margin-right: 6px;"></i> ${admin.email} &bull;
                    <i class="fa-solid fa-phone" style="margin-left: 8px; margin-right: 4px;"></i> ${admin.phone}
                </p>
            </div>
        </div>

        <!-- System Counts -->
        <div style="display: flex; gap: 14px; flex-wrap: wrap;">
            <div style="background: rgba(255,255,255,0.06); padding: 12px 18px; border-radius: var(--radius-md); text-align: center; border: 1px solid rgba(255,255,255,0.1); min-width: 90px;">
                <div style="font-size: 1.6rem; font-weight: 800; color: #60A5FA;">${totalOrders}</div>
                <div style="font-size: 0.72rem; text-transform: uppercase; color: var(--gray-400); font-weight: 600;">Total Orders</div>
            </div>
            <div style="background: rgba(255,255,255,0.06); padding: 12px 18px; border-radius: var(--radius-md); text-align: center; border: 1px solid rgba(255,255,255,0.1); min-width: 90px;">
                <div style="font-size: 1.6rem; font-weight: 800; color: #34D399;">${totalCustomers}</div>
                <div style="font-size: 0.72rem; text-transform: uppercase; color: var(--gray-400); font-weight: 600;">Customers</div>
            </div>
            <div style="background: rgba(255,255,255,0.06); padding: 12px 18px; border-radius: var(--radius-md); text-align: center; border: 1px solid rgba(255,255,255,0.1); min-width: 90px;">
                <div style="font-size: 1.6rem; font-weight: 800; color: #F59E0B;">${totalItems}</div>
                <div style="font-size: 0.72rem; text-transform: uppercase; color: var(--gray-400); font-weight: 600;">Menu Dishes</div>
            </div>
        </div>
    </div>

    <!-- Alert Notification -->
    <c:if test="${param.msg == 'profile_updated'}">
        <div class="alert alert-success" style="margin-bottom: 24px; display: flex; align-items: center; gap: 12px; background: #ECFDF5; color: #065F46; border: 1px solid #6EE7B7; padding: 14px 18px; border-radius: var(--radius-md);">
            <i class="fa-solid fa-circle-check" style="font-size: 1.3rem;"></i>
            <div><strong>Administrator Record Updated!</strong> Profile details saved to database.</div>
        </div>
    </c:if>

    <div style="display: grid; grid-template-columns: 1.2fr 0.8fr; gap: 30px; align-items: flex-start;">
        <!-- Left: Edit Admin Profile Details -->
        <div style="background: var(--white); border-radius: var(--radius-lg); border: 1px solid var(--gray-200); padding: 28px; box-shadow: var(--shadow-sm);">
            <div style="margin-bottom: 20px; border-bottom: 1px solid var(--gray-200); padding-bottom: 12px;">
                <h2 style="font-size: 1.25rem; margin: 0; color: var(--dark);">
                    <i class="fa-solid fa-sliders" style="color: #2563EB; margin-right: 8px;"></i> Administrator Credentials
                </h2>
                <span style="font-size: 0.8rem; color: var(--gray-500);">Central platform operator profile</span>
            </div>

            <form action="${pageContext.request.contextPath}/admin/profile" method="POST">
                <div class="form-group" style="margin-bottom: 18px;">
                    <label class="form-label" for="fullName">Admin Full Name <span style="color: var(--danger);">*</span></label>
                    <input type="text" id="fullName" name="fullName" class="form-control" value="${admin.fullName}" required>
                </div>

                <div class="form-group" style="margin-bottom: 18px;">
                    <label class="form-label">Email Address</label>
                    <div style="position: relative;">
                        <input type="email" class="form-control" value="${admin.email}" readonly style="background: var(--gray-50); color: var(--gray-600); cursor: not-allowed; padding-right: 36px;">
                        <i class="fa-solid fa-lock" style="position: absolute; right: 12px; top: 12px; color: var(--gray-400);"></i>
                    </div>
                </div>

                <div class="form-group" style="margin-bottom: 18px;">
                    <label class="form-label" for="phone">Direct Contact Phone <span style="color: var(--danger);">*</span></label>
                    <input type="tel" id="phone" name="phone" class="form-control" value="${admin.phone}" required>
                </div>

                <div class="form-group" style="margin-bottom: 24px;">
                    <label class="form-label" for="address">Central Kitchen / Headquarters Address</label>
                    <textarea id="address" name="address" class="form-control" rows="3">${admin.address}</textarea>
                </div>

                <div style="display: flex; justify-content: space-between; align-items: center; gap: 14px;">
                    <a href="${pageContext.request.contextPath}/admin/dashboard" class="btn btn-outline">
                        <i class="fa-solid fa-arrow-left"></i> Admin Dashboard
                    </a>
                    <button type="submit" class="btn btn-primary" style="background: #2563EB; border-color: #2563EB; padding: 12px 24px;">
                        <i class="fa-solid fa-floppy-disk"></i> Update Admin Record
                    </button>
                </div>
            </form>
        </div>

        <!-- Right: Control Panel Quick Access & System Status -->
        <div style="display: flex; flex-direction: column; gap: 20px;">
            <!-- Admin Portal Quick Navigation -->
            <div style="background: var(--white); border: 1px solid var(--gray-200); border-radius: var(--radius-lg); padding: 22px; box-shadow: var(--shadow-sm);">
                <h4 style="font-size: 1rem; color: var(--dark); margin-bottom: 14px;">
                    <i class="fa-solid fa-bolt" style="color: var(--primary); margin-right: 6px;"></i> Management Consoles
                </h4>
                <div style="display: flex; flex-direction: column; gap: 10px;">
                    <a href="${pageContext.request.contextPath}/admin/orders" class="btn btn-outline" style="text-align: left; justify-content: flex-start; padding: 10px 14px;">
                        <i class="fa-solid fa-truck-fast" style="color: var(--primary); margin-right: 8px;"></i> Live Order & Dispatch Console
                    </a>
                    <a href="${pageContext.request.contextPath}/admin/menu" class="btn btn-outline" style="text-align: left; justify-content: flex-start; padding: 10px 14px;">
                        <i class="fa-solid fa-utensils" style="color: var(--secondary); margin-right: 8px;"></i> Menu Catalog & Pricing
                    </a>
                    <a href="${pageContext.request.contextPath}/admin/customers" class="btn btn-outline" style="text-align: left; justify-content: flex-start; padding: 10px 14px;">
                        <i class="fa-solid fa-users" style="color: #10B981; margin-right: 8px;"></i> Customer Accounts Directory
                    </a>
                </div>
            </div>

            <!-- Architecture & Integrity Health Card -->
            <div style="background: #F8FAFC; border: 1px solid #E2E8F0; border-radius: var(--radius-lg); padding: 22px;">
                <h4 style="font-size: 0.95rem; color: #1E293B; margin-bottom: 10px;">
                    <i class="fa-solid fa-server" style="color: #64748B; margin-right: 6px;"></i> Infrastructure Status
                </h4>
                <div style="font-size: 0.82rem; color: #475569; line-height: 1.8;">
                    <div>&bull; <strong>Server:</strong> Apache Tomcat 10.1 (Jakarta EE 10)</div>
                    <div>&bull; <strong>Database:</strong> MySQL 8.0 (ACID JDBC Transactions)</div>
                    <div>&bull; <strong>Tracking:</strong> Live Real-Time Polling & Webhook Simulator</div>
                    <div>&bull; <strong>Delivery Security:</strong> 4-Digit Cryptographic Handshake OTP</div>
                </div>
            </div>
        </div>
    </div>
</main>

<jsp:include page="/WEB-INF/views/common/footer.jsp" />
