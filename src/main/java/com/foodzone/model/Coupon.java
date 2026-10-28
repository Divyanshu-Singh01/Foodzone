package com.foodzone.model;

import java.io.Serializable;
import java.math.BigDecimal;
import java.sql.Timestamp;

public class Coupon implements Serializable {
    private static final long serialVersionUID = 1L;

    private int couponId;
    private String code;
    private BigDecimal discountAmount;
    private BigDecimal minOrderAmount;
    private boolean active;
    private Timestamp createdAt;

    public Coupon() {}

    public Coupon(int couponId, String code, BigDecimal discountAmount, BigDecimal minOrderAmount, boolean active) {
        this.couponId = couponId;
        this.code = code;
        this.discountAmount = discountAmount;
        this.minOrderAmount = minOrderAmount;
        this.active = active;
    }

    public int getCouponId() { return couponId; }
    public void setCouponId(int couponId) { this.couponId = couponId; }

    public String getCode() { return code; }
    public void setCode(String code) { this.code = code; }

    public BigDecimal getDiscountAmount() { return discountAmount; }
    public void setDiscountAmount(BigDecimal discountAmount) { this.discountAmount = discountAmount; }

    public BigDecimal getMinOrderAmount() { return minOrderAmount; }
    public void setMinOrderAmount(BigDecimal minOrderAmount) { this.minOrderAmount = minOrderAmount; }

    public boolean isActive() { return active; }
    public void setActive(boolean active) { this.active = active; }

    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }
}
