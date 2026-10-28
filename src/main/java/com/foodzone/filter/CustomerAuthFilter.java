package com.foodzone.filter;

import com.foodzone.model.User;
import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.FilterConfig;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebFilter(urlPatterns = {"/checkout", "/orders", "/order-details", "/order-confirmation"})
public class CustomerAuthFilter implements Filter {

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {}

    @Override
    public void doFilter(ServletRequest req, ServletResponse res, FilterChain chain)
            throws IOException, ServletException {
        HttpServletRequest request = (HttpServletRequest) req;
        HttpServletResponse response = (HttpServletResponse) res;

        HttpSession session = request.getSession(false);
        User currentUser = (session != null) ? (User) session.getAttribute("currentUser") : null;

        if (currentUser == null) {
            String target = request.getRequestURI();
            String query = request.getQueryString();
            if (query != null) target += "?" + query;
            response.sendRedirect(request.getContextPath() + "/login?error=auth_required&redirect=" + java.net.URLEncoder.encode(target, "UTF-8"));
            return;
        }

        chain.doFilter(req, res);
    }

    @Override
    public void destroy() {}
}
