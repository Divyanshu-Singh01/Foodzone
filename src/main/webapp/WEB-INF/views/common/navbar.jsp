<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<header class="navbar">
    <div class="container nav-container">
        <!-- Brand Logo -->
        <a href="${pageContext.request.contextPath}/home" class="logo" id="site-logo">
            <div class="logo-icon">
                <i class="fa-solid fa-fire-burner"></i>
            </div>
            Food<span>Zone</span>
        </a>

        <!-- Desktop Navigation Links -->
        <nav>
            <ul class="nav-links">
                <li>
                    <a href="${pageContext.request.contextPath}/home" class="nav-link ${activePage == 'home' ? 'active' : ''}">Home</a>
                </li>
                <li>
                    <a href="${pageContext.request.contextPath}/menu" class="nav-link ${activePage == 'menu' ? 'active' : ''}">Menu & Catalog</a>
                </li>
                <c:if test="${not empty sessionScope.currentUser}">
                    <li>
                        <a href="${pageContext.request.contextPath}/orders" class="nav-link ${activePage == 'orders' ? 'active' : ''}">My Orders</a>
                    </li>
                </c:if>
                <c:if test="${sessionScope.currentUser != null and sessionScope.currentUser.admin}">
                    <li>
                        <a href="${pageContext.request.contextPath}/admin/dashboard" class="nav-link ${activePage == 'admin' ? 'active' : ''}" style="color: var(--primary);">
                            <i class="fa-solid fa-shield-halved"></i> Admin Portal
                        </a>
                    </li>
                </c:if>
            </ul>
        </nav>

        <!-- Action Buttons -->
        <div class="nav-actions">
            <!-- Shopping Cart Button with Dynamic Badge -->
            <a href="${pageContext.request.contextPath}/cart" class="cart-btn" id="nav-cart-btn" title="View Cart">
                <i class="fa-solid fa-bag-shopping"></i>
                <c:set var="cartCount" value="${sessionScope.cart != null ? sessionScope.cart.itemCount : 0}" />
                <span class="cart-badge" id="nav-cart-badge">${cartCount}</span>
            </a>

            <!-- Authentication State -->
            <c:choose>
                <c:when test="${not empty sessionScope.currentUser}">
                    <div style="display: flex; align-items: center; gap: 12px;">
                        <span style="font-size: 0.9rem; font-weight: 600; color: var(--gray-800);">
                            <i class="fa-regular fa-user" style="color: var(--primary); margin-right: 4px;"></i>
                            ${sessionScope.currentUser.fullName}
                        </span>
                        <a href="${pageContext.request.contextPath}/logout" class="btn btn-outline btn-sm" id="logout-btn">
                            <i class="fa-solid fa-arrow-right-from-bracket"></i> Logout
                        </a>
                    </div>
                </c:when>
                <c:otherwise>
                    <a href="${pageContext.request.contextPath}/login" class="btn btn-primary btn-sm" id="login-btn">
                        <i class="fa-solid fa-arrow-right-to-bracket"></i> Sign In
                    </a>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</header>
