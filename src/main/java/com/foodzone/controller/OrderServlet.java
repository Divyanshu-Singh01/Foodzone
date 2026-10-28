package com.foodzone.controller;

import com.foodzone.dao.OrderDAO;
import com.foodzone.dao.ReviewDAO;
import com.foodzone.model.Order;
import com.foodzone.model.Review;
import com.foodzone.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

@WebServlet(urlPatterns = {"/orders", "/order-details", "/order-status-api"})
public class OrderServlet extends HttpServlet {

    private final OrderDAO orderDAO = new OrderDAO();
    private final ReviewDAO reviewDAO = new ReviewDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("currentUser") == null) {
            response.sendRedirect(request.getContextPath() + "/login?error=auth_required");
            return;
        }

        User user = (User) session.getAttribute("currentUser");
        String path = request.getServletPath();

        // Real-time API for the Live Pizza Tracker
        if ("/order-status-api".equals(path)) {
            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            String idParam = request.getParameter("id");
            if (idParam == null || idParam.trim().isEmpty()) {
                idParam = request.getParameter("orderId");
            }
            if (idParam != null) {
                try {
                    int orderId = Integer.parseInt(idParam.trim());
                    Order order = orderDAO.getOrderById(orderId);
                    if (order != null && (order.getUserId() == user.getUserId() || user.isAdmin() || user.isDelivery())) {
                        String riderInfo = (order.getRiderName() != null) ? order.getRiderName() : "";
                        String json = String.format("{\"status\":\"%s\",\"orderType\":\"%s\",\"riderName\":\"%s\",\"riderPhone\":\"%s\",\"riderVehicle\":\"%s\",\"tripStage\":\"%s\"}",
                                order.getOrderStatus(),
                                order.getOrderType(),
                                riderInfo,
                                order.getRiderPhone() != null ? order.getRiderPhone() : "",
                                order.getRiderVehicle() != null ? order.getRiderVehicle() : "",
                                order.getTripStage() != null ? order.getTripStage() : "");
                        response.getWriter().write(json);
                        return;
                    }
                } catch (NumberFormatException ignored) {}
            }
            response.getWriter().write("{\"error\":\"not_found\"}");
            return;
        }

        if ("/order-details".equals(path)) {
            String idParam = request.getParameter("id");
            if (idParam != null) {
                try {
                    int orderId = Integer.parseInt(idParam.trim());
                    Order order = orderDAO.getOrderById(orderId);
                    if (order != null && (order.getUserId() == user.getUserId() || user.isAdmin() || user.isDelivery())) {
                        request.setAttribute("order", order);
                        Review existingReview = reviewDAO.getReviewByOrderId(orderId);
                        request.setAttribute("existingReview", existingReview);
                        request.getRequestDispatcher("/WEB-INF/views/customer/order-confirmation.jsp").forward(request, response);
                        return;
                    }
                } catch (NumberFormatException ignored) {}
            }
            response.sendRedirect(request.getContextPath() + "/orders");
            return;
        }

        // Default: /orders (order history)
        List<Order> orders = orderDAO.getOrdersByUserId(user.getUserId());
        request.setAttribute("orders", orders);
        request.getRequestDispatcher("/WEB-INF/views/customer/order-history.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("currentUser") == null) {
            response.sendRedirect(request.getContextPath() + "/login?error=auth_required");
            return;
        }

        User user = (User) session.getAttribute("currentUser");
        String action = request.getParameter("action");

        if ("review".equalsIgnoreCase(action)) {
            String idParam = request.getParameter("orderId");
            String ratingStr = request.getParameter("rating");
            String deliveryRatingStr = request.getParameter("deliveryRating");
            String reviewText = request.getParameter("reviewText");

            if (idParam != null && ratingStr != null) {
                try {
                    int orderId = Integer.parseInt(idParam.trim());
                    int rating = Integer.parseInt(ratingStr.trim());
                    int deliveryRating = 5;
                    if (deliveryRatingStr != null && !deliveryRatingStr.trim().isEmpty()) {
                        deliveryRating = Integer.parseInt(deliveryRatingStr.trim());
                    }
                    Review r = new Review();
                    r.setOrderId(orderId);
                    r.setUserId(user.getUserId());
                    r.setRating(rating);
                    r.setDeliveryRating(deliveryRating);
                    r.setReviewText(reviewText != null ? reviewText.trim() : "");

                    Order o = orderDAO.getOrderById(orderId);
                    if (o != null && o.getItems() != null && !o.getItems().isEmpty()) {
                        r.setFoodId(o.getItems().get(0).getFoodId());
                    }

                    boolean saved = reviewDAO.addReview(r);
                    if (saved) {
                        response.sendRedirect(request.getContextPath() + "/order-details?id=" + orderId + "&msg=review_submitted");
                        return;
                    }
                } catch (Exception ex) {
                    System.err.println("[OrderServlet] Review error: " + ex.getMessage());
                }
            }
        }

        if ("cancel".equalsIgnoreCase(action)) {
            String idParam = request.getParameter("orderId");
            if (idParam != null) {
                try {
                    int orderId = Integer.parseInt(idParam.trim());
                    boolean cancelled = orderDAO.cancelOrderByCustomer(orderId, user.getUserId());
                    if (cancelled) {
                        response.sendRedirect(request.getContextPath() + "/orders?msg=order_cancelled");
                        return;
                    }
                } catch (NumberFormatException ignored) {}
            }
        }

        response.sendRedirect(request.getContextPath() + "/orders");
    }
}
