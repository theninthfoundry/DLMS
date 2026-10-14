/**
 * DIGITAL LIBRARY MANAGEMENT SYSTEM (DLMS) - BROWSER DATABASE ENGINE
 * Preloaded with production schema and seed dataset from database.sql.
 * Persists changes in localStorage with complete CRUD and transaction workflows.
 */

const DLMS_STORAGE_KEY = 'dlms_database_v1';
const DLMS_USER_KEY = 'dlms_session_user';

const INITIAL_DATA = {
    users: [
        { id: 1, username: 'admin', email: 'admin@library.edu', password: 'admin123', role: 'ADMIN', memberId: null, status: 'ACTIVE' },
        { id: 2, username: 'librarian', email: 'librarian@library.edu', password: 'admin123', role: 'LIBRARIAN', memberId: null, status: 'ACTIVE' },
        { id: 3, username: 'siddhartha', email: 'siddhartha@library.edu', password: 'student123', role: 'STUDENT', memberId: 'MEM-2024-001', status: 'ACTIVE' },
        { id: 4, username: 'aman', email: 'amanuddin@library.edu', password: 'student123', role: 'STUDENT', memberId: 'MEM-2024-002', status: 'ACTIVE' },
        { id: 5, username: 'jashwanth', email: 'jashwanth@library.edu', password: 'student123', role: 'STUDENT', memberId: 'MEM-2024-003', status: 'ACTIVE' },
        { id: 6, username: 'student', email: 'student@library.edu', password: 'student123', role: 'STUDENT', memberId: 'MEM-2024-005', status: 'ACTIVE' },
        { id: 7, username: 'drrajesh', email: 'rajesh.sharma@library.edu', password: 'student123', role: 'FACULTY', memberId: 'MEM-2024-004', status: 'ACTIVE' }
    ],
    members: [
        { id: 1, memberId: 'MEM-2024-001', name: 'L.N.C Siddhartha', email: 'siddhartha@library.edu', phone: '+91 98765 43210', department: 'Computer Science & Engineering', year: '3rd Year', memberType: 'STUDENT', maxBorrowLimit: 4, registrationDate: '2024-01-10', status: 'ACTIVE' },
        { id: 2, memberId: 'MEM-2024-002', name: 'Md. Amanuddin', email: 'amanuddin@library.edu', phone: '+91 98765 43211', department: 'Computer Science & Engineering', year: '3rd Year', memberType: 'STUDENT', maxBorrowLimit: 4, registrationDate: '2024-01-10', status: 'ACTIVE' },
        { id: 3, memberId: 'MEM-2024-003', name: 'Jashwanth Chowdary', email: 'jashwanth@library.edu', phone: '+91 98765 43212', department: 'Computer Science & Engineering', year: '3rd Year', memberType: 'STUDENT', maxBorrowLimit: 4, registrationDate: '2024-01-12', status: 'ACTIVE' },
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
        { id: 14, bookId: 'BK-1014', isbn: '978-0201633610', title: 'Design Patterns: Elements of Reusable Object-Oriented Software', author: 'Erich Gamma, Richard Helm, Ralph Johnson', category: 'Software Architecture', publisher: 'Addison-Wesley', 1994, language: 'English', description: 'The classic Gang of Four (GoF) catalog of 23 fundamental software engineering design patterns.', shelfNumber: 'CS-B3-06', quantity: 4, availableCopies: 3, status: 'AVAILABLE', coverUrl: 'https://images.unsplash.com/photo-1532012164546-f432f2e3777a?w=400&q=80' },
        { id: 15, bookId: 'BK-1015', isbn: '978-0134092669', title: 'Computer Organization and Architecture', author: 'William Stallings', category: 'Computer Science', publisher: 'Pearson', publicationYear: 2018, language: 'English', description: 'Structure and function of computers, pipelining, cache memory, RISC architectures, and superscalar processors.', shelfNumber: 'CS-E1-04', quantity: 5, availableCopies: 4, status: 'AVAILABLE', coverUrl: 'https://images.unsplash.com/photo-1589829085413-56de8ae18c73?w=400&q=80' },
        { id: 16, bookId: 'BK-1016', isbn: '978-0262033855', title: 'Compilers: Principles, Techniques, and Tools (Dragon Book)', author: 'Alfred V. Aho, Monica S. Lam, Ravi Sethi', category: 'Computer Science', publisher: 'Addison-Wesley', 2006, language: 'English', description: 'Lexical analysis, syntax-directed translation, code optimization, and code generation for compilers.', shelfNumber: 'CS-E2-10', quantity: 3, availableCopies: 2, status: 'AVAILABLE', coverUrl: 'https://images.unsplash.com/photo-1507842229451-7f01be7fe8e6?w=400&q=80' },
        { id: 17, bookId: 'BK-1017', isbn: '978-0132350891', title: 'Head First Design Patterns', author: 'Eric Freeman, Elisabeth Robson', category: 'Software Architecture', publisher: 'O\'Reilly Media', 2020, language: 'English', description: 'A visually rich, brain-friendly guide to design patterns, OOP principles, and loose coupling.', shelfNumber: 'CS-B4-02', quantity: 5, availableCopies: 3, status: 'AVAILABLE', coverUrl: 'https://images.unsplash.com/photo-1497633762265-9d179a990aa6?w=400&q=80' },
        { id: 18, bookId: 'BK-1018', isbn: '978-1449331818', title: 'Learning JavaScript Design Patterns', author: 'Addy Osmani', category: 'Web Development', publisher: 'O\'Reilly Media', 2017, language: 'English', description: 'Explore classical and modern design patterns to write beautiful, structured, and maintainable JavaScript code.', shelfNumber: 'WB-A1-08', quantity: 4, availableCopies: 3, status: 'AVAILABLE', coverUrl: 'https://images.unsplash.com/photo-1524995997946-a1c2e315a42f?w=400&q=80' }
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

class DLMSDatabase {
    constructor() {
        this.data = this.load();
    }

    load() {
        try {
            const raw = localStorage.getItem(DLMS_STORAGE_KEY);
            if (raw) {
                return JSON.parse(raw);
            }
        } catch (e) {
            console.warn('LocalStorage error or unavailable, using in-memory state.', e);
        }
        const clone = JSON.parse(JSON.stringify(INITIAL_DATA));
        this.save(clone);
        return clone;
    }

    save(data = this.data) {
        this.data = data;
        try {
            localStorage.setItem(DLMS_STORAGE_KEY, JSON.stringify(data));
        } catch (e) {
            console.error('Failed to save to localStorage', e);
        }
    }

    reset() {
        localStorage.removeItem(DLMS_STORAGE_KEY);
        this.data = JSON.parse(JSON.stringify(INITIAL_DATA));
        this.save(this.data);
    }

    // ---------------- AUTH & SESSION ----------------
    getCurrentUser() {
        try {
            const u = localStorage.getItem(DLMS_USER_KEY);
            if (u) return JSON.parse(u);
        } catch (e) {}
        // Default to admin for convenience
        return this.data.users[0];
    }

    setCurrentUser(user) {
        localStorage.setItem(DLMS_USER_KEY, JSON.stringify(user));
    }

    login(username, password) {
        const user = this.data.users.find(u => (u.username === username || u.email === username) && u.password === password);
        if (user) {
            this.setCurrentUser(user);
            return { success: true, user };
        }
        return { success: false, message: 'Invalid username or password.' };
    }

    logout() {
        localStorage.removeItem(DLMS_USER_KEY);
    }

    // ---------------- BOOKS ----------------
    getBooks() {
        return this.data.books;
    }

    getBook(idOrBookId) {
        return this.data.books.find(b => b.id == idOrBookId || b.bookId === idOrBookId);
    }

    addBook(book) {
        const nextId = this.data.books.length > 0 ? Math.max(...this.data.books.map(b => b.id)) + 1 : 1;
        const newBookId = 'BK-' + (1000 + nextId);
        const qty = parseInt(book.quantity) || 1;
        const newBook = {
            id: nextId,
            bookId: newBookId,
            isbn: book.isbn || ('978-013' + Math.floor(100000 + Math.random() * 900000)),
            title: book.title.trim(),
            author: book.author.trim(),
            category: book.category || 'General',
            publisher: book.publisher || 'Academic Press',
            publicationYear: parseInt(book.publicationYear) || new Date().getFullYear(),
            language: book.language || 'English',
            description: book.description || '',
            shelfNumber: book.shelfNumber || 'CS-A1-01',
            quantity: qty,
            availableCopies: qty,
            status: qty > 0 ? 'AVAILABLE' : 'OUT_OF_STOCK',
            coverUrl: book.coverUrl || 'https://images.unsplash.com/photo-1544716278-ca5e3f4abd8c?w=400&q=80'
        };
        this.data.books.unshift(newBook);
        this.save();
        return newBook;
    }

    updateBook(id, book) {
        const idx = this.data.books.findIndex(b => b.id == id);
        if (idx !== -1) {
            const current = this.data.books[idx];
            const qty = parseInt(book.quantity) || current.quantity;
            const borrowed = current.quantity - current.availableCopies;
            const newAvail = Math.max(0, qty - borrowed);
            this.data.books[idx] = {
                ...current,
                ...book,
                quantity: qty,
                availableCopies: newAvail,
                status: newAvail > 0 ? 'AVAILABLE' : 'OUT_OF_STOCK'
            };
            this.save();
            return this.data.books[idx];
        }
        return null;
    }

    deleteBook(id) {
        const book = this.getBook(id);
        if (!book) return { success: false, message: 'Book not found' };
        const activeTx = this.data.transactions.find(t => t.bookId === book.bookId && t.status !== 'RETURNED');
        if (activeTx) {
            return { success: false, message: 'Cannot delete volume: Copies are currently issued to patrons.' };
        }
        this.data.books = this.data.books.filter(b => b.id != id);
        this.save();
        return { success: true };
    }

    // ---------------- MEMBERS ----------------
    getMembers() {
        return this.data.members;
    }

    getMember(idOrMemberId) {
        return this.data.members.find(m => m.id == idOrMemberId || m.memberId === idOrMemberId);
    }

    addMember(member) {
        const nextId = this.data.members.length > 0 ? Math.max(...this.data.members.map(m => m.id)) + 1 : 1;
        const newMemberId = 'MEM-2024-' + String(nextId).padStart(3, '0');
        const isFaculty = member.memberType === 'FACULTY';
        const newMember = {
            id: nextId,
            memberId: newMemberId,
            name: member.name.trim(),
            email: member.email.trim(),
            phone: member.phone || '+91 98765 00000',
            department: member.department || 'Computer Science & Engineering',
            year: member.year || (isFaculty ? 'Faculty' : '1st Year'),
            memberType: member.memberType || 'STUDENT',
            maxBorrowLimit: isFaculty ? 8 : 4,
            registrationDate: new Date().toISOString().split('T')[0],
            status: 'ACTIVE'
        };
        this.data.members.push(newMember);
        // Also register a user record for login
        const username = member.email.split('@')[0].toLowerCase().replace(/[^a-z0-9]/g, '');
        this.data.users.push({
            id: this.data.users.length + 1,
            username: username,
            email: member.email,
            password: 'student123',
            role: member.memberType || 'STUDENT',
            memberId: newMemberId,
            status: 'ACTIVE'
        });
        this.save();
        return newMember;
    }

    updateMember(id, member) {
        const idx = this.data.members.findIndex(m => m.id == id);
        if (idx !== -1) {
            this.data.members[idx] = { ...this.data.members[idx], ...member };
            this.save();
            return this.data.members[idx];
        }
        return null;
    }

    toggleMemberStatus(id) {
        const m = this.data.members.find(m => m.id == id);
        if (m) {
            m.status = m.status === 'ACTIVE' ? 'SUSPENDED' : 'ACTIVE';
            this.save();
            return m;
        }
        return null;
    }

    // ---------------- TRANSACTIONS (CIRCULATION) ----------------
    getTransactions() {
        return this.data.transactions.map(t => this.enrichTransaction(t));
    }

    enrichTransaction(t) {
        const book = this.getBook(t.bookId);
        const member = this.getMember(t.memberId);
        const today = new Date().toISOString().split('T')[0];
        const isOverdue = t.status !== 'RETURNED' && t.dueDate < today;
        const daysLate = isOverdue ? Math.max(0, Math.floor((new Date() - new Date(t.dueDate)) / (1000 * 60 * 60 * 24))) : 0;
        return {
            ...t,
            bookTitle: book ? book.title : t.bookId,
            bookCoverUrl: book ? book.coverUrl : '',
            memberName: member ? member.name : t.memberId,
            isOverdue,
            daysOverdue: daysLate
        };
    }

    issueBook({ memberId, bookId, issueDate, dueDate, remarks }) {
        const member = this.getMember(memberId);
        if (!member || member.status !== 'ACTIVE') {
            return { success: false, message: 'Invalid or inactive patron account.' };
        }
        const activeLoans = this.data.transactions.filter(t => t.memberId === memberId && t.status !== 'RETURNED');
        if (activeLoans.length >= member.maxBorrowLimit) {
            return { success: false, message: `Borrowing quota exceeded! Limit is ${member.maxBorrowLimit} books.` };
        }
        const book = this.getBook(bookId);
        if (!book || book.availableCopies <= 0) {
            return { success: false, message: 'This title is currently out of stock.' };
        }

        const nextId = this.data.transactions.length > 0 ? Math.max(...this.data.transactions.map(t => t.id)) + 1 : 1;
        const txId = 'TXN-2024-' + (1000 + nextId);

        const newTx = {
            id: nextId,
            transactionId: txId,
            memberId: member.memberId,
            bookId: book.bookId,
            issueDate: issueDate || new Date().toISOString().split('T')[0],
            dueDate: dueDate || this.calculateDueDate(member.memberType),
            returnDate: null,
            fine: 0.00,
            status: 'ISSUED',
            issuedBy: this.getCurrentUser().username,
            remarks: remarks || 'Issued via Web Portal'
        };

        book.availableCopies -= 1;
        if (book.availableCopies === 0) {
            book.status = 'OUT_OF_STOCK';
        }

        this.data.transactions.unshift(newTx);
        this.save();
        return { success: true, transaction: newTx };
    }

    calculateDueDate(memberType) {
        const days = memberType === 'FACULTY' ? 30 : 14;
        const d = new Date();
        d.setDate(d.getDate() + days);
        return d.toISOString().split('T')[0];
    }

    returnBook(txId, remarks) {
        const tx = this.data.transactions.find(t => t.transactionId === txId || t.id == txId);
        if (!tx || tx.status === 'RETURNED') {
            return { success: false, message: 'Active transaction record not found.' };
        }

        const today = new Date().toISOString().split('T')[0];
        tx.returnDate = today;
        tx.status = 'RETURNED';
        if (remarks) tx.remarks = remarks;

        // Calculate fine if returned late (Rs 5.00 / day)
        if (today > tx.dueDate) {
            const daysLate = Math.max(0, Math.floor((new Date() - new Date(tx.dueDate)) / (1000 * 60 * 60 * 24)));
            const fineAmount = daysLate * 5.00;
            tx.fine = fineAmount;

            const nextFineId = this.data.fines.length > 0 ? Math.max(...this.data.fines.map(f => f.id)) + 1 : 1;
            const newFine = {
                id: nextFineId,
                fineId: 'FN-2024-' + String(nextFineId).padStart(3, '0'),
                transactionId: tx.transactionId,
                memberId: tx.memberId,
                amount: fineAmount,
                daysLate: daysLate,
                status: 'UNPAID',
                paidAt: null,
                paymentMode: null
            };
            this.data.fines.unshift(newFine);
        }

        // Restore book copies
        const book = this.getBook(tx.bookId);
        if (book) {
            book.availableCopies += 1;
            book.status = 'AVAILABLE';
        }

        // Check if there are waitlist reservations for this book
        const pendingRes = this.data.reservations.filter(r => r.bookId === tx.bookId && r.status === 'PENDING');
        let waitlistAlert = null;
        if (pendingRes.length > 0) {
            pendingRes.sort((a, b) => a.queuePosition - b.queuePosition);
            const first = pendingRes[0];
            first.status = 'NOTIFIED';
            waitlistAlert = `Book restored to stock! Next patron in queue notified: ${first.memberId} (Rank #1)`;
        }

        this.save();
        return { success: true, transaction: tx, waitlistAlert };
    }

    // ---------------- FINES ----------------
    getFines() {
        return this.data.fines.map(f => {
            const member = this.getMember(f.memberId);
            const tx = this.data.transactions.find(t => t.transactionId === f.transactionId);
            const book = tx ? this.getBook(tx.bookId) : null;
            return {
                ...f,
                memberName: member ? member.name : f.memberId,
                bookTitle: book ? book.title : 'Overdue Loan'
            };
        });
    }

    payFine(fineId, mode = 'UPI') {
        const fine = this.data.fines.find(f => f.fineId === fineId || f.id == fineId);
        if (fine) {
            fine.status = 'PAID';
            fine.paidAt = new Date().toISOString().replace('T', ' ').substring(0, 19);
            fine.paymentMode = mode;
            this.save();
            return { success: true, fine };
        }
        return { success: false, message: 'Fine record not found.' };
    }

    // ---------------- RESERVATIONS (FIFO QUEUE) ----------------
    getReservations() {
        return this.data.reservations.map(r => {
            const member = this.getMember(r.memberId);
            const book = this.getBook(r.bookId);
            return {
                ...r,
                memberName: member ? member.name : r.memberId,
                bookTitle: book ? book.title : r.bookId
            };
        });
    }

    reserveBook(memberId, bookId) {
        const existing = this.data.reservations.find(r => r.memberId === memberId && r.bookId === bookId && r.status === 'PENDING');
        if (existing) {
            return { success: false, message: `You already have an active reservation at queue rank #${existing.queuePosition}.` };
        }

        const existingQueue = this.data.reservations.filter(r => r.bookId === bookId && r.status === 'PENDING');
        const nextRank = existingQueue.length + 1;
        const nextId = this.data.reservations.length > 0 ? Math.max(...this.data.reservations.map(r => r.id)) + 1 : 1;
        const expiry = new Date();
        expiry.setDate(expiry.getDate() + 30);

        const newRes = {
            id: nextId,
            reservationId: 'RES-2024-' + String(nextId).padStart(3, '0'),
            memberId: memberId,
            bookId: bookId,
            reservationDate: new Date().toISOString().replace('T', ' ').substring(0, 19),
            queuePosition: nextRank,
            status: 'PENDING',
            expiryDate: expiry.toISOString().split('T')[0]
        };

        this.data.reservations.push(newRes);
        this.save();
        return { success: true, reservation: newRes, queuePosition: nextRank };
    }

    cancelReservation(reservationId) {
        const res = this.data.reservations.find(r => r.reservationId === reservationId || r.id == reservationId);
        if (res) {
            res.status = 'CANCELLED';
            // Re-order queue
            const remaining = this.data.reservations.filter(r => r.bookId === res.bookId && r.status === 'PENDING' && r.queuePosition > res.queuePosition);
            remaining.forEach(r => { r.queuePosition -= 1; });
            this.save();
            return { success: true };
        }
        return { success: false, message: 'Reservation not found.' };
    }

    // ---------------- STATS & CHARTS ----------------
    getStats() {
        const totalBooks = this.data.books.reduce((acc, b) => acc + b.quantity, 0);
        const availableBooks = this.data.books.reduce((acc, b) => acc + b.availableCopies, 0);
        const issuedBooks = this.data.transactions.filter(t => t.status === 'ISSUED' || t.status === 'OVERDUE').length;
        const totalMembers = this.data.members.filter(m => m.status === 'ACTIVE').length;
        const today = new Date().toISOString().split('T')[0];
        const overdueBooks = this.data.transactions.filter(t => t.status === 'OVERDUE' || (t.status === 'ISSUED' && t.dueDate < today)).length;
        const unpaidFines = this.data.fines.filter(f => f.status === 'UNPAID').reduce((acc, f) => acc + f.amount, 0);
        const paidFines = this.data.fines.filter(f => f.status === 'PAID').reduce((acc, f) => acc + f.amount, 0);
        const pendingReservations = this.data.reservations.filter(r => r.status === 'PENDING').length;
        const utilizationRate = totalBooks > 0 ? Math.round(((totalBooks - availableBooks) * 100) / totalBooks) : 0;
        const availableRatio = totalBooks > 0 ? Math.round((availableBooks * 100) / totalBooks) : 0;

        const categoryCounts = {};
        this.data.books.forEach(b => {
            categoryCounts[b.category] = (categoryCounts[b.category] || 0) + 1;
        });

        const monthlyTrends = { 'May': 14, 'Jun': 22, 'Jul': 35, 'Aug': 48, 'Sep': 62, 'Oct': 79 };

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
            availableRatio,
            categories: categoryCounts,
            monthlyTrends
        };
    }

    // ---------------- EXPORT TO CSV ----------------
    exportCSV(type) {
        let filename = `dlms_${type}_${new Date().toISOString().split('T')[0]}.csv`;
        let csvContent = 'data:text/csv;charset=utf-8,';

        if (type === 'books') {
            csvContent += 'Book ID,ISBN,Title,Author,Category,Publisher,Year,Shelf,Total Copies,Available Copies,Status\r\n';
            this.data.books.forEach(b => {
                csvContent += `"${b.bookId}","${b.isbn}","${b.title.replace(/"/g, '""')}","${b.author}","${b.category}","${b.publisher}",${b.publicationYear},"${b.shelfNumber}",${b.quantity},${b.availableCopies},"${b.status}"\r\n`;
            });
        } else if (type === 'members') {
            csvContent += 'Member ID,Name,Email,Phone,Department,Year,Type,Limit,Status,Registered\r\n';
            this.data.members.forEach(m => {
                csvContent += `"${m.memberId}","${m.name}","${m.email}","${m.phone}","${m.department}","${m.year}","${m.memberType}",${m.maxBorrowLimit},"${m.status}","${m.registrationDate}"\r\n`;
            });
        } else if (type === 'transactions') {
            csvContent += 'TXN ID,Member ID,Book ID,Issue Date,Due Date,Return Date,Fine,Status,Issued By\r\n';
            this.data.transactions.forEach(t => {
                csvContent += `"${t.transactionId}","${t.memberId}","${t.bookId}","${t.issueDate}","${t.dueDate}","${t.returnDate || ''}",${t.fine},"${t.status}","${t.issuedBy}"\r\n`;
            });
        } else if (type === 'fines') {
            csvContent += 'Fine ID,TXN ID,Member ID,Amount,Days Late,Status,Paid At,Payment Mode\r\n';
            this.data.fines.forEach(f => {
                csvContent += `"${f.fineId}","${f.transactionId}","${f.memberId}",${f.amount},${f.daysLate},"${f.status}","${f.paidAt || ''}","${f.paymentMode || ''}"\r\n`;
            });
        }

        const encodedUri = encodeURI(csvContent);
        const link = document.createElement('a');
        link.setAttribute('href', encodedUri);
        link.setAttribute('download', filename);
        document.body.appendChild(link);
        link.click();
        document.body.removeChild(link);
    }
}

// Global instance
window.db = new DLMSDatabase();

// Toast helper
window.showToast = function (message, type = 'info') {
    let container = document.getElementById('toastContainer');
    if (!container) {
        container = document.createElement('div');
        container.id = 'toastContainer';
        document.body.appendChild(container);
    }

    const toastDiv = document.createElement('div');
    toastDiv.className = `toast align-items-center text-white bg-${type === 'error' ? 'danger' : type} border-0 shadow-lg mb-2`;
    toastDiv.setAttribute('role', 'alert');
    toastDiv.setAttribute('aria-live', 'assertive');
    toastDiv.setAttribute('aria-atomic', 'true');

    toastDiv.innerHTML = `
        <div class="d-flex">
            <div class="toast-body d-flex align-items-center gap-2">
                <i class="bi ${type === 'success' ? 'bi-check-circle-fill' : (type === 'error' ? 'bi-exclamation-triangle-fill' : 'bi-info-circle-fill')} fs-5"></i>
                <span>${message}</span>
            </div>
            <button type="button" class="btn-close btn-close-white me-2 m-auto" data-bs-dismiss="toast" aria-label="Close"></button>
        </div>
    `;

    container.appendChild(toastDiv);
    const bsToast = new bootstrap.Toast(toastDiv, { delay: 4000 });
    bsToast.show();
    toastDiv.addEventListener('hidden.bs.toast', () => toastDiv.remove());
};
