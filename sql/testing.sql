-- Test Procedures File: test.sql
USE event_management_system;

-- Adding Users using the 'insert_user_login' procedure
CALL insert_user_login('user1@example.com', 'Password1!');
CALL insert_user_login('user2@example.com', 'Password1!');
CALL insert_user_login('user3@example.com', 'Password1!');
CALL insert_user_login('user4@example.com', 'Password1!');
CALL insert_user_login('user5@example.com', 'Password1!');
CALL insert_user_login('user6@example.com', 'Password1!');
CALL insert_user_login('user7@example.com', 'Password1!');
CALL insert_user_login('user8@example.com', 'Password1!');
CALL insert_user_login('user9@example.com', 'Password1!');
CALL insert_user_login('user10@example.com', 'Password1!');

-- Adding RSOs using a custom procedure for creating RSOs and assigning an admin
CALL create_rso_and_admin('user1', 'RSO Science Club', 'Science', 'Blue', 'A club for science enthusiasts');
CALL create_rso_and_admin('user2', 'RSO Math Club', 'Mathematics', 'Green', 'Focus on advanced math techniques');
CALL create_rso_and_admin('user3', 'RSO Engineering Club', 'Engineering', 'Red', 'Engineering projects and networking');
CALL create_rso_and_admin('user4', 'RSO Literature Club', 'Literature', 'Yellow', 'Exploring world literature');
CALL create_rso_and_admin('user5', 'RSO Technology Club', 'Technology', 'Purple', 'Latest in technology trends');

-- Adding Events using 'insert_event' procedure
CALL insert_event(1, 1, 'Math Conference', 'Educational', 'Annual math conference', '2024-05-10 09:00', '2024-05-10 17:00', 'Campus Center', '555-1234', 'contact@univ.com');
CALL insert_event(1, 1, 'Physics Symposium', 'Educational', 'Annual physics symposium', '2024-06-15 09:00', '2024-06-15 17:00', 'Science Building', '555-2345', 'contact2@univ.com');
CALL insert_event(2, 1, 'Chemistry Workshop', 'Educational', 'Annual chemistry workshop', '2024-07-20 09:00', '2024-07-20 17:00', 'Chemistry Lab', '555-3456', 'contact3@univ.com');
CALL insert_event(2, 1, 'Biology Seminar', 'Educational', 'Annual biology seminar', '2024-08-25 09:00', '2024-08-25 17:00', 'Biology Department', '555-4567', 'contact4@univ.com');
CALL insert_event(3, 1, 'Computer Science Fair', 'Educational', 'Annual computer science fair', '2024-09-30 09:00', '2024-09-30 17:00', 'Tech Center', '555-5678', 'contact5@univ.com');
CALL insert_event(3, 1, 'Engineering Expo', 'Educational', 'Annual engineering expo', '2024-10-05 09:00', '2024-10-05 17:00', 'Engineering Hall', '555-6789', 'contact6@univ.com');
CALL insert_event(4, 1, 'Mathematics Colloquium', 'Educational', 'Annual mathematics colloquium', '2024-11-10 09:00', '2024-11-10 17:00', 'Math Department', '555-7890', 'contact7@univ.com');
CALL insert_event(4, 1, 'Physics Conference', 'Educational', 'Annual physics conference', '2024-12-15 09:00', '2024-12-15 17:00', 'Physics Department', '555-8901', 'contact8@univ.com');
CALL insert_event(5, 1, 'Chemistry Colloquium', 'Educational', 'Annual chemistry colloquium', '2025-01-20 09:00', '2025-01-20 17:00', 'Chemistry Department', '555-9012', 'contact9@univ.com');
CALL insert_event(5, 1, 'Biology Workshop', 'Educational', 'Annual biology workshop', '2025-02-25 09:00', '2025-02-25 17:00', 'Biology Lab', '555-0123', 'contact10@univ.com');
CALL insert_event(1, 1, 'Astronomy Night', 'Educational', 'Stargazing and lectures', '2025-03-15 20:00', '2025-03-15 23:00', 'Observatory', '555-1122', 'contact11@univ.com');
CALL insert_event(2, 1, 'Coding Marathon', 'Educational', '24-hour coding challenge', '2025-04-01 09:00', '2025-04-02 09:00', 'Tech Center', '555-2211', 'contact12@univ.com');
CALL insert_event(3, 1, 'Robotics Workshop', 'Educational', 'Hands-on robotics training', '2025-05-05 09:00', '2025-05-05 17:00', 'Engineering Lab', '555-3311', 'contact13@univ.com');
CALL insert_event(4, 1, 'Literature Festival', 'Educational', 'Celebrating world literature', '2025-06-10 09:00', '2025-06-10 17:00', 'Library', '555-4411', 'contact14@univ.com');
CALL insert_event(5, 1, 'Tech Expo', 'Educational', 'Showcasing latest tech trends', '2025-07-15 09:00', '2025-07-15 17:00', 'Exhibition Hall', '555-5511', 'contact15@univ.com');
CALL insert_event(1, 1, 'Science Fair', 'Educational', 'Annual science fair', '2025-08-20 09:00', '2025-08-20 17:00', 'Science Building', '555-6611', 'contact16@univ.com');
CALL insert_event(2, 1, 'Math Olympiad', 'Educational', 'Math competition for students', '2025-09-25 09:00', '2025-09-25 17:00', 'Math Department', '555-7711', 'contact17@univ.com');
CALL insert_event(3, 1, 'Engineering Summit', 'Educational', 'Annual engineering summit', '2025-10-30 09:00', '2025-10-30 17:00', 'Engineering Hall', '555-8811', 'contact18@univ.com');
CALL insert_event(4, 1, 'Literature Symposium', 'Educational', 'Discussions on classic literature', '2025-11-04 09:00', '2025-11-04 17:00', 'Library', '555-9911', 'contact19@univ.com');
CALL insert_event(5, 1, 'Tech Workshop', 'Educational', 'Workshop on latest technologies', '2025-12-09 09:00', '2025-12-09 17:00', 'Tech Center', '555-1010', 'contact20@univ.com');

-- Adding Comments using 'insert_comment' procedure
CALL insert_comment(1, 'user1', 'Very informative event.', 5);
CALL insert_comment(2, 'user2', 'Loved the discussions.', 4);
CALL insert_comment(3, 'user3', 'Great speakers.', 5);
CALL insert_comment(4, 'user4', 'Interesting topics.', 4);
CALL insert_comment(5, 'user5', 'Well organized.', 5);
CALL insert_comment(6, 'user6', 'Learned a lot.', 4);
CALL insert_comment(7, 'user7', 'Engaging presentations.', 5);
CALL insert_comment(8, 'user8', 'Would attend again.', 4);
CALL insert_comment(9, 'user9', 'Excellent event.', 5);
CALL insert_comment(10, 'user10', 'Highly recommend.', 4);

-- Checking Table Statuses using SQL queries
SELECT 'Total Users:', COUNT(*) FROM USER_LOGIN;
SELECT 'Total RSOs:', COUNT(*) FROM RSO;
SELECT 'Total Events:', COUNT(*) FROM EVENTS;
SELECT 'Total Comments:', COUNT(*) FROM COMMENT;

-- Additional utility procedures (e.g., to test or debug)
CALL testGetRSO();
CALL testJoinRSO();
CALL test_get_unapproved_events();
CALL test_approve_event();

