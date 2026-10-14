/**
 * DIGITAL LIBRARY MANAGEMENT SYSTEM (DLMS) - FULL-STACK APPLICATION SERVER
 * B.Tech PBL Project | Team: Md. Amanuddin & Jashwanth Chowdary
 * Runs standalone on port 8080 with zero external npm dependencies.
 * Implements complete backend business logic, session auth, database state,
 * and serves the modern academic frontend with Chart.js analytics.
 */

const http = require('http');
const fs = require('fs');
const path = require('path');
const url = require('url');
const querystring = require('querystring');
const crypto = require('crypto');

const PORT = process.env.PORT || 8080;
const WEBAPP_DIR = path.join(__dirname, 'src', 'main', 'webapp');

// --------------------------------------------------------------------
// IN-MEMORY DATABASE INITIALIZED DIRECTLY FROM database.sql SCHEMA
// --------------------------------------------------------------------
const db = {
    users: [
        { id: 1, username: 'admin', email: 'admin@library.edu', password: 'admin123', role: 'ADMIN', memberId: null, status: 'ACTIVE' },
        { id: 2, username: 'librarian', email: 'librarian@library.edu', password: 'admin123', role: 'LIBRARIAN', memberId: null, status: 'ACTIVE' },
        { id: 3, username: 'aman', email: 'amanuddin@library.edu', password: 'student123', role: 'STUDENT', memberId: 'MEM-2024-001', status: 'ACTIVE' },
        { id: 4, username: 'jashwanth', email: 'jashwanth@library.edu', password: 'student123', role: 'STUDENT', memberId: 'MEM-2024-002', status: 'ACTIVE' },
        { id: 5, username: 'student', email: 'student@library.edu', password: 'student123', role: 'STUDENT', memberId: 'MEM-2024-003', status: 'ACTIVE' },
        { id: 6, username: 'drrajesh', email: 'rajesh.sharma@library.edu', password: 'student123', role: 'FACULTY', memberId: 'MEM-2024-004', status: 'ACTIVE' }
    ],
    members: [
        { id: 1, memberId: 'MEM-2024-001', name: 'Md. Amanuddin', email: 'amanuddin@library.edu', phone: '+91 98765 43211', department: 'Computer Science & Engineering', year: '3rd Year', memberType: 'STUDENT', maxBorrowLimit: 4, registrationDate: '2024-01-10', status: 'ACTIVE' },
        { id: 2, memberId: 'MEM-2024-002', name: 'Jashwanth Chowdary', email: 'jashwanth@library.edu', phone: '+91 98765 43212', department: 'Computer Science & Engineering', year: '3rd Year', memberType: 'STUDENT', maxBorrowLimit: 4, registrationDate: '2024-01-12', status: 'ACTIVE' },
        { id: 4, memberId: 'MEM-2024-004', name: 'Dr. Rajesh Sharma', email: 'rajesh.sharma@library.edu', phone: '+91 98765 11223', department: 'Information Technology', year: 'Associate Professor', memberType: 'FACULTY', maxBorrowLimit: 8, registrationDate: '2023-08-01', status: 'ACTIVE' },
        { id: 5, memberId: 'MEM-2024-005', name: 'Priya Nair', email: 'priya.nair@library.edu', phone: '+91 98765 22334', department: 'Electronics & Communication', year: '2nd Year', memberType: 'STUDENT', maxBorrowLimit: 4, registrationDate: '2024-02-15', status: 'ACTIVE' },
        { id: 6, memberId: 'MEM-2024-006', name: 'Rohan Verma', email: 'rohan.verma@library.edu', phone: '+91 98765 33445', department: 'Mechanical Engineering', year: '4th Year', memberType: 'STUDENT', maxBorrowLimit: 4, registrationDate: '2023-09-05', status: 'ACTIVE' },
        { id: 7, memberId: 'MEM-2024-007', name: 'Prof. Ananya Sen', email: 'ananya.sen@library.edu', phone: '+91 98765 44556', department: 'Computer Science & Engineering', year: 'Professor & HOD', memberType: 'FACULTY', maxBorrowLimit: 8, registrationDate: '2023-07-20', status: 'ACTIVE' },
        { id: 8, memberId: 'MEM-2024-008', name: 'Kavita Reddy', email: 'kavita.reddy@library.edu', phone: '+91 98765 55667', department: 'Data Science & AI', year: '1st Year', memberType: 'STUDENT', maxBorrowLimit: 4, registrationDate: '2024-08-20', status: 'ACTIVE' },
        { id: 9, memberId: 'MEM-2024-009', name: 'Vikram Aditya', email: 'vikram.aditya@library.edu', phone: '+91 98765 66778', department: 'Civil Engineering', year: '3rd Year', memberType: 'STUDENT', maxBorrowLimit: 4, registrationDate: '2024-03-01', status: 'ACTIVE' }
    ],
    books: [
        { id: 1, bookId: 'BK-1001', isbn: '978-0262033848', title: 'Introduction to Algorithms (CLRS)', author: 'Thomas H. Cormen, Charles E. Leiserson', category: 'Computer Science', publisher: 'MIT Press', publicationYear: 2022, language: 'English', description: 'The leading textbook on computer algorithms, covering dynamic programming, greedy algorithms, graph theory, and advanced data structures.', shelfNumber: 'CS-A1-04', quantity: 5, availableCopies: 3, status: 'AVAILABLE', coverUrl: 'https://images.unsplash.com/photo-1532012164546-f432f2e3777a?w=400&q=80' },
        { id: 2, bookId: 'BK-1002', isbn: '978-0131103627', title: 'The C Programming Language', author: 'Brian W. Kernighan, Dennis M. Ritchie', category: 'Programming', publisher: 'Prentice Hall', publicationYear: 2018, language: 'English', description: 'The definitive guide to ANSI standard C programming by the creators of the language.', shelfNumber: 'CS-A2-12', quantity: 6, availableCopies: 4, status: 'AVAILABLE', coverUrl: 'https://images.unsplash.com/photo-1544716278-ca5e3f4abd8c?w=400&q=80' },
        { id: 3, bookId: 'BK-1003', isbn: '978-0134685991', title: 'Effective Java (3rd Edition)', author: 'Joshua Bloch', category: 'Programming', publisher: 'Addison-Wesley', publicationYear: 2018, language: 'English', description: 'Essential best practices for the Java platform covering generics, lambdas, streams, and concurrency.', shelfNumber: 'CS-B1-08', quantity: 4, availableCopies: 2, status: 'AVAILABLE', coverUrl: 'https://images.unsplash.com/photo-1512820790803-83ca734da794?w=400&q=80' },
        { id: 4, bookId: 'BK-1004', isbn: '978-0132350884', title: 'Clean Code: A Handbook of Agile Software', author: 'Robert C. Martin (Uncle Bob)', category: 'Software Engineering', publisher: 'Prentice Hall', publicationYear: 2008, language: 'English', description: 'A handbook of agile software craftsmanship for writing readable, maintainable, and elegant code.', shelfNumber: 'CS-B2-03', quantity: 4, availableCopies: 1, status: 'AVAILABLE', coverUrl: 'https://images.unsplash.com/photo-1589829085413-56de8ae18c73?w=400&q=80' },
        { id: 5, bookId: 'BK-1005', isbn: '978-0078022159', title: 'Database System Concepts (7th Edition)', author: 'Abraham Silberschatz, Henry F. Korth', category: 'Database Systems', publisher: 'McGraw-Hill', publicationYear: 2019, language: 'English', description: 'Comprehensive coverage of relational models, SQL, indexing, transaction processing, and concurrency control.', shelfNumber: 'DB-A1-01', quantity: 5, availableCopies: 0, status: 'OUT_OF_STOCK', coverUrl: 'https://images.unsplash.com/photo-1507842229451-7f01be7fe8e6?w=400&q=80' },
        { id: 6, bookId: 'BK-1006', isbn: '978-0133594140', title: 'Operating System Concepts (10th Edition)', author: 'Abraham Silberschatz, Peter B. Galvin', category: 'Operating Systems', publisher: 'Wiley', publicationYear: 2018, language: 'English', description: 'Foundational concepts of threads, CPU scheduling, synchronization, memory management, and virtualization.', shelfNumber: 'OS-C1-09', quantity: 4, availableCopies: 2, status: 'AVAILABLE', coverUrl: 'https://images.unsplash.com/photo-1497633762265-9d179a990aa6?w=400&q=80' },
        { id: 7, bookId: 'BK-1007', isbn: '978-0132126953', title: 'Computer Networks (5th Edition)', author: 'Andrew S. Tanenbaum, David J. Wetherall', category: 'Networking', publisher: 'Pearson', publicationYear: 2013, language: 'English', description: 'In-depth explanation of physical, data link, network, transport, and application layers including IPv6 and wireless.', shelfNumber: 'NW-D2-14', quantity: 5, availableCopies: 3, status: 'AVAILABLE', coverUrl: 'https://images.unsplash.com/photo-1524995997946-a1c2e315a42f?w=400&q=80' },
        { id: 8, bookId: 'BK-1008', isbn: '978-0262035613', title: 'Deep Learning (Adaptive Computation & ML)', author: 'Ian Goodfellow, Yoshua Bengio, Aaron Courville', category: 'Artificial Intelligence', publisher: 'MIT Press', publicationYear: 2016, language: 'English', description: 'Mathematical and conceptual background of deep neural networks, CNNs, RNNs, and generative modeling.', shelfNumber: 'AI-A1-05', quantity: 3, availableCopies: 1, status: 'AVAILABLE', coverUrl: 'https://images.unsplash.com/photo-1516979187457-637abb4f9353?w=400&q=80' },
        { id: 9, bookId: 'BK-1009', isbn: '978-1449369415', title: 'Designing Data-Intensive Applications', author: 'Martin Kleppmann', category: 'Software Architecture', publisher: 'O\'Reilly Media', publicationYear: 2017, language: 'English', description: 'The big ideas behind reliable, scalable, and maintainable storage engines, stream processing, and distributed consensus.', shelfNumber: 'SA-B3-11', quantity: 4, availableCopies: 2, status: 'AVAILABLE', coverUrl: 'https://images.unsplash.com/photo-1457369804613-52c61a468e7d?w=400&q=80' },
        { id: 10, bookId: 'BK-1010', isbn: '978-0131495050', title: 'Artificial Intelligence: A Modern Approach', author: 'Stuart Russell, Peter Norvig', category: 'Artificial Intelligence', publisher: 'Pearson', publicationYear: 2020, language: 'English', description: 'The standard worldwide authority on intelligent agents, heuristic search, logic inference, and probabilistic reasoning.', shelfNumber: 'AI-A2-07', quantity: 4, availableCopies: 0, status: 'OUT_OF_STOCK', coverUrl: 'https://images.unsplash.com/photo-1495446815901-a7297e633e8d?w=400&q=80' },
        { id: 11, bookId: 'BK-1011', isbn: '978-0134444321', title: 'Software Engineering: A Practitioner\'s Approach', author: 'Roger S. Pressman, Bruce R. Maxim', category: 'Software Engineering', publisher: 'McGraw-Hill', publicationYear: 2019, language: 'English', description: 'Framework for agile workflows, requirements engineering, architectural design, software testing, and DevOps metrics.', shelfNumber: 'SE-A3-02', quantity: 6, availableCopies: 5, status: 'AVAILABLE', coverUrl: 'https://images.unsplash.com/photo-1481627834876-b7833e8f5570?w=400&q=80' },
        { id: 12, bookId: 'BK-1012', isbn: '978-0070147331', title: 'Discrete Mathematics and Its Applications', author: 'Kenneth H. Rosen', category: 'Mathematics', publisher: 'McGraw-Hill', publicationYear: 2018, language: 'English', description: 'Combinatorics, propositional logic, graph theory, set theory, and recurrence relations for computer scientists.', shelfNumber: 'MA-C2-01', quantity: 5, availableCopies: 4, status: 'AVAILABLE', coverUrl: 'https://images.unsplash.com/photo-1512820790803-83ca734da794?w=400&q=80' },
        { id: 13, bookId: 'BK-1013', isbn: '978-1491957660', title: 'Python Crash Course (2nd Edition)', author: 'Eric Matthes', category: 'Programming', publisher: 'No Starch Press', publicationYear: 2019, language: 'English', description: 'A hands-on, project-based introduction to programming in Python, data visualization, and web applications.', shelfNumber: 'CS-D1-15', quantity: 6, availableCopies: 4, status: 'AVAILABLE', coverUrl: 'https://images.unsplash.com/photo-1544716278-ca5e3f4abd8c?w=400&q=80' },
        { id: 14, bookId: 'BK-1014', isbn: '978-0201633610', title: 'Design Patterns: Reusable Object-Oriented Software', author: 'Erich Gamma, Richard Helm, Ralph Johnson', category: 'Software Architecture', publisher: 'Addison-Wesley', publicationYear: 1994, language: 'English', description: 'The classic Gang of Four (GoF) catalog of 23 fundamental software engineering design patterns.', shelfNumber: 'CS-B3-06', quantity: 4, availableCopies: 3, status: 'AVAILABLE', coverUrl: 'https://images.unsplash.com/photo-1532012164546-f432f2e3777a?w=400&q=80' },
        { id: 15, bookId: 'BK-1015', isbn: '978-0134092669', title: 'Computer Organization and Architecture', author: 'William Stallings', category: 'Computer Science', publisher: 'Pearson', publicationYear: 2018, language: 'English', description: 'Structure and function of computers, pipelining, cache memory, RISC architectures, and superscalar processors.', shelfNumber: 'CS-E1-04', quantity: 5, availableCopies: 4, status: 'AVAILABLE', coverUrl: 'https://images.unsplash.com/photo-1589829085413-56de8ae18c73?w=400&q=80' },
        { id: 16, bookId: 'BK-1016', isbn: '978-0262033855', title: 'Compilers: Principles, Techniques, & Tools', author: 'Alfred V. Aho, Monica S. Lam, Ravi Sethi', category: 'Computer Science', publisher: 'Addison-Wesley', publicationYear: 2006, language: 'English', description: 'Lexical analysis, syntax-directed translation, code optimization, and code generation for compilers.', shelfNumber: 'CS-E2-10', quantity: 3, availableCopies: 2, status: 'AVAILABLE', coverUrl: 'https://images.unsplash.com/photo-1507842229451-7f01be7fe8e6?w=400&q=80' },
        { id: 17, bookId: 'BK-1017', isbn: '978-0132350891', title: 'Head First Design Patterns', author: 'Eric Freeman, Elisabeth Robson', category: 'Software Architecture', publisher: 'O\'Reilly Media', publicationYear: 2020, language: 'English', description: 'A visually rich, brain-friendly guide to design patterns, OOP principles, and loose coupling.', shelfNumber: 'CS-B4-02', quantity: 5, availableCopies: 3, status: 'AVAILABLE', coverUrl: 'https://images.unsplash.com/photo-1497633762265-9d179a990aa6?w=400&q=80' },
        { id: 18, bookId: 'BK-1018', isbn: '978-1449331818', title: 'Learning JavaScript Design Patterns', author: 'Addy Osmani', category: 'Web Development', publisher: 'O\'Reilly Media', publicationYear: 2017, language: 'English', description: 'Explore classical and modern design patterns to write beautiful, structured, and maintainable JavaScript code.', shelfNumber: 'WB-A1-08', quantity: 4, availableCopies: 3, status: 'AVAILABLE', coverUrl: 'https://images.unsplash.com/photo-1524995997946-a1c2e315a42f?w=400&q=80' }
    ],
    transactions: [
        { id: 1, transactionId: 'TXN-2024-1001', memberId: 'MEM-2024-001', bookId: 'BK-1002', issueDate: '2024-08-01', dueDate: '2024-08-15', returnDate: '2024-08-14', fine: 0.00, status: 'RETURNED', issuedBy: 'admin', remarks: 'Returned in good condition' },
        { id: 2, transactionId: 'TXN-2024-1002', memberId: 'MEM-2024-002', bookId: 'BK-1003', issueDate: '2024-08-05', dueDate: '2024-08-19', returnDate: '2024-08-23', fine: 20.00, status: 'RETURNED', issuedBy: 'admin', remarks: 'Returned 4 days late, fine paid' },
        { id: 3, transactionId: 'TXN-2024-1003', memberId: 'MEM-2024-001', bookId: 'BK-1004', issueDate: '2024-10-01', dueDate: '2024-10-15', returnDate: null, fine: 0.00, status: 'ISSUED', issuedBy: 'admin', remarks: 'Active loan' },
        { id: 4, transactionId: 'TXN-2024-1004', memberId: 'MEM-2024-002', bookId: 'BK-1001', issueDate: '2024-10-02', dueDate: '2024-10-16', returnDate: null, fine: 0.00, status: 'ISSUED', issuedBy: 'admin', remarks: 'Active loan' },
        { id: 5, transactionId: 'TXN-2024-1005', memberId: 'MEM-2024-003', bookId: 'BK-1006', issueDate: '2024-09-28', dueDate: '2024-10-12', returnDate: null, fine: 0.00, status: 'ISSUED', issuedBy: 'admin', remarks: 'Active loan' },
        { id: 6, transactionId: 'TXN-2024-1006', memberId: 'MEM-2024-005', bookId: 'BK-1005', issueDate: '2024-09-10', dueDate: '2024-09-24', returnDate: null, fine: 65.00, status: 'OVERDUE', issuedBy: 'admin', remarks: 'Overdue by 13 days' },
        { id: 7, transactionId: 'TXN-2024-1007', memberId: 'MEM-2024-006', bookId: 'BK-1010', issueDate: '2024-09-12', dueDate: '2024-09-26', returnDate: null, fine: 55.00, status: 'OVERDUE', issuedBy: 'admin', remarks: 'Overdue by 11 days' },
        { id: 8, transactionId: 'TXN-2024-1008', memberId: 'MEM-2024-004', bookId: 'BK-1008', issueDate: '2024-09-20', dueDate: '2024-10-20', returnDate: null, fine: 0.00, status: 'ISSUED', issuedBy: 'admin', remarks: 'Faculty special borrowing period' }
    ],
    fines: [
        { id: 1, fineId: 'FN-2024-001', transactionId: 'TXN-2024-1002', memberId: 'MEM-2024-002', amount: 20.00, daysLate: 4, status: 'PAID', paidAt: '2024-08-23 11:32:00', paymentMode: 'UPI' },
        { id: 2, fineId: 'FN-2024-002', transactionId: 'TXN-2024-1006', memberId: 'MEM-2024-005', amount: 65.00, daysLate: 13, status: 'UNPAID', paidAt: null, paymentMode: null },
        { id: 3, fineId: 'FN-2024-003', transactionId: 'TXN-2024-1007', memberId: 'MEM-2024-006', amount: 55.00, daysLate: 11, status: 'UNPAID', paidAt: null, paymentMode: null }
    ],
    reservations: [
        { id: 1, reservationId: 'RES-2024-001', memberId: 'MEM-2024-001', bookId: 'BK-1005', reservationDate: '2024-09-25 14:10:00', queuePosition: 1, status: 'PENDING', expiryDate: '2024-10-25' },
        { id: 2, reservationId: 'RES-2024-002', memberId: 'MEM-2024-003', bookId: 'BK-1005', reservationDate: '2024-09-26 10:15:00', queuePosition: 2, status: 'PENDING', expiryDate: '2024-10-26' },
        { id: 3, reservationId: 'RES-2024-003', memberId: 'MEM-2024-002', bookId: 'BK-1010', reservationDate: '2024-09-28 16:45:00', queuePosition: 1, status: 'PENDING', expiryDate: '2024-10-28' }
    ]
};

