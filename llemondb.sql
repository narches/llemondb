-- Create Database
CREATE DATABASE LLemonDB;


USE LLemonDB;


-- =======================================
-- CUSTOMER TABLE
-- =======================================
CREATE TABLE Customer (
    customer_id INT AUTO_INCREMENT PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    phone_number VARCHAR(15) NOT NULL UNIQUE,
    email VARCHAR(100) UNIQUE,
    address VARCHAR(255)
);

-- =======================================
-- STAFF TABLE
-- =======================================
CREATE TABLE Staff (
    staff_id INT AUTO_INCREMENT PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    role VARCHAR(50) NOT NULL,
    salary DECIMAL(10,2) NOT NULL,
    phone_number VARCHAR(15),
    email VARCHAR(100) UNIQUE
);

-- =======================================
--  BOOKINGS TABLE
-- =======================================
CREATE TABLE Bookings (
    booking_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT NOT NULL,
    staff_id INT,
    booking_date DATE NOT NULL,
    table_number INT NOT NULL,
    CONSTRAINT fk_booking_customer
        FOREIGN KEY (customer_id) REFERENCES Customer(customer_id)
        ON DELETE CASCADE,
    CONSTRAINT fk_booking_staff
        FOREIGN KEY (staff_id) REFERENCES Staff(staff_id)
        ON DELETE SET NULL
);

-- =======================================
-- MENU TABLE
-- =======================================
CREATE TABLE Menu (
    menu_id INT AUTO_INCREMENT PRIMARY KEY,
    item_name VARCHAR(100) NOT NULL,
    category ENUM('Starter','Course','Drink','Dessert','Cuisine') NOT NULL,
    price DECIMAL(10,2) NOT NULL
);

-- =======================================
-- ORDERS TABLE
-- =======================================
CREATE TABLE Orders (
    order_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT NOT NULL,
    staff_id INT,
    booking_id INT,
    order_date DATE NOT NULL,
    total_cost DECIMAL(10,2),
    CONSTRAINT fk_order_customer
        FOREIGN KEY (customer_id) REFERENCES Customer(customer_id)
        ON DELETE CASCADE,
    CONSTRAINT fk_order_staff
        FOREIGN KEY (staff_id) REFERENCES Staff(staff_id)
        ON DELETE SET NULL,
    CONSTRAINT fk_order_booking
        FOREIGN KEY (booking_id) REFERENCES Bookings(booking_id)
        ON DELETE SET NULL
);

-- =======================================
-- ORDER DETAILS (JUNCTION TABLE)
-- =======================================
CREATE TABLE OrderDetails (
    orderdetail_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT NOT NULL,
    menu_id INT NOT NULL,
    quantity INT NOT NULL CHECK (quantity > 0),
    subtotal DECIMAL(10,2),
    CONSTRAINT fk_orderdetail_order
        FOREIGN KEY (order_id) REFERENCES Orders(order_id)
        ON DELETE CASCADE,
    CONSTRAINT fk_orderdetail_menu
        FOREIGN KEY (menu_id) REFERENCES Menu(menu_id)
        ON DELETE CASCADE
);

-- =======================================
-- TRIGGER: AUTO-CALCULATE SUBTOTAL
-- =======================================
DELIMITER //
CREATE TRIGGER before_orderdetails_insert
BEFORE INSERT ON OrderDetails
FOR EACH ROW
BEGIN
    DECLARE item_price DECIMAL(10,2);
    SELECT price INTO item_price FROM Menu WHERE menu_id = NEW.menu_id;
    SET NEW.subtotal = NEW.quantity * item_price;
END //
DELIMITER ;

-- =======================================
-- ORDER DELIVERY STATUS TABLE
-- =======================================
CREATE TABLE OrderDeliveryStatus (
    delivery_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT NOT NULL,
    staff_id INT,
    delivery_date DATE,
    status ENUM('Pending','In Progress','Delivered','Cancelled') DEFAULT 'Pending',
    CONSTRAINT fk_delivery_order
        FOREIGN KEY (order_id) REFERENCES Orders(order_id)
        ON DELETE CASCADE,
    CONSTRAINT fk_delivery_staff
        FOREIGN KEY (staff_id) REFERENCES Staff(staff_id)
        ON DELETE SET NULL
);
