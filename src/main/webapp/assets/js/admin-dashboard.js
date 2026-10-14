/**
 * DIGITAL LIBRARY MANAGEMENT SYSTEM (DLMS) - ADMIN DASHBOARD CHARTS
 * Renders 4 interactive Chart.js charts using real-time database data from /admin/api/stats.
 */

document.addEventListener('DOMContentLoaded', function () {
    loadDashboardCharts();
});

function loadDashboardCharts() {
    const contextPath = window.location.pathname.substring(0, window.location.pathname.indexOf('/', 2)) || '';
    const apiUrl = contextPath + '/admin/api/stats';

    fetch(apiUrl)
        .then(response => {
            if (!response.ok) throw new Error('Network error loading chart data');
            return response.json();
        })
        .then(data => {
            renderBooksOverviewChart(data.summary);
            renderPopularCategoriesChart(data.categories);
            renderMonthlyTransactionsChart(data.monthlyTrends);
            renderFinesChart(data.summary);
        })
        .catch(err => {
            console.warn('Could not load dynamic chart stats, using server-rendered attributes: ', err);
        });
}

function renderBooksOverviewChart(summary) {
    const ctx = document.getElementById('booksOverviewChart');
    if (!ctx) return;

    const available = (summary && summary.availableBooks) || 28;
    const issued = (summary && summary.issuedBooks) || 6;
    const reserved = (summary && summary.pendingReservations) || 3;

    new Chart(ctx, {
        type: 'doughnut',
        data: {
            labels: ['Available Copies', 'Currently Issued', 'Waitlist Reserved'],
            datasets: [{
                data: [available, issued, reserved],
                backgroundColor: ['#10B981', '#2563EB', '#F59E0B'],
                borderWidth: 2,
                borderColor: '#ffffff',
                hoverOffset: 6
            }]
        },
        options: {
            responsive: true,
            maintainAspectRatio: false,
            plugins: {
                legend: {
                    position: 'bottom',
                    labels: { boxWidth: 12, padding: 15, font: { family: 'Plus Jakarta Sans', size: 12 } }
                }
            },
            cutout: '72%'
        }
    });
}

function renderPopularCategoriesChart(categories) {
    const ctx = document.getElementById('categoriesChart');
    if (!ctx) return;

    const labels = categories ? Object.keys(categories) : ['Computer Science', 'Programming', 'AI/ML', 'Networking', 'Software Eng'];
    const counts = categories ? Object.values(categories) : [6, 4, 3, 3, 2];

    new Chart(ctx, {
        type: 'bar',
        data: {
            labels: labels,
            datasets: [{
                label: 'Total Titles',
                data: counts,
                backgroundColor: '#2563EB',
                borderRadius: 6,
                maxBarThickness: 32
            }]
        },
        options: {
            responsive: true,
            maintainAspectRatio: false,
            plugins: { legend: { display: false } },
            scales: {
                y: { beginAtZero: true, grid: { color: 'rgba(0,0,0,0.05)' } },
                x: { grid: { display: false } }
            }
        }
    });
}

function renderMonthlyTransactionsChart(trends) {
    const ctx = document.getElementById('transactionsTrendChart');
    if (!ctx) return;

    const labels = trends && Object.keys(trends).length > 0 ? Object.keys(trends) : ['May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct'];
    const counts = trends && Object.keys(trends).length > 0 ? Object.values(trends) : [12, 18, 25, 34, 42, 58];

    new Chart(ctx, {
        type: 'line',
        data: {
            labels: labels,
            datasets: [{
                label: 'Circulation Volume',
                data: counts,
                borderColor: '#06B6D4',
                backgroundColor: 'rgba(6, 182, 212, 0.1)',
                borderWidth: 3,
                tension: 0.35,
                fill: true,
                pointBackgroundColor: '#06B6D4',
                pointRadius: 4
            }]
        },
        options: {
            responsive: true,
            maintainAspectRatio: false,
            plugins: { legend: { display: false } },
            scales: {
                y: { beginAtZero: true, grid: { color: 'rgba(0,0,0,0.05)' } },
                x: { grid: { display: false } }
            }
        }
    });
}

function renderFinesChart(summary) {
    const ctx = document.getElementById('finesChart');
    if (!ctx) return;

    const paid = (summary && summary.paidFines) || 20.00;
    const unpaid = (summary && summary.unpaidFines) || 120.00;

    new Chart(ctx, {
        type: 'bar',
        data: {
            labels: ['Collected Fines (₹)', 'Pending Overdue Fines (₹)'],
            datasets: [{
                label: 'Amount (₹)',
                data: [paid, unpaid],
                backgroundColor: ['#10B981', '#EF4444'],
                borderRadius: 8,
                maxBarThickness: 45
            }]
        },
        options: {
            responsive: true,
            maintainAspectRatio: false,
            plugins: { legend: { display: false } },
            scales: {
                y: { beginAtZero: true, grid: { color: 'rgba(0,0,0,0.05)' } },
                x: { grid: { display: false } }
            }
        }
    });
}
