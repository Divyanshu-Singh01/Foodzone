package com.foodzone.dao;

import com.foodzone.config.DBConnection;
import com.foodzone.model.FoodItem;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

public class FoodItemDAO {

    public List<FoodItem> getAllItems() {
        List<FoodItem> list = new ArrayList<>();
        String sql = "SELECT f.*, c.category_name FROM food_items f "
                   + "JOIN categories c ON f.category_id = c.category_id "
                   + "ORDER BY f.food_id ASC";
        Connection conn = null;
        Statement stmt = null;
        ResultSet rs = null;
        try {
            conn = DBConnection.getConnection();
            stmt = conn.createStatement();
            rs = stmt.executeQuery(sql);
            while (rs.next()) {
                list.add(mapFoodItem(rs));
            }
        } catch (SQLException e) {
            System.err.println("[FoodItemDAO] getAllItems error: " + e.getMessage());
        } finally {
            DBConnection.close(conn, stmt, rs);
        }
        return list;
    }

    public List<FoodItem> getAvailableItems() {
        List<FoodItem> list = new ArrayList<>();
        String sql = "SELECT f.*, c.category_name FROM food_items f "
                   + "JOIN categories c ON f.category_id = c.category_id "
                   + "WHERE f.is_available = TRUE "
                   + "ORDER BY f.food_id ASC";
        Connection conn = null;
        Statement stmt = null;
        ResultSet rs = null;
        try {
            conn = DBConnection.getConnection();
            stmt = conn.createStatement();
            rs = stmt.executeQuery(sql);
            while (rs.next()) {
                list.add(mapFoodItem(rs));
            }
        } catch (SQLException e) {
            System.err.println("[FoodItemDAO] getAvailableItems error: " + e.getMessage());
        } finally {
            DBConnection.close(conn, stmt, rs);
        }
        return list;
    }

