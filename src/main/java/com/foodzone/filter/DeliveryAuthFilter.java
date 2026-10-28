package com.foodzone.filter;

import com.foodzone.model.User;
import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

/**
 * Security Filter for Delivery Partner portal routes (/delivery/*).
 * Ensures only authenticated users with role DELIVERY (or ADMIN) can enter.
 */
@WebFilter("/delivery/*")
public class DeliveryAuthFilter implements Filter {

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse res = (HttpServletResponse) response;

        HttpSession session = req.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("currentUser") : null;

        if (user == null) {
            res.sendRedirect(req.getContextPath() + "/login?error=auth_required&redirect=" + req.getRequestURI());
            return;
        }

        if (!user.isDelivery() && !user.isAdmin()) {
            res.sendRedirect(req.getContextPath() + "/home?error=forbidden");
            return;
        }

        chain.doFilter(request, response);
    }
}
