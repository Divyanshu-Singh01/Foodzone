<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<c:set var="pageTitle" value="Create Account - FoodZone" />

<jsp:include page="/WEB-INF/views/common/header.jsp" />
<jsp:include page="/WEB-INF/views/common/navbar.jsp" />

<main class="container" style="padding-top: 40px; padding-bottom: 70px; display: flex; justify-content: center;">
    <div style="width: 100%; max-width: 480px;">
        <div style="background: var(--white); border-radius: var(--radius-lg); border: 1px solid var(--gray-200); padding: 36px; box-shadow: var(--shadow-md);">
            <div style="text-align: center; margin-bottom: 24px;">
                <div class="logo-icon" style="margin: 0 auto 12px; width: 48px; height: 48px; font-size: 1.4rem;">
                    <i class="fa-solid fa-user-plus"></i>
                </div>
                <h1 style="font-size: 1.8rem; margin-bottom: 6px;">Join FoodZone</h1>
                <p style="color: var(--gray-600); font-size: 0.9rem;">Create your profile for fast ordering and delivery tracking</p>
            </div>

            <!-- Error Notification -->
            <c:if test="${not empty errorMessage}">
                <div class="alert alert-danger">
                    <i class="fa-solid fa-triangle-exclamation"></i> ${errorMessage}
                </div>
            </c:if>

            <!-- Registration Form -->
            <form action="${pageContext.request.contextPath}/register" method="post" id="register-form">
                <div class="form-group">
                    <label class="form-label" for="reg-name">Full Name <span style="color: var(--danger);">*</span></label>
                    <input type="text" id="reg-name" name="fullName" class="form-control" required placeholder="e.g. John Doe"
                           value="<c:out value='${fullName}'/>">
                </div>

                <div class="form-group">
                    <label class="form-label" for="reg-email">Email Address <span style="color: var(--danger);">*</span></label>
                    <input type="email" id="reg-email" name="email" class="form-control" required placeholder="e.g. john@example.com"
                           value="<c:out value='${email}'/>">
                </div>

                <div class="form-group">
                    <label class="form-label" for="reg-phone">Contact Phone Number <span style="color: var(--danger);">*</span></label>
                    <input type="tel" id="reg-phone" name="phone" class="form-control" required placeholder="e.g. 9876543210"
                           value="<c:out value='${phone}'/>">
                </div>

                <div class="form-group">
                    <label class="form-label" for="reg-password">Password <span style="color: var(--danger);">*</span></label>
                    <input type="password" id="reg-password" name="password" class="form-control" required placeholder="At least 6 characters">
                </div>

                <div class="form-group">
                    <label class="form-label" for="reg-confirmPassword">Confirm Password <span style="color: var(--danger);">*</span></label>
                    <input type="password" id="reg-confirmPassword" name="confirmPassword" class="form-control" required placeholder="Re-enter password">
                </div>

                <div class="form-group">
                    <label class="form-label" for="reg-address">Default Delivery Address (Optional)</label>
                    <textarea id="reg-address" name="address" class="form-control" rows="2" placeholder="Street, Apartment, City"><c:out value='${address}'/></textarea>
                </div>

                <button type="submit" class="btn btn-primary" style="width: 100%; padding: 12px; margin-top: 8px;" id="submit-register-btn">
                    Create Account <i class="fa-solid fa-arrow-right" style="margin-left: 6px;"></i>
                </button>
            </form>

            <div style="text-align: center; margin-top: 24px; font-size: 0.9rem; color: var(--gray-600);">
                Already have an account?
                <a href="${pageContext.request.contextPath}/login" style="font-weight: 600;">Sign in here</a>
            </div>
        </div>
    </div>
</main>

<jsp:include page="/WEB-INF/views/common/footer.jsp" />
