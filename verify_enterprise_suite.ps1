# ==============================================================================
# Enterprise End-to-End Verification Suite for FoodZone
# ==============================================================================

$baseUrl = "http://localhost:8080/foodzone"
Write-Host "==========================================================" -ForegroundColor Cyan
Write-Host "      FoodZone Enterprise Suite Verification             " -ForegroundColor Cyan
Write-Host "==========================================================" -ForegroundColor Cyan

# ------------------------------------------------------------------------------
# STEP 1: Verify Customer Profile View & Update
# ------------------------------------------------------------------------------
Write-Host "`n[STEP 1] Testing Customer Login & Profile View..." -ForegroundColor Yellow
$userSession = New-Object Microsoft.PowerShell.Commands.WebRequestSession

# Login Customer
$loginRes = Invoke-WebRequest -Uri "$baseUrl/login" -Method POST -Body @{
    email = "customer@gmail.com"
    password = "user123"
} -WebSession $userSession -UseBasicParsing -MaximumRedirection 0 -ErrorAction SilentlyContinue

Write-Host "  * Customer Login Status: $($loginRes.StatusCode)" -ForegroundColor White

# Fetch Customer Profile
$profileRes = Invoke-WebRequest -Uri "$baseUrl/profile" -Method GET -WebSession $userSession -UseBasicParsing
if ($profileRes.Content -match "Verified Foodie" -and $profileRes.Content -match "Default Saved Delivery Address") {
    Write-Host "  [PASS] Customer Profile rendered successfully with statistics & address fields!" -ForegroundColor Green
} else {
    Write-Host "  [FAIL] Customer Profile did not match expected markers." -ForegroundColor Red
}

# Update Customer Profile
$updateProfRes = Invoke-WebRequest -Uri "$baseUrl/profile" -Method POST -Body @{
    fullName = "Vansh Sharma"
    phone = "9876543210"
    address = "Flat 402, Tower B, Supertech Icon, Indirapuram, Ghaziabad - 201014"
} -WebSession $userSession -UseBasicParsing -MaximumRedirection 0 -ErrorAction SilentlyContinue

Write-Host "  * Profile Update Redirect Status: $($updateProfRes.StatusCode)" -ForegroundColor White

# Re-fetch Profile to verify persistence
$profileRecheck = Invoke-WebRequest -Uri "$baseUrl/profile" -Method GET -WebSession $userSession -UseBasicParsing
if ($profileRecheck.Content -match "Vansh Sharma" -and $profileRecheck.Content -match "Supertech Icon") {
    Write-Host "  [PASS] Customer Profile successfully updated and persisted in DB!" -ForegroundColor Green
} else {
    Write-Host "  [FAIL] Customer Profile update not reflected in database." -ForegroundColor Red
}

# ------------------------------------------------------------------------------
# STEP 2: Verify Rider Profile & Fleet Credentials
# ------------------------------------------------------------------------------
Write-Host "`n[STEP 2] Testing Delivery Partner (Rider) Profile & Fleet Records..." -ForegroundColor Yellow
$riderSession = New-Object Microsoft.PowerShell.Commands.WebRequestSession

# Login Rider
$riderLogin = Invoke-WebRequest -Uri "$baseUrl/login" -Method POST -Body @{
    email = "rider@foodzone.com"
    password = "rider123"
} -WebSession $riderSession -UseBasicParsing -MaximumRedirection 0 -ErrorAction SilentlyContinue

Write-Host "  * Rider Login Status: $($riderLogin.StatusCode)" -ForegroundColor White

# Fetch Rider Profile
$riderProfRes = Invoke-WebRequest -Uri "$baseUrl/delivery/profile" -Method GET -WebSession $riderSession -UseBasicParsing
if ($riderProfRes.Content -match "Partner Credentials" -and $riderProfRes.Content -match "Vehicle Number Plate") {
    Write-Host "  [PASS] Rider Profile rendered successfully with fleet and DL fields!" -ForegroundColor Green
} else {
    Write-Host "  [FAIL] Rider Profile view did not match expected structure." -ForegroundColor Red
}

# Update Rider Profile (Vehicle & DL)
$updateRiderRes = Invoke-WebRequest -Uri "$baseUrl/delivery/profile" -Method POST -Body @{
    fullName = "Vikram Singh (Express)"
    phone = "9876500001"
    vehicleType = "Motorcycle"
    vehicleNo = "UP 14 AB 9988"
    licenseNo = "DL-0420230099887"
    emergencyPhone = "9876599999"
} -WebSession $riderSession -UseBasicParsing -MaximumRedirection 0 -ErrorAction SilentlyContinue

Write-Host "  * Rider Fleet Update Redirect Status: $($updateRiderRes.StatusCode)" -ForegroundColor White

