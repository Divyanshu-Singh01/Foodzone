package com.foodzone.model;

import java.io.Serializable;
import java.math.BigDecimal;

public class CartItem implements Serializable {
    private static final long serialVersionUID = 1L;

    private FoodItem foodItem;
    private int quantity;

    public CartItem() {}

    public CartItem(FoodItem foodItem, int quantity) {
        this.foodItem = foodItem;
        this.quantity = quantity;
    }

    public FoodItem getFoodItem() { return foodItem; }
    public void setFoodItem(FoodItem foodItem) { this.foodItem = foodItem; }

    public int getQuantity() { return quantity; }
    public void setQuantity(int quantity) { this.quantity = quantity; }

    public BigDecimal getSubtotal() {
        if (foodItem == null || foodItem.getPrice() == null) {
            return BigDecimal.ZERO;
        }
        return foodItem.getPrice().multiply(BigDecimal.valueOf(quantity));
    }
}
