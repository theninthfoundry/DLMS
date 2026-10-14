<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="pageTitle" value="DLMS - Digital Library Management System" />
<jsp:include page="/includes/header.jsp" />

<!-- Public Landing Navigation Bar -->
<nav class="navbar navbar-expand-lg fixed-top py-3" style="background: rgba(15, 23, 42, 0.9); backdrop-filter: blur(16px); border-bottom: 1px solid rgba(255, 255, 255, 0.08);">
    <div class="container">
        <a class="navbar-brand d-flex align-items-center gap-2 text-white fw-bold" href="#">
            <div class="rounded-3 p-2 d-flex align-items-center justify-content-center" style="background: var(--dlms-gradient-primary); width: 38px; height: 38px;">
                <i class="bi bi-book-half text-white fs-5"></i>
            </div>
            <span>DLMS<span class="text-cyan" style="color: #06B6D4;">.EDU</span></span>
        </a>
        <button class="navbar-toggler border-0 text-white" type="button" data-bs-toggle="collapse" data-bs-target="#landingNavbar">
            <i class="bi bi-list fs-2"></i>
        </button>
        <div class="collapse navbar-collapse" id="landingNavbar">
            <ul class="navbar-nav mx-auto mb-2 mb-lg-0 gap-lg-3">
                <li class="nav-item"><a class="nav-link text-white-50 hover-text-white" href="#features">Features</a></li>
                <li class="nav-item"><a class="nav-link text-white-50 hover-text-white" href="#how-it-works">How It Works</a></li>
                <li class="nav-item"><a class="nav-link text-white-50 hover-text-white" href="#statistics">Statistics</a></li>
                <li class="nav-item"><a class="nav-link text-white-50 hover-text-white" href="#about">About Library</a></li>
                <li class="nav-item"><a class="nav-link text-white-50 hover-text-white" href="#team">Team</a></li>
            </ul>
            <div class="d-flex align-items-center gap-2">
                <a href="${pageContext.request.contextPath}/login?role=STUDENT" class="btn btn-outline-light rounded-pill px-3 py-2 fw-semibold">
                    <i class="bi bi-mortarboard me-1"></i> Student Login
                </a>
                <a href="${pageContext.request.contextPath}/login?role=ADMIN" class="btn btn-gradient-primary rounded-pill px-4 py-2">
                    <i class="bi bi-shield-lock me-1"></i> Admin Login
                </a>
            </div>
        </div>
    </div>
</nav>

<!-- HERO SECTION -->
<section class="hero-section text-center text-lg-start position-relative">
    <div class="hero-glow-1"></div>
    <div class="hero-glow-2"></div>
    <div class="container pt-4">
        <div class="row align-items-center min-vh-75 py-5">
            <div class="col-lg-7 mb-5 mb-lg-0">
                <div class="d-inline-flex align-items-center gap-2 px-3 py-1 rounded-pill mb-4" style="background: rgba(6, 182, 212, 0.15); border: 1px solid rgba(6, 182, 212, 0.3);">
                    <i class="bi bi-stars text-cyan" style="color: #06B6D4;"></i>
                    <span class="text-white small fw-medium">Next-Generation Academic Library Suite</span>
                </div>
                <h1 class="display-3 fw-extrabold text-white mb-3" style="line-height: 1.15; letter-spacing: -0.03em;">
                    Your Library.<br>
                    <span style="background: linear-gradient(135deg, #60A5FA 0%, #22D3EE 100%); -webkit-background-clip: text; background-clip: text; -webkit-text-fill-color: transparent;">
                        Smarter. Faster. Digital.
                    </span>
                </h1>
                <p class="lead text-white-50 mb-4 pe-lg-5 fs-5">
                    Discover, manage and track your library resources with a modern digital library management platform. Automated circulation, instant waitlist queues, and real-time fine calculation.
                </p>
                <div class="d-flex flex-wrap gap-3 justify-content-center justify-content-lg-start">
                    <a href="${pageContext.request.contextPath}/login?role=STUDENT" class="btn btn-gradient-primary btn-lg px-4 py-3 shadow-lg">
                        <i class="bi bi-search me-2"></i> Explore Library
                    </a>
                    <a href="${pageContext.request.contextPath}/login?role=STUDENT" class="btn btn-outline-light btn-lg px-4 py-3 rounded-3">
                        <i class="bi bi-person-circle me-2"></i> Student Login
                    </a>
                    <a href="${pageContext.request.contextPath}/login?role=ADMIN" class="btn btn-navy btn-lg px-4 py-3 rounded-3 border border-secondary">
                        <i class="bi bi-key me-2"></i> Admin Login
                    </a>
                </div>

                <div class="d-flex align-items-center gap-4 mt-5 pt-3 border-top border-white-10">
                    <div class="d-flex align-items-center gap-2">
                        <i class="bi bi-check-circle-fill text-success fs-5"></i>
                        <span class="text-white-50 small">Java MVC Servlets & JDBC</span>
                    </div>
                    <div class="d-flex align-items-center gap-2">
                        <i class="bi bi-check-circle-fill text-success fs-5"></i>
                        <span class="text-white-50 small">Production MySQL Schema</span>
                    </div>
                    <div class="d-flex align-items-center gap-2">
                        <i class="bi bi-check-circle-fill text-success fs-5"></i>
                        <span class="text-white-50 small">OOP & DSA Architecture</span>
                    </div>
                </div>
            </div>

            <!-- Animated Visual Library Illustration Cards -->
            <div class="col-lg-5 position-relative">
                <div class="p-4 rounded-4 shadow-2xl position-relative floating-card" style="background: rgba(30, 41, 59, 0.7); backdrop-filter: blur(20px); border: 1px solid rgba(255, 255, 255, 0.12);">
                    <div class="d-flex align-items-center justify-content-between mb-4">
                        <div class="d-flex align-items-center gap-2">
                            <div class="rounded-circle bg-danger" style="width: 10px; height: 10px;"></div>
                            <div class="rounded-circle bg-warning" style="width: 10px; height: 10px;"></div>
                            <div class="rounded-circle bg-success" style="width: 10px; height: 10px;"></div>
                        </div>
                        <span class="badge bg-primary px-3 py-1 rounded-pill small">Live Circulation</span>
                    </div>

                    <!-- Book Spotlight Card Inside Glass -->
                    <div class="p-3 rounded-3 mb-3" style="background: rgba(15, 23, 42, 0.8); border: 1px solid rgba(255, 255, 255, 0.08);">
                        <div class="d-flex gap-3 align-items-center">
                            <img src="https://images.unsplash.com/photo-1532012164546-f432f2e3777a?w=400&q=80" alt="CLRS" class="rounded-3 shadow" style="width: 60px; height: 80px; object-fit: cover;">
                            <div>
                                <span class="badge badge-soft-info mb-1" style="font-size: 0.7rem;">Computer Science</span>
                                <h6 class="text-white mb-0 fw-bold">Introduction to Algorithms (CLRS)</h6>
                                <small class="text-white-50">Thomas H. Cormen • Shelf CS-A1-04</small>
                                <div class="mt-2 d-flex align-items-center gap-2">
                                    <span class="badge badge-soft-success" style="font-size: 0.7rem;"><i class="bi bi-check2-circle me-1"></i>3 Copies Available</span>
                                    <small class="text-cyan" style="color: #22D3EE;">#BK-1001</small>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Waitlist Activity Card -->
                    <div class="p-3 rounded-3 mb-3" style="background: rgba(15, 23, 42, 0.8); border: 1px solid rgba(255, 255, 255, 0.08);">
                        <div class="d-flex align-items-center justify-content-between">
                            <div class="d-flex align-items-center gap-2">
                                <i class="bi bi-hourglass-split text-warning fs-4"></i>
                                <div>
                                    <div class="text-white fw-semibold small">Queue Waitlist Active</div>
                                    <small class="text-white-50">FIFO Queue Position #1 Notified</small>
                                </div>
                            </div>
                            <span class="badge bg-warning text-dark fw-bold">Auto Dispatched</span>
                        </div>
                    </div>

                    <!-- Dynamic Metrics Preview -->
                    <div class="row g-2">
                        <div class="col-6">
                            <div class="p-2 rounded-3 text-center" style="background: rgba(37, 99, 235, 0.15); border: 1px solid rgba(37, 99, 235, 0.3);">
                                <small class="text-white-50 d-block">Loan Duration</small>
                                <strong class="text-white fs-5">14 Days</strong>
                            </div>
                        </div>
                        <div class="col-6">
                            <div class="p-2 rounded-3 text-center" style="background: rgba(16, 185, 129, 0.15); border: 1px solid rgba(16, 185, 129, 0.3);">
                                <small class="text-white-50 d-block">Fine Policy</small>
                                <strong class="text-white fs-5">₹5.00 / day</strong>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</section>

<!-- FEATURES SECTION -->
<section id="features" class="py-6 bg-light" style="padding: 5rem 0;">
    <div class="container">
        <div class="text-center max-w-700 mx-auto mb-5">
            <span class="badge badge-soft-info px-3 py-1 mb-2 fw-semibold text-uppercase">Enterprise Features</span>
            <h2 class="display-6 fw-bold">Built for Modern Academic Excellence</h2>
            <p class="text-muted">Designed to streamline campus cataloging, circulation auditing, and patron experience.</p>
        </div>

        <div class="row g-4">
            <div class="col-md-4">
                <div class="glass-card p-4 h-100 card-hover-lift">
                    <div class="rounded-3 p-3 d-inline-flex mb-3" style="background: rgba(37, 99, 235, 0.1); color: var(--dlms-blue); font-size: 1.8rem;">
                        <i class="bi bi-book"></i>
                    </div>
                    <h5 class="fw-bold mb-2">📚 Smart Book Management</h5>
                    <p class="text-muted small">Complete catalog lifecycle with ISBN tracking, category tags, shelf location assignment, and automatic copy count recalculation.</p>
                </div>
            </div>
            <div class="col-md-4">
                <div class="glass-card p-4 h-100 card-hover-lift">
                    <div class="rounded-3 p-3 d-inline-flex mb-3" style="background: rgba(6, 182, 212, 0.1); color: var(--dlms-cyan); font-size: 1.8rem;">
                        <i class="bi bi-search"></i>
                    </div>
                    <h5 class="fw-bold mb-2">🔍 Powerful Search</h5>
                    <p class="text-muted small">Instant multi-column search across Book ID, ISBN, Title, Author, and Category with database-level indexed querying.</p>
                </div>
            </div>
            <div class="col-md-4">
                <div class="glass-card p-4 h-100 card-hover-lift">
                    <div class="rounded-3 p-3 d-inline-flex mb-3" style="background: rgba(16, 185, 129, 0.1); color: var(--dlms-success); font-size: 1.8rem;">
                        <i class="bi bi-arrow-left-right"></i>
                    </div>
                    <h5 class="fw-bold mb-2">📖 Easy Issue & Return</h5>
                    <p class="text-muted small">Single-click checkout workflow verifying active member credentials, quota limits, and automatic due date scheduling.</p>
                </div>
            </div>
            <div class="col-md-4">
                <div class="glass-card p-4 h-100 card-hover-lift">
                    <div class="rounded-3 p-3 d-inline-flex mb-3" style="background: rgba(245, 158, 11, 0.1); color: var(--dlms-warning); font-size: 1.8rem;">
                        <i class="bi bi-clock-history"></i>
                    </div>
                    <h5 class="fw-bold mb-2">⏰ Due Date Tracking</h5>
                    <p class="text-muted small">Polymorphic loan rules giving students 14 days and faculty 30 days, with visual overdue badges and alerts.</p>
                </div>
            </div>
            <div class="col-md-4">
                <div class="glass-card p-4 h-100 card-hover-lift">
                    <div class="rounded-3 p-3 d-inline-flex mb-3" style="background: rgba(239, 68, 68, 0.1); color: var(--dlms-danger); font-size: 1.8rem;">
                        <i class="bi bi-currency-rupee"></i>
                    </div>
                    <h5 class="fw-bold mb-2">💰 Automatic Fine Calculation</h5>
                    <p class="text-muted status">Automated late fee auditing multiplying overdue days by configurable rates, supporting Cash, UPI, and Card reconciliation.</p>
                </div>
            </div>
            <div class="col-md-4">
                <div class="glass-card p-4 h-100 card-hover-lift">
                    <div class="rounded-3 p-3 d-inline-flex mb-3" style="background: rgba(147, 51, 234, 0.1); color: #9333EA; font-size: 1.8rem;">
                        <i class="bi bi-pie-chart"></i>
                    </div>
                    <h5 class="fw-bold mb-2">📊 Intelligent Reports</h5>
                    <p class="text-muted small">Live analytics powered by Chart.js, real SQL aggregations, printable reports, and full CSV data export capabilities.</p>
                </div>
            </div>
        </div>
    </div>
</section>

<!-- HOW IT WORKS SECTION -->
<section id="how-it-works" class="py-6" style="padding: 5rem 0;">
    <div class="container">
        <div class="text-center max-w-700 mx-auto mb-5">
            <span class="badge badge-soft-info px-3 py-1 mb-2 fw-semibold text-uppercase">Workflow</span>
            <h2 class="display-6 fw-bold">How It Works</h2>
            <p class="text-muted">A streamlined 4-step workflow designed for librarians and students.</p>
        </div>

        <div class="row g-4 text-center">
            <div class="col-md-3">
                <div class="p-4 rounded-4 bg-white border border-slate-200 shadow-sm h-100">
                    <div class="rounded-circle bg-primary text-white d-flex align-items-center justify-content-center mx-auto mb-3 fw-bold fs-4" style="width: 56px; height: 56px;">1</div>
                    <h5 class="fw-bold">Step 1: Search</h5>
                    <p class="text-muted small">Search the digital catalogue by title, author, or discipline to check real-time availability.</p>
                </div>
            </div>
            <div class="col-md-3">
                <div class="p-4 rounded-4 bg-white border border-slate-200 shadow-sm h-100">
                    <div class="rounded-circle bg-info text-white d-flex align-items-center justify-content-center mx-auto mb-3 fw-bold fs-4" style="width: 56px; height: 56px;">2</div>
                    <h5 class="fw-bold">Step 2: Borrow</h5>
                    <p class="text-muted small">Instant issue with quota verification or automated FIFO queue placement if copy is on loan.</p>
                </div>
            </div>
            <div class="col-md-3">
                <div class="p-4 rounded-4 bg-white border border-slate-200 shadow-sm h-100">
                    <div class="rounded-circle bg-warning text-white d-flex align-items-center justify-content-center mx-auto mb-3 fw-bold fs-4" style="width: 56px; height: 56px;">3</div>
                    <h5 class="fw-bold">Step 3: Track</h5>
                    <p class="text-muted small">Patrons monitor due dates and queue rank from their personal student dashboard.</p>
                </div>
            </div>
            <div class="col-md-3">
                <div class="p-4 rounded-4 bg-white border border-slate-200 shadow-sm h-100">
                    <div class="rounded-circle bg-success text-white d-flex align-items-center justify-content-center mx-auto mb-3 fw-bold fs-4" style="width: 56px; height: 56px;">4</div>
                    <h5 class="fw-bold">Step 4: Return</h5>
                    <p class="text-muted small">Seamless return with automatic fee calculation, inventory replenishment, and waitlist notice.</p>
                </div>
            </div>
        </div>
    </div>
</section>

<!-- LIVE DATABASE COUNTERS SECTION -->
<section id="statistics" class="py-5" style="background: var(--dlms-navy); color: #FFFFFF;">
    <div class="container py-4">
        <div class="row g-4 text-center">
            <div class="col-6 col-md-3">
                <div class="p-3">
                    <div class="display-5 fw-extrabold text-cyan animated-counter" data-target="1250" style="color: #06B6D4;">1,250</div>
                    <div class="text-white-50 mt-1 fw-medium">Total Books</div>
                </div>
            </div>
            <div class="col-6 col-md-3">
                <div class="p-3">
                    <div class="display-5 fw-extrabold text-white animated-counter" data-target="450">450</div>
                    <div class="text-white-50 mt-1 fw-medium">Active Members</div>
                </div>
            </div>
            <div class="col-6 col-md-3">
                <div class="p-3">
                    <div class="display-5 fw-extrabold text-warning animated-counter" data-target="320">320</div>
                    <div class="text-white-50 mt-1 fw-medium">Books Issued</div>
                </div>
            </div>
            <div class="col-6 col-md-3">
                <div class="p-3">
                    <div class="display-5 fw-extrabold text-success animated-counter" data-target="930">930</div>
                    <div class="text-white-50 mt-1 fw-medium">Books Available</div>
                </div>
            </div>
        </div>
    </div>
</section>

<!-- ABOUT LIBRARY SECTION -->
<section id="about" class="py-6" style="padding: 5rem 0;">
    <div class="container">
        <div class="row align-items-center g-5">
            <div class="col-lg-6">
                <img src="https://images.unsplash.com/photo-1521587760476-6c12a4b040da?w=800&q=80" alt="Modern Library" class="img-fluid rounded-4 shadow-lg">
            </div>
            <div class="col-lg-6">
                <span class="badge badge-soft-info px-3 py-1 mb-2 fw-semibold text-uppercase">About DLMS</span>
                <h2 class="display-6 fw-bold mb-3">Empowering Engineering Research & Academic Curiosity</h2>
                <p class="text-muted">
                    Traditional paper-based registers and fragmented library systems create administrative bottlenecks, delayed returns, and lost circulation audit trails.
                </p>
                <p class="text-muted">
                    The <strong>Digital Library Management System (DLMS)</strong> transforms collegiate resource sharing by combining Java Enterprise MVC architecture, resilient MySQL transactions, and a reactive modern user interface.
                </p>
                <div class="row g-3 mt-2">
                    <div class="col-sm-6">
                        <div class="d-flex align-items-center gap-2">
                            <i class="bi bi-shield-check text-primary fs-4"></i>
                            <span class="fw-semibold">Role-Based Security</span>
                        </div>
                    </div>
                    <div class="col-sm-6">
                        <div class="d-flex align-items-center gap-2">
                            <i class="bi bi-diagram-3 text-info fs-4"></i>
                            <span class="fw-semibold">Polymorphic Quotas</span>
                        </div>
                    </div>
                    <div class="col-sm-6">
                        <div class="d-flex align-items-center gap-2">
                            <i class="bi bi-layers text-success fs-4"></i>
                            <span class="fw-semibold">FIFO Waitlist Queues</span>
                        </div>
                    </div>
                    <div class="col-sm-6">
                        <div class="d-flex align-items-center gap-2">
                            <i class="bi bi-download text-warning fs-4"></i>
                            <span class="fw-semibold">Instant CSV Data Exports</span>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</section>

<!-- TEAM INFORMATION SECTION -->
<section id="team" class="py-6 bg-light" style="padding: 5rem 0;">
    <div class="container">
        <div class="text-center max-w-700 mx-auto mb-5">
            <span class="badge badge-soft-info px-3 py-1 mb-2 fw-semibold text-uppercase">B.Tech PBL Project</span>
            <h2 class="display-6 fw-bold">Project Team</h2>
            <p class="text-muted">Digital Library Management System | <strong>Team No: 1</strong></p>
        </div>

        <div class="row g-4 justify-content-center">
            <div class="col-md-5">
                <div class="glass-card p-4 text-center h-100 card-hover-lift">
                    <div class="rounded-circle bg-info text-white d-flex align-items-center justify-content-center mx-auto mb-3 fw-bold fs-3 shadow" style="width: 72px; height: 72px;">
                        MA
                    </div>
                    <h5 class="fw-bold mb-1">Md. Amanuddin</h5>
                    <p class="text-info small fw-semibold mb-2">Team Member 1 (MEM-2024-001)</p>
                    <p class="text-muted small">System Architecture, Java Servlets MVC Controllers, JDBC PreparedStatement, Fine & Queue Logic.</p>
                </div>
            </div>
            <div class="col-md-5">
                <div class="glass-card p-4 text-center h-100 card-hover-lift">
                    <div class="rounded-circle bg-navy text-white d-flex align-items-center justify-content-center mx-auto mb-3 fw-bold fs-3 shadow" style="background: var(--dlms-navy); width: 72px; height: 72px;">
                        JC
                    </div>
                    <h5 class="fw-bold mb-1">Jashwanth Chowdary</h5>
                    <p class="text-dark small fw-semibold mb-2">Team Member 2 (MEM-2024-002)</p>
                    <p class="text-muted small">Modern Frontend UI/UX, Minimalist Styling, Chart.js Data Visualizations, Patron Portal Workflows.</p>
                </div>
            </div>
        </div>
    </div>
</section>

<!-- FOOTER -->
<footer class="py-5" style="background: var(--dlms-navy-dark); color: #94A3B8; border-top: 1px solid rgba(255,255,255,0.06);">
    <div class="container">
        <div class="row g-4 mb-4">
            <div class="col-lg-4">
                <div class="d-flex align-items-center gap-2 text-white fw-bold fs-5 mb-3">
                    <div class="rounded-3 p-2 d-flex align-items-center justify-content-center" style="background: var(--dlms-gradient-primary); width: 32px; height: 32px;">
                        <i class="bi bi-book-half text-white fs-6"></i>
                    </div>
                    <span>DLMS PORTAL</span>
                </div>
                <p class="small text-muted">
                    Enterprise Digital Library Management System built with Java Servlets, JSP, JDBC, and MySQL for academic institutions.
                </p>
            </div>
            <div class="col-6 col-lg-2">
                <h6 class="text-white fw-bold mb-3">Navigation</h6>
                <ul class="list-unstyled small d-flex flex-column gap-2">
                    <li><a href="#features" class="text-muted">Features</a></li>
                    <li><a href="#how-it-works" class="text-muted">How It Works</a></li>
                    <li><a href="#statistics" class="text-muted">Statistics</a></li>
                    <li><a href="#team" class="text-muted">Team Members</a></li>
                </ul>
            </div>
            <div class="col-6 col-lg-3">
                <h6 class="text-white fw-bold mb-3">Access Portals</h6>
                <ul class="list-unstyled small d-flex flex-column gap-2">
                    <li><a href="${pageContext.request.contextPath}/login?role=STUDENT" class="text-muted"><i class="bi bi-mortarboard me-1"></i> Student Portal</a></li>
                    <li><a href="${pageContext.request.contextPath}/login?role=ADMIN" class="text-muted"><i class="bi bi-shield-lock me-1"></i> Admin Portal</a></li>
                    <li><a href="${pageContext.request.contextPath}/login" class="text-muted"><i class="bi bi-box-arrow-in-right me-1"></i> Staff Login</a></li>
                </ul>
            </div>
            <div class="col-lg-3">
                <h6 class="text-white fw-bold mb-3">PBL Submission</h6>
                <p class="small text-muted mb-1"><strong>Course:</strong> B.Tech Project-Based Learning</p>
                <p class="small text-muted mb-1"><strong>Team:</strong> Group 1</p>
                <p class="small text-muted">Designed for high-concurrency campus library operations.</p>
            </div>
        </div>
        <div class="border-top border-white-10 pt-4 d-flex flex-column flex-md-row align-items-center justify-content-between small text-muted">
            <div>&copy; 2024 Digital Library Management System. All rights reserved.</div>
            <div>Built by Md. Amanuddin and Jashwanth Chowdary</div>
        </div>
    </div>
</footer>

<jsp:include page="/includes/footer.jsp" />
