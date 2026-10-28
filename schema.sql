-- ========================================================
-- FoodZone Database Schema & Seed Script
-- Project: Online Food Ordering & Management System
-- Target: MySQL Server 8.0+ / MySQL Workbench
-- ========================================================

CREATE DATABASE IF NOT EXISTS foodzone_db
    CHARACTER SET utf8mb4
    COLLATE utf8mb4_unicode_ci;

USE foodzone_db;

-- --------------------------------------------------------
-- Table 1: Users (Customers & Administrators)
-- --------------------------------------------------------
DROP TABLE IF EXISTS order_items;
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS food_items;
DROP TABLE IF EXISTS categories;
DROP TABLE IF EXISTS users;

CREATE TABLE users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    email VARCHAR(120) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    phone VARCHAR(20) NOT NULL,
    vehicle_no VARCHAR(30) NULL,
    is_active_rider BOOLEAN DEFAULT TRUE,
    address TEXT,
    role ENUM('CUSTOMER', 'ADMIN', 'DELIVERY') DEFAULT 'CUSTOMER',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

-- --------------------------------------------------------
-- Table 2: Categories (Menu Categories)
-- --------------------------------------------------------
CREATE TABLE categories (
    category_id INT AUTO_INCREMENT PRIMARY KEY,
    category_name VARCHAR(60) NOT NULL UNIQUE,
    description VARCHAR(255),
    icon_class VARCHAR(50) DEFAULT 'fa-utensils'
) ENGINE=InnoDB;

-- --------------------------------------------------------
-- Table 3: Food Items (Dishes & Products)
-- --------------------------------------------------------
CREATE TABLE food_items (
    food_id INT AUTO_INCREMENT PRIMARY KEY,
    category_id INT NOT NULL,
    food_name VARCHAR(120) NOT NULL,
    description TEXT,
    price DECIMAL(10, 2) NOT NULL CHECK (price >= 0),
    image_url VARCHAR(255),
    is_veg BOOLEAN DEFAULT TRUE,
    is_available BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_food_category
        FOREIGN KEY (category_id) REFERENCES categories(category_id)
        ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB;

-- --------------------------------------------------------
-- Table 4: Orders (Customer Orders Header)
-- --------------------------------------------------------
CREATE TABLE orders (
    order_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    order_type ENUM('DELIVERY', 'TAKEAWAY') DEFAULT 'DELIVERY',
    order_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    subtotal DECIMAL(10, 2) NOT NULL,
    tax_amount DECIMAL(10, 2) NOT NULL DEFAULT 0.00,
    delivery_fee DECIMAL(10, 2) NOT NULL DEFAULT 0.00,
    discount_amount DECIMAL(10, 2) NOT NULL DEFAULT 0.00,
    total_amount DECIMAL(10, 2) NOT NULL,
    order_status ENUM('PENDING', 'PREPARING', 'OUT_FOR_DELIVERY', 'COMPLETED', 'CANCELLED') DEFAULT 'PENDING',
    delivery_address TEXT NOT NULL,
    contact_phone VARCHAR(20) NOT NULL,
    payment_method VARCHAR(30) DEFAULT 'Cash on Delivery',
    delivery_otp VARCHAR(6) NULL,
    coupon_code VARCHAR(30) NULL,
    rider_id INT NULL,
    special_notes TEXT,
    CONSTRAINT fk_order_user
        FOREIGN KEY (user_id) REFERENCES users(user_id)
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_order_rider
        FOREIGN KEY (rider_id) REFERENCES users(user_id)
        ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB;

-- --------------------------------------------------------
-- Table 5: Order Items (Line Items in an Order)
-- --------------------------------------------------------
CREATE TABLE order_items (
    order_item_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT NOT NULL,
    food_id INT NOT NULL,
    quantity INT NOT NULL CHECK (quantity > 0),
    unit_price DECIMAL(10, 2) NOT NULL,
    subtotal DECIMAL(10, 2) NOT NULL,
    CONSTRAINT fk_order_parent
        FOREIGN KEY (order_id) REFERENCES orders(order_id)
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_order_food
        FOREIGN KEY (food_id) REFERENCES food_items(food_id)
        ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB;

-- ========================================================
-- Seed Data for Testing & Demonstration
-- ========================================================

-- Users (1 Admin, 1 Customer, 1 Delivery Partner)
INSERT INTO users (full_name, email, password_hash, phone, address, vehicle_no, role) VALUES
('System Administrator', 'admin@foodzone.com', 'admin123', '9876543210', 'FoodZone HQ, Suite 101', NULL, 'ADMIN'),
('Rahul Sharma', 'customer@gmail.com', 'user123', '9123456780', 'Flat 402, Green Valley Apts, MG Road', NULL, 'CUSTOMER'),
('Vikram Singh (Rider)', 'rider@foodzone.com', 'rider123', '9876500001', 'Delivery Hub North', 'DL 04 AB 1234', 'DELIVERY');

-- Coupons
INSERT INTO coupons (coupon_code, discount_type, discount_value, min_order_amount, is_active) VALUES
('WELCOME50', 'FLAT', 50.00, 200.00, TRUE),
('DOM100', 'FLAT', 100.00, 400.00, TRUE),
('FREEDEL', 'FREE_DELIVERY', 40.00, 150.00, TRUE);

-- Categories
INSERT INTO categories (category_name, description, icon_class) VALUES
('Pizzas', 'Oven-fresh stone baked pizzas with premium toppings', 'fa-pizza-slice'),
('Burgers', 'Gourmet juicy patties served in toasted brioche buns', 'fa-hamburger'),
('Biryani & Rice', 'Authentic spiced dum biryani and fragrant rice bowls', 'fa-bowl-rice'),
('Beverages', 'Chilled refreshers, cold brews, and mocktails', 'fa-glass-water'),
('Desserts', 'Sweet gourmet treats, cakes, and artisanal pastries', 'fa-ice-cream');

-- Food Items
INSERT INTO food_items (category_id, food_name, description, price, image_url, is_veg, is_available) VALUES
(1, 'Margherita Pizza', 'Classic Italian mozzarella, San Marzano tomato sauce, and fresh basil leaves.', 249.00, 'https://images.unsplash.com/photo-1604382355076-af4b0eb60143?w=600', TRUE, TRUE),
(1, 'Paneer Tikka Pizza', 'Spicy tandoori paneer cubes, crisp bell peppers, red onions, and melted cheese.', 329.00, 'https://images.unsplash.com/photo-1513104890138-7c749659a591?w=600', TRUE, TRUE),
(1, 'Chicken Supreme Pizza', 'Loaded with grilled chicken, smokey barbecue drizzle, and button mushrooms.', 399.00, 'https://images.unsplash.com/photo-1565299624946-b28f40a0ae38?w=600', FALSE, TRUE),
(2, 'Classic Crispy Veg Burger', 'Golden spiced potato-herb patty with crunchy lettuce and signature mayo.', 129.00, 'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?w=600', TRUE, TRUE),
(2, 'Smoked Cheese Chicken Burger', 'Crispy spiced chicken fillet topped with melted cheddar and caramelized onions.', 189.00, 'https://images.unsplash.com/photo-1550547660-d9450f859349?w=600', FALSE, TRUE),
(3, 'Hyderabadi Chicken Dum Biryani', 'Slow-cooked aromatic basmati rice layered with succulent marinated chicken and saffron.', 299.00, 'https://images.unsplash.com/photo-1563379091339-03b21ab4a4f8?w=600', FALSE, TRUE),
(3, 'Royal Vegetable Dum Biryani', 'Fragrant basmati rice cooked with fresh seasonal garden veggies, mint, and whole spices.', 229.00, 'https://images.unsplash.com/photo-1589302168068-964664d93dc0?w=600', TRUE, TRUE),
(4, 'Cold Coffee with Ice Cream', 'Chilled espresso blended with thick dairy milk and topped with vanilla bean scoop.', 99.00, 'https://images.unsplash.com/photo-1517701604599-bb29b565090c?w=600', TRUE, TRUE),
(4, 'Fresh Mint Mojito', 'Crushed fresh garden mint, zesty lime juice, and sparkling soda over crushed ice.', 89.00, 'https://images.unsplash.com/photo-1551024709-8f23befc6f87?w=600', TRUE, TRUE),
(5, 'Warm Chocolate Lava Cake', 'Decadent warm dark chocolate sponge with an oozing liquid chocolate molten center.', 149.00, 'https://images.unsplash.com/photo-1606313564200-e75d5e30476c?w=600', TRUE, TRUE);

