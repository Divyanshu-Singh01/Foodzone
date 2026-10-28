package com.foodzone.config;

import java.io.InputStream;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.Properties;

/**
 * Thread-safe Database Connection Provider for FoodZone.
 * Reads configuration from db.properties or falls back to system properties/defaults.
 */
public class DBConnection {

    private static String url = "jdbc:mysql://localhost:3306/foodzone_db?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC&characterEncoding=UTF-8";
    private static String username = "root";
    private static String password = "root";
    private static String driver = "com.mysql.cj.jdbc.Driver";

    static {
        try {
            // Load db.properties if present on classpath
            try (InputStream input = DBConnection.class.getClassLoader().getResourceAsStream("db.properties")) {
                if (input != null) {
                    Properties prop = new Properties();
                    prop.load(input);
                    if (prop.getProperty("db.url") != null) url = prop.getProperty("db.url");
                    if (prop.getProperty("db.user") != null) username = prop.getProperty("db.user");
                    if (prop.getProperty("db.password") != null) password = prop.getProperty("db.password");
                    if (prop.getProperty("db.driver") != null) driver = prop.getProperty("db.driver");
                }
            } catch (Exception ex) {
                System.err.println("[FoodZone DB] Note: using default db configuration. (" + ex.getMessage() + ")");
            }

            // Allow environment variable or system property override
            if (System.getProperty("FOODZONE_DB_PASS") != null) {
                password = System.getProperty("FOODZONE_DB_PASS");
            } else if (System.getenv("FOODZONE_DB_PASS") != null) {
                password = System.getenv("FOODZONE_DB_PASS");
            }

            Class.forName(driver);
            System.out.println("[FoodZone DB] MySQL Driver loaded successfully.");
        } catch (ClassNotFoundException e) {
            System.err.println("[FoodZone DB] ERROR: MySQL JDBC Driver not found: " + e.getMessage());
        }
    }

    /**
     * Obtains a new connection to the MySQL database.
     */
    public static Connection getConnection() throws SQLException {
        return DriverManager.getConnection(url, username, password);
    }

    /**
     * Safely closes JDBC resources to prevent memory or connection leaks.
     */
    public static void close(Connection conn, Statement stmt, ResultSet rs) {
        if (rs != null) {
            try { rs.close(); } catch (SQLException ignored) {}
        }
        if (stmt != null) {
            try { stmt.close(); } catch (SQLException ignored) {}
        }
        if (conn != null) {
            try { conn.close(); } catch (SQLException ignored) {}
        }
    }

    public static void close(Connection conn, Statement stmt) {
        close(conn, stmt, null);
    }
}
