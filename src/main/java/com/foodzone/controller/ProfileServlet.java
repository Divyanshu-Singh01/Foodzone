package com.foodzone.controller;

import com.foodzone.dao.FoodItemDAO;
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
import java.util.List;
import java.util.Map;

@WebServlet(urlPatterns = {"/profile", "/delivery/profile", "/admin/profile"})
public class ProfileServlet extends HttpServlet {

    private final UserDAO userDAO = new UserDAO();
    private final OrderDAO orderDAO = new OrderDAO();
    private final FoodItemDAO foodDAO = new FoodItemDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("currentUser") == null) {
            response.sendRedirect(request.getContextPath() + "/login?error=auth_required");
            return;
        }

        User sessionUser = (User) session.getAttribute("currentUser");
        User user = userDAO.getUserById(sessionUser.getUserId());
        if (user == null) user = sessionUser;
        session.setAttribute("currentUser", user);

        String path = request.getServletPath();

        // Delivery Partner Profile
        if ("/delivery/profile".equals(path) || (user.isDelivery() && "/profile".equals(path))) {
            Map<String, Object> shiftStats = orderDAO.getRiderShiftStats(user.getUserId());
            request.setAttribute("rider", user);
            request.setAttribute("shiftStats", shiftStats);
            request.getRequestDispatcher("/WEB-INF/views/delivery/profile.jsp").forward(request, response);
            return;
        }

        // Admin Profile
        if ("/admin/profile".equals(path) || (user.isAdmin() && "/profile".equals(path))) {
            int totalOrders = orderDAO.getTotalOrderCount();
            int totalCustomers = userDAO.getCustomerCount();
            int totalItems = foodDAO.getAllItems().size();
            request.setAttribute("admin", user);
            request.setAttribute("totalOrders", totalOrders);
            request.setAttribute("totalCustomers", totalCustomers);
            request.setAttribute("totalItems", totalItems);
            request.getRequestDispatcher("/WEB-INF/views/admin/profile.jsp").forward(request, response);
            return;
        }

        // Customer Profile
        Map<String, Object> stats = orderDAO.getCustomerStats(user.getUserId());
        List<Order> orders = orderDAO.getOrdersByUserId(user.getUserId());
        request.setAttribute("user", user);
        request.setAttribute("stats", stats);
        request.setAttribute("recentOrders", orders != null && orders.size() > 5 ? orders.subList(0, 5) : orders);
        request.getRequestDispatcher("/WEB-INF/views/customer/profile.jsp").forward(request, response);
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
        String path = request.getServletPath();

        if (user.isDelivery() || "/delivery/profile".equals(path)) {
            String fullName = request.getParameter("fullName");
            String phone = request.getParameter("phone");
            String vehicleNo = request.getParameter("vehicleNo");
            String vehicleType = request.getParameter("vehicleType");
            String licenseNo = request.getParameter("licenseNo");
            String emergencyPhone = request.getParameter("emergencyPhone");

            userDAO.updateRiderProfile(user.getUserId(), fullName, phone, vehicleNo, vehicleType, licenseNo, emergencyPhone);

            // Refresh session
            User fresh = userDAO.getUserById(user.getUserId());
            session.setAttribute("currentUser", fresh);
            response.sendRedirect(request.getContextPath() + "/delivery/profile?msg=profile_updated");
            return;
        }

        // Customer or Admin update
        String fullName = request.getParameter("fullName");
        String phone = request.getParameter("phone");
        String address = request.getParameter("address");

        userDAO.updateUserProfile(user.getUserId(), fullName, phone, address);

        User fresh = userDAO.getUserById(user.getUserId());
        session.setAttribute("currentUser", fresh);

        if (user.isAdmin() || "/admin/profile".equals(path)) {
            response.sendRedirect(request.getContextPath() + "/admin/profile?msg=profile_updated");
        } else {
            response.sendRedirect(request.getContextPath() + "/profile?msg=profile_updated");
        }
    }
}
