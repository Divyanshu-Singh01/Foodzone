package com.foodzone.model;

import java.io.Serializable;
import java.sql.Timestamp;

public class Review implements Serializable {
    private static final long serialVersionUID = 1L;

    private int reviewId;
    private int orderId;
    private int userId;
    private Integer foodId;
    private int rating; // 1 to 5
    private int deliveryRating = 5; // 1 to 5
    private String reviewText;
    private Timestamp createdAt;

    // Joined
    private String customerName;

    public Review() {}

    public int getReviewId() { return reviewId; }
    public void setReviewId(int reviewId) { this.reviewId = reviewId; }

    public int getOrderId() { return orderId; }
    public void setOrderId(int orderId) { this.orderId = orderId; }

    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }

    public Integer getFoodId() { return foodId; }
    public void setFoodId(Integer foodId) { this.foodId = foodId; }

    public int getRating() { return rating; }
    public void setRating(int rating) { this.rating = rating; }

    public int getDeliveryRating() { return deliveryRating; }
    public void setDeliveryRating(int deliveryRating) { this.deliveryRating = deliveryRating; }

    public String getReviewText() { return reviewText; }
    public void setReviewText(String reviewText) { this.reviewText = reviewText; }

    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }

    public String getCustomerName() { return customerName; }
    public void setCustomerName(String customerName) { this.customerName = customerName; }
}
