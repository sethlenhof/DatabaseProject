-- RSO stuff


use event_management_system;
DROP PROCEDURE IF EXISTS create_rso_and_admin;
DROP PROCEDURE IF EXISTS testRSO;


-- create a new RSO and assign the creating user as the admin
-- create a new RSO and assign the creating user as the admin
DELIMITER //
CREATE PROCEDURE create_rso_and_admin(
    IN input_user_id CHAR(255),
    IN input_rso_name VARCHAR(255),
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
    SELECT COUNT(*) INTO existing_rso_count FROM RSO WHERE RSO_NAME = input_rso_name;

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
        VALUES (input_rso_name, rso_color, rso_description);

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
    CALL create_rso_and_admin(userID, 'UCF CLUB1', 'red', 'RSO Description: Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aliquam commodo, turpis at venenatis facilisis, ex dolor dictum nunc, eu varius arcu orci non massa. Donec tincidunt suscipit finibus. Vestibulum sed nisl cursus, pellentesque lorem in, maximus turpis. Morbi fringilla mauris tempor, sodales turpis non, auctor mauris. Quisque sed vulputate dui. Sed non dapibus sapien, sit amet viverra velit. Sed ultrices sem vel lectus pretium, et porta eros tincidunt. Suspendisse facilisis nibh urna, id aliquet sem interdum eu. Suspendisse pulvinar ex eget lacinia aliquam. Sed ultricies suscipit consequat. Etiam scelerisque vehicula vehicula. Praesent ut dolor ex. Cras dictum vel nunc quis accumsan. Sed sed volutpat urna');
    CALL create_rso_and_admin(userID, 'UCF CLUB2', 'pink', 'RSO Description: Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aliquam commodo, turpis at venenatis facilisis, ex dolor dictum nunc, eu varius arcu orci non massa. Donec tincidunt suscipit finibus. Vestibulum sed nisl cursus, pellentesque lorem in, maximus turpis. Morbi fringilla mauris tempor, sodales turpis non, auctor mauris. Quisque sed vulputate dui. Sed non dapibus sapien, sit amet viverra velit. Sed ultrices sem vel lectus pretium, et porta eros tincidunt. Suspendisse facilisis nibh urna, id aliquet sem interdum eu. Suspendisse pulvinar ex eget lacinia aliquam. Sed ultricies suscipit consequat. Etiam scelerisque vehicula vehicula. Praesent ut dolor ex. Cras dictum vel nunc quis accumsan. Sed sed volutpat urna');
    CALL create_rso_and_admin(userID, 'UCF CLUB3', 'orange', 'RSO Description: Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aliquam commodo, turpis at venenatis facilisis, ex dolor dictum nunc, eu varius arcu orci non massa. Donec tincidunt suscipit finibus. Vestibulum sed nisl cursus, pellentesque lorem in, maximus turpis. Morbi fringilla mauris tempor, sodales turpis non, auctor mauris. Quisque sed vulputate dui. Sed non dapibus sapien, sit amet viverra velit. Sed ultrices sem vel lectus pretium, et porta eros tincidunt. Suspendisse facilisis nibh urna, id aliquet sem interdum eu. Suspendisse pulvinar ex eget lacinia aliquam. Sed ultricies suscipit consequat. Etiam scelerisque vehicula vehicula. Praesent ut dolor ex. Cras dictum vel nunc quis accumsan. Sed sed volutpat urna');
    CALL create_rso_and_admin(userID, 'UCF CLUB4', 'green', 'RSO Description: Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aliquam commodo, turpis at venenatis facilisis, ex dolor dictum nunc, eu varius arcu orci non massa. Donec tincidunt suscipit finibus. Vestibulum sed nisl cursus, pellentesque lorem in, maximus turpis. Morbi fringilla mauris tempor, sodales turpis non, auctor mauris. Quisque sed vulputate dui. Sed non dapibus sapien, sit amet viverra velit. Sed ultrices sem vel lectus pretium, et porta eros tincidunt. Suspendisse facilisis nibh urna, id aliquet sem interdum eu. Suspendisse pulvinar ex eget lacinia aliquam. Sed ultricies suscipit consequat. Etiam scelerisque vehicula vehicula. Praesent ut dolor ex. Cras dictum vel nunc quis accumsan. Sed sed volutpat urna');
    CALL create_rso_and_admin(userID, 'UCF CLUB5', 'black', 'RSO Description: Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aliquam commodo, turpis at venenatis facilisis, ex dolor dictum nunc, eu varius arcu orci non massa. Donec tincidunt suscipit finibus. Vestibulum sed nisl cursus, pellentesque lorem in, maximus turpis. Morbi fringilla mauris tempor, sodales turpis non, auctor mauris. Quisque sed vulputate dui. Sed non dapibus sapien, sit amet viverra velit. Sed ultrices sem vel lectus pretium, et porta eros tincidunt. Suspendisse facilisis nibh urna, id aliquet sem interdum eu. Suspendisse pulvinar ex eget lacinia aliquam. Sed ultricies suscipit consequat. Etiam scelerisque vehicula vehicula. Praesent ut dolor ex. Cras dictum vel nunc quis accumsan. Sed sed volutpat urna');

    SELECT * FROM RSO;
    SELECT * FROM RSO_ADMIN;
    SELECT * FROM STUDENT;

    -- Call the procedure again to see the error message
    CALL create_rso_and_admin(userID, 'Sample RSO', 'red', 'RSO Description');
    END //
DELIMITER ;

-- call procedure to test the rso creation
CALL testRSO();

DROP PROCEDURE IF EXISTS get_rsos;

-- procedure to get RSOs available from user university
DELIMITER //
CREATE PROCEDURE get_rsos(IN input_user_id CHAR(255))
BEGIN
    DECLARE uni_id INT;

    SELECT UNIVERSITY_ID INTO uni_id FROM USER_INFO WHERE USER_ID = input_user_id;

    SELECT * FROM RSO WHERE UNIVERSITY_ID = uni_id;
END //
DELIMITER ;

DROP PROCEDURE IF EXISTS testGetRSO;

-- test procedure to get RSOs
DELIMITER //
CREATE PROCEDURE testGetRSO()
BEGIN
    DECLARE userID CHAR(255);
    -- to test different user, update this email
    SELECT USER_ID INTO userID FROM USER_LOGIN WHERE EMAIL = 'admin@admin.com';
    CALL get_rsos(userID);
END //
DELIMITER ;

-- call procedure to test the rso creation
CALL testGetRSO();

DROP PROCEDURE IF EXISTS join_rso;

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


DROP PROCEDURE IF EXISTS testJoinRSO;

-- test procedure to join RSO
DELIMITER //
CREATE PROCEDURE testJoinRSO()
BEGIN
    DECLARE userID CHAR(255);
    -- to test different user, update this email
    SELECT USER_ID INTO userID FROM USER_LOGIN WHERE EMAIL = 'admin@admin.com';
    CALL join_rso(userID, 1);
    CALL join_rso(userID, 2);

    SELECT * FROM STUDENT;
END //
DELIMITER ;

-- call procedure to test the rso creation
CALL testJoinRSO();