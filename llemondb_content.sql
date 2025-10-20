USE LLemonDB;

-- =======================================
-- CUSTOMER DETAILS
-- =======================================
INSERT INTO Customer (full_name, phone_number, email, address)
VALUES
('John Smith', '08011112222', 'john.smith@gmail.com', '12 Pine Street, Lagos'),
('Mary Johnson', '08033334444', 'mary.j@gmail.com', '45 Elm Avenue, Abuja'),
('James Okafor', '08055556666', 'james.okafor@gmail.com', '23 Unity Road, Enugu'),
('Fatima Bello', '08077778888', 'fatima.b@gmail.com', '89 Palm Close, Kano'),
('Daniel Obi', '08099990000', 'daniel.obi@gmail.com', '17 Coral Drive, Port Harcourt');

-- =======================================
-- STAFF INFORMATION
-- =======================================
INSERT INTO Staff (full_name, role, salary, phone_number, email)
VALUES
('Grace Thomas', 'Manager', 250000.00, '08122223333', 'grace.thomas@littlelemon.com'),
('Samuel Adeniyi', 'Waiter', 120000.00, '08144445555', 'samuel.adeniyi@littlelemon.com'),
('Chika Eze', 'Chef', 200000.00, '08166667777', 'chika.eze@littlelemon.com'),
('David Mark', 'Receptionist', 100000.00, '08188889999', 'david.mark@littlelemon.com'),
('Helen Musa', 'Delivery', 90000.00, '08100001111', 'helen.musa@littlelemon.com');

-- =======================================
-- BOOKINGS
-- =======================================
INSERT INTO Bookings (customer_id, staff_id, booking_date, table_number)
VALUES
(1, 4, '2025-10-10', 5),
(2, 4, '2025-10-11', 2),
(3, 1, '2025-10-12', 7),
(4, 4, '2025-10-12', 1),
(5, 1, '2025-10-13', 3);

-- =======================================
-- MENU
-- =======================================
INSERT INTO Menu (item_name, category, price)
VALUES
('Caesar Salad', 'Starter', 2500.00),
('Jollof Rice with Chicken', 'Course', 5500.00),
('Beef Burger', 'Course', 4500.00),
('Orange Juice', 'Drink', 1500.00),
('Chocolate Cake', 'Dessert', 3000.00),
('Fried Rice with Fish', 'Course', 5000.00),
('Chapman', 'Drink', 2000.00),
('Efo Riro', 'Cuisine', 4000.00);

-- =======================================
-- ORDERS
-- =======================================
INSERT INTO Orders (customer_id, staff_id, booking_id, order_date, total_cost)
VALUES
(1, 2, 1, '2025-10-10', NULL),
(2, 3, 2, '2025-10-11', NULL),
(3, 2, 3, '2025-10-12', NULL),
(4, 3, 4, '2025-10-12', NULL),
(5, 2, 5, '2025-10-13', NULL);

-- =======================================
-- ORDER DETAILS (TRIGGER WILL COMPUTE SUBTOTAL)
-- =======================================
INSERT INTO OrderDetails (order_id, menu_id, quantity)
VALUES
(1, 1, 2), 
(1, 2, 1), 
(2, 3, 1), 
(2, 4, 2), 
(3, 6, 1), 
(3, 7, 1), 
(4, 2, 1), 
(4, 5, 1), 
(5, 8, 1), 
(5, 4, 2); 

-- =======================================
-- 7️⃣ ORDER DELIVERY STATUS
-- =======================================
INSERT INTO OrderDeliveryStatus (order_id, staff_id, delivery_date, status)
VALUES
(1, 5, '2025-10-10', 'Delivered'),
(2, 5, '2025-10-11', 'Delivered'),
(3, 5, '2025-10-12', 'Delivered'),
(4, 5, '2025-10-12', 'Pending'),
(5, 5, NULL, 'In Progress');
