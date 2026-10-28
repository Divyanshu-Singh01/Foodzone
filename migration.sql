USE foodzone_db;

-- 1. Update user roles
ALTER TABLE users 
    MODIFY COLUMN role ENUM('CUSTOMER', 'ADMIN', 'DELIVERY') DEFAULT 'CUSTOMER';

-- 2. Add rider columns to users
ALTER TABLE users ADD COLUMN vehicle_no VARCHAR(30) AFTER phone;
ALTER TABLE users ADD COLUMN is_active_rider BOOLEAN DEFAULT TRUE AFTER vehicle_no;

-- 3. Seed Demo Delivery Partner
INSERT INTO users (full_name, email, password_hash, phone, vehicle_no, role) 
VALUES ('Vikram Singh (Rider)', 'rider@foodzone.com', 'rider123', '9876500001', 'DL 04 AB 1234', 'DELIVERY')
ON DUPLICATE KEY UPDATE full_name=VALUES(full_name), vehicle_no=VALUES(vehicle_no);

-- 4. Add columns to orders
ALTER TABLE orders ADD COLUMN order_type ENUM('DELIVERY', 'TAKEAWAY') DEFAULT 'DELIVERY' AFTER user_id;
ALTER TABLE orders ADD COLUMN delivery_otp VARCHAR(6) AFTER payment_method;
ALTER TABLE orders ADD COLUMN coupon_code VARCHAR(30) NULL AFTER delivery_otp;
ALTER TABLE orders ADD COLUMN discount_amount DECIMAL(10,2) DEFAULT 0.00 AFTER coupon_code;
ALTER TABLE orders ADD COLUMN rider_id INT NULL AFTER discount_amount;

-- 5. Create Coupons table
CREATE TABLE IF NOT EXISTS coupons (
    coupon_id INT AUTO_INCREMENT PRIMARY KEY,
    code VARCHAR(30) NOT NULL UNIQUE,
    discount_amount DECIMAL(10,2) NOT NULL,
    min_order_amount DECIMAL(10,2) NOT NULL DEFAULT 0.00,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

INSERT INTO coupons (code, discount_amount, min_order_amount, is_active) VALUES
('WELCOME50', 50.00, 200.00, TRUE),
('DOM100', 100.00, 400.00, TRUE),
('FREEDEL', 40.00, 150.00, TRUE)
ON DUPLICATE KEY UPDATE discount_amount=VALUES(discount_amount);

-- 6. Create Reviews table
CREATE TABLE IF NOT EXISTS reviews (
    review_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT NOT NULL,
    user_id INT NOT NULL,
    food_id INT NOT NULL,
    rating INT NOT NULL CHECK (rating BETWEEN 1 AND 5),
    review_text TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_rev_order FOREIGN KEY (order_id) REFERENCES orders(order_id) ON DELETE CASCADE,
    CONSTRAINT fk_rev_user FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    CONSTRAINT fk_rev_food FOREIGN KEY (food_id) REFERENCES food_items(food_id) ON DELETE CASCADE
) ENGINE=InnoDB;
