/**
 * FoodZone - Shopping Cart Interactions
 */

document.addEventListener('DOMContentLoaded', () => {
    // Confirmation on removing item if clicked
    const removeButtons = document.querySelectorAll('button[title="Remove Item"]');
    removeButtons.forEach(btn => {
        btn.addEventListener('click', (e) => {
            if (!confirm('Remove this dish from your cart?')) {
                e.preventDefault();
            }
        });
    });

    // Form submission validation for Checkout
    const checkoutForm = document.getElementById('checkout-form');
    if (checkoutForm) {
        checkoutForm.addEventListener('submit', (e) => {
            const phone = document.getElementById('contactPhone').value.trim();
            const address = document.getElementById('deliveryAddress').value.trim();

            if (!phone || !address) {
                e.preventDefault();
                alert('Please enter your contact phone and complete delivery address.');
                return;
            }

            if (phone.length < 10) {
                e.preventDefault();
                alert('Please enter a valid 10-digit mobile phone number.');
            }
        });
    }
});
