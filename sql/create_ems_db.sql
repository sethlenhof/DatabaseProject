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
CREATE TABLE User_Login {
    user_id INT,
    email VARCHAR(255),
    password VARCHAR(255)
}
-- Create University table
CREATE TABLE University {
    university_id INT,
    name VARCHAR(255),
    location VARCHAR(255),
    description TEXT
    num_of_students INT
}

-- Create RSO table
CREATE TABLE RSO {
    rso_id INT, 
    name VARCHAR(255),
    description TEXT
}

-- Create User table
CREATE TABLE User {
    user_id INT,
    name VARCHAR(255),
    university_id INT,
    foreign key (university_id) references University(university_id)
    foreign key (user_id) references User_Login(user_id)
}

-- Create Student table
CREATE TABLE Student {
    rso_id INT,
    user_id INT,
    foreign key (user_id) references User(user_id)
    foreign key (rso_id) references RSO(rso_id)
}

-- Create RAdmin table
CREATE TABLE RAdmin {
    user_id INT,
    rso_id INT,
    foreign key (user_id) references User(user_id)
    foreign key (rso_id) references RSO(rso_id)
}

-- Create SAdmin table
CREATE TABLE SAdmin {
    user_id INT,
    university_id INT,
    foreign key (user_id) references User(user_id)
    foreign key (university_id) references University(university_id)
}

-- Create Events table
CREATE TABLE Events {
    event_id INT,
    rso_id INT,
    university_id INT
}

-- Create Approved_Events table
CREATE TABLE Approved_Events {
    event_id INT,
    SAdmin_id INT
}

-- Create Comment table
CREATE TABLE Comment {
    comment_id INT,
    event_id INT,
    user_id INT,
    comment TEXT,
    rating INT,
    foreign key (event_id) references Events(event_id)
    foreign key (user_id) references User(user_id)
}

