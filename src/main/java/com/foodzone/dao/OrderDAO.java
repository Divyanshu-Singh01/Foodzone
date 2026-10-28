package com.foodzone.dao;

import com.foodzone.config.DBConnection;
import com.foodzone.model.Order;
import com.foodzone.model.OrderItem;

import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

public class OrderDAO {

    /**
     * Atomically creates an Order header and its child OrderItems using JDBC transaction.
     */
    public boolean placeOrder(Order order, List<OrderItem> items) throws SQLException {
        Connection conn = null;
        PreparedStatement orderStmt = null;
        PreparedStatement itemStmt = null;
        ResultSet rs = null;

        String orderSql = "INSERT INTO orders (user_id, subtotal, tax_amount, delivery_fee, "
                        + "total_amount, order_status, delivery_address, contact_phone, "
                        + "payment_method, special_notes) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

        String itemSql = "INSERT INTO order_items (order_id, food_id, quantity, unit_price, subtotal) "
                       + "VALUES (?, ?, ?, ?, ?)";

        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false); // Begin ACID transaction

            orderStmt = conn.prepareStatement(orderSql, Statement.RETURN_GENERATED_KEYS);
            orderStmt.setInt(1, order.getUserId());
            orderStmt.setBigDecimal(2, order.getSubtotal());
            orderStmt.setBigDecimal(3, order.getTaxAmount());
            orderStmt.setBigDecimal(4, order.getDeliveryFee());
            orderStmt.setBigDecimal(5, order.getTotalAmount());
            orderStmt.setString(6, order.getOrderStatus() != null ? order.getOrderStatus() : "PENDING");
            orderStmt.setString(7, order.getDeliveryAddress());
            orderStmt.setString(8, order.getContactPhone());
            orderStmt.setString(9, order.getPaymentMethod() != null ? order.getPaymentMethod() : "Cash on Delivery");
            orderStmt.setString(10, order.getSpecialNotes());

            int affected = orderStmt.executeUpdate();
            if (affected == 0) {
                conn.rollback();
                return false;
            }

            rs = orderStmt.getGeneratedKeys();
            int generatedOrderId = 0;
            if (rs.next()) {
                generatedOrderId = rs.getInt(1);
                order.setOrderId(generatedOrderId);
            } else {
                conn.rollback();
                return false;
            }

            itemStmt = conn.prepareStatement(itemSql);
            for (OrderItem item : items) {
                itemStmt.setInt(1, generatedOrderId);
                itemStmt.setInt(2, item.getFoodId());
                itemStmt.setInt(3, item.getQuantity());
                itemStmt.setBigDecimal(4, item.getUnitPrice());
                itemStmt.setBigDecimal(5, item.getSubtotal());
                itemStmt.addBatch();
            }
            itemStmt.executeBatch();

            conn.commit(); // Transaction success!
            return true;
        } catch (SQLException e) {
            if (conn != null) {
                try {
                    conn.rollback();
                } catch (SQLException rollbackEx) {
                    System.err.println("[OrderDAO] Rollback error: " + rollbackEx.getMessage());
                }
            }
            System.err.println("[OrderDAO] placeOrder error: " + e.getMessage());
            throw e;
        } finally {
            if (rs != null) try { rs.close(); } catch (SQLException ignored) {}
            if (orderStmt != null) try { orderStmt.close(); } catch (SQLException ignored) {}
            if (itemStmt != null) try { itemStmt.close(); } catch (SQLException ignored) {}
            if (conn != null) {
                try { conn.setAutoCommit(true); } catch (SQLException ignored) {}
                try { conn.close(); } catch (SQLException ignored) {}
            }
        }
    }

    public List<Order> getOrdersByUserId(int userId) {
        List<Order> list = new ArrayList<>();
        String sql = "SELECT * FROM orders WHERE user_id = ? ORDER BY order_date DESC";
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        try {
            conn = DBConnection.getConnection();
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, userId);
            rs = stmt.executeQuery();
            while (rs.next()) {
                Order o = mapOrder(rs);
                o.setItems(getOrderItems(conn, o.getOrderId()));
                list.add(o);
            }
        } catch (SQLException e) {
            System.err.println("[OrderDAO] getOrdersByUserId error: " + e.getMessage());
        } finally {
            DBConnection.close(conn, stmt, rs);
        }
        return list;
    }

    public Order getOrderById(int orderId) {
        String sql = "SELECT o.*, u.full_name, u.email FROM orders o "
                   + "JOIN users u ON o.user_id = u.user_id "
                   + "WHERE o.order_id = ?";
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        try {
            conn = DBConnection.getConnection();
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, orderId);
            rs = stmt.executeQuery();
            if (rs.next()) {
                Order o = mapOrder(rs);
                o.setCustomerName(rs.getString("full_name"));
                o.setCustomerEmail(rs.getString("email"));
                o.setItems(getOrderItems(conn, orderId));
                return o;
            }
        } catch (SQLException e) {
            System.err.println("[OrderDAO] getOrderById error: " + e.getMessage());
        } finally {
            DBConnection.close(conn, stmt, rs);
        }
        return null;
    }

    public List<Order> getAllOrders() {
        List<Order> list = new ArrayList<>();
        String sql = "SELECT o.*, u.full_name, u.email FROM orders o "
                   + "JOIN users u ON o.user_id = u.user_id "
                   + "ORDER BY o.order_date DESC";
        Connection conn = null;
        Statement stmt = null;
        ResultSet rs = null;
        try {
            conn = DBConnection.getConnection();
            stmt = conn.createStatement();
            rs = stmt.executeQuery(sql);
            while (rs.next()) {
                Order o = mapOrder(rs);
                o.setCustomerName(rs.getString("full_name"));
                o.setCustomerEmail(rs.getString("email"));
                o.setItems(getOrderItems(conn, o.getOrderId()));
                list.add(o);
            }
        } catch (SQLException e) {
            System.err.println("[OrderDAO] getAllOrders error: " + e.getMessage());
        } finally {
            DBConnection.close(conn, stmt, rs);
        }
        return list;
    }

    public boolean updateOrderStatus(int orderId, String status) {
        String sql = "UPDATE orders SET order_status = ? WHERE order_id = ?";
        Connection conn = null;
        PreparedStatement stmt = null;
        try {
            conn = DBConnection.getConnection();
            stmt = conn.prepareStatement(sql);
            stmt.setString(1, status);
            stmt.setInt(2, orderId);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("[OrderDAO] updateOrderStatus error: " + e.getMessage());
        } finally {
            DBConnection.close(conn, stmt);
        }
        return false;
    }

    public BigDecimal getTotalRevenue() {
        String sql = "SELECT COALESCE(SUM(total_amount), 0) FROM orders WHERE order_status != 'CANCELLED'";
        Connection conn = null;
        Statement stmt = null;
        ResultSet rs = null;
        try {
            conn = DBConnection.getConnection();
            stmt = conn.createStatement();
            rs = stmt.executeQuery(sql);
            if (rs.next()) return rs.getBigDecimal(1);
        } catch (SQLException e) {
            System.err.println("[OrderDAO] getTotalRevenue error: " + e.getMessage());
        } finally {
            DBConnection.close(conn, stmt, rs);
        }
        return BigDecimal.ZERO;
    }

    public int getTotalOrderCount() {
        String sql = "SELECT COUNT(*) FROM orders";
        Connection conn = null;
        Statement stmt = null;
        ResultSet rs = null;
        try {
            conn = DBConnection.getConnection();
            stmt = conn.createStatement();
            rs = stmt.executeQuery(sql);
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) {
            System.err.println("[OrderDAO] getTotalOrderCount error: " + e.getMessage());
        } finally {
            DBConnection.close(conn, stmt, rs);
        }
        return 0;
    }

    public int getPendingOrderCount() {
        String sql = "SELECT COUNT(*) FROM orders WHERE order_status IN ('PENDING', 'PREPARING')";
        Connection conn = null;
        Statement stmt = null;
        ResultSet rs = null;
        try {
            conn = DBConnection.getConnection();
            stmt = conn.createStatement();
            rs = stmt.executeQuery(sql);
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) {
            System.err.println("[OrderDAO] getPendingOrderCount error: " + e.getMessage());
        } finally {
            DBConnection.close(conn, stmt, rs);
        }
        return 0;
    }

    public List<Order> getRecentOrders(int limit) {
        List<Order> list = new ArrayList<>();
        String sql = "SELECT o.*, u.full_name, u.email FROM orders o "
                   + "JOIN users u ON o.user_id = u.user_id "
                   + "ORDER BY o.order_date DESC LIMIT ?";
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        try {
            conn = DBConnection.getConnection();
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, limit);
            rs = stmt.executeQuery();
            while (rs.next()) {
                Order o = mapOrder(rs);
                o.setCustomerName(rs.getString("full_name"));
                o.setCustomerEmail(rs.getString("email"));
                o.setItems(getOrderItems(conn, o.getOrderId()));
                list.add(o);
            }
        } catch (SQLException e) {
            System.err.println("[OrderDAO] getRecentOrders error: " + e.getMessage());
        } finally {
            DBConnection.close(conn, stmt, rs);
        }
        return list;
    }

    private List<OrderItem> getOrderItems(Connection conn, int orderId) {
        List<OrderItem> items = new ArrayList<>();
        String sql = "SELECT oi.*, f.food_name, f.image_url FROM order_items oi "
                   + "JOIN food_items f ON oi.food_id = f.food_id "
                   + "WHERE oi.order_id = ?";
        PreparedStatement stmt = null;
        ResultSet rs = null;
        try {
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, orderId);
            rs = stmt.executeQuery();
            while (rs.next()) {
                OrderItem item = new OrderItem();
                item.setOrderItemId(rs.getInt("order_item_id"));
                item.setOrderId(rs.getInt("order_id"));
                item.setFoodId(rs.getInt("food_id"));
                item.setQuantity(rs.getInt("quantity"));
                item.setUnitPrice(rs.getBigDecimal("unit_price"));
                item.setSubtotal(rs.getBigDecimal("subtotal"));
                item.setFoodName(rs.getString("food_name"));
                item.setImageUrl(rs.getString("image_url"));
                items.add(item);
            }
        } catch (SQLException e) {
            System.err.println("[OrderDAO] getOrderItems error: " + e.getMessage());
        } finally {
            if (rs != null) try { rs.close(); } catch (SQLException ignored) {}
            if (stmt != null) try { stmt.close(); } catch (SQLException ignored) {}
        }
        return items;
    }

    private Order mapOrder(ResultSet rs) throws SQLException {
        Order o = new Order();
        o.setOrderId(rs.getInt("order_id"));
        o.setUserId(rs.getInt("user_id"));
        o.setOrderDate(rs.getTimestamp("order_date"));
        o.setSubtotal(rs.getBigDecimal("subtotal"));
        o.setTaxAmount(rs.getBigDecimal("tax_amount"));
        o.setDeliveryFee(rs.getBigDecimal("delivery_fee"));
        o.setTotalAmount(rs.getBigDecimal("total_amount"));
        o.setOrderStatus(rs.getString("order_status"));
        o.setDeliveryAddress(rs.getString("delivery_address"));
        o.setContactPhone(rs.getString("contact_phone"));
        o.setPaymentMethod(rs.getString("payment_method"));
        o.setSpecialNotes(rs.getString("special_notes"));
        return o;
    }
}
