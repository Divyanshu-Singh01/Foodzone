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
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class OrderDAO {

    /**
     * Atomically creates an Order header and its child OrderItems using JDBC transaction.
     */
    public boolean placeOrder(Order order, List<OrderItem> items) throws SQLException {
        Connection conn = null;
        PreparedStatement orderStmt = null;
        PreparedStatement itemStmt = null;
        ResultSet rs = null;

        String orderSql = "INSERT INTO orders (user_id, order_type, subtotal, tax_amount, delivery_fee, "
                        + "discount_amount, total_amount, order_status, delivery_address, contact_phone, "
                        + "payment_method, delivery_otp, coupon_code, special_notes, "
                        + "landmark, address_type, delivery_instructions, alternate_phone) "
                        + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

        String itemSql = "INSERT INTO order_items (order_id, food_id, quantity, unit_price, subtotal) "
                       + "VALUES (?, ?, ?, ?, ?)";

        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false); // Begin ACID transaction

            orderStmt = conn.prepareStatement(orderSql, Statement.RETURN_GENERATED_KEYS);
            orderStmt.setInt(1, order.getUserId());
            orderStmt.setString(2, order.getOrderType() != null ? order.getOrderType() : "DELIVERY");
            orderStmt.setBigDecimal(3, order.getSubtotal());
            orderStmt.setBigDecimal(4, order.getTaxAmount());
            orderStmt.setBigDecimal(5, order.getDeliveryFee());
            orderStmt.setBigDecimal(6, order.getDiscountAmount() != null ? order.getDiscountAmount() : BigDecimal.ZERO);
            orderStmt.setBigDecimal(7, order.getTotalAmount());
            orderStmt.setString(8, order.getOrderStatus() != null ? order.getOrderStatus() : "PENDING");
            orderStmt.setString(9, order.getDeliveryAddress());
            orderStmt.setString(10, order.getContactPhone());
            orderStmt.setString(11, order.getPaymentMethod() != null ? order.getPaymentMethod() : "Cash on Delivery");
            orderStmt.setString(12, order.getDeliveryOtp());
            orderStmt.setString(13, order.getCouponCode());
            orderStmt.setString(14, order.getSpecialNotes());
            orderStmt.setString(15, order.getLandmark() != null ? order.getLandmark() : "");
            orderStmt.setString(16, order.getAddressType() != null ? order.getAddressType() : "HOME");
            orderStmt.setString(17, order.getDeliveryInstructions() != null ? order.getDeliveryInstructions() : "");
            orderStmt.setString(18, order.getAlternatePhone() != null ? order.getAlternatePhone() : "");

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
        String sql = "SELECT o.*, u.full_name, u.email, r.full_name AS rider_name, r.phone AS rider_phone, r.vehicle_no AS rider_vehicle "
                   + "FROM orders o "
                   + "JOIN users u ON o.user_id = u.user_id "
                   + "LEFT JOIN users r ON o.rider_id = r.user_id "
                   + "WHERE o.user_id = ? ORDER BY o.order_date DESC";
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
                o.setCustomerName(rs.getString("full_name"));
                o.setCustomerEmail(rs.getString("email"));
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
        String sql = "SELECT o.*, u.full_name, u.email, r.full_name AS rider_name, r.phone AS rider_phone, r.vehicle_no AS rider_vehicle "
                   + "FROM orders o "
                   + "JOIN users u ON o.user_id = u.user_id "
                   + "LEFT JOIN users r ON o.rider_id = r.user_id "
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
        String sql = "SELECT o.*, u.full_name, u.email, r.full_name AS rider_name, r.phone AS rider_phone, r.vehicle_no AS rider_vehicle "
                   + "FROM orders o "
                   + "JOIN users u ON o.user_id = u.user_id "
                   + "LEFT JOIN users r ON o.rider_id = r.user_id "
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
        String sql = "SELECT o.*, u.full_name, u.email, r.full_name AS rider_name, r.phone AS rider_phone, r.vehicle_no AS rider_vehicle "
                   + "FROM orders o "
                   + "JOIN users u ON o.user_id = u.user_id "
                   + "LEFT JOIN users r ON o.rider_id = r.user_id "
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

    public boolean hasActiveDelivery(int riderId) {
        return hasActiveDelivery(riderId, -1);
    }

    public boolean hasActiveDelivery(int riderId, int excludeOrderId) {
        String sql = "SELECT COUNT(*) FROM orders "
                   + "WHERE rider_id = ? "
                   + "  AND order_status = 'OUT_FOR_DELIVERY' "
                   + "  AND (trip_stage IS NULL OR trip_stage IN ('ASSIGNED', 'PICKED_UP', 'ARRIVED')) "
                   + (excludeOrderId > 0 ? "AND order_id != ? " : "");
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        try {
            conn = DBConnection.getConnection();
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, riderId);
            if (excludeOrderId > 0) {
                stmt.setInt(2, excludeOrderId);
            }
            rs = stmt.executeQuery();
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        } catch (SQLException e) {
            System.err.println("[OrderDAO] hasActiveDelivery error: " + e.getMessage());
        } finally {
            DBConnection.close(conn, stmt, rs);
        }
        return false;
    }

    public List<Order> getAvailableUnassignedOrders() {
        List<Order> list = new ArrayList<>();
        String sql = "SELECT o.*, u.full_name, u.email, NULL AS rider_name, NULL AS rider_phone, NULL AS rider_vehicle "
                   + "FROM orders o "
                   + "JOIN users u ON o.user_id = u.user_id "
                   + "WHERE (o.rider_id IS NULL OR o.rider_id = 0) "
                   + "  AND o.order_type = 'DELIVERY' "
                   + "  AND o.order_status IN ('PENDING', 'PREPARING') "
                   + "ORDER BY o.order_date ASC";
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        try {
            conn = DBConnection.getConnection();
            stmt = conn.prepareStatement(sql);
            rs = stmt.executeQuery();
            while (rs.next()) {
                Order o = mapOrder(rs);
                o.setCustomerName(rs.getString("full_name"));
                o.setCustomerEmail(rs.getString("email"));
                o.setItems(getOrderItems(conn, o.getOrderId()));
                list.add(o);
            }
        } catch (SQLException e) {
            System.err.println("[OrderDAO] getAvailableUnassignedOrders error: " + e.getMessage());
        } finally {
            DBConnection.close(conn, stmt, rs);
        }
        return list;
    }

    public synchronized boolean claimOrder(int orderId, int riderId) {
        if (hasActiveDelivery(riderId)) {
            System.out.println("[OrderDAO] claimOrder blocked: Rider " + riderId + " already has an active delivery!");
            return false;
        }

        String sql = "UPDATE orders "
                   + "SET rider_id = ?, order_status = 'OUT_FOR_DELIVERY', trip_stage = 'ASSIGNED' "
                   + "WHERE order_id = ? "
                   + "  AND (rider_id IS NULL OR rider_id = 0) "
                   + "  AND order_status IN ('PENDING', 'PREPARING')";
        Connection conn = null;
        PreparedStatement stmt = null;
        try {
            conn = DBConnection.getConnection();
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, riderId);
            stmt.setInt(2, orderId);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("[OrderDAO] claimOrder error: " + e.getMessage());
        } finally {
            DBConnection.close(conn, stmt);
        }
        return false;
    }

    public boolean assignRider(int orderId, int riderId) {
        if (hasActiveDelivery(riderId, orderId)) {
            System.out.println("[OrderDAO] assignRider blocked: Rider " + riderId + " already has an active delivery!");
            return false;
        }
        String sql = "UPDATE orders SET rider_id = ?, order_status = 'OUT_FOR_DELIVERY', trip_stage = 'ASSIGNED' WHERE order_id = ?";
        Connection conn = null;
        PreparedStatement stmt = null;
        try {
            conn = DBConnection.getConnection();
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, riderId);
            stmt.setInt(2, orderId);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("[OrderDAO] assignRider error: " + e.getMessage());
        } finally {
            DBConnection.close(conn, stmt);
        }
        return false;
    }

    public boolean updateTripStage(int orderId, int riderId, String tripStage) {
        String sql = "UPDATE orders SET trip_stage = ? WHERE order_id = ? AND rider_id = ?";
        Connection conn = null;
        PreparedStatement stmt = null;
        try {
            conn = DBConnection.getConnection();
            stmt = conn.prepareStatement(sql);
            stmt.setString(1, tripStage);
            stmt.setInt(2, orderId);
            stmt.setInt(3, riderId);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("[OrderDAO] updateTripStage error: " + e.getMessage());
        } finally {
            DBConnection.close(conn, stmt);
        }
        return false;
    }

    public boolean verifyAndCompleteOrder(int orderId, int riderId, String inputOtp) {
        return verifyAndCompleteOrder(orderId, riderId, inputOtp, null, null);
    }

    public boolean verifyAndCompleteOrder(int orderId, int riderId, String inputOtp, BigDecimal cashReceived, String deliveryNote) {
        if (inputOtp == null) return false;
        String sql = "UPDATE orders SET order_status = 'COMPLETED', trip_stage = 'DELIVERED', "
                   + "cash_received = ?, delivery_note = ? "
                   + "WHERE order_id = ? AND rider_id = ? AND TRIM(delivery_otp) = TRIM(?) AND order_status = 'OUT_FOR_DELIVERY'";
        Connection conn = null;
        PreparedStatement stmt = null;
        try {
            conn = DBConnection.getConnection();
            stmt = conn.prepareStatement(sql);
            stmt.setBigDecimal(1, cashReceived);
            stmt.setString(2, deliveryNote);
            stmt.setInt(3, orderId);
            stmt.setInt(4, riderId);
            stmt.setString(5, inputOtp.trim());
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("[OrderDAO] verifyAndCompleteOrder error: " + e.getMessage());
        } finally {
            DBConnection.close(conn, stmt);
        }
        return false;
    }

    public Map<String, Object> getRiderShiftStats(int riderId) {
        Map<String, Object> stats = new HashMap<>();
        stats.put("completedToday", 0);
        stats.put("cashCollectedToday", BigDecimal.ZERO);
        stats.put("totalLifetimeOrders", 0);

        String sqlToday = "SELECT COUNT(*) AS count_today, COALESCE(SUM(total_amount), 0) AS cash_today "
                        + "FROM orders WHERE rider_id = ? AND order_status = 'COMPLETED' AND DATE(order_date) = CURDATE()";
        String sqlLifetime = "SELECT COUNT(*) AS count_all FROM orders WHERE rider_id = ? AND order_status = 'COMPLETED'";

        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        try {
            conn = DBConnection.getConnection();
            stmt = conn.prepareStatement(sqlToday);
            stmt.setInt(1, riderId);
            rs = stmt.executeQuery();
            if (rs.next()) {
                stats.put("completedToday", rs.getInt("count_today"));
                stats.put("cashCollectedToday", rs.getBigDecimal("cash_today"));
            }
            rs.close();
            stmt.close();

            stmt = conn.prepareStatement(sqlLifetime);
            stmt.setInt(1, riderId);
            rs = stmt.executeQuery();
            if (rs.next()) {
                stats.put("totalLifetimeOrders", rs.getInt("count_all"));
            }
        } catch (SQLException e) {
            System.err.println("[OrderDAO] getRiderShiftStats error: " + e.getMessage());
        } finally {
            DBConnection.close(conn, stmt, rs);
        }
        return stats;
    }

    public Map<String, Object> getCustomerStats(int userId) {
        Map<String, Object> stats = new HashMap<>();
        stats.put("totalOrders", 0);
        stats.put("totalSpent", BigDecimal.ZERO);
        stats.put("completedOrders", 0);
        stats.put("activeOrders", 0);

        String sql = "SELECT COUNT(*) AS total_count, "
                   + "COALESCE(SUM(CASE WHEN order_status = 'COMPLETED' THEN total_amount ELSE 0 END), 0) AS total_spent, "
                   + "COUNT(CASE WHEN order_status = 'COMPLETED' THEN 1 END) AS completed_count, "
                   + "COUNT(CASE WHEN order_status NOT IN ('COMPLETED', 'CANCELLED') THEN 1 END) AS active_count "
                   + "FROM orders WHERE user_id = ?";

        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        try {
            conn = DBConnection.getConnection();
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, userId);
            rs = stmt.executeQuery();
            if (rs.next()) {
                stats.put("totalOrders", rs.getInt("total_count"));
                stats.put("totalSpent", rs.getBigDecimal("total_spent"));
                stats.put("completedOrders", rs.getInt("completed_count"));
                stats.put("activeOrders", rs.getInt("active_count"));
            }
        } catch (SQLException e) {
            System.err.println("[OrderDAO] getCustomerStats error: " + e.getMessage());
        } finally {
            DBConnection.close(conn, stmt, rs);
        }
        return stats;
    }

    public List<Order> getOrdersByRiderId(int riderId) {
        List<Order> list = new ArrayList<>();
        String sql = "SELECT o.*, u.full_name, u.email, r.full_name AS rider_name, r.phone AS rider_phone, r.vehicle_no AS rider_vehicle "
                   + "FROM orders o "
                   + "JOIN users u ON o.user_id = u.user_id "
                   + "LEFT JOIN users r ON o.rider_id = r.user_id "
                   + "WHERE o.rider_id = ? "
                   + "ORDER BY CASE WHEN o.order_status = 'OUT_FOR_DELIVERY' THEN 1 ELSE 2 END, o.order_date DESC";
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        try {
            conn = DBConnection.getConnection();
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, riderId);
            rs = stmt.executeQuery();
            while (rs.next()) {
                Order o = mapOrder(rs);
                o.setCustomerName(rs.getString("full_name"));
                o.setCustomerEmail(rs.getString("email"));
                o.setItems(getOrderItems(conn, o.getOrderId()));
                list.add(o);
            }
        } catch (SQLException e) {
            System.err.println("[OrderDAO] getOrdersByRiderId error: " + e.getMessage());
        } finally {
            DBConnection.close(conn, stmt, rs);
        }
        return list;
    }

    public boolean cancelOrderByCustomer(int orderId, int userId) {
        String sql = "UPDATE orders SET order_status = 'CANCELLED' WHERE order_id = ? AND user_id = ? AND order_status = 'PENDING'";
        Connection conn = null;
        PreparedStatement stmt = null;
        try {
            conn = DBConnection.getConnection();
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, orderId);
            stmt.setInt(2, userId);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("[OrderDAO] cancelOrderByCustomer error: " + e.getMessage());
        } finally {
            DBConnection.close(conn, stmt);
        }
        return false;
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
        try { o.setOrderType(rs.getString("order_type")); } catch (SQLException ignored) {}
        o.setOrderDate(rs.getTimestamp("order_date"));
        o.setSubtotal(rs.getBigDecimal("subtotal"));
        o.setTaxAmount(rs.getBigDecimal("tax_amount"));
        o.setDeliveryFee(rs.getBigDecimal("delivery_fee"));
        try { o.setDiscountAmount(rs.getBigDecimal("discount_amount")); } catch (SQLException ignored) {}
        o.setTotalAmount(rs.getBigDecimal("total_amount"));
        o.setOrderStatus(rs.getString("order_status"));
        o.setDeliveryAddress(rs.getString("delivery_address"));
        o.setContactPhone(rs.getString("contact_phone"));
        o.setPaymentMethod(rs.getString("payment_method"));
        try { o.setDeliveryOtp(rs.getString("delivery_otp")); } catch (SQLException ignored) {}
        try { o.setCouponCode(rs.getString("coupon_code")); } catch (SQLException ignored) {}
        try {
            int rid = rs.getInt("rider_id");
            if (!rs.wasNull()) o.setRiderId(rid);
        } catch (SQLException ignored) {}
        o.setSpecialNotes(rs.getString("special_notes"));

        try { o.setRiderName(rs.getString("rider_name")); } catch (SQLException ignored) {}
        try { o.setRiderPhone(rs.getString("rider_phone")); } catch (SQLException ignored) {}
        try { o.setRiderVehicle(rs.getString("rider_vehicle")); } catch (SQLException ignored) {}

        try { o.setLandmark(rs.getString("landmark")); } catch (SQLException ignored) {}
        try { o.setAddressType(rs.getString("address_type")); } catch (SQLException ignored) {}
        try { o.setDeliveryInstructions(rs.getString("delivery_instructions")); } catch (SQLException ignored) {}
        try { o.setAlternatePhone(rs.getString("alternate_phone")); } catch (SQLException ignored) {}
        try { o.setTripStage(rs.getString("trip_stage")); } catch (SQLException ignored) {}
        try { o.setDeliveryNote(rs.getString("delivery_note")); } catch (SQLException ignored) {}
        try { o.setCashReceived(rs.getBigDecimal("cash_received")); } catch (SQLException ignored) {}
        return o;
    }
}
