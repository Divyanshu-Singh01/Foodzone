USE foodzone_db;

-- 1. Extend orders table with structured delivery info & trip progress
ALTER TABLE orders 
    ADD COLUMN landmark VARCHAR(120) NULL AFTER delivery_address,
    ADD COLUMN address_type VARCHAR(20) DEFAULT 'HOME' AFTER landmark,
    ADD COLUMN delivery_instructions VARCHAR(120) NULL AFTER address_type,
    ADD COLUMN alternate_phone VARCHAR(20) NULL AFTER contact_phone,
    ADD COLUMN trip_stage ENUM('ASSIGNED', 'PICKED_UP', 'ARRIVED', 'DELIVERED') DEFAULT 'ASSIGNED' AFTER rider_id,
    ADD COLUMN delivery_note VARCHAR(100) NULL AFTER trip_stage,
    ADD COLUMN cash_received DECIMAL(10,2) NULL AFTER delivery_note;

-- 2. Extend users table for enterprise rider compliance & shift state
ALTER TABLE users
    ADD COLUMN vehicle_type VARCHAR(30) DEFAULT 'Motorcycle' AFTER vehicle_no,
    ADD COLUMN license_no VARCHAR(50) DEFAULT 'DL-0420230012345' AFTER vehicle_type,
    ADD COLUMN emergency_phone VARCHAR(20) DEFAULT '9876599999' AFTER license_no,
    ADD COLUMN is_on_duty BOOLEAN DEFAULT TRUE AFTER is_active_rider;

-- 3. Extend reviews table
ALTER TABLE reviews
    ADD COLUMN delivery_rating INT DEFAULT 5 AFTER rating;
