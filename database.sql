-- ====================================================================
-- DIGITAL LIBRARY MANAGEMENT SYSTEM (DLMS) - DATABASE SCRIPT
-- B.Tech PBL Project | Team No: 1
-- Members: L.N.C Siddhartha, Md. Amanuddin, Jashwanth Chowdary
-- Compatible with MySQL 5.7+ / MySQL 8.0+ / MariaDB
-- ====================================================================

DROP DATABASE IF EXISTS library_management;
CREATE DATABASE library_management CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE library_management;

-- --------------------------------------------------------------------
-- Table 1: USERS (Authentication & Role-Based Access Control)
-- Roles: ADMIN, LIBRARIAN, STUDENT, FACULTY
-- --------------------------------------------------------------------
CREATE TABLE users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    email VARCHAR(100) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    role ENUM('ADMIN', 'LIBRARIAN', 'STUDENT', 'FACULTY') NOT NULL DEFAULT 'STUDENT',
    member_id VARCHAR(30) NULL,
    status ENUM('ACTIVE', 'INACTIVE', 'SUSPENDED') NOT NULL DEFAULT 'ACTIVE',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_user_username (username),
    INDEX idx_user_email (email),
    INDEX idx_user_role (role)
) ENGINE=InnoDB;

-- --------------------------------------------------------------------
-- Table 2: MEMBERS (Library Patrons: Students, Research Scholars, Faculty)
-- --------------------------------------------------------------------
CREATE TABLE members (
    id INT AUTO_INCREMENT PRIMARY KEY,
    member_id VARCHAR(30) NOT NULL UNIQUE,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    phone VARCHAR(20) NOT NULL,
    department VARCHAR(80) NOT NULL,
    year VARCHAR(20) NOT NULL, -- e.g., '1st Year', '2nd Year', '3rd Year', '4th Year', 'Faculty'
    member_type ENUM('STUDENT', 'FACULTY', 'SCHOLAR') NOT NULL DEFAULT 'STUDENT',
    max_borrow_limit INT NOT NULL DEFAULT 4,
    registration_date DATE NOT NULL,
    status ENUM('ACTIVE', 'EXPIRED', 'SUSPENDED') NOT NULL DEFAULT 'ACTIVE',
    INDEX idx_member_id (member_id),
    INDEX idx_member_name (name),
    INDEX idx_member_dept (department),
    INDEX idx_member_status (status)
) ENGINE=InnoDB;

-- --------------------------------------------------------------------
-- Table 3: BOOKS (Catalog of Physical & Digital Resources)
-- --------------------------------------------------------------------
CREATE TABLE books (
    id INT AUTO_INCREMENT PRIMARY KEY,
    book_id VARCHAR(30) NOT NULL UNIQUE,
    isbn VARCHAR(30) NOT NULL UNIQUE,
    title VARCHAR(200) NOT NULL,
    author VARCHAR(150) NOT NULL,
    category VARCHAR(80) NOT NULL,
    publisher VARCHAR(120) NOT NULL,
    publication_year INT NOT NULL,
    language VARCHAR(40) NOT NULL DEFAULT 'English',
    description TEXT NULL,
    shelf_number VARCHAR(30) NOT NULL,
    quantity INT NOT NULL DEFAULT 1,
    available_copies INT NOT NULL DEFAULT 1,
    status ENUM('AVAILABLE', 'OUT_OF_STOCK', 'ARCHIVED', 'LOST') NOT NULL DEFAULT 'AVAILABLE',
    cover_url VARCHAR(300) NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_book_id (book_id),
    INDEX idx_book_isbn (isbn),
    INDEX idx_book_title (title),
    INDEX idx_book_author (author),
    INDEX idx_book_category (category),
    INDEX idx_book_status (status)
) ENGINE=InnoDB;

