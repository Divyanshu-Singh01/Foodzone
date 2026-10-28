<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>

<c:set var="pageTitle" value="Delivery Partner Hub - FoodZone Logistics" />
<c:set var="activePage" value="delivery" />

<jsp:include page="/WEB-INF/views/common/header.jsp" />
<jsp:include page="/WEB-INF/views/common/navbar.jsp" />

<main class="container" style="padding-top: 32px; padding-bottom: 70px;">
    
    <!-- ════════════════════ 1. RIDER COMMAND CENTER HEADER ════════════════════ -->
    <div class="rider-command-bar">
        <div style="position: relative; z-index: 1; display: flex; justify-content: space-between; align-items: center; flex-wrap: wrap; gap: 24px;">
            
            <!-- Left: Driver Identity Lockup -->
            <div>
                <div style="display: flex; align-items: center; gap: 14px; margin-bottom: 12px; flex-wrap: wrap;">
                    
                    <!-- Tactile iOS/Uber Duty Switch -->
                    <form action="${pageContext.request.contextPath}/delivery" method="POST" style="margin: 0;">
                        <input type="hidden" name="action" value="toggle-duty">
                        <input type="hidden" name="redirect" value="/delivery/dashboard">
                        <button type="submit" class="tactile-duty-switch ${rider.isOnDuty ? 'is-online' : 'is-offline'}"
                                id="dashboard-duty-toggle"
                                title="Click to toggle Shift Duty">
                            <span class="tactile-duty-knob">
                                <i class="fa-solid ${rider.isOnDuty ? 'fa-bolt' : 'fa-power-off'}"></i>
                            </span>
                            <span class="tactile-duty-label">
                                ${rider.isOnDuty ? 'ONLINE • ACCEPTING TRIPS' : 'OFFLINE • SHIFT PAUSED'}
                            </span>
                        </button>
                    </form>

                    <a href="${pageContext.request.contextPath}/delivery/profile" class="btn btn-outline btn-sm"
                       style="color: #FFFFFF; border-color: rgba(255,255,255,0.25); background: rgba(255,255,255,0.06); padding: 6px 14px; font-size: 0.8rem; border-radius: var(--r-full); font-weight: 700;">
                        <i class="fa-solid fa-id-card-clip" style="color: #60A5FA; margin-right: 4px;"></i> Digital Fleet Passport
                    </a>
                </div>

                <div style="display: flex; align-items: center; gap: 12px; flex-wrap: wrap;">
                    <h1 style="font-size: 1.9rem; color: #FFFFFF; margin: 0; font-family: var(--font-display); font-weight: 800; letter-spacing: -0.02em;">
                        ${rider.fullName}
                    </h1>
                    <span style="background: rgba(251, 191, 36, 0.15); color: #FBBF24; border: 1px solid rgba(251, 191, 36, 0.35); font-size: 0.75rem; font-weight: 800; padding: 3px 12px; border-radius: var(--r-full); display: inline-flex; align-items: center; gap: 5px;">
                        <i class="fa-solid fa-star"></i> 4.9 Elite Partner
                    </span>
                </div>

                <div style="color: var(--ink-300); font-size: 0.88rem; display: flex; flex-wrap: wrap; align-items: center; gap: 16px; margin-top: 10px;">
                    <!-- Embossed Indian HSRP Plate -->
                    <span class="hsrp-plate">
                        <span class="hsrp-ind"><span class="hsrp-chakra"></span>IND</span>
                        <span class="hsrp-number">${not empty rider.vehicleNo ? rider.vehicleNo : 'DL 04 AB 1234'}</span>
                    </span>
                    <span><i class="fa-solid fa-motorcycle" style="color: var(--brand);"></i> ${not empty rider.vehicleType ? rider.vehicleType : 'Motorcycle'}</span>
                    <span><i class="fa-solid fa-id-card" style="color: #60A5FA;"></i> DL: ${not empty rider.licenseNo ? rider.licenseNo : 'DL-0420230012345'}</span>
                    <span><i class="fa-solid fa-phone" style="color: var(--emerald);"></i> ${rider.phone}</span>
                </div>
            </div>

            <!-- Right: Shift Telemetry HUD -->
            <div class="telemetry-hud" style="position: relative; z-index: 1;">
                <div class="telemetry-card">
                    <div class="telemetry-val" style="color: var(--brand);">${activeDeliveries.size()}</div>
                    <div class="telemetry-label">Active Trips</div>
                </div>
                <div class="telemetry-card">
                    <div class="telemetry-val" style="color: var(--emerald);">${shiftStats.completedToday != null ? shiftStats.completedToday : completedDeliveries.size()}</div>
                    <div class="telemetry-label">Today Done</div>
                </div>
                <div class="telemetry-card" style="min-width: 130px;">
                    <div class="telemetry-val" style="color: var(--amber);">₹<fmt:formatNumber value="${shiftStats.cashCollectedToday}" pattern="#,##0"/></div>
                    <div class="telemetry-label">Cash In Hand</div>
                </div>
            </div>

        </div>
    </div>

    <c:if test="${param.msg == 'welcome_rider'}">
        <div class="alert alert-success" style="margin-bottom: 24px; display: flex; align-items: center; gap: 12px; background: #ECFDF5; color: #065F46; border: 1.5px solid #34D399; padding: 18px 22px; border-radius: var(--r-xl); box-shadow: 0 4px 14px rgba(16, 185, 129, 0.15);">
            <div style="width: 44px; height: 44px; border-radius: 50%; background: #D1FAE5; color: #059669; display: flex; align-items: center; justify-content: center; font-size: 1.3rem; flex-shrink: 0;">
                <i class="fa-solid fa-sparkles"></i>
            </div>
            <div>
                <strong style="font-size: 1rem; font-family: var(--font-display);">Welcome to the FoodZone Delivery Fleet, ${rider.fullName}!</strong>
                <p style="margin: 2px 0 0 0; font-size: 0.86rem; color: #047857;">Your vehicle and digital credentials have been registered. You are currently <strong>ONLINE</strong> and your Live Dispatch Radar is active below. Happy delivering!</p>
            </div>
        </div>
    </c:if>

    <c:if test="${param.msg == 'delivery_success'}">
        <div class="alert alert-success" style="margin-bottom: 24px; display: flex; align-items: center; gap: 12px; background: #ECFDF5; color: #065F46; border: 1px solid #6EE7B7; padding: 16px; border-radius: var(--r-xl); box-shadow: var(--shadow-sm);">
            <i class="fa-solid fa-circle-check" style="font-size: 1.5rem; color: var(--emerald);"></i>
            <div>
                <strong style="font-size: 0.95rem;">OTP Verified & Delivery Completed!</strong>
                <p style="margin: 2px 0 0 0; font-size: 0.85rem; color: #047857;">Order #FZ-${param.orderId} marked as DELIVERED. Customer receipt and store billing updated successfully.</p>
            </div>
        </div>
    </c:if>

    <c:if test="${param.msg == 'picked_up'}">
        <div class="alert alert-info" style="margin-bottom: 24px; display: flex; align-items: center; gap: 12px; background: #EFF6FF; color: #1E40AF; border: 1px solid #93C5FD; padding: 14px; border-radius: var(--r-xl); box-shadow: var(--shadow-sm);">
            <i class="fa-solid fa-motorcycle" style="font-size: 1.4rem; color: #3B82F6;"></i>
            <div>
                <strong style="font-size: 0.95rem;">Kitchen Pickup Confirmed!</strong>
                <p style="margin: 2px 0 0 0; font-size: 0.85rem; color: #1D4ED8;">Trip #FZ-${param.orderId} is now EN ROUTE to customer doorstep. Drive safely!</p>
            </div>
        </div>
    </c:if>

    <c:if test="${param.msg == 'arrived'}">
        <div class="alert alert-info" style="margin-bottom: 24px; display: flex; align-items: center; gap: 12px; background: #FFFBEB; color: #92400E; border: 1px solid #FCD34D; padding: 14px; border-radius: var(--r-xl); box-shadow: var(--shadow-sm);">
            <i class="fa-solid fa-location-dot" style="font-size: 1.4rem; color: var(--amber);"></i>
            <div>
                <strong style="font-size: 0.95rem;">Arrival Logged at Destination!</strong>
                <p style="margin: 2px 0 0 0; font-size: 0.85rem; color: #78350F;">Customer notified that courier has reached the doorstep. Ask for their 4-digit secret OTP.</p>
            </div>
        </div>
    </c:if>

    <c:if test="${param.msg == 'duty_toggled'}">
        <div class="alert alert-info" style="margin-bottom: 24px; display: flex; align-items: center; gap: 12px; background: #F0FDF4; color: #166534; border: 1px solid #BBF7D0; padding: 12px 18px; border-radius: var(--r-xl); box-shadow: var(--shadow-sm);">
            <i class="fa-solid fa-circle-info" style="color: var(--emerald);"></i>
            <div style="font-size: 0.88rem; font-weight: 600;">Shift duty status updated successfully. Central routing updated.</div>
        </div>
    </c:if>

    <c:if test="${param.error == 'invalid_otp'}">
        <div class="alert alert-error" style="margin-bottom: 24px; display: flex; align-items: center; gap: 12px; background: #FEE2E2; color: #991B1B; border: 1px solid #F87171; padding: 16px; border-radius: var(--r-xl); box-shadow: var(--shadow-sm);">
            <i class="fa-solid fa-triangle-exclamation" style="font-size: 1.5rem; color: var(--red);"></i>
            <div>
                <strong style="font-size: 0.95rem;">Security Verification Failed: Incorrect OTP!</strong>
                <p style="margin: 2px 0 0 0; font-size: 0.85rem; color: #B91C1C;">The entered OTP does not match order #FZ-${param.orderId}. Please ask the customer to read the 4-digit OTP shown on their screen.</p>
            </div>
        </div>
    </c:if>

    <c:if test="${param.msg == 'trip_claimed'}">
        <div class="alert alert-success" style="margin-bottom: 24px; display: flex; align-items: center; gap: 12px; background: #ECFDF5; color: #065F46; border: 1px solid #6EE7B7; padding: 16px; border-radius: var(--r-xl); box-shadow: var(--shadow-sm);">
            <i class="fa-solid fa-circle-check" style="font-size: 1.5rem; color: var(--emerald);"></i>
            <div>
                <strong style="font-size: 0.95rem;">Delivery Request Claimed Successfully!</strong>
                <p style="margin: 2px 0 0 0; font-size: 0.85rem; color: #047857;">You accepted order #FZ-${param.orderId} first! The order is now locked exclusively to you. Follow the route below to complete pickup.</p>
            </div>
        </div>
    </c:if>

    <c:if test="${param.error == 'trip_already_claimed'}">
        <div class="alert alert-error" style="margin-bottom: 24px; display: flex; align-items: center; gap: 12px; background: #FFF1F2; color: #9F1239; border: 1px solid #FDA4AF; padding: 16px; border-radius: var(--r-xl); box-shadow: var(--shadow-sm);">
            <i class="fa-solid fa-person-running" style="font-size: 1.5rem; color: #E11D48;"></i>
            <div>
                <strong style="font-size: 0.95rem;">Order Already Accepted by Another Partner!</strong>
                <p style="margin: 2px 0 0 0; font-size: 0.85rem; color: #BE123C;">Another delivery partner accepted order #FZ-${param.orderId} first. Only 1 rider can accept each order. Keep your radar open!</p>
            </div>
        </div>
    </c:if>

    <c:if test="${param.error == 'active_trip_limit'}">
        <div class="alert alert-error" style="margin-bottom: 24px; display: flex; align-items: center; gap: 12px; background: #FEF2F2; color: #991B1B; border: 1px solid #FCA5A5; padding: 16px; border-radius: var(--r-xl); box-shadow: var(--shadow-sm);">
            <i class="fa-solid fa-lock" style="font-size: 1.5rem; color: var(--red);"></i>
            <div>
                <strong style="font-size: 0.95rem;">Single Active Order Policy (Limit Reached)</strong>
                <p style="margin: 2px 0 0 0; font-size: 0.85rem; color: #B91C1C;">You already have an active order to deliver. You can only deliver 1 order at a time until completed.</p>
            </div>
        </div>
    </c:if>

    <c:if test="${param.error == 'must_be_on_duty'}">
        <div class="alert alert-error" style="margin-bottom: 24px; display: flex; align-items: center; gap: 12px; background: #FFFBEB; color: #92400E; border: 1px solid #FCD34D; padding: 16px; border-radius: var(--r-xl); box-shadow: var(--shadow-sm);">
            <i class="fa-solid fa-power-off" style="font-size: 1.5rem; color: #D97706;"></i>
            <div>
                <strong style="font-size: 0.95rem;">You Are Currently Off-Duty</strong>
                <p style="margin: 2px 0 0 0; font-size: 0.85rem; color: #B45309;">Please turn ON DUTY at the top of your dashboard to accept live delivery orders.</p>
            </div>
        </div>
    </c:if>

    <!-- ════════════════════ 1.5. LIVE DISPATCH RADAR & REQUEST POOL ════════════════════ -->
    <c:choose>
        <%-- Case A: Rider is OFFLINE --%>
        <c:when test="${!rider.isOnDuty}">
            <div class="off-duty-notice-banner">
                <div style="display: flex; align-items: center; gap: 14px;">
                    <div style="width: 44px; height: 44px; border-radius: 50%; background: #F1F5F9; color: #64748B; display: flex; align-items: center; justify-content: center; font-size: 1.25rem;">
                        <i class="fa-solid fa-power-off"></i>
                    </div>
                    <div>
                        <strong style="color: var(--ink-900); font-size: 0.95rem;">Shift Paused (Currently Off-Duty)</strong>
                        <p style="margin: 2px 0 0 0; font-size: 0.85rem; color: var(--ink-400);">Switch 'ONLINE' at the top to receive real-time order requests broadcasted across Sector 18.</p>
                    </div>
                </div>
                <form action="${pageContext.request.contextPath}/delivery" method="POST" style="margin: 0;">
                    <input type="hidden" name="action" value="toggle-duty">
                    <input type="hidden" name="redirect" value="/delivery/dashboard">
                    <button type="submit" class="btn btn-primary" style="padding: 10px 22px; font-weight: 800; border-radius: var(--r-full); font-size: 0.88rem;">
                        <i class="fa-solid fa-bolt" style="margin-right: 6px;"></i> Go Online Now
                    </button>
                </form>
            </div>
        </c:when>

        <%-- Case B: Rider is ONLINE but already has an ACTIVE TRIP (1-Order Limit) --%>
        <c:when test="${hasActiveDelivery}">
            <div class="active-trip-lock-banner">
                <div style="width: 44px; height: 44px; border-radius: 50%; background: #FEF3C7; color: #D97706; display: flex; align-items: center; justify-content: center; font-size: 1.25rem; flex-shrink: 0;">
                    <i class="fa-solid fa-lock"></i>
                </div>
                <div style="flex: 1;">
                    <div style="font-weight: 800; font-size: 0.95rem; color: #92400E; display: flex; align-items: center; gap: 8px;">
                        <span>Single Active Order Policy Engaged</span>
                        <span style="font-size: 0.72rem; padding: 2px 8px; border-radius: var(--r-full); background: #FDE68A; color: #78350F; font-weight: 800;">ACTIVE TRIP IN PROGRESS</span>
                    </div>
                    <p style="margin: 3px 0 0 0; font-size: 0.85rem; color: #B45309; line-height: 1.4;">
                        You are actively delivering Order <strong>#FZ-${activeDeliveries[0].orderId}</strong>. You can only take 1 order at a time until completed. Complete your current delivery with the customer secret OTP to unlock new dispatches.
                    </p>
                </div>
            </div>
        </c:when>

        <%-- Case C: Rider is ONLINE and AVAILABLE to accept incoming orders --%>
        <c:otherwise>
            <div class="radar-container" id="live-dispatch-radar">
                <div class="radar-header">
                    <div>
                        <div style="display: flex; align-items: center; gap: 10px;">
                            <span class="radar-status-badge">
                                <span class="radar-pulse-ring"></span>
                                LIVE DISPATCH RADAR
                            </span>
                            <span style="font-size: 0.78rem; font-weight: 700; color: var(--ink-400);">
                                <i class="fa-solid fa-satellite-dish" style="margin-right: 4px;"></i> Sector 18 Central Dispatch
                            </span>
                        </div>
                        <h2 style="font-size: 1.45rem; font-family: var(--font-display); font-weight: 800; color: var(--ink-900); margin: 8px 0 2px 0;">
                            Available Delivery Requests
                        </h2>
                        <p style="color: var(--ink-400); font-size: 0.86rem; margin: 0;">
                            First on-duty delivery partner to accept secures the trip. Instant atomic lock.
                        </p>
                    </div>
                    <div style="display: flex; align-items: center; gap: 10px;">
                        <button type="button" onclick="location.reload();" class="btn btn-outline btn-sm"
                                style="border-color: var(--ink-200); color: var(--ink-600); font-weight: 700; border-radius: var(--r-full); padding: 7px 16px; font-size: 0.82rem;"
                                title="Refresh Live Radar">
                            <i class="fa-solid fa-arrows-rotate"></i> Refresh
                        </button>
                        <span style="font-size: 0.82rem; font-weight: 800; color: #047857; background: #DCFCE7; padding: 6px 14px; border-radius: var(--r-full);">
                            ${availableOrders.size()} Open Dispatches
                        </span>
                    </div>
                </div>

                <c:choose>
                    <c:when test="${empty availableOrders}">
                        <div class="radar-scanning-box">
                            <div class="radar-sweep-icon">
                                <i class="fa-solid fa-satellite-dish"></i>
                            </div>
                            <h3 style="font-size: 1.2rem; font-family: var(--font-display); font-weight: 800; color: var(--ink-900); margin: 0;">
                                Scanning For Incoming Orders...
                            </h3>
                            <p style="color: var(--ink-400); max-width: 480px; margin: 8px auto 0; font-size: 0.88rem; line-height: 1.5;">
                                Your GPS is linked and shift radar is broadcasting. As soon as a customer places a delivery order, it will appear here in real-time. Be ready to accept first!
                            </p>
                            <div style="margin-top: 18px; display: inline-flex; align-items: center; gap: 8px; font-size: 0.78rem; color: var(--ink-400); background: #FFFFFF; padding: 6px 16px; border-radius: var(--r-full); border: 1px solid var(--ink-200);">
                                <span style="width: 7px; height: 7px; border-radius: 50%; background: #10B981; display: inline-block;"></span>
                                Auto-refreshing every 6 seconds
                            </div>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="broadcast-grid">
                            <c:forEach items="${availableOrders}" var="req">
                                <div class="broadcast-card">
                                    <div class="broadcast-card-top">
                                        <div style="display: flex; align-items: center; gap: 8px;">
                                            <span class="broadcast-tag">
                                                <i class="fa-solid fa-bolt"></i> NEW REQUEST
                                            </span>
                                            <span style="font-family: var(--font-display); font-weight: 900; font-size: 1.1rem; color: var(--ink-900);">
                                                #FZ-${req.orderId}
                                            </span>
                                        </div>
                                        <div class="broadcast-payout-pill">
                                            ₹<fmt:formatNumber value="${req.deliveryFee != null && req.deliveryFee > 0 ? req.deliveryFee : 50}" pattern="#,##0"/> <span style="font-size: 0.75rem; color: #047857; font-weight: 700;">Payout</span>
                                        </div>
                                    </div>

                                    <div class="broadcast-body">
                                        <!-- Route Card -->
                                        <div class="route-step-box">
                                            <div class="route-row">
                                                <div class="route-icon-dot route-icon-pickup">
                                                    <i class="fa-solid fa-store"></i>
                                                </div>
                                                <div>
                                                    <div style="font-size: 0.72rem; color: #C2410C; font-weight: 800; text-transform: uppercase;">1. Pickup Store</div>
                                                    <div style="font-weight: 800; color: var(--ink-900); font-size: 0.88rem;">FoodZone Central Kitchen</div>
                                                    <div style="font-size: 0.78rem; color: var(--ink-400);">Sector 18 Hub &bull; Ready for packing</div>
                                                </div>
                                            </div>
                                            <div style="height: 12px; border-left: 2px dashed #CBD5E1; margin-left: 10px;"></div>
                                            <div class="route-row">
                                                <div class="route-icon-dot route-icon-drop">
                                                    <i class="fa-solid fa-location-dot"></i>
                                                </div>
                                                <div>
                                                    <div style="font-size: 0.72rem; color: #16A34A; font-weight: 800; text-transform: uppercase;">2. Customer Drop</div>
                                                    <div style="font-weight: 800; color: var(--ink-900); font-size: 0.88rem;">${req.deliveryAddress}</div>
                                                    <c:if test="${not empty req.landmark}">
                                                        <div style="font-size: 0.78rem; color: var(--ink-500);"><i class="fa-solid fa-map-pin" style="color: var(--brand);"></i> Near ${req.landmark}</div>
                                                    </c:if>
                                                </div>
                                            </div>
                                        </div>

                                        <!-- Items & Billing Preview -->
                                        <div style="display: flex; justify-content: space-between; align-items: center; padding: 10px 14px; background: #F8FAFC; border-radius: 12px; font-size: 0.82rem;">
                                            <span style="color: var(--ink-600); font-weight: 600;">
                                                <i class="fa-solid fa-bag-shopping" style="color: var(--brand); margin-right: 4px;"></i>
                                                ${req.items.size()} item(s) &bull; ${req.paymentMethod}
                                            </span>
                                            <span style="font-weight: 900; color: var(--ink-900); font-family: var(--font-display);">
                                                Bill: ₹<fmt:formatNumber value="${req.totalAmount}" pattern="#,##0.00" />
                                            </span>
                                        </div>

                                        <!-- Atomic Acceptance Action Form -->
                                        <form action="${pageContext.request.contextPath}/delivery" method="POST" style="margin: 0; margin-top: auto;">
                                            <input type="hidden" name="action" value="accept-trip">
                                            <input type="hidden" name="orderId" value="${req.orderId}">
                                            <button type="submit" class="btn-claim-order">
                                                <i class="fa-solid fa-bolt"></i> ACCEPT DELIVERY FIRST &rarr;
                                            </button>
                                        </form>
                                        <div style="text-align: center; font-size: 0.72rem; color: var(--ink-400); font-weight: 600;">
                                            <i class="fa-solid fa-shield-halved" style="color: var(--emerald);"></i> Locks this order to your route exclusively
                                        </div>
                                    </div>
                                </div>
                            </c:forEach>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </c:otherwise>
    </c:choose>

    <!-- ════════════════════ 2. LIVE ASSIGNED TRIPS ════════════════════ -->
    <div style="margin-bottom: 50px;">
        <div style="display: flex; justify-content: space-between; align-items: flex-end; margin-bottom: 22px;">
            <div>
                <div style="display: flex; align-items: center; gap: 10px;">
                    <div style="width: 32px; height: 32px; border-radius: var(--r-md); background: var(--brand-100); color: var(--brand); display: flex; align-items: center; justify-content: center; font-size: 0.95rem;">
                        <i class="fa-solid fa-route"></i>
                    </div>
                    <h2 style="font-size: 1.45rem; font-family: var(--font-display); font-weight: 800; color: var(--ink-900); margin: 0;">
                        Live Assigned Tasks
                    </h2>
                </div>
                <p style="color: var(--ink-400); font-size: 0.88rem; margin: 4px 0 0 42px;">Follow standard workflow: Store Pickup &rarr; En Route &rarr; Doorstep OTP Verification.</p>
            </div>
            <span style="font-size: 0.82rem; font-weight: 700; color: var(--ink-500); background: var(--ink-100); padding: 4px 12px; border-radius: var(--r-full);">
                ${activeDeliveries.size()} Pending Action
            </span>
        </div>

        <c:choose>
            <c:when test="${empty activeDeliveries}">
                <div style="background: var(--ink-0); border-radius: var(--r-2xl); border: 2px dashed var(--ink-200); padding: 60px 24px; text-align: center; box-shadow: var(--shadow-xs);">
                    <div style="width: 72px; height: 72px; border-radius: 50%; background: var(--ink-50); color: var(--ink-300); display: flex; align-items: center; justify-content: center; font-size: 2.2rem; margin: 0 auto 16px;">
                        <i class="fa-solid fa-motorcycle"></i>
                    </div>
                    <h3 style="font-size: 1.25rem; font-family: var(--font-display); font-weight: 800; color: var(--ink-900); margin: 0;">
                        No Active Trips Assigned
                    </h3>
                    <p style="color: var(--ink-400); max-width: 440px; margin: 8px auto 0; font-size: 0.9rem; line-height: 1.5;">
                        You're all clear! New orders assigned by central dispatch will appear here immediately with turn-by-turn details.
                    </p>
                </div>
            </c:when>
            <c:otherwise>
                <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(430px, 1fr)); gap: 28px;">
                    <c:forEach items="${activeDeliveries}" var="ord">
                        <div class="dispatch-order-card">
                            
                            <!-- 1. Card Brand Header -->
                            <div class="dispatch-header">
                                <div style="display: flex; align-items: center; gap: 12px;">
                                    <div class="dispatch-order-num">
                                        #FZ-<span>${ord.orderId}</span>
                                    </div>
                                    <span class="dispatch-time-pill">
                                        <i class="fa-regular fa-clock" style="margin-right: 4px;"></i>
                                        ${ord.formattedTime}
                                    </span>
                                </div>
                                <div>
                                    <c:choose>
                                        <c:when test="${ord.tripStage == 'ARRIVED'}">
                                            <span class="dispatch-badge dispatch-badge-arrived">
                                                <span class="pulse-dot-amber"></span> AT DOORSTEP
                                            </span>
                                        </c:when>
                                        <c:when test="${ord.tripStage == 'PICKED_UP'}">
                                            <span class="dispatch-badge dispatch-badge-enroute">
                                                <span class="pulse-dot-blue"></span> ON THE WAY
                                            </span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="dispatch-badge dispatch-badge-assigned">
                                                <span class="pulse-dot-green"></span> ORDER READY
                                            </span>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </div>

                            <!-- 2. Domino's / Uber 3-Step Pipeline Micro-Stepper -->
                            <div class="dispatch-stepper">
                                <div class="step-node ${ord.tripStage == 'PICKED_UP' or ord.tripStage == 'ARRIVED' ? 'step-done' : 'step-active'}">
                                    <div class="step-circle">
                                        <i class="fa-solid ${ord.tripStage == 'PICKED_UP' or ord.tripStage == 'ARRIVED' ? 'fa-check' : 'fa-bag-shopping'}"></i>
                                    </div>
                                    <span class="step-text">1. Kitchen Pickup</span>
                                </div>
                                <div class="step-connector ${ord.tripStage == 'PICKED_UP' or ord.tripStage == 'ARRIVED' ? 'connector-done' : ''}"></div>
                                <div class="step-node ${ord.tripStage == 'ARRIVED' ? 'step-done' : (ord.tripStage == 'PICKED_UP' ? 'step-active' : '')}">
                                    <div class="step-circle">
                                        <i class="fa-solid ${ord.tripStage == 'ARRIVED' ? 'fa-check' : 'fa-motorcycle'}"></i>
                                    </div>
                                    <span class="step-text">2. In Transit</span>
                                </div>
                                <div class="step-connector ${ord.tripStage == 'ARRIVED' ? 'connector-active' : ''}"></div>
                                <div class="step-node ${ord.tripStage == 'ARRIVED' ? 'step-active-arrived' : ''}">
                                    <div class="step-circle">
                                        <i class="fa-solid fa-key"></i>
                                    </div>
                                    <span class="step-text">3. Doorstep OTP</span>
                                </div>
                            </div>

                            <!-- 3. Stage Action Hero CTA (For Pickup & In-Transit) -->
                            <c:if test="${ord.tripStage == 'ASSIGNED' || empty ord.tripStage}">
                                <div style="padding: 14px 24px; background: #FFF7ED; border-bottom: 1px solid #FED7AA;">
                                    <form action="${pageContext.request.contextPath}/delivery" method="POST" style="margin: 0;">
                                        <input type="hidden" name="action" value="pickup">
                                        <input type="hidden" name="orderId" value="${ord.orderId}">
                                        <button type="submit" class="stage-cta-btn cta-pickup">
                                            <i class="fa-solid fa-bag-shopping"></i> 1. Confirm Kitchen Pickup & Start Ride
                                        </button>
                                    </form>
                                </div>
                            </c:if>

                            <c:if test="${ord.tripStage == 'PICKED_UP'}">
                                <div style="padding: 14px 24px; background: #EFF6FF; border-bottom: 1px solid #BFDBFE;">
                                    <form action="${pageContext.request.contextPath}/delivery" method="POST" style="margin: 0;">
                                        <input type="hidden" name="action" value="arrive">
                                        <input type="hidden" name="orderId" value="${ord.orderId}">
                                        <button type="submit" class="stage-cta-btn cta-arrive">
                                            <i class="fa-solid fa-location-dot"></i> 2. I Have Reached Customer Doorstep
                                        </button>
                                    </form>
                                </div>
                            </c:if>

                            <!-- 4. Card Body Content -->
                            <div class="dispatch-body">
                                
                                <!-- Customer Identity & Calling Shortcuts -->
                                <div class="customer-header-row">
                                    <div style="display: flex; align-items: center; gap: 12px;">
                                        <div class="customer-avatar">
                                            ${fn:substring(ord.customerName, 0, 1)}
                                        </div>
                                        <div>
                                            <div style="display: flex; align-items: center; gap: 8px;">
                                                <h4 style="font-size: 1.15rem; font-family: var(--font-display); font-weight: 800; color: var(--ink-900); margin: 0;">
                                                    ${ord.customerName}
                                                </h4>
                                                <span style="font-size: 0.7rem; padding: 2px 8px; border-radius: var(--r-full); background: #EEF2FF; color: #4338CA; font-weight: 800; text-transform: uppercase;">
                                                    ${ord.addressType != null ? ord.addressType : 'HOME'}
                                                </span>
                                            </div>
                                            <div style="font-size: 0.8rem; color: var(--ink-400); margin-top: 2px;">
                                                <i class="fa-solid fa-phone" style="font-size: 0.72rem; margin-right: 4px;"></i>${ord.contactPhone}
                                            </div>
                                        </div>
                                    </div>
                                    <div style="display: flex; gap: 6px;">
                                        <a href="tel:${ord.contactPhone}" class="btn btn-sm"
                                           style="background: #ECFDF5; color: #047857; border: 1.5px solid #A7F3D0; padding: 7px 14px; font-size: 0.82rem; border-radius: var(--r-full); font-weight: 800; box-shadow: 0 1px 3px rgba(0,0,0,0.05);"
                                           title="Call Customer Primary Phone">
                                            <i class="fa-solid fa-phone" style="margin-right: 4px;"></i> Call
                                        </a>
                                        <c:if test="${not empty ord.alternatePhone}">
                                            <a href="tel:${ord.alternatePhone}" class="btn btn-sm"
                                               style="background: #F8FAFC; color: var(--ink-700); border: 1px solid var(--ink-200); padding: 7px 10px; font-size: 0.82rem; border-radius: var(--r-full); font-weight: 700;"
                                               title="Alternate Phone">
                                                <i class="fa-solid fa-phone-volume"></i> Alt
                                            </a>
                                        </c:if>
                                    </div>
                                </div>

                                <!-- Destination & Turn-by-Turn Map Navigation -->
                                <div class="destination-box">
                                    <div style="display: flex; gap: 12px; align-items: flex-start;">
                                        <div style="width: 32px; height: 32px; border-radius: 50%; background: #FEE2E2; color: #DC2626; display: flex; align-items: center; justify-content: center; font-size: 0.95rem; flex-shrink: 0; margin-top: 2px;">
                                            <i class="fa-solid fa-location-dot"></i>
                                        </div>
                                        <div style="flex: 1;">
                                            <p class="destination-address">
                                                ${ord.deliveryAddress}
                                            </p>
                                            <c:if test="${not empty ord.landmark}">
                                                <div>
                                                    <span class="landmark-pill">
                                                        <i class="fa-solid fa-map-pin"></i> Landmark: ${ord.landmark}
                                                    </span>
                                                </div>
                                            </c:if>
                                            <div>
                                                <a href="https://maps.google.com/?q=${ord.deliveryAddress}" target="_blank" class="nav-map-btn">
                                                    <i class="fa-solid fa-diamond-turn-right"></i> Open Navigation Map &rarr;
                                                </a>
                                            </div>
                                        </div>
                                    </div>
                                </div>

                                <!-- Customer Doorstep Special Instructions -->
                                <c:if test="${not empty ord.deliveryInstructions}">
                                    <div class="customer-note-banner">
                                        <i class="fa-solid fa-bell-slash" style="font-size: 1.1rem; color: #D97706; flex-shrink: 0;"></i>
                                        <span>Customer Note: &ldquo;${ord.deliveryInstructions}&rdquo;</span>
                                    </div>
                                </c:if>

                                <!-- Financial Summary (Mode & Total Bill) -->
                                <div class="dispatch-payment-bar">
                                    <div>
                                        <span style="font-size: 0.7rem; color: var(--ink-400); text-transform: uppercase; font-weight: 800; letter-spacing: 0.06em;">Payment Mode</span>
                                        <p style="font-size: 0.95rem; font-weight: 800; color: var(--ink-900); margin: 3px 0 0 0;">
                                            <c:choose>
                                                <c:when test="${ord.paymentMethod == 'Cash on Delivery'}">
                                                    <span style="color: #059669; display: flex; align-items: center; gap: 6px;">
                                                        <i class="fa-solid fa-money-bill-wave"></i> Cash on Delivery
                                                    </span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span style="color: #2563EB; display: flex; align-items: center; gap: 6px;">
                                                        <i class="fa-solid fa-credit-card"></i> Prepaid Online
                                                    </span>
                                                </c:otherwise>
                                            </c:choose>
                                        </p>
                                    </div>
                                    <div style="text-align: right;">
                                        <span style="font-size: 0.7rem; color: var(--ink-400); text-transform: uppercase; font-weight: 800; letter-spacing: 0.06em;">Total Bill</span>
                                        <p style="font-size: 1.45rem; font-family: var(--font-display); font-weight: 900; color: var(--brand); margin: 3px 0 0 0; line-height: 1;">
                                            ₹<fmt:formatNumber value="${ord.totalAmount}" pattern="#,##0.00" />
                                        </p>
                                    </div>
                                </div>

                                <!-- COD Quick Change Assistant (If Cash on Delivery) -->
                                <c:if test="${ord.paymentMethod == 'Cash on Delivery'}">
                                    <div class="cod-calc-drawer">
                                        <div style="display: flex; justify-content: space-between; align-items: center;">
                                            <span style="font-size: 0.8rem; font-weight: 800; color: #166534; display: flex; align-items: center; gap: 6px;">
                                                <i class="fa-solid fa-coins"></i> COD Change Calculator
                                            </span>
                                            <span id="change-text-${ord.orderId}" style="font-size: 0.85rem; font-weight: 800; color: #047857; background: #DCFCE7; padding: 2px 10px; border-radius: var(--r-full);">
                                                Return: ₹0.00
                                            </span>
                                        </div>
                                        
                                        <!-- Quick Presets -->
                                        <div style="display: flex; gap: 6px; margin: 10px 0; flex-wrap: wrap;">
                                            <span class="cod-calc-chip" onclick="setCodPreset(${ord.totalAmount}, ${ord.totalAmount}, 'change-text-${ord.orderId}', 'cash-hidden-${ord.orderId}', 'cash-input-${ord.orderId}')">Exact</span>
                                            <span class="cod-calc-chip" onclick="setCodPreset(500, ${ord.totalAmount}, 'change-text-${ord.orderId}', 'cash-hidden-${ord.orderId}', 'cash-input-${ord.orderId}')">₹500</span>
                                            <span class="cod-calc-chip" onclick="setCodPreset(600, ${ord.totalAmount}, 'change-text-${ord.orderId}', 'cash-hidden-${ord.orderId}', 'cash-input-${ord.orderId}')">₹600</span>
                                            <span class="cod-calc-chip" onclick="setCodPreset(1000, ${ord.totalAmount}, 'change-text-${ord.orderId}', 'cash-hidden-${ord.orderId}', 'cash-input-${ord.orderId}')">₹1000</span>
                                        </div>

                                        <div style="display: flex; gap: 8px; align-items: center;">
                                            <span style="font-size: 0.82rem; color: #166534; font-weight: 700;">Cash Received: ₹</span>
                                            <input type="number" id="cash-input-${ord.orderId}" step="any" placeholder="Enter cash"
                                                   style="padding: 6px 12px; font-size: 0.9rem; font-weight: 800; border: 1.5px solid #86EFAC; border-radius: 8px; width: 120px; outline: none; background: #FFFFFF; font-family: var(--font-display);"
                                                   oninput="calculateChange(this.value, ${ord.totalAmount}, 'change-text-${ord.orderId}', 'cash-hidden-${ord.orderId}')">
                                        </div>
                                    </div>
                                </c:if>

                                <!-- Package Item Checklist -->
                                <div style="padding: 2px 0;">
                                    <span style="font-size: 0.72rem; color: var(--ink-400); text-transform: uppercase; font-weight: 800; letter-spacing: 0.05em;">Package Checklist</span>
                                    <ul style="list-style: none; margin: 8px 0 0 0; padding: 0; display: flex; flex-direction: column; gap: 6px;">
                                        <c:forEach items="${ord.items}" var="it">
                                            <li style="font-size: 0.88rem; color: var(--ink-800); display: flex; justify-content: space-between; padding: 4px 0; border-bottom: 1px dashed var(--ink-100);">
                                                <span><strong style="color: var(--brand); font-weight: 800;">${it.quantity}x</strong> ${it.foodName}</span>
                                                <span style="font-weight: 700; color: var(--ink-700);">₹<fmt:formatNumber value="${it.subtotal}" pattern="#,##0.00" /></span>
                                            </li>
                                        </c:forEach>
                                    </ul>
                                </div>

                                <!-- Doorstep Secret OTP Verification Card -->
                                <div class="otp-container">
                                    <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 12px;">
                                        <label style="font-size: 0.9rem; font-weight: 800; color: #92400E; display: flex; align-items: center; gap: 8px; margin: 0; font-family: var(--font-display);">
                                            <i class="fa-solid fa-key" style="color: #D97706;"></i> Customer Doorstep OTP Handshake
                                        </label>
                                        <span style="font-size: 0.72rem; color: #B45309; font-weight: 700; background: #FEF3C7; padding: 2px 8px; border-radius: var(--r-full);">
                                            4-Digit PIN
                                        </span>
                                    </div>

                                    <form action="${pageContext.request.contextPath}/delivery" method="POST">
                                        <input type="hidden" name="action" value="verify-delivery">
                                        <input type="hidden" name="orderId" value="${ord.orderId}">
                                        <input type="hidden" name="cashReceived" id="cash-hidden-${ord.orderId}" value="${ord.totalAmount}">
                                        <input type="hidden" name="deliveryOtp" id="combined-otp-${ord.orderId}" required>

                                        <!-- 4 Segmented OTP Digit Boxes (No autofocus to avoid scrolling down!) -->
                                        <div class="otp-input-group">
                                            <input type="text" class="otp-cell" maxlength="1" pattern="[0-9]" inputmode="numeric" required>
                                            <input type="text" class="otp-cell" maxlength="1" pattern="[0-9]" inputmode="numeric" required>
                                            <input type="text" class="otp-cell" maxlength="1" pattern="[0-9]" inputmode="numeric" required>
                                            <input type="text" class="otp-cell" maxlength="1" pattern="[0-9]" inputmode="numeric" required>
                                        </div>

                                        <input type="text" name="deliveryNote" placeholder="Delivery Note (e.g. Handed to customer / Left at door)" class="form-control"
                                               style="font-size: 0.84rem; padding: 9px 14px; background: #FFFFFF; border: 1.5px solid #FCD34D; border-radius: 12px; margin-bottom: 12px;">

                                        <button type="submit" class="stage-cta-btn cta-verify">
                                            <i class="fa-solid fa-circle-check"></i> Verify OTP & Complete Delivery
                                        </button>
                                    </form>
                                </div>

                            </div>
                        </div>
                    </c:forEach>
                </div>
            </c:otherwise>
        </c:choose>
    </div>

    <!-- ════════════════════ 3. COMPLETED DELIVERIES HISTORY ════════════════════ -->
    <div>
        <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 16px;">
            <div style="display: flex; align-items: center; gap: 8px;">
                <i class="fa-solid fa-clock-rotate-left" style="color: var(--ink-400); font-size: 1.1rem;"></i>
                <h3 style="font-size: 1.25rem; font-family: var(--font-display); font-weight: 800; color: var(--ink-900); margin: 0;">
                    Shift Completed Deliveries
                </h3>
            </div>
            <span style="font-size: 0.82rem; font-weight: 700; color: var(--ink-500); background: var(--ink-100); padding: 4px 12px; border-radius: var(--r-full);">
                ${completedDeliveries.size()} Orders
            </span>
        </div>
        
        <div class="table-responsive">
            <table class="data-table">
                <thead>
                    <tr>
                        <th>Order #</th>
                        <th>Customer</th>
                        <th>Delivered Address</th>
                        <th>Amount</th>
                        <th>Payment Mode</th>
                        <th>Delivery Handshake Note</th>
                        <th>Status</th>
                    </tr>
                </thead>
                <tbody>
                    <c:choose>
                        <c:when test="${empty completedDeliveries}">
                            <tr>
                                <td colspan="7" style="padding: 40px 20px; text-align: center; color: var(--ink-400);">
                                    <i class="fa-solid fa-inbox" style="font-size: 2rem; color: var(--ink-200); margin-bottom: 8px; display: block;"></i>
                                    No completed deliveries recorded yet for this shift.
                                </td>
                            </tr>
                        </c:when>
                        <c:otherwise>
                            <c:forEach items="${completedDeliveries}" var="co">
                                <tr>
                                    <td style="font-weight: 800; color: var(--brand); font-family: var(--font-display);">#FZ-${co.orderId}</td>
                                    <td style="font-weight: 700; color: var(--ink-900);">${co.customerName}</td>
                                    <td style="color: var(--ink-600); max-width: 250px; overflow: hidden; text-overflow: ellipsis; white-space: nowrap;">
                                        ${co.deliveryAddress}
                                    </td>
                                    <td style="font-weight: 800; font-family: var(--font-display); color: var(--ink-900);">₹<fmt:formatNumber value="${co.totalAmount}" pattern="#,##0.00" /></td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${co.paymentMethod == 'Cash on Delivery'}">
                                                <span style="font-size: 0.82rem; font-weight: 700; color: #047857; background: #ECFDF5; padding: 2px 8px; border-radius: 4px;">
                                                    <i class="fa-solid fa-coins"></i> COD
                                                </span>
                                            </c:when>
                                            <c:otherwise>
                                                <span style="font-size: 0.82rem; font-weight: 700; color: #1E40AF; background: #EFF6FF; padding: 2px 8px; border-radius: 4px;">
                                                    <i class="fa-solid fa-credit-card"></i> Prepaid
                                                </span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td style="font-size: 0.85rem; color: var(--ink-500);">${not empty co.deliveryNote ? co.deliveryNote : '-'}</td>
                                    <td>
                                        <span class="badge badge-completed"><i class="fa-solid fa-check"></i> DELIVERED</span>
                                    </td>
                                </tr>
                            </c:forEach>
                        </c:otherwise>
                    </c:choose>
                </tbody>
            </table>
        </div>
    </div>

    <c:if test="${rider.isOnDuty && !hasActiveDelivery}">
        <script>
            // Automated real-time polling every 6 seconds to fetch newly placed orders dynamically
            (function() {
                var initialOpenCount = ${availableOrders.size()};
                setInterval(function() {
                    fetch('${pageContext.request.contextPath}/delivery/dashboard?ajax=poll', {
                        headers: { 'Accept': 'application/json' }
                    })
                    .then(function(res) { return res.json(); })
                    .then(function(data) {
                        if (data && data.success) {
                            if (data.availableCount !== initialOpenCount || data.hasActiveDelivery || !data.isOnDuty) {
                                window.location.reload();
                            }
                        }
                    })
                    .catch(function(err) { /* silent poll error handling */ });
                }, 6000);
            })();
        </script>
    </c:if>
</main>

<jsp:include page="/WEB-INF/views/common/footer.jsp" />
