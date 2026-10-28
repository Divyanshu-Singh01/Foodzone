package com.foodzone.controller.admin;

import com.foodzone.dao.FoodItemDAO;
import com.foodzone.dao.OrderDAO;
import com.foodzone.dao.UserDAO;
import com.foodzone.model.Order;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.math.BigDecimal;
import java.util.List;

@WebServlet("/admin/dashboard")
public class AdminDashboardServlet extends HttpServlet {

    private final OrderDAO orderDAO = new OrderDAO();
    private final FoodItemDAO foodItemDAO = new FoodItemDAO();
    private final UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        BigDecimal totalRevenue = orderDAO.getTotalRevenue();
        int totalOrders = orderDAO.getTotalOrderCount();
        int pendingOrders = orderDAO.getPendingOrderCount();
        int totalItems = foodItemDAO.getTotalItemCount();
        int totalCustomers = userDAO.getCustomerCount();
        List<Order> recentOrders = orderDAO.getRecentOrders(5);

        request.setAttribute("totalRevenue", totalRevenue);
        request.setAttribute("totalOrders", totalOrders);
        request.setAttribute("pendingOrders", pendingOrders);
        request.setAttribute("totalItems", totalItems);
        request.setAttribute("totalCustomers", totalCustomers);
        request.setAttribute("recentOrders", recentOrders);

        request.getRequestDispatcher("/WEB-INF/views/admin/dashboard.jsp").forward(request, response);
    }
}
