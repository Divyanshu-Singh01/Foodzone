package com.foodzone.controller;

import com.foodzone.dao.CategoryDAO;
import com.foodzone.dao.FoodItemDAO;
import com.foodzone.model.Category;
import com.foodzone.model.FoodItem;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

@WebServlet(urlPatterns = {"", "/home"})
public class HomeServlet extends HttpServlet {

    private final CategoryDAO categoryDAO = new CategoryDAO();
    private final FoodItemDAO foodItemDAO = new FoodItemDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<Category> categories = categoryDAO.getAllCategories();
        List<FoodItem> featuredItems = foodItemDAO.getAvailableItems();

        if (featuredItems.size() > 6) {
            featuredItems = featuredItems.subList(0, 6);
        }

        request.setAttribute("categories", categories);
        request.setAttribute("featuredItems", featuredItems);
        request.getRequestDispatcher("/WEB-INF/views/customer/home.jsp").forward(request, response);
    }
}