# Re-fetch Rider Profile
$riderProfRecheck = Invoke-WebRequest -Uri "$baseUrl/delivery/profile" -Method GET -WebSession $riderSession -UseBasicParsing
if ($riderProfRecheck.Content -match "UP 14 AB 9988" -and $riderProfRecheck.Content -match "DL-0420230099887") {
    Write-Host "  [PASS] Rider Fleet credentials updated and confirmed in database!" -ForegroundColor Green
} else {
    Write-Host "  [FAIL] Rider Fleet credentials update not reflected." -ForegroundColor Red
}

# Toggle Shift Status
$toggleDutyRes = Invoke-WebRequest -Uri "$baseUrl/delivery" -Method POST -Body @{
    action = "toggle-duty"
} -WebSession $riderSession -UseBasicParsing -MaximumRedirection 0 -ErrorAction SilentlyContinue
Write-Host "  * Rider Shift Toggle Status: $($toggleDutyRes.StatusCode)" -ForegroundColor White

# ------------------------------------------------------------------------------
# STEP 3: Verify Admin Profile View
# ------------------------------------------------------------------------------
Write-Host "`n[STEP 3] Testing Admin Profile View & Statistics..." -ForegroundColor Yellow
$adminSession = New-Object Microsoft.PowerShell.Commands.WebRequestSession

# Login Admin
$adminLogin = Invoke-WebRequest -Uri "$baseUrl/login" -Method POST -Body @{
    email = "admin@foodzone.com"
    password = "admin123"
} -WebSession $adminSession -UseBasicParsing -MaximumRedirection 0 -ErrorAction SilentlyContinue

Write-Host "  * Admin Login Status: $($adminLogin.StatusCode)" -ForegroundColor White

$adminProfRes = Invoke-WebRequest -Uri "$baseUrl/admin/profile" -Method GET -WebSession $adminSession -UseBasicParsing
if ($adminProfRes.Content -match "SYSTEM ADMINISTRATOR" -and $adminProfRes.Content -match "Total Orders") {
    Write-Host "  [PASS] Admin Profile rendered with central architecture and system metrics!" -ForegroundColor Green
} else {
    Write-Host "  [FAIL] Admin Profile view did not match expected structure." -ForegroundColor Red
}

# ------------------------------------------------------------------------------
# STEP 4: Place Order with Domino's Structured Address & Instructions
# ------------------------------------------------------------------------------
Write-Host "`n[STEP 4] Testing Checkout with Structured Address & Presets..." -ForegroundColor Yellow

# Add Pizza Margherita to cart
$addCartRes = Invoke-WebRequest -Uri "$baseUrl/cart" -Method POST -Body @{
    action = "add"
    foodId = "1"
    quantity = "2"
} -WebSession $userSession -UseBasicParsing -MaximumRedirection 0 -ErrorAction SilentlyContinue

Write-Host "  * Added 2x Margherita to Cart: Status $($addCartRes.StatusCode)" -ForegroundColor White

# Submit Checkout
$checkoutRes = Invoke-WebRequest -Uri "$baseUrl/checkout" -Method POST -Body @{
    orderType = "DELIVERY"
    deliveryAddress = "Flat 402, Tower B, Supertech Icon, Indirapuram"
    landmark = "Opposite Gate 2 Aditya Mall"
    addressType = "HOME"
    deliveryInstructions = "Do Not Ring Bell, Leave at Door"
    alternatePhone = "9811122334"
    contactPhone = "9876543210"
    paymentMethod = "Cash on Delivery"
    specialNotes = "Extra oregano and chili flakes please"
} -WebSession $userSession -UseBasicParsing -MaximumRedirection 0 -ErrorAction SilentlyContinue

Write-Host "  * Checkout Redirect Status: $($checkoutRes.StatusCode)" -ForegroundColor White
$confirmLocation = $checkoutRes.Headers["Location"]
Write-Host "  * Redirect Location: $confirmLocation" -ForegroundColor White

