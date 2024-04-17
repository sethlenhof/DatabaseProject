

DROP PROCEDURE IF EXISTS get_unapproved_events;

-- procedure to get unapproved events
DELIMITER //

CREATE PROCEDURE get_unapproved_events_for_university(IN input_user_id CHAR(255))
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

DROP PROCEDURE IF EXISTS test_get_unapproved_events_for_university;

-- test procedure for get_unapproved_events
CREATE PROCEDURE test_get_unapproved_events_for_university()
BEGIN
    DECLARE user_id CHAR(255);
    SELECT INTO user_id USER_ID FROM SUPER_ADMIN WHERE EMAIL = "admin@ucf.edu";
    CALL get_unapproved_events_for_university(user_id);
END;


DROP PROCEDURE IF EXISTS approve_event;
-- procedure to approve an event
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
        SELECT 'Error' AS Status, 'Event cannot be approved by this super admin.' AS Message;
    END IF;
END //

DELIMITER ;

DROP PROCEDURE IF EXISTS test_approve_event;
-- test procedure for approve_event
CREATE PROCEDURE test_approve_event()
BEGIN
    DECLARE super_admin_id CHAR(255);
    DECLARE event_id INT;
    SELECT INTO super_admin_id USER_ID FROM SUPER_ADMIN WHERE EMAIL = "admin@ucf.edu";
    SELECT INTO event_id EVENT_ID FROM EVENTS WHERE UNIVERSITY_ID = 1;
    CALL approve_event(super_admin_id, event_id);
END;
DELIMITER ;
