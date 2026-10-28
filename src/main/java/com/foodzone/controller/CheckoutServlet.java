package com.foodzone.controller;

import com.foodzone.dao.OrderDAO;
import com.foodzone.model.Cart;
import com.foodzone.model.CartItem;
import com.foodzone.model.Order;
import com.foodzone.model.OrderItem;
import com.foodzone.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@WebServlet(urlPatterns = {"/checkout", "/order-confirmation"})
public class CheckoutServlet extends HttpServlet {

    private final OrderDAO orderDAO = new OrderDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String path = request.getServletPath();

        if ("/order-confirmation".equals(path)) {
            String orderIdStr = request.getParameter("orderId");
            if (orderIdStr == null || orderIdStr.trim().isEmpty()) {
                orderIdStr = request.getParameter("id");
            }
            if (orderIdStr != null) {
                try {
                    int orderId = Integer.parseInt(orderIdStr.trim());
                    Order order = orderDAO.getOrderById(orderId);
                    if (order != null) {
                        request.setAttribute("order", order);
                        request.getRequestDispatcher("/WEB-INF/views/customer/order-confirmation.jsp").forward(request, response);
                        return;
                    }
                } catch (NumberFormatException ignored) {}
            }
            response.sendRedirect(request.getContextPath() + "/orders");
            return;
        }

        // Default: /checkout
        HttpSession session = request.getSession(false);
        Cart cart = (session != null) ? (Cart) session.getAttribute("cart") : null;

        if (cart == null || cart.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/menu?msg=cart_empty");
            return;
        }

        request.getRequestDispatcher("/WEB-INF/views/customer/checkout.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        User user = (User) session.getAttribute("currentUser");
        Cart cart = (Cart) session.getAttribute("cart");

        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login?error=auth_required");
            return;
        }

        if (cart == null || cart.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/menu");
            return;
        }

        String orderType = request.getParameter("orderType");
        if (orderType == null || orderType.trim().isEmpty()) {
            orderType = cart.getOrderType();
        }
        if (orderType == null || (!"TAKEAWAY".equalsIgnoreCase(orderType) && !"DELIVERY".equalsIgnoreCase(orderType))) {
            orderType = "DELIVERY";
        }
        cart.setOrderType(orderType);

        String deliveryAddress = request.getParameter("deliveryAddress");
        String contactPhone = request.getParameter("contactPhone");
        String paymentMethod = request.getParameter("paymentMethod");
        String specialNotes = request.getParameter("specialNotes");
        String landmark = request.getParameter("landmark");
        String addressType = request.getParameter("addressType");
        String deliveryInstructions = request.getParameter("deliveryInstructions");
        String alternatePhone = request.getParameter("alternatePhone");

        if ("TAKEAWAY".equalsIgnoreCase(orderType) && (deliveryAddress == null || deliveryAddress.trim().isEmpty())) {
            deliveryAddress = "Store Takeaway (FoodZone Central Kitchen, Indirapuram)";
        }

        if (deliveryAddress == null || contactPhone == null ||
            deliveryAddress.trim().isEmpty() || contactPhone.trim().isEmpty()) {
            request.setAttribute("errorMessage", "Delivery address and contact phone are required.");
            request.getRequestDispatcher("/WEB-INF/views/customer/checkout.jsp").forward(request, response);
            return;
        }

        // Generate 4-digit secure delivery OTP
        String deliveryOtp = String.format("%04d", new java.util.Random().nextInt(10000));

        Order order = new Order();
        order.setUserId(user.getUserId());
        order.setOrderType(orderType.toUpperCase());
        order.setSubtotal(cart.getSubtotal());
        order.setTaxAmount(cart.getTaxAmount());
        order.setDeliveryFee(cart.getDeliveryFee());
        order.setDiscountAmount(cart.getDiscountAmount());
        order.setCouponCode(cart.getCouponCode());
        order.setTotalAmount(cart.getTotalAmount());
        order.setOrderStatus("PENDING");
        order.setDeliveryAddress(deliveryAddress.trim());
        order.setContactPhone(contactPhone.trim());
        order.setPaymentMethod(paymentMethod != null ? paymentMethod : "Cash on Delivery");
        order.setDeliveryOtp(deliveryOtp);
        order.setSpecialNotes(specialNotes != null ? specialNotes.trim() : "");
        order.setLandmark(landmark != null ? landmark.trim() : "");
        order.setAddressType(addressType != null ? addressType.trim().toUpperCase() : "HOME");
        order.setDeliveryInstructions(deliveryInstructions != null ? deliveryInstructions.trim() : "");
        order.setAlternatePhone(alternatePhone != null ? alternatePhone.trim() : "");

        List<OrderItem> items = new ArrayList<>();
        for (CartItem ci : cart.getItems()) {
            OrderItem oi = new OrderItem();
            oi.setFoodId(ci.getFoodItem().getFoodId());
            oi.setQuantity(ci.getQuantity());
            oi.setUnitPrice(ci.getFoodItem().getPrice());
            oi.setSubtotal(ci.getSubtotal());
            items.add(oi);
        }

        try {
            boolean success = orderDAO.placeOrder(order, items);
            if (success) {
                cart.clear(); // Empty cart upon successful order
                response.sendRedirect(request.getContextPath() + "/order-confirmation?orderId=" + order.getOrderId());
            } else {
                request.setAttribute("errorMessage", "Failed to place order. Please try again.");
                request.getRequestDispatcher("/WEB-INF/views/customer/checkout.jsp").forward(request, response);
            }
        } catch (Exception e) {
            System.err.println("[CheckoutServlet] Error placing order: " + e.getMessage());
            request.setAttribute("errorMessage", "Order failed: " + e.getMessage());
            request.getRequestDispatcher("/WEB-INF/views/customer/checkout.jsp").forward(request, response);
        }
    }
}