// Simple active sessions map
const sessions = new Map();

// Helper to get joined attributes for transactions
function enrichTransaction(t) {
    const book = db.books.find(b => b.bookId === t.bookId);
    const member = db.members.find(m => m.memberId === t.memberId);
    const isOverdue = t.status !== 'RETURNED' && new Date(t.dueDate) < new Date();
    const daysLate = Math.max(0, Math.floor((new Date() - new Date(t.dueDate)) / (1000 * 60 * 60 * 24)));
    return {
        ...t,
        bookTitle: book ? book.title : t.bookId,
        bookCoverUrl: book ? book.coverUrl : '',
        memberName: member ? member.name : t.memberId,
        isOverdue: isOverdue,
        daysOverdue: daysLate
    };
}

function enrichFine(f) {
    const member = db.members.find(m => m.memberId === f.memberId);
    const tx = db.transactions.find(t => t.transactionId === f.transactionId);
    const book = tx ? db.books.find(b => b.bookId === tx.bookId) : null;
    return {
        ...f,
        memberName: member ? member.name : f.memberId,
        bookTitle: book ? book.title : 'Overdue Loan'
    };
}

function enrichReservation(r) {
    const member = db.members.find(m => m.memberId === r.memberId);
    const book = db.books.find(b => b.bookId === r.bookId);
    return {
        ...r,
        memberName: member ? member.name : r.memberId,
        bookTitle: book ? book.title : r.bookId
    };
}

// --------------------------------------------------------------------
// STATS CALCULATION (FOR CHARTS & DASHBOARD)
// --------------------------------------------------------------------
function getSummaryStats() {
    const totalBooks = db.books.reduce((acc, b) => acc + b.quantity, 0);
    const availableBooks = db.books.reduce((acc, b) => acc + b.availableCopies, 0);
    const issuedBooks = db.transactions.filter(t => t.status === 'ISSUED' || t.status === 'OVERDUE').length;
    const totalMembers = db.members.filter(m => m.status === 'ACTIVE').length;
    const overdueBooks = db.transactions.filter(t => t.status === 'OVERDUE' || (t.status === 'ISSUED' && new Date(t.dueDate) < new Date())).length;
    const unpaidFines = db.fines.filter(f => f.status === 'UNPAID').reduce((acc, f) => acc + f.amount, 0);
    const paidFines = db.fines.filter(f => f.status === 'PAID').reduce((acc, f) => acc + f.amount, 0);
    const pendingReservations = db.reservations.filter(r => r.status === 'PENDING').length;
    const utilizationRate = totalBooks > 0 ? Math.round(((totalBooks - availableBooks) * 100.0) / totalBooks) : 0;
    const availableRatio = totalBooks > 0 ? Math.round((availableBooks * 100.0) / totalBooks) : 0;

    return {
        totalBooks,
        availableBooks,
        issuedBooks,
        totalMembers,
        overdueBooks,
        unpaidFines,
        paidFines,
        pendingReservations,
        utilizationRate,
        availableRatio
    };
}

