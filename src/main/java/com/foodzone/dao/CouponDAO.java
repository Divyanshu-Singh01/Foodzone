package com.foodzone.dao;

import com.foodzone.config.DBConnection;
import com.foodzone.model.Coupon;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class CouponDAO {

    public Coupon getCouponByCode(String code) {
        if (code == null || code.trim().isEmpty()) return null;
        String sql = "SELECT * FROM coupons WHERE UPPER(code) = UPPER(?) AND is_active = TRUE";
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            conn = DBConnection.getConnection();
            stmt = conn.prepareStatement(sql);
            stmt.setString(1, code.trim());
            rs = stmt.executeQuery();

            if (rs.next()) {
                Coupon c = new Coupon();
                c.setCouponId(rs.getInt("coupon_id"));
                c.setCode(rs.getString("code"));
                c.setDiscountAmount(rs.getBigDecimal("discount_amount"));
                c.setMinOrderAmount(rs.getBigDecimal("min_order_amount"));
                c.setActive(rs.getBoolean("is_active"));
                c.setCreatedAt(rs.getTimestamp("created_at"));
                return c;
            }
        } catch (Exception e) {
            System.err.println("[CouponDAO] Error finding coupon by code: " + e.getMessage());
        } finally {
            DBConnection.close(conn, stmt, rs);
        }
        return null;
    }

    public List<Coupon> getAllActiveCoupons() {
        List<Coupon> list = new ArrayList<>();
        String sql = "SELECT * FROM coupons WHERE is_active = TRUE ORDER BY discount_amount DESC";
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            conn = DBConnection.getConnection();
            stmt = conn.prepareStatement(sql);
            rs = stmt.executeQuery();

            while (rs.next()) {
                Coupon c = new Coupon();
                c.setCouponId(rs.getInt("coupon_id"));
                c.setCode(rs.getString("code"));
                c.setDiscountAmount(rs.getBigDecimal("discount_amount"));
                c.setMinOrderAmount(rs.getBigDecimal("min_order_amount"));
                c.setActive(rs.getBoolean("is_active"));
                c.setCreatedAt(rs.getTimestamp("created_at"));
                list.add(c);
            }
        } catch (Exception e) {
            System.err.println("[CouponDAO] Error loading coupons: " + e.getMessage());
        } finally {
            DBConnection.close(conn, stmt, rs);
        }
        return list;
    }
}
