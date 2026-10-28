package com.foodzone.controller.admin;

import com.foodzone.dao.OrderDAO;
import com.foodzone.model.Order;
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

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String filterStatus = request.getParameter("status");
        List<Order> orders = orderDAO.getAllOrders();

        if (filterStatus != null && !filterStatus.trim().isEmpty() && !"ALL".equalsIgnoreCase(filterStatus)) {
            orders.removeIf(o -> !filterStatus.equalsIgnoreCase(o.getOrderStatus()));
        }

        request.setAttribute("orders", orders);
        request.setAttribute("filterStatus", filterStatus);
        request.getRequestDispatcher("/WEB-INF/views/admin/order-management.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String orderIdStr = request.getParameter("orderId");
        String newStatus = request.getParameter("newStatus");

        if (orderIdStr != null && newStatus != null) {
            try {
                int orderId = Integer.parseInt(orderIdStr.trim());
                orderDAO.updateOrderStatus(orderId, newStatus.trim());
            } catch (Exception e) {
                System.err.println("[AdminOrderServlet] Error updating status: " + e.getMessage());
            }
        }

        response.sendRedirect(request.getContextPath() + "/admin/orders?msg=status_updated");
    }
}
