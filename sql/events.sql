USE event_management_system;

DROP PROCEDURE IF EXISTS get_unapproved_events;

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

DROP PROCEDURE IF EXISTS test_get_unapproved_events;

-- test procedure for get_unapproved_events
DELIMITER //
CREATE PROCEDURE test_get_unapproved_events()
BEGIN
    DECLARE userID CHAR(255);
    SELECT USER_ID INTO userID FROM USER_LOGIN WHERE EMAIL = 'admin@ucf.edu';
    CALL get_unapproved_events(userID);
END //
DELIMITER ;

CALL test_get_unapproved_events();

DROP PROCEDURE IF EXISTS approve_event;

-- Procedure to approve an event
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



DROP PROCEDURE IF EXISTS test_approve_event;

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

CALL test_approve_event();
