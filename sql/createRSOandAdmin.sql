-- RSO stuff


use event_management_system;
DROP PROCEDURE IF EXISTS create_rso_and_admin;
DROP PROCEDURE IF EXISTS testRSO;


-- create a new RSO and assign the creating user as the admin
-- create a new RSO and assign the creating user as the admin
DELIMITER //
CREATE PROCEDURE create_rso_and_admin(
    IN input_user_id CHAR(255),
    IN rso_name VARCHAR(255),
    IN rso_color VARCHAR(255),
    IN rso_description TEXT
)
BEGIN
    DECLARE new_rso_id INT;
    DECLARE existing_admin_count INT;
    DECLARE existing_rso_count INT;
    DECLARE existing_user_count INT;

        CREATE TEMPORARY TABLE IF NOT EXISTS RESPONSE (
        RESPONSE_STATUS VARCHAR(20),
        RESPONSE_MESSAGE VARCHAR(255)
    );
    
    -- Check if an RSO with the same name already exists
    SELECT COUNT(*) INTO existing_rso_count FROM RSO WHERE RSO_NAME = rso_name;

    -- Start the transaction here to ensure all following operations are atomic
    START TRANSACTION;

    IF existing_rso_count > 0 THEN
        -- If an RSO with this name exists, rollback and signal an error
        ROLLBACK;
        INSERT INTO RESPONSE (RESPONSE_STATUS, RESPONSE_MESSAGE) VALUES ('ERROR', 'An RSO with this name already exists.');
    ELSEIF existing_user_count = 0 THEN
        -- If user does not exist, rollback and signal an error
        ROLLBACK;
        INSERT INTO RESPONSE (RESPONSE_STATUS, RESPONSE_MESSAGE) VALUES ('ERROR', 'User does not exist.');
    ELSE
        -- Insert new RSO
        INSERT INTO RSO (RSO_NAME, COLOR, RSO_DESCRIPTION)
        VALUES (rso_name, rso_color, rso_description);

        -- Capture the RSO_ID of the newly created RSO
        SET new_rso_id = LAST_INSERT_ID();

        -- Check if there is already an admin for the new RSO
        SELECT COUNT(*) INTO existing_admin_count FROM RSO_ADMIN WHERE RSO_ID = new_rso_id;

        -- Proceed only if there is no admin already set for this RSO
        IF existing_admin_count = 0 THEN
            -- Assign the creating user as the RSO admin
            INSERT INTO RSO_ADMIN (USER_ID, RSO_ID)
            VALUES (input_user_id, new_rso_id);

            -- Commit the transaction if all operations were successful
            COMMIT;
            INSERT INTO RESPONSE (RESPONSE_STATUS, RESPONSE_MESSAGE) VALUES ('SUCCESS', 'RSO created successfully.');
        ELSE
            -- Rollback if an admin already exists
            ROLLBACK;
            INSERT INTO RESPONSE (RESPONSE_STATUS, RESPONSE_MESSAGE) VALUES ('ERROR', 'An admin already exists for this RSO.');
        END IF;
    END IF;
    SELECT * FROM RESPONSE;
    DROP TEMPORARY TABLE IF EXISTS RESPONSE;
END //
DELIMITER ;

DROP PROCEDURE IF EXISTS testRSO;


-- Call the procedure using a admin user
DELIMITER //
    CREATE PROCEDURE testRSO()
    BEGIN

    DECLARE userID CHAR(255);
    SELECT USER_ID INTO userID FROM USER_LOGIN WHERE EMAIL = 'admin@admin.com';
    CALL create_rso_and_admin(userID, 'Sample RSO', 'red', 'RSO Description');

    SELECT * FROM RSO;
    SELECT * FROM RSO_ADMIN;
    SELECT * FROM STUDENT;

    -- Call the procedure again to see the error message
    CALL create_rso_and_admin(userID, 'Sample RSO', 'red', 'RSO Description');
    END //
DELIMITER ;

--call procedure to test the rso creation
CALL testRSO();