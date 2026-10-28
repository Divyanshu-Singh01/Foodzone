package com.foodzone.model;

import java.io.Serializable;
import java.math.BigDecimal;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

public class Order implements Serializable {
    private static final long serialVersionUID = 1L;

    private int orderId;
    private int userId;
    private String orderType = "DELIVERY"; // 'DELIVERY' or 'TAKEAWAY'
    private Timestamp orderDate;
    private BigDecimal subtotal;
    private BigDecimal taxAmount;
    private BigDecimal deliveryFee;
    private BigDecimal discountAmount = BigDecimal.ZERO;
    private BigDecimal totalAmount;
    private String orderStatus; // 'PENDING', 'PREPARING', 'OUT_FOR_DELIVERY', 'COMPLETED', 'CANCELLED'
    private String deliveryAddress;
    private String landmark;
    private String addressType = "HOME"; // 'HOME', 'WORK', 'OTHER'
    private String deliveryInstructions;
    private String contactPhone;
    private String alternatePhone;
    private String paymentMethod;
    private String deliveryOtp;
    private String couponCode;
    private Integer riderId;
    private String tripStage = "ASSIGNED"; // 'ASSIGNED', 'PICKED_UP', 'ARRIVED', 'DELIVERED'
    private String deliveryNote;
    private BigDecimal cashReceived;
    private String specialNotes;

    // Joined fields for view
    private String customerName;
    private String customerEmail;
    private String riderName;
    private String riderPhone;
    private String riderVehicle;
    private List<OrderItem> items = new ArrayList<>();

    public Order() {}

    public Order(int orderId, int userId, Timestamp orderDate, BigDecimal subtotal, BigDecimal taxAmount,
                 BigDecimal deliveryFee, BigDecimal totalAmount, String orderStatus, String deliveryAddress,
                 String contactPhone, String paymentMethod, String specialNotes) {
        this.orderId = orderId;
        this.userId = userId;
        this.orderDate = orderDate;
        this.subtotal = subtotal;
        this.taxAmount = taxAmount;
        this.deliveryFee = deliveryFee;
        this.totalAmount = totalAmount;
        this.orderStatus = orderStatus;
        this.deliveryAddress = deliveryAddress;
        this.contactPhone = contactPhone;
        this.paymentMethod = paymentMethod;
        this.specialNotes = specialNotes;
    }

    public int getOrderId() { return orderId; }
    public void setOrderId(int orderId) { this.orderId = orderId; }

    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }

    public Timestamp getOrderDate() { return orderDate; }
    public void setOrderDate(Timestamp orderDate) { this.orderDate = orderDate; }

    public String getFormattedTime() {
        if (orderDate == null) return "";
        return new java.text.SimpleDateFormat("hh:mm a").format(orderDate);
    }

    public String getFormattedDate() {
        if (orderDate == null) return "";
        return new java.text.SimpleDateFormat("dd MMM yyyy, hh:mm a").format(orderDate);
    }

    public BigDecimal getSubtotal() { return subtotal; }
    public void setSubtotal(BigDecimal subtotal) { this.subtotal = subtotal; }

    public BigDecimal getTaxAmount() { return taxAmount; }
    public void setTaxAmount(BigDecimal taxAmount) { this.taxAmount = taxAmount; }

    public BigDecimal getDeliveryFee() { return deliveryFee; }
    public void setDeliveryFee(BigDecimal deliveryFee) { this.deliveryFee = deliveryFee; }

    public BigDecimal getTotalAmount() { return totalAmount; }
    public void setTotalAmount(BigDecimal totalAmount) { this.totalAmount = totalAmount; }

    public String getOrderStatus() { return orderStatus; }
    public void setOrderStatus(String orderStatus) { this.orderStatus = orderStatus; }

    public String getDeliveryAddress() { return deliveryAddress; }
    public void setDeliveryAddress(String deliveryAddress) { this.deliveryAddress = deliveryAddress; }

    public String getContactPhone() { return contactPhone; }
    public void setContactPhone(String contactPhone) { this.contactPhone = contactPhone; }

    public String getPaymentMethod() { return paymentMethod; }
    public void setPaymentMethod(String paymentMethod) { this.paymentMethod = paymentMethod; }

    public String getSpecialNotes() { return specialNotes; }
    public void setSpecialNotes(String specialNotes) { this.specialNotes = specialNotes; }

    public String getCustomerName() { return customerName; }
    public void setCustomerName(String customerName) { this.customerName = customerName; }

    public String getCustomerEmail() { return customerEmail; }
    public void setCustomerEmail(String customerEmail) { this.customerEmail = customerEmail; }

    public String getOrderType() { return orderType; }
    public void setOrderType(String orderType) { this.orderType = orderType; }

    public String getDeliveryOtp() { return deliveryOtp; }
    public void setDeliveryOtp(String deliveryOtp) { this.deliveryOtp = deliveryOtp; }

    public String getCouponCode() { return couponCode; }
    public void setCouponCode(String couponCode) { this.couponCode = couponCode; }

    public BigDecimal getDiscountAmount() { return discountAmount; }
    public void setDiscountAmount(BigDecimal discountAmount) { this.discountAmount = discountAmount; }

    public Integer getRiderId() { return riderId; }
    public void setRiderId(Integer riderId) { this.riderId = riderId; }

    public String getRiderName() { return riderName; }
    public void setRiderName(String riderName) { this.riderName = riderName; }

    public String getRiderPhone() { return riderPhone; }
    public void setRiderPhone(String riderPhone) { this.riderPhone = riderPhone; }

    public String getRiderVehicle() { return riderVehicle; }
    public void setRiderVehicle(String riderVehicle) { this.riderVehicle = riderVehicle; }

    public String getLandmark() { return landmark; }
    public void setLandmark(String landmark) { this.landmark = landmark; }

    public String getAddressType() { return addressType; }
    public void setAddressType(String addressType) { this.addressType = addressType; }

    public String getDeliveryInstructions() { return deliveryInstructions; }
    public void setDeliveryInstructions(String deliveryInstructions) { this.deliveryInstructions = deliveryInstructions; }

    public String getAlternatePhone() { return alternatePhone; }
    public void setAlternatePhone(String alternatePhone) { this.alternatePhone = alternatePhone; }

    public String getTripStage() { return tripStage; }
    public void setTripStage(String tripStage) { this.tripStage = tripStage; }

    public String getDeliveryNote() { return deliveryNote; }
    public void setDeliveryNote(String deliveryNote) { this.deliveryNote = deliveryNote; }

    public BigDecimal getCashReceived() { return cashReceived; }
    public void setCashReceived(BigDecimal cashReceived) { this.cashReceived = cashReceived; }

    public List<OrderItem> getItems() { return items; }
    public void setItems(List<OrderItem> items) { this.items = items; }
}
