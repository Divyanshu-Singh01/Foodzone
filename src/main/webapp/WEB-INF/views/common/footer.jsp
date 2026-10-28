<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<footer class="footer">
    <div class="container">
        <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(220px, 1fr)); gap: 36px;">
            <!-- Column 1: Brand Info -->
            <div>
                <div class="logo" style="color: var(--white); margin-bottom: 16px;">
                    <div class="logo-icon" style="width: 36px; height: 36px; font-size: 1.1rem;">
                        <i class="fa-solid fa-fire-burner"></i>
                    </div>
                    Food<span style="color: var(--primary);">Zone</span>
                </div>
                <p style="font-size: 0.9rem; color: var(--gray-300); line-height: 1.6;">
                    Delicious gourmet meals, artisanal pizzas, and comfort classics prepared fresh and delivered straight to your door with love.
                </p>
            </div>

            <!-- Column 2: Quick Links -->
            <div>
                <h4 style="color: var(--white); font-size: 1.05rem; margin-bottom: 16px;">Quick Links</h4>
                <ul style="list-style: none; display: flex; flex-direction: column; gap: 10px; font-size: 0.9rem;">
                    <li><a href="${pageContext.request.contextPath}/home" style="color: var(--gray-300);">Home</a></li>
                    <li><a href="${pageContext.request.contextPath}/menu" style="color: var(--gray-300);">Full Food Menu</a></li>
                    <li><a href="${pageContext.request.contextPath}/cart" style="color: var(--gray-300);">Your Cart</a></li>
                    <li><a href="${pageContext.request.contextPath}/orders" style="color: var(--gray-300);">Track Orders</a></li>
                </ul>
            </div>

            <!-- Column 3: Hours & Service -->
            <div>
                <h4 style="color: var(--white); font-size: 1.05rem; margin-bottom: 16px;">Service Hours</h4>
                <p style="font-size: 0.9rem; color: var(--gray-300); margin-bottom: 8px;">
                    <i class="fa-regular fa-clock" style="color: var(--primary); margin-right: 6px;"></i> Mon - Sun: 10:00 AM - 11:30 PM
                </p>
                <p style="font-size: 0.9rem; color: var(--gray-300); margin-bottom: 8px;">
                    <i class="fa-solid fa-motorcycle" style="color: var(--secondary); margin-right: 6px;"></i> Average Delivery: 30 - 40 Mins
                </p>
                <p style="font-size: 0.9rem; color: var(--gray-300);">
                    <i class="fa-solid fa-tag" style="color: var(--warning); margin-right: 6px;"></i> Free delivery on orders over ₹500
                </p>
            </div>

            <!-- Column 4: Contact & Demo -->
            <div>
                <h4 style="color: var(--white); font-size: 1.05rem; margin-bottom: 16px;">Contact & Support</h4>
                <p style="font-size: 0.9rem; color: var(--gray-300); margin-bottom: 8px;">
                    <i class="fa-solid fa-phone" style="color: var(--primary); margin-right: 6px;"></i> +91 98765 43210
                </p>
                <p style="font-size: 0.9rem; color: var(--gray-300); margin-bottom: 8px;">
                    <i class="fa-regular fa-envelope" style="color: var(--primary); margin-right: 6px;"></i> support@foodzone.com
                </p>
                <p style="font-size: 0.9rem; color: var(--gray-300);">
                    <i class="fa-solid fa-location-dot" style="color: var(--primary); margin-right: 6px;"></i> MG Road, Bangalore, India
                </p>
            </div>
        </div>

        <!-- Footer Bottom Bar -->
        <div class="footer-bottom">
            <span>&copy; <%= java.time.Year.now().getValue() %> FoodZone. Built with Java 25 LTS, Tomcat 10.1 & Jakarta Servlets.</span>
            <span>Academic Demonstration Project</span>
        </div>
    </div>
</footer>

<!-- Toast Notification Container -->
<div id="toast-container" style="position: fixed; bottom: 24px; right: 24px; z-index: 9999; display: flex; flex-direction: column; gap: 10px;"></div>

<!-- Core Scripts -->
<script src="${pageContext.request.contextPath}/static/js/main.js"></script>
<script src="${pageContext.request.contextPath}/static/js/cart.js"></script>
<c:if test="${sessionScope.currentUser != null and sessionScope.currentUser.admin}">
    <script src="${pageContext.request.contextPath}/static/js/admin.js"></script>
</c:if>
</body>
</html>
