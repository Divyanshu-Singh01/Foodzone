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

@WebServlet("/menu")
public class MenuServlet extends HttpServlet {

    private final CategoryDAO categoryDAO = new CategoryDAO();
    private final FoodItemDAO foodItemDAO = new FoodItemDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String categoryParam = request.getParameter("category");
        String searchParam = request.getParameter("q");

        Integer categoryId = null;
        if (categoryParam != null && !categoryParam.trim().isEmpty()) {
            try {
                categoryId = Integer.parseInt(categoryParam.trim());
            } catch (NumberFormatException ignored) {}
        }

        List<FoodItem> items;
        if ((searchParam != null && !searchParam.trim().isEmpty()) || (categoryId != null && categoryId > 0)) {
            items = foodItemDAO.searchItems(searchParam, categoryId);
        } else {
            items = foodItemDAO.getAvailableItems();
        }

        List<Category> categories = categoryDAO.getAllCategories();

        request.setAttribute("foodItems", items);
        request.setAttribute("categories", categories);
        request.setAttribute("selectedCategoryId", categoryId);
        request.setAttribute("searchQuery", searchParam);

        request.getRequestDispatcher("/WEB-INF/views/customer/menu.jsp").forward(request, response);
    }
}
