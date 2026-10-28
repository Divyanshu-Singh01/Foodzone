package com.foodzone.model;

import java.io.Serializable;
import java.math.BigDecimal;
import java.sql.Timestamp;

public class FoodItem implements Serializable {
    private static final long serialVersionUID = 1L;

    private int foodId;
    private int categoryId;
    private String foodName;
    private String description;
    private BigDecimal price;
    private String imageUrl;
    private boolean isVeg;
    private boolean isAvailable;
    private Timestamp createdAt;

    // Joined attribute for convenience
    private String categoryName;

    public FoodItem() {}

    public FoodItem(int foodId, int categoryId, String foodName, String description, BigDecimal price,
                    String imageUrl, boolean isVeg, boolean isAvailable, Timestamp createdAt) {
        this.foodId = foodId;
        this.categoryId = categoryId;
        this.foodName = foodName;
        this.description = description;
        this.price = price;
        this.imageUrl = imageUrl;
        this.isVeg = isVeg;
        this.isAvailable = isAvailable;
        this.createdAt = createdAt;
    }

    public int getFoodId() { return foodId; }
    public void setFoodId(int foodId) { this.foodId = foodId; }

    public int getCategoryId() { return categoryId; }
    public void setCategoryId(int categoryId) { this.categoryId = categoryId; }

    public String getFoodName() { return foodName; }
    public void setFoodName(String foodName) { this.foodName = foodName; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public BigDecimal getPrice() { return price; }
    public void setPrice(BigDecimal price) { this.price = price; }

    public String getImageUrl() { return imageUrl; }
    public void setImageUrl(String imageUrl) { this.imageUrl = imageUrl; }

    public boolean isVeg() { return isVeg; }
    public void setVeg(boolean isVeg) { this.isVeg = isVeg; }

    public boolean isAvailable() { return isAvailable; }
    public void setAvailable(boolean isAvailable) { this.isAvailable = isAvailable; }

    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }

    public String getCategoryName() { return categoryName; }
    public void setCategoryName(String categoryName) { this.categoryName = categoryName; }
}