    public List<FoodItem> getItemsByCategory(int categoryId) {
        List<FoodItem> list = new ArrayList<>();
        String sql = "SELECT f.*, c.category_name FROM food_items f "
                   + "JOIN categories c ON f.category_id = c.category_id "
                   + "WHERE f.category_id = ? AND f.is_available = TRUE "
                   + "ORDER BY f.food_id ASC";
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        try {
            conn = DBConnection.getConnection();
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, categoryId);
            rs = stmt.executeQuery();
            while (rs.next()) {
                list.add(mapFoodItem(rs));
            }
        } catch (SQLException e) {
            System.err.println("[FoodItemDAO] getItemsByCategory error: " + e.getMessage());
        } finally {
            DBConnection.close(conn, stmt, rs);
        }
        return list;
    }

    public List<FoodItem> searchItems(String keyword, Integer categoryId) {
        List<FoodItem> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder(
            "SELECT f.*, c.category_name FROM food_items f "
          + "JOIN categories c ON f.category_id = c.category_id WHERE 1=1 "
        );

        if (categoryId != null && categoryId > 0) {
            sql.append("AND f.category_id = ? ");
        }
        if (keyword != null && !keyword.trim().isEmpty()) {
            sql.append("AND (LOWER(f.food_name) LIKE ? OR LOWER(f.description) LIKE ?) ");
        }
        sql.append("ORDER BY f.food_id ASC");

        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        try {
            conn = DBConnection.getConnection();
            stmt = conn.prepareStatement(sql.toString());
            int idx = 1;
            if (categoryId != null && categoryId > 0) {
                stmt.setInt(idx++, categoryId);
            }
            if (keyword != null && !keyword.trim().isEmpty()) {
                String pattern = "%" + keyword.trim().toLowerCase() + "%";
                stmt.setString(idx++, pattern);
                stmt.setString(idx++, pattern);
            }
            rs = stmt.executeQuery();
            while (rs.next()) {
                list.add(mapFoodItem(rs));
            }
        } catch (SQLException e) {
            System.err.println("[FoodItemDAO] searchItems error: " + e.getMessage());
        } finally {
            DBConnection.close(conn, stmt, rs);
        }
        return list;
    }

    public FoodItem getItemById(int foodId) {
        String sql = "SELECT f.*, c.category_name FROM food_items f "
                   + "JOIN categories c ON f.category_id = c.category_id "
                   + "WHERE f.food_id = ?";
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        try {
            conn = DBConnection.getConnection();
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, foodId);
            rs = stmt.executeQuery();
            if (rs.next()) {
                return mapFoodItem(rs);
            }
        } catch (SQLException e) {
            System.err.println("[FoodItemDAO] getItemById error: " + e.getMessage());
        } finally {
            DBConnection.close(conn, stmt, rs);
        }
        return null;
    }

    public boolean addItem(FoodItem item) {
        String sql = "INSERT INTO food_items (category_id, food_name, description, price, image_url, is_veg, is_available) "
                   + "VALUES (?, ?, ?, ?, ?, ?, ?)";
        Connection conn = null;
        PreparedStatement stmt = null;
        try {
            conn = DBConnection.getConnection();
            stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            stmt.setInt(1, item.getCategoryId());
            stmt.setString(2, item.getFoodName());
            stmt.setString(3, item.getDescription());
            stmt.setBigDecimal(4, item.getPrice());
            stmt.setString(5, item.getImageUrl());
            stmt.setBoolean(6, item.isVeg());
            stmt.setBoolean(7, item.isAvailable());

            int rows = stmt.executeUpdate();
            if (rows > 0) {
                try (ResultSet rs = stmt.getGeneratedKeys()) {
                    if (rs.next()) item.setFoodId(rs.getInt(1));
                }
                return true;
            }
        } catch (SQLException e) {
            System.err.println("[FoodItemDAO] addItem error: " + e.getMessage());
        } finally {
            DBConnection.close(conn, stmt);
        }
        return false;
    }

    public boolean updateItem(FoodItem item) {
        String sql = "UPDATE food_items SET category_id = ?, food_name = ?, description = ?, "
                   + "price = ?, image_url = ?, is_veg = ?, is_available = ? WHERE food_id = ?";
        Connection conn = null;
        PreparedStatement stmt = null;
        try {
            conn = DBConnection.getConnection();
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, item.getCategoryId());
            stmt.setString(2, item.getFoodName());
            stmt.setString(3, item.getDescription());
            stmt.setBigDecimal(4, item.getPrice());
            stmt.setString(5, item.getImageUrl());
            stmt.setBoolean(6, item.isVeg());
            stmt.setBoolean(7, item.isAvailable());
            stmt.setInt(8, item.getFoodId());
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("[FoodItemDAO] updateItem error: " + e.getMessage());
        } finally {
            DBConnection.close(conn, stmt);
        }
        return false;
    }

    public boolean deleteItem(int foodId) {
        String sql = "DELETE FROM food_items WHERE food_id = ?";
        Connection conn = null;
        PreparedStatement stmt = null;
        try {
            conn = DBConnection.getConnection();
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, foodId);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("[FoodItemDAO] deleteItem error: " + e.getMessage());
        } finally {
            DBConnection.close(conn, stmt);
        }
        return false;
    }

    public int getTotalItemCount() {
        String sql = "SELECT COUNT(*) FROM food_items";
        Connection conn = null;
        Statement stmt = null;
        ResultSet rs = null;
        try {
            conn = DBConnection.getConnection();
            stmt = conn.createStatement();
            rs = stmt.executeQuery(sql);
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) {
            System.err.println("[FoodItemDAO] getTotalItemCount error: " + e.getMessage());
        } finally {
            DBConnection.close(conn, stmt, rs);
        }
        return 0;
    }

    private FoodItem mapFoodItem(ResultSet rs) throws SQLException {
        FoodItem item = new FoodItem();
        item.setFoodId(rs.getInt("food_id"));
        item.setCategoryId(rs.getInt("category_id"));
        item.setFoodName(rs.getString("food_name"));
        item.setDescription(rs.getString("description"));
        item.setPrice(rs.getBigDecimal("price"));
        item.setImageUrl(rs.getString("image_url"));
        item.setVeg(rs.getBoolean("is_veg"));
        item.setAvailable(rs.getBoolean("is_available"));
        item.setCreatedAt(rs.getTimestamp("created_at"));
        try {
            item.setCategoryName(rs.getString("category_name"));
        } catch (SQLException ignored) {}
        return item;
    }
}
