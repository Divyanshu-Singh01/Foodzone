package com.foodzone.model;

import java.io.Serializable;
import java.sql.Timestamp;

public class User implements Serializable {
    private static final long serialVersionUID = 1L;

    private int userId;
    private String fullName;
    private String email;
    private String passwordHash;
    private String phone;
    private String address;
    private String role; // 'CUSTOMER', 'ADMIN', 'DELIVERY'
    private String vehicleNo;
    private String vehicleType = "Motorcycle";
    private String licenseNo;
    private String emergencyPhone;
    private boolean isActiveRider = true;
    private boolean isOnDuty = true;
    private Timestamp createdAt;

    public User() {}

    public User(int userId, String fullName, String email, String passwordHash, String phone, String address, String role, Timestamp createdAt) {
        this.userId = userId;
        this.fullName = fullName;
        this.email = email;
        this.passwordHash = passwordHash;
        this.phone = phone;
        this.address = address;
        this.role = role;
        this.createdAt = createdAt;
    }

    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }

    public String getFullName() { return fullName; }
    public void setFullName(String fullName) { this.fullName = fullName; }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    public String getPasswordHash() { return passwordHash; }
    public void setPasswordHash(String passwordHash) { this.passwordHash = passwordHash; }

    public String getPhone() { return phone; }
    public void setPhone(String phone) { this.phone = phone; }

    public String getVehicleNo() { return vehicleNo; }
    public void setVehicleNo(String vehicleNo) { this.vehicleNo = vehicleNo; }

    public String getVehicleType() { return vehicleType; }
    public void setVehicleType(String vehicleType) { this.vehicleType = vehicleType; }

    public String getLicenseNo() { return licenseNo; }
    public void setLicenseNo(String licenseNo) { this.licenseNo = licenseNo; }

    public String getEmergencyPhone() { return emergencyPhone; }
    public void setEmergencyPhone(String emergencyPhone) { this.emergencyPhone = emergencyPhone; }

    public boolean isActiveRider() { return isActiveRider; }
    public void setActiveRider(boolean activeRider) { isActiveRider = activeRider; }

    public boolean isOnDuty() { return isOnDuty; }
    public boolean getIsOnDuty() { return isOnDuty; }
    public void setOnDuty(boolean onDuty) { isOnDuty = onDuty; }
    public void setIsOnDuty(boolean onDuty) { isOnDuty = onDuty; }

    public String getAddress() { return address; }
    public void setAddress(String address) { this.address = address; }

    public String getRole() { return role; }
    public void setRole(String role) { this.role = role; }

    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }

    public boolean isAdmin() {
        return "ADMIN".equalsIgnoreCase(this.role);
    }

    public boolean isDelivery() {
        return "DELIVERY".equalsIgnoreCase(this.role);
    }

    public boolean isCustomer() {
        return "CUSTOMER".equalsIgnoreCase(this.role) || (!isAdmin() && !isDelivery());
    }
}
