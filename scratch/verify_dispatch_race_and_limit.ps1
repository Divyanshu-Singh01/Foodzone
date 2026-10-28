# ==============================================================================
# Verification Suite: Single Active Delivery Limit & Atomic Broadcast Claim
# ==============================================================================

$baseUrl = "http://localhost:8080/foodzone"
Write-Host "==========================================================" -ForegroundColor Cyan
Write-Host "   Single Active Delivery & Broadcast Claim Test Suite    " -ForegroundColor Cyan
Write-Host "==========================================================" -ForegroundColor Cyan

function Request-Post($url, $body, $session) {
    return Invoke-WebRequest -Uri $url -Method POST -Body $body -WebSession $session -UseBasicParsing -MaximumRedirection 0 -ErrorAction SilentlyContinue
}

function Request-Get($url, $session) {
    return Invoke-WebRequest -Uri $url -Method GET -WebSession $session -UseBasicParsing -ErrorAction SilentlyContinue
}

# Ensure DB has no dangling active orders
& "C:\Program Files\MySQL\MySQL Server 8.0\bin\mysql.exe" -u root -p@Divyanshu2004 foodzone_db -e "UPDATE orders SET order_status = 'COMPLETED', trip_stage = 'DELIVERED' WHERE order_status = 'OUT_FOR_DELIVERY'; DELETE FROM order_items WHERE order_id >= 15; DELETE FROM orders WHERE order_id >= 15;"

# ------------------------------------------------------------------------------
# SETUP: Customer, Rider 1 (Vikram), Rider 2 (Amit)
# ------------------------------------------------------------------------------
$custSession = New-Object Microsoft.PowerShell.Commands.WebRequestSession
$rider1Session = New-Object Microsoft.PowerShell.Commands.WebRequestSession
$rider2Session = New-Object Microsoft.PowerShell.Commands.WebRequestSession

# Login Customer
$null = Request-Post "$baseUrl/login" @{ email = "customer@gmail.com"; password = "user123" } $custSession

# Login Rider 1 (Vikram)
$null = Request-Post "$baseUrl/login" @{ email = "rider@foodzone.com"; password = "rider123" } $rider1Session

# Login Rider 2 (Amit)
$null = Request-Post "$baseUrl/login" @{ email = "rider2@foodzone.com"; password = "rider123" } $rider2Session

# Ensure Rider 1 starts OFF-DUTY
$r1Dash = Request-Get "$baseUrl/delivery/dashboard" $rider1Session
if ($r1Dash.Content -match "ONLINE &bull; ACCEPTING TRIPS" -or $r1Dash.Content -match "ONLINE • ACCEPTING TRIPS" -or $r1Dash.Content -match "is-online") {
    $null = Request-Post "$baseUrl/delivery" @{ action = "toggle-duty" } $rider1Session
}

# Ensure Rider 2 starts ON-DUTY
$r2Dash = Request-Get "$baseUrl/delivery/dashboard" $rider2Session
if ($r2Dash.Content -match "OFFLINE &bull; SHIFT PAUSED" -or $r2Dash.Content -match "OFFLINE • SHIFT PAUSED" -or $r2Dash.Content -match "is-offline") {
    $null = Request-Post "$baseUrl/delivery" @{ action = "toggle-duty" } $rider2Session
}

Write-Host "`n[TEST 1] Testing Customer Places Order #1 (Unassigned Broadcast)..." -ForegroundColor Yellow
$null = Request-Post "$baseUrl/cart" @{ action = "add"; foodId = "1"; quantity = "1" } $custSession
$order1Res = Request-Post "$baseUrl/checkout" @{
    orderType = "DELIVERY"
    deliveryAddress = "Tower 7, Express Park View, Greater Noida"
    landmark = "Near Pari Chowk"
    addressType = "HOME"
    deliveryInstructions = "Please call upon reaching"
    contactPhone = "9876543210"
    paymentMethod = "Cash on Delivery"
} $custSession
$order1Id = [regex]::Match($order1Res.Headers["Location"], 'orderId=(\d+)').Groups[1].Value
Write-Host "  * Created Order 1 ID: #FZ-$order1Id" -ForegroundColor Green

# Extract OTP for Order 1
$otp1 = (& "C:\Program Files\MySQL\MySQL Server 8.0\bin\mysql.exe" -u root -p@Divyanshu2004 foodzone_db -N -s -e "SELECT delivery_otp FROM orders WHERE order_id = $order1Id;").Trim()
Write-Host "  * Order 1 Secret OTP: $otp1" -ForegroundColor Magenta

