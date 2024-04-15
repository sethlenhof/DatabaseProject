use event_management_system;
DROP PROCEDURE IF EXISTS insert_super_admin;

DELIMITER //
CREATE PROCEDURE insert_super_admin(
    IN admin_email VARCHAR(255),
    IN admin_name VARCHAR(255),
    IN university_name VARCHAR(255) -- Placeholder name
)
BEGIN
    DECLARE userID CHAR(255);
    DECLARE uni_id INT;
    DECLARE user_exists INT DEFAULT 0;
    DECLARE super_admin_exists INT DEFAULT 0;

    -- Check if user exists in USER_LOGIN and retrieve userID
    SELECT COUNT(*) INTO user_exists FROM USER_LOGIN WHERE EMAIL = admin_email;
    IF user_exists = 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error: No user found with the specified email';
    END IF;

    -- Retrieve userID
    SELECT USER_ID INTO userID FROM USER_LOGIN WHERE EMAIL = admin_email;
    IF userID IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error: User ID is null after selection.';
    ELSE
        SELECT 'User ID retrieved successfully', userID;
    END IF;

     -- Check if a super admin entry already exists for this userID
    SELECT COUNT(*) INTO super_admin_exists FROM SUPER_ADMIN WHERE USER_ID = userID;
    IF super_admin_exists > 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error: A super admin entry already exists for this user';
    END IF;

    START TRANSACTION;

    -- Insert the new university with minimal initial data
    INSERT INTO UNIVERSITY (UNIVERSITY_NAME, UNIVERSITY_LOCATION, UNI_DESCRIPTION, NUM_OF_STUDENTS, COLOR)
    VALUES (university_name, NULL, NULL, NULL, NULL);

    -- Get the last inserted university ID
    SET uni_id = LAST_INSERT_ID();

    -- Insert or update user info
    INSERT INTO USER_INFO (USER_ID, USERS_NAME, UNIVERSITY_ID)
    VALUES (userID, admin_name, uni_id)
    ON DUPLICATE KEY UPDATE USERS_NAME = VALUES(USERS_NAME), UNIVERSITY_ID = VALUES(UNIVERSITY_ID);

    -- Insert into SUPER_ADMIN table
    INSERT INTO SUPER_ADMIN (USER_ID, UNIVERSITY_ID)
    VALUES (userID, uni_id)
    ON DUPLICATE KEY UPDATE UNIVERSITY_ID = VALUES(UNIVERSITY_ID);

    COMMIT;
END //

DELIMITER ;

-- Call the procedure
CALL insert_super_admin('admin@admin.com', 'Admin Name', 'University Name');

SELECT * FROM SUPER_ADMIN;