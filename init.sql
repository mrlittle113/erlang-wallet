-- Table users
DROP TABLE IF EXISTS users;
CREATE TABLE users (
    email VARCHAR(100) PRIMARY KEY,
    name VARCHAR(100),
    password VARCHAR(255) NOT NULL,
    role ENUM('admin', 'user') NOT NULL DEFAULT 'user',
    money BIGINT NOT NULL DEFAULT 0
);

-- Insert dummy data into the users table
INSERT INTO users (email, name, password, role, money) VALUES
('john.doe@example.com', 'John Doe', 'hashedpassword1', 'user', 100),
('jane.smith@example.com', 'Jane Smith', 'hashedpassword2', 'admin', 200),
('alice.johnson@example.com', 'Alice Johnson', 'hashedpassword3', 'user', 300),
('admin@example.com', 'Admin User', 'admin', 'admin', 500);