/**
 * DIGITAL LIBRARY MANAGEMENT SYSTEM (DLMS) - CORE UI SCRIPTS
 * Theme switcher, animated stats counters, navigation, and sidebar controls.
 */

document.addEventListener('DOMContentLoaded', function () {
    initTheme();
    initAnimatedCounters();
    initSidebarToggle();
    updateUserSessionUI();
});

// 1. Dark Mode / Theme Toggle
function initTheme() {
    const savedTheme = localStorage.getItem('dlms_theme') || 'light';
    applyTheme(savedTheme);

    const themeToggleBtn = document.getElementById('themeToggleBtn');
    if (themeToggleBtn) {
        themeToggleBtn.addEventListener('click', function () {
            const currentTheme = document.documentElement.getAttribute('data-bs-theme') || 'light';
            const newTheme = currentTheme === 'dark' ? 'light' : 'dark';
            applyTheme(newTheme);
            localStorage.setItem('dlms_theme', newTheme);
        });
    }
}

function applyTheme(theme) {
    document.documentElement.setAttribute('data-bs-theme', theme);
    const themeIcon = document.getElementById('themeToggleIcon');
    if (themeIcon) {
        if (theme === 'dark') {
            themeIcon.className = 'bi bi-sun-fill text-warning';
        } else {
            themeIcon.className = 'bi bi-moon-stars-fill text-dark';
        }
    }
}

// 2. Animated Stats Counters
function initAnimatedCounters() {
    const counterElements = document.querySelectorAll('.animated-counter');
    counterElements.forEach(el => {
        const target = parseFloat(el.getAttribute('data-target')) || 0;
        const isCurrency = el.classList.contains('is-currency');
        const duration = 1200;
        const startTime = performance.now();

        function updateCounter(currentTime) {
            const elapsed = currentTime - startTime;
            const progress = Math.min(elapsed / duration, 1);
            const easeOutProgress = 1 - Math.pow(1 - progress, 3);
            const currentVal = target * easeOutProgress;

            if (isCurrency) {
                el.textContent = '₹' + currentVal.toFixed(2);
            } else {
                el.textContent = Math.round(currentVal).toLocaleString();
            }

            if (progress < 1) {
                requestAnimationFrame(updateCounter);
            } else {
                if (isCurrency) {
                    el.textContent = '₹' + target.toFixed(2);
                } else {
                    el.textContent = Math.round(target).toLocaleString();
                }
            }
        }

        requestAnimationFrame(updateCounter);
    });
}

// 3. Mobile Sidebar Toggle
function initSidebarToggle() {
    const sidebarToggleBtn = document.getElementById('sidebarToggleBtn');
    const sidebar = document.getElementById('sidebar');
    if (sidebarToggleBtn && sidebar) {
        sidebarToggleBtn.addEventListener('click', function () {
            sidebar.classList.toggle('show');
        });
    }
}

// 4. Update Header User Profile and Logout handler
function updateUserSessionUI() {
    if (!window.db) return;
    const user = window.db.getCurrentUser();
    const userNameEls = document.querySelectorAll('.session-user-name');
    const userRoleEls = document.querySelectorAll('.session-user-role');

    userNameEls.forEach(el => {
        el.textContent = user.username.charAt(0).toUpperCase() + user.username.slice(1);
    });

    userRoleEls.forEach(el => {
        el.textContent = user.role;
    });

    const logoutBtns = document.querySelectorAll('.btn-logout');
    logoutBtns.forEach(btn => {
        btn.addEventListener('click', function (e) {
            e.preventDefault();
            window.db.logout();
            window.location.href = '../login.html';
        });
    });
}
