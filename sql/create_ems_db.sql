DROP DATABASE IF EXISTS event_management_system;
CREATE DATABASE event_management_system;
USE event_management_system;

-- Dropping tables in reverse order due to foreign key constraints
DROP TABLE IF EXISTS COMMENT;
DROP TABLE IF EXISTS APPROVED_EVENTS;
DROP TABLE IF EXISTS EVENTS;
DROP TABLE IF EXISTS SUPER_ADMIN;
DROP TABLE IF EXISTS RSO_ADMIN;
DROP TABLE IF EXISTS STUDENT;
DROP TABLE IF EXISTS USER_INFO;
DROP TABLE IF EXISTS RSO;
DROP TABLE IF EXISTS UNIVERSITY;
DROP TABLE IF EXISTS USER_LOGIN;

DROP USER IF EXISTS 'dev'@'localhost';

-- create dev user
-- CREATE USER 'dev'@'localhost' IDENTIFIED BY 'Password1!';
-- create if using js
CREATE USER 'dev'@'localhost' IDENTIFIED WITH mysql_native_password BY 'Password1!';

-- grant dev user permissions
GRANT ALL PRIVILEGES ON event_management_system.* TO 'dev'@'localhost';

FLUSH PRIVILEGES;

CREATE TABLE USER_LOGIN (
    USER_ID CHAR(255) PRIMARY KEY,
    EMAIL VARCHAR(255) NOT NULL UNIQUE,
    PASS VARCHAR(255) NOT NULL
);

CREATE TABLE UNIVERSITY (
    UNIVERSITY_ID INT AUTO_INCREMENT PRIMARY KEY NOT NULL,
    UNIVERSITY_NAME VARCHAR(255),
    UNIVERSITY_LOCATION VARCHAR(255),
    UNI_DESCRIPTION TEXT,
    NUM_OF_STUDENTS INT,
    COLOR VARCHAR(255)
);

CREATE TABLE RSO (
    RSO_ID INT AUTO_INCREMENT PRIMARY KEY,
    RSO_NAME VARCHAR(255),
    COLOR VARCHAR(255),
    RSO_DESCRIPTION TEXT
);

CREATE TABLE USER_INFO (
    USER_ID CHAR(255) PRIMARY KEY,
    USERS_NAME VARCHAR(255),
    UNIVERSITY_ID INT,
    FOREIGN KEY (UNIVERSITY_ID) REFERENCES UNIVERSITY(UNIVERSITY_ID)
);

CREATE TABLE STUDENT (
    RSO_ID INT,
    USER_ID CHAR(255),
    PRIMARY KEY (RSO_ID, USER_ID),
    FOREIGN KEY (USER_ID) REFERENCES USER_INFO(USER_ID),
    FOREIGN KEY (RSO_ID) REFERENCES RSO(RSO_ID)
);

CREATE TABLE RSO_ADMIN (
    USER_ID CHAR(255),
    RSO_ID INT,
    PRIMARY KEY (USER_ID, RSO_ID),
    FOREIGN KEY (USER_ID) REFERENCES USER_INFO(USER_ID),
    FOREIGN KEY (RSO_ID) REFERENCES RSO(RSO_ID)
);

CREATE TABLE SUPER_ADMIN (
    USER_ID CHAR(255),
    UNIVERSITY_ID INT,
    PRIMARY KEY (USER_ID, UNIVERSITY_ID),
    FOREIGN KEY (USER_ID) REFERENCES USER_INFO(USER_ID),
    FOREIGN KEY (UNIVERSITY_ID) REFERENCES UNIVERSITY(UNIVERSITY_ID)
);

CREATE TABLE EVENTS (
    EVENT_ID INT AUTO_INCREMENT PRIMARY KEY,
    RSO_ID INT,
    UNIVERSITY_ID INT,
    EVENT_LOCATION VARCHAR(255),
    EVENT_START VARCHAR(255),
    EVENT_END VARCHAR(255),
    FOREIGN KEY (RSO_ID) REFERENCES RSO(RSO_ID),
    FOREIGN KEY (UNIVERSITY_ID) REFERENCES UNIVERSITY(UNIVERSITY_ID)
);

