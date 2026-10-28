package com.foodzone.controller;

import com.foodzone.dao.CouponDAO;
import com.foodzone.dao.FoodItemDAO;
import com.foodzone.model.Cart;
import com.foodzone.model.Coupon;
import com.foodzone.model.FoodItem;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/cart")
public class CartServlet extends HttpServlet {

    private final FoodItemDAO foodItemDAO = new FoodItemDAO();
    private final CouponDAO couponDAO = new CouponDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        Cart cart = getOrCreateCart(request);

        // Fetch upselling items (Beverages = category 4, Desserts = category 5)
        List<FoodItem> upsellItems = new ArrayList<>();
        try {
            List<FoodItem> drinks = foodItemDAO.getItemsByCategory(4);
            List<FoodItem> desserts = foodItemDAO.getItemsByCategory(5);
            if (drinks != null) upsellItems.addAll(drinks);
            if (desserts != null) upsellItems.addAll(desserts);
        } catch (Exception ignored) {}

        request.setAttribute("upsellItems", upsellItems);
        request.setAttribute("activeCoupons", couponDAO.getAllActiveCoupons());
        request.getRequestDispatcher("/WEB-INF/views/customer/cart.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        Cart cart = getOrCreateCart(request);
        String redirectUrl = request.getContextPath() + "/cart";

        if ("add".equalsIgnoreCase(action)) {
            handleAdd(request, cart);
            String referer = request.getHeader("Referer");
            if (referer != null && !referer.contains("/cart")) {
                redirectUrl = referer + (referer.contains("?") ? "&" : "?") + "msg=cart_updated";
            }
        } else if ("update".equalsIgnoreCase(action)) {
            handleUpdate(request, cart);
        } else if ("remove".equalsIgnoreCase(action)) {
            handleRemove(request, cart);
        } else if ("clear".equalsIgnoreCase(action)) {
            cart.clear();
        } else if ("apply-coupon".equalsIgnoreCase(action)) {
            String code = request.getParameter("couponCode");
            Coupon coupon = couponDAO.getCouponByCode(code);
            if (coupon != null) {
                if (cart.getSubtotal().compareTo(coupon.getMinOrderAmount()) >= 0) {
                    cart.applyCoupon(coupon.getCode(), coupon.getDiscountAmount());
                    redirectUrl += "?msg=coupon_applied";
                } else {
                    redirectUrl += "?error=min_order_" + coupon.getMinOrderAmount();
                }
            } else {
                redirectUrl += "?error=invalid_coupon";
            }
        } else if ("remove-coupon".equalsIgnoreCase(action)) {
            cart.removeCoupon();
            redirectUrl += "?msg=coupon_removed";
        } else if ("set-order-type".equalsIgnoreCase(action)) {
            String type = request.getParameter("orderType");
            if ("TAKEAWAY".equalsIgnoreCase(type) || "DELIVERY".equalsIgnoreCase(type)) {
                cart.setOrderType(type.toUpperCase());
            }
        }

        response.sendRedirect(redirectUrl);
    }

    private void handleAdd(HttpServletRequest request, Cart cart) {
        try {
            int foodId = Integer.parseInt(request.getParameter("foodId"));
            int qty = 1;
            String qtyParam = request.getParameter("quantity");
            if (qtyParam != null && !qtyParam.trim().isEmpty()) {
                qty = Math.max(1, Integer.parseInt(qtyParam.trim()));
            }

            FoodItem item = foodItemDAO.getItemById(foodId);
            if (item != null && item.isAvailable()) {
                cart.addItem(item, qty);
            }
        } catch (NumberFormatException ignored) {}
    }

    private void handleUpdate(HttpServletRequest request, Cart cart) {
        try {
            int foodId = Integer.parseInt(request.getParameter("foodId"));
            int qty = Integer.parseInt(request.getParameter("quantity"));
            cart.updateQuantity(foodId, qty);
        } catch (NumberFormatException ignored) {}
    }

    private void handleRemove(HttpServletRequest request, Cart cart) {
        try {
            int foodId = Integer.parseInt(request.getParameter("foodId"));
            cart.removeItem(foodId);
        } catch (NumberFormatException ignored) {}
    }

    private Cart getOrCreateCart(HttpServletRequest request) {
        HttpSession session = request.getSession(true);
        Cart cart = (Cart) session.getAttribute("cart");
        if (cart == null) {
            cart = new Cart();
            session.setAttribute("cart", cart);
        }
        return cart;
    }
}
