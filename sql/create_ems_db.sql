-- this is NOT made by gpt and WILL be used

DROP DATABASE IF EXISTS event_management_system;
CREATE DATABASE event_management_system;
use event_management_system;


-- if the tables exist delete them
DROP TABLE IF EXISTS AdminApproval;
DROP TABLE IF EXISTS EventContacts;
DROP TABLE IF EXISTS EventComments;
DROP TABLE IF EXISTS EventRatings;
DROP TABLE IF EXISTS Events;
DROP TABLE IF EXISTS RSOMembers;
DROP TABLE IF EXISTS RSOs;
DROP TABLE IF EXISTS Universities;
DROP TABLE IF EXISTS UserUserTypes;
DROP TABLE IF EXISTS UserTypes;
DROP TABLE IF EXISTS UserLogin;
DROP TABLE IF EXISTS Users;

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


-- Users Table
CREATE TABLE Users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    email VARCHAR(255) NOT NULL UNIQUE
);

-- User Authentication Table (for storing hashed passwords and login info)
CREATE TABLE UserLogin (
    user_id INT PRIMARY KEY,
    password_hash VARCHAR(255) NOT NULL,
    last_login TIMESTAMP NULL,
    login_count INT DEFAULT 0,
    FOREIGN KEY (user_id) REFERENCES Users(user_id)
);

-- UserType Table
CREATE TABLE UserTypes (
    type_id INT AUTO_INCREMENT PRIMARY KEY,
    type_name ENUM('RSO', 'School') NOT NULL UNIQUE
);

-- UserUserType Junction Table
CREATE TABLE UserUserTypes (
    user_id INT,
    type_id INT,
    PRIMARY KEY (user_id, type_id),
    FOREIGN KEY (user_id) REFERENCES Users(user_id),
    FOREIGN KEY (type_id) REFERENCES UserTypes(type_id)
);

-- Universities Table
CREATE TABLE Universities (
    university_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    location VARCHAR(255) NOT NULL,
    description TEXT,
    number_of_students INT,
    picture_url VARCHAR(255)
);

-- RSO Table
CREATE TABLE RSOs (
    rso_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    admin_id INT NOT NULL,
    university_id INT NOT NULL,
    FOREIGN KEY (admin_id) REFERENCES Users(user_id),
    FOREIGN KEY (university_id) REFERENCES Universities(university_id)
);

-- RSO Members Junction Table
CREATE TABLE RSOMembers (
    rso_id INT,
    user_id INT,
    PRIMARY KEY (rso_id, user_id),
    FOREIGN KEY (rso_id) REFERENCES RSOs(rso_id),
    FOREIGN KEY (user_id) REFERENCES Users(user_id)
);

-- Events Table
CREATE TABLE Events (
    event_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    description TEXT NOT NULL,
    location VARCHAR(255) NOT NULL,
    visibility ENUM('Public', 'Private') NOT NULL,
    university_id INT,
    user_created INT,
    FOREIGN KEY (university_id) REFERENCES Universities(university_id),
    FOREIGN KEY (user_created) REFERENCES Users(user_id)
);

-- EventRatings Table
CREATE TABLE EventRatings (
    rating_id INT AUTO_INCREMENT PRIMARY KEY,
    event_id INT,
    rating DECIMAL(3, 2),
    user_id INT,
    FOREIGN KEY (event_id) REFERENCES Events(event_id),
    FOREIGN KEY (user_id) REFERENCES Users(user_id)
);

-- EventComments Table
CREATE TABLE EventComments (
    comment_id INT AUTO_INCREMENT PRIMARY KEY,
    event_id INT,
    user_id INT,
    comment TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (event_id) REFERENCES Events(event_id),
    FOREIGN KEY (user_id) REFERENCES Users(user_id)
);

-- EventContacts Table
CREATE TABLE EventContacts (
    event_id INT PRIMARY KEY,
    contact_phone VARCHAR(20),
    contact_email VARCHAR(255),
    FOREIGN KEY (event_id) REFERENCES Events(event_id)
);

-- AdminApproval Table
CREATE TABLE AdminApproval (
    event_id INT,
    admin_id INT,
    approval_status BOOLEAN DEFAULT FALSE,
    approved_at TIMESTAMP,
    PRIMARY KEY (event_id, admin_id),
    FOREIGN KEY (event_id) REFERENCES Events(event_id),
    FOREIGN KEY (admin_id) REFERENCES Users(user_id)
);
