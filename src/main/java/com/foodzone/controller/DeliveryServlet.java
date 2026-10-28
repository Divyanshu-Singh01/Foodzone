package com.foodzone.controller;

import com.foodzone.dao.OrderDAO;
import com.foodzone.dao.UserDAO;
import com.foodzone.model.Order;
import com.foodzone.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

@WebServlet(urlPatterns = {"/delivery", "/delivery/dashboard", "/delivery/orders"})
public class DeliveryServlet extends HttpServlet {

    private final OrderDAO orderDAO = new OrderDAO();
    private final UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User sessionUser = (session != null) ? (User) session.getAttribute("currentUser") : null;

        if (sessionUser == null || (!"DELIVERY".equalsIgnoreCase(sessionUser.getRole()) && !"ADMIN".equalsIgnoreCase(sessionUser.getRole()))) {
            response.sendRedirect(request.getContextPath() + "/login?error=rider_access_required");
            return;
        }

        // Fetch fresh rider record
        User rider = userDAO.getUserById(sessionUser.getUserId());
        if (rider == null) rider = sessionUser;
        session.setAttribute("currentUser", rider);

        boolean hasActive = orderDAO.hasActiveDelivery(rider.getUserId());
        List<Order> availableOrders = new ArrayList<>();
        if (rider.getIsOnDuty() && !hasActive) {
            availableOrders = orderDAO.getAvailableUnassignedOrders();
        }

        // Support Ajax Polling for live radar!
        String accept = request.getHeader("Accept");
        if ("poll".equalsIgnoreCase(request.getParameter("ajax")) || (accept != null && accept.contains("application/json"))) {
            response.setContentType("application/json;charset=UTF-8");
            response.getWriter().write("{"
                + "\"success\":true,"
                + "\"isOnDuty\":" + rider.getIsOnDuty() + ","
                + "\"hasActiveDelivery\":" + hasActive + ","
                + "\"availableCount\":" + availableOrders.size()
                + "}");
            return;
        }

        List<Order> allAssigned = orderDAO.getOrdersByRiderId(rider.getUserId());
        List<Order> activeDeliveries = new ArrayList<>();
        List<Order> completedDeliveries = new ArrayList<>();

        for (Order o : allAssigned) {
            if ("OUT_FOR_DELIVERY".equalsIgnoreCase(o.getOrderStatus())) {
                activeDeliveries.add(o);
            } else if ("COMPLETED".equalsIgnoreCase(o.getOrderStatus())) {
                completedDeliveries.add(o);
            }
        }

        Map<String, Object> shiftStats = orderDAO.getRiderShiftStats(rider.getUserId());

        request.setAttribute("activeDeliveries", activeDeliveries);
        request.setAttribute("completedDeliveries", completedDeliveries);
        request.setAttribute("availableOrders", availableOrders);
        request.setAttribute("hasActiveDelivery", hasActive);
        request.setAttribute("shiftStats", shiftStats);
        request.setAttribute("rider", rider);

        request.getRequestDispatcher("/WEB-INF/views/delivery/dashboard.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User rider = (session != null) ? (User) session.getAttribute("currentUser") : null;

        if (rider == null || (!"DELIVERY".equalsIgnoreCase(rider.getRole()) && !"ADMIN".equalsIgnoreCase(rider.getRole()))) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String action = request.getParameter("action");

        // First-Come, First-Served Atomic Delivery Request Claim
        if ("accept-trip".equalsIgnoreCase(action) || "claim-order".equalsIgnoreCase(action)) {
            // 1. Shift Check: Rider must be on duty
            if (!rider.getIsOnDuty()) {
                response.sendRedirect(request.getContextPath() + "/delivery/dashboard?error=must_be_on_duty");
                return;
            }

            // 2. 1-Trip Limit Check: Rider cannot have more than 1 active delivery
            if (orderDAO.hasActiveDelivery(rider.getUserId())) {
                response.sendRedirect(request.getContextPath() + "/delivery/dashboard?error=active_trip_limit");
                return;
            }

            String orderIdStr = request.getParameter("orderId");
            if (orderIdStr != null && !orderIdStr.trim().isEmpty()) {
                try {
                    int orderId = Integer.parseInt(orderIdStr.trim());
                    boolean claimed = orderDAO.claimOrder(orderId, rider.getUserId());
                    if (claimed) {
                        response.sendRedirect(request.getContextPath() + "/delivery/dashboard?msg=trip_claimed&orderId=" + orderId);
                        return;
                    } else {
                        // Order was already claimed by another rider first, or rider already has an active order
                        if (orderDAO.hasActiveDelivery(rider.getUserId())) {
                            response.sendRedirect(request.getContextPath() + "/delivery/dashboard?error=active_trip_limit");
                        } else {
                            response.sendRedirect(request.getContextPath() + "/delivery/dashboard?error=trip_already_claimed&orderId=" + orderId);
                        }
                        return;
                    }
                } catch (NumberFormatException ignored) {}
            }
            response.sendRedirect(request.getContextPath() + "/delivery/dashboard");
            return;
        }

        if ("toggle-duty".equalsIgnoreCase(action)) {
            boolean newDuty = !rider.getIsOnDuty();
            userDAO.toggleRiderDuty(rider.getUserId(), newDuty);
            rider.setIsOnDuty(newDuty);
            session.setAttribute("currentUser", rider);

            String isAjax = request.getHeader("X-Requested-With");
            String accept = request.getHeader("Accept");
            if ("XMLHttpRequest".equalsIgnoreCase(isAjax) || (accept != null && accept.contains("application/json")) || "true".equalsIgnoreCase(request.getParameter("ajax"))) {
                response.setContentType("application/json;charset=UTF-8");
                response.getWriter().write("{\"success\":true,\"isOnDuty\":" + newDuty + ",\"label\":\"" + (newDuty ? "ON DUTY (ACCEPTING)" : "OFF DUTY (PAUSED)") + "\"}");
                return;
            }

            String redirect = request.getParameter("redirect");
            if (redirect != null && !redirect.trim().isEmpty() && !redirect.contains("login")) {
                String target = redirect.startsWith("/") ? redirect : "/" + redirect;
                response.sendRedirect(request.getContextPath() + target + (target.contains("?") ? "&" : "?") + "msg=duty_toggled");
                return;
            }
            response.sendRedirect(request.getContextPath() + "/delivery/dashboard?msg=duty_toggled");
            return;
        }

        if ("pickup".equalsIgnoreCase(action)) {
            String orderIdStr = request.getParameter("orderId");
            if (orderIdStr != null) {
                try {
                    int orderId = Integer.parseInt(orderIdStr.trim());
                    orderDAO.updateTripStage(orderId, rider.getUserId(), "PICKED_UP");
                    response.sendRedirect(request.getContextPath() + "/delivery/dashboard?msg=picked_up&orderId=" + orderId);
                    return;
                } catch (NumberFormatException ignored) {}
            }
        }

        if ("arrive".equalsIgnoreCase(action)) {
            String orderIdStr = request.getParameter("orderId");
            if (orderIdStr != null) {
                try {
                    int orderId = Integer.parseInt(orderIdStr.trim());
                    orderDAO.updateTripStage(orderId, rider.getUserId(), "ARRIVED");
                    response.sendRedirect(request.getContextPath() + "/delivery/dashboard?msg=arrived&orderId=" + orderId);
                    return;
                } catch (NumberFormatException ignored) {}
            }
        }

        if ("verify-delivery".equalsIgnoreCase(action) || "verify-otp".equalsIgnoreCase(action)) {
            String orderIdStr = request.getParameter("orderId");
            String inputOtp = request.getParameter("deliveryOtp");
            if (inputOtp == null || inputOtp.trim().isEmpty()) {
                inputOtp = request.getParameter("otp");
            }

            String cashReceivedStr = request.getParameter("cashReceived");
            BigDecimal cashReceived = null;
            if (cashReceivedStr != null && !cashReceivedStr.trim().isEmpty()) {
                try {
                    cashReceived = new BigDecimal(cashReceivedStr.trim());
                } catch (NumberFormatException ignored) {}
            }
            String deliveryNote = request.getParameter("deliveryNote");

            if (orderIdStr != null && inputOtp != null) {
                try {
                    int orderId = Integer.parseInt(orderIdStr.trim());
                    boolean verified = orderDAO.verifyAndCompleteOrder(orderId, rider.getUserId(), inputOtp.trim(), cashReceived, deliveryNote);

                    if (verified) {
                        response.sendRedirect(request.getContextPath() + "/delivery/dashboard?msg=delivery_success&orderId=" + orderId);
                        return;
                    } else {
                        response.sendRedirect(request.getContextPath() + "/delivery/dashboard?error=invalid_otp&orderId=" + orderId);
                        return;
                    }
                } catch (NumberFormatException ignored) {}
            }
        }

        response.sendRedirect(request.getContextPath() + "/delivery/dashboard");
    }
}
