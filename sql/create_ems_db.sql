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
    UNIVERSITY_EMAIL VARCHAR(255) UNIQUE,
    UNI_DESCRIPTION TEXT,
    NUM_OF_STUDENTS INT,
    COLOR VARCHAR(255)
);

CREATE TABLE RSO (
    RSO_ID INT AUTO_INCREMENT PRIMARY KEY,
    RSO_NAME VARCHAR(255),
    RSO_TYPE VARCHAR(255),
    COLOR VARCHAR(255),
    RSO_DESCRIPTION TEXT,
    UNIVERSITY_ID INT,
    FOREIGN KEY (UNIVERSITY_ID) REFERENCES UNIVERSITY(UNIVERSITY_ID)
);

CREATE TABLE USER_INFO (
    USER_ID CHAR(255) PRIMARY KEY,
    USERS_NAME VARCHAR(255),
    UNIVERSITY_ID INT,
    FOREIGN KEY (UNIVERSITY_ID) REFERENCES UNIVERSITY(UNIVERSITY_ID),
    FOREIGN KEY (USER_ID) REFERENCES USER_LOGIN(USER_ID)
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
    EVENT_NAME VARCHAR(255),
    CATEGORY VARCHAR(255),
    EVENT_DESCRIPTION TEXT,
    EVENT_LOCATION VARCHAR(255),
    CONTACT_PHONE VARCHAR(255),
    CONTACT_EMAIL VARCHAR(255),
    RSO_ID INT,
    UNIVERSITY_ID INT,
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



-- ||===================================================================================================||
-- ||                                     INSERT USER_LOGIN                                             ||              
-- ||===================================================================================================||
DELIMITER //
CREATE PROCEDURE insert_user_login(IN input_email VARCHAR(255), IN input_pass VARCHAR(255))
BEGIN
    -- Check if the email already exists
    DECLARE emailExists INT;
    DECLARE passLength INT;
    DECLARE userGUID CHAR(255);
    DECLARE UNI_ID INT;
    DECLARE UNI_EXISTS INT;
    DECLARE emailDomain VARCHAR(255);

    SET userGUID = UUID();
    
    -- Create a temporary table for response
    CREATE TEMPORARY TABLE IF NOT EXISTS RESPONSE (
        RESPONSE_STATUS VARCHAR(20),
        RESPONSE_MESSAGE VARCHAR(255)
    );
    
    SELECT COUNT(*) INTO emailExists FROM USER_LOGIN WHERE EMAIL = input_email;
    SELECT LENGTH(input_pass) INTO passLength;

    -- Get the email domain from the email (e.g. gmail.com, yahoo.com)
    SET emailDomain = SUBSTRING_INDEX(input_email, '@', -1);
    -- Check if the email domain is a university
    SELECT COUNT(*) INTO UNI_EXISTS FROM UNIVERSITY WHERE UNIVERSITY_EMAIL = emailDomain;



    -- Insert the new user only if the email does not exist
    IF emailExists > 0 THEN
        INSERT INTO RESPONSE VALUES ('Error', 'duplicateEmail');
    ELSEIF passLength < 8 THEN
        INSERT INTO RESPONSE VALUES ('Error', 'invalidPass');
    ELSEIF UNI_EXISTS = 0 THEN
        INSERT INTO RESPONSE VALUES ('Error', 'invalidUniversityEmail');
    ELSE
        -- Insert the new user if the email does not exist
        INSERT INTO USER_LOGIN (USER_ID, EMAIL, PASS) VALUES (userGUID, input_email, SHA2(input_pass, 256));
        INSERT INTO RESPONSE VALUES ('Success', CONCAT('User added ', userGUID));
        
        -- Get the university ID
        SELECT UNIVERSITY_ID INTO UNI_ID FROM UNIVERSITY WHERE UNIVERSITY_EMAIL = emailDomain;

        -- Insert the user into the USER_INFO table
        INSERT INTO USER_INFO (USER_ID, USERS_NAME, UNIVERSITY_ID) VALUES (userGUID, 'New User', UNI_ID);
    END IF;
    SELECT * FROM RESPONSE;
    DROP TEMPORARY TABLE RESPONSE;
END //

DELIMITER ;

-- ||===================================================================================================||
-- ||                                       VALIDATE_USER                                               ||              
-- ||===================================================================================================||

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

-- ||===================================================================================================||
-- ||                                       PROCEDURES FOR EVENTS                                       ||
-- ||===================================================================================================||

-- Find event data by ID
DELIMITER //
CREATE PROCEDURE find_event_by_id(IN input_event_id INT)
BEGIN
    -- select all events for the RSOs that the user is a part of
    SELECT * FROM EVENTS WHERE EVENT_ID = input_event_id;
END //

-- Find RSO events for user
DELIMITER //
CREATE PROCEDURE find_RSO_events(IN input_user_id INT)
BEGIN
    -- select all events for the RSOs that the user is a part of
    SELECT * FROM EVENTS WHERE RSO_ID IN (SELECT RSO_ID FROM STUDENT WHERE USER_ID = input_user_id);
END //
DELIMITER ;

-- find private events for user (where there is no RSO but is University)
DELIMITER //
CREATE PROCEDURE find_private_events(IN input_user_id INT)
BEGIN
    -- select all events for the university that the user is a part of
    SELECT * FROM EVENTS WHERE UNIVERSITY_ID = (SELECT UNIVERSITY_ID FROM USER_INFO WHERE USER_ID = input_user_id) AND RSO_ID IS NULL;
END //
DELIMITER ;


-- find public events for user (where there is no RSO and no University)
DELIMITER //
CREATE PROCEDURE find_public_events()
BEGIN
    -- select all events that are public
    SELECT * FROM EVENTS WHERE UNIVERSITY_ID IS NULL AND RSO_ID IS NULL;
END //

-- find public events for user (where there is no RSO and no University)
DELIMITER //
CREATE PROCEDURE find_approved_events()
BEGIN
    -- select all events that are public and approved
    SELECT * FROM APPROVED_EVENTS;
END //

-- find all events for user
DELIMITER //
CREATE PROCEDURE find_all_events(IN input_user_id INT)
BEGIN
    -- create reponse
    CREATE TEMPORARY TABLE IF NOT EXISTS RESPONSE (
        RESPONSE_STATUS VARCHAR(20),
        RESPONSE_MESSAGE VARCHAR(255)
    );

    -- Union all calls to get all events
    SELECT * FROM EVENTS WHERE RSO_ID IN (SELECT RSO_ID FROM STUDENT WHERE USER_ID = input_user_id)
    UNION
    SELECT * FROM EVENTS WHERE UNIVERSITY_ID = (SELECT UNIVERSITY_ID FROM USER_INFO WHERE USER_ID = input_user_id) AND RSO_ID IS NULL
    UNION
    SELECT * FROM EVENTS WHERE EVENT_ID IN (SELECT EVENT_ID FROM APPROVED_EVENTS);
    
END //
DELIMITER ;

-- find RSO admin of
DELIMITER //
CREATE PROCEDURE get_rso_admin_membership(IN input_user_id CHAR(255))
BEGIN
    SELECT RSO.RSO_ID
    FROM RSO
    INNER JOIN RSO_ADMIN ON RSO.RSO_ID = RSO_ADMIN.RSO_ID
    WHERE RSO_ADMIN.USER_ID = input_user_id;
END //

DELIMITER ;


-- create event
DELIMITER //

CREATE PROCEDURE insert_event(
    IN p_rso_id INT,
    IN p_university_id INT,
    IN p_name VARCHAR(255),
    IN p_category VARCHAR(255),
    IN p_description TEXT,
    IN p_event_start VARCHAR(255),
    IN p_event_end VARCHAR(255),
    IN p_location VARCHAR(255),
    IN p_contact_phone VARCHAR(255),
    IN p_contact_email VARCHAR(255)
)
BEGIN
    INSERT INTO EVENTS (RSO_ID, UNIVERSITY_ID, EVENT_NAME, CATEGORY, EVENT_DESCRIPTION, EVENT_START, EVENT_END, EVENT_LOCATION, CONTACT_PHONE, CONTACT_EMAIL)
    VALUES (p_rso_id, p_university_id, p_name, p_category, p_description, p_event_start, p_event_end, p_location, p_contact_phone, p_contact_email);

    -- respond with success
    SELECT 'Success: Event created';
END //

DELIMITER ;

-- ||===================================================================================================||
-- ||                                       PROCEDURES FOR COMMENTS                                     ||
-- ||===================================================================================================||
-- create comment
DELIMITER //
CREATE PROCEDURE insert_comment(
    IN p_event_id INT,
    IN p_user_id CHAR(255),
    IN p_comment TEXT,
    IN p_rating INT
)
BEGIN
    INSERT INTO COMMENT (EVENT_ID, USER_ID, COMMENT, RATING)
    VALUES (p_event_id, p_user_id, p_comment, p_rating);

    -- respond with success
    SELECT 'Success: Comment created';
END //

DELIMITER ;

-- get comments for event
DELIMITER //
CREATE PROCEDURE get_comments_for_event(IN input_event_id INT)
BEGIN
    SELECT * FROM COMMENT WHERE EVENT_ID = input_event_id;
END //

DELIMITER ;




-- //===============================================================================================//
-- //                                PROCEDURES FOR ADDING ROLES                                    //
-- //===============================================================================================//

-- procedure to join RSO
DELIMITER //

CREATE PROCEDURE join_rso(
    IN input_user_id CHAR(255),
    IN input_rso_id INT
)
BEGIN
    DECLARE is_member INT DEFAULT 0;
    DECLARE user_exists INT DEFAULT 0;
    DECLARE rso_exists INT DEFAULT 0;

    CREATE TEMPORARY TABLE IF NOT EXISTS RESPONSE (
        RESPONSE_STATUS VARCHAR(20),
        RESPONSE_MESSAGE VARCHAR(255)
    );

    -- Check if the user and RSO exist
    SELECT COUNT(*) INTO user_exists FROM USER_INFO WHERE USER_ID = input_user_id;
    SELECT COUNT(*) INTO rso_exists FROM RSO WHERE RSO_ID = input_rso_id;

    IF user_exists = 0 THEN
        INSERT INTO RESPONSE (RESPONSE_STATUS, RESPONSE_MESSAGE) VALUES ('Error', 'User does not exist.');
    ELSEIF rso_exists = 0 THEN
        INSERT INTO RESPONSE (RESPONSE_STATUS, RESPONSE_MESSAGE) VALUES ('Error', 'RSO does not exist.');
    ELSE
        -- Check if the user is already a member of this RSO
        SELECT COUNT(*) INTO is_member FROM STUDENT WHERE USER_ID = input_user_id AND RSO_ID = input_rso_id;

        -- If the user is not already a member, insert the new record
        IF is_member = 0 THEN
            INSERT INTO STUDENT (RSO_ID, USER_ID) VALUES (input_rso_id, input_user_id);
            INSERT INTO RESPONSE (RESPONSE_STATUS, RESPONSE_MESSAGE) VALUES ('Success', 'You have successfully joined the RSO.');
        ELSE
            INSERT INTO RESPONSE (RESPONSE_STATUS, RESPONSE_MESSAGE) VALUES ('Error', 'You are already a member of this RSO.');
        END IF;
    END IF;

    SELECT * FROM RESPONSE;
    DROP TEMPORARY TABLE IF EXISTS RESPONSE;
END //
DELIMITER ;

-- procedure to insert a super admin
DELIMITER //
CREATE PROCEDURE insert_super_admin(
    IN admin_email VARCHAR(255),
    IN admin_name VARCHAR(255),
    IN admin_pass VARCHAR(255),
    IN university_name VARCHAR(255)
)
BEGIN
    DECLARE userID CHAR(255);
    DECLARE uni_id INT;
    DECLARE emailDomain VARCHAR(255);
    set userID = UUID();
    
    -- Grabbing domain 
    SET emailDomain = SUBSTRING_INDEX(admin_email, '@', -1);
    -- Search for domain in university table
    SELECT UNIVERSITY_ID INTO uni_id FROM UNIVERSITY WHERE UNIVERSITY_EMAIL = emailDomain;
    -- if found, return error
    IF uni_id IS NOT NULL THEN
        SELECT 'Error: University already exists with this email domain';
        ROLLBACK;
    END IF;
    START TRANSACTION;

    -- Create University with same email domain as admin email
    -- Insert into University table
    INSERT INTO UNIVERSITY (UNIVERSITY_NAME, UNIVERSITY_EMAIL) VALUES (university_name, emailDomain);
    -- Get the last inserted university ID
    SET uni_id = LAST_INSERT_ID();

    INSERT INTO USER_LOGIN (USER_ID, EMAIL, PASS) VALUES (userID, admin_email, SHA2(admin_pass, 256));
    INSERT INTO USER_INFO (USER_ID, USERS_NAME, UNIVERSITY_ID) VALUES (userID, admin_name, uni_id);
    INSERT INTO SUPER_ADMIN (USER_ID, UNIVERSITY_ID) VALUES (userID, uni_id);

    COMMIT;
END //
DELIMITER ;


-- Procedure to get uni id 
DELIMITER //
CREATE PROCEDURE get_uni_id(IN input_user_id CHAR(255))
BEGIN
    SELECT UNIVERSITY_ID FROM USER_INFO WHERE USER_ID = input_user_id;
END //
DELIMITER ;

-- Procedure to get uni id
DELIMITER //
CREATE PROCEDURE get_rso_id(IN input_user_id CHAR(255))
BEGIN
    SELECT RSO_ID FROM RSO_ADMIN WHERE USER_ID = input_user_id;
END //
DELIMITER ;

-- PROCEDURE TO UPDATE UNIVERSITY INFO
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
    SELECT USER_ID INTO userID FROM USER_LOGIN WHERE EMAIL = 'admin@ucf.edu';
    CALL update_university_info(userID, 'New University Name', 'New Location', 'New Description', 1000, 'blue');
    SELECT * FROM UNIVERSITY;
    CALL update_university_info(userID, 'New Name', 'IDK Location', 'New Description', 1000, 'blue');

END //
DELIMITER ;



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
        SET user_type = 'superAdmin';
    ELSEIF is_rso_admin > 0 THEN
        SET user_type = 'rsoAdmin';
    ELSEIF is_student > 0 THEN
        SET user_type = 'student';
    ELSE
        SET user_type = 'unknown';
    END IF;

    -- Insert the result into the response table
    INSERT INTO RESPONSE (RESPONSE_STATUS, RESPONSE_MESSAGE) 
    VALUES ('Success', user_type);

    -- Select all responses
    SELECT * FROM RESPONSE;
    DROP TEMPORARY TABLE RESPONSE;
END //
DELIMITER ;

-- create a new RSO and assign the creating user as the admin
DELIMITER //

CREATE PROCEDURE create_rso_and_admin(
    IN input_user_id CHAR(255),
    IN input_rso_name VARCHAR(255),
    IN input_rso_type VARCHAR(255),
    IN input_rso_color VARCHAR(255),
    IN input_rso_description TEXT
)
BEGIN
    DECLARE new_rso_id INT;
    DECLARE existing_admin_count INT;
    DECLARE existing_rso_count INT;
    DECLARE existing_user_count INT;
    DECLARE user_university_id INT;

    CREATE TEMPORARY TABLE IF NOT EXISTS RESPONSE (
        RESPONSE_STATUS VARCHAR(20),
        RESPONSE_MESSAGE VARCHAR(255)
    );

    -- Check if the user exists and get the university ID
    SELECT COUNT(*) INTO existing_user_count FROM USER_INFO WHERE USER_ID = input_user_id;
    SELECT UNIVERSITY_ID INTO user_university_id FROM USER_INFO WHERE USER_ID = input_user_id;

    -- Check if an RSO with the same name exists at the same university
    SELECT COUNT(*) INTO existing_rso_count
    FROM RSO
    WHERE RSO_NAME = input_rso_name AND UNIVERSITY_ID = user_university_id;

    -- Start the transaction here to ensure all following operations are atomic
    START TRANSACTION;

    IF existing_rso_count > 0 THEN
        -- If an RSO with this name exists at the same university, rollback and signal an error
        ROLLBACK;
        INSERT INTO RESPONSE (RESPONSE_STATUS, RESPONSE_MESSAGE) VALUES ('Error', 'An RSO with this name already exists at your university.');
    ELSEIF existing_user_count = 0 THEN
        -- If user does not exist, rollback and signal an error
        ROLLBACK;
        INSERT INTO RESPONSE (RESPONSE_STATUS, RESPONSE_MESSAGE) VALUES ('Error', 'User does not exist.');
    ELSE
        -- Insert new RSO
        INSERT INTO RSO (RSO_NAME, RSO_TYPE, COLOR, RSO_DESCRIPTION, UNIVERSITY_ID)
        VALUES (input_rso_name, input_rso_type, input_rso_color, input_rso_description, user_university_id);

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
            INSERT INTO RESPONSE (RESPONSE_STATUS, RESPONSE_MESSAGE) VALUES ('Success', 'RSO created successfully.');
        ELSE
            -- Rollback if an admin already exists
            ROLLBACK;
            INSERT INTO RESPONSE (RESPONSE_STATUS, RESPONSE_MESSAGE) VALUES ('Error', 'An admin already exists for this RSO.');
        END IF;
    END IF;
    SELECT * FROM RESPONSE;
    DROP TEMPORARY TABLE IF EXISTS RESPONSE;
END //

DELIMITER ;

-- Call the procedure using a admin user
DELIMITER //
    CREATE PROCEDURE testRSO()
    BEGIN

    DECLARE userID CHAR(255);
    SELECT USER_ID INTO userID FROM USER_LOGIN WHERE EMAIL = 'admin@ucf.edu';
    CALL create_rso_and_admin(userID, 'Sample RSO', 'frat', 'red', 'RSO Description');
    CALL create_rso_and_admin(userID, 'UCF CLUB1', 'club', 'red', 'RSO Description: Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aliquam commodo, turpis at venenatis facilisis, ex dolor dictum nunc, eu varius arcu orci non massa. Donec tincidunt suscipit finibus. Vestibulum sed nisl cursus, pellentesque lorem in, maximus turpis. Morbi fringilla mauris tempor, sodales turpis non, auctor mauris. Quisque sed vulputate dui. Sed non dapibus sapien, sit amet viverra velit. Sed ultrices sem vel lectus pretium, et porta eros tincidunt. Suspendisse facilisis nibh urna, id aliquet sem interdum eu. Suspendisse pulvinar ex eget lacinia aliquam. Sed ultricies suscipit consequat. Etiam scelerisque vehicula vehicula. Praesent ut dolor ex. Cras dictum vel nunc quis accumsan. Sed sed volutpat urna');
    CALL create_rso_and_admin(userID, 'UCF CLUB2', 'club','pink', 'RSO Description: Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aliquam commodo, turpis at venenatis facilisis, ex dolor dictum nunc, eu varius arcu orci non massa. Donec tincidunt suscipit finibus. Vestibulum sed nisl cursus, pellentesque lorem in, maximus turpis. Morbi fringilla mauris tempor, sodales turpis non, auctor mauris. Quisque sed vulputate dui. Sed non dapibus sapien, sit amet viverra velit. Sed ultrices sem vel lectus pretium, et porta eros tincidunt. Suspendisse facilisis nibh urna, id aliquet sem interdum eu. Suspendisse pulvinar ex eget lacinia aliquam. Sed ultricies suscipit consequat. Etiam scelerisque vehicula vehicula. Praesent ut dolor ex. Cras dictum vel nunc quis accumsan. Sed sed volutpat urna');
    CALL create_rso_and_admin(userID, 'UCF CLUB3', 'club','orange', 'RSO Description: Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aliquam commodo, turpis at venenatis facilisis, ex dolor dictum nunc, eu varius arcu orci non massa. Donec tincidunt suscipit finibus. Vestibulum sed nisl cursus, pellentesque lorem in, maximus turpis. Morbi fringilla mauris tempor, sodales turpis non, auctor mauris. Quisque sed vulputate dui. Sed non dapibus sapien, sit amet viverra velit. Sed ultrices sem vel lectus pretium, et porta eros tincidunt. Suspendisse facilisis nibh urna, id aliquet sem interdum eu. Suspendisse pulvinar ex eget lacinia aliquam. Sed ultricies suscipit consequat. Etiam scelerisque vehicula vehicula. Praesent ut dolor ex. Cras dictum vel nunc quis accumsan. Sed sed volutpat urna');
    CALL create_rso_and_admin(userID, 'UCF CLUB4', 'honors','green', 'RSO Description: Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aliquam commodo, turpis at venenatis facilisis, ex dolor dictum nunc, eu varius arcu orci non massa. Donec tincidunt suscipit finibus. Vestibulum sed nisl cursus, pellentesque lorem in, maximus turpis. Morbi fringilla mauris tempor, sodales turpis non, auctor mauris. Quisque sed vulputate dui. Sed non dapibus sapien, sit amet viverra velit. Sed ultrices sem vel lectus pretium, et porta eros tincidunt. Suspendisse facilisis nibh urna, id aliquet sem interdum eu. Suspendisse pulvinar ex eget lacinia aliquam. Sed ultricies suscipit consequat. Etiam scelerisque vehicula vehicula. Praesent ut dolor ex. Cras dictum vel nunc quis accumsan. Sed sed volutpat urna');
    CALL create_rso_and_admin(userID, 'UCF CLUB5', 'honors','black', 'RSO Description: Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aliquam commodo, turpis at venenatis facilisis, ex dolor dictum nunc, eu varius arcu orci non massa. Donec tincidunt suscipit finibus. Vestibulum sed nisl cursus, pellentesque lorem in, maximus turpis. Morbi fringilla mauris tempor, sodales turpis non, auctor mauris. Quisque sed vulputate dui. Sed non dapibus sapien, sit amet viverra velit. Sed ultrices sem vel lectus pretium, et porta eros tincidunt. Suspendisse facilisis nibh urna, id aliquet sem interdum eu. Suspendisse pulvinar ex eget lacinia aliquam. Sed ultricies suscipit consequat. Etiam scelerisque vehicula vehicula. Praesent ut dolor ex. Cras dictum vel nunc quis accumsan. Sed sed volutpat urna');

    SELECT * FROM RSO;
    SELECT * FROM RSO_ADMIN;
    SELECT * FROM STUDENT;

    -- Call the procedure again to see the error message
    CALL create_rso_and_admin(userID, 'Sample RSO', 'club', 'red', 'RSO Description');
    END //
DELIMITER ;


-- procedure to get RSOs available from user university
DELIMITER //
CREATE PROCEDURE get_rsos(IN input_user_id CHAR(255))
BEGIN
    DECLARE uni_id INT;

    SELECT UNIVERSITY_ID INTO uni_id FROM USER_INFO WHERE USER_ID = input_user_id;

    SELECT * FROM RSO WHERE UNIVERSITY_ID = uni_id;
END //
DELIMITER ;

-- test procedure to get RSOs
DELIMITER //
CREATE PROCEDURE testGetRSO()
BEGIN
    DECLARE userID CHAR(255);
    -- to test different user, update this email
    SELECT USER_ID INTO userID FROM USER_LOGIN WHERE EMAIL = 'admin@ucf.edu';
    CALL get_rsos(userID);
END //
DELIMITER ;


-- test procedure to join RSO
DELIMITER //
CREATE PROCEDURE testJoinRSO()
BEGIN
    DECLARE userID CHAR(255);
    -- to test different user, update this email
    SELECT USER_ID INTO userID FROM USER_LOGIN WHERE EMAIL = 'admin@ucf.edu';
    CALL join_rso(userID, 1);
    SELECT * FROM STUDENT;
END //
DELIMITER ;

-- procedure to get unapproved events
DELIMITER //

CREATE PROCEDURE get_unapproved_events(IN input_user_id CHAR(255))
BEGIN
    DECLARE uni_id INT;

    -- Get the university ID associated with the super admin
    SELECT UNIVERSITY_ID INTO uni_id FROM SUPER_ADMIN WHERE USER_ID = input_user_id;

    -- Select events that are not approved and belong to the specified university
    SELECT e.*
    FROM EVENTS e
    LEFT JOIN APPROVED_EVENTS ae ON e.EVENT_ID = ae.EVENT_ID
    WHERE ae.EVENT_ID IS NULL AND e.UNIVERSITY_ID = uni_id;
END //
DELIMITER ;

-- test procedure for get_unapproved_events
DELIMITER //
CREATE PROCEDURE test_get_unapproved_events()
BEGIN
    DECLARE userID CHAR(255);
    SELECT USER_ID INTO userID FROM USER_LOGIN WHERE EMAIL = 'admin@ucf.edu';
    CALL get_unapproved_events(userID);
END //
DELIMITER ;


DELIMITER //
-- procedure to approve an event
DELIMITER //

CREATE PROCEDURE approve_event(IN input_super_admin_id CHAR(255), IN input_event_id INT)
BEGIN
    DECLARE uni_id INT;
    DECLARE event_uni_id INT;
    DECLARE already_approved INT;

    -- Create response table
    CREATE TEMPORARY TABLE IF NOT EXISTS RESPONSE (
        RESPONSE_STATUS VARCHAR(20),
        RESPONSE_MESSAGE VARCHAR(255)
    );

    -- Get the university ID associated with the super admin
    SELECT UNIVERSITY_ID INTO uni_id FROM SUPER_ADMIN WHERE USER_ID = input_super_admin_id;

    -- Get the university ID associated with the event
    SELECT UNIVERSITY_ID INTO event_uni_id FROM EVENTS WHERE EVENT_ID = input_event_id;

    -- Check if the event is already approved
    SELECT COUNT(*) INTO already_approved FROM APPROVED_EVENTS WHERE EVENT_ID = input_event_id;

    -- Check if the event is already approved
    IF already_approved > 0 THEN
        INSERT INTO RESPONSE (RESPONSE_STATUS, RESPONSE_MESSAGE) VALUES ('Error', 'Cannot approve the event: It is already approved.');
    ELSE
        -- Ensure the event and the super admin are from the same university
        IF uni_id = event_uni_id THEN
            -- Insert the approval record into APPROVED_EVENTS
            INSERT INTO APPROVED_EVENTS (EVENT_ID, SUPER_ADMIN_ID)
            VALUES (input_event_id, input_super_admin_id);

            INSERT INTO RESPONSE (RESPONSE_STATUS, RESPONSE_MESSAGE) VALUES ('Success', 'Event approved successfully.');
        ELSE
            INSERT INTO RESPONSE (RESPONSE_STATUS, RESPONSE_MESSAGE) VALUES ('Error', 'Error approving event. Super admin and event are not from the same university.');
        END IF;
    END IF;

    -- Select all responses to return to the caller
    SELECT * FROM RESPONSE;

    -- Cleanup: drop the temporary table
    DROP TEMPORARY TABLE IF EXISTS RESPONSE;
END //

DELIMITER ;


-- Test procedure for approve_event
DELIMITER //
CREATE PROCEDURE test_approve_event()
BEGIN
    DECLARE super_admin_id CHAR(255);
    DECLARE uni_id INT;
    DECLARE event_id INT;
    DECLARE test_uni_id INT;
    SELECT USER_ID INTO super_admin_id FROM USER_LOGIN WHERE EMAIL = 'admin@ucf.edu';
    SELECT UNIVERSITY_ID INTO uni_id FROM SUPER_ADMIN WHERE USER_ID = super_admin_id;
    CALL approve_event(super_admin_id, 1);
END //
DELIMITER ;




-- Insert test super admin (admin@ucf.edu 'James D. Taiclet' 'Password1!' University of Central Florida)
CALL insert_super_admin('admin@ucf.edu', 'James D. Taiclet', 'Password1!', 'University of Central Florida');

-- INSERT INTO UNIVERSITY (UNIVERSITY_NAME, UNIVERSITY_LOCATION, UNIVERSITY_EMAIL, UNIVERSITY_ID) VALUES ('University of Central Florida', 'Orlando, FL', 'ucf.edu', 1);

-- CALL insert_user_login('test@ucf.edu', 'Password1!');
CALL insert_user_login('rso@ucf.edu', 'Password1!');
CALL insert_user_login('admin@ucf.edu', 'Password1!');
CALL insert_user_login('guy3@ucf.edu', 'Password1!');
CALL validate_user('admin@ucf.edu', 'Password1!');

-- manually insert test user
INSERT INTO USER_LOGIN (USER_ID, EMAIL, PASS) VALUES ('0', 'test@ucf.edu', SHA2('Password1!', 256));
INSERT INTO USER_INFO (USER_ID, USERS_NAME, UNIVERSITY_ID) VALUES ('0', 'Test User', 1);

CALL validate_user('test@ucf.edu', 'Password1!');



SELECT * FROM SUPER_ADMIN;
SELECT * FROM UNIVERSITY;

-- Call the procedure
CALL testUpdateUniversity();

-- call procedure to test the rso creation
-- call procedure to test the rso creation
CALL testRSO();

-- call procedure to test the rso creation
CALL testGetRSO();

-- call procedure to test the rso creation
CALL testJoinRSO();


-- RSO events
-- insert event params: (p_rso_id INT, p_university_id INT, p_name VARCHAR(255), p_category VARCHAR(255), p_description TEXT, p_event_start VARCHAR(255), p_event_end VARCHAR(255), p_location VARCHAR(255), p_contact_phone VARCHAR(255), p_contact_email VARCHAR(255))
CALL insert_event(1, 1, 'UCF Event', 'Educational', 'This is a test event', '2024-04-12 12:00:00', '2024-04-12 14:00:00', 'UCF Student Union', '407-123-4567', 'test@email.com');

-- test RSO event (SHOULD NOT BE ABLE TO SEE FROM STUDENT)
CALL insert_event(2, 1, 'UCF Event', 'Yippee!', 'This event shouldnt be visible', '2024-04-11 12:00:00', '2024-04-11 14:00:00', 'UCF Student Union', '407-123-4567', 'test@email.com');


-- Private event
CALL insert_event(NULL, 1, 'UCF Event', 'Educational', 'This is a test event', '2024-04-09 12:00:00', '2024-04-09 14:00:00', 'UCF Student Union', '407-123-4567', 'test@email.com');

-- Public event
CALL insert_event(NULL, NULL, 'UCF Event', 'Educational', 'This is a test event', '2024-04-10 12:00:00', '2024-04-10 14:00:00', 'UCF Student Union', '407-123-4567', 'test@email.com');


-- add test student to RSO
CALL join_rso('0', 1);

-- test get event
CALL find_all_events('0');


CALL test_get_unapproved_events();

CALL get_rso_admin_membership('0');

-- CALL test_approve_event();

-- TO DO:
-- X 1. Update procedure for sign up to include user info and set as student 
-- X 2. update sign up endpoint to call the updated procedure
-- 3. Update front end to include user info
-- X (But for all users) 4. make logic where if user is super admin, their email prefix is used to identify students
-- X 5. use this in endpoint to set student university
-- X OR make it so a user registers as a student at a university and then can create an RSO at that school