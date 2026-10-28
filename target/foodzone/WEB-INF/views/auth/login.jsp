<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<c:set var="pageTitle" value="Sign In — FoodZone" />
<c:set var="activePage" value="login" />

<jsp:include page="/WEB-INF/views/common/header.jsp" />

<style>
  body { overflow: hidden; }
  @media (max-width: 768px) { body { overflow: auto; } }
</style>

<div class="auth-page">

    <!-- Left: Dark branded panel -->
    <div class="auth-left">
        <div style="position:relative;z-index:1;max-width:480px;">
            <!-- Logo -->
            <a href="${pageContext.request.contextPath}/home" style="display:inline-flex;align-items:center;gap:12px;font-family:var(--font-display);font-size:1.5rem;font-weight:800;color:#fff;letter-spacing:-.03em;margin-bottom:var(--sp-16);text-decoration:none;">
                <div class="logo-icon" style="width:44px;height:44px;font-size:1.2rem;">
                    <i class="fa-solid fa-fire-burner"></i>
                </div>
                Food<span style="color:var(--brand);">Zone</span>
            </a>

            <h2 style="font-family:var(--font-display);font-size:2.4rem;color:#fff;font-weight:800;line-height:1.15;letter-spacing:-.03em;margin-bottom:var(--sp-5);">
                Premium Food.<br>Delivered Fast.
            </h2>
            <p style="color:var(--ink-300);font-size:1rem;line-height:1.7;margin-bottom:var(--sp-12);">
                Sign in to unlock your order history, save favourite dishes, and get faster checkout every time.
            </p>

            <!-- Trust bullets -->
            <div style="display:flex;flex-direction:column;gap:var(--sp-4);">
                <div style="display:flex;align-items:center;gap:var(--sp-3);font-size:.9rem;color:var(--ink-300);">
                    <div style="width:36px;height:36px;border-radius:var(--r-md);background:rgba(255,77,0,.15);color:var(--brand-400);display:flex;align-items:center;justify-content:center;flex-shrink:0;">
                        <i class="fa-solid fa-bolt"></i>
                    </div>
                    <span><strong style="color:#fff;">30-minute delivery</strong> guarantee on all orders</span>
                </div>
                <div style="display:flex;align-items:center;gap:var(--sp-3);font-size:.9rem;color:var(--ink-300);">
                    <div style="width:36px;height:36px;border-radius:var(--r-md);background:rgba(0,196,140,.15);color:var(--emerald);display:flex;align-items:center;justify-content:center;flex-shrink:0;">
                        <i class="fa-solid fa-shield-heart"></i>
                    </div>
                    <span><strong style="color:#fff;">Hygienic & FSSAI-certified</strong> kitchen operations</span>
                </div>
                <div style="display:flex;align-items:center;gap:var(--sp-3);font-size:.9rem;color:var(--ink-300);">
                    <div style="width:36px;height:36px;border-radius:var(--r-md);background:rgba(245,158,11,.15);color:var(--amber);display:flex;align-items:center;justify-content:center;flex-shrink:0;">
                        <i class="fa-solid fa-star"></i>
                    </div>
                    <span><strong style="color:#fff;">4.8 star</strong> rated by 10,000+ happy customers</span>
                </div>
            </div>
        </div>
    </div>

    <!-- Right: Login Form -->
    <div class="auth-right">
        <div class="auth-form-box">
            <div style="margin-bottom:var(--sp-8);">
                <h1 class="auth-heading">Welcome Back</h1>
                <p class="auth-subtext">Sign in to your FoodZone account</p>
            </div>

            <!-- Alerts -->
            <c:if test="${not empty errorMessage}">
                <div class="alert alert-danger">
                    <i class="fa-solid fa-triangle-exclamation alert-icon"></i>
                    <span>${errorMessage}</span>
                </div>
            </c:if>
            <c:if test="${param.msg == 'logged_out'}">
                <div class="alert alert-success">
                    <i class="fa-solid fa-circle-check alert-icon"></i>
                    <span>You've been signed out successfully.</span>
                </div>
            </c:if>
            <c:if test="${param.error == 'auth_required'}">
                <div class="alert alert-info">
                    <i class="fa-solid fa-circle-info alert-icon"></i>
                    <span>Please sign in to continue to checkout.</span>
                </div>
            </c:if>
            <c:if test="${param.error == 'unauthorized'}">
                <div class="alert alert-danger">
                    <i class="fa-solid fa-shield-halved alert-icon"></i>
                    <span>Access denied. Admin credentials required.</span>
                </div>
            </c:if>

            <!-- Login Form -->
            <form action="${pageContext.request.contextPath}/login" method="post" id="login-form">
                <input type="hidden" name="redirect" value="<c:out value='${param.redirect}'/>">

                <div class="form-group">
                    <label class="form-label" for="login-email">Email Address</label>
                    <div class="input-icon-wrap">
                        <i class="fa-regular fa-envelope input-icon"></i>
                        <input type="email" id="login-email" name="email" class="form-control"
                               required placeholder="name@example.com"
                               value="<c:out value='${not empty email ? email : param.email}'/>">
                    </div>
                </div>

                <div class="form-group">
                    <label class="form-label" for="login-password">Password</label>
                    <div class="input-icon-wrap">
                        <i class="fa-solid fa-lock input-icon"></i>
                        <input type="password" id="login-password" name="password"
                               class="form-control" required placeholder="••••••••">
                    </div>
                </div>

                <button type="submit" class="btn btn-primary btn-block" style="margin-top:var(--sp-2);padding:14px;" id="submit-login-btn">
                    Sign In <i class="fa-solid fa-arrow-right-to-bracket"></i>
                </button>
            </form>

            <!-- Demo Quick-Fill -->
            <div style="margin-top:var(--sp-6);padding:var(--sp-5);background:var(--ink-50);border-radius:var(--r-lg);border:1px dashed var(--ink-200);">
                <div style="font-size:.72rem;text-transform:uppercase;font-weight:800;letter-spacing:.08em;color:var(--ink-400);margin-bottom:var(--sp-3);">
                    <i class="fa-solid fa-key" style="color:var(--brand);margin-right:4px;"></i> Quick Demo Login
                </div>
                <div style="display:flex;gap:var(--sp-2);flex-wrap:wrap;">
                    <button type="button" class="btn btn-secondary btn-xs"
                            onclick="document.getElementById('login-email').value='customer@gmail.com';document.getElementById('login-password').value='user123';"
                            id="demo-customer-btn">
                        <i class="fa-solid fa-user"></i> Customer
                    </button>
                    <button type="button" class="btn btn-secondary btn-xs"
                            onclick="document.getElementById('login-email').value='admin@foodzone.com';document.getElementById('login-password').value='admin123';"
                            id="demo-admin-btn">
                        <i class="fa-solid fa-shield-halved"></i> Admin
                    </button>
                    <button type="button" class="btn btn-secondary btn-xs"
                            style="color:var(--emerald);"
                            onclick="document.getElementById('login-email').value='rider@foodzone.com';document.getElementById('login-password').value='rider123';"
                            id="demo-rider-btn">
                        <i class="fa-solid fa-motorcycle"></i> Rider
                    </button>
                </div>
            </div>

            <div class="divider-text">or</div>

            <div style="text-align:center;font-size:.9rem;color:var(--ink-400);">
                Don't have an account?
                <a href="${pageContext.request.contextPath}/register" style="font-weight:700;color:var(--brand);">Create one free</a>
            </div>

            <div style="margin-top: 16px; text-align: center; font-size: 0.85rem; padding-top: 14px; border-top: 1px dashed var(--ink-200);">
                <span style="color: var(--ink-400);">Deliver with us & earn?</span>
                <a href="${pageContext.request.contextPath}/rider-register" style="font-weight: 800; color: #059669; margin-left: 6px; display: inline-flex; align-items: center; gap: 4px;">
                    <i class="fa-solid fa-motorcycle"></i> Join as Delivery Partner &rarr;
                </a>
            </div>
        </div>
    </div>

</div>

<script src="${pageContext.request.contextPath}/static/js/main.js"></script>
</body>
</html>
