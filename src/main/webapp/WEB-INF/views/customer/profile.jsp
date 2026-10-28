<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<c:set var="pageTitle" value="My Profile - FoodZone" />
<c:set var="activePage" value="profile" />

<jsp:include page="/WEB-INF/views/common/header.jsp" />
<jsp:include page="/WEB-INF/views/common/navbar.jsp" />

<main class="container" style="padding-top: 36px; padding-bottom: 70px;">
    <!-- Profile Header Banner -->
    <div style="background: linear-gradient(135deg, #1F2937, #111827); border-radius: var(--radius-lg); padding: 32px; color: var(--white); margin-bottom: 30px; box-shadow: var(--shadow-md); display: flex; justify-content: space-between; align-items: center; flex-wrap: wrap; gap: 20px;">
        <div style="display: flex; align-items: center; gap: 20px;">
            <div style="width: 72px; height: 72px; border-radius: 50%; background: linear-gradient(135deg, var(--primary), var(--secondary)); color: var(--white); display: flex; align-items: center; justify-content: center; font-size: 2rem; font-weight: 800; font-family: var(--font-heading); box-shadow: 0 4px 12px rgba(255, 107, 53, 0.4);">
                ${user.fullName.substring(0, 1).toUpperCase()}
            </div>
            <div>
                <div style="display: flex; align-items: center; gap: 10px;">
                    <h1 style="font-size: 1.8rem; color: var(--white); margin: 0; font-family: var(--font-heading);">${user.fullName}</h1>
                    <span class="badge" style="background: rgba(255, 107, 53, 0.2); color: var(--primary); border: 1px solid var(--primary); font-size: 0.75rem;">
                        Verified Foodie
                    </span>
                </div>
                <p style="color: var(--gray-400); font-size: 0.9rem; margin-top: 4px;">
                    <i class="fa-solid fa-envelope" style="margin-right: 6px;"></i> ${user.email} &bull;
                    <i class="fa-solid fa-phone" style="margin-left: 8px; margin-right: 4px;"></i> ${not empty user.phone ? user.phone : 'No phone linked'}
                </p>
            </div>
        </div>

        <!-- Quick Summary Numbers -->
        <div style="display: flex; gap: 14px; flex-wrap: wrap;">
            <div style="background: rgba(255,255,255,0.06); padding: 12px 20px; border-radius: var(--radius-md); text-align: center; border: 1px solid rgba(255,255,255,0.1); min-width: 90px;">
                <div style="font-size: 1.6rem; font-weight: 800; color: var(--primary);">${stats.totalOrders}</div>
                <div style="font-size: 0.72rem; text-transform: uppercase; color: var(--gray-400); font-weight: 600;">Total Orders</div>
            </div>
            <div style="background: rgba(255,255,255,0.06); padding: 12px 20px; border-radius: var(--radius-md); text-align: center; border: 1px solid rgba(255,255,255,0.1); min-width: 110px;">
                <div style="font-size: 1.6rem; font-weight: 800; color: #10B981;">₹<fmt:formatNumber value="${stats.totalSpent}" pattern="#,##0"/></div>
                <div style="font-size: 0.72rem; text-transform: uppercase; color: var(--gray-400); font-weight: 600;">Total Spent</div>
            </div>
            <div style="background: rgba(255,255,255,0.06); padding: 12px 20px; border-radius: var(--radius-md); text-align: center; border: 1px solid rgba(255,255,255,0.1); min-width: 90px;">
                <div style="font-size: 1.6rem; font-weight: 800; color: var(--warning);">${stats.activeOrders}</div>
                <div style="font-size: 0.72rem; text-transform: uppercase; color: var(--gray-400); font-weight: 600;">Active Now</div>
            </div>
        </div>
    </div>

    <!-- Alert Message -->
    <c:if test="${param.msg == 'profile_updated'}">
        <div class="alert alert-success" style="margin-bottom: 24px; display: flex; align-items: center; gap: 12px; background: #ECFDF5; color: #065F46; border: 1px solid #6EE7B7; padding: 14px 18px; border-radius: var(--radius-md);">
            <i class="fa-solid fa-circle-check" style="font-size: 1.3rem;"></i>
            <div><strong>Profile Updated!</strong> Your personal details and delivery address have been saved.</div>
        </div>
    </c:if>

    <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 30px; align-items: flex-start;">
        
        <!-- Column 1: Edit Profile Details -->
        <div style="background: var(--white); border-radius: var(--radius-lg); border: 1px solid var(--gray-200); padding: 28px; box-shadow: var(--shadow-sm);">
            <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px; border-bottom: 1px solid var(--gray-200); padding-bottom: 12px;">
                <h2 style="font-size: 1.25rem; margin: 0; color: var(--dark);">
                    <i class="fa-solid fa-user-gear" style="color: var(--primary); margin-right: 8px;"></i> Account Details
                </h2>
                <span style="font-size: 0.8rem; color: var(--gray-500);">Keep your contact info fresh</span>
            </div>

            <form action="${pageContext.request.contextPath}/profile" method="POST">
                <div class="form-group" style="margin-bottom: 18px;">
                    <label class="form-label" for="fullName">Full Name <span style="color: var(--danger);">*</span></label>
                    <input type="text" id="fullName" name="fullName" class="form-control" value="${user.fullName}" required>
                </div>

                <div class="form-group" style="margin-bottom: 18px;">
                    <label class="form-label">Email Address</label>
                    <div style="position: relative;">
                        <input type="email" class="form-control" value="${user.email}" readonly style="background: var(--gray-50); color: var(--gray-600); cursor: not-allowed; padding-right: 36px;">
                        <i class="fa-solid fa-lock" style="position: absolute; right: 12px; top: 12px; color: var(--gray-400);"></i>
                    </div>
                    <span style="font-size: 0.75rem; color: var(--gray-500); margin-top: 4px; display: block;">Email is tied to your account login and cannot be altered.</span>
                </div>

                <div class="form-group" style="margin-bottom: 18px;">
                    <label class="form-label" for="phone">Primary Phone Number <span style="color: var(--danger);">*</span></label>
                    <input type="tel" id="phone" name="phone" class="form-control" value="${user.phone}" required placeholder="10-digit mobile number">
                </div>

                <div class="form-group" style="margin-bottom: 24px;">
                    <label class="form-label" for="address">Default Saved Delivery Address</label>
                    <textarea id="address" name="address" class="form-control" rows="3" placeholder="Flat No, Floor, Building Name, Society, Street, Pincode">${user.address}</textarea>
                    <span style="font-size: 0.75rem; color: var(--gray-500); margin-top: 4px; display: block;">This address will auto-fill during fast 1-click checkout.</span>
                </div>

                <button type="submit" class="btn btn-primary" style="width: 100%; padding: 12px;">
                    <i class="fa-solid fa-floppy-disk"></i> Save Profile Details
                </button>
            </form>
        </div>

        <!-- Column 2: Recent Activity & Quick Shortcuts -->
        <div style="display: flex; flex-direction: column; gap: 24px;">
            <!-- Recent Orders Mini Card -->
            <div style="background: var(--white); border-radius: var(--radius-lg); border: 1px solid var(--gray-200); padding: 26px; box-shadow: var(--shadow-sm);">
                <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 16px; border-bottom: 1px solid var(--gray-200); padding-bottom: 12px;">
                    <h3 style="font-size: 1.15rem; margin: 0; color: var(--dark);">
                        <i class="fa-solid fa-clock-rotate-left" style="color: var(--secondary); margin-right: 8px;"></i> Recent Orders
                    </h3>
                    <a href="${pageContext.request.contextPath}/orders" style="font-size: 0.85rem; color: var(--primary); font-weight: 700; text-decoration: underline;">
                        View All (${stats.totalOrders})
                    </a>
                </div>

                <c:choose>
                    <c:when test="${empty recentOrders}">
                        <div style="text-align: center; padding: 24px; color: var(--gray-500);">
                            <i class="fa-solid fa-pizza-slice" style="font-size: 2.2rem; color: var(--gray-300); margin-bottom: 8px; display: block;"></i>
                            No orders placed yet. Explore delicious pizzas today!
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div style="display: flex; flex-direction: column; gap: 12px;">
                            <c:forEach items="${recentOrders}" var="ro">
                                <a href="${pageContext.request.contextPath}/order-details?id=${ro.orderId}" style="display: flex; justify-content: space-between; align-items: center; padding: 10px 14px; background: var(--gray-50); border: 1px solid var(--gray-200); border-radius: var(--radius-md); text-decoration: none; color: inherit; transition: background 0.2s;">
                                    <div>
                                        <strong style="color: var(--primary); font-size: 0.95rem;">#FZ-${ro.orderId}</strong>
                                        <span style="font-size: 0.78rem; color: var(--gray-500); display: block;">
                                            <fmt:formatDate value="${ro.orderDate}" pattern="dd MMM yyyy, hh:mm a" />
                                        </span>
                                    </div>
                                    <div style="text-align: right;">
                                        <span style="font-weight: 700; color: var(--dark); font-size: 0.95rem; display: block;">
                                            ₹<fmt:formatNumber value="${ro.totalAmount}" pattern="#,##0.00"/>
                                        </span>
                                        <span class="badge badge-${ro.orderStatus.toLowerCase()}" style="font-size: 0.7rem; padding: 2px 8px;">
                                            ${ro.orderStatus}
                                        </span>
                                    </div>
                                </a>
                            </c:forEach>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>

            <!-- Quick Action Shortcuts -->
            <div style="background: #FFF7ED; border: 1px solid #FFEDD5; border-radius: var(--radius-lg); padding: 20px;">
                <h4 style="font-size: 0.95rem; color: var(--dark); margin-bottom: 12px;">Quick Shortcuts</h4>
                <div style="display: flex; gap: 10px; flex-wrap: wrap;">
                    <a href="${pageContext.request.contextPath}/menu" class="btn btn-primary btn-sm">
                        <i class="fa-solid fa-utensils"></i> Browse Menu
                    </a>
                    <a href="${pageContext.request.contextPath}/cart" class="btn btn-outline btn-sm">
                        <i class="fa-solid fa-cart-shopping"></i> View Cart
                    </a>
                    <a href="${pageContext.request.contextPath}/orders" class="btn btn-outline btn-sm">
                        <i class="fa-solid fa-list-check"></i> Order History
                    </a>
                </div>
            </div>
        </div>

    </div>
</main>

<jsp:include page="/WEB-INF/views/common/footer.jsp" />
