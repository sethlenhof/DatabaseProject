USE event_management_system;

-- Inserting sample universities
INSERT INTO UNIVERSITY (NAME, LOCATION, DESCRIPTION, NUM_OF_STUDENTS) VALUES 
('Tech University', 'Tech City', 'A leading university in technology.', 10000),
('Humanities University', 'Humanities City', 'A leading university in humanities.', 8000);

-- Inserting sample RSOs
INSERT INTO RSO (NAME, DESCRIPTION) VALUES 
('Tech Club', 'A club for tech enthusiasts.'),
('Literature Society', 'A society for lovers of literature.');

-- Inserting sample users
INSERT INTO USER_LOGIN (EMAIL, PASS) VALUES 
('john.doe@example.com', SHA2('password123', 256)),
('jane.smith@example.com', SHA2('password456', 256));

INSERT INTO USER_INFO (NAME, UNIVERSITY_ID) VALUES 
('John Doe', 1),
('Jane Smith', 2);

-- Assigning users to RSOs and roles
INSERT INTO STUDENT (RSO_ID, USER_ID) VALUES 
(1, 1),
(2, 2);

INSERT INTO RSO_ADMIN (USER_ID, RSO_ID) VALUES 
(1, 1),
(2, 2);

INSERT INTO SUPER_ADMIN (USER_ID, UNIVERSITY_ID) VALUES 
(1, 1),
(2, 2);

-- Inserting sample events
-- Public events
INSERT INTO EVENTS (RSO_ID, UNIVERSITY_ID) VALUES 
(NULL, NULL);

-- RSO specific events
INSERT INTO EVENTS (RSO_ID, UNIVERSITY_ID) VALUES 
(1, 1),
(2, 2);

-- University wide events
INSERT INTO EVENTS (RSO_ID, UNIVERSITY_ID) VALUES 
(NULL, 1),
(NULL, 2);

-- Approving some events
INSERT INTO APPROVED_EVENTS (EVENT_ID, SUPER_ADMIN_ID) VALUES 
(1, 1),
(2, 2);

-- Adding comments to events
INSERT INTO COMMENT (EVENT_ID, USER_ID, COMMENT, RATING) VALUES 
(1, 1, 'Great event!', 5),
(2, 2, 'Very informative.', 4);


CALL find_all_events(1);