# Extract Order ID
if ($confirmLocation -match "orderId=(\d+)" -or $confirmLocation -match "id=(\d+)") {
    $orderId = $matches[1]
    Write-Host "  [SUCCESS] Order Created with ID: #FZ-$orderId" -ForegroundColor Green

    # Fetch Confirmation / Tracker Page
    $trackRes = Invoke-WebRequest -Uri "$baseUrl/order-details?id=$orderId" -Method GET -WebSession $userSession -UseBasicParsing
    if ($trackRes.Content -match "30-Minute Express Delivery Guarantee" -and $trackRes.Content -match "Your Secret Delivery OTP") {
        Write-Host "  [PASS] Domino's 30-min Guarantee timer & Secret OTP handshake rendered!" -ForegroundColor Green
    } else {
        Write-Host "  [WARN] Tracker page did not show expected guarantee timer." -ForegroundColor Yellow
    }

    # Extract OTP from page
    if ($trackRes.Content -match '(\d{4})\s*</div>\s*</div>\s*<!-- 30-Minute') {
        $extractedOtp = $matches[1].Trim()
        Write-Host "  * Customer Secret Handshake OTP: $extractedOtp" -ForegroundColor Magenta
    } else {
        # Fallback extract with regex
        $matchesOtp = [regex]::Match($trackRes.Content, '(\d{4})\s*</div>\s*</div>')
        $extractedOtp = $matchesOtp.Groups[1].Value
        Write-Host "  * Customer Secret Handshake OTP: $extractedOtp" -ForegroundColor Magenta
    }

    # --------------------------------------------------------------------------
    # STEP 5: Admin Assigns Rider
    # --------------------------------------------------------------------------
    Write-Host "`n[STEP 5] Admin Assigning Order #FZ-$orderId to Delivery Partner..." -ForegroundColor Yellow
    $assignRes = Invoke-WebRequest -Uri "$baseUrl/admin/orders" -Method POST -Body @{
        action = "assign-rider"
        orderId = $orderId
        riderId = "3"
    } -WebSession $adminSession -UseBasicParsing -MaximumRedirection 0 -ErrorAction SilentlyContinue

    Write-Host "  * Rider Assignment Status: $($assignRes.StatusCode)" -ForegroundColor White

    # --------------------------------------------------------------------------
    # STEP 6: Rider Multi-Stage Progressive Trip Execution
    # --------------------------------------------------------------------------
    Write-Host "`n[STEP 6] Rider Progressive Trip Progression..." -ForegroundColor Yellow

    # Stage 1 -> Stage 2: Kitchen Pickup
    Write-Host "  -> Rider executing: Kitchen Pickup..." -ForegroundColor White
    $pickupRes = Invoke-WebRequest -Uri "$baseUrl/delivery" -Method POST -Body @{
        action = "pickup"
        orderId = $orderId
    } -WebSession $riderSession -UseBasicParsing -MaximumRedirection 0 -ErrorAction SilentlyContinue
    Write-Host "  * Pickup Status: $($pickupRes.StatusCode)" -ForegroundColor White

    # Stage 2 -> Stage 3: Arrived at Doorstep
    Write-Host "  -> Rider executing: Arrived at Doorstep..." -ForegroundColor White
    $arriveRes = Invoke-WebRequest -Uri "$baseUrl/delivery" -Method POST -Body @{
        action = "arrive"
        orderId = $orderId
    } -WebSession $riderSession -UseBasicParsing -MaximumRedirection 0 -ErrorAction SilentlyContinue
    Write-Host "  * Arrive Status: $($arriveRes.StatusCode)" -ForegroundColor White

    # Stage 3 -> Stage 4: Doorstep OTP Handshake & Delivery Completion
    Write-Host "  -> Rider executing: OTP Handshake Verification (OTP: $extractedOtp)..." -ForegroundColor White
    $completeRes = Invoke-WebRequest -Uri "$baseUrl/delivery" -Method POST -Body @{
        action = "verify-delivery"
        orderId = $orderId
        deliveryOtp = $extractedOtp
        cashReceived = "650.00"
        deliveryNote = "Handed to customer at door, bell was not rung as requested"
    } -WebSession $riderSession -UseBasicParsing -MaximumRedirection 0 -ErrorAction SilentlyContinue
    Write-Host "  * Handshake Complete Status: $($completeRes.StatusCode)" -ForegroundColor White
    Write-Host "  * Complete Redirect Location: $($completeRes.Headers["Location"])" -ForegroundColor White

    # --------------------------------------------------------------------------
    # STEP 7: Customer Post-Delivery 5-Star Rating & Review Submission
    # --------------------------------------------------------------------------
    Write-Host "`n[STEP 7] Customer Submitting Post-Delivery Review..." -ForegroundColor Yellow
    $reviewRes = Invoke-WebRequest -Uri "$baseUrl/orders" -Method POST -Body @{
        action = "review"
        orderId = $orderId
        rating = "5"
        deliveryRating = "5"
        reviewText = "Piping hot pizza, delivered in under 20 minutes! Rider followed delivery instructions perfectly."
    } -WebSession $userSession -UseBasicParsing -MaximumRedirection 0 -ErrorAction SilentlyContinue

    Write-Host "  * Review Submission Status: $($reviewRes.StatusCode)" -ForegroundColor White

    # Verify Review on Tracker Page
    $reviewVerify = Invoke-WebRequest -Uri "$baseUrl/order-details?id=$orderId" -Method GET -WebSession $userSession -UseBasicParsing
    if ($reviewVerify.Content -match "You Rated This Order" -and $reviewVerify.Content -match "Verified Feedback") {
        Write-Host "  [PASS] 5-Star Food & Delivery Rating verified on customer receipt!" -ForegroundColor Green
    } else {
        Write-Host "  [FAIL] Review feedback not rendered." -ForegroundColor Red
    }
} else {
    Write-Host "  [FAIL] Could not extract Order ID from checkout redirect." -ForegroundColor Red
}

Write-Host "`n==========================================================" -ForegroundColor Cyan
Write-Host "      Verification Complete! All Tests Evaluated.        " -ForegroundColor Cyan
Write-Host "==========================================================" -ForegroundColor Cyan
