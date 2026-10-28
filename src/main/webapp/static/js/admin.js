/**
 * FoodZone - Admin Panel Interactions
 */

document.addEventListener('DOMContentLoaded', () => {
    // Delete action confirmation guard
    const deleteButtons = document.querySelectorAll('button[title="Delete Item"]');
    deleteButtons.forEach(btn => {
        btn.addEventListener('click', (e) => {
            if (!confirm('Are you sure you want to permanently delete this food item?')) {
                e.preventDefault();
            }
        });
    });

    // Auto-highlight status changes
    const statusSelects = document.querySelectorAll('select[name="newStatus"]');
    statusSelects.forEach(sel => {
        sel.addEventListener('change', () => {
            sel.style.borderColor = 'var(--primary)';
            sel.style.boxShadow = '0 0 0 2px rgba(255, 107, 53, 0.2)';
        });
    });
});
