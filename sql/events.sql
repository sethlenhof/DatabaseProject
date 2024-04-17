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
DELIMITER //
CREATE PROCEDURE approve_event(IN input_super_admin_id CHAR(255), IN input_event_id INT)
BEGIN
    DECLARE uni_id INT;
    DECLARE event_uni_id INT;
    -- Get the university ID associated with the super admin
    SELECT UNIVERSITY_ID INTO uni_id FROM SUPER_ADMIN WHERE USER_ID = input_super_admin_id;

    -- Get the university ID associated with the event
    SELECT UNIVERSITY_ID INTO event_uni_id FROM EVENTS WHERE EVENT_ID = input_event_id;

    -- Ensure the event and the super admin are from the same university
    IF uni_id = event_uni_id THEN
        -- Insert the approval record into APPROVED_EVENTS
        INSERT INTO APPROVED_EVENTS (EVENT_ID, SUPER_ADMIN_ID)
        VALUES (input_event_id, input_super_admin_id);

        SELECT 'Success' AS Status, 'Event approved successfully.' AS Message;
    ELSE
        SELECT 'Error' AS Status, 'Event cannot be approved by this super admin, mismatch in university IDs.' AS Message;
    END IF;
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
