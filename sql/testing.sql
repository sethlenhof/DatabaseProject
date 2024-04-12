use event_management_system;
-- Populate the UNIVERSITY Table
INSERT INTO UNIVERSITY (NAME, LOCATION, DESCRIPTION, NUM_OF_STUDENTS) 
VALUES 
('Tech University', 'Tech City', 'A university focused on technology and innovation.', 15000),
('Art University', 'Art City', 'A university dedicated to art and design.', 8000);

-- Populate the RSO Table
INSERT INTO RSO (NAME, DESCRIPTION) 
VALUES 
('Tech Club', 'A club for students interested in technology.'),
('Art Society', 'A society for students interested in arts.');

-- Create users and populate USER_LOGIN and USER_INFO
CALL insert_user_login('techuser@techuniversity.com', 'TechPass123');
CALL insert_user_login('artuser@artuniversity.com', 'ArtPass123');

-- Assuming the procedure `insert_user_login` does not actually populate USER_INFO
-- Populate the USER_INFO Table manually if needed
UPDATE USER_INFO SET NAME = 'Tech User', UNIVERSITY_ID = 1 WHERE USER_ID = (SELECT USER_ID FROM USER_LOGIN WHERE EMAIL = 'techuser@techuniversity.com');
UPDATE USER_INFO SET NAME = 'Art User', UNIVERSITY_ID = 2 WHERE USER_ID = (SELECT USER_ID FROM USER_LOGIN WHERE EMAIL = 'artuser@artuniversity.com');

-- Populate STUDENT Table linking users to RSOs
INSERT INTO STUDENT (RSO_ID, USER_ID) 
VALUES 
(1, (SELECT USER_ID FROM USER_INFO WHERE EMAIL = 'techuser@techuniversity.com')),
(2, (SELECT USER_ID FROM USER_INFO WHERE EMAIL = 'artuser@artuniversity.com'));

-- Populate the EVENTS Table with RSO events, private university events, and public events
INSERT INTO EVENTS (RSO_ID, UNIVERSITY_ID) 
VALUES 
(1, 1),  -- RSO event at Tech University
(2, 2),  -- RSO event at Art University
(NULL, 1),  -- Private event at Tech University
(NULL, NULL);  -- Public event

-- Populate the APPROVED_EVENTS Table to ensure some events are approved
INSERT INTO APPROVED_EVENTS (EVENT_ID, SUPER_ADMIN_ID) 
VALUES 
(1, (SELECT USER_ID FROM USER_INFO WHERE EMAIL = 'techuser@techuniversity.com')),
(2, (SELECT USER_ID FROM USER_INFO WHERE EMAIL = 'artuser@artuniversity.com'));

-- Populate the COMMENT Table with some comments for events
INSERT INTO COMMENT (EVENT_ID, USER_ID, COMMENT, RATING) 
VALUES 
(1, (SELECT USER_ID FROM USER_INFO WHERE EMAIL = 'techuser@techuniversity.com'), 'Very informative session!', 5),
(2, (SELECT USER_ID FROM USER_INFO WHERE EMAIL = 'artuser@artuniversity.com'), 'Inspiring art workshop!', 4);

-- Testing the procedure to find all events for a user
CALL find_all_events((SELECT USER_ID FROM USER_INFO WHERE EMAIL = 'techuser@techuniversity.com'));
CALL find_all_events((SELECT USER_ID FROM USER_INFO WHERE EMAIL = 'artuser@artuniversity.com'));
