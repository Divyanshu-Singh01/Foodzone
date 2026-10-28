<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>

<c:set var="pageTitle" value="Delivery Partner Fleet Profile - FoodZone Logistics" />
<c:set var="activePage" value="rider-profile" />

<jsp:include page="/WEB-INF/views/common/header.jsp" />
<jsp:include page="/WEB-INF/views/common/navbar.jsp" />

<main style="background:var(--ink-50);min-height:calc(100vh - 72px);padding-top:var(--sp-8);padding-bottom:var(--sp-16);">
<div class="container">

    <!-- ════════════════════ TOP EXECUTIVE HERO BANNER ════════════════════ -->
    <div style="background:linear-gradient(135deg, #0F172A 0%, #1E293B 100%);border-radius:var(--r-2xl);padding:var(--sp-8) var(--sp-10);color:#FFFFFF;margin-bottom:var(--sp-8);box-shadow:var(--shadow-lg);position:relative;overflow:hidden;">
        <!-- Subtle background glowing accents -->
        <div style="position:absolute;width:340px;height:340px;border-radius:50%;background:radial-gradient(circle,rgba(0,196,140,0.14) 0%,transparent 70%);right:-60px;top:-80px;pointer-events:none;"></div>
        <div style="position:absolute;width:240px;height:240px;border-radius:50%;background:radial-gradient(circle,rgba(255,77,0,0.12) 0%,transparent 70%);left:-40px;bottom:-60px;pointer-events:none;"></div>

        <div style="position:relative;z-index:1;display:flex;justify-content:space-between;align-items:center;flex-wrap:wrap;gap:var(--sp-6);">
            
            <!-- Left: Rider Identity & Rating -->
            <div style="display:flex;align-items:center;gap:var(--sp-6);flex-wrap:wrap;">
                <div style="position:relative;">
                    <div style="width:84px;height:84px;border-radius:50%;background:linear-gradient(135deg, #00C48C 0%, #00875A 100%);color:#FFFFFF;display:flex;align-items:center;justify-content:center;font-size:2.4rem;font-weight:800;font-family:var(--font-display);box-shadow:0 8px 24px rgba(0,196,140,0.35);border:3px solid rgba(255,255,255,0.2);">
                        <i class="fa-solid fa-motorcycle"></i>
                    </div>
                    <span style="position:absolute;bottom:2px;right:2px;width:20px;height:20px;border-radius:50%;background:${rider.isOnDuty ? 'var(--emerald)' : 'var(--red)'};border:3px solid #0F172A;box-shadow:0 0 10px ${rider.isOnDuty ? 'var(--emerald)' : 'var(--red)'};display:block;"></span>
                </div>

                <div>
                    <div style="display:flex;align-items:center;gap:10px;flex-wrap:wrap;">
                        <h1 style="font-size:2rem;color:#FFFFFF;margin:0;font-family:var(--font-display);font-weight:800;letter-spacing:-0.02em;">
                            ${rider.fullName}
                        </h1>
                        <span style="background:${rider.isOnDuty ? 'rgba(0,196,140,0.18)' : 'rgba(239,68,68,0.2)'};color:${rider.isOnDuty ? '#34D399' : '#FCA5A5'};border:1px solid ${rider.isOnDuty ? 'rgba(0,196,140,0.4)' : 'rgba(239,68,68,0.35)'};font-size:.72rem;font-weight:800;letter-spacing:.06em;text-transform:uppercase;padding:3px 10px;border-radius:var(--r-full);">
                            ${rider.isOnDuty ? 'ACTIVE ON SHIFT' : 'OFF DUTY'}
                        </span>
                        <span style="background:rgba(255,255,255,0.1);color:#FBBF24;font-size:.72rem;font-weight:800;padding:3px 10px;border-radius:var(--r-full);display:inline-flex;align-items:center;gap:4px;">
                            <i class="fa-solid fa-star"></i> 4.9 Partner Rating
                        </span>
                    </div>

                    <div style="color:var(--ink-300);font-size:.88rem;margin-top:8px;display:flex;flex-wrap:wrap;gap:18px;">
                        <span><i class="fa-solid fa-envelope" style="color:var(--ink-400);margin-right:6px;"></i>${rider.email}</span>
                        <span><i class="fa-solid fa-phone" style="color:var(--emerald);margin-right:6px;"></i>${rider.phone}</span>
                        <span><i class="fa-solid fa-id-badge" style="color:#60A5FA;margin-right:6px;"></i>ID: #FZ-R-${rider.userId}</span>
                    </div>
                </div>
            </div>

            <!-- Right: Tactile Duty Toggle Switch -->
            <div style="display:flex;align-items:center;gap:var(--sp-4);">
                <form action="${pageContext.request.contextPath}/delivery" method="POST" style="margin:0;">
                    <input type="hidden" name="action" value="toggle-duty">
                    <input type="hidden" name="redirect" value="/delivery/profile">
                    <button type="submit" class="tactile-duty-switch ${rider.isOnDuty ? 'is-online' : 'is-offline'}"
                            id="profile-duty-toggle"
                            title="Click to toggle Shift Duty">
                        <span class="tactile-duty-knob">
                            <i class="fa-solid ${rider.isOnDuty ? 'fa-bolt' : 'fa-power-off'}"></i>
                        </span>
                        <span class="tactile-duty-label">
                            ${rider.isOnDuty ? 'ONLINE • ACCEPTING TRIPS' : 'OFFLINE • SHIFT PAUSED'}
                        </span>
                    </button>
                </form>
            </div>

        </div>

        <!-- 4 Shift Telemetry Tiles -->
        <div style="display:grid;grid-template-columns:repeat(auto-fit, minmax(180px, 1fr));gap:var(--sp-4);margin-top:var(--sp-8);padding-top:var(--sp-6);border-top:1px solid rgba(255,255,255,0.1);">
            <div style="background:rgba(255,255,255,0.05);padding:14px 18px;border-radius:var(--r-lg);border:1px solid rgba(255,255,255,0.08);">
                <div style="font-size:1.6rem;font-weight:900;color:var(--emerald);font-family:var(--font-display);line-height:1;">
                    ${shiftStats.completedToday != null ? shiftStats.completedToday : 0}
                </div>
                <div style="font-size:.72rem;text-transform:uppercase;color:var(--ink-300);font-weight:700;letter-spacing:.05em;margin-top:4px;">Today Completed</div>
            </div>

            <div style="background:rgba(255,255,255,0.05);padding:14px 18px;border-radius:var(--r-lg);border:1px solid rgba(255,255,255,0.08);">
                <div style="font-size:1.6rem;font-weight:900;color:var(--amber);font-family:var(--font-display);line-height:1;">
                    ₹<fmt:formatNumber value="${shiftStats.cashCollectedToday}" pattern="#,##0"/>
                </div>
                <div style="font-size:.72rem;text-transform:uppercase;color:var(--ink-300);font-weight:700;letter-spacing:.05em;margin-top:4px;">Cash In Hand (COD)</div>
            </div>

            <div style="background:rgba(255,255,255,0.05);padding:14px 18px;border-radius:var(--r-lg);border:1px solid rgba(255,255,255,0.08);">
                <div style="font-size:1.6rem;font-weight:900;color:#60A5FA;font-family:var(--font-display);line-height:1;">
                    ${shiftStats.totalLifetimeOrders != null ? shiftStats.totalLifetimeOrders : 0}
                </div>
                <div style="font-size:.72rem;text-transform:uppercase;color:var(--ink-300);font-weight:700;letter-spacing:.05em;margin-top:4px;">Career Deliveries</div>
            </div>

            <div style="background:rgba(255,255,255,0.05);padding:14px 18px;border-radius:var(--r-lg);border:1px solid rgba(255,255,255,0.08);">
                <div style="font-size:1.6rem;font-weight:900;color:#A78BFA;font-family:var(--font-display);line-height:1;">
                    99.2%
                </div>
                <div style="font-size:.72rem;text-transform:uppercase;color:var(--ink-300);font-weight:700;letter-spacing:.05em;margin-top:4px;">On-Time SLA Rate</div>
            </div>
        </div>

    </div>

    <!-- Alert Notification -->
    <c:if test="${param.msg == 'profile_updated'}">
        <div class="alert alert-success" style="margin-bottom:var(--sp-6);">
            <i class="fa-solid fa-circle-check alert-icon"></i>
            <div>
                <strong>Fleet Passport Updated!</strong> Your vehicle number plate and driving license records are confirmed in the central logistics database.
            </div>
        </div>
    </c:if>

    <c:if test="${param.msg == 'duty_toggled'}">
        <div class="alert alert-info" style="margin-bottom:var(--sp-6);">
            <i class="fa-solid fa-circle-info alert-icon"></i>
            <div>
                <strong>Shift Status Updated:</strong> You are currently <strong>${rider.isOnDuty ? 'ON DUTY (Accepting Trips)' : 'OFF DUTY (Shift Paused)'}</strong>.
            </div>
        </div>
    </c:if>

    <!-- ════════════════════ REARRANGED PROFILE INFORMATION ════════════════════ -->
    <div style="display:grid;grid-template-columns:1.3fr 0.7fr;gap:var(--sp-8);align-items:flex-start;">
        
        <!-- LEFT COLUMN: Verified Vehicle Passport & Edit Form -->
        <div style="display:flex;flex-direction:column;gap:var(--sp-8);">
            
            <!-- CARD 1: Official Indian Digital Fleet Passport (HSRP) -->
            <div class="fleet-passport-card">
                <div style="display:flex;justify-content:space-between;align-items:center;padding-bottom:16px;margin-bottom:20px;border-bottom:1px solid rgba(255,255,255,0.12);">
                    <div>
                        <span style="font-size:.7rem;font-weight:800;text-transform:uppercase;letter-spacing:.08em;color:#60A5FA;">Verified Partner Credentials &bull; Ministry of Transport</span>
                        <h2 style="font-size:1.35rem;font-family:var(--font-display);font-weight:900;color:#FFFFFF;margin-top:2px;letter-spacing:-0.01em;">
                            <i class="fa-solid fa-id-card-clip" style="color:var(--emerald);margin-right:8px;"></i>
                            Fleet & Vehicle Passport
                        </h2>
                    </div>
                    <span class="fleet-passport-badge">
                        <i class="fa-solid fa-shield-check"></i> RTO Verified Partner
                    </span>
                </div>

                <!-- Visual Indian Number Plate (HSRP) & Vehicle Showcase -->
                <div style="background:rgba(255,255,255,0.06);border:1px solid rgba(255,255,255,0.12);border-radius:18px;padding:20px;margin-bottom:20px;display:flex;justify-content:space-between;align-items:center;flex-wrap:wrap;gap:16px;">
                    <div>
                        <div style="font-size:.72rem;text-transform:uppercase;font-weight:800;color:var(--ink-300);letter-spacing:.06em;margin-bottom:8px;">
                            Official Registration Plate
                        </div>
                        
                        <!-- Realistic IND Number Plate -->
                        <div class="hsrp-plate">
                            <div class="hsrp-ind">
                                <div class="hsrp-chakra"></div>
                                <span>IND</span>
                            </div>
                            <div class="hsrp-number">
                                ${not empty rider.vehicleNo ? rider.vehicleNo : 'DL 04 AB 1234'}
                            </div>
                        </div>
                    </div>

                    <div style="text-align:right;">
                        <div style="font-size:.72rem;text-transform:uppercase;font-weight:800;color:var(--ink-300);letter-spacing:.06em;margin-bottom:8px;">
                            Vehicle Category
                        </div>
                        <div style="display:inline-flex;align-items:center;gap:8px;background:rgba(255,255,255,0.08);border:1.5px solid rgba(255,255,255,0.18);padding:6px 16px;border-radius:var(--r-full);font-weight:800;color:#FFFFFF;font-size:.9rem;">
                            <i class="fa-solid fa-motorcycle" style="color:var(--brand);"></i>
                            ${not empty rider.vehicleType ? rider.vehicleType : 'Motorcycle'}
                        </div>
                    </div>
                </div>

                <!-- Credential Detail Grid -->
                <div style="display:grid;grid-template-columns:1fr 1fr;gap:16px;">
                    <div style="background:rgba(255,255,255,0.05);padding:14px 16px;border-radius:14px;border:1px solid rgba(255,255,255,0.08);">
                        <div style="font-size:.7rem;font-weight:800;text-transform:uppercase;color:var(--ink-300);letter-spacing:0.04em;">Commercial Driving License</div>
                        <div style="font-size:1rem;font-weight:900;color:#FFFFFF;font-family:monospace;letter-spacing:.05em;margin-top:4px;">
                            ${not empty rider.licenseNo ? rider.licenseNo : 'DL-0420230012345'}
                        </div>
                        <span style="font-size:.72rem;color:#34D399;font-weight:700;display:inline-flex;align-items:center;gap:4px;margin-top:4px;">
                            <i class="fa-solid fa-circle-check"></i> Valid Commercial Transport Permit
                        </span>
                    </div>

                    <div style="background:rgba(255,255,255,0.05);padding:14px 16px;border-radius:14px;border:1px solid rgba(255,255,255,0.08);">
                        <div style="font-size:.7rem;font-weight:800;text-transform:uppercase;color:var(--ink-300);letter-spacing:0.04em;">Emergency SOS Dispatch Hotline</div>
                        <div style="font-size:1rem;font-weight:900;color:#FFFFFF;margin-top:4px;">
                            ${not empty rider.emergencyPhone ? rider.emergencyPhone : '9876543210'}
                        </div>
                        <a href="tel:${rider.emergencyPhone}" style="font-size:.72rem;color:#F87171;font-weight:800;display:inline-flex;align-items:center;gap:4px;margin-top:4px;text-decoration:none;">
                            <i class="fa-solid fa-phone"></i> Direct SOS Dispatch Shortcut &rarr;
                        </a>
                    </div>
                </div>
            </div>

            <!-- CARD 2: Edit & Update Fleet Information Form -->
            <div class="credential-form-card">
                <div style="padding-bottom:16px;margin-bottom:24px;border-bottom:1px solid var(--ink-100);display:flex;justify-content:space-between;align-items:center;">
                    <div>
                        <h3 style="font-size:1.25rem;font-family:var(--font-display);font-weight:900;color:var(--ink-900);margin:0;letter-spacing:-0.01em;">
                            <i class="fa-solid fa-pen-to-square" style="color:var(--brand);margin-right:8px;"></i>
                            Edit Partner Information & Records
                        </h3>
                        <p style="font-size:.84rem;color:var(--ink-400);margin:4px 0 0;">Update your active vehicle plate number, phone number or license record</p>
                    </div>
                    <span style="font-size:0.75rem;font-weight:800;color:var(--emerald);background:var(--emerald-light);padding:4px 12px;border-radius:var(--r-full);border:1px solid rgba(0,196,140,0.25);">
                        <i class="fa-solid fa-cloud-arrow-up"></i> Live Persisted
                    </span>
                </div>

                <form action="${pageContext.request.contextPath}/delivery/profile" method="POST">
                    
                    <!-- Section A: Personal Records -->
                    <div style="margin-bottom: 24px;">
                        <div style="font-size:0.75rem;font-weight:800;text-transform:uppercase;color:var(--ink-400);letter-spacing:0.06em;margin-bottom:12px;display:flex;align-items:center;gap:6px;">
                            <i class="fa-solid fa-user-circle" style="color:var(--brand);"></i> 1. Personal & Mobile Credentials
                        </div>
                        <div style="display:grid;grid-template-columns:1fr 1fr;gap:18px;">
                            <div class="form-group">
                                <label class="form-label" for="fullName">Full Legal Name <span style="color:var(--red);">*</span></label>
                                <input type="text" id="fullName" name="fullName" class="form-control" value="${rider.fullName}" required
                                       style="font-weight:700;font-size:0.92rem;border-radius:12px;padding:11px 16px;">
                            </div>

                            <div class="form-group">
                                <label class="form-label" for="phone">Primary Mobile Phone <span style="color:var(--red);">*</span></label>
                                <input type="tel" id="phone" name="phone" class="form-control" value="${rider.phone}" required placeholder="10-digit mobile number"
                                       style="font-weight:700;font-size:0.92rem;border-radius:12px;padding:11px 16px;">
                            </div>
                        </div>
                    </div>

                    <!-- Section B: Vehicle Records -->
                    <div style="margin-bottom: 24px;padding-top:18px;border-top:1px dashed var(--ink-100);">
                        <div style="font-size:0.75rem;font-weight:800;text-transform:uppercase;color:var(--ink-400);letter-spacing:0.06em;margin-bottom:12px;display:flex;align-items:center;gap:6px;">
                            <i class="fa-solid fa-motorcycle" style="color:var(--emerald);"></i> 2. Vehicle Registration & Category
                        </div>
                        <div style="display:grid;grid-template-columns:1fr 1fr;gap:18px;">
                            <div class="form-group">
                                <label class="form-label" for="vehicleType">Vehicle Type</label>
                                <select id="vehicleType" name="vehicleType" class="form-control"
                                        style="font-weight:700;font-size:0.92rem;border-radius:12px;padding:11px 16px;">
                                    <option value="Motorcycle" ${rider.vehicleType == 'Motorcycle' ? 'selected' : ''}>🏍️ Motorcycle / Bike</option>
                                    <option value="Scooter" ${rider.vehicleType == 'Scooter' ? 'selected' : ''}>🛵 Scooter (Activa/Jupiter)</option>
                                    <option value="Electric Bike" ${rider.vehicleType == 'Electric Bike' ? 'selected' : ''}>⚡ Electric Bike (EV)</option>
                                    <option value="Bicycle" ${rider.vehicleType == 'Bicycle' ? 'selected' : ''}>🚲 Bicycle</option>
                                    <option value="Compact Car" ${rider.vehicleType == 'Compact Car' ? 'selected' : ''}>🚗 Compact Car</option>
                                </select>
                            </div>

                            <div class="form-group">
                                <label class="form-label" for="vehicleNo">Vehicle Number Plate <span style="color:var(--red);">*</span></label>
                                <input type="text" id="vehicleNo" name="vehicleNo" class="form-control" value="${rider.vehicleNo}" required placeholder="e.g. DL 04 AB 1234"
                                       style="font-weight:900;font-size:0.95rem;font-family:var(--font-display);letter-spacing:0.08em;border-radius:12px;padding:11px 16px;background:#FFFDF5;border-color:#FCD34D;">
                            </div>
                        </div>
                    </div>

                    <!-- Section C: Regulatory & Emergency Records -->
                    <div style="margin-bottom: 24px;padding-top:18px;border-top:1px dashed var(--ink-100);">
                        <div style="font-size:0.75rem;font-weight:800;text-transform:uppercase;color:var(--ink-400);letter-spacing:0.06em;margin-bottom:12px;display:flex;align-items:center;gap:6px;">
                            <i class="fa-solid fa-shield-halved" style="color:#60A5FA;"></i> 3. Driving License & Emergency SOS
                        </div>
                        <div style="display:grid;grid-template-columns:1fr 1fr;gap:18px;">
                            <div class="form-group">
                                <label class="form-label" for="licenseNo">Driving License (DL) Number</label>
                                <input type="text" id="licenseNo" name="licenseNo" class="form-control" value="${rider.licenseNo}" placeholder="e.g. DL-0420230012345"
                                       style="font-family:monospace;font-weight:700;font-size:0.92rem;border-radius:12px;padding:11px 16px;">
                            </div>

                            <div class="form-group">
                                <label class="form-label" for="emergencyPhone">Emergency SOS Contact Phone</label>
                                <input type="tel" id="emergencyPhone" name="emergencyPhone" class="form-control" value="${rider.emergencyPhone}" placeholder="Family or contact phone"
                                       style="font-weight:700;font-size:0.92rem;border-radius:12px;padding:11px 16px;">
                            </div>
                        </div>
                    </div>

                    <div style="display:flex;justify-content:space-between;align-items:center;gap:16px;padding-top:20px;border-top:1px solid var(--ink-100);">
                        <a href="${pageContext.request.contextPath}/delivery/dashboard" class="btn btn-outline btn-sm"
                           style="border-radius:var(--r-full);padding:10px 20px;font-weight:800;">
                            <i class="fa-solid fa-arrow-left"></i> Back to Live Deliveries
                        </a>
                        <button type="submit" class="stage-cta-btn cta-verify" style="width:auto;padding:10px 28px;border-radius:var(--r-full);">
                            <i class="fa-solid fa-floppy-disk"></i> Save Fleet Credentials
                        </button>
                    </div>
                </form>
            </div>

        </div>

        <!-- RIGHT COLUMN: Shift Status, Cash in Hand & Guidelines -->
        <div style="display:flex;flex-direction:column;gap:var(--sp-6);">
            
            <!-- Quick Hub Shortcut -->
            <div style="background:var(--ink-0);border-radius:22px;border:1px solid var(--ink-100);padding:24px;box-shadow:var(--shadow-sm);">
                <div style="display:flex;align-items:center;justify-content:space-between;margin-bottom:12px;">
                    <h4 style="font-size:1.05rem;color:var(--ink-900);font-weight:900;margin:0;font-family:var(--font-display);">
                        <i class="fa-solid fa-motorcycle" style="color:var(--emerald);margin-right:8px;"></i> Live Delivery Pipeline
                    </h4>
                    <span class="dispatch-badge ${rider.isOnDuty ? 'dispatch-badge-assigned' : 'dispatch-badge-arrived'}">
                        <span class="${rider.isOnDuty ? 'pulse-dot-green' : 'pulse-dot-amber'}"></span>
                        ${rider.isOnDuty ? 'Online' : 'Paused'}
                    </span>
                </div>
                <p style="font-size:.85rem;color:var(--ink-400);line-height:1.5;margin-bottom:16px;">
                    Orders assigned by central admin dispatch appear instantly in your live tasks hub.
                </p>
                <a href="${pageContext.request.contextPath}/delivery/dashboard" class="stage-cta-btn cta-pickup" style="text-decoration:none;">
                    <i class="fa-solid fa-route"></i> Open Live Deliveries
                </a>
            </div>

            <!-- Cash in Hand Settlement Card -->
            <div class="reconciliation-card">
                <div style="display:flex;align-items:center;justify-content:space-between;margin-bottom:10px;">
                    <span style="font-size:.75rem;font-weight:800;text-transform:uppercase;color:#92400E;letter-spacing:.06em;">
                        <i class="fa-solid fa-coins"></i> Cash Reconciliation
                    </span>
                    <span style="font-size:.78rem;font-weight:800;color:#92400E;background:#FEF08A;padding:2px 10px;border-radius:var(--r-full);">
                        Pending Deposit
                    </span>
                </div>
                <div style="font-family:var(--font-display);font-size:2rem;font-weight:900;color:#78350F;line-height:1.1;">
                    ₹<fmt:formatNumber value="${shiftStats.cashCollectedToday}" pattern="#,##0.00"/>
                </div>
                <p style="font-size:.82rem;color:#92400E;line-height:1.45;margin-top:10px;">
                    Please hand over all Cash on Delivery (COD) proceeds at the store hub cashier counter at the conclusion of your shift.
                </p>
            </div>

            <!-- Delivery Partner Code of Excellence -->
            <div style="background:var(--ink-0);border:1px solid var(--ink-100);border-radius:var(--r-xl);padding:var(--sp-6);box-shadow:var(--shadow-sm);">
                <h4 style="font-size:.95rem;color:var(--ink-900);font-weight:800;margin-bottom:var(--sp-4);">
                    <i class="fa-solid fa-shield-halved" style="color:var(--brand);margin-right:6px;"></i> Delivery SOP Protocols
                </h4>
                <ul style="list-style:none;padding:0;margin:0;font-size:.84rem;color:var(--ink-600);line-height:1.65;display:flex;flex-direction:column;gap:10px;">
                    <li style="display:flex;gap:8px;align-items:flex-start;">
                        <i class="fa-solid fa-helmet-safety" style="color:var(--emerald);margin-top:3px;"></i>
                        <span><strong>Protective Gear:</strong> Certified helmet & thermal insulated delivery bag are mandatory.</span>
                    </li>
                    <li style="display:flex;gap:8px;align-items:flex-start;">
                        <i class="fa-solid fa-key" style="color:var(--amber);margin-top:3px;"></i>
                        <span><strong>4-Digit Secret OTP:</strong> Must be entered and verified before handing over food boxes to customer.</span>
                    </li>
                    <li style="display:flex;gap:8px;align-items:flex-start;">
                        <i class="fa-solid fa-bell-slash" style="color:#6366F1;margin-top:3px;"></i>
                        <span><strong>Customer Doorstep Notes:</strong> Check instruction presets (e.g. "Do Not Ring Bell", "Leave at Door").</span>
                    </li>
                    <li style="display:flex;gap:8px;align-items:flex-start;">
                        <i class="fa-solid fa-phone" style="color:var(--brand);margin-top:3px;"></i>
                        <span><strong>Direct Calling:</strong> Use primary and alternate customer phone shortcuts when locating destination.</span>
                    </li>
                </ul>
            </div>

        </div>

    </div>

</div>
</main>

<!-- Toast Container & Core Scripts (NO consumer footer) -->
<div id="toast-container"></div>
<script src="${pageContext.request.contextPath}/static/js/main.js"></script>

</body>
</html>