CREATE TABLE APPROVED_EVENTS (
    EVENT_ID INT,
    SUPER_ADMIN_ID CHAR(255),
    PRIMARY KEY (EVENT_ID, SUPER_ADMIN_ID),
    FOREIGN KEY (EVENT_ID) REFERENCES EVENTS(EVENT_ID),
    FOREIGN KEY (SUPER_ADMIN_ID) REFERENCES SUPER_ADMIN(USER_ID)
);

CREATE TABLE COMMENT (
    COMMENT_ID INT AUTO_INCREMENT PRIMARY KEY,
    EVENT_ID INT,
    USER_ID CHAR(255),
    COMMENT TEXT,
    RATING INT,
    FOREIGN KEY (EVENT_ID) REFERENCES EVENTS(EVENT_ID),
    FOREIGN KEY (USER_ID) REFERENCES USER_INFO(USER_ID)
);


DELIMITER //
-- INSERT USER_LOGIN
CREATE PROCEDURE insert_user_login(IN input_email VARCHAR(255), IN input_pass VARCHAR(255))
BEGIN
    -- Check if the email already exists
    DECLARE emailExists INT;
    DECLARE passLength INT;
    DECLARE userGUID CHAR(255);

    SET userGUID = UUID();
    
    -- Create a temporary table for response
    CREATE TEMPORARY TABLE IF NOT EXISTS RESPONSE (
        RESPONSE_STATUS VARCHAR(20),
        RESPONSE_MESSAGE VARCHAR(255)
    );
    
    SELECT COUNT(*) INTO emailExists FROM USER_LOGIN WHERE EMAIL = input_email;
    SELECT LENGTH(input_pass) INTO passLength;

    -- Insert the new user only if the email does not exist
    IF emailExists > 0 THEN
        INSERT INTO RESPONSE VALUES ('Error', 'duplicateEmail');
    ELSEIF passLength < 8 THEN
        INSERT INTO RESPONSE VALUES ('Error', 'invalidPass');
    ELSE
        -- Insert the new user if the email does not exist
        INSERT INTO USER_LOGIN (USER_ID, EMAIL, PASS) VALUES (userGUID, input_email, SHA2(input_pass, 256));
        INSERT INTO RESPONSE VALUES ('Success', CONCAT('User added ', userGUID));
    END IF;
    SELECT * FROM RESPONSE;
    DROP TEMPORARY TABLE RESPONSE;
END //

DELIMITER ;

DELIMITER //
CREATE PROCEDURE validate_user(IN input_email VARCHAR(255), IN input_pass VARCHAR(255))
BEGIN
    -- logic variables
    DECLARE isValid INT DEFAULT 0;
    DECLARE userID CHAR(255);

    -- Create a temporary table for response
    CREATE TEMPORARY TABLE IF NOT EXISTS RESPONSE (
        RESPONSE_STATUS VARCHAR(20),
        RESPONSE_MESSAGE VARCHAR(255)
    );
    -- check if user exists
    SELECT COUNT(*) INTO isValid FROM USER_LOGIN WHERE EMAIL = input_email AND PASS = SHA2(input_pass, 256);
    IF isValid = 0 THEN
        INSERT INTO RESPONSE VALUES ('Error', 'invalidCredentials');
    ELSE
        SELECT USER_ID INTO userID FROM USER_LOGIN WHERE EMAIL = input_email AND PASS = SHA2(input_pass, 256);
        INSERT INTO RESPONSE VALUES ('Success', userID);
    END IF;
    SELECT * FROM RESPONSE;
    DROP TEMPORARY TABLE RESPONSE;
END //
DELIMITER ;

