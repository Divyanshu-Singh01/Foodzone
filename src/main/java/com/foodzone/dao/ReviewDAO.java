package com.foodzone.dao;

import com.foodzone.config.DBConnection;
import com.foodzone.model.Review;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class ReviewDAO {

    public boolean addReview(Review r) {
        String sql = "INSERT INTO reviews (order_id, user_id, food_id, rating, delivery_rating, review_text) "
                   + "VALUES (?, ?, ?, ?, ?, ?)";
        Connection conn = null;
        PreparedStatement stmt = null;
        try {
            conn = DBConnection.getConnection();
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, r.getOrderId());
            stmt.setInt(2, r.getUserId());
            if (r.getFoodId() != null) {
                stmt.setInt(3, r.getFoodId());
            } else {
                stmt.setNull(3, java.sql.Types.INTEGER);
            }
            stmt.setInt(4, r.getRating());
            stmt.setInt(5, r.getDeliveryRating());
            stmt.setString(6, r.getReviewText());
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("[ReviewDAO] addReview error: " + e.getMessage());
        } finally {
            DBConnection.close(conn, stmt);
        }
        return false;
    }

    public Review getReviewByOrderId(int orderId) {
        String sql = "SELECT r.*, u.full_name AS customer_name FROM reviews r "
                   + "JOIN users u ON r.user_id = u.user_id "
                   + "WHERE r.order_id = ?";
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        try {
            conn = DBConnection.getConnection();
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, orderId);
            rs = stmt.executeQuery();
            if (rs.next()) {
                Review rev = new Review();
                rev.setReviewId(rs.getInt("review_id"));
                rev.setOrderId(rs.getInt("order_id"));
                rev.setUserId(rs.getInt("user_id"));
                rev.setRating(rs.getInt("rating"));
                rev.setDeliveryRating(rs.getInt("delivery_rating"));
                rev.setReviewText(rs.getString("review_text"));
                rev.setCreatedAt(rs.getTimestamp("created_at"));
                rev.setCustomerName(rs.getString("customer_name"));
                return rev;
            }
        } catch (SQLException e) {
            System.err.println("[ReviewDAO] getReviewByOrderId error: " + e.getMessage());
        } finally {
            DBConnection.close(conn, stmt, rs);
        }
        return null;
    }

    public List<Review> getRecentReviews(int limit) {
        List<Review> list = new ArrayList<>();
        String sql = "SELECT r.*, u.full_name AS customer_name FROM reviews r "
                   + "JOIN users u ON r.user_id = u.user_id "
                   + "ORDER BY r.created_at DESC LIMIT ?";
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        try {
            conn = DBConnection.getConnection();
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, limit);
            rs = stmt.executeQuery();
            while (rs.next()) {
                Review rev = new Review();
                rev.setReviewId(rs.getInt("review_id"));
                rev.setOrderId(rs.getInt("order_id"));
                rev.setUserId(rs.getInt("user_id"));
                rev.setRating(rs.getInt("rating"));
                rev.setDeliveryRating(rs.getInt("delivery_rating"));
                rev.setReviewText(rs.getString("review_text"));
                rev.setCreatedAt(rs.getTimestamp("created_at"));
                rev.setCustomerName(rs.getString("customer_name"));
                list.add(rev);
            }
        } catch (SQLException e) {
            System.err.println("[ReviewDAO] getRecentReviews error: " + e.getMessage());
        } finally {
            DBConnection.close(conn, stmt, rs);
        }
        return list;
    }
}
