<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<%-- Consumer Marketing Footer — hidden for Admin, Rider, Login and Register --%>
<c:if test="${(empty sessionScope.currentUser or sessionScope.currentUser.customer) and activePage != 'login' and activePage != 'register'}">
<footer class="footer">
    <div class="container">
        <div class="footer-grid">
            <!-- Brand column -->
            <div>
                <div class="logo" style="color:#fff;margin-bottom:var(--sp-4);">
                    <div class="logo-icon" style="width:36px;height:36px;font-size:1rem;">
                        <i class="fa-solid fa-fire-burner"></i>
                    </div>
                    Food<span>Zone</span>
                </div>
                <p class="footer-brand-desc">
                    Premium gourmet meals, artisanal pizzas, and comfort classics — prepared fresh and delivered with love, straight to your door.
                </p>
                <!-- Social icons -->
                <div style="display:flex;gap:var(--sp-2);margin-top:var(--sp-6);">
                    <a href="#" style="width:36px;height:36px;border-radius:var(--r-md);background:rgba(255,255,255,.06);color:var(--ink-400);display:flex;align-items:center;justify-content:center;border:1px solid rgba(255,255,255,.08);font-size:.95rem;transition:all .2s;" aria-label="Instagram">
                        <i class="fa-brands fa-instagram"></i>
                    </a>
                    <a href="#" style="width:36px;height:36px;border-radius:var(--r-md);background:rgba(255,255,255,.06);color:var(--ink-400);display:flex;align-items:center;justify-content:center;border:1px solid rgba(255,255,255,.08);font-size:.95rem;transition:all .2s;" aria-label="Twitter">
                        <i class="fa-brands fa-x-twitter"></i>
                    </a>
                    <a href="#" style="width:36px;height:36px;border-radius:var(--r-md);background:rgba(255,255,255,.06);color:var(--ink-400);display:flex;align-items:center;justify-content:center;border:1px solid rgba(255,255,255,.08);font-size:.95rem;transition:all .2s;" aria-label="Facebook">
                        <i class="fa-brands fa-facebook-f"></i>
                    </a>
                </div>
            </div>

            <!-- Quick Links -->
            <div>
                <div class="footer-col-title">Quick Links</div>
                <ul class="footer-links">
                    <li><a href="${pageContext.request.contextPath}/home"><i class="fa-solid fa-chevron-right" style="font-size:.65rem;"></i> Home</a></li>
                    <li><a href="${pageContext.request.contextPath}/menu"><i class="fa-solid fa-chevron-right" style="font-size:.65rem;"></i> Full Menu</a></li>
                    <li><a href="${pageContext.request.contextPath}/cart"><i class="fa-solid fa-chevron-right" style="font-size:.65rem;"></i> Your Cart</a></li>
                    <li><a href="${pageContext.request.contextPath}/orders"><i class="fa-solid fa-chevron-right" style="font-size:.65rem;"></i> Track Orders</a></li>
                </ul>
            </div>

            <!-- Service Hours -->
            <div>
                <div class="footer-col-title">Service Hours</div>
                <ul class="footer-links">
                    <li>
                        <a href="#" style="pointer-events:none;">
                            <i class="fa-regular fa-clock" style="color:var(--brand);"></i>
                            Mon – Sun: 10 AM – 11:30 PM
                        </a>
                    </li>
                    <li>
                        <a href="#" style="pointer-events:none;">
                            <i class="fa-solid fa-motorcycle" style="color:var(--emerald);"></i>
                            Delivery: 30 – 45 min avg
                        </a>
                    </li>
                    <li>
                        <a href="#" style="pointer-events:none;">
                            <i class="fa-solid fa-tag" style="color:var(--amber);"></i>
                            Free delivery on orders ₹500+
                        </a>
                    </li>
                </ul>
            </div>

            <!-- Contact -->
            <div>
                <div class="footer-col-title">Contact Us</div>
                <ul class="footer-links">
                    <li>
                        <a href="tel:+919876543210">
                            <i class="fa-solid fa-phone" style="color:var(--brand);"></i>
                            +91 98765 43210
                        </a>
                    </li>
                    <li>
                        <a href="mailto:support@foodzone.com">
                            <i class="fa-regular fa-envelope" style="color:var(--brand);"></i>
                            support@foodzone.com
                        </a>
                    </li>
                    <li>
                        <a href="#" style="pointer-events:none;">
                            <i class="fa-solid fa-location-dot" style="color:var(--brand);"></i>
                            MG Road, Bangalore, India
                        </a>
                    </li>
                </ul>
            </div>
        </div>

        <!-- Bottom bar -->
        <div class="footer-bottom">
            <span>&copy; <%= java.time.Year.now().getValue() %> FoodZone. Built on Java · Tomcat 10.1 · Jakarta EE.</span>
            <span style="display:flex;align-items:center;gap:var(--sp-2);">
                <span class="status-pill-dot" style="width:6px;height:6px;border-radius:50%;background:var(--emerald);display:inline-block;"></span>
                Enterprise Delivery Platform
            </span>
        </div>
    </div>
</footer>
</c:if>

<!-- Toast Notification Container -->
<div id="toast-container"></div>

<!-- Core Scripts -->
<script src="${pageContext.request.contextPath}/static/js/main.js"></script>
<c:if test="${empty sessionScope.currentUser or sessionScope.currentUser.customer}">
    <script src="${pageContext.request.contextPath}/static/js/cart.js"></script>
</c:if>
<c:if test="${sessionScope.currentUser != null and sessionScope.currentUser.admin}">
    <script src="${pageContext.request.contextPath}/static/js/admin.js"></script>
</c:if>
</body>
</html>
