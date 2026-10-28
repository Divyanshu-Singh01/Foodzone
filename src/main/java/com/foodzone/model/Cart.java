package com.foodzone.model;

import java.io.Serializable;
import java.math.BigDecimal;
import java.math.RoundingMode;
import java.util.Collection;
import java.util.LinkedHashMap;
import java.util.Map;

/**
 * Session-backed Shopping Cart containing CartItems and order total calculations.
 */
public class Cart implements Serializable {
    private static final long serialVersionUID = 1L;

    private final Map<Integer, CartItem> items = new LinkedHashMap<>();
    private String orderType = "DELIVERY"; // 'DELIVERY' or 'TAKEAWAY'
    private String couponCode = null;
    private BigDecimal discountAmount = BigDecimal.ZERO;

    public Cart() {}

    public String getOrderType() { return orderType; }
    public void setOrderType(String orderType) { this.orderType = orderType; }

    public String getCouponCode() { return couponCode; }
    public BigDecimal getDiscountAmount() { return discountAmount; }

    public void applyCoupon(String code, BigDecimal discount) {
        this.couponCode = code;
        this.discountAmount = discount != null ? discount : BigDecimal.ZERO;
    }

    public void removeCoupon() {
        this.couponCode = null;
        this.discountAmount = BigDecimal.ZERO;
    }

    public Collection<CartItem> getItems() {
        return items.values();
    }

    public boolean isEmpty() {
        return items.isEmpty();
    }

    public void addItem(FoodItem food, int qty) {
        if (food == null || qty <= 0) return;
        int id = food.getFoodId();
        if (items.containsKey(id)) {
            CartItem existing = items.get(id);
            existing.setQuantity(existing.getQuantity() + qty);
        } else {
            items.put(id, new CartItem(food, qty));
        }
    }

    public void updateQuantity(int foodId, int qty) {
        if (qty <= 0) {
            removeItem(foodId);
        } else if (items.containsKey(foodId)) {
            items.get(foodId).setQuantity(qty);
        }
    }

    public void removeItem(int foodId) {
        items.remove(foodId);
    }

    public void clear() {
        items.clear();
        removeCoupon();
    }

    public int getItemCount() {
        int count = 0;
        for (CartItem item : items.values()) {
            count += item.getQuantity();
        }
        return count;
    }

    public BigDecimal getSubtotal() {
        BigDecimal sum = BigDecimal.ZERO;
        for (CartItem item : items.values()) {
            sum = sum.add(item.getSubtotal());
        }
        return sum.setScale(2, RoundingMode.HALF_UP);
    }

    /**
     * 5% GST tax calculation.
     */
    public BigDecimal getTaxAmount() {
        BigDecimal subtotal = getSubtotal();
        return subtotal.multiply(new BigDecimal("0.05")).setScale(2, RoundingMode.HALF_UP);
    }

    /**
     * If Takeaway, delivery is 0. If Delivery: free above 500, else flat fee 40.
     */
    public BigDecimal getDeliveryFee() {
        if (isEmpty() || "TAKEAWAY".equalsIgnoreCase(orderType)) {
            return BigDecimal.ZERO.setScale(2, RoundingMode.HALF_UP);
        }
        BigDecimal subtotal = getSubtotal();
        if (subtotal.compareTo(new BigDecimal("500.00")) >= 0) {
            return BigDecimal.ZERO.setScale(2, RoundingMode.HALF_UP);
        }
        return new BigDecimal("40.00").setScale(2, RoundingMode.HALF_UP);
    }

    public BigDecimal getTotalAmount() {
        if (isEmpty()) return BigDecimal.ZERO.setScale(2, RoundingMode.HALF_UP);
        BigDecimal total = getSubtotal().add(getTaxAmount()).add(getDeliveryFee()).subtract(discountAmount);
        if (total.compareTo(BigDecimal.ZERO) < 0) {
            total = BigDecimal.ZERO;
        }
        return total.setScale(2, RoundingMode.HALF_UP);
    }
}
