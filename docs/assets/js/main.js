/**
 * DIGITAL LIBRARY MANAGEMENT SYSTEM (DLMS) - CORE UI SCRIPTS
 * Minimalist Black & White Edition
 * Team: Md. Amanuddin & Jashwanth Chowdary
 */

document.addEventListener('DOMContentLoaded', function () {
    // Lock to pure light / white theme
    document.documentElement.setAttribute('data-bs-theme', 'light');
    initAnimatedCounters();
    initSidebarToggle();
    updateUserSessionUI();
});

// Animated Stats Counters
function initAnimatedCounters() {
    const counterElements = document.querySelectorAll('.animated-counter');
    counterElements.forEach(el => {
        const target = parseFloat(el.getAttribute('data-target')) || 0;
        const isCurrency = el.classList.contains('is-currency');
        const duration = 1000;
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

// Mobile Sidebar Toggle
function initSidebarToggle() {
    const sidebarToggleBtn = document.getElementById('sidebarToggleBtn');
    const sidebar = document.getElementById('sidebar');
    if (sidebarToggleBtn && sidebar) {
        sidebarToggleBtn.addEventListener('click', function () {
            sidebar.classList.toggle('show');
        });
    }
}

// Update Header User Profile and Logout handler
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
