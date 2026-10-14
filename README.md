# Digital Library Management System (DLMS)

**B.Tech Project-Based Learning (PBL) Project — Team No: 1**

[![Java](https://img.shields.io/badge/Java-8%20%2F%2017-ED8B00?logo=openjdk&logoColor=white)](https://www.oracle.com/java/)
[![Servlets](https://img.shields.io/badge/Architecture-MVC%20Servlets-007396?logo=java&logoColor=white)](https://tomcat.apache.org/)
[![Database](https://img.shields.io/badge/Database-MySQL%208.0-4479A1?logo=mysql&logoColor=white)](https://www.mysql.com/)
[![Frontend](https://img.shields.io/badge/Frontend-Bootstrap%205%20%7C%20Glassmorphism-7952B3?logo=bootstrap&logoColor=white)](https://getbootstrap.com/)
[![Charts](https://img.shields.io/badge/Charts-Chart.js-FF6384?logo=chartdotjs&logoColor=white)](https://www.chartjs.org/)
[![Deploy to GitHub Pages](https://img.shields.io/badge/Deploy-GitHub%20Pages-22C55E?logo=github&logoColor=white)](DEPLOY_GITHUB.md)

> 🌐 **Live Demo on GitHub Pages**: Once pushed to GitHub, your project runs 100% natively at `https://<YOUR_USERNAME>.github.io/<YOUR_REPO_NAME>/`. See [DEPLOY_GITHUB.md](DEPLOY_GITHUB.md) for 1-click deployment instructions.

---

## 👥 Project Team Details

| Roll / Member ID | Name | Role & Core Responsibilities |
| :--- | :--- | :--- |
| **MEM-2024-001** | **Md. Amanuddin** | System Architecture, Java Servlets MVC Controller, JDBC Layer, Fine & Waitlist Algorithms |
| **MEM-2024-002** | **Jashwanth Chowdary** | Frontend UI/UX, Minimalist Design System, Chart.js Visualizations, Patron Portal Workflows |

---

## 📌 Executive Summary

The **Digital Library Management System (DLMS)** is an end-to-end web application developed to modernize paper-based academic library operations into a streamlined, high-performance digital platform. 

Unlike basic CRUD projects, DLMS implements an enterprise **Model-View-Controller (MVC)** architecture with **Java Servlets**, **JSP**, **JDBC PreparedStatement security**, and **MySQL**. It features real-time inventory synchronization, automated loan calculations, fine management with multi-mode payment tracking, a **First-Come, First-Served (FIFO) waitlist queue**, and an interactive **Chart.js** analytics dashboard backed by live database aggregations.

---

## 🚀 Key Features

### 🛡️ For Administrators / Librarians
- **Secure Authentication:** Role-based access control (RBAC) with SHA-256 encrypted passwords.
- **Real-Time Analytics Dashboard:** 6 animated metric counters and 4 dynamic Chart.js visualizations (Books Overview, Circulation Trends, Categories Breakdown, Fines Collection Audit).
- **Comprehensive Book Management:** Add, edit, delete, search, filter by subject category, sort by multiple columns, and switch between dual Table and Card Grid views.
- **Patron Management:** Manage Students, Faculty, and Research Scholars with polymorphic borrowing privileges and automatic account creation.
- **Automated Issue Workflow:** Validates patron active status, enforces quota limits (4 for students, 8 for faculty), verifies available copies, and auto-schedules due dates.
- **Return & Fine Engine:** Detects overdue returns, calculates fines at ₹5.00/day, restores copy stock, and alerts patrons in the waitlist queue.
- **Fine Reconciliation:** Track unpaid fees and process payments via UPI, Cash, Card, or Waiver.
- **Waitlist Queue Monitoring:** View patron positions in the reservation queue.
- **Audit & Export:** Live circulation history and one-click **CSV data exports** for Books, Members, Transactions, and Fines.

### 🎓 For Students & Faculty
- **Dedicated Patron Portal:** Personalized dashboard displaying borrowed volumes and due date countdowns.
- **Online Catalog Search:** Search volumes by title, author, or ISBN; view real-time shelf location and availability.
- **Waitlist Reservations:** Reserve unavailable or out-of-stock titles with automatic FIFO queue rank assignment.
- **Due Date Reminders & Alerts:** Visual indicators for books due soon or overdue.
- **Fines & Ledger:** Complete transparent ledger of outstanding dues and payment receipts.
- **Circulation History:** Full log of past borrowing records.
- **Profile & Security:** View membership parameters and update passwords securely.

---

## 🏛️ System Architecture (MVC)

The project strictly follows the **Model-View-Controller (MVC)** architectural design pattern:

```
                          HTTP Request (Browser)
                                    │
                                    ▼
                     ┌──────────────────────────────┐
                     │          CONTROLLER          │
                     │  (Java Servlets: AuthFilter, │
                     │   BookServlet, IssueServlet, │
                     │     AdminDashboardServlet)   │
                     └──────────────┬───────────────┘
                                    │
              Dispatches Business   │   Populates Attributes
                    Logic           │       for Rendering
                                    ▼             │
                     ┌────────────────────────┐   │
                     │        SERVICE         │   │
                     │ (IssueReturnService,   │   │
                     │  BookService, etc.)    │   │
                     └──────────┬─────────────┘   │
                                │                 │
                       Database │                 │
                      Operations│                 │
                                ▼                 │
                     ┌────────────────────┐       │
                     │     DAO LAYER      │       │
                     │ (PreparedStatement │       │
                     │  CRUD Operations)  │       │
                     └──────────┬─────────┘       │
                                │                 │
                        Queries │                 │
                                ▼                 ▼
       ┌───────────────────────────────┐   ┌─────────────────────────────┐
       │           DATABASE            │   │            VIEW             │
       │  MySQL (library_management)   │   │  (JSP, Bootstrap 5, CSS3,   │
       │  Tables: users, books,        │   │   Chart.js, Glassmorphism)  │
       │  members, transactions, etc.  │   └─────────────────────────────┘
       └───────────────────────────────┘
```

---

## 🎓 Object-Oriented Programming (OOP) Principles Demonstrated

This project is tailored for academic viva defense, demonstrating core Java OOP principles:

1. **Encapsulation:**
   - All Model classes (`Book`, `Member`, `Transaction`, `User`, `Fine`, `Reservation`) use `private` member fields exposed only through validated getters and setters.
   - Database connection parameters are encapsulated within `DatabaseConnection` and `AppConfig`.

2. **Abstraction:**
   - The base class `Member` is declared `abstract`, hiding implementation specifics while exposing abstract contracts:
     ```java
     public abstract int getAllowedBorrowDays();
     public abstract double calculateFineRate(double baseFineRate);
     public abstract String getRoleDescription();
     ```

3. **Inheritance:**
   - `Student` and `Faculty` inherit from `Member`:
     - `Student extends Member` (Standard 14-day borrowing period, 4 books quota).
     - `Faculty extends Member` (Extended 30-day research borrowing period, 8 books quota).

4. **Polymorphism:**
   - **Method Overriding:** Both `Student` and `Faculty` provide concrete overrides for `getAllowedBorrowDays()` and `calculateFineRate()`.
   - **Dynamic Method Dispatch:** When issuing a book, `IssueReturnService` invokes `member.getAllowedBorrowDays()`. Java resolves the appropriate loan window at runtime based on the patron object's concrete type without messy `if-else` type inspections.

---

## 📊 Data Structures & Algorithms (DSA) Demonstrated

The application demonstrates practical applications of classical data structures:

| Data Structure | Implementation in DLMS | Real-world Purpose |
| :--- | :--- | :--- |
| **`ArrayList`** | `List<Book>`, `List<Transaction>` in DAO layer | Dynamic, indexed in-memory catalog storage and pagination display. |
| **`HashMap`** | `BookDAO.getBookIdMap()`, `MemberDAO.getMemberIdMap()` | Fast $O(1)$ constant-time lookup by unique alphanumeric identifier (`BK-1001`, `MEM-2024-001`). |
| **`Queue` (FIFO)** | `Queue<Reservation> = new LinkedList<>()` | First-Come, First-Served waitlist ordering for reserved out-of-stock titles. First patron in queue gets priority upon return. |
| **`Stack` (LIFO)** | `Stack<Transaction>` in `TransactionDAO.getRecentActivitiesStack()` | Last-In, First-Out retrieval of most recent circulation actions for real-time dashboard activity feeds. |

---

## 📂 Project Folder Structure

```
aman_pbl/
├── pom.xml                               # Maven project descriptor & dependencies
├── mvnw.cmd                              # Maven Wrapper for Windows
├── database.sql                          # Complete MySQL schema & seed data
├── README.md                             # Documentation & Setup guide
├── .vscode/
│   ├── launch.json                       # VS Code run & debug configuration
│   ├── tasks.json                        # VS Code compile and build tasks
│   └── extensions.json                   # Recommended VS Code extensions
└── src/
    └── main/
        ├── java/com/dlms/
        │   ├── controller/               # MVC Servlets (Auth, Books, Issue, Admin, Student)
        │   ├── dao/                      # Data Access Objects (JDBC PreparedStatements)
        │   ├── model/                    # OOP Entities (Book, Member, Student, Faculty, etc.)
        │   ├── service/                  # Business Logic & Circulation validation
        │   ├── exception/                # Custom Exceptions (BookNotAvailable, QuotaLimit, etc.)
        │   └── util/                     # DatabaseConnection, PasswordHasher, DateUtils
        ├── resources/
        │   └── db.properties             # External configuration (DB URL, fine rate, quotas)
        └── webapp/
            ├── WEB-INF/
            │   └── web.xml               # Deployment descriptor & error pages
            ├── assets/
            │   ├── css/style.css         # Custom modern design system & dark mode
            │   └── js/                   # Core UI, Theme toggle, Chart.js loader
            ├── includes/                 # Header, Footer, Topbar, Sidebars, Modals
            ├── admin/                    # Admin Dashboard, Books, Members, Circulation, Reports
            ├── student/                  # Student Portal, Catalog Browse, Fines, Reservations
            ├── index.jsp                 # Landing page
            ├── login.jsp                 # Authentication page
            ├── error-404.jsp             # Friendly 404 page
            └── error-500.jsp             # Friendly 500 error page
```

---

## 🛠️ Technology Stack

- **Backend:** Java 8 / 11 / 17, Java Servlets (JSR 369), JSP, JSTL 1.2
- **Database:** MySQL 8.0+ / MariaDB via JDBC Connector/J 8.0.33
- **Server:** Apache Tomcat 8.5+ / 9.0+ / 10.1+ (or embedded `tomcat7-maven-plugin`)
- **Frontend:** HTML5, CSS3, Bootstrap 5.3, Bootstrap Icons, Google Fonts (Plus Jakarta Sans, Inter)
- **Visualizations:** Chart.js 4.4
- **Security:** SHA-256 Password Hashing, Session Management, PreparedStatement SQL Sanitization

---

## 🗄️ Database Setup Instructions

1. Start your local **MySQL Server** (via MySQL Workbench, Command Line, or XAMPP/WAMP).
2. Open a terminal or MySQL shell and execute:
   ```sql
   source /path/to/database.sql;
   ```
   *Or in PowerShell / Command Prompt:*
   ```powershell
   mysql -u root -p < database.sql
   ```
3. This creates the database `library_management`, generates 7 tables (`users`, `books`, `members`, `transactions`, `reservations`, `fines`, `notifications`) with foreign key constraints and indexes, and inserts seed data (18 books, 9 members, transactions, and initial accounts).

4. **Configure Credentials:**
   Open `src/main/resources/db.properties` and verify your MySQL password:
   ```properties
   db.url=jdbc:mysql://localhost:3306/library_management?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC
   db.username=root
   db.password=your_mysql_password
   ```

---

## 💻 How to Run Locally in VS Code

### Option 1: Using Maven Command (Recommended)
1. Open the project folder in **VS Code**:
   ```bash
   code .
   ```
2. Open the built-in terminal in VS Code (`Ctrl + ~`).
3. Run the embedded Tomcat server via Maven:
   ```bash
   mvn tomcat7:run
   ```
   *(Or using the included wrapper on Windows:)*
   ```powershell
   .\mvnw.cmd tomcat7:run
   ```
4. Open your web browser and navigate to:
   ```
   http://localhost:8080/library
   ```

### Option 2: Using Standalone Apache Tomcat
1. Build the production WAR package:
   ```bash
   mvn clean package
   ```
2. Copy the generated `target/library.war` file into your Apache Tomcat `webapps/` directory:
   ```
   C:\apache-tomcat-9.x.x\webapps\library.war
   ```
3. Start Tomcat via `bin/startup.bat`.
4. Navigate to `http://localhost:8080/library`.

### Option 3: Using VS Code "Community Server Connectors" / "Tomcat for Java"
1. Install the **Extension Pack for Java** and **Community Server Connectors** extensions in VS Code.
2. In the "Servers" pane, add your local Apache Tomcat server.
3. Right-click the server and choose **Add Deployment** -> select the `target/library.war` or webapp folder.
4. Click **Start Server** and navigate to `http://localhost:8080/library`.

---

## 🔑 Default Login Credentials

For demonstration and testing during evaluation, use these default accounts:

| Portal | Username | Password | Role | Description |
| :--- | :--- | :--- | :--- | :--- |
| **Admin Portal** | `admin` | `admin123` | `ADMIN` | Full administrative control, catalog CRUD, reports |
| **Librarian** | `librarian` | `admin123` | `LIBRARIAN` | Circulation desk checkout, check-in, fines collection |
| **Student** | `aman` | `student123` | `STUDENT` | Patron catalog browse, loan status, queue reservations |
| **Student** | `jashwanth` | `student123` | `STUDENT` | Patron account |
| **Faculty** | `drrajesh` | `student123` | `FACULTY` | Faculty research account (8 books quota, 30 days) |

*(Note: The login page includes convenient **1-Click Demo Credential Fillers** for live viva presentation).*

---

## 🧪 Comprehensive Testing Scenarios

1. **Authentication & Role Security:**
   - Log in as `admin` -> verifies redirect to `/admin/dashboard`.
   - Log in as `aman` -> verifies redirect to `/student/dashboard`.
   - Try accessing `/admin/dashboard` as student -> access denied by `AuthFilter`.
2. **Book Catalog CRUD & Search:**
   - Add a new book -> verifies instant insertion in MySQL and visibility in catalog.
   - Filter by category ("Computer Science") or search by author.
   - Switch between **Table View** and **Card Grid View**.
3. **Circulation Issue & Quota Enforcement:**
   - Issue an available volume to a member. Observe available copy count decrements by 1.
   - Try issuing an out-of-stock title -> system throws and displays `BookNotAvailableException`.
4. **Circulation Return & Automated Fine Assessment:**
   - Select an overdue transaction to return -> system calculates overdue days $\times$ ₹5.00.
   - Click confirm -> status changes to `RETURNED`, book stock increments by 1, and fine is recorded.
5. **Waitlist Queue (FIFO Queue):**
   - In Student portal, find an out-of-stock volume and click "Reserve Waitlist".
   - System places the patron in the waitlist queue with rank #1 or #2.
6. **Reporting & Data Export:**
   - Navigate to `/admin/reports` -> review metrics.
   - Click "Export Books Dataset (CSV)" -> downloads complete CSV spreadsheet.

---

## 🚀 Future Enhancements

As outlined in our project proposal, future development milestones include:
1. **SMS & Email Notifications:** Automated reminder emails 48 hours before due date via JavaMail API.
2. **Barcode / QR Code Scanning:** Fast checkout scanning using physical USB barcode readers or webcam scanning.
3. **Integrated Online Payment Gateway:** Razorpay / Stripe integration for instant digital fine settlement.
4. **Digital Repository (E-Books & PDFs):** In-browser PDF reader for institutional digital research papers.
5. **Mobile Companion Application:** Android / iOS cross-platform patron app built with Flutter.

---

**Digital Library Management System** | B.Tech PBL Submission | Team No: 1