-- Find RSO events for user
-- REDO THIS--------------------------------
-- DELIMITER //
-- CREATE PROCEDURE find_RSO_even(IN input_user_id INT)
-- BEGIN
--     -- select all events for the RSOs that the user is a part of
--     SELECT * FROM EVENTS WHERE RSO_ID IN (SELECT RSO_ID FROM STUDENT WHERE USER_ID = input_user_id);
-- END //
-- DELIMITER ;

-- -- find private events for user (where there is no RSO but is University)
-- DELIMITER //
-- CREATE PROCEDURE find_private_events(IN input_user_id INT)
-- BEGIN
--     -- select all events for the university that the user is a part of
--     SELECT * FROM EVENTS WHERE UNIVERSITY_ID = (SELECT UNIVERSITY_ID FROM USER_INFO WHERE USER_ID = input_user_id) AND RSO_ID IS NULL;
-- END //
-- DELIMITER ;

-- -- find public events for user (where there is no RSO and no University)
-- DELIMITER //
-- CREATE PROCEDURE find_public_events()
-- BEGIN
--     -- select all events that are public
--     SELECT * FROM EVENTS WHERE UNIVERSITY_ID IS NULL AND RSO_ID IS NULL;
-- END //

-- -- find all events for user
-- DELIMITER //
-- CREATE PROCEDURE find_all_events(IN input_user_id INT)
-- BEGIN
--     -- select all events for the user, calling other procedures
--     CALL find_RSO_even(input_user_id);
--     CALL find_private_events(input_user_id);
--     CALL find_public_events();
-- END //
-- DELIMITER ;


CALL insert_user_login('admin@admin.com', 'Password1!');
CALL validate_user('admin@admin.com', 'Password1!');

CALL insert_user_login('test@test.com', 'Password1!');
CALL validate_user('test@test.com', 'Password1!');

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


-- PROCEDURE TO FIND USER TYPE
DELIMITER //

CREATE PROCEDURE get_user_type(IN input_user_id CHAR(255))
BEGIN
    -- Variables to check user's role
    DECLARE is_student INT DEFAULT 0;
    DECLARE is_rso_admin INT DEFAULT 0;
    DECLARE is_super_admin INT DEFAULT 0;
    DECLARE user_type VARCHAR(255);

    -- Create a temporary table for the response
    CREATE TEMPORARY TABLE IF NOT EXISTS RESPONSE (
        RESPONSE_STATUS VARCHAR(20),
        RESPONSE_MESSAGE VARCHAR(255)
    );

    -- Check if the user is a student
    SELECT COUNT(*) INTO is_student FROM STUDENT WHERE USER_ID = input_user_id;
    -- Check if the user is an RSO admin
    SELECT COUNT(*) INTO is_rso_admin FROM RSO_ADMIN WHERE USER_ID = input_user_id;
    -- Check if the user is a super admin
    SELECT COUNT(*) INTO is_super_admin FROM SUPER_ADMIN WHERE USER_ID = input_user_id;

    -- Determine the user type
    IF is_super_admin > 0 THEN
        SET user_type = 'Super Admin';
    ELSEIF is_rso_admin > 0 THEN
        SET user_type = 'RSO Admin';
    ELSEIF is_student > 0 THEN
        SET user_type = 'Student';
    ELSE
        SET user_type = 'Unknown';
    END IF;

    -- Insert the result into the response table
    INSERT INTO RESPONSE (RESPONSE_STATUS, RESPONSE_MESSAGE) 
    VALUES ('Success', user_type);

    -- Select all responses
    SELECT * FROM RESPONSE;
    DROP TEMPORARY TABLE RESPONSE;
END //

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
    CALL create_rso_and_admin(userID, 'RSO Name', 'RSO Color', 'RSO Description');
    END //
DELIMITER ;

CALL testRSO();



-- TO DO:
-- 1. Update procedure for sign up to include user info and set as student
-- 2. update sign up endpoint to call the updated procedure
-- 3. Update front end to include user info
-- 4. make logic where if user is super admin, their email prefix is used to identify students
-- 5. use this in endpoint to set student university
-- OR make it so a user registers as a student at a university and then can create an RSO at that school