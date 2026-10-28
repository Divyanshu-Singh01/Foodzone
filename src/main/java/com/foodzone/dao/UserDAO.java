package com.foodzone.dao;

import com.foodzone.config.DBConnection;
import com.foodzone.model.User;
import com.foodzone.util.PasswordUtil;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

public class UserDAO {

    public boolean register(User user) {
        String sql = "INSERT INTO users (full_name, email, password_hash, phone, address, role) VALUES (?, ?, ?, ?, ?, ?)";
        Connection conn = null;
        PreparedStatement stmt = null;
        try {
            conn = DBConnection.getConnection();
            stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            stmt.setString(1, user.getFullName());
            stmt.setString(2, user.getEmail().trim().toLowerCase());
            stmt.setString(3, PasswordUtil.hashPassword(user.getPasswordHash()));
            stmt.setString(4, user.getPhone());
            stmt.setString(5, user.getAddress());
            stmt.setString(6, user.getRole() != null ? user.getRole() : "CUSTOMER");

            int rows = stmt.executeUpdate();
            if (rows > 0) {
                try (ResultSet rs = stmt.getGeneratedKeys()) {
                    if (rs.next()) {
                        user.setUserId(rs.getInt(1));
                    }
                }
                return true;
            }
        } catch (SQLException e) {
            System.err.println("[UserDAO] register error: " + e.getMessage());
        } finally {
            DBConnection.close(conn, stmt);
        }
        return false;
    }

    public boolean registerRider(User rider) {
        String sql = "INSERT INTO users (full_name, email, password_hash, phone, address, role, vehicle_no, vehicle_type, license_no, emergency_phone, is_active_rider, is_on_duty) "
                   + "VALUES (?, ?, ?, ?, ?, 'DELIVERY', ?, ?, ?, ?, 1, 1)";
        Connection conn = null;
        PreparedStatement stmt = null;
        try {
            conn = DBConnection.getConnection();
            stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            stmt.setString(1, rider.getFullName());
            stmt.setString(2, rider.getEmail().trim().toLowerCase());
            stmt.setString(3, PasswordUtil.hashPassword(rider.getPasswordHash()));
            stmt.setString(4, rider.getPhone());
            stmt.setString(5, rider.getAddress() != null ? rider.getAddress() : "");
            stmt.setString(6, rider.getVehicleNo() != null ? rider.getVehicleNo().trim().toUpperCase() : "");
            stmt.setString(7, rider.getVehicleType() != null ? rider.getVehicleType().trim() : "Motorcycle");
            stmt.setString(8, rider.getLicenseNo() != null ? rider.getLicenseNo().trim().toUpperCase() : "");
            stmt.setString(9, rider.getEmergencyPhone() != null ? rider.getEmergencyPhone().trim() : "");

            int rows = stmt.executeUpdate();
            if (rows > 0) {
                try (ResultSet rs = stmt.getGeneratedKeys()) {
                    if (rs.next()) {
                        rider.setUserId(rs.getInt(1));
                    }
                }
                rider.setRole("DELIVERY");
                rider.setActiveRider(true);
                rider.setOnDuty(true);
                return true;
            }
        } catch (SQLException e) {
            System.err.println("[UserDAO] registerRider error: " + e.getMessage());
        } finally {
            DBConnection.close(conn, stmt);
        }
        return false;
    }

    public User authenticate(String email, String plainPassword) {
        String sql = "SELECT * FROM users WHERE LOWER(email) = ?";
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        try {
            conn = DBConnection.getConnection();
            stmt = conn.prepareStatement(sql);
            stmt.setString(1, email.trim().toLowerCase());
            rs = stmt.executeQuery();

            if (rs.next()) {
                String storedHash = rs.getString("password_hash");
                if (PasswordUtil.checkPassword(plainPassword, storedHash)) {
                    return mapUser(rs);
                }
            }
        } catch (SQLException e) {
            System.err.println("[UserDAO] authenticate error: " + e.getMessage());
        } finally {
            DBConnection.close(conn, stmt, rs);
        }
        return null;
    }

    public User findByEmail(String email) {
        String sql = "SELECT * FROM users WHERE LOWER(email) = ?";
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        try {
            conn = DBConnection.getConnection();
            stmt = conn.prepareStatement(sql);
            stmt.setString(1, email.trim().toLowerCase());
            rs = stmt.executeQuery();

            if (rs.next()) {
                return mapUser(rs);
            }
        } catch (SQLException e) {
            System.err.println("[UserDAO] findByEmail error: " + e.getMessage());
        } finally {
            DBConnection.close(conn, stmt, rs);
        }
        return null;
    }

    public User findById(int userId) {
        String sql = "SELECT * FROM users WHERE user_id = ?";
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        try {
            conn = DBConnection.getConnection();
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, userId);
            rs = stmt.executeQuery();

            if (rs.next()) {
                return mapUser(rs);
            }
        } catch (SQLException e) {
            System.err.println("[UserDAO] findById error: " + e.getMessage());
        } finally {
            DBConnection.close(conn, stmt, rs);
        }
        return null;
    }

    public User getUserById(int userId) {
        return findById(userId);
    }

    public List<User> getAllCustomers() {
        List<User> list = new ArrayList<>();
        String sql = "SELECT * FROM users WHERE role = 'CUSTOMER' ORDER BY created_at DESC";
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        try {
            conn = DBConnection.getConnection();
            stmt = conn.prepareStatement(sql);
            rs = stmt.executeQuery();
            while (rs.next()) {
                list.add(mapUser(rs));
            }
        } catch (SQLException e) {
            System.err.println("[UserDAO] getAllCustomers error: " + e.getMessage());
        } finally {
            DBConnection.close(conn, stmt, rs);
        }
        return list;
    }

    public int getCustomerCount() {
        String sql = "SELECT COUNT(*) FROM users WHERE role = 'CUSTOMER'";
        Connection conn = null;
        Statement stmt = null;
        ResultSet rs = null;
        try {
            conn = DBConnection.getConnection();
            stmt = conn.createStatement();
            rs = stmt.executeQuery(sql);
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) {
            System.err.println("[UserDAO] getCustomerCount error: " + e.getMessage());
        } finally {
            DBConnection.close(conn, stmt, rs);
        }
        return 0;
    }

    public List<User> getAllDeliveryRiders() {
        List<User> list = new ArrayList<>();
        String sql = "SELECT * FROM users WHERE role = 'DELIVERY' ORDER BY full_name ASC";
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        try {
            conn = DBConnection.getConnection();
            stmt = conn.prepareStatement(sql);
            rs = stmt.executeQuery();
            while (rs.next()) {
                list.add(mapUser(rs));
            }
        } catch (SQLException e) {
            System.err.println("[UserDAO] getAllDeliveryRiders error: " + e.getMessage());
        } finally {
            DBConnection.close(conn, stmt, rs);
        }
        return list;
    }

    public boolean updateUserProfile(int userId, String fullName, String phone, String address) {
        String sql = "UPDATE users SET full_name = ?, phone = ?, address = ? WHERE user_id = ?";
        Connection conn = null;
        PreparedStatement stmt = null;
        try {
            conn = DBConnection.getConnection();
            stmt = conn.prepareStatement(sql);
            stmt.setString(1, fullName);
            stmt.setString(2, phone);
            stmt.setString(3, address);
            stmt.setInt(4, userId);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("[UserDAO] updateUserProfile error: " + e.getMessage());
        } finally {
            DBConnection.close(conn, stmt);
        }
        return false;
    }

    public boolean updateRiderProfile(int userId, String fullName, String phone, String vehicleNo, String vehicleType, String licenseNo, String emergencyPhone) {
        String sql = "UPDATE users SET full_name = ?, phone = ?, vehicle_no = ?, vehicle_type = ?, license_no = ?, emergency_phone = ? WHERE user_id = ?";
        Connection conn = null;
        PreparedStatement stmt = null;
        try {
            conn = DBConnection.getConnection();
            stmt = conn.prepareStatement(sql);
            stmt.setString(1, fullName);
            stmt.setString(2, phone);
            stmt.setString(3, vehicleNo);
            stmt.setString(4, vehicleType);
            stmt.setString(5, licenseNo);
            stmt.setString(6, emergencyPhone);
            stmt.setInt(7, userId);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("[UserDAO] updateRiderProfile error: " + e.getMessage());
        } finally {
            DBConnection.close(conn, stmt);
        }
        return false;
    }

    public boolean toggleRiderDuty(int userId, boolean isOnDuty) {
        String sql = "UPDATE users SET is_on_duty = ? WHERE user_id = ?";
        Connection conn = null;
        PreparedStatement stmt = null;
        try {
            conn = DBConnection.getConnection();
            stmt = conn.prepareStatement(sql);
            stmt.setBoolean(1, isOnDuty);
            stmt.setInt(2, userId);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("[UserDAO] toggleRiderDuty error: " + e.getMessage());
        } finally {
            DBConnection.close(conn, stmt);
        }
        return false;
    }

    private User mapUser(ResultSet rs) throws SQLException {
        User u = new User();
        u.setUserId(rs.getInt("user_id"));
        u.setFullName(rs.getString("full_name"));
        u.setEmail(rs.getString("email"));
        u.setPasswordHash(rs.getString("password_hash"));
        u.setPhone(rs.getString("phone"));
        u.setAddress(rs.getString("address"));
        u.setRole(rs.getString("role"));
        try {
            u.setVehicleNo(rs.getString("vehicle_no"));
            u.setVehicleType(rs.getString("vehicle_type"));
            u.setLicenseNo(rs.getString("license_no"));
            u.setEmergencyPhone(rs.getString("emergency_phone"));
            u.setActiveRider(rs.getBoolean("is_active_rider"));
            u.setOnDuty(rs.getBoolean("is_on_duty"));
        } catch (SQLException ignored) {}
        u.setCreatedAt(rs.getTimestamp("created_at"));
        return u;
    }
}
