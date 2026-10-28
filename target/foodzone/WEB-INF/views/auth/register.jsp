<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<c:set var="pageTitle" value="Create Account — FoodZone" />
<c:set var="activePage" value="register" />

<jsp:include page="/WEB-INF/views/common/header.jsp" />

<style>
  body { overflow: hidden; }
  @media (max-width: 768px) { body { overflow: auto; } }
</style>

<div class="auth-page">

    <!-- Left: Dark Branded Panel -->
    <div class="auth-left">
        <div style="position:relative;z-index:1;">
            <a href="${pageContext.request.contextPath}/home" style="display:inline-flex;align-items:center;gap:12px;font-family:var(--font-display);font-size:1.5rem;font-weight:800;color:#fff;letter-spacing:-.03em;margin-bottom:var(--sp-16);text-decoration:none;">
                <div class="logo-icon" style="width:44px;height:44px;font-size:1.2rem;"><i class="fa-solid fa-fire-burner"></i></div>
                Food<span style="color:var(--brand);">Zone</span>
            </a>

            <h2 style="font-family:var(--font-display);font-size:2.2rem;color:#fff;font-weight:800;line-height:1.15;letter-spacing:-.03em;margin-bottom:var(--sp-5);">
                Join thousands of<br>happy food lovers
            </h2>
            <p style="color:var(--ink-300);font-size:.95rem;line-height:1.7;margin-bottom:var(--sp-10);">
                Create your free account to unlock exclusive deals, track deliveries in real-time, and enjoy faster checkout.
            </p>

            <!-- Perks -->
            <div style="display:flex;flex-direction:column;gap:var(--sp-4);">
                <div style="display:flex;align-items:center;gap:var(--sp-3);font-size:.88rem;color:var(--ink-300);">
                    <i class="fa-solid fa-circle-check" style="color:var(--emerald);font-size:1.1rem;"></i>
                    <span>Real-time delivery tracking on all orders</span>
                </div>
                <div style="display:flex;align-items:center;gap:var(--sp-3);font-size:.88rem;color:var(--ink-300);">
                    <i class="fa-solid fa-circle-check" style="color:var(--emerald);font-size:1.1rem;"></i>
                    <span>Save favourite addresses for quick checkout</span>
                </div>
                <div style="display:flex;align-items:center;gap:var(--sp-3);font-size:.88rem;color:var(--ink-300);">
                    <i class="fa-solid fa-circle-check" style="color:var(--emerald);font-size:1.1rem;"></i>
                    <span>Order history & repeat orders in one tap</span>
                </div>
                <div style="display:flex;align-items:center;gap:var(--sp-3);font-size:.88rem;color:var(--ink-300);">
                    <i class="fa-solid fa-circle-check" style="color:var(--emerald);font-size:1.1rem;"></i>
                    <span>Exclusive early-access promotions & deals</span>
                </div>
            </div>
        </div>
    </div>

    <!-- Right: Registration Form -->
    <div class="auth-right" style="overflow-y:auto;">
        <div class="auth-form-box">
            <div style="margin-bottom:var(--sp-8);">
                <h1 class="auth-heading">Create Account</h1>
                <p class="auth-subtext">Free forever. No credit card required.</p>
            </div>

            <c:if test="${not empty errorMessage}">
                <div class="alert alert-danger">
                    <i class="fa-solid fa-triangle-exclamation alert-icon"></i>
                    <span>${errorMessage}</span>
                </div>
            </c:if>

            <form action="${pageContext.request.contextPath}/register" method="post" id="register-form">

                <div class="form-group">
                    <label class="form-label" for="reg-name">Full Name <span style="color:var(--brand);">*</span></label>
                    <div class="input-icon-wrap">
                        <i class="fa-solid fa-user input-icon"></i>
                        <input type="text" id="reg-name" name="fullName" class="form-control"
                               required placeholder="e.g. Priya Sharma"
                               value="<c:out value='${fullName}'/>">
                    </div>
                </div>

                <div class="form-group">
                    <label class="form-label" for="reg-email">Email Address <span style="color:var(--brand);">*</span></label>
                    <div class="input-icon-wrap">
                        <i class="fa-regular fa-envelope input-icon"></i>
                        <input type="email" id="reg-email" name="email" class="form-control"
                               required placeholder="name@example.com"
                               value="<c:out value='${email}'/>">
                    </div>
                </div>

                <div class="form-group">
                    <label class="form-label" for="reg-phone">Phone Number <span style="color:var(--brand);">*</span></label>
                    <div class="input-icon-wrap">
                        <i class="fa-solid fa-phone input-icon"></i>
                        <input type="tel" id="reg-phone" name="phone" class="form-control"
                               required placeholder="10-digit mobile number"
                               value="<c:out value='${phone}'/>">
                    </div>
                </div>

                <div style="display:grid;grid-template-columns:1fr 1fr;gap:var(--sp-4);">
                    <div class="form-group">
                        <label class="form-label" for="reg-password">Password <span style="color:var(--brand);">*</span></label>
                        <div class="input-icon-wrap">
                            <i class="fa-solid fa-lock input-icon"></i>
                            <input type="password" id="reg-password" name="password"
                                   class="form-control" required placeholder="Min. 6 chars">
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="form-label" for="reg-confirm">Confirm <span style="color:var(--brand);">*</span></label>
                        <div class="input-icon-wrap">
                            <i class="fa-solid fa-lock input-icon"></i>
                            <input type="password" id="reg-confirm" name="confirmPassword"
                                   class="form-control" required placeholder="Repeat">
                        </div>
                    </div>
                </div>

                <div class="form-group">
                    <label class="form-label" for="reg-address">Default Delivery Address <span style="color:var(--ink-400);font-weight:500;">(optional)</span></label>
                    <div class="input-icon-wrap">
                        <i class="fa-solid fa-location-dot input-icon" style="top:15px;transform:none;"></i>
                        <textarea id="reg-address" name="address" class="form-control"
                                  rows="2" placeholder="Street, Apartment, City, PIN"
                                  style="padding-left:42px;"><c:out value='${address}'/></textarea>
                    </div>
                </div>

                <button type="submit" class="btn btn-primary btn-block" style="padding:14px;" id="submit-register-btn">
                    <i class="fa-solid fa-user-plus"></i> Create My Account
                </button>
            </form>

            <div class="divider-text">already have an account?</div>

            <a href="${pageContext.request.contextPath}/login" class="btn btn-outline btn-block" id="goto-login-btn">
                <i class="fa-solid fa-arrow-right-to-bracket"></i> Sign In Instead
            </a>

            <div style="margin-top: 18px; text-align: center; font-size: 0.85rem; padding-top: 14px; border-top: 1px dashed var(--ink-200);">
                <span style="color: var(--ink-400);">Want to earn as a Delivery Partner?</span>
                <a href="${pageContext.request.contextPath}/rider-register" style="font-weight: 800; color: #059669; margin-left: 6px; display: inline-flex; align-items: center; gap: 4px;">
                    <i class="fa-solid fa-motorcycle"></i> Join FoodZone Fleet &rarr;
                </a>
            </div>
        </div>
    </div>

</div>

<script src="${pageContext.request.contextPath}/static/js/main.js"></script>
</body>
</html>
