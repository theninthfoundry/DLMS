/**
 * DIGITAL LIBRARY MANAGEMENT SYSTEM (DLMS) - CORE JAVASCRIPT
 * Handles Dark Mode, Animated Counters, Toast Notifications, and UI Interactivity.
 */

document.addEventListener('DOMContentLoaded', function () {
    initTheme();
    initAnimatedCounters();
    initToasts();
    initSidebarToggle();
    initConfirmationModals();
});

// --------------------------------------------------------------------
// 1. Dark Mode / Theme Toggle with LocalStorage Persistence
// --------------------------------------------------------------------
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

// --------------------------------------------------------------------
// 2. Animated Counters for Dashboard Statistics Cards
// --------------------------------------------------------------------
function initAnimatedCounters() {
    const counterElements = document.querySelectorAll('.animated-counter');
    counterElements.forEach(el => {
        const target = parseFloat(el.getAttribute('data-target')) || 0;
        const isCurrency = el.classList.contains('is-currency');
        const duration = 1200; // ms
        const startTime = performance.now();

        function updateCounter(currentTime) {
            const elapsed = currentTime - startTime;
            const progress = Math.min(elapsed / duration, 1);
            // Ease-out cubic calculation
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

// --------------------------------------------------------------------
// 3. Toast Notifications
// --------------------------------------------------------------------
function initToasts() {
    const toastElList = document.querySelectorAll('.toast');
    toastElList.forEach(toastEl => {
        const toast = new bootstrap.Toast(toastEl, { delay: 4000 });
        toast.show();
    });
}

function showToast(message, type = 'info') {
    const container = document.getElementById('toastContainer');
    if (!container) return;

    const toastDiv = document.createElement('div');
    toastDiv.className = `toast align-items-center text-white bg-${type} border-0 shadow-lg`;
    toastDiv.role = 'alert';
    toastDiv.innerHTML = `
        <div class="d-flex">
            <div class="toast-body fw-medium">${message}</div>
            <button type="button" class="btn-close btn-close-white me-2 m-auto" data-bs-dismiss="toast"></button>
        </div>
    `;
    container.appendChild(toastDiv);
    const toast = new bootstrap.Toast(toastDiv, { delay: 4000 });
    toast.show();
}

// --------------------------------------------------------------------
// 4. Mobile Responsive Sidebar Toggle
// --------------------------------------------------------------------
function initSidebarToggle() {
    const toggleBtn = document.getElementById('sidebarToggleBtn');
    const sidebar = document.querySelector('.sidebar');
    if (toggleBtn && sidebar) {
        toggleBtn.addEventListener('click', function () {
            sidebar.classList.toggle('show');
        });
    }
}

// --------------------------------------------------------------------
// 5. Generic Confirmation Modal Helper
// --------------------------------------------------------------------
function initConfirmationModals() {
    document.querySelectorAll('[data-confirm]').forEach(el => {
        el.addEventListener('click', function (e) {
            const message = el.getAttribute('data-confirm');
            if (!confirm(message)) {
                e.preventDefault();
            }
        });
    });
}
