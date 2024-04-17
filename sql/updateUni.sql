use event_management_system;

DROP PROCEDURE IF EXISTS update_university_info;
DROP PROCEDURE IF EXISTS testUpdateUniversity;
-- PROCEDURE TO UPDATE UNIVERSITY INFORMATION
DELIMITER //
CREATE PROCEDURE update_university_info(
    IN input_user_id CHAR(255),
    IN input_university_name VARCHAR(255),
    IN input_university_location VARCHAR(255),
    IN input_uni_description TEXT,
    IN input_num_of_students INT,
    IN input_color VARCHAR(255)
)
BEGIN
    DECLARE uni_id INT;

    -- Create a temporary table for response
    CREATE TEMPORARY TABLE IF NOT EXISTS RESPONSE (
        RESPONSE_STATUS VARCHAR(20),
        RESPONSE_MESSAGE VARCHAR(255)
    );

    -- Start the transaction
    START TRANSACTION;

    -- Check if the user is a super admin and get the associated university ID
    SELECT UNIVERSITY_ID INTO uni_id FROM SUPER_ADMIN WHERE USER_ID = input_user_id;

    -- Proceed with the update if the user is a super admin and a university ID was found
    IF uni_id IS NOT NULL THEN
        UPDATE UNIVERSITY
        SET UNIVERSITY_NAME = input_university_name,
            UNIVERSITY_LOCATION = input_university_location,
            UNI_DESCRIPTION = input_uni_description,
            NUM_OF_STUDENTS = input_num_of_students,
            COLOR = input_color
        WHERE UNIVERSITY_ID = uni_id;

        -- Commit the changes after successful update
        COMMIT;

        -- Insert success message into the RESPONSE table
        INSERT INTO RESPONSE (RESPONSE_STATUS, RESPONSE_MESSAGE) VALUES ('Success', 'University information updated successfully.');
    ELSE
        -- Rollback and insert error message if no valid super admin was found
        ROLLBACK;
        INSERT INTO RESPONSE (RESPONSE_STATUS, RESPONSE_MESSAGE) VALUES ('Error', 'User is not a super admin or university ID not found.');
    END IF;

    -- Return the response
    SELECT * FROM RESPONSE;
    DROP TEMPORARY TABLE IF EXISTS RESPONSE;
END //
DELIMITER ;


-- create test procedure for updating university info
DELIMITER //
CREATE PROCEDURE testUpdateUniversity()
BEGIN
    DECLARE userID CHAR(255);
    -- to test different user, update this email
    SELECT USER_ID INTO userID FROM USER_LOGIN WHERE EMAIL = 'admin@admin.com';
    CALL update_university_info(userID, 'New University Name', 'New Location', 'New Description', 1000, 'blue');
    SELECT * FROM UNIVERSITY;
    CALL update_university_info(userID, 'New Name', 'IDK Location', 'New Description', 1000, 'blue');

END //
DELIMITER ;

-- Call the procedure
CALL testUpdateUniversity();

SELECT * FROM UNIVERSITY;