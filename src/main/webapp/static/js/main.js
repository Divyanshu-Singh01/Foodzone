/**
 * FoodZone - Global Client-Side Scripts
 */

document.addEventListener('DOMContentLoaded', () => {
    // 1. Auto-dismiss alerts after 5 seconds
    const alerts = document.querySelectorAll('.alert');
    alerts.forEach(alert => {
        setTimeout(() => {
            alert.style.transition = 'opacity 0.5s ease, transform 0.5s ease';
            alert.style.opacity = '0';
            alert.style.transform = 'translateY(-10px)';
            setTimeout(() => alert.remove(), 500);
        }, 5000);
    });

    // 2. Add-to-cart button bounce animation
    const addButtons = document.querySelectorAll('.add-to-cart-btn');
    addButtons.forEach(btn => {
        btn.addEventListener('click', () => {
            const navBadge = document.getElementById('nav-cart-badge');
            if (navBadge) {
                navBadge.style.transition = 'transform 0.2s ease';
                navBadge.style.transform = 'scale(1.35)';
                setTimeout(() => {
                    navBadge.style.transform = 'scale(1)';
                }, 250);
            }
        });
    });
});

/**
 * Global Toast Notification Helper
 */
function showToast(message, type = 'success') {
    const container = document.getElementById('toast-container');
    if (!container) return;

    const toast = document.createElement('div');
    toast.className = `alert alert-${type}`;
    toast.style.margin = '0';
    toast.style.boxShadow = 'var(--shadow-lg)';
    toast.style.minWidth = '280px';
    toast.style.animation = 'fadeIn 0.3s ease';
    toast.innerHTML = `<i class="fa-solid fa-circle-check" style="margin-right: 8px;"></i> ${message}`;

    container.appendChild(toast);

    setTimeout(() => {
        toast.style.transition = 'opacity 0.4s ease, transform 0.4s ease';
        toast.style.opacity = '0';
        toast.style.transform = 'translateX(50px)';
        setTimeout(() => toast.remove(), 400);
    }, 3500);
}