-- --------------------------------------------------------------------
-- Table 4: TRANSACTIONS (Circulation: Issue and Return Records)
-- --------------------------------------------------------------------
CREATE TABLE transactions (
    id INT AUTO_INCREMENT PRIMARY KEY,
    transaction_id VARCHAR(40) NOT NULL UNIQUE,
    member_id VARCHAR(30) NOT NULL,
    book_id VARCHAR(30) NOT NULL,
    issue_date DATE NOT NULL,
    due_date DATE NOT NULL,
    return_date DATE NULL,
    fine DECIMAL(8,2) NOT NULL DEFAULT 0.00,
    status ENUM('ISSUED', 'RETURNED', 'OVERDUE', 'LOST') NOT NULL DEFAULT 'ISSUED',
    issued_by VARCHAR(50) DEFAULT 'admin',
    remarks VARCHAR(255) NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_tx_member (member_id),
    INDEX idx_tx_book (book_id),
    INDEX idx_tx_status (status),
    INDEX idx_tx_due_date (due_date),
    CONSTRAINT fk_tx_member FOREIGN KEY (member_id) REFERENCES members(member_id) ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT fk_tx_book FOREIGN KEY (book_id) REFERENCES books(book_id) ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE=InnoDB;

-- --------------------------------------------------------------------
-- Table 5: RESERVATIONS (Waitlist Queue for Currently Unavailable Books)
-- First-Come, First-Served Queue
-- --------------------------------------------------------------------
CREATE TABLE reservations (
    id INT AUTO_INCREMENT PRIMARY KEY,
    reservation_id VARCHAR(40) NOT NULL UNIQUE,
    member_id VARCHAR(30) NOT NULL,
    book_id VARCHAR(30) NOT NULL,
    reservation_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    queue_position INT NOT NULL DEFAULT 1,
    status ENUM('PENDING', 'NOTIFIED', 'FULFILLED', 'CANCELLED', 'EXPIRED') NOT NULL DEFAULT 'PENDING',
    expiry_date DATE NULL,
    INDEX idx_res_member (member_id),
    INDEX idx_res_book (book_id),
    INDEX idx_res_status (status),
    CONSTRAINT fk_res_member FOREIGN KEY (member_id) REFERENCES members(member_id) ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT fk_res_book FOREIGN KEY (book_id) REFERENCES books(book_id) ON UPDATE CASCADE ON DELETE CASCADE
) ENGINE=InnoDB;

-- --------------------------------------------------------------------
-- Table 6: FINES (Overdue Penalties & Payment Auditing)
-- --------------------------------------------------------------------
CREATE TABLE fines (
    id INT AUTO_INCREMENT PRIMARY KEY,
    fine_id VARCHAR(40) NOT NULL UNIQUE,
    transaction_id VARCHAR(40) NOT NULL,
    member_id VARCHAR(30) NOT NULL,
    amount DECIMAL(8,2) NOT NULL,
    days_late INT NOT NULL DEFAULT 0,
    status ENUM('UNPAID', 'PAID', 'WAIVED') NOT NULL DEFAULT 'UNPAID',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    paid_at TIMESTAMP NULL,
    payment_mode ENUM('CASH', 'UPI', 'CARD', 'ONLINE', 'WAIVED') NULL,
    INDEX idx_fine_tx (transaction_id),
    INDEX idx_fine_member (member_id),
    INDEX idx_fine_status (status),
    CONSTRAINT fk_fine_tx FOREIGN KEY (transaction_id) REFERENCES transactions(transaction_id) ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT fk_fine_member FOREIGN KEY (member_id) REFERENCES members(member_id) ON UPDATE CASCADE ON DELETE CASCADE
) ENGINE=InnoDB;

-- --------------------------------------------------------------------
-- Table 7: NOTIFICATIONS (System Toasts, Alerts, Due Date Reminders)
-- --------------------------------------------------------------------
CREATE TABLE notifications (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    title VARCHAR(120) NOT NULL,
    message VARCHAR(255) NOT NULL,
    type ENUM('INFO', 'SUCCESS', 'WARNING', 'DANGER') NOT NULL DEFAULT 'INFO',
    is_read BOOLEAN NOT NULL DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_notif_user (user_id),
    INDEX idx_notif_read (is_read),
    CONSTRAINT fk_notif_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
) ENGINE=InnoDB;

-- ====================================================================
-- SEED DATA (Realistic Engineering & College Library Dataset)
-- Passwords below are SHA-256 / BCrypt for standard default credentials:
-- 'admin123' -> 240be518fabd2724ddb6f04eeb1da5967448d7e831c08c8fa822809f74c720a9
-- 'student123' -> d550b06437d8e2d4d989fce0a7e04f9ffadba04f5e048130761e2ca4cb38eb35
-- Plain text or SHA256 supported via PasswordHasher utility
-- ====================================================================

-- 1. Insert Members (8+ realistic members)
INSERT INTO members (member_id, name, email, phone, department, year, member_type, max_borrow_limit, registration_date, status) VALUES
('MEM-2024-001', 'L.N.C Siddhartha', 'siddhartha@library.edu', '+91 98765 43210', 'Computer Science & Engineering', '3rd Year', 'STUDENT', 4, '2024-01-10', 'ACTIVE'),
('MEM-2024-002', 'Md. Amanuddin', 'amanuddin@library.edu', '+91 98765 43211', 'Computer Science & Engineering', '3rd Year', 'STUDENT', 4, '2024-01-10', 'ACTIVE'),
('MEM-2024-003', 'Jashwanth Chowdary', 'jashwanth@library.edu', '+91 98765 43212', 'Computer Science & Engineering', '3rd Year', 'STUDENT', 4, '2024-01-12', 'ACTIVE'),
('MEM-2024-004', 'Dr. Rajesh Sharma', 'rajesh.sharma@library.edu', '+91 98765 11223', 'Information Technology', 'Faculty', 'FACULTY', 8, '2023-08-01', 'ACTIVE'),
('MEM-2024-005', 'Priya Nair', 'priya.nair@library.edu', '+91 98765 22334', 'Electronics & Communication', '2nd Year', 'STUDENT', 4, '2024-02-15', 'ACTIVE'),
('MEM-2024-006', 'Rohan Verma', 'rohan.verma@library.edu', '+91 98765 33445', 'Mechanical Engineering', '4th Year', 'STUDENT', 4, '2023-09-05', 'ACTIVE'),
('MEM-2024-007', 'Prof. Ananya Sen', 'ananya.sen@library.edu', '+91 98765 44556', 'Computer Science & Engineering', 'Faculty', 'FACULTY', 8, '2023-07-20', 'ACTIVE'),
('MEM-2024-008', 'Kavita Reddy', 'kavita.reddy@library.edu', '+91 98765 55667', 'Data Science & AI', '1st Year', 'STUDENT', 4, '2024-08-20', 'ACTIVE'),
('MEM-2024-009', 'Vikram Aditya', 'vikram.aditya@library.edu', '+91 98765 66778', 'Civil Engineering', '3rd Year', 'STUDENT', 4, '2024-03-01', 'ACTIVE');

-- 2. Insert Users (Admin, Student, Faculty logins)
-- Password for all defaults is: 'admin123' for admin, 'student123' for students, 'faculty123' for faculty
-- Hashes stored: SHA-256
INSERT INTO users (username, email, password_hash, role, member_id, status) VALUES
('admin', 'admin@library.edu', '240be518fabd2724ddb6f04eeb1da5967448d7e831c08c8fa822809f74c720a9', 'ADMIN', NULL, 'ACTIVE'),
('librarian', 'librarian@library.edu', '240be518fabd2724ddb6f04eeb1da5967448d7e831c08c8fa822809f74c720a9', 'LIBRARIAN', NULL, 'ACTIVE'),
('siddhartha', 'siddhartha@library.edu', 'd550b06437d8e2d4d989fce0a7e04f9ffadba04f5e048130761e2ca4cb38eb35', 'STUDENT', 'MEM-2024-001', 'ACTIVE'),
('aman', 'amanuddin@library.edu', 'd550b06437d8e2d4d989fce0a7e04f9ffadba04f5e048130761e2ca4cb38eb35', 'STUDENT', 'MEM-2024-002', 'ACTIVE'),
('jashwanth', 'jashwanth@library.edu', 'd550b06437d8e2d4d989fce0a7e04f9ffadba04f5e048130761e2ca4cb38eb35', 'STUDENT', 'MEM-2024-003', 'ACTIVE'),
('student', 'student@library.edu', 'd550b06437d8e2d4d989fce0a7e04f9ffadba04f5e048130761e2ca4cb38eb35', 'STUDENT', 'MEM-2024-005', 'ACTIVE'),
('drrajesh', 'rajesh.sharma@library.edu', 'd550b06437d8e2d4d989fce0a7e04f9ffadba04f5e048130761e2ca4cb38eb35', 'FACULTY', 'MEM-2024-004', 'ACTIVE');

-- 3. Insert Books (18 comprehensive library titles with real covers & categories)
INSERT INTO books (book_id, isbn, title, author, category, publisher, publication_year, language, description, shelf_number, quantity, available_copies, status, cover_url) VALUES
('BK-1001', '978-0262033848', 'Introduction to Algorithms (CLRS)', 'Thomas H. Cormen, Charles E. Leiserson', 'Computer Science', 'MIT Press', 2022, 'English', 'The leading textbook on computer algorithms, covering dynamic programming, greedy algorithms, graph theory, and advanced data structures.', 'CS-A1-04', 5, 3, 'AVAILABLE', 'https://images.unsplash.com/photo-1532012164546-f432f2e3777a?w=400&q=80'),
('BK-1002', '978-0131103627', 'The C Programming Language', 'Brian W. Kernighan, Dennis M. Ritchie', 'Programming', 'Prentice Hall', 2018, 'English', 'The definitive guide to ANSI standard C programming by the creators of the language.', 'CS-A2-12', 6, 4, 'AVAILABLE', 'https://images.unsplash.com/photo-1544716278-ca5e3f4abd8c?w=400&q=80'),
('BK-1003', '978-0134685991', 'Effective Java (3rd Edition)', 'Joshua Bloch', 'Programming', 'Addison-Wesley', 2018, 'English', 'Essential best practices for the Java platform covering generics, lambdas, streams, and concurrency.', 'CS-B1-08', 4, 2, 'AVAILABLE', 'https://images.unsplash.com/photo-1512820790803-83ca734da794?w=400&q=80'),
('BK-1004', '978-0132350884', 'Clean Code: A Handbook of Agile Software', 'Robert C. Martin (Uncle Bob)', 'Software Engineering', 'Prentice Hall', 2008, 'English', 'A handbook of agile software craftsmanship for writing readable, maintainable, and elegant code.', 'CS-B2-03', 4, 1, 'AVAILABLE', 'https://images.unsplash.com/photo-1589829085413-56de8ae18c73?w=400&q=80'),
('BK-1005', '978-0078022159', 'Database System Concepts (7th Edition)', 'Abraham Silberschatz, Henry F. Korth', 'Database Systems', 'McGraw-Hill', 2019, 'English', 'Comprehensive coverage of relational models, SQL, indexing, transaction processing, and concurrency control.', 'DB-A1-01', 5, 0, 'OUT_OF_STOCK', 'https://images.unsplash.com/photo-1507842229451-7f01be7fe8e6?w=400&q=80'),
('BK-1006', '978-0133594140', 'Operating System Concepts (10th Edition)', 'Abraham Silberschatz, Peter B. Galvin', 'Operating Systems', 'Wiley', 2018, 'English', 'Foundational concepts of threads, CPU scheduling, synchronization, memory management, and virtualization.', 'OS-C1-09', 4, 2, 'AVAILABLE', 'https://images.unsplash.com/photo-1497633762265-9d179a990aa6?w=400&q=80'),
('BK-1007', '978-0132126953', 'Computer Networks (5th Edition)', 'Andrew S. Tanenbaum, David J. Wetherall', 'Networking', 'Pearson', 2013, 'English', 'In-depth explanation of physical, data link, network, transport, and application layers including IPv6 and wireless.', 'NW-D2-14', 5, 3, 'AVAILABLE', 'https://images.unsplash.com/photo-1524995997946-a1c2e315a42f?w=400&q=80'),
('BK-1008', '978-0262035613', 'Deep Learning (Adaptive Computation & ML)', 'Ian Goodfellow, Yoshua Bengio, Aaron Courville', 'Artificial Intelligence', 'MIT Press', 2016, 'English', 'Mathematical and conceptual background of deep neural networks, CNNs, RNNs, and generative modeling.', 'AI-A1-05', 3, 1, 'AVAILABLE', 'https://images.unsplash.com/photo-1516979187457-637abb4f9353?w=400&q=80'),
('BK-1009', '978-1449369415', 'Designing Data-Intensive Applications', 'Martin Kleppmann', 'Software Architecture', 'O\'Reilly Media', 2017, 'English', 'The big ideas behind reliable, scalable, and maintainable storage engines, stream processing, and distributed consensus.', 'SA-B3-11', 4, 2, 'AVAILABLE', 'https://images.unsplash.com/photo-1457369804613-52c61a468e7d?w=400&q=80'),
('BK-1010', '978-0131495050', 'Artificial Intelligence: A Modern Approach', 'Stuart Russell, Peter Norvig', 'Artificial Intelligence', 'Pearson', 2020, 'English', 'The standard worldwide authority on intelligent agents, heuristic search, logic inference, and probabilistic reasoning.', 'AI-A2-07', 4, 0, 'OUT_OF_STOCK', 'https://images.unsplash.com/photo-1495446815901-a7297e633e8d?w=400&q=80'),
('BK-1011', '978-0134444321', 'Software Engineering: A Practitioner\'s Approach', 'Roger S. Pressman, Bruce R. Maxim', 'Software Engineering', 'McGraw-Hill', 2019, 'English', 'Framework for agile workflows, requirements engineering, architectural design, software testing, and DevOps metrics.', 'SE-A3-02', 6, 5, 'AVAILABLE', 'https://images.unsplash.com/photo-1481627834876-b7833e8f5570?w=400&q=80'),
('BK-1012', '978-0070147331', 'Discrete Mathematics and Its Applications', 'Kenneth H. Rosen', 'Mathematics', 'McGraw-Hill', 2018, 'English', 'Combinatorics, propositional logic, graph theory, set theory, and recurrence relations for computer scientists.', 'MA-C2-01', 5, 4, 'AVAILABLE', 'https://images.unsplash.com/photo-1512820790803-83ca734da794?w=400&q=80'),
('BK-1013', '978-1491957660', 'Python Crash Course (2nd Edition)', 'Eric Matthes', 'Programming', 'No Starch Press', 2019, 'English', 'A hands-on, project-based introduction to programming in Python, data visualization, and web applications.', 'CS-D1-15', 6, 4, 'AVAILABLE', 'https://images.unsplash.com/photo-1544716278-ca5e3f4abd8c?w=400&q=80'),
('BK-1014', '978-0201633610', 'Design Patterns: Elements of Reusable Object-Oriented Software', 'Erich Gamma, Richard Helm, Ralph Johnson, John Vlissides', 'Software Architecture', 'Addison-Wesley', 1994, 'English', 'The classic Gang of Four (GoF) catalog of 23 fundamental software engineering design patterns.', 'CS-B3-06', 4, 3, 'AVAILABLE', 'https://images.unsplash.com/photo-1532012164546-f432f2e3777a?w=400&q=80'),
('BK-1015', '978-0134092669', 'Computer Organization and Architecture', 'William Stallings', 'Computer Science', 'Pearson', 2018, 'English', 'Structure and function of computers, pipelining, cache memory, RISC architectures, and superscalar processors.', 'CS-E1-04', 5, 4, 'AVAILABLE', 'https://images.unsplash.com/photo-1589829085413-56de8ae18c73?w=400&q=80'),
('BK-1016', '978-0262033855', 'Compilers: Principles, Techniques, and Tools (Dragon Book)', 'Alfred V. Aho, Monica S. Lam, Ravi Sethi, Jeffrey D. Ullman', 'Computer Science', 'Addison-Wesley', 2006, 'English', 'Lexical analysis, syntax-directed translation, code optimization, and code generation for compilers.', 'CS-E2-10', 3, 2, 'AVAILABLE', 'https://images.unsplash.com/photo-1507842229451-7f01be7fe8e6?w=400&q=80'),
('BK-1017', '978-0132350891', 'Head First Design Patterns', 'Eric Freeman, Elisabeth Robson', 'Software Architecture', 'O\'Reilly Media', 2020, 'English', 'A visually rich, brain-friendly guide to design patterns, OOP principles, and loose coupling.', 'CS-B4-02', 5, 3, 'AVAILABLE', 'https://images.unsplash.com/photo-1497633762265-9d179a990aa6?w=400&q=80'),
('BK-1018', '978-1449331818', 'Learning JavaScript Design Patterns', 'Addy Osmani', 'Web Development', 'O\'Reilly Media', 2017, 'English', 'Explore classical and modern design patterns to write beautiful, structured, and maintainable JavaScript code.', 'WB-A1-08', 4, 3, 'AVAILABLE', 'https://images.unsplash.com/photo-1524995997946-a1c2e315a42f?w=400&q=80');

-- 4. Insert Transactions (Active, Overdue, and Returned records)
INSERT INTO transactions (transaction_id, member_id, book_id, issue_date, due_date, return_date, fine, status, issued_by, remarks) VALUES
-- Returned on time
('TXN-2024-1001', 'MEM-2024-001', 'BK-1002', '2024-08-01', '2024-08-15', '2024-08-14', 0.00, 'RETURNED', 'admin', 'Returned in good condition'),
-- Returned late with fine collected
('TXN-2024-1002', 'MEM-2024-002', 'BK-1003', '2024-08-05', '2024-08-19', '2024-08-23', 20.00, 'RETURNED', 'admin', 'Returned 4 days late, fine paid'),
-- Currently Active (Due in future)
('TXN-2024-1003', 'MEM-2024-001', 'BK-1004', '2024-10-01', '2024-10-15', NULL, 0.00, 'ISSUED', 'admin', 'Active loan'),
('TXN-2024-1004', 'MEM-2024-002', 'BK-1001', '2024-10-02', '2024-10-16', NULL, 0.00, 'ISSUED', 'admin', 'Active loan'),
('TXN-2024-1005', 'MEM-2024-003', 'BK-1006', '2024-09-28', '2024-10-12', NULL, 0.00, 'ISSUED', 'admin', 'Active loan'),
-- Overdue Transaction (Past due date)
('TXN-2024-1006', 'MEM-2024-005', 'BK-1005', '2024-09-10', '2024-09-24', NULL, 65.00, 'OVERDUE', 'admin', 'Overdue by 13 days'),
('TXN-2024-1007', 'MEM-2024-006', 'BK-1010', '2024-09-12', '2024-09-26', NULL, 55.00, 'OVERDUE', 'admin', 'Overdue by 11 days'),
-- Active loan for faculty (30 days window)
('TXN-2024-1008', 'MEM-2024-004', 'BK-1008', '2024-09-20', '2024-10-20', NULL, 0.00, 'ISSUED', 'admin', 'Faculty special borrowing period');

-- 5. Insert Fines
INSERT INTO fines (fine_id, transaction_id, member_id, amount, days_late, status, created_at, paid_at, payment_mode) VALUES
('FN-2024-001', 'TXN-2024-1002', 'MEM-2024-002', 20.00, 4, 'PAID', '2024-08-23 11:30:00', '2024-08-23 11:32:00', 'UPI'),
('FN-2024-002', 'TXN-2024-1006', 'MEM-2024-005', 65.00, 13, 'UNPAID', '2024-09-25 09:00:00', NULL, NULL),
('FN-2024-003', 'TXN-2024-1007', 'MEM-2024-006', 55.00, 11, 'UNPAID', '2024-09-27 09:00:00', NULL, NULL);

-- 6. Insert Reservations (Queue for out-of-stock / high-demand titles)
INSERT INTO reservations (reservation_id, member_id, book_id, reservation_date, queue_position, status, expiry_date) VALUES
('RES-2024-001', 'MEM-2024-001', 'BK-1005', '2024-09-25 14:10:00', 1, 'PENDING', '2024-10-25'),
('RES-2024-002', 'MEM-2024-003', 'BK-1005', '2024-09-26 10:15:00', 2, 'PENDING', '2024-10-26'),
('RES-2024-003', 'MEM-2024-002', 'BK-1010', '2024-09-28 16:45:00', 1, 'PENDING', '2024-10-28');

-- 7. Insert Notifications
INSERT INTO notifications (user_id, title, message, type, is_read, created_at) VALUES
(1, 'System Ready', 'Digital Library Management System initialized successfully.', 'SUCCESS', TRUE, '2024-08-01 09:00:00'),
(1, 'Overdue Alert', '2 members currently have overdue book transactions.', 'WARNING', FALSE, NOW()),
(3, 'Welcome to DLMS', 'Welcome Siddhartha! Your student library account is active.', 'INFO', TRUE, '2024-08-01 10:00:00'),
(4, 'Book Issued', 'You have borrowed CLRS (BK-1001). Due date is Oct 16, 2024.', 'SUCCESS', FALSE, NOW()),
(6, 'Overdue Notice', 'Database System Concepts (BK-1005) is overdue. Please return to avoid further fine.', 'DANGER', FALSE, NOW());
