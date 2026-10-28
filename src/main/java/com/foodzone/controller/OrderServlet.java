package com.foodzone.controller;

import com.foodzone.dao.OrderDAO;
import com.foodzone.model.Order;
import com.foodzone.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

@WebServlet(urlPatterns = {"/orders", "/order-details"})
public class OrderServlet extends HttpServlet {

    private final OrderDAO orderDAO = new OrderDAO();

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

        if ("/order-details".equals(path)) {
            String idParam = request.getParameter("id");
            if (idParam != null) {
                try {
                    int orderId = Integer.parseInt(idParam.trim());
                    Order order = orderDAO.getOrderById(orderId);
                    // Ensure customer can only view their own order unless admin
                    if (order != null && (order.getUserId() == user.getUserId() || user.isAdmin())) {
                        request.setAttribute("order", order);
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
}