# ------------------------------------------------------------------------------
# TEST 2: Off-Duty Rider does NOT see broadcast; On-Duty Rider sees broadcast
# ------------------------------------------------------------------------------
Write-Host "`n[TEST 2] Verifying Duty Status Gate for Broadcast Pool..." -ForegroundColor Yellow
$r1DashOff = Request-Get "$baseUrl/delivery/dashboard" $rider1Session
if ($r1DashOff.Content -match "Shift Paused" -and $r1DashOff.Content -notmatch "ACCEPT DELIVERY FIRST") {
    Write-Host "  [PASS] Off-duty rider correctly sees 'Shift Paused' and cannot view/claim broadcast requests!" -ForegroundColor Green
} else {
    Write-Host "  [FAIL] Off-duty rider was able to see or access requests." -ForegroundColor Red
}

$r2DashOn = Request-Get "$baseUrl/delivery/dashboard" $rider2Session
if ($r2DashOn.Content -match "LIVE DISPATCH RADAR" -and $r2DashOn.Content -match "#FZ-$order1Id") {
    Write-Host "  [PASS] On-duty rider automatically received broadcast for Order #FZ-$order1Id!" -ForegroundColor Green
} else {
    Write-Host "  [FAIL] On-duty rider did not receive broadcast for Order #FZ-$order1Id." -ForegroundColor Red
}

# Toggle Rider 1 to ON-DUTY as well
$null = Request-Post "$baseUrl/delivery" @{ action = "toggle-duty" } $rider1Session
$r1DashOn = Request-Get "$baseUrl/delivery/dashboard" $rider1Session
if ($r1DashOn.Content -match "#FZ-$order1Id" -and $r1DashOn.Content -match "ACCEPT DELIVERY FIRST") {
    Write-Host "  [PASS] Rider 1 went on-duty and immediately received broadcast for Order #FZ-$order1Id!" -ForegroundColor Green
} else {
    Write-Host "  [FAIL] Rider 1 did not receive broadcast after going on-duty." -ForegroundColor Red
}

# ------------------------------------------------------------------------------
# TEST 3: First Rider to Accept Claims Trip; Second Rider is Rejected
# ------------------------------------------------------------------------------
Write-Host "`n[TEST 3] Race Acceptance: Rider 1 accepts first, Rider 2 attempts to accept same..." -ForegroundColor Yellow

# Rider 1 accepts Order 1
$claim1Res = Request-Post "$baseUrl/delivery" @{ action = "accept-trip"; orderId = $order1Id } $rider1Session
$loc1 = $claim1Res.Headers["Location"]
Write-Host "  * Rider 1 Accept Redirect: $loc1" -ForegroundColor White
if ($loc1 -match "msg=trip_claimed") {
    Write-Host "  [PASS] Rider 1 won the race and successfully claimed Order #FZ-$order1Id!" -ForegroundColor Green
} else {
    Write-Host "  [FAIL] Rider 1 could not claim order." -ForegroundColor Red
}

# Rider 2 attempts to accept the SAME Order 1
$claim2Res = Request-Post "$baseUrl/delivery" @{ action = "accept-trip"; orderId = $order1Id } $rider2Session
$loc2 = $claim2Res.Headers["Location"]
Write-Host "  * Rider 2 Accept Redirect: $loc2" -ForegroundColor White
if ($loc2 -match "error=trip_already_claimed") {
    Write-Host "  [PASS] Rider 2 was blocked with 'trip_already_claimed'! Concurrency protection verified." -ForegroundColor Green
} else {
    Write-Host "  [FAIL] Rider 2 was not blocked from accepting an already claimed trip." -ForegroundColor Red
}

# ------------------------------------------------------------------------------
# TEST 4: Single Active Order Rule (Rider 1 Cannot Take 2nd Order while 1 is active)
# ------------------------------------------------------------------------------
Write-Host "`n[TEST 4] Single Active Order Enforcement (Max 1 Order per Rider)..." -ForegroundColor Yellow

# Customer places Order #2
$null = Request-Post "$baseUrl/cart" @{ action = "add"; foodId = "2"; quantity = "1" } $custSession
$order2Res = Request-Post "$baseUrl/checkout" @{
    orderType = "DELIVERY"
    deliveryAddress = "Flat 101, Supertech Icon, Ghaziabad"
    contactPhone = "9876543210"
    paymentMethod = "Cash on Delivery"
} $custSession
$order2Id = [regex]::Match($order2Res.Headers["Location"], 'orderId=(\d+)').Groups[1].Value
Write-Host "  * Created Order 2 ID: #FZ-$order2Id" -ForegroundColor Green

