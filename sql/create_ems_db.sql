-- this is NOT made by gpt and WILL be used

DROP DATABASE IF EXISTS event_management_system;
CREATE DATABASE event_management_system;
use event_management_system;


-- if the tables exist delete them
DROP TABLE IF EXISTS User_Login;
DROP TABLE IF EXISTS University; 
DROP TABLE IF EXISTS RSO;
DROP TABLE IF EXISTS User;
DROP TABLE IF EXISTS Student;
DROP TABLE IF EXISTS RAdmin; -- Admin is a reserved word
DROP TABLE IF EXISTS SAdmin;
DROP TABLE IF EXISTS Events; -- Event is a reserved word
DROP TABLE IF EXISTS Approved_Events;
DROP TABLE IF EXISTS Comment;

-- drop the users
DROP USER IF EXISTS 'dev'@'localhost';

-- create dev user
-- CREATE USER 'dev'@'localhost' IDENTIFIED BY 'Password1!';
-- create if using js
CREATE USER 'dev'@'localhost' IDENTIFIED WITH mysql_native_password BY 'Password1!';
-- CREATE USER 'dev'@'localhost' IDENTIFIED BY 'Password1!';

-- grant dev user permissions
GRANT ALL PRIVILEGES ON event_management_system.* TO 'dev'@'localhost';

-- flush privileges
FLUSH PRIVILEGES;

-- Create User_Login table

-- Create University table
-- Create RSO table
-- Create User table
-- Create Student table
-- Create RAdmin table
-- Create SAdmin table
-- Create Events table
-- Create Approved_Events table
-- Create Comment table