function getCategoryDistribution() {
    const map = {};
    db.books.forEach(b => {
        map[b.category] = (map[b.category] || 0) + 1;
    });
    return map;
}

function getMonthlyTrends() {
    return {
        'May': 14,
        'Jun': 22,
        'Jul': 35,
        'Aug': 48,
        'Sep': 62,
        'Oct': 79
    };
}

// --------------------------------------------------------------------
// COOKIE & SESSION MANAGEMENT
// --------------------------------------------------------------------
function getSessionUser(req) {
    const cookies = req.headers.cookie;
    if (!cookies) return null;
    const match = cookies.match(/DLMS_SESSION=([a-zA-Z0-9_-]+)/);
    if (match && sessions.has(match[1])) {
        return sessions.get(match[1]);
    }
    return null;
}

function setSessionUser(res, user) {
    const sessionId = crypto.randomBytes(16).toString('hex');
    sessions.set(sessionId, user);
    res.setHeader('Set-Cookie', `DLMS_SESSION=${sessionId}; Path=/; HttpOnly; Max-Age=86400`);
}

function clearSession(res) {
    res.setHeader('Set-Cookie', 'DLMS_SESSION=; Path=/; Expires=Thu, 01 Jan 1970 00:00:00 GMT');
}

// --------------------------------------------------------------------
// TEMPLATE ENGINE / HTML VIEW RENDERER
// --------------------------------------------------------------------
function renderPage(viewPath, context = {}) {
    const fullPath = path.join(WEBAPP_DIR, viewPath);
    if (!fs.existsSync(fullPath)) {
        return `<h1>View Not Found: ${viewPath}</h1>`;
    }
    let html = fs.readFileSync(fullPath, 'utf8');

    // Recursively replace <jsp:include page="..." />
    let maxDepth = 5;
    const includeRegex = /<jsp:include\s+page=["']([^"']+)["']\s*\/>/g;
    while (maxDepth > 0 && includeRegex.test(html)) {
        html = html.replace(includeRegex, (match, incPath) => {
            const cleanInc = incPath.startsWith('/') ? incPath.slice(1) : incPath;
            const incFullPath = path.join(WEBAPP_DIR, cleanInc);
            if (fs.existsSync(incFullPath)) {
                return fs.readFileSync(incFullPath, 'utf8');
            }
            return '';
        });
        maxDepth--;
    }

    const b = context.book || {};
    const m = context.member || {};
    const u = context.user || null;
    const stats = context.stats || {};
    const summary = context.summary || {};
    const isAdmin = u && (u.role === 'ADMIN' || u.role === 'LIBRARIAN');

    // Handle session user menu in navbar
    html = html.replace(/<c:choose>\s*<c:when\s+test=["']\$\{sessionScope\.currentUser\.admin\}["']>([\s\S]*?)<\/c:when>\s*<c:otherwise>([\s\S]*?)<\/c:otherwise>\s*<\/c:choose>/g, (match, adminPart, studentPart) => {
        return isAdmin ? adminPart : studentPart;
    });

    // Handle book availability choose block
    if (context.book) {
        const isAvailable = b.availableCopies > 0;
        html = html.replace(/<c:choose>\s*<c:when\s+test=["']\$\{book\.availableCopies\s*>\s*0\}["']>([\s\S]*?)<\/c:when>\s*<c:otherwise>([\s\S]*?)<\/c:otherwise>\s*<\/c:choose>/g, (match, whenPart, otherPart) => {
            return isAvailable ? whenPart : otherPart;
        });
    }

    // Handle isEdit conditions
    if (context.isEdit) {
        html = html.replace(/<c:if\s+test=["']\$\{isEdit\}["']>([\s\S]*?)<\/c:if>/g, '$1');
        html = html.replace(/<c:if\s+test=["']\$\{!isEdit\}["']>([\s\S]*?)<\/c:if>/g, '');
    } else {
        html = html.replace(/<c:if\s+test=["']\$\{isEdit\}["']>([\s\S]*?)<\/c:if>/g, '');
        html = html.replace(/<c:if\s+test=["']\$\{!isEdit\}["']>([\s\S]*?)<\/c:if>/g, '$1');
    }

    // Flash message banners
    if (context.success) {
        html = html.replace(/<c:if\s+test=["']\$\{not\s+empty\s+param\.success\}["']>([\s\S]*?)<\/c:if>/g, '$1');
        html = html.replace(/\$\{param\.success\}/g, context.success);
    } else {
        html = html.replace(/<c:if\s+test=["']\$\{not\s+empty\s+param\.success\}["']>([\s\S]*?)<\/c:if>/g, '');
    }

    if (context.error) {
        html = html.replace(/<c:if\s+test=["']\$\{not\s+empty\s+(?:param\.error|errorMessage)\}["']>([\s\S]*?)<\/c:if>/g, '$1');
        html = html.replace(/\$\{(?:param\.error|errorMessage)\}/g, context.error);
    } else {
        html = html.replace(/<c:if\s+test=["']\$\{not\s+empty\s+(?:param\.error|errorMessage)\}["']>([\s\S]*?)<\/c:if>/g, '');
    }

    if (context.msg) {
        html = html.replace(/<c:if\s+test=["']\$\{not\s+empty\s+param\.msg\}["']>([\s\S]*?)<\/c:if>/g, '$1');
        html = html.replace(/\$\{param\.msg\}/g, context.msg);
    } else {
        html = html.replace(/<c:if\s+test=["']\$\{not\s+empty\s+param\.msg\}["']>([\s\S]*?)<\/c:if>/g, '');
    }

    // Active sidebar class handler (must execute before stripping remaining ${...})
    const activePage = context.activePage || '';
    html = html.replace(/\$\{activePage\s*==\s*['"]([^'"]+)['"]\s*\?\s*['"]active['"]\s*:\s*['"]['"]\}/g, (m, p) => (p === activePage ? 'active' : ''));

    // Replace contextual expressions
    const replacements = {
        '${pageContext.request.contextPath}': '',
        '${sessionScope.currentUser.admin ? pageContext.request.contextPath.concat(\'/admin/books\') : pageContext.request.contextPath.concat(\'/student/browse\')}': isAdmin ? '/admin/books' : '/student/browse',
        '${sessionScope.currentUser != null ? sessionScope.currentUser.username.substring(0, 1).toUpperCase() : "U"}': u ? u.username[0].toUpperCase() : 'U',
        '${sessionScope.currentUser != null ? sessionScope.currentUser.username : "Guest"}': u ? u.username : 'Guest',
        '${sessionScope.currentUser != null ? sessionScope.currentUser.role : "Patron"}': u ? u.role : 'Patron',
        '${sessionScope.currentUser.email}': u ? u.email : '',
        '${sessionScope.currentUser.username}': u ? u.username : 'Guest',

        // Stats
        '${stats.totalBooks != null ? stats.totalBooks : 0}': stats.totalBooks !== undefined ? stats.totalBooks : 0,
        '${stats.totalBooks}': stats.totalBooks !== undefined ? stats.totalBooks : 0,
        '${stats.availableBooks != null ? stats.availableBooks : 0}': stats.availableBooks !== undefined ? stats.availableBooks : 0,
        '${stats.availableBooks}': stats.availableBooks !== undefined ? stats.availableBooks : 0,
        '${stats.issuedBooks != null ? stats.issuedBooks : 0}': stats.issuedBooks !== undefined ? stats.issuedBooks : 0,
        '${stats.issuedBooks}': stats.issuedBooks !== undefined ? stats.issuedBooks : 0,
        '${stats.totalMembers != null ? stats.totalMembers : 0}': stats.totalMembers !== undefined ? stats.totalMembers : 0,
        '${stats.totalMembers}': stats.totalMembers !== undefined ? stats.totalMembers : 0,
        '${stats.overdueBooks != null ? stats.overdueBooks : 0}': stats.overdueBooks !== undefined ? stats.overdueBooks : 0,
        '${stats.overdueBooks}': stats.overdueBooks !== undefined ? stats.overdueBooks : 0,
        '${stats.unpaidFines != null ? stats.unpaidFines : 0}': stats.unpaidFines !== undefined ? stats.unpaidFines : '0.00',
        '${stats.unpaidFines}': stats.unpaidFines !== undefined ? stats.unpaidFines : '0.00',
        '${stats.paidFines}': stats.paidFines !== undefined ? stats.paidFines : '0.00',

        // Summary
        '${summary.totalBooks}': summary.totalBooks !== undefined ? summary.totalBooks : 0,
        '${summary.availableBooks}': summary.availableBooks !== undefined ? summary.availableBooks : 0,
        '${summary.issuedBooks}': summary.issuedBooks !== undefined ? summary.issuedBooks : 0,
        '${summary.totalMembers}': summary.totalMembers !== undefined ? summary.totalMembers : 0,
        '${summary.overdueBooks}': summary.overdueBooks !== undefined ? summary.overdueBooks : 0,
        '${summary.paidFines}': summary.paidFines !== undefined ? summary.paidFines : '0.00',
        '${summary.unpaidFines}': summary.unpaidFines !== undefined ? summary.unpaidFines : '0.00',
        '${summary.pendingReservations}': summary.pendingReservations !== undefined ? summary.pendingReservations : 0,
        '${summary.utilizationRate != null ? summary.utilizationRate : 0}': summary.utilizationRate !== undefined ? summary.utilizationRate : 0,
        '${summary.availableRatio != null ? summary.availableRatio : 0}': summary.availableRatio !== undefined ? summary.availableRatio : 0,
        '${summary.utilizationRate}': summary.utilizationRate !== undefined ? summary.utilizationRate : 0,
        '${summary.availableRatio}': summary.availableRatio !== undefined ? summary.availableRatio : 0,

        // Student Portal
        '${member != null ? member.roleDescription : \'Patron\'}': m.roleDescription || 'Student Patron',
        '${member != null ? member.roleDescription : \'Library Patron\'}': m.roleDescription || 'Student Patron',
        '${member != null ? member.name : sessionScope.currentUser.username}': m.name || (u ? u.username : 'Student'),
        '${member != null ? member.department : "Engineering"}': m.department || 'Engineering',
        '${member != null ? member.department : "N/A"}': m.department || 'Engineering',
        '${member != null ? member.memberId : "N/A"}': m.memberId || 'N/A',
        '${member != null ? member.memberId : \'\'}': m.memberId || '',
        '${member != null ? member.name : \'\'}': m.name || '',
        '${member != null ? member.email : sessionScope.currentUser.email}': m.email || (u ? u.email : ''),
        '${member != null ? member.email : \'\'}': m.email || '',
        '${member != null ? member.phone : "N/A"}': m.phone || 'N/A',
        '${member != null ? member.phone : \'\'}': m.phone || '',
        '${member != null ? member.department : \'\'}': m.department || '',
        '${member != null ? member.maxBorrowLimit : 4}': m.maxBorrowLimit || 4,
        '${member != null ? member.allowedBorrowDays : 14}': m.allowedBorrowDays || 14,
        '${member != null ? member.name.substring(0, 1) : "P"}': m.name ? m.name[0].toUpperCase() : 'P',
        '${member != null ? (member.memberType == \'FACULTY\' ? member.roleDescription : \'3rd Year\') : \'1st Year\'}': m.year || '3rd Year',
        '${member.memberType == \'FACULTY\' ? \'selected\' : \'\'}': m.memberType === 'FACULTY' ? 'selected' : '',
        '${member.memberType == \'STUDENT\' ? \'selected\' : \'\'}': m.memberType === 'STUDENT' ? 'selected' : '',
        '${member.status == \'ACTIVE\' ? \'selected\' : \'\'}': (m.status || 'ACTIVE') === 'ACTIVE' ? 'selected' : '',
        '${activeLoans != null ? activeLoans.size() : 0}': context.activeLoans ? context.activeLoans.length : 0,
        '${overdueCount > 0 ? \'text-danger\' : \'text-success\'}': (context.overdueCount || 0) > 0 ? 'text-danger' : 'text-success',
        '${overdueCount}': context.overdueCount || 0,
        '${overdueCount > 0 ? "Immediate return required" : "No overdue books"}': (context.overdueCount || 0) > 0 ? 'Immediate return required' : 'No overdue books',
        '${unpaidFines != null ? unpaidFines : \'0.00\'}': context.unpaidFines !== undefined ? context.unpaidFines : '0.00',
        '${reservations != null ? reservations.size() : 0}': context.reservations ? context.reservations.length : 0,

        // Book details & Form
        '${book.id}': b.id || '',
        '${book.bookId}': b.bookId || '',
        '${book.isbn}': b.isbn || '',
        '${book.title}': b.title || '',
        '${book.author}': b.author || '',
        '${book.category}': b.category || '',
        '${book.publisher}': b.publisher || '',
        '${book.publicationYear}': b.publicationYear || 2024,
        '${book.language}': b.language || 'English',
        '${book.shelfNumber}': b.shelfNumber || '',
        '${book.quantity}': b.quantity || 1,
        '${book.availableCopies}': b.availableCopies !== undefined ? b.availableCopies : 1,
        '${book.status}': b.status || 'AVAILABLE',
        '${book.coverUrl}': b.coverUrl || '',
        '${book.description}': b.description || '',
        '${not empty book.description ? book.description : "No description provided for this catalog volume."}': b.description || 'No description provided for this catalog volume.',
        '${book != null ? book.bookId : \'\'}': b.bookId || '',
        '${book != null ? book.isbn : \'\'}': b.isbn || '',
        '${book != null ? book.category : \'\'}': b.category || '',
        '${book != null ? book.title : \'\'}': b.title || '',
        '${book != null ? book.author : \'\'}': b.author || '',
        '${book != null ? book.publisher : \'\'}': b.publisher || '',
        '${book != null ? book.publicationYear : 2023}': b.publicationYear || 2024,
        '${book != null ? book.language : \'English\'}': b.language || 'English',
        '${book != null ? book.shelfNumber : \'\'}': b.shelfNumber || '',
        '${book != null ? book.quantity : 1}': b.quantity !== undefined ? b.quantity : 1,
        '${book != null ? book.availableCopies : 1}': b.availableCopies !== undefined ? b.availableCopies : 1,
        '${book != null ? book.coverUrl : \'\'}': b.coverUrl || '',
        '${book != null ? book.description : \'\'}': b.description || '',

        // Form Edit Labels
        '${isEdit ? \'Edit Book\' : \'Add New Book\'}': context.isEdit ? 'Edit Book' : 'Add New Book',
        '${isEdit ? \'Edit Book Details\' : \'Register New Book in Catalog\'}': context.isEdit ? 'Edit Book Details' : 'Register New Book in Catalog',
        '${isEdit ? \'update\' : \'save\'}': context.isEdit ? 'update' : 'save',
        '${isEdit ? \'Save Changes\' : \'Add to Catalog\'}': context.isEdit ? 'Save Changes' : 'Add to Catalog',
        '${isEdit ? \'Edit Member\' : \'Register Member\'}': context.isEdit ? 'Edit Member' : 'Register Member',
        '${isEdit ? \'Edit Member Profile\' : \'Register New Library Member\'}': context.isEdit ? 'Edit Member Profile' : 'Register New Library Member',
        '${isEdit ? \'Update Member\' : \'Register Member\'}': context.isEdit ? 'Update Member' : 'Register Member',

        // General
        '${totalUnpaid != null ? totalUnpaid : \'0.00\'}': context.totalUnpaid != null ? context.totalUnpaid : '0.00',
        '${paramQuery}': context.query || '',
        '${paramStatus}': context.status || '',
        '${paramCategory}': context.category || '',
        '${currentPage}': context.page || 1,
        '${totalPages}': context.totalPages || 1,
        '${totalCount}': context.totalCount || 0
    };

    for (const [key, val] of Object.entries(replacements)) {
        html = html.split(key).join(val !== undefined && val !== null ? String(val) : '');
    }

    // Clean up JSTL and JSP directives gracefully so browser gets pure semantic HTML5
    html = html.replace(/<%@\s*page[^>]*%>/g, '');
    html = html.replace(/<%@\s*taglib[^>]*%>/g, '');
    html = html.replace(/<c:set[^>]*\/>/g, '');
    html = html.replace(/\$\{pageTitle[^}]*\}/g, 'Digital Library Management System - B.Tech PBL Project');

    // Clean any unhandled EL expressions and tags gracefully
    html = html.replace(/<c:if[^>]*>([\s\S]*?)<\/c:if>/g, '$1');
    html = html.replace(/\$\{[^}]+\}/g, '');

    return html;
}

// --------------------------------------------------------------------
// HTTP SERVER & REQUEST DISPATCHER
// --------------------------------------------------------------------
const server = http.createServer((req, res) => {
    const parsedUrl = url.parse(req.url, true);
    const pathname = parsedUrl.pathname;
    const query = parsedUrl.query;
    const currentUser = getSessionUser(req);

    // 1. Static Assets Delivery (.css, .js, images)
    if (pathname.startsWith('/assets/')) {
        const filePath = path.join(WEBAPP_DIR, pathname);
        if (fs.existsSync(filePath)) {
            const ext = path.extname(filePath).toLowerCase();
            const mimeTypes = {
                '.css': 'text/css',
                '.js': 'application/javascript',
                '.png': 'image/png',
                '.jpg': 'image/jpeg',
                '.svg': 'image/svg+xml'
            };
            res.writeHead(200, { 'Content-Type': mimeTypes[ext] || 'text/plain' });
            return fs.createReadStream(filePath).pipe(res);
        }
    }

    // 2. Public Homepage / Landing Page
    if (pathname === '/' || pathname === '/index.jsp') {
        const rendered = renderPage('index.jsp', { user: currentUser, activePage: 'home' });
        res.writeHead(200, { 'Content-Type': 'text/html; charset=utf-8' });
        return res.end(rendered);
    }

    // 3. Authentication: Login & Logout
    if (pathname === '/login') {
        if (req.method === 'POST') {
            let body = '';
            req.on('data', chunk => { body += chunk; });
            req.on('end', () => {
                const params = querystring.parse(body);
                const username = (params.username || '').trim();
                const password = (params.password || '').trim();

                const user = db.users.find(u => (u.username === username || u.email === username) && u.password === password && u.status === 'ACTIVE');
                if (user) {
                    setSessionUser(res, user);
                    if (user.role === 'ADMIN' || user.role === 'LIBRARIAN') {
                        res.writeHead(302, { 'Location': '/admin/dashboard' });
                    } else {
                        res.writeHead(302, { 'Location': '/student/dashboard' });
                    }
                    return res.end();
                } else {
                    res.writeHead(302, { 'Location': '/login?error=Invalid username or password' });
                    return res.end();
                }
            });
            return;
        }

        // GET /login
        const rendered = renderPage('login.jsp', { user: currentUser, query: query.role, error: query.error, msg: query.msg });
        res.writeHead(200, { 'Content-Type': 'text/html; charset=utf-8' });
        return res.end(rendered);
    }

    if (pathname === '/logout') {
        clearSession(res);
        res.writeHead(302, { 'Location': '/login?msg=You have been logged out securely.' });
        return res.end();
    }

    // 4. Chart.js Live JSON Endpoint
    if (pathname === '/admin/api/stats') {
        res.writeHead(200, { 'Content-Type': 'application/json' });
        return res.end(JSON.stringify({
            summary: getSummaryStats(),
            categories: getCategoryDistribution(),
            monthlyTrends: getMonthlyTrends()
        }));
    }

    // 5. Admin Dashboard
    if (pathname === '/admin/dashboard') {
        if (!currentUser || (currentUser.role !== 'ADMIN' && currentUser.role !== 'LIBRARIAN')) {
            res.writeHead(302, { 'Location': '/login?error=Please log in as Admin.' });
            return res.end();
        }

        const stats = getSummaryStats();
        let html = renderPage('admin/dashboard.jsp', { user: currentUser, stats, activePage: 'dashboard' });

        // Inject dynamic recent activities table
        const recentTxHtml = db.transactions.slice(-6).reverse().map(t => {
            const enriched = enrichTransaction(t);
            return `<tr>
                <td><span class="font-monospace fw-semibold text-primary">${enriched.transactionId}</span></td>
                <td><div class="fw-semibold">${enriched.memberName}</div><small class="text-muted font-monospace">${enriched.memberId}</small></td>
                <td><div class="d-flex align-items-center gap-2"><img src="${enriched.bookCoverUrl}" class="book-thumb"><div><div class="fw-medium text-truncate" style="max-width:240px;">${enriched.bookTitle}</div><small class="text-muted font-monospace">${enriched.bookId}</small></div></div></td>
                <td>${enriched.issueDate}</td>
                <td><span class="${enriched.isOverdue ? 'text-danger fw-bold' : ''}">${enriched.dueDate} ${enriched.isOverdue ? '<span class="badge badge-soft-danger ms-1">Overdue</span>' : ''}</span></td>
                <td><span class="badge ${enriched.status === 'RETURNED' ? 'badge-soft-success' : (enriched.isOverdue ? 'badge-soft-danger' : 'badge-soft-info')}">${enriched.status}</span></td>
                <td>${enriched.status !== 'RETURNED' ? `<a href="/admin/return?txId=${enriched.transactionId}" class="btn btn-sm btn-outline-custom py-1 px-2"><i class="bi bi-arrow-down-left-circle me-1"></i> Return</a>` : '-'}</td>
            </tr>`;
        }).join('');

        html = html.replace(/<tbody[\s\S]*?<\/tbody>/i, `<tbody>${recentTxHtml}</tbody>`);

        res.writeHead(200, { 'Content-Type': 'text/html; charset=utf-8' });
        return res.end(html);
    }

    // 6. Admin Books Management
    if (pathname === '/admin/books') {
        const action = query.action || 'list';

        if (action === 'view') {
            const id = parseInt(query.id, 10);
            const book = db.books.find(b => b.id === id || b.bookId === query.id || b.bookId === query.bookId);
            if (!book) {
                res.writeHead(302, { 'Location': '/admin/books?error=Book not found.' });
                return res.end();
            }
            const html = renderPage('admin/book-details.jsp', { user: currentUser, book, activePage: 'books' });
            res.writeHead(200, { 'Content-Type': 'text/html; charset=utf-8' });
            return res.end(html);
        }

        if (action === 'new') {
            const html = renderPage('admin/book-form.jsp', { user: currentUser, isEdit: false, activePage: 'books' });
            res.writeHead(200, { 'Content-Type': 'text/html; charset=utf-8' });
            return res.end(html);
        }

        if (action === 'edit') {
            const id = parseInt(query.id, 10);
            const book = db.books.find(b => b.id === id || b.bookId === query.id);
            if (!book) {
                res.writeHead(302, { 'Location': '/admin/books?error=Book not found.' });
                return res.end();
            }
            const html = renderPage('admin/book-form.jsp', { user: currentUser, book, isEdit: true, activePage: 'books' });
            res.writeHead(200, { 'Content-Type': 'text/html; charset=utf-8' });
            return res.end(html);
        }

        if (action === 'delete') {
            const id = parseInt(query.id, 10);
            const idx = db.books.findIndex(b => b.id === id || b.bookId === query.id);
            if (idx !== -1) db.books.splice(idx, 1);
            res.writeHead(302, { 'Location': '/admin/books?success=Book deleted successfully.' });
            return res.end();
        }

        if (req.method === 'POST') {
            let body = '';
            req.on('data', chunk => { body += chunk; });
            req.on('end', () => {
                const p = querystring.parse(body);
                if (p.action === 'update') {
                    const id = parseInt(p.id, 10);
                    const book = db.books.find(b => b.id === id || b.bookId === p.bookId);
                    if (book) {
                        book.bookId = p.bookId || book.bookId;
                        book.isbn = p.isbn || book.isbn;
                        book.title = p.title || book.title;
                        book.author = p.author || book.author;
                        book.category = p.category || book.category;
                        book.publisher = p.publisher || book.publisher;
                        book.publicationYear = parseInt(p.publicationYear, 10) || book.publicationYear;
                        book.language = p.language || book.language;
                        book.shelfNumber = p.shelfNumber || book.shelfNumber;
                        book.quantity = parseInt(p.quantity, 10) || book.quantity;
                        book.availableCopies = p.availableCopies !== undefined && p.availableCopies !== '' ? parseInt(p.availableCopies, 10) : book.availableCopies;
                        book.description = p.description !== undefined ? p.description : book.description;
                        if (p.coverUrl) book.coverUrl = p.coverUrl;
                        book.status = book.availableCopies > 0 ? 'AVAILABLE' : 'OUT_OF_STOCK';
                        res.writeHead(302, { 'Location': '/admin/books?success=Book updated successfully!' });
                        return res.end();
                    }
                }
                const newBook = {
                    id: db.books.length + 1,
                    bookId: p.bookId || `BK-${Date.now() % 10000}`,
                    isbn: p.isbn || 'N/A',
                    title: p.title || 'Untitled',
                    author: p.author || 'Unknown',
                    category: p.category || 'General',
                    publisher: p.publisher || 'Academic',
                    publicationYear: parseInt(p.publicationYear, 10) || 2024,
                    language: p.language || 'English',
                    description: p.description || '',
                    shelfNumber: p.shelfNumber || 'A1-01',
                    quantity: parseInt(p.quantity, 10) || 1,
                    availableCopies: parseInt(p.quantity, 10) || 1,
                    status: 'AVAILABLE',
                    coverUrl: p.coverUrl || 'https://images.unsplash.com/photo-1544716278-ca5e3f4abd8c?w=400&q=80'
                };
                db.books.unshift(newBook);
                res.writeHead(302, { 'Location': '/admin/books?success=Book added successfully!' });
                return res.end();
            });
            return;
        }

        // List books table
        let booksList = [...db.books];
        if (query.q) {
            const q = query.q.toLowerCase();
            booksList = booksList.filter(b => b.title.toLowerCase().includes(q) || b.author.toLowerCase().includes(q) || b.isbn.includes(q) || b.bookId.toLowerCase().includes(q));
        }
        if (query.category && query.category !== 'ALL') {
            booksList = booksList.filter(b => b.category === query.category);
        }

        let html = renderPage('admin/books.jsp', { user: currentUser, activePage: 'books', totalCount: booksList.length, query: query.q, success: query.success, error: query.error });

        const rowsHtml = booksList.map(b => `
            <tr>
                <td><span class="font-monospace fw-semibold text-primary">${b.bookId}</span></td>
                <td>
                    <div class="d-flex align-items-center gap-3">
                        <img src="${b.coverUrl}" class="book-thumb">
                        <div>
                            <div class="fw-bold text-dark">${b.title}</div>
                            <small class="text-muted font-monospace">ISBN: ${b.isbn}</small>
                        </div>
                    </div>
                </td>
                <td>${b.author}</td>
                <td><span class="badge badge-soft-info">${b.category}</span></td>
                <td><span class="font-monospace text-muted small">${b.shelfNumber}</span></td>
                <td><strong>${b.availableCopies}</strong> / ${b.quantity}</td>
                <td><span class="badge ${b.availableCopies > 0 ? 'badge-soft-success' : 'badge-soft-danger'}">${b.availableCopies > 0 ? 'AVAILABLE' : 'OUT OF STOCK'}</span></td>
                <td class="text-end">
                    <div class="d-inline-flex gap-1">
                        <a href="/admin/books?action=view&id=${b.id}" class="btn btn-sm btn-outline-custom p-1 px-2" title="View Details"><i class="bi bi-eye"></i></a>
                        <a href="/admin/books?action=edit&id=${b.id}" class="btn btn-sm btn-outline-custom p-1 px-2" title="Edit Book"><i class="bi bi-pencil"></i></a>
                        ${b.availableCopies > 0 ? `<a href="/admin/issue?bookId=${b.bookId}" class="btn btn-sm btn-primary p-1 px-2" title="Issue"><i class="bi bi-arrow-up-right"></i></a>` : ''}
                        <a href="/admin/books?action=delete&id=${b.id}" class="btn btn-sm btn-outline-danger p-1 px-2" onclick="return confirm('Delete this volume?');"><i class="bi bi-trash"></i></a>
                    </div>
                </td>
            </tr>
        `).join('');

        html = html.replace(/<tbody[\s\S]*?<\/tbody>/i, `<tbody>${rowsHtml}</tbody>`);
        res.writeHead(200, { 'Content-Type': 'text/html; charset=utf-8' });
        return res.end(html);
    }

    // 7. Admin Issue Book
    if (pathname === '/admin/issue') {
        if (req.method === 'POST') {
            let body = '';
            req.on('data', chunk => { body += chunk; });
            req.on('end', () => {
                const p = querystring.parse(body);
                const book = db.books.find(b => b.bookId === p.bookId);
                const member = db.members.find(m => m.memberId === p.memberId);

                if (book && book.availableCopies > 0 && member) {
                    book.availableCopies--;
                    if (book.availableCopies === 0) book.status = 'OUT_OF_STOCK';

                    const issueDate = new Date().toISOString().split('T')[0];
                    const dueDateObj = new Date();
                    dueDateObj.setDate(dueDateObj.getDate() + (member.memberType === 'FACULTY' ? 30 : 14));
                    const dueDate = dueDateObj.toISOString().split('T')[0];

                    db.transactions.unshift({
                        id: db.transactions.length + 1,
                        transactionId: `TXN-${Date.now()}`,
                        memberId: member.memberId,
                        bookId: book.bookId,
                        issueDate: issueDate,
                        dueDate: dueDate,
                        returnDate: null,
                        fine: 0.0,
                        status: 'ISSUED',
                        issuedBy: currentUser ? currentUser.username : 'admin',
                        remarks: 'Issued successfully'
                    });

                    res.writeHead(302, { 'Location': '/admin/transactions?success=Book issued successfully!' });
                    return res.end();
                } else {
                    res.writeHead(302, { 'Location': '/admin/issue?error=Book unavailable or quota exceeded.' });
                    return res.end();
                }
            });
            return;
        }

        let html = renderPage('admin/issue-book.jsp', { user: currentUser, activePage: 'issue', success: query.success, error: query.error });
        // Populate dynamic select options
        const memberOptions = db.members.map(m => `<option value="${m.memberId}">${m.memberId} — ${m.name} (${m.department})</option>`).join('');
        const bookOptions = db.books.filter(b => b.availableCopies > 0).map(b => `<option value="${b.bookId}" ${query.bookId === b.bookId ? 'selected' : ''}>${b.bookId} — ${b.title} (${b.availableCopies} available)</option>`).join('');

        html = html.replace(/<select name="memberId"[\s\S]*?<\/select>/i, `<select name="memberId" class="form-select" required><option value="">-- Choose Member --</option>${memberOptions}</select>`);
        html = html.replace(/<select name="bookId"[\s\S]*?<\/select>/i, `<select name="bookId" class="form-select" required><option value="">-- Choose Volume --</option>${bookOptions}</select>`);

        res.writeHead(200, { 'Content-Type': 'text/html; charset=utf-8' });
        return res.end(html);
    }

    // 8. Admin Return Book
    if (pathname === '/admin/return') {
        if (req.method === 'POST') {
            let body = '';
            req.on('data', chunk => { body += chunk; });
            req.on('end', () => {
                const p = querystring.parse(body);
                const tx = db.transactions.find(t => t.transactionId === p.transactionId);
                if (tx && tx.status !== 'RETURNED') {
                    tx.status = 'RETURNED';
                    tx.returnDate = new Date().toISOString().split('T')[0];
                    const daysLate = Math.max(0, Math.floor((new Date() - new Date(tx.dueDate)) / (1000 * 60 * 60 * 24)));
                    tx.fine = daysLate * 5.0;
                    tx.remarks = p.remarks || 'Returned on time';

                    const book = db.books.find(b => b.bookId === tx.bookId);
                    if (book) {
                        book.availableCopies++;
                        book.status = 'AVAILABLE';
                    }

                    if (tx.fine > 0) {
                        db.fines.unshift({
                            id: db.fines.length + 1,
                            fineId: `FN-${Date.now()}`,
                            transactionId: tx.transactionId,
                            memberId: tx.memberId,
                            amount: tx.fine,
                            daysLate: daysLate,
                            status: 'UNPAID',
                            paidAt: null,
                            paymentMode: null
                        });
                    }

                    res.writeHead(302, { 'Location': '/admin/transactions?success=Book returned successfully.' });
                    return res.end();
                }
            });
            return;
        }

        let html = renderPage('admin/return-book.jsp', { user: currentUser, activePage: 'return', success: query.success, error: query.error });
        const activeLoans = db.transactions.filter(t => t.status === 'ISSUED' || t.status === 'OVERDUE').map(enrichTransaction);
        const options = activeLoans.map(t => `<option value="${t.transactionId}" ${query.txId === t.transactionId ? 'selected' : ''}>${t.transactionId} — ${t.memberName} (${t.bookTitle})</option>`).join('');

        html = html.replace(/<select name="txId"[\s\S]*?<\/select>/i, `<select name="txId" class="form-select" onchange="this.form.submit()"><option value="">-- Choose Active Loan --</option>${options}</select>`);

        // If txId is passed, render return card details
        if (query.txId) {
            const tx = activeLoans.find(t => t.transactionId === query.txId);
            if (tx) {
                html = html.replace(/<form action="\/admin\/return" method="POST"[\s\S]*?<\/form>/i, `
                    <form action="/admin/return" method="POST">
                        <input type="hidden" name="transactionId" value="${tx.transactionId}">
                        <div class="p-3 rounded-3 bg-light border mb-4">
                            <div class="row g-3">
                                <div class="col-6"><small class="text-muted d-block">Transaction ID</small><span class="font-monospace fw-bold text-primary">${tx.transactionId}</span></div>
                                <div class="col-6"><small class="text-muted d-block">Patron</small><span class="fw-bold">${tx.memberName} (${tx.memberId})</span></div>
                                <div class="col-6"><small class="text-muted d-block">Volume</small><span>${tx.bookTitle}</span></div>
                                <div class="col-6"><small class="text-muted d-block">Due Date</small><strong class="${tx.isOverdue ? 'text-danger' : 'text-primary'}">${tx.dueDate}</strong></div>
                            </div>
                        </div>
                        <div class="row g-3 mb-4">
                            <div class="col-4 text-center p-3 rounded-3 bg-light border"><small class="text-muted d-block">Days Overdue</small><div class="fs-3 fw-bold ${tx.daysOverdue > 0 ? 'text-danger' : 'text-success'}">${tx.daysOverdue} Days</div></div>
                            <div class="col-4 text-center p-3 rounded-3 bg-light border"><small class="text-muted d-block">Fine Rate</small><div class="fs-3 fw-bold">₹5.00/day</div></div>
                            <div class="col-4 text-center p-3 rounded-3 bg-light border"><small class="text-muted d-block">Calculated Fine</small><div class="fs-3 fw-bold text-warning">₹${tx.daysOverdue * 5.0}</div></div>
                        </div>
                        <div class="mb-3"><label class="form-label small fw-semibold">Return Remarks</label><input type="text" name="remarks" class="form-control" value="Returned in good condition"></div>
                        <button type="submit" class="btn btn-gradient-primary px-4 py-2"><i class="bi bi-check-circle-fill me-1"></i> Confirm & Complete Return</button>
                    </form>
                `);
            }
        }

        res.writeHead(200, { 'Content-Type': 'text/html; charset=utf-8' });
        return res.end(html);
    }

    // 9. Admin Transactions History
    if (pathname === '/admin/transactions') {
        let list = db.transactions.map(enrichTransaction);
        if (query.status && query.status !== 'ALL') {
            list = list.filter(t => t.status === query.status);
        }
        if (query.q) {
            const q = query.q.toLowerCase();
            list = list.filter(t => t.transactionId.toLowerCase().includes(q) || t.memberName.toLowerCase().includes(q) || t.bookTitle.toLowerCase().includes(q));
        }

        let html = renderPage('admin/transactions.jsp', { user: currentUser, activePage: 'transactions', totalCount: list.length, success: query.success, error: query.error });
        const rows = list.map(t => `<tr>
            <td><span class="font-monospace fw-semibold text-primary">${t.transactionId}</span></td>
            <td><div class="fw-bold">${t.memberName}</div><small class="text-muted font-monospace">${t.memberId}</small></td>
            <td><div class="fw-medium text-truncate" style="max-width:220px;">${t.bookTitle}</div></td>
            <td>${t.issueDate}</td>
            <td><span class="${t.isOverdue ? 'text-danger fw-bold' : ''}">${t.dueDate}</span></td>
            <td>${t.returnDate || '-'}</td>
            <td>${t.fine > 0 ? `<span class="badge badge-soft-warning">₹${t.fine}</span>` : '₹0.00'}</td>
            <td><span class="badge ${t.status === 'RETURNED' ? 'badge-soft-success' : (t.isOverdue ? 'badge-soft-danger' : 'badge-soft-info')}">${t.status}</span></td>
            <td class="text-end">${t.status !== 'RETURNED' ? `<a href="/admin/return?txId=${t.transactionId}" class="btn btn-sm btn-outline-custom py-1 px-2">Return</a>` : '-'}</td>
        </tr>`).join('');

        html = html.replace(/<tbody[\s\S]*?<\/tbody>/i, `<tbody>${rows}</tbody>`);
        res.writeHead(200, { 'Content-Type': 'text/html; charset=utf-8' });
        return res.end(html);
    }

    // 10. Admin Members
    if (pathname === '/admin/members') {
        const action = query.action || 'list';
        if (action === 'new') {
            const html = renderPage('admin/member-form.jsp', { user: currentUser, isEdit: false, activePage: 'members' });
            res.writeHead(200, { 'Content-Type': 'text/html; charset=utf-8' });
            return res.end(html);
        }

        if (action === 'edit') {
            const id = parseInt(query.id, 10);
            const member = db.members.find(m => m.id === id || m.memberId === query.id);
            if (!member) {
                res.writeHead(302, { 'Location': '/admin/members?error=Member not found.' });
                return res.end();
            }
            const enrichedMem = {
                ...member,
                roleDescription: member.year || member.memberType
            };
            const html = renderPage('admin/member-form.jsp', { user: currentUser, member: enrichedMem, isEdit: true, activePage: 'members' });
            res.writeHead(200, { 'Content-Type': 'text/html; charset=utf-8' });
            return res.end(html);
        }

        if (action === 'delete') {
            const id = parseInt(query.id, 10);
            const idx = db.members.findIndex(m => m.id === id || m.memberId === query.id);
            if (idx !== -1) db.members.splice(idx, 1);
            res.writeHead(302, { 'Location': '/admin/members?success=Member removed.' });
            return res.end();
        }

        if (req.method === 'POST') {
            let body = '';
            req.on('data', chunk => { body += chunk; });
            req.on('end', () => {
                const p = querystring.parse(body);
                if (p.action === 'update') {
                    const id = parseInt(p.id, 10);
                    const member = db.members.find(m => m.id === id || m.memberId === p.memberId);
                    if (member) {
                        member.memberId = p.memberId || member.memberId;
                        member.name = p.name || member.name;
                        member.email = p.email || member.email;
                        member.phone = p.phone || member.phone;
                        member.department = p.department || member.department;
                        member.year = p.yearOrDesignation || member.year;
                        member.memberType = p.memberType || member.memberType;
                        member.maxBorrowLimit = parseInt(p.maxBorrowLimit, 10) || member.maxBorrowLimit;
                        member.status = p.status || member.status;
                        res.writeHead(302, { 'Location': '/admin/members?success=Member updated successfully!' });
                        return res.end();
                    }
                }
                const newMem = {
                    id: db.members.length + 1,
                    memberId: p.memberId || `MEM-${Date.now() % 10000}`,
                    name: p.name || 'Student Patron',
                    email: p.email || 'student@library.edu',
                    phone: p.phone || '+91 98765 00000',
                    department: p.department || 'Computer Science',
                    year: p.yearOrDesignation || '1st Year',
                    memberType: p.memberType || 'STUDENT',
                    maxBorrowLimit: parseInt(p.maxBorrowLimit, 10) || 4,
                    registrationDate: new Date().toISOString().split('T')[0],
                    status: p.status || 'ACTIVE'
                };
                db.members.unshift(newMem);
                if (p.createAccount === 'yes') {
                    db.users.push({
                        id: db.users.length + 1,
                        username: (p.username || p.memberId).trim().toLowerCase(),
                        email: p.email,
                        password: 'student123',
                        role: p.memberType === 'FACULTY' ? 'FACULTY' : 'STUDENT',
                        memberId: newMem.memberId,
                        status: 'ACTIVE'
                    });
                }
                res.writeHead(302, { 'Location': '/admin/members?success=Member registered successfully!' });
                return res.end();
            });
            return;
        }

        let html = renderPage('admin/members.jsp', { user: currentUser, activePage: 'members', success: query.success, error: query.error });
        const rows = db.members.map(m => `<tr>
            <td><span class="font-monospace fw-semibold text-primary">${m.memberId}</span></td>
            <td><div class="fw-bold">${m.name}</div><span class="badge ${m.memberType === 'FACULTY' ? 'badge-soft-warning' : 'bg-light text-dark border'} small">${m.memberType}</span></td>
            <td><div><i class="bi bi-envelope me-1 text-muted"></i><small>${m.email}</small></div><div><i class="bi bi-telephone me-1 text-muted"></i><small>${m.phone}</small></div></td>
            <td><div class="fw-medium">${m.department}</div><small class="text-muted">${m.year}</small></td>
            <td><span class="badge badge-soft-info">${m.maxBorrowLimit} Books</span></td>
            <td><span class="badge badge-soft-success">ACTIVE</span></td>
            <td class="text-end">
                <div class="d-inline-flex gap-1">
                    <a href="/admin/issue?memberId=${m.memberId}" class="btn btn-sm btn-primary p-1 px-2" title="Issue"><i class="bi bi-arrow-up-right"></i></a>
                    <a href="/admin/members?action=edit&id=${m.id}" class="btn btn-sm btn-outline-custom p-1 px-2" title="Edit Member"><i class="bi bi-pencil"></i></a>
                    <a href="/admin/members?action=delete&id=${m.id}" class="btn btn-sm btn-outline-danger p-1 px-2" onclick="return confirm('Delete this member?');"><i class="bi bi-trash"></i></a>
                </div>
            </td>
        </tr>`).join('');

        html = html.replace(/<tbody[\s\S]*?<\/tbody>/i, `<tbody>${rows}</tbody>`);
        res.writeHead(200, { 'Content-Type': 'text/html; charset=utf-8' });
        return res.end(html);
    }

    // 11. Admin Fines & Payment
    if (pathname === '/admin/fines') {
        if (req.method === 'POST') {
            let body = '';
            req.on('data', chunk => { body += chunk; });
            req.on('end', () => {
                const p = querystring.parse(body);
                const fine = db.fines.find(f => f.fineId === p.fineId);
                if (fine) {
                    fine.status = 'PAID';
                    fine.paidAt = new Date().toLocaleString();
                    fine.paymentMode = p.paymentMode || 'CASH';
                }
                res.writeHead(302, { 'Location': '/admin/fines?success=Fine payment recorded.' });
                return res.end();
            });
            return;
        }

        let html = renderPage('admin/fines.jsp', { user: currentUser, activePage: 'fines', success: query.success, error: query.error });
        const finesList = db.fines.map(enrichFine);
        const rows = finesList.map(f => `<tr>
            <td><span class="font-monospace fw-semibold text-danger">${f.fineId}</span></td>
            <td><span class="font-monospace text-muted small">${f.transactionId}</span></td>
            <td><div class="fw-bold">${f.memberName}</div><small class="text-muted font-monospace">${f.memberId}</small></td>
            <td><div class="text-truncate" style="max-width:180px;">${f.bookTitle}</div></td>
            <td><span class="fw-semibold text-danger">${f.daysLate} Days</span></td>
            <td><strong class="fs-6 text-dark">₹${f.amount}</strong></td>
            <td><span class="badge bg-light text-dark border">${f.paymentMode || '-'}</span></td>
            <td><span class="badge ${f.status === 'PAID' ? 'badge-soft-success' : 'badge-soft-danger'}">${f.status}</span></td>
            <td class="text-end">
                ${f.status === 'UNPAID' ? `
                    <form action="/admin/fines" method="POST" class="d-inline">
                        <input type="hidden" name="fineId" value="${f.fineId}">
                        <input type="hidden" name="paymentMode" value="UPI">
                        <button type="submit" class="btn btn-sm btn-success py-1 px-2"><i class="bi bi-cash me-1"></i> Pay Fine</button>
                    </form>
                ` : '<span class="text-success small fw-semibold"><i class="bi bi-check-all"></i> Settled</span>'}
            </td>
        </tr>`).join('');

        html = html.replace(/<tbody[\s\S]*?<\/tbody>/i, `<tbody>${rows}</tbody>`);
        res.writeHead(200, { 'Content-Type': 'text/html; charset=utf-8' });
        return res.end(html);
    }

    // 12. Admin Waitlist Reservations Queue
    if (pathname === '/admin/reservations') {
        let html = renderPage('admin/reservations.jsp', { user: currentUser, activePage: 'reservations', success: query.success, error: query.error });
        const list = db.reservations.map(enrichReservation);
        const rows = list.map(r => `<tr>
            <td><div class="rounded-circle ${r.queuePosition === 1 ? 'bg-warning text-dark' : 'bg-light text-muted border'} d-inline-flex align-items-center justify-content-center fw-bold" style="width:34px;height:34px;">#${r.queuePosition}</div></td>
            <td><span class="font-monospace fw-semibold text-primary">${r.reservationId}</span></td>
            <td><div class="fw-bold text-truncate" style="max-width:240px;">${r.bookTitle}</div><small class="text-muted font-monospace">${r.bookId}</small></td>
            <td><div class="fw-semibold">${r.memberName}</div><small class="text-muted font-monospace">${r.memberId}</small></td>
            <td><small class="text-muted">${r.reservationDate}</small></td>
            <td><span class="badge badge-soft-warning">PENDING</span></td>
            <td class="text-end"><form action="/student/cancel-reserve" method="POST" class="d-inline"><input type="hidden" name="reservationId" value="${r.reservationId}"><button type="submit" class="btn btn-sm btn-outline-danger py-1 px-2"><i class="bi bi-x-circle me-1"></i> Cancel</button></form></td>
        </tr>`).join('');

        html = html.replace(/<tbody[\s\S]*?<\/tbody>/i, `<tbody>${rows}</tbody>`);
        res.writeHead(200, { 'Content-Type': 'text/html; charset=utf-8' });
        return res.end(html);
    }

    // 13. Reports & CSV Exports
    if (pathname === '/admin/reports') {
        const summary = getSummaryStats();
        const html = renderPage('admin/reports.jsp', { user: currentUser, summary, activePage: 'reports' });
        res.writeHead(200, { 'Content-Type': 'text/html; charset=utf-8' });
        return res.end(html);
    }

    if (pathname === '/admin/export') {
        const type = query.type || 'books';
        res.setHeader('Content-Type', 'text/csv');
        res.setHeader('Content-Disposition', `attachment; filename="dlms_${type}_export_${Date.now()}.csv"`);

        if (type === 'books') {
            let csv = 'Book ID,ISBN,Title,Author,Category,Shelf,Total,Available,Status\n';
            db.books.forEach(b => {
                csv += `"${b.bookId}","${b.isbn}","${b.title}","${b.author}","${b.category}","${b.shelfNumber}",${b.quantity},${b.availableCopies},"${b.status}"\n`;
            });
            return res.end(csv);
        } else if (type === 'transactions') {
            let csv = 'Transaction ID,Member ID,Book ID,Issue Date,Due Date,Return Date,Fine,Status\n';
            db.transactions.forEach(t => {
                csv += `"${t.transactionId}","${t.memberId}","${t.bookId}","${t.issueDate}","${t.dueDate}","${t.returnDate || ''}",${t.fine},"${t.status}"\n`;
            });
            return res.end(csv);
        } else if (type === 'members') {
            let csv = 'Member ID,Name,Email,Phone,Department,Role,Quota,Status\n';
            db.members.forEach(m => {
                csv += `"${m.memberId}","${m.name}","${m.email}","${m.phone}","${m.department}","${m.year}",${m.maxBorrowLimit},"${m.status}"\n`;
            });
            return res.end(csv);
        } else {
            let csv = 'Fine ID,Transaction ID,Member ID,Amount,Days Late,Status\n';
            db.fines.forEach(f => {
                csv += `"${f.fineId}","${f.transactionId}","${f.memberId}",${f.amount},${f.daysLate},"${f.status}"\n`;
            });
            return res.end(csv);
        }
    }

    // 14. Admin Settings
    if (pathname === '/admin/settings') {
        const html = renderPage('admin/settings.jsp', { user: currentUser, activePage: 'settings' });
        res.writeHead(200, { 'Content-Type': 'text/html; charset=utf-8' });
        return res.end(html);
    }

    // 15. Student Portal
    if (pathname === '/student/dashboard') {
        const studentUser = currentUser || db.users[2]; // Default to Aman
        const rawMember = db.members.find(m => m.memberId === studentUser.memberId) || db.members[0];
        const member = {
            ...rawMember,
            roleDescription: rawMember.year || (rawMember.memberType === 'FACULTY' ? 'Faculty Member' : 'Student Patron'),
            allowedBorrowDays: rawMember.memberType === 'FACULTY' ? 30 : 14
        };
        const studentLoans = db.transactions.filter(t => t.memberId === member.memberId && t.status !== 'RETURNED').map(enrichTransaction);
        const unpaidFines = db.fines.filter(f => f.memberId === member.memberId && f.status === 'UNPAID').reduce((a, b) => a + b.amount, 0);
        const reservations = db.reservations.filter(r => r.memberId === member.memberId);
        const overdueCount = studentLoans.filter(t => t.isOverdue).length;

        let html = renderPage('student/dashboard.jsp', {
            user: studentUser,
            member: member,
            activeLoans: studentLoans,
            overdueCount: overdueCount,
            unpaidFines: unpaidFines.toFixed(2),
            reservations: reservations,
            activePage: 'dashboard',
            success: query.success,
            error: query.error
        });

        // Dynamic active loans cards replacement
        let loansHtml = '';
        if (studentLoans.length > 0) {
            const cards = studentLoans.map(tx => `
                <div class="col-md-6 col-xl-4">
                    <div class="p-3 rounded-3 border bg-light h-100 d-flex flex-column">
                        <div class="d-flex gap-3 align-items-center mb-2">
                            ${tx.bookCoverUrl ? `<img src="${tx.bookCoverUrl}" alt="cover" class="book-thumb">` : ''}
                            <div>
                                <h6 class="fw-bold mb-0 text-truncate" style="max-width: 200px;" title="${tx.bookTitle}">${tx.bookTitle}</h6>
                                <small class="text-muted font-monospace">${tx.bookId}</small>
                            </div>
                        </div>
                        <div class="mt-auto pt-2 border-top small d-flex justify-content-between align-items-center">
                            <div>
                                <span class="text-muted d-block" style="font-size: 0.75rem;">Due Date:</span>
                                <strong class="${tx.isOverdue ? 'text-danger' : 'text-dark'}">${tx.dueDate}</strong>
                            </div>
                            ${tx.isOverdue ? `<span class="badge badge-soft-danger">${tx.daysOverdue} Days Late</span>` : `<span class="badge badge-soft-success">On Loan</span>`}
                        </div>
                    </div>
                </div>
            `).join('');
            loansHtml = `<div class="row g-3">${cards}</div>`;
        } else {
            loansHtml = `
                <div class="empty-state py-4">
                    <i class="bi bi-book empty-state-icon"></i>
                    <div class="fw-bold">No Active Loans</div>
                    <p class="text-muted small">You currently have no borrowed books. Explore our catalog to request titles.</p>
                    <a href="/student/browse" class="btn btn-sm btn-gradient-primary">
                        <i class="bi bi-search me-1"></i> Browse Library Catalog
                    </a>
                </div>
            `;
        }

        html = html.replace(/<c:choose>[\s\S]*?<c:when\s+test=["']\$\{not empty activeLoans\}["']>[\s\S]*?<\/c:choose>/i, loansHtml);

        // Dynamic recommended books cards replacement
        const recBooks = db.books.filter(b => b.availableCopies > 0).slice(0, 4);
        const recHtml = recBooks.map(b => `
            <div class="col-sm-6 col-lg-3">
                <div class="card h-100 border rounded-3 overflow-hidden shadow-sm">
                    <img src="${b.coverUrl}" alt="${b.title}" style="height: 150px; object-fit: cover;">
                    <div class="p-3 d-flex flex-column flex-grow-1">
                        <span class="badge badge-soft-info mb-1 small text-truncate">${b.category}</span>
                        <h6 class="fw-bold mb-1 text-truncate" title="${b.title}">${b.title}</h6>
                        <small class="text-muted text-truncate mb-2">${b.author}</small>
                        <div class="mt-auto">
                            <a href="/student/browse?q=${encodeURIComponent(b.title)}" class="btn btn-sm btn-outline-custom w-100">
                                View Details
                            </a>
                        </div>
                    </div>
                </div>
            </div>
        `).join('');

        html = html.replace(/<div class="row g-3">\s*<c:forEach\s+var=["']book["']\s+items=["']\$\{recommendedBooks\}["']>[\s\S]*?<\/div>\s*<\/div>\s*<\/main>/i, `<div class="row g-3">${recHtml}</div></div></main>`);

        res.writeHead(200, { 'Content-Type': 'text/html; charset=utf-8' });
        return res.end(html);
    }

    if (pathname === '/student/browse') {
        let booksList = [...db.books];
        if (query.q) {
            const q = query.q.toLowerCase();
            booksList = booksList.filter(b => b.title.toLowerCase().includes(q) || b.author.toLowerCase().includes(q) || b.isbn.includes(q));
        }
        if (query.category && query.category !== 'ALL') {
            booksList = booksList.filter(b => b.category === query.category);
        }

        let html = renderPage('student/browse-books.jsp', { user: currentUser || db.users[2], activePage: 'browse', query: query.q, success: query.success, error: query.error });
        const cardsHtml = booksList.map(b => `
            <div class="col-sm-6 col-lg-4 col-xl-3">
                <div class="glass-card h-100 card-hover-lift d-flex flex-column overflow-hidden">
                    <img src="${b.coverUrl}" class="book-card-cover">
                    <div class="p-3 d-flex flex-column flex-grow-1">
                        <div class="d-flex justify-content-between align-items-center mb-1"><span class="badge badge-soft-info small">${b.category}</span><small class="text-muted font-monospace">${b.shelfNumber}</small></div>
                        <h6 class="fw-bold mb-1 text-truncate">${b.title}</h6>
                        <p class="text-muted small mb-2 text-truncate">${b.author}</p>
                        <div class="mt-auto pt-2 border-top">
                            <div class="d-flex justify-content-between align-items-center mb-2">
                                <small class="text-muted font-monospace">#${b.bookId}</small>
                                <span class="badge ${b.availableCopies > 0 ? 'badge-soft-success' : 'badge-soft-danger'}">${b.availableCopies > 0 ? b.availableCopies + ' Available' : 'Out of Stock'}</span>
                            </div>
                            ${b.availableCopies > 0 ? `
                                <button class="btn btn-sm btn-gradient-primary w-100" onclick="alert('Book ID: ${b.bookId} is available at Shelf: ${b.shelfNumber}. Please present your ID card at the circulation desk.');"><i class="bi bi-check-circle me-1"></i> Available at Desk</button>
                            ` : `
                                <form action="/student/reserve" method="POST">
                                    <input type="hidden" name="bookId" value="${b.bookId}">
                                    <button type="submit" class="btn btn-sm btn-warning w-100 text-dark fw-semibold"><i class="bi bi-bookmark-plus me-1"></i> Reserve Waitlist</button>
                                </form>
                            `}
                        </div>
                    </div>
                </div>
            </div>
        `).join('');

        html = html.replace(/<div class="row g-4 mb-4">[\s\S]*?<\/div>\s*<!-- Pagination -->/i, `<div class="row g-4 mb-4">${cardsHtml}</div><!-- Pagination -->`);

        res.writeHead(200, { 'Content-Type': 'text/html; charset=utf-8' });
        return res.end(html);
    }

    if (pathname === '/student/reserve') {
        if (req.method === 'POST') {
            let body = '';
            req.on('data', chunk => { body += chunk; });
            req.on('end', () => {
                const p = querystring.parse(body);
                const studentUser = currentUser || db.users[2];
                const count = db.reservations.filter(r => r.bookId === p.bookId && r.status === 'PENDING').length;
                db.reservations.push({
                    id: db.reservations.length + 1,
                    reservationId: `RES-${Date.now()}`,
                    memberId: studentUser.memberId || 'MEM-2024-001',
                    bookId: p.bookId,
                    reservationDate: new Date().toLocaleString(),
                    queuePosition: count + 1,
                    status: 'PENDING',
                    expiryDate: '2024-11-20'
                });
                res.writeHead(302, { 'Location': '/student/reservations?success=Book reserved! You are #' + (count + 1) + ' in the queue.' });
                return res.end();
            });
            return;
        }
    }

    if (pathname === '/student/cancel-reserve') {
        if (req.method === 'POST') {
            let body = '';
            req.on('data', chunk => { body += chunk; });
            req.on('end', () => {
                const p = querystring.parse(body);
                const idx = db.reservations.findIndex(r => r.reservationId === p.reservationId);
                if (idx !== -1) db.reservations.splice(idx, 1);
                res.writeHead(302, { 'Location': (currentUser && currentUser.role === 'ADMIN') ? '/admin/reservations?success=Reservation cancelled.' : '/student/reservations?success=Reservation cancelled.' });
                return res.end();
            });
            return;
        }
    }

    if (pathname === '/student/my-books') {
        const studentUser = currentUser || db.users[2];
        const studentLoans = db.transactions.filter(t => t.memberId === (studentUser.memberId || 'MEM-2024-001') && t.status !== 'RETURNED').map(enrichTransaction);
        let html = renderPage('student/my-books.jsp', { user: studentUser, activeLoans: studentLoans, activePage: 'my-books', success: query.success, error: query.error });

        const rows = studentLoans.map(t => `<tr>
            <td><div class="d-flex align-items-center gap-3"><img src="${t.bookCoverUrl}" class="book-thumb"><div><h6 class="fw-bold mb-0 text-dark">${t.bookTitle}</h6><small class="text-muted font-monospace">Book ID: ${t.bookId}</small></div></div></td>
            <td>${t.issueDate}</td>
            <td><strong class="${t.isOverdue ? 'text-danger' : 'text-primary'}">${t.dueDate}</strong></td>
            <td><span class="badge ${t.isOverdue ? 'badge-soft-danger' : 'badge-soft-success'}">${t.isOverdue ? t.daysOverdue + ' Days Overdue' : 'Active Loan'}</span></td>
            <td>${t.isOverdue ? `<span class="fw-bold text-danger">₹${t.daysOverdue * 5.0}</span>` : '₹0.00'}</td>
        </tr>`).join('');

        html = html.replace(/<tbody[\s\S]*?<\/tbody>/i, `<tbody>${rows}</tbody>`);
        res.writeHead(200, { 'Content-Type': 'text/html; charset=utf-8' });
        return res.end(html);
    }

    if (pathname === '/student/reservations') {
        const studentUser = currentUser || db.users[2];
        const resList = db.reservations.filter(r => r.memberId === (studentUser.memberId || 'MEM-2024-001')).map(enrichReservation);
        let html = renderPage('student/reservations.jsp', { user: studentUser, activePage: 'reservations', success: query.success, error: query.error });

        const rows = resList.map(r => `<tr>
            <td><div class="rounded-circle ${r.queuePosition === 1 ? 'bg-warning text-dark' : 'bg-light text-muted border'} d-inline-flex align-items-center justify-content-center fw-bold" style="width:34px;height:34px;">#${r.queuePosition}</div></td>
            <td><span class="font-monospace text-primary fw-semibold">${r.reservationId}</span></td>
            <td><div class="fw-bold text-dark text-truncate" style="max-width:240px;">${r.bookTitle}</div><small class="text-muted font-monospace">${r.bookId}</small></td>
            <td><small class="text-muted">${r.reservationDate}</small></td>
            <td><small class="text-muted">${r.expiryDate}</small></td>
            <td><span class="badge badge-soft-warning">In Waitlist Queue</span></td>
            <td class="text-end"><form action="/student/cancel-reserve" method="POST" class="d-inline"><input type="hidden" name="reservationId" value="${r.reservationId}"><button type="submit" class="btn btn-sm btn-outline-danger py-1 px-2">Cancel</button></form></td>
        </tr>`).join('');

        html = html.replace(/<tbody[\s\S]*?<\/tbody>/i, `<tbody>${rows}</tbody>`);
        res.writeHead(200, { 'Content-Type': 'text/html; charset=utf-8' });
        return res.end(html);
    }

    if (pathname === '/student/fines') {
        const studentUser = currentUser || db.users[2];
        const finesList = db.fines.filter(f => f.memberId === (studentUser.memberId || 'MEM-2024-001')).map(enrichFine);
        const totalUnpaid = finesList.filter(f => f.status === 'UNPAID').reduce((a, b) => a + b.amount, 0);
        let html = renderPage('student/fines.jsp', { user: studentUser, totalUnpaid: totalUnpaid.toFixed(2), activePage: 'fines', success: query.success, error: query.error });

        const rows = finesList.map(f => `<tr>
            <td><span class="font-monospace fw-semibold text-danger">${f.fineId}</span></td>
            <td><span class="font-monospace text-muted small">${f.transactionId}</span></td>
            <td><div class="fw-bold text-dark text-truncate" style="max-width:240px;">${f.bookTitle}</div></td>
            <td><span class="text-danger fw-semibold">${f.daysLate} Days</span></td>
            <td><strong class="fs-6 text-dark">₹${f.amount}</strong></td>
            <td><span class="badge ${f.status === 'PAID' ? 'badge-soft-success' : 'badge-soft-danger'}">${f.status}</span></td>
            <td><small class="text-muted">${f.paidAt || '-'}</small></td>
        </tr>`).join('');

        html = html.replace(/<tbody[\s\S]*?<\/tbody>/i, `<tbody>${rows}</tbody>`);
        res.writeHead(200, { 'Content-Type': 'text/html; charset=utf-8' });
        return res.end(html);
    }

    if (pathname === '/student/history') {
        const studentUser = currentUser || db.users[2];
        const historyList = db.transactions.filter(t => t.memberId === (studentUser.memberId || 'MEM-2024-001')).map(enrichTransaction);
        let html = renderPage('student/history.jsp', { user: studentUser, activePage: 'history', success: query.success, error: query.error });

        const rows = historyList.map(t => `<tr>
            <td><span class="font-monospace fw-semibold text-primary">${t.transactionId}</span></td>
            <td><div class="fw-bold text-dark text-truncate" style="max-width:250px;">${t.bookTitle}</div><small class="text-muted font-monospace">${t.bookId}</small></td>
            <td>${t.issueDate}</td>
            <td>${t.dueDate}</td>
            <td>${t.returnDate || '-'}</td>
            <td>${t.fine > 0 ? `<span class="badge badge-soft-warning">₹${t.fine}</span>` : '₹0.00'}</td>
            <td><span class="badge ${t.status === 'RETURNED' ? 'badge-soft-success' : (t.isOverdue ? 'badge-soft-danger' : 'badge-soft-info')}">${t.status}</span></td>
        </tr>`).join('');

        html = html.replace(/<tbody[\s\S]*?<\/tbody>/i, `<tbody>${rows}</tbody>`);
        res.writeHead(200, { 'Content-Type': 'text/html; charset=utf-8' });
        return res.end(html);
    }

    if (pathname === '/student/profile') {
        const studentUser = currentUser || db.users[2];
        const rawMember = db.members.find(m => m.memberId === (studentUser.memberId || 'MEM-2024-001')) || db.members[0];
        const member = {
            ...rawMember,
            roleDescription: rawMember.year || (rawMember.memberType === 'FACULTY' ? 'Faculty Member' : 'Student Patron'),
            allowedBorrowDays: rawMember.memberType === 'FACULTY' ? 30 : 14
        };
        const html = renderPage('student/profile.jsp', { user: studentUser, member, activePage: 'profile', success: query.success, error: query.error });
        res.writeHead(200, { 'Content-Type': 'text/html; charset=utf-8' });
        return res.end(html);
    }

    if (pathname === '/student/change-password') {
        if (req.method === 'POST') {
            let body = '';
            req.on('data', chunk => { body += chunk; });
            req.on('end', () => {
                const p = querystring.parse(body);
                if (!p.newPassword || p.newPassword !== p.confirmPassword) {
                    res.writeHead(302, { 'Location': '/student/profile?error=Passwords do not match.' });
                    return res.end();
                }
                const studentUser = currentUser || db.users[2];
                const u = db.users.find(usr => usr.id === studentUser.id);
                if (u) {
                    u.password = p.newPassword;
                }
                res.writeHead(302, { 'Location': '/student/profile?success=Password updated successfully!' });
                return res.end();
            });
            return;
        }
        res.writeHead(302, { 'Location': '/student/profile' });
        return res.end();
    }

    // 404 Fallback
    const errHtml = renderPage('error-404.jsp', {});
    res.writeHead(404, { 'Content-Type': 'text/html; charset=utf-8' });
    res.end(errHtml);
});

server.listen(PORT, () => {
    console.log(`====================================================================`);
    console.log(`  DIGITAL LIBRARY MANAGEMENT SYSTEM (DLMS) - SERVER RUNNING`);
    console.log(`  B.Tech PBL Project | Team No: 1`);
    console.log(`  Members: Md. Amanuddin, Jashwanth Chowdary`);
    console.log(`  URL: http://localhost:${PORT}`);
    console.log(`====================================================================`);
});
