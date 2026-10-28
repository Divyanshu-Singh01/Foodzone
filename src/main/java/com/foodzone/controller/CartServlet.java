package com.foodzone.controller;

import com.foodzone.dao.FoodItemDAO;
import com.foodzone.model.Cart;
import com.foodzone.model.FoodItem;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet("/cart")
public class CartServlet extends HttpServlet {

    private final FoodItemDAO foodItemDAO = new FoodItemDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        getOrCreateCart(request);
        request.getRequestDispatcher("/WEB-INF/views/customer/cart.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        Cart cart = getOrCreateCart(request);

        if ("add".equalsIgnoreCase(action)) {
            handleAdd(request, cart);
        } else if ("update".equalsIgnoreCase(action)) {
            handleUpdate(request, cart);
        } else if ("remove".equalsIgnoreCase(action)) {
            handleRemove(request, cart);
        } else if ("clear".equalsIgnoreCase(action)) {
            cart.clear();
        }

        String referer = request.getHeader("Referer");
        if (referer != null && !referer.contains("/cart")) {
            response.sendRedirect(referer + (referer.contains("?") ? "&" : "?") + "msg=cart_updated");
        } else {
            response.sendRedirect(request.getContextPath() + "/cart");
        }
    }

    private void handleAdd(HttpServletRequest request, Cart cart) {
        try {
            int foodId = Integer.parseInt(request.getParameter("foodId"));
            int qty = 1;
            String qtyParam = request.getParameter("quantity");
            if (qtyParam != null && !qtyParam.trim().isEmpty()) {
                qty = Math.max(1, Integer.parseInt(qtyParam.trim()));
            }

            FoodItem item = foodItemDAO.getItemById(foodId);
            if (item != null && item.isAvailable()) {
                cart.addItem(item, qty);
            }
        } catch (Exception e) {
            System.err.println("[CartServlet] handleAdd error: " + e.getMessage());
        }
    }

    private void handleUpdate(HttpServletRequest request, Cart cart) {
        try {
            int foodId = Integer.parseInt(request.getParameter("foodId"));
            int qty = Integer.parseInt(request.getParameter("quantity"));
            cart.updateQuantity(foodId, qty);
        } catch (Exception e) {
            System.err.println("[CartServlet] handleUpdate error: " + e.getMessage());
        }
    }

    private void handleRemove(HttpServletRequest request, Cart cart) {
        try {
            int foodId = Integer.parseInt(request.getParameter("foodId"));
            cart.removeItem(foodId);
        } catch (Exception e) {
            System.err.println("[CartServlet] handleRemove error: " + e.getMessage());
        }
    }

    private Cart getOrCreateCart(HttpServletRequest request) {
        HttpSession session = request.getSession(true);
        Cart cart = (Cart) session.getAttribute("cart");
        if (cart == null) {
            cart = new Cart();
            session.setAttribute("cart", cart);
        }
        return cart;
    }
}
