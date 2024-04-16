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

    -- Check if an RSO with the same name already exists
    SELECT COUNT(*) INTO existing_rso_count FROM RSO WHERE RSO_NAME = rso_name;

    -- Start the transaction here to ensure all following operations are atomic
    START TRANSACTION;

    IF existing_rso_count > 0 THEN
        -- If an RSO with this name exists, rollback and signal an error
        ROLLBACK;
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'An RSO with this name already exists.';
    ELSEIF existing_user_count = 0 THEN
        -- If user does not exist, rollback and signal an error
        ROLLBACK;
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error: User ID does not exist in USER_INFO.';
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
        ELSE
            -- Rollback if an admin already exists
            ROLLBACK;
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'An admin already exists for this RSO.';
        END IF;
    END IF;
END //
DELIMITER ;

DROP PROCEDURE IF EXISTS testRSO;
-- Call the procedure using a test user
DELIMITER //
    CREATE PROCEDURE testRSO()
    BEGIN

    DECLARE userID CHAR(255);
    SELECT USER_ID INTO userID FROM USER_LOGIN WHERE EMAIL = 'test@test.com';
    CALL create_rso_and_admin(userID, 'RSO Name', 'RSO Color', 'RSO Description');

    SELECT * FROM RSO;
    SELECT * FROM RSO_ADMIN;
    SELECT * FROM STUDENT;

    -- Call the procedure again to see the error message
    CALL create_rso_and_admin(userID, 'FUCK', 'RSO Color', 'RSO Description');
    END //
DELIMITER ;

CALL create_rso_and_admin('d474223c-fbb8-11ee-a9fa-00155d00f503', 'res', 'RSO Color', 'RSO Description');

-- CALL testRSO();