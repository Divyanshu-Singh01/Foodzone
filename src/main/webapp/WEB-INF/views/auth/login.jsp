<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<c:set var="pageTitle" value="Sign In - FoodZone" />

<jsp:include page="/WEB-INF/views/common/header.jsp" />
<jsp:include page="/WEB-INF/views/common/navbar.jsp" />

<main class="container" style="padding-top: 50px; padding-bottom: 70px; display: flex; justify-content: center;">
    <div style="width: 100%; max-width: 440px;">
        <!-- Card Container -->
        <div style="background: var(--white); border-radius: var(--radius-lg); border: 1px solid var(--gray-200); padding: 36px; box-shadow: var(--shadow-md);">
            <div style="text-align: center; margin-bottom: 28px;">
                <div class="logo-icon" style="margin: 0 auto 12px; width: 48px; height: 48px; font-size: 1.4rem;">
                    <i class="fa-solid fa-lock"></i>
                </div>
                <h1 style="font-size: 1.8rem; margin-bottom: 6px;">Welcome Back</h1>
                <p style="color: var(--gray-600); font-size: 0.9rem;">Sign in to track orders and checkout faster</p>
            </div>

            <!-- Alerts -->
            <c:if test="${not empty errorMessage}">
                <div class="alert alert-danger">
                    <i class="fa-solid fa-triangle-exclamation"></i> ${errorMessage}
                </div>
            </c:if>
            <c:if test="${param.msg == 'logged_out'}">
                <div class="alert alert-success">
                    <i class="fa-solid fa-circle-check"></i> You have successfully signed out.
                </div>
            </c:if>
            <c:if test="${param.error == 'auth_required'}">
                <div class="alert alert-danger">
                    <i class="fa-solid fa-circle-info"></i> Please sign in to proceed with checkout.
                </div>
            </c:if>
            <c:if test="${param.error == 'unauthorized'}">
                <div class="alert alert-danger">
                    <i class="fa-solid fa-shield-halved"></i> Access denied: Admin credentials required.
                </div>
            </c:if>

            <!-- Login Form -->
            <form action="${pageContext.request.contextPath}/login" method="post" id="login-form">
                <input type="hidden" name="redirect" value="<c:out value='${param.redirect}'/>">

                <div class="form-group">
                    <label class="form-label" for="login-email">Email Address</label>
                    <input type="email" id="login-email" name="email" class="form-control" required placeholder="name@example.com"
                           value="<c:out value='${not empty email ? email : param.email}'/>">
                </div>

                <div class="form-group">
                    <label class="form-label" for="login-password">Password</label>
                    <input type="password" id="login-password" name="password" class="form-control" required placeholder="••••••••">
                </div>

                <button type="submit" class="btn btn-primary" style="width: 100%; padding: 12px; margin-top: 8px;" id="submit-login-btn">
                    Sign In <i class="fa-solid fa-arrow-right-to-bracket" style="margin-left: 6px;"></i>
                </button>
            </form>

            <!-- Demo Credentials Quick-Fill Pill -->
            <div style="margin-top: 24px; padding: 14px; background: var(--gray-50); border-radius: var(--radius-md); border: 1px dashed var(--gray-300);">
                <span style="font-size: 0.78rem; text-transform: uppercase; font-weight: 700; color: var(--gray-600); display: block; margin-bottom: 8px;">
                    <i class="fa-solid fa-key" style="color: var(--primary);"></i> Quick Demo Fill
                </span>
                <div style="display: flex; gap: 8px;">
                    <button type="button" class="btn btn-secondary btn-sm" style="flex: 1; font-size: 0.8rem; padding: 6px 8px;"
                            onclick="document.getElementById('login-email').value='customer@gmail.com'; document.getElementById('login-password').value='user123';">
                        Customer Demo
                    </button>
                    <button type="button" class="btn btn-secondary btn-sm" style="flex: 1; font-size: 0.8rem; padding: 6px 8px;"
                            onclick="document.getElementById('login-email').value='admin@foodzone.com'; document.getElementById('login-password').value='admin123';">
                        Admin Demo
                    </button>
                </div>
            </div>

            <!-- Footer Link -->
            <div style="text-align: center; margin-top: 24px; font-size: 0.9rem; color: var(--gray-600);">
                Don't have an account?
                <a href="${pageContext.request.contextPath}/register" style="font-weight: 600;">Sign up here</a>
            </div>
        </div>
    </div>
</main>

<jsp:include page="/WEB-INF/views/common/footer.jsp" />
