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
    UNIVERSITY_ID INT AUTO_INCREMENT PRIMARY KEY,
    NAME VARCHAR(255),
    LOCATION VARCHAR(255),
    DESCRIPTION TEXT,
    NUM_OF_STUDENTS INT
);

CREATE TABLE RSO (
    RSO_ID INT AUTO_INCREMENT PRIMARY KEY,
    NAME VARCHAR(255),
    DESCRIPTION TEXT
);

CREATE TABLE USER_INFO (
    USER_ID CHAR(255) PRIMARY KEY,
    NAME VARCHAR(255),
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
        INSERT INTO RESPONSE VALUES ('Success', 'User added');
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
DELIMITER //
CREATE PROCEDURE find_RSO_even(IN input_user_id INT)
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

-- find all events for user
DELIMITER //
CREATE PROCEDURE find_all_events(IN input_user_id INT)
BEGIN
    -- select all events for the user, calling other procedures
    CALL find_RSO_even(input_user_id);
    CALL find_private_events(input_user_id);
    CALL find_public_events();
END //


CALL insert_user_login('admin@admin.com', 'Password1!');
CALL validate_user('admin@admin.com', 'Password1!');
