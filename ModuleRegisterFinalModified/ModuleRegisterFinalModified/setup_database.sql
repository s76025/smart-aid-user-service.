-- ============================================================
--  Dino LCMS – Database Setup Script
--  Database: CSE3953
--  Run this in MySQL Workbench or phpMyAdmin
-- ============================================================

CREATE DATABASE IF NOT EXISTS CSE3953;
USE CSE3953;

-- ── Managers ──────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS managers (
    id       INT          AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50)  NOT NULL UNIQUE,
    password VARCHAR(100) NOT NULL,
    email    VARCHAR(100)
);

-- Default manager account (username: admin  password: admin123)
INSERT IGNORE INTO managers (username, password, email)
VALUES ('admin', 'admin123', 'admin@lcms.edu.my');

-- ── Teachers ──────────────────────────────────────────────
--  Only the Manager (admin) can create teacher accounts.
CREATE TABLE IF NOT EXISTS teachers (
    id                  INT          AUTO_INCREMENT PRIMARY KEY,
    username            VARCHAR(50)  NOT NULL UNIQUE,
    password            VARCHAR(100) NOT NULL,
    full_name           VARCHAR(100),
    ic_number           VARCHAR(20),          -- format: 900101-14-5678
    email               VARCHAR(100),
    phone               VARCHAR(20),
    qualification       VARCHAR(150),         -- e.g. Bachelor of Education
    teaching_experience VARCHAR(100),         -- e.g. 5 years
    subject             VARCHAR(100)
);

-- ── Migration: add new columns if upgrading from old schema ──
-- Run these only if the teachers table already exists without the new columns:
-- ALTER TABLE teachers ADD COLUMN ic_number           VARCHAR(20)  AFTER full_name;
-- ALTER TABLE teachers ADD COLUMN qualification       VARCHAR(150) AFTER phone;
-- ALTER TABLE teachers ADD COLUMN teaching_experience VARCHAR(100) AFTER qualification;

-- Default teacher account (username: teacher1  password: teacher123)
INSERT IGNORE INTO teachers (username, password, full_name, ic_number, email, phone,
                              qualification, teaching_experience, subject)
VALUES ('teacher1', 'teacher123', 'Cikgu Demo', '900101-14-0000',
        'teacher@lcms.edu.my', '+60 12-000 0000',
        'Bachelor of Education', '3 years', 'General');

-- ── Parents ───────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS parents (
    id         INT          AUTO_INCREMENT PRIMARY KEY,
    username   VARCHAR(50)  NOT NULL UNIQUE,
    password   VARCHAR(100) NOT NULL,
    email      VARCHAR(100),
    phone      VARCHAR(20),
    age        INT,
    occupation VARCHAR(100),
    address    TEXT,
    ic         VARCHAR(20)
);

-- ── Students ──────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS students (
    id           INT          AUTO_INCREMENT PRIMARY KEY,
    first_name   VARCHAR(50)  NOT NULL,
    last_name    VARCHAR(50),
    dob          VARCHAR(20),
    gender       VARCHAR(10),
    guardian     VARCHAR(100),
    relationship VARCHAR(50),
    phone        VARCHAR(20),
    email        VARCHAR(100),
    parent_id    INT,
    FOREIGN KEY (parent_id) REFERENCES parents(id) ON DELETE SET NULL
);

-- ── ClassRooms ────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS classrooms (
    id           INT          AUTO_INCREMENT PRIMARY KEY,
    class_name   VARCHAR(100) NOT NULL,
    class_code   VARCHAR(20),
    max_children INT,
    lead_teacher VARCHAR(100),
    class_days   VARCHAR(100)
);

-- ============================================================
--  Done! Tables created. Connect with:
--    URL:      jdbc:mysql://localhost:3306/CSE3953
--    User:     root
--    Password: admin   (change in DBConnection.java if different)
-- ============================================================
