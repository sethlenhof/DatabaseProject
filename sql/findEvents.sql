use event_management_system;
DROP PROCEDURE IF EXISTS find_accessible_events;

DELIMITER //

CREATE PROCEDURE find_accessible_events(IN input_user_id CHAR(255))
BEGIN
    DECLARE done INT DEFAULT FALSE;
    DECLARE user_uni_id INT;
    DECLARE rso_list TEXT;
    DECLARE cur_rso CURSOR FOR SELECT DISTINCT RSO_ID FROM STUDENT WHERE USER_ID = input_user_id;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

    CREATE TEMPORARY TABLE IF NOT EXISTS RESPONSE (
        EVENT_ID INT,
        EVENT_NAME VARCHAR(255),
        CATEGORY VARCHAR(255),
        EVENT_DESCRIPTION TEXT,
        EVENT_LOCATION VARCHAR(255),
        CONTACT_PHONE VARCHAR(255),
        CONTACT_EMAIL VARCHAR(255),
        EVENT_START VARCHAR(255),
        EVENT_END VARCHAR(255),
        RSO_ID INT,
        UNIVERSITY_ID INT,
        UNIQUE KEY (EVENT_ID)  -- Ensuring uniqueness
    );

    -- Fetch user's university ID
    SELECT UNIVERSITY_ID INTO user_uni_id FROM USER_INFO WHERE USER_ID = input_user_id;

    -- Insert events from user's university that are approved
    IF user_uni_id IS NOT NULL THEN
        INSERT IGNORE INTO RESPONSE
        SELECT E.EVENT_ID, E.EVENT_NAME, E.CATEGORY, E.EVENT_DESCRIPTION, E.EVENT_LOCATION, 
               E.CONTACT_PHONE, E.CONTACT_EMAIL, E.EVENT_START, E.EVENT_END,
               IFNULL(E.RSO_ID, 0) AS RSO_ID, E.UNIVERSITY_ID
        FROM EVENTS E
        JOIN APPROVED_EVENTS AE ON E.EVENT_ID = AE.EVENT_ID
        WHERE E.UNIVERSITY_ID = user_uni_id AND AE.APPROVED = TRUE;
    END IF;

    -- Open cursor to process RSOs
    OPEN cur_rso;

    rso_loop: LOOP
        FETCH cur_rso INTO rso_list;
        IF done THEN
            LEAVE rso_loop;
        END IF;
        
        -- Insert events linked to RSOs that user is a part of
        INSERT IGNORE INTO RESPONSE
        SELECT E.EVENT_ID, E.EVENT_NAME, E.CATEGORY, E.EVENT_DESCRIPTION, E.EVENT_LOCATION, 
               E.CONTACT_PHONE, E.CONTACT_EMAIL, E.EVENT_START, E.EVENT_END,
               IFNULL(E.RSO_ID, 0) AS RSO_ID, E.UNIVERSITY_ID
        FROM EVENTS E
        INNER JOIN APPROVED_EVENTS AE ON E.EVENT_ID = AE.EVENT_ID
        WHERE E.RSO_ID = rso_list AND AE.APPROVED = TRUE;
    END LOOP;

    CLOSE cur_rso;

    -- Handle public events (no RSO or university association) but approved
    INSERT IGNORE INTO RESPONSE
    SELECT E.EVENT_ID, E.EVENT_NAME, E.CATEGORY, E.EVENT_DESCRIPTION, E.EVENT_LOCATION, 
           E.CONTACT_PHONE, E.CONTACT_EMAIL, E.EVENT_START, E.EVENT_END,
           IFNULL(E.RSO_ID, 0) AS RSO_ID, E.UNIVERSITY_ID
    FROM EVENTS E
    INNER JOIN APPROVED_EVENTS AE ON E.EVENT_ID = AE.EVENT_ID
    WHERE E.RSO_ID IS NULL AND E.UNIVERSITY_ID IS NULL AND AE.APPROVED = TRUE;

    -- Output the results
    SELECT * FROM RESPONSE;

    -- Cleanup
    DROP TEMPORARY TABLE IF EXISTS RESPONSE;
END //

DELIMITER ;



DROP PROCEDURE IF EXISTS approve_all_events;
DELIMITER //

CREATE PROCEDURE approve_all_events(IN approver_id CHAR(255))
BEGIN
    -- Insert into APPROVED_EVENTS if the event is not already approved
    INSERT INTO APPROVED_EVENTS (EVENT_ID, SUPER_ADMIN_ID)
    SELECT EVENT_ID, approver_id
    FROM EVENTS
    WHERE EVENT_ID NOT IN (SELECT EVENT_ID FROM APPROVED_EVENTS);

    -- You can include error handling to provide feedback on how many events were approved or if the operation was successful
    SELECT CONCAT(COUNT(*), ' events were approved.') AS ApprovalFeedback
    FROM APPROVED_EVENTS
    WHERE SUPER_ADMIN_ID = approver_id;
END //

DELIMITER ;




DROP PROCEDURE IF EXISTS test_find_accessible_events;
DELIMITER //
-- Test procedure for find_accessible_events
CREATE PROCEDURE test_find_accessible_events()
BEGIN
    DECLARE userID CHAR(255);
    SELECT USER_ID INTO userID FROM USER_LOGIN WHERE EMAIL = 'admin@ucf.edu';
    CALL find_accessible_events(userID);
END //
DELIMITER ;

-- CALL test_find_accessible_events();

CALL find_accessible_events(0);
CALL find_accessible_events('286932fb-fd3e-11ee-a9fa-00155d00f503');

CALL approve_all_events('286932fb-fd3e-11ee-a9fa-00155d00f503');
CALL find_accessible_events('286932fb-fd3e-11ee-a9fa-00155d00f503');

CALL find_accessible_events("0");