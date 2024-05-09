DELIMITER $$

-- Drop the procedure if it already exists
DROP PROCEDURE IF EXISTS AddNewLocation$$

-- Create a new stored procedure AddNewLocation
CREATE PROCEDURE AddNewLocation (
	IN zip_code_prefix INT,
    IN latitude DECIMAL (50, 20),
    IN longitude DECIMAL (50, 20),
    IN city VARCHAR(30),
    IN state CHAR(2)
)
BEGIN

	-- Start a new transaction to ensure atomicity
    START TRANSACTION;
    
   -- Insert new location into the 'location' table
    INSERT INTO location (zip_code_prefix, latitude, longitude,city,state)
    VALUES (zip_code_prefix, latitude, longitude,city,state);

	-- Commit the transaction to make the changes permanent
    COMMIT;
END $$

DELIMITER ;

-- Call the AddNewLocation procedure with values
CALL AddNewLocation(99950,-28.07010363,-52.01865773,"tapejara","RS");

-- retrieving the whole table to check if the location is added
SELECT * FROM location;


DELIMITER $$

-- Drop the procedure if it already exists
DROP PROCEDURE IF EXISTS UpdateCustomerLocation$$

-- Create a new stored procedure UpdateCustomerLocation
CREATE PROCEDURE UpdateCustomerLocation (
	IN customerId VARCHAR(50),
	IN newZipCodePrefix INT
)
BEGIN
	-- Start a new transaction to ensure atomicity
    START TRANSACTION;
    
    -- Update the zip_code_prefix for a specific customer in the 'customers' table
    UPDATE customers
    SET zip_code_prefix = newZipCodePrefix
    WHERE customer_id = customerId;
    
    -- Commit the transaction to make the changes permanent
    COMMIT;

END $$

DELIMITER ;

-- Call the UpdateCustomerLocation procedure with values
CALL UpdateCustomerLocation('00a39528c677a55852f57235f988b837', 99950);

-- retrieving the whole table to check if the customer information is updated
SELECT * FROM customers;