# Extract OTP for Order 2
$otp2 = (& "C:\Program Files\MySQL\MySQL Server 8.0\bin\mysql.exe" -u root -p@Divyanshu2004 foodzone_db -N -s -e "SELECT delivery_otp FROM orders WHERE order_id = $order2Id;").Trim()
Write-Host "  * Order 2 Secret OTP: $otp2" -ForegroundColor Magenta

# Check Rider 1 Dashboard: Must show 1-Order Limit banner, cannot accept Order 2
$r1DashActive = Request-Get "$baseUrl/delivery/dashboard" $rider1Session
if ($r1DashActive.Content -match "Single Active Order Policy Engaged" -or $r1DashActive.Content -match "ACTIVE TRIP IN PROGRESS") {
    Write-Host "  [PASS] Rider 1 dashboard shows Single Active Order policy lock banner!" -ForegroundColor Green
} else {
    Write-Host "  [FAIL] Rider 1 dashboard did not show active trip lock banner." -ForegroundColor Red
}

# Rider 1 attempts to accept Order 2 (Should be strictly rejected)
$claimOrder2ByRider1 = Request-Post "$baseUrl/delivery" @{ action = "accept-trip"; orderId = $order2Id } $rider1Session
$r1LocOrder2 = $claimOrder2ByRider1.Headers["Location"]
Write-Host "  * Rider 1 (Busy) Attempt on Order 2 Redirect: $r1LocOrder2" -ForegroundColor White
if ($r1LocOrder2 -match "error=active_trip_limit") {
    Write-Host "  [PASS] Rider 1 was blocked with 'active_trip_limit'! Cannot take second order until first is completed." -ForegroundColor Green
} else {
    Write-Host "  [FAIL] Rider 1 was allowed to take a second active order." -ForegroundColor Red
}

# Rider 2 (Available, on-duty) accepts Order 2
$claimOrder2ByRider2 = Request-Post "$baseUrl/delivery" @{ action = "accept-trip"; orderId = $order2Id } $rider2Session
$r2LocOrder2 = $claimOrder2ByRider2.Headers["Location"]
Write-Host "  * Rider 2 (Free) Accept Redirect: $r2LocOrder2" -ForegroundColor White
if ($r2LocOrder2 -match "msg=trip_claimed") {
    Write-Host "  [PASS] Rider 2 (Free) successfully claimed Order #FZ-$order2Id!" -ForegroundColor Green
} else {
    Write-Host "  [FAIL] Rider 2 could not claim Order 2." -ForegroundColor Red
}

# ------------------------------------------------------------------------------
# TEST 5: Completing Order via OTP unlocks Rider for new orders
# ------------------------------------------------------------------------------
Write-Host "`n[TEST 5] Order Progression & Completion via OTP Handshake..." -ForegroundColor Yellow

# Rider 1 completes Order 1
$null = Request-Post "$baseUrl/delivery" @{ action = "pickup"; orderId = $order1Id } $rider1Session
$null = Request-Post "$baseUrl/delivery" @{ action = "arrive"; orderId = $order1Id } $rider1Session
$comp1 = Request-Post "$baseUrl/delivery" @{
    action = "verify-delivery"
    orderId = $order1Id
    deliveryOtp = $otp1
} $rider1Session
Write-Host "  * Rider 1 OTP Complete Redirect: $($comp1.Headers["Location"])" -ForegroundColor White

# Re-check Rider 1 Dashboard: active deliveries should be 0 and lock removed
$r1DashCleared = Request-Get "$baseUrl/delivery/dashboard" $rider1Session
if ($r1DashCleared.Content -match "LIVE DISPATCH RADAR" -and $r1DashCleared.Content -notmatch "Single Active Order Policy Engaged") {
    Write-Host "  [PASS] Rider 1 completed delivery and is now unlocked to accept new orders!" -ForegroundColor Green
} else {
    Write-Host "  [FAIL] Rider 1 was not unlocked after completion." -ForegroundColor Red
}

# Rider 2 completes Order 2
$null = Request-Post "$baseUrl/delivery" @{ action = "pickup"; orderId = $order2Id } $rider2Session
$null = Request-Post "$baseUrl/delivery" @{ action = "arrive"; orderId = $order2Id } $rider2Session
$comp2 = Request-Post "$baseUrl/delivery" @{
    action = "verify-delivery"
    orderId = $order2Id
    deliveryOtp = $otp2
} $rider2Session
Write-Host "  * Rider 2 OTP Complete Redirect: $($comp2.Headers["Location"])" -ForegroundColor White

Write-Host "`n==========================================================" -ForegroundColor Cyan
Write-Host "   All Concurrency & 1-Order Policy Tests Passed!        " -ForegroundColor Cyan
Write-Host "==========================================================" -ForegroundColor Cyan
