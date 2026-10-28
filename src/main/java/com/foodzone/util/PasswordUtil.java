package com.foodzone.util;

import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;

/**
 * Utility for hashing and verifying passwords using SHA-256 with salt.
 * Also supports backward compatibility for pre-seeded demonstration passwords.
 */
public class PasswordUtil {

    private static final String SALT = "FoodZone@2026_Secured#";

    /**
     * Hashes a raw password with SHA-256 and salt.
     */
    public static String hashPassword(String password) {
        if (password == null || password.trim().isEmpty()) {
            return "";
        }
        try {
            MessageDigest md = MessageDigest.getInstance("SHA-256");
            md.update(SALT.getBytes(StandardCharsets.UTF_8));
            byte[] hashedBytes = md.digest(password.getBytes(StandardCharsets.UTF_8));
            StringBuilder sb = new StringBuilder();
            for (byte b : hashedBytes) {
                sb.append(String.format("%02x", b));
            }
            return sb.toString();
        } catch (NoSuchAlgorithmException e) {
            throw new RuntimeException("SHA-256 algorithm not available", e);
        }
    }

    /**
     * Verifies a plain password against stored hash or plain password (for demo seeds).
     */
    public static boolean checkPassword(String plainPassword, String storedHash) {
        if (plainPassword == null || storedHash == null) {
            return false;
        }
        // Direct match for initial demo seeds (e.g. 'admin123', 'user123')
        if (plainPassword.equals(storedHash)) {
            return true;
        }
        // Match against salted SHA-256 hash
        String computedHash = hashPassword(plainPassword);
        return computedHash.equalsIgnoreCase(storedHash);
    }
}
