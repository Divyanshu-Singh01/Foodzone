<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<c:set var="pageTitle" value="Become a Delivery Partner — FoodZone Fleet" />
<c:set var="activePage" value="rider-register" />

<jsp:include page="/WEB-INF/views/common/header.jsp" />

<style>
  body { overflow: hidden; background: #0B1120; }
  @media (max-width: 900px) { body { overflow: auto; } }

  .rider-auth-left {
    background: radial-gradient(circle at 80% 20%, rgba(16, 185, 129, 0.22) 0%, transparent 55%),
                radial-gradient(circle at 20% 80%, rgba(37, 99, 235, 0.16) 0%, transparent 55%),
                linear-gradient(145deg, #060D1A 0%, #0F172A 50%, #0A1120 100%);
    border-right: 1px solid rgba(255, 255, 255, 0.08);
    position: relative;
    padding: 60px 50px;
    display: flex;
    flex-direction: column;
    justify-content: space-between;
    color: #FFFFFF;
  }

  .vehicle-select-group {
    display: grid;
    grid-template-columns: repeat(4, 1fr);
    gap: 8px;
    margin-top: 6px;
  }
  .vehicle-option-chip {
    padding: 9px 8px;
    text-align: center;
    border: 1.5px solid var(--ink-200);
    border-radius: 12px;
    background: #FFFFFF;
    color: var(--ink-700);
    font-size: 0.8rem;
    font-weight: 700;
    cursor: pointer;
    transition: all 0.2s ease;
    display: flex;
    flex-direction: column;
    align-items: center;
    gap: 4px;
  }
  .vehicle-option-chip i { font-size: 1.1rem; }
  .vehicle-option-chip:hover {
    border-color: #10B981;
    color: #059669;
    background: #ECFDF5;
  }
  .vehicle-option-chip.selected {
    border-color: #059669;
    background: #059669;
    color: #FFFFFF;
    box-shadow: 0 4px 12px rgba(5, 150, 105, 0.28);
  }

  .live-hsrp-preview {
    margin-top: 8px;
    display: inline-flex;
    align-items: center;
    background: #FFFFFF;
    border: 2px solid #0F172A;
    border-radius: 6px;
    overflow: hidden;
    box-shadow: 0 2px 6px rgba(0,0,0,0.12);
  }
  .live-hsrp-ind {
    background: #003399;
    color: #FFFFFF;
    padding: 3px 5px;
    font-size: 0.55rem;
    font-weight: 900;
    line-height: 1;
    display: flex;
    flex-direction: column;
    align-items: center;
  }
  .live-hsrp-num {
    padding: 2px 10px;
    font-size: 0.88rem;
    color: #0F172A;
    font-weight: 900;
    letter-spacing: 0.1em;
    font-family: var(--font-display), monospace;
  }
</style>

<div class="auth-page">

    <!-- Left: Fleet Logistics Showcase Panel -->
    <div class="auth-left rider-auth-left">
        <div style="position: relative; z-index: 1;">
            
            <!-- Brand & Fleet Tag -->
            <div style="display: flex; align-items: center; justify-content: space-between; margin-bottom: 40px; flex-wrap: wrap; gap: 12px;">
                <a href="${pageContext.request.contextPath}/home" style="display: inline-flex; align-items: center; gap: 10px; text-decoration: none;">
                    <div class="logo-icon" style="width: 42px; height: 42px; font-size: 1.2rem; background: linear-gradient(135deg, #10B981, #059669);">
                        <i class="fa-solid fa-motorcycle"></i>
                    </div>
                    <span style="font-family: var(--font-display); font-size: 1.45rem; font-weight: 900; color: #FFFFFF; letter-spacing: -0.02em;">
                        Food<span style="color: var(--brand);">Zone</span> <span style="font-size: 0.82rem; color: #34D399; font-weight: 800; letter-spacing: 0.08em; text-transform: uppercase;">Fleet</span>
                    </span>
                </a>
                <span style="background: rgba(16, 185, 129, 0.15); color: #34D399; border: 1px solid rgba(16, 185, 129, 0.35); padding: 4px 12px; border-radius: var(--r-full); font-size: 0.72rem; font-weight: 800; letter-spacing: 0.06em; text-transform: uppercase;">
                    <i class="fa-solid fa-bolt"></i> Partner Onboarding
                </span>
            </div>

            <h2 style="font-family: var(--font-display); font-size: 2.3rem; color: #FFFFFF; font-weight: 900; line-height: 1.15; letter-spacing: -0.03em; margin: 0 0 16px 0;">
                Deliver with Pride.<br>
                <span style="background: linear-gradient(135deg, #34D399 0%, #10B981 100%); -webkit-background-clip: text; -webkit-text-fill-color: transparent;">Earn On Your Schedule.</span>
            </h2>
            <p style="color: var(--ink-300); font-size: 0.95rem; line-height: 1.65; max-width: 440px; margin-bottom: 32px;">
                Join the highest-rated delivery fleet in Sector 18 & NCR. Experience atomic first-accept dispatch, weekly guaranteed payouts, and zero multi-drop delivery chaos.
            </p>

            <!-- Value Propositions Grid -->
            <div style="display: flex; flex-direction: column; gap: 18px; margin-bottom: 36px;">
                <div style="display: flex; gap: 14px; align-items: flex-start;">
                    <div style="width: 34px; height: 34px; border-radius: 10px; background: rgba(16, 185, 129, 0.2); color: #34D399; display: flex; align-items: center; justify-content: center; font-size: 0.95rem; flex-shrink: 0; margin-top: 2px;">
                        <i class="fa-solid fa-bolt"></i>
                    </div>
                    <div>
                        <strong style="color: #FFFFFF; font-size: 0.92rem;">First-Accept Central Dispatch Radar</strong>
                        <p style="margin: 2px 0 0 0; color: var(--ink-300); font-size: 0.82rem; line-height: 1.4;">Live broadcasts sent directly to on-duty riders. The fastest partner to accept locks the order exclusively.</p>
                    </div>
                </div>

                <div style="display: flex; gap: 14px; align-items: flex-start;">
                    <div style="width: 34px; height: 34px; border-radius: 10px; background: rgba(251, 191, 36, 0.2); color: #FBBF24; display: flex; align-items: center; justify-content: center; font-size: 0.95rem; flex-shrink: 0; margin-top: 2px;">
                        <i class="fa-solid fa-shield-halved"></i>
                    </div>
                    <div>
                        <strong style="color: #FFFFFF; font-size: 0.92rem;">Strict 1-Order Safe Delivery Policy</strong>
                        <p style="margin: 2px 0 0 0; color: var(--ink-300); font-size: 0.82rem; line-height: 1.4;">You will only ever deliver 1 order at a time. No stress, no missed deadlines, high customer ratings.</p>
                    </div>
                </div>

                <div style="display: flex; gap: 14px; align-items: flex-start;">
                    <div style="width: 34px; height: 34px; border-radius: 10px; background: rgba(96, 165, 250, 0.2); color: #60A5FA; display: flex; align-items: center; justify-content: center; font-size: 0.95rem; flex-shrink: 0; margin-top: 2px;">
                        <i class="fa-solid fa-id-card-clip"></i>
                    </div>
                    <div>
                        <strong style="color: #FFFFFF; font-size: 0.92rem;">Digital Fleet Passport & HSRP Badging</strong>
                        <p style="margin: 2px 0 0 0; color: var(--ink-300); font-size: 0.82rem; line-height: 1.4;">Official government license and vehicle verification recorded on your digital partner credential.</p>
                    </div>
                </div>
            </div>

            <!-- Partner Telemetry Card -->
            <div style="background: rgba(255, 255, 255, 0.05); border: 1px solid rgba(255, 255, 255, 0.12); border-radius: 18px; padding: 18px 22px; backdrop-filter: blur(10px); display: flex; align-items: center; justify-content: space-between;">
                <div>
                    <span style="font-size: 0.7rem; color: var(--ink-300); text-transform: uppercase; font-weight: 800; letter-spacing: 0.06em;">Avg Monthly Payout</span>
                    <div style="font-family: var(--font-display); font-size: 1.4rem; font-weight: 900; color: #34D399;">₹25,000 - ₹35,000</div>
                </div>
                <div style="text-align: right;">
                    <span style="font-size: 0.7rem; color: var(--ink-300); text-transform: uppercase; font-weight: 800; letter-spacing: 0.06em;">Partner Rating</span>
                    <div style="font-family: var(--font-display); font-size: 1.15rem; font-weight: 900; color: #FBBF24;">
                        <i class="fa-solid fa-star"></i> 4.9 Elite
                    </div>
                </div>
            </div>

        </div>

        <div style="font-size: 0.78rem; color: var(--ink-400); margin-top: 28px;">
            FoodZone Fleet Network &bull; Ministry of Transport Compliant &bull; Sector 18 Central Hub
        </div>
    </div>

    <!-- Right: Driver Registration Form -->
    <div class="auth-right" style="overflow-y: auto; max-height: 100vh; padding: 40px 30px;">
        <div class="auth-form-box" style="max-width: 500px; padding: 0 10px;">
            
            <div style="margin-bottom: 24px;">
                <div style="display: inline-flex; align-items: center; gap: 6px; background: #ECFDF5; color: #047857; border: 1px solid #A7F3D0; font-size: 0.72rem; font-weight: 800; padding: 3px 10px; border-radius: var(--r-full); margin-bottom: 10px; text-transform: uppercase;">
                    <i class="fa-solid fa-circle-check"></i> Instant Shift Activation
                </div>
                <h1 class="auth-heading" style="font-size: 1.85rem; margin-bottom: 4px;">Join as a Delivery Partner</h1>
                <p class="auth-subtext" style="font-size: 0.88rem; margin: 0;">Fill in your personal and vehicle credentials to start delivering today.</p>
            </div>

            <c:if test="${not empty errorMessage}">
                <div class="alert alert-danger" style="margin-bottom: 20px; display: flex; align-items: center; gap: 10px; padding: 12px 16px; border-radius: var(--r-lg);">
                    <i class="fa-solid fa-triangle-exclamation alert-icon"></i>
                    <span style="font-size: 0.88rem;">${errorMessage}</span>
                </div>
            </c:if>

            <form action="${pageContext.request.contextPath}/rider-register" method="post" id="rider-register-form">
                
                <!-- ─── SECTION 1: PERSONAL IDENTITY ─── -->
                <div style="margin-bottom: 20px;">
                    <span style="font-size: 0.72rem; font-weight: 900; color: var(--ink-400); text-transform: uppercase; letter-spacing: 0.08em; display: block; margin-bottom: 10px;">
                        1. Personal Identity
                    </span>

                    <div class="form-group" style="margin-bottom: 14px;">
                        <label class="form-label" for="rider-name">Full Name (as per Driving License) <span style="color: var(--brand);">*</span></label>
                        <div class="input-icon-wrap">
                            <i class="fa-solid fa-user input-icon"></i>
                            <input type="text" id="rider-name" name="fullName" class="form-control"
                                   required placeholder="e.g. Vikram Singh"
                                   value="<c:out value='${fullName}'/>">
                        </div>
                    </div>

                    <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 12px;">
                        <div class="form-group" style="margin-bottom: 14px;">
                            <label class="form-label" for="rider-phone">Primary Mobile <span style="color: var(--brand);">*</span></label>
                            <div class="input-icon-wrap">
                                <i class="fa-solid fa-phone input-icon"></i>
                                <input type="tel" id="rider-phone" name="phone" class="form-control"
                                       required placeholder="10-digit number"
                                       value="<c:out value='${phone}'/>">
                            </div>
                        </div>

                        <div class="form-group" style="margin-bottom: 14px;">
                            <label class="form-label" for="rider-email">Email Address <span style="color: var(--brand);">*</span></label>
                            <div class="input-icon-wrap">
                                <i class="fa-regular fa-envelope input-icon"></i>
                                <input type="email" id="rider-email" name="email" class="form-control"
                                       required placeholder="rider@email.com"
                                       value="<c:out value='${email}'/>">
                            </div>
                        </div>
                    </div>

                    <div class="form-group" style="margin-bottom: 14px;">
                        <label class="form-label" for="rider-address">Base Operating Zone / Address <span style="color: var(--ink-400); font-weight: 500;">(optional)</span></label>
                        <div class="input-icon-wrap">
                            <i class="fa-solid fa-location-dot input-icon" style="top: 14px; transform: none;"></i>
                            <input type="text" id="rider-address" name="address" class="form-control"
                                   placeholder="e.g. Indirapuram / Sector 18 Hub, Noida"
                                   value="<c:out value='${address}'/>">
                        </div>
                    </div>
                </div>

                <!-- ─── SECTION 2: FLEET & VEHICLE CREDENTIALS ─── -->
                <div style="margin-bottom: 20px; padding-top: 14px; border-top: 1px dashed var(--ink-200);">
                    <span style="font-size: 0.72rem; font-weight: 900; color: #059669; text-transform: uppercase; letter-spacing: 0.08em; display: block; margin-bottom: 10px;">
                        2. Fleet & Vehicle Credentials
                    </span>

                    <!-- Vehicle Type Segmented Chips -->
                    <div class="form-group" style="margin-bottom: 14px;">
                        <label class="form-label">Delivery Vehicle Type <span style="color: var(--brand);">*</span></label>
                        <input type="hidden" name="vehicleType" id="selected-vehicle-type" value="${not empty vehicleType ? vehicleType : 'Motorcycle'}">
                        
                        <div class="vehicle-select-group">
                            <div class="vehicle-option-chip ${empty vehicleType or vehicleType == 'Motorcycle' ? 'selected' : ''}" onclick="selectVehicle('Motorcycle', this)">
                                <i class="fa-solid fa-motorcycle"></i>
                                <span>Motorcycle</span>
                            </div>
                            <div class="vehicle-option-chip ${vehicleType == 'Scooter' ? 'selected' : ''}" onclick="selectVehicle('Scooter', this)">
                                <i class="fa-solid fa-moped"></i>
                                <span>Scooter</span>
                            </div>
                            <div class="vehicle-option-chip ${vehicleType == 'EV Bike' ? 'selected' : ''}" onclick="selectVehicle('EV Bike', this)">
                                <i class="fa-solid fa-bolt"></i>
                                <span>EV Bike</span>
                            </div>
                            <div class="vehicle-option-chip ${vehicleType == 'Bicycle' ? 'selected' : ''}" onclick="selectVehicle('Bicycle', this)">
                                <i class="fa-solid fa-bicycle"></i>
                                <span>Bicycle</span>
                            </div>
                        </div>
                    </div>

                    <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 12px;">
                        <div class="form-group" style="margin-bottom: 14px;">
                            <label class="form-label" for="rider-vehicleno">Vehicle Number Plate <span style="color: var(--brand);">*</span></label>
                            <div class="input-icon-wrap">
                                <i class="fa-solid fa-hashtag input-icon"></i>
                                <input type="text" id="rider-vehicleno" name="vehicleNo" class="form-control"
                                       required placeholder="UP 14 AB 1234" style="text-transform: uppercase;"
                                       value="<c:out value='${vehicleNo}'/>"
                                       oninput="updatePlatePreview(this.value)">
                            </div>
                            <div class="live-hsrp-preview">
                                <span class="live-hsrp-ind">IND</span>
                                <span class="live-hsrp-num" id="live-plate-text">${not empty vehicleNo ? vehicleNo : 'UP 14 AB 1234'}</span>
                            </div>
                        </div>

                        <div class="form-group" style="margin-bottom: 14px;">
                            <label class="form-label" for="rider-license">Driving License (DL) <span style="color: var(--brand);">*</span></label>
                            <div class="input-icon-wrap">
                                <i class="fa-solid fa-id-card input-icon"></i>
                                <input type="text" id="rider-license" name="licenseNo" class="form-control"
                                       required placeholder="DL-0420230012345" style="text-transform: uppercase;"
                                       value="<c:out value='${licenseNo}'/>">
                            </div>
                            <span style="font-size: 0.72rem; color: var(--ink-400); margin-top: 4px; display: block;">MoRTH 15-digit DL format</span>
                        </div>
                    </div>

                    <div class="form-group" style="margin-bottom: 14px;">
                        <label class="form-label" for="rider-emergency">Emergency SOS Contact Phone <span style="color: var(--ink-400); font-weight: 500;">(optional)</span></label>
                        <div class="input-icon-wrap">
                            <i class="fa-solid fa-phone-volume input-icon"></i>
                            <input type="tel" id="rider-emergency" name="emergencyPhone" class="form-control"
                                   placeholder="Family or emergency contact number"
                                   value="<c:out value='${emergencyPhone}'/>">
                        </div>
                    </div>
                </div>

                <!-- ─── SECTION 3: PASSCODE SECURITY ─── -->
                <div style="margin-bottom: 24px; padding-top: 14px; border-top: 1px dashed var(--ink-200);">
                    <span style="font-size: 0.72rem; font-weight: 900; color: var(--ink-400); text-transform: uppercase; letter-spacing: 0.08em; display: block; margin-bottom: 10px;">
                        3. Passcode & Security
                    </span>

                    <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 12px;">
                        <div class="form-group" style="margin-bottom: 14px;">
                            <label class="form-label" for="rider-password">Account Password <span style="color: var(--brand);">*</span></label>
                            <div class="input-icon-wrap">
                                <i class="fa-solid fa-lock input-icon"></i>
                                <input type="password" id="rider-password" name="password"
                                       class="form-control" required placeholder="Min. 6 chars">
                            </div>
                        </div>
                        <div class="form-group" style="margin-bottom: 14px;">
                            <label class="form-label" for="rider-confirm">Confirm Password <span style="color: var(--brand);">*</span></label>
                            <div class="input-icon-wrap">
                                <i class="fa-solid fa-lock input-icon"></i>
                                <input type="password" id="rider-confirm" name="confirmPassword"
                                       class="form-control" required placeholder="Repeat password">
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Single Active Order Guarantee Notice -->
                <div style="background: #F0FDF4; border: 1.5px solid #86EFAC; border-radius: 14px; padding: 12px 16px; margin-bottom: 20px; display: flex; align-items: center; gap: 10px;">
                    <i class="fa-solid fa-shield-halved" style="color: #059669; font-size: 1.2rem; flex-shrink: 0;"></i>
                    <span style="font-size: 0.8rem; color: #166534; font-weight: 600; line-height: 1.4;">
                        <strong>FoodZone Single-Order Policy:</strong> You will only take 1 order to deliver at a time until completed. No simultaneous multiple orders.
                    </span>
                </div>

                <!-- Submit Button -->
                <button type="submit" class="btn btn-block" style="background: linear-gradient(135deg, #10B981 0%, #059669 100%); color: #FFFFFF; font-size: 1rem; font-weight: 900; padding: 14px; border-radius: 14px; border: none; box-shadow: 0 4px 16px rgba(16, 185, 129, 0.35); cursor: pointer;" id="submit-rider-register-btn">
                    <i class="fa-solid fa-bolt" style="margin-right: 6px;"></i> Register As Delivery Partner &rarr;
                </button>
            </form>

            <div class="divider-text" style="margin: 22px 0 16px;">Already a Delivery Partner?</div>

            <a href="${pageContext.request.contextPath}/login" class="btn btn-outline btn-block" style="border-color: var(--ink-200); color: var(--ink-700); font-weight: 700; padding: 12px; border-radius: 14px;">
                <i class="fa-solid fa-arrow-right-to-bracket"></i> Sign In to Rider Hub
            </a>

            <div style="text-align: center; margin-top: 16px; font-size: 0.82rem; color: var(--ink-400);">
                Looking to order food instead?
                <a href="${pageContext.request.contextPath}/register" style="color: var(--brand); font-weight: 700;">Customer Sign Up</a>
            </div>

        </div>
    </div>

</div>

<script>
    function selectVehicle(type, el) {
        document.getElementById('selected-vehicle-type').value = type;
        document.querySelectorAll('.vehicle-option-chip').forEach(function(c) {
            c.classList.remove('selected');
        });
        el.classList.add('selected');
    }

    function updatePlatePreview(val) {
        var clean = val ? val.trim().toUpperCase() : 'UP 14 AB 1234';
        document.getElementById('live-plate-text').innerText = clean;
    }
</script>

<script src="${pageContext.request.contextPath}/static/js/main.js"></script>
</body>
</html>
