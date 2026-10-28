package com.foodzone.controller.admin;

import com.foodzone.dao.OrderDAO;
import com.foodzone.dao.UserDAO;
import com.foodzone.model.Order;
import com.foodzone.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

@WebServlet("/admin/orders")
public class AdminOrderServlet extends HttpServlet {

    private final OrderDAO orderDAO = new OrderDAO();
    private final UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String filterStatus = request.getParameter("status");
        List<Order> orders = orderDAO.getAllOrders();
        List<User> deliveryRiders = userDAO.getAllDeliveryRiders();

        if (filterStatus != null && !filterStatus.trim().isEmpty() && !"ALL".equalsIgnoreCase(filterStatus)) {
            orders.removeIf(o -> !filterStatus.equalsIgnoreCase(o.getOrderStatus()));
        }

        request.setAttribute("orders", orders);
        request.setAttribute("deliveryRiders", deliveryRiders);
        request.setAttribute("filterStatus", filterStatus);
        request.getRequestDispatcher("/WEB-INF/views/admin/order-management.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        String orderIdStr = request.getParameter("orderId");
        String riderIdStr = request.getParameter("riderId");
        String newStatus = request.getParameter("newStatus");

        if (orderIdStr != null && !orderIdStr.trim().isEmpty()) {
            try {
                int orderId = Integer.parseInt(orderIdStr.trim());

                // 1. Explicit Rider Assignment action or riderId provided
                if ("assign-rider".equalsIgnoreCase(action) || (riderIdStr != null && !riderIdStr.trim().isEmpty())) {
                    if (riderIdStr != null && !riderIdStr.trim().isEmpty()) {
                        int riderId = Integer.parseInt(riderIdStr.trim());
                        if (riderId > 0) {
                            if (orderDAO.hasActiveDelivery(riderId, orderId)) {
                                response.sendRedirect(request.getContextPath() + "/admin/orders?error=rider_already_busy");
                                return;
                            }
                            boolean assigned = orderDAO.assignRider(orderId, riderId);
                            if (assigned) {
                                if (newStatus != null && !newStatus.trim().isEmpty() && !"OUT_FOR_DELIVERY".equalsIgnoreCase(newStatus)) {
                                    orderDAO.updateOrderStatus(orderId, newStatus.trim());
                                }
                                response.sendRedirect(request.getContextPath() + "/admin/orders?msg=rider_assigned");
                                return;
                            }
                        }
                    }
                    response.sendRedirect(request.getContextPath() + "/admin/orders?error=select_rider");
                    return;
                }

                // 2. Status Update
                if (newStatus != null && !newStatus.trim().isEmpty()) {
                    String status = newStatus.trim();
                    // If status is OUT_FOR_DELIVERY and order has no rider assigned, auto-assign first available on-duty rider
                    if ("OUT_FOR_DELIVERY".equalsIgnoreCase(status)) {
                        Order currentOrder = orderDAO.getOrderById(orderId);
                        if (currentOrder != null && "DELIVERY".equalsIgnoreCase(currentOrder.getOrderType()) && currentOrder.getRiderId() == null) {
                            List<User> activeRiders = userDAO.getAllDeliveryRiders();
                            if (activeRiders != null && !activeRiders.isEmpty()) {
                                User eligibleRider = null;
                                for (User r : activeRiders) {
                                    if (r.getIsOnDuty() && !orderDAO.hasActiveDelivery(r.getUserId())) {
                                        eligibleRider = r;
                                        break;
                                    }
                                }
                                if (eligibleRider == null && !activeRiders.isEmpty()) {
                                    // Fallback to first rider if no one is explicitly flagged on-duty
                                    for (User r : activeRiders) {
                                        if (!orderDAO.hasActiveDelivery(r.getUserId())) {
                                            eligibleRider = r;
                                            break;
                                        }
                                    }
                                }
                                if (eligibleRider != null) {
                                    orderDAO.assignRider(orderId, eligibleRider.getUserId());
                                    response.sendRedirect(request.getContextPath() + "/admin/orders?msg=rider_assigned");
                                    return;
                                }
                            }
                        }
                    }

                    orderDAO.updateOrderStatus(orderId, status);
                    response.sendRedirect(request.getContextPath() + "/admin/orders?msg=status_updated");
                    return;
                }

            } catch (Exception e) {
                System.err.println("[AdminOrderServlet] Error processing order update: " + e.getMessage());
            }
        }

        response.sendRedirect(request.getContextPath() + "/admin/orders");
    }
}
