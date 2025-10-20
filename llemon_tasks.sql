USE llemondb;

-- CREATING A STORED PROCEDURE
DELIMITER //
CREATE PROCEDURE GetMaxQuantity()
BEGIN
    SELECT 
        MAX(quantity) AS Max_Ordered_Quantity
    FROM 
        OrderDetails;
END //
DELIMITER ;

CALL GetMaxQuantity()

-- CREATING A PREPARED STATEMENT

PREPARE GetOrderDetail 
FROM 
'SELECT 
     o.order_id, 
     od.quantity, 
     o.total_cost
 FROM Orders o
 JOIN OrderDetails od ON o.order_id = od.order_id
 WHERE o.customer_id = ?';

SET @id = 1;

-- EXECUTING PRPEARED STATEMENT
EXECUTE GetOrderDetail USING @id;


-- DEALLOCATING PREPARED STATEMENT
DEALLOCATE PREPARE GetOrderDetail;


-- STORED PROCEDURE - CANCELLING ORDER
DELIMITER //
CREATE PROCEDURE CancelOrder(IN orderId INT)
BEGIN
    -- Check if the order exists
    IF EXISTS (SELECT 1 FROM Orders WHERE order_id = orderId) THEN
        -- Delete related records in the correct order due to foreign keys
        DELETE FROM OrderDetails WHERE order_id = orderId;
        DELETE FROM OrderDeliveryStatus WHERE order_id = orderId;
        DELETE FROM Orders WHERE order_id = orderId;
        
        SELECT CONCAT('Order with ID ', orderId, ' has been successfully cancelled.') AS Message;
    ELSE
        SELECT CONCAT('Order with ID ', orderId, ' does not exist.') AS Message;
    END IF;
END //
DELIMITER ;

-- CALL CancelOrder(5)
CALL CancelOrder(3);

-- CHECKING FOR CONTENTS OF BOOKING TABLE
SELECT * FROM bookings;

-- CREATING A STORED PROCEDURE FOR CHECKINGBOOKING
DELIMITER //
CREATE PROCEDURE CheckBooking(
    IN bookingDate DATE,
    IN tableNumber INT
)
BEGIN
    DECLARE tableStatus VARCHAR(50);

    -- Check if a booking exists for that date and table number
    IF EXISTS (
        SELECT 1 
        FROM Bookings 
        WHERE booking_date = bookingDate 
        AND table_number = tableNumber
    ) THEN
        SET tableStatus = 'Table is already booked for the selected date.';
    ELSE
        SET tableStatus = 'Table is available for booking.';
    END IF;

    -- Display the result
    SELECT tableStatus AS StatusMessage;
END //
DELIMITER ;


-- CALLING THE CHECKINGBOOKING STORED PROCEDURE
CALL CheckBooking('2025-10-12', 7);


-- CREATING THE BOOKING VALIDATION STROED PROCEDURE
DELIMITER //
CREATE PROCEDURE AddValidBooking(
    IN inCustomerID INT,
    IN inStaffID INT,
    IN inBookingDate DATE,
    IN inTableNumber INT
)
BEGIN
    DECLARE bookingExists INT DEFAULT 0;

    -- Start the transaction
    START TRANSACTION;

    -- Check if a booking already exists for the same table and date
    SELECT COUNT(*) INTO bookingExists
    FROM Bookings
    WHERE booking_date = inBookingDate
      AND table_number = inTableNumber;

    -- If table is already booked, rollback
    IF bookingExists > 0 THEN
        ROLLBACK;
        SELECT CONCAT('Booking declined: Table ', inTableNumber, 
                      ' is already booked on ', inBookingDate) AS StatusMessage;
    ELSE
        -- Otherwise insert the new booking
        INSERT INTO Bookings (customer_id, staff_id, booking_date, table_number)
        VALUES (inCustomerID, inStaffID, inBookingDate, inTableNumber);

        COMMIT;
        SELECT CONCAT('Booking confirmed for table ', inTableNumber, 
                      ' on ', inBookingDate) AS StatusMessage;
    END IF;
END //
DELIMITER ;

-- CALLING THE ADDVALIDBOOKING
CALL AddValidBooking(2, 4, '2025-10-15', 5);

-- CREATING THE ADDBOOKING STORED PROCEDURE
DELIMITER $$
CREATE PROCEDURE AddBooking(
    IN p_booking_id INT,
    IN p_customer_id INT,
    IN p_booking_date DATE,
    IN p_table_number INT
)
BEGIN
    INSERT INTO bookings (booking_id, customer_id, booking_date, table_number)
    VALUES (p_booking_id, p_customer_id, p_booking_date, p_table_number);
    
    SELECT 'New booking record added successfully.' AS Confirmation;
END $$
DELIMITER ;

-- CALLING THE ADDBOOKING 
CALL AddBooking(101, 3, '2025-10-20', 7);


-- CREATING THE UPDATE-BOOKING STORED PROCEDURE
DELIMITER $$
CREATE PROCEDURE UpdateBooking(
    IN p_booking_id INT,
    IN p_booking_date DATE
)
BEGIN
    UPDATE bookings
    SET booking_date = p_booking_date
    WHERE booking_id = p_booking_id;

    SELECT CONCAT('Booking ID ', p_booking_id, ' has been updated to ', p_booking_date) AS Confirmation;
END $$
DELIMITER ;


-- CALLING THE UPDATE BOOKING
CALL UpdateBooking(101, '2025-11-05');


-- CREATING CANCELBOOKING
DELIMITER $$
CREATE PROCEDURE CancelBooking(
    IN p_booking_id INT
)
BEGIN
    DELETE FROM bookings
    WHERE booking_id = p_booking_id;

    SELECT CONCAT('Booking ID ', p_booking_id, ' has been successfully cancelled.') AS Confirmation;
END $$
DELIMITER ;

-- CALLING THE CANCELBOOKING PROCEDURE
CALL CancelBooking(105);



