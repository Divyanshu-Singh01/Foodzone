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

    // 3. Profile Dropdown Click Toggle for Rider / Users
    const dropdownWrappers = document.querySelectorAll('.nav-dropdown-wrapper');
    dropdownWrappers.forEach(wrapper => {
        const trigger = wrapper.querySelector('.nav-user-chip');
        if (trigger) {
            trigger.addEventListener('click', (e) => {
                // If user clicks the dropdown arrow or the chip, toggle open
                e.preventDefault();
                e.stopPropagation();
                wrapper.classList.toggle('open');
            });
        }
    });

    document.addEventListener('click', (e) => {
        dropdownWrappers.forEach(wrapper => {
            if (!wrapper.contains(e.target)) {
                wrapper.classList.remove('open');
            }
        });
    });

    // 4. Interactive AJAX Duty Switchers (Instant haptic-style toggle)
    const dutyForms = document.querySelectorAll('form[action*="/delivery"]');
    dutyForms.forEach(form => {
        const actionInput = form.querySelector('input[name="action"][value="toggle-duty"]');
        if (actionInput) {
            form.addEventListener('submit', function(e) {
                // If fetch is available, perform smooth AJAX toggle with optimistic UI update
                if (window.fetch) {
                    e.preventDefault();
                    const url = form.getAttribute('action');
                    const formData = new FormData(form);
                    formData.set('ajax', 'true');

                    // Optimistic UI Toggle
                    const allDutySwitches = document.querySelectorAll('.tactile-duty-switch, .duty-nav-btn');
                    const isCurrentlyOn = form.querySelector('.is-online, .duty-on') !== null;
                    const willBeOn = !isCurrentlyOn;

                    allDutySwitches.forEach(sw => {
                        if (sw.classList.contains('tactile-duty-switch')) {
                            sw.classList.toggle('is-online', willBeOn);
                            sw.classList.toggle('is-offline', !willBeOn);
                            const label = sw.querySelector('.tactile-duty-label');
                            if (label) label.textContent = willBeOn ? 'ONLINE • ACCEPTING TRIPS' : 'OFFLINE • SHIFT PAUSED';
                        } else if (sw.classList.contains('duty-nav-btn')) {
                            sw.classList.toggle('duty-on', willBeOn);
                            sw.classList.toggle('duty-off', !willBeOn);
                            const span = sw.querySelector('span:last-child');
                            if (span) span.textContent = willBeOn ? 'ON DUTY' : 'OFF DUTY';
                        }
                    });

                    fetch(url, {
                        method: 'POST',
                        headers: { 'X-Requested-With': 'XMLHttpRequest' },
                        body: new URLSearchParams(formData)
                    })
                    .then(r => r.json())
                    .then(data => {
                        if (data.success) {
                            showToast(data.isOnDuty ? '🟢 Shift Duty ACTIVE: Central dispatch is routing orders to you.' : '⏸️ Shift Duty PAUSED: You are now offline.');
                        }
                    })
                    .catch(() => {
                        // If AJAX fails, submit normally
                        form.submit();
                    });
                }
            });
        }
    });

    // 5. 4-Cell Segmented OTP Auto-Advance
    document.querySelectorAll('.otp-input-group').forEach(group => {
        const cells = group.querySelectorAll('.otp-cell');
        const hiddenInput = group.closest('form').querySelector('input[name="deliveryOtp"]');
        
        cells.forEach((cell, idx) => {
            cell.addEventListener('input', (e) => {
                const val = e.target.value.replace(/[^0-9]/g, '');
                e.target.value = val;
                if (val && idx < cells.length - 1) {
                    cells[idx + 1].focus();
                }
                updateCombinedOtp(cells, hiddenInput);
            });

            cell.addEventListener('keydown', (e) => {
                if (e.key === 'Backspace' && !e.target.value && idx > 0) {
                    cells[idx - 1].focus();
                }
            });
        });
    });

    function updateCombinedOtp(cells, hiddenInput) {
        if (!hiddenInput) return;
        let combined = '';
        cells.forEach(c => combined += c.value);
        hiddenInput.value = combined;
    }
});

/**
 * COD Quick Preset Handler
 */
function setCodPreset(amount, total, displayId, hiddenInputId, inputFieldId) {
    const inputField = document.getElementById(inputFieldId);
    if (inputField) inputField.value = amount;
    calculateChange(amount, total, displayId, hiddenInputId);
}

function calculateChange(tendered, total, displayId, hiddenInputId) {
    const tenderedVal = parseFloat(tendered);
    const displayEl = document.getElementById(displayId);
    const hiddenEl = document.getElementById(hiddenInputId);
    if (!isNaN(tenderedVal) && tenderedVal >= total) {
        const change = tenderedVal - total;
        if (displayEl) {
            displayEl.innerHTML = '<span style="color:#059669;font-weight:800;">Return: ₹' + change.toFixed(2) + '</span>';
        }
        if (hiddenEl) hiddenEl.value = tenderedVal.toFixed(2);
    } else {
        if (displayEl) {
            displayEl.innerHTML = '<span style="color:#DC2626;font-weight:700;">Insufficient (' + (total - (isNaN(tenderedVal) ? 0 : tenderedVal)).toFixed(2) + ' short)</span>';
        }
        if (hiddenEl) hiddenEl.value = total.toFixed(2);
    }
}

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
