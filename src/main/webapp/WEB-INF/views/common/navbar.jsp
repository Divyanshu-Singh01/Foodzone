<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>

<header class="navbar" id="main-navbar">
    <div class="container nav-container">

        <c:choose>
            <%-- ══════════ 1. DELIVERY RIDER NAVBAR ══════════ --%>
            <c:when test="${not empty sessionScope.currentUser and sessionScope.currentUser.delivery}">
                <a href="${pageContext.request.contextPath}/delivery/dashboard" class="logo" id="site-logo">
                    <div class="logo-icon" style="background:linear-gradient(135deg,var(--emerald),#00A878);">
                        <i class="fa-solid fa-motorcycle"></i>
                    </div>
                    Food<span>Zone</span>
                    <span style="font-size:.62rem;font-weight:800;text-transform:uppercase;letter-spacing:.08em;background:var(--emerald-light);color:var(--emerald);padding:3px 8px;border-radius:var(--r-sm);margin-left:6px;border:1px solid rgba(0,196,140,.25);">
                        Rider Hub
                    </span>
                </a>

                <nav>
                    <ul class="nav-links">
                        <li>
                            <a href="${pageContext.request.contextPath}/delivery/dashboard"
                               class="nav-link ${activePage == 'delivery' ? 'active' : ''}">
                                <i class="fa-solid fa-clipboard-list"></i> Deliveries
                            </a>
                        </li>
                        <li>
                            <a href="${pageContext.request.contextPath}/delivery/profile"
                               class="nav-link ${activePage == 'rider-profile' ? 'active' : ''}">
                                <i class="fa-solid fa-id-card"></i> My Profile
                            </a>
                        </li>
                    </ul>
                </nav>

                <div class="nav-actions">
                    <!-- 1-Click Duty Switcher -->
                    <form action="${pageContext.request.contextPath}/delivery" method="POST" style="margin:0;">
                        <input type="hidden" name="action" value="toggle-duty">
                        <input type="hidden" name="redirect" value="${activePage == 'rider-profile' ? '/delivery/profile' : '/delivery/dashboard'}">
                        <button type="submit" class="duty-nav-btn ${sessionScope.currentUser.isOnDuty ? 'duty-on' : 'duty-off'}"
                                id="navbar-duty-toggle"
                                title="Click to toggle Shift Duty (Current: ${sessionScope.currentUser.isOnDuty ? 'ON DUTY' : 'OFF DUTY'})">
                            <span class="duty-indicator-dot"></span>
                            <span>${sessionScope.currentUser.isOnDuty ? 'ON DUTY' : 'OFF DUTY'}</span>
                        </button>
                    </form>

                    <!-- Rider Profile Dropdown Menu -->
                    <div class="nav-dropdown-wrapper">
                        <a href="${pageContext.request.contextPath}/delivery/profile" class="nav-user-chip" id="rider-profile-link" title="Open Fleet Profile">
                            <div class="nav-user-avatar" style="background:linear-gradient(135deg,var(--emerald),#00A878);position:relative;">
                                ${fn:substring(sessionScope.currentUser.fullName, 0, 1)}
                                <span style="position:absolute;bottom:-1px;right:-1px;width:8px;height:8px;border-radius:50%;background:${sessionScope.currentUser.isOnDuty ? 'var(--emerald)' : 'var(--red)'};border:1.5px solid #FFFFFF;"></span>
                            </div>
                            <span style="font-weight:700;">${fn:split(sessionScope.currentUser.fullName, ' ')[0]}</span>
                            <i class="fa-solid fa-chevron-down nav-dropdown-arrow"></i>
                        </a>

                        <div class="nav-dropdown-menu" id="rider-dropdown-menu">
                            <div class="nav-dropdown-header">
                                <div class="nav-dropdown-avatar" style="background:linear-gradient(135deg,var(--emerald),#00A878);position:relative;">
                                    ${fn:substring(sessionScope.currentUser.fullName, 0, 1)}
                                </div>
                                <div style="min-width:0;flex:1;">
                                    <div class="nav-dropdown-name">${sessionScope.currentUser.fullName}</div>
                                    <div class="nav-dropdown-email">${sessionScope.currentUser.email}</div>
                                    <div class="nav-dropdown-badge">
                                        <i class="fa-solid fa-motorcycle"></i> ${not empty sessionScope.currentUser.vehicleType ? sessionScope.currentUser.vehicleType : 'Motorcycle'} &bull; ${not empty sessionScope.currentUser.vehicleNo ? sessionScope.currentUser.vehicleNo : 'DL 04 AB 1234'}
                                    </div>
                                </div>
                            </div>

                            <div style="padding: 6px 14px 10px;">
                                <div style="display:flex;align-items:center;justify-content:space-between;background:var(--ink-50);padding:8px 12px;border-radius:var(--r-md);border:1px solid var(--ink-100);">
                                    <span style="font-size:0.75rem;font-weight:800;color:var(--ink-500);text-transform:uppercase;letter-spacing:0.04em;">Shift State</span>
                                    <span style="font-size:0.75rem;font-weight:800;color:${sessionScope.currentUser.isOnDuty ? '#059669' : '#DC2626'};display:flex;align-items:center;gap:5px;">
                                        <span class="status-pill-dot" style="background:${sessionScope.currentUser.isOnDuty ? 'var(--emerald)' : 'var(--red)'};"></span>
                                        ${sessionScope.currentUser.isOnDuty ? 'ONLINE' : 'OFFLINE'}
                                    </span>
                                </div>
                            </div>

                            <div class="nav-dropdown-divider"></div>

                            <a href="${pageContext.request.contextPath}/delivery/dashboard" class="nav-dropdown-item">
                                <i class="fa-solid fa-route"></i>
                                <span>Active Deliveries Hub</span>
                            </a>
                            <a href="${pageContext.request.contextPath}/delivery/profile" class="nav-dropdown-item">
                                <i class="fa-solid fa-id-card-clip"></i>
                                <span>Fleet Passport & Vehicle ID</span>
                            </a>

                            <div class="nav-dropdown-divider"></div>

                            <a href="${pageContext.request.contextPath}/logout" class="nav-dropdown-item nav-dropdown-danger" id="logout-btn">
                                <i class="fa-solid fa-arrow-right-from-bracket"></i>
                                <span>Sign Out of Shift</span>
                            </a>
                        </div>
                    </div>
                </div>
            </c:when>

            <%-- ══════════ 2. ADMIN NAVBAR ══════════ --%>
            <c:when test="${not empty sessionScope.currentUser and sessionScope.currentUser.admin}">
                <a href="${pageContext.request.contextPath}/admin/dashboard" class="logo" id="site-logo">
                    <div class="logo-icon">
                        <i class="fa-solid fa-shield-halved"></i>
                    </div>
                    Food<span>Zone</span>
                    <span style="font-size:.62rem;font-weight:800;text-transform:uppercase;letter-spacing:.08em;background:var(--brand-100);color:var(--brand);padding:3px 8px;border-radius:var(--r-sm);margin-left:6px;border:1px solid rgba(255,77,0,.2);">
                        Admin
                    </span>
                </a>

                <nav>
                    <ul class="nav-links">
                        <li>
                            <a href="${pageContext.request.contextPath}/admin/dashboard"
                               class="nav-link ${activeAdminTab == 'dashboard' or activePage == 'admin' ? 'active' : ''}">
                                <i class="fa-solid fa-chart-pie"></i> Dashboard
                            </a>
                        </li>
                        <li>
                            <a href="${pageContext.request.contextPath}/admin/orders"
                               class="nav-link ${activeAdminTab == 'orders' ? 'active' : ''}">
                                <i class="fa-solid fa-receipt"></i> Live Orders
                            </a>
                        </li>
                        <li>
                            <a href="${pageContext.request.contextPath}/admin/menu"
                               class="nav-link ${activeAdminTab == 'menu' ? 'active' : ''}">
                                <i class="fa-solid fa-burger"></i> Menu
                            </a>
                        </li>
                        <li>
                            <a href="${pageContext.request.contextPath}/admin/users"
                               class="nav-link ${activeAdminTab == 'users' ? 'active' : ''}">
                                <i class="fa-solid fa-users"></i> Customers
                            </a>
                        </li>
                    </ul>
                </nav>

                <div class="nav-actions">
                    <a href="${pageContext.request.contextPath}/admin/profile" class="nav-user-chip" id="admin-profile-link">
                        <div class="nav-user-avatar">
                            ${fn:substring(sessionScope.currentUser.fullName, 0, 1)}
                        </div>
                        ${sessionScope.currentUser.fullName}
                    </a>
                    <a href="${pageContext.request.contextPath}/logout" class="btn btn-outline btn-sm" id="logout-btn">
                        <i class="fa-solid fa-arrow-right-from-bracket"></i>
                    </a>
                </div>
            </c:when>

            <%-- ══════════ 3. CUSTOMER / PUBLIC NAVBAR ══════════ --%>
            <c:otherwise>
                <a href="${pageContext.request.contextPath}/home" class="logo" id="site-logo">
                    <div class="logo-icon">
                        <i class="fa-solid fa-fire-burner"></i>
                    </div>
                    Food<span>Zone</span>
                </a>

                <nav>
                    <ul class="nav-links">
                        <li>
                            <a href="${pageContext.request.contextPath}/home"
                               class="nav-link ${activePage == 'home' ? 'active' : ''}">Home</a>
                        </li>
                        <li>
                            <a href="${pageContext.request.contextPath}/menu"
                               class="nav-link ${activePage == 'menu' ? 'active' : ''}">Menu</a>
                        </li>
                        <c:if test="${not empty sessionScope.currentUser}">
                            <li>
                                <a href="${pageContext.request.contextPath}/orders"
                                   class="nav-link ${activePage == 'orders' ? 'active' : ''}">My Orders</a>
                            </li>
                        </c:if>
                    </ul>
                </nav>

                <div class="nav-actions">
                    <!-- Cart -->
                    <a href="${pageContext.request.contextPath}/cart" class="cart-btn" id="nav-cart-btn" title="View Cart">
                        <i class="fa-solid fa-bag-shopping"></i>
                        <c:set var="cartCount" value="${sessionScope.cart != null ? sessionScope.cart.itemCount : 0}" />
                        <span class="cart-badge" id="nav-cart-badge">${cartCount}</span>
                    </a>

                    <!-- Auth state -->
                    <c:choose>
                        <c:when test="${not empty sessionScope.currentUser}">
                            <a href="${pageContext.request.contextPath}/profile" class="nav-user-chip" id="customer-profile-link">
                                <div class="nav-user-avatar">
                                    ${fn:substring(sessionScope.currentUser.fullName, 0, 1)}
                                </div>
                                ${fn:split(sessionScope.currentUser.fullName, ' ')[0]}
                            </a>
                            <a href="${pageContext.request.contextPath}/logout" class="btn btn-outline btn-sm" id="logout-btn">
                                <i class="fa-solid fa-arrow-right-from-bracket"></i>
                            </a>
                        </c:when>
                        <c:otherwise>
                            <a href="${pageContext.request.contextPath}/rider-register" class="btn btn-outline btn-sm" id="nav-rider-join-btn"
                               style="border-color: #A7F3D0; color: #047857; background: #ECFDF5; font-weight: 700; border-radius: var(--r-full); padding: 7px 14px; font-size: 0.8rem; display: inline-flex; align-items: center; gap: 5px;">
                                <i class="fa-solid fa-motorcycle"></i> Ride with Us
                            </a>
                            <a href="${pageContext.request.contextPath}/login" class="btn btn-primary btn-sm" id="login-btn">
                                <i class="fa-solid fa-arrow-right-to-bracket"></i> Sign In
                            </a>
                        </c:otherwise>
                    </c:choose>
                </div>
            </c:otherwise>
        </c:choose>

    </div>
</header>

<script>
  /* Navbar shadow on scroll */
  window.addEventListener('scroll', function () {
    const nav = document.getElementById('main-navbar');
    if (nav) nav.classList.toggle('scrolled', window.scrollY > 10);
  }, { passive: true });
</script>
