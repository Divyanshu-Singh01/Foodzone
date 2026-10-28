package com.foodzone.controller.admin;

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
import java.math.BigDecimal;
import java.util.List;

@WebServlet("/admin/menu")
public class AdminMenuServlet extends HttpServlet {

    private final FoodItemDAO foodItemDAO = new FoodItemDAO();
    private final CategoryDAO categoryDAO = new CategoryDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String editIdStr = request.getParameter("editId");
        if (editIdStr != null) {
            try {
                int editId = Integer.parseInt(editIdStr.trim());
                FoodItem editItem = foodItemDAO.getItemById(editId);
                request.setAttribute("editItem", editItem);
            } catch (NumberFormatException ignored) {}
        }

        List<FoodItem> items = foodItemDAO.getAllItems();
        List<Category> categories = categoryDAO.getAllCategories();

        request.setAttribute("items", items);
        request.setAttribute("categories", categories);
        request.getRequestDispatcher("/WEB-INF/views/admin/menu-management.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");

        try {
            if ("add".equalsIgnoreCase(action)) {
                handleAdd(request);
            } else if ("update".equalsIgnoreCase(action)) {
                handleUpdate(request);
            } else if ("delete".equalsIgnoreCase(action)) {
                handleDelete(request);
            }
        } catch (Exception e) {
            System.err.println("[AdminMenuServlet] Error: " + e.getMessage());
        }

        response.sendRedirect(request.getContextPath() + "/admin/menu?msg=success");
    }

    private void handleAdd(HttpServletRequest request) {
        FoodItem item = extractFoodItem(request);
        foodItemDAO.addItem(item);
    }

    private void handleUpdate(HttpServletRequest request) {
        int foodId = Integer.parseInt(request.getParameter("foodId"));
        FoodItem item = extractFoodItem(request);
        item.setFoodId(foodId);
        foodItemDAO.updateItem(item);
    }

    private void handleDelete(HttpServletRequest request) {
        int foodId = Integer.parseInt(request.getParameter("foodId"));
        foodItemDAO.deleteItem(foodId);
    }

    private FoodItem extractFoodItem(HttpServletRequest request) {
        FoodItem item = new FoodItem();
        item.setCategoryId(Integer.parseInt(request.getParameter("categoryId")));
        item.setFoodName(request.getParameter("foodName").trim());
        item.setDescription(request.getParameter("description").trim());
        item.setPrice(new BigDecimal(request.getParameter("price").trim()));
        item.setImageUrl(request.getParameter("imageUrl").trim());
        item.setVeg("true".equalsIgnoreCase(request.getParameter("isVeg")) || "on".equalsIgnoreCase(request.getParameter("isVeg")));
        item.setAvailable("true".equalsIgnoreCase(request.getParameter("isAvailable")) || "on".equalsIgnoreCase(request.getParameter("isAvailable")));
        return item;
    }
}
