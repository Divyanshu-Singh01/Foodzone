package com.foodzone.controller;

import com.foodzone.dao.UserDAO;
import com.foodzone.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet(urlPatterns = {"/login", "/register", "/rider-register", "/delivery/signup", "/logout"})
public class AuthServlet extends HttpServlet {

    private final UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String path = request.getServletPath();

        if ("/logout".equals(path)) {
            HttpSession session = request.getSession(false);
            if (session != null) {
                session.invalidate();
            }
            response.sendRedirect(request.getContextPath() + "/login?msg=logged_out");
            return;
        }

        if ("/register".equals(path)) {
            request.getRequestDispatcher("/WEB-INF/views/auth/register.jsp").forward(request, response);
            return;
        }

        if ("/rider-register".equals(path) || "/delivery/signup".equals(path)) {
            request.getRequestDispatcher("/WEB-INF/views/auth/rider-register.jsp").forward(request, response);
            return;
        }

        // Default: /login
        request.getRequestDispatcher("/WEB-INF/views/auth/login.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String path = request.getServletPath();

        if ("/register".equals(path)) {
            handleRegister(request, response);
        } else if ("/rider-register".equals(path) || "/delivery/signup".equals(path)) {
            handleRiderRegister(request, response);
        } else if ("/login".equals(path)) {
            handleLogin(request, response);
        }
    }

    private void handleLogin(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String redirect = request.getParameter("redirect");

        if (email == null || email.trim().isEmpty() || password == null || password.trim().isEmpty()) {
            request.setAttribute("errorMessage", "Email and Password are required.");
            request.getRequestDispatcher("/WEB-INF/views/auth/login.jsp").forward(request, response);
            return;
        }

        User user = userDAO.authenticate(email, password);
        if (user != null) {
            HttpSession session = request.getSession(true);
            session.setAttribute("currentUser", user);
            session.setAttribute("userRole", user.getRole());

            if (user.isAdmin()) {
                response.sendRedirect(request.getContextPath() + "/admin/dashboard");
            } else if (user.isDelivery()) {
                response.sendRedirect(request.getContextPath() + "/delivery/dashboard");
            } else if (redirect != null && !redirect.trim().isEmpty()) {
                response.sendRedirect(redirect);
            } else {
                response.sendRedirect(request.getContextPath() + "/menu");
            }
        } else {
            request.setAttribute("errorMessage", "Invalid email or password.");
            request.setAttribute("email", email);
            request.getRequestDispatcher("/WEB-INF/views/auth/login.jsp").forward(request, response);
        }
    }

    private void handleRegister(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String fullName = request.getParameter("fullName");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");
        String phone = request.getParameter("phone");
        String address = request.getParameter("address");

        if (fullName == null || email == null || password == null || phone == null ||
            fullName.trim().isEmpty() || email.trim().isEmpty() || password.trim().isEmpty()) {
            request.setAttribute("errorMessage", "Please fill in all required fields.");
            forwardToRegister(request, response);
            return;
        }

        if (!password.equals(confirmPassword)) {
            request.setAttribute("errorMessage", "Passwords do not match.");
            forwardToRegister(request, response);
            return;
        }

        if (userDAO.findByEmail(email) != null) {
            request.setAttribute("errorMessage", "An account with this email already exists.");
            forwardToRegister(request, response);
            return;
        }

        User user = new User();
        user.setFullName(fullName.trim());
        user.setEmail(email.trim());
        user.setPasswordHash(password);
        user.setPhone(phone != null ? phone.trim() : "");
        user.setAddress(address != null ? address.trim() : "");
        user.setRole("CUSTOMER");

        boolean success = userDAO.register(user);
        if (success) {
            HttpSession session = request.getSession(true);
            session.setAttribute("currentUser", user);
            session.setAttribute("userRole", user.getRole());
            response.sendRedirect(request.getContextPath() + "/menu?msg=welcome");
        } else {
            request.setAttribute("errorMessage", "Registration failed due to a database error. Please try again.");
            forwardToRegister(request, response);
        }
    }

    private void forwardToRegister(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setAttribute("fullName", request.getParameter("fullName"));
        request.setAttribute("email", request.getParameter("email"));
        request.setAttribute("phone", request.getParameter("phone"));
        request.setAttribute("address", request.getParameter("address"));
        request.getRequestDispatcher("/WEB-INF/views/auth/register.jsp").forward(request, response);
    }

    private void handleRiderRegister(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String fullName = request.getParameter("fullName");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");
        String phone = request.getParameter("phone");
        String vehicleNo = request.getParameter("vehicleNo");
        String vehicleType = request.getParameter("vehicleType");
        String licenseNo = request.getParameter("licenseNo");
        String emergencyPhone = request.getParameter("emergencyPhone");
        String address = request.getParameter("address");

        if (fullName == null || email == null || password == null || phone == null ||
            vehicleNo == null || licenseNo == null ||
            fullName.trim().isEmpty() || email.trim().isEmpty() || password.trim().isEmpty() ||
            vehicleNo.trim().isEmpty() || licenseNo.trim().isEmpty()) {
            request.setAttribute("errorMessage", "Please fill in all mandatory fleet fields (Full Name, Email, Password, Phone, Vehicle Plate, Driving License).");
            forwardToRiderRegister(request, response);
            return;
        }

        if (!password.equals(confirmPassword)) {
            request.setAttribute("errorMessage", "Passwords do not match.");
            forwardToRiderRegister(request, response);
            return;
        }

        if (userDAO.findByEmail(email) != null) {
            request.setAttribute("errorMessage", "An account with this email address already exists. Please sign in or use another email.");
            forwardToRiderRegister(request, response);
            return;
        }

        User rider = new User();
        rider.setFullName(fullName.trim());
        rider.setEmail(email.trim());
        rider.setPasswordHash(password);
        rider.setPhone(phone.trim());
        rider.setAddress(address != null ? address.trim() : "");
        rider.setVehicleNo(vehicleNo.trim().toUpperCase());
        rider.setVehicleType(vehicleType != null && !vehicleType.trim().isEmpty() ? vehicleType.trim() : "Motorcycle");
        rider.setLicenseNo(licenseNo.trim().toUpperCase());
        rider.setEmergencyPhone(emergencyPhone != null ? emergencyPhone.trim() : "");
        rider.setRole("DELIVERY");
        rider.setActiveRider(true);
        rider.setOnDuty(true);

        boolean success = userDAO.registerRider(rider);
        if (success) {
            HttpSession session = request.getSession(true);
            session.setAttribute("currentUser", rider);
            session.setAttribute("userRole", rider.getRole());
            response.sendRedirect(request.getContextPath() + "/delivery/dashboard?msg=welcome_rider");
        } else {
            request.setAttribute("errorMessage", "Delivery partner registration failed due to a database error. Please try again.");
            forwardToRiderRegister(request, response);
        }
    }

    private void forwardToRiderRegister(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setAttribute("fullName", request.getParameter("fullName"));
        request.setAttribute("email", request.getParameter("email"));
        request.setAttribute("phone", request.getParameter("phone"));
        request.setAttribute("vehicleNo", request.getParameter("vehicleNo"));
        request.setAttribute("vehicleType", request.getParameter("vehicleType"));
        request.setAttribute("licenseNo", request.getParameter("licenseNo"));
        request.setAttribute("emergencyPhone", request.getParameter("emergencyPhone"));
        request.setAttribute("address", request.getParameter("address"));
        request.getRequestDispatcher("/WEB-INF/views/auth/rider-register.jsp").forward(request, response);
    }
}
