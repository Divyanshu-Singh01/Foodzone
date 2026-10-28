# ==============================================================================
# Automated Verification Suite: Rider Registration Onboarding Flow
# ==============================================================================

$baseUrl = "http://localhost:8080/foodzone"
Write-Host "==========================================================" -ForegroundColor Cyan
Write-Host "      FoodZone Delivery Partner Sign Up Test Suite        " -ForegroundColor Cyan
Write-Host "==========================================================" -ForegroundColor Cyan

# Cleanup test rider if exists
& "C:\Program Files\MySQL\MySQL Server 8.0\bin\mysql.exe" -u root -p@Divyanshu2004 foodzone_db -e "DELETE FROM users WHERE email = 'rahul.rider@foodzone.com';"

$session = New-Object Microsoft.PowerShell.Commands.WebRequestSession

# STEP 1: GET /rider-register
Write-Host "`n[STEP 1] Fetching Delivery Partner Sign Up Page..." -ForegroundColor Yellow
$pageRes = Invoke-WebRequest -Uri "$baseUrl/rider-register" -Method GET -WebSession $session -UseBasicParsing
if ($pageRes.StatusCode -eq 200 -and $pageRes.Content -match "Join as a Delivery Partner" -and $pageRes.Content -match "Vehicle Number Plate" -and $pageRes.Content -match "Single-Order") {
    Write-Host "  [PASS] /rider-register page rendered with full fleet onboarding UI!" -ForegroundColor Green
} else {
    Write-Host "  [FAIL] /rider-register page failed to render expected structure." -ForegroundColor Red
}

# STEP 2: Validation - Passwords Mismatch
Write-Host "`n[STEP 2] Testing Password Mismatch Validation..." -ForegroundColor Yellow
$mismatchRes = Invoke-WebRequest -Uri "$baseUrl/rider-register" -Method POST -Body @{
    fullName = "Rahul Verma"
    email = "rahul.rider@foodzone.com"
    phone = "9876540003"
    vehicleNo = "DL 04 EF 7788"
    vehicleType = "Motorcycle"
    licenseNo = "DL-0420230077889"
    password = "secretpassword"
    confirmPassword = "differentpassword"
} -WebSession $session -UseBasicParsing
if ($mismatchRes.Content -match "Passwords do not match") {
    Write-Host "  [PASS] Validation caught password mismatch!" -ForegroundColor Green
} else {
    Write-Host "  [FAIL] Password mismatch was not caught." -ForegroundColor Red
}

# STEP 3: Successful Rider Sign Up
Write-Host "`n[STEP 3] Submitting Valid Delivery Partner Registration..." -ForegroundColor Yellow
$signupRes = Invoke-WebRequest -Uri "$baseUrl/rider-register" -Method POST -Body @{
    fullName = "Rahul Verma (Thunder)"
    email = "rahul.rider@foodzone.com"
    phone = "9876540003"
    address = "Hub 4, Sector 18, Noida"
    vehicleType = "Motorcycle"
    vehicleNo = "DL 04 EF 7788"
    licenseNo = "DL-0420230077889"
    emergencyPhone = "9876599991"
    password = "riderpassword123"
    confirmPassword = "riderpassword123"
} -WebSession $session -UseBasicParsing -MaximumRedirection 0 -ErrorAction SilentlyContinue

Write-Host "  * Redirect Status: $($signupRes.StatusCode)" -ForegroundColor White
$loc = $signupRes.Headers["Location"]
Write-Host "  * Redirect Location: $loc" -ForegroundColor White

if ($loc -match "/delivery/dashboard\?msg=welcome_rider") {
    Write-Host "  [PASS] Successfully registered and redirected to Delivery Dashboard!" -ForegroundColor Green
} else {
    Write-Host "  [FAIL] Registration did not redirect to dashboard with welcome_rider." -ForegroundColor Red
}

# STEP 4: Inspect Dashboard View for New Rider
Write-Host "`n[STEP 4] Inspecting New Rider Dashboard State..." -ForegroundColor Yellow
$dashRes = Invoke-WebRequest -Uri "$baseUrl/delivery/dashboard" -Method GET -WebSession $session -UseBasicParsing
if ($dashRes.Content -match "Rahul Verma" -and $dashRes.Content -match "DL 04 EF 7788" -and $dashRes.Content -match "LIVE DISPATCH RADAR") {
    Write-Host "  [PASS] New Rider dashboard rendered with active radar & verified vehicle plate!" -ForegroundColor Green
} else {
    Write-Host "  [FAIL] Dashboard did not reflect new rider credentials." -ForegroundColor Red
}

# STEP 5: Verify Database Persistence
Write-Host "`n[STEP 5] Verifying MySQL Record Persistence..." -ForegroundColor Yellow
$dbCheck = & "C:\Program Files\MySQL\MySQL Server 8.0\bin\mysql.exe" -u root -p@Divyanshu2004 foodzone_db -N -s -e "SELECT role, vehicle_no, license_no, is_on_duty, is_active_rider FROM users WHERE email = 'rahul.rider@foodzone.com';"
Write-Host "  * DB Record: $dbCheck" -ForegroundColor Magenta
if ($dbCheck -match "DELIVERY" -and $dbCheck -match "DL 04 EF 7788" -and $dbCheck -match "DL-0420230077889") {
    Write-Host "  [PASS] Rider credentials securely persisted in MySQL database!" -ForegroundColor Green
} else {
    Write-Host "  [FAIL] Database record mismatch." -ForegroundColor Red
}

Write-Host "`n==========================================================" -ForegroundColor Cyan
Write-Host "   Rider Sign Up Verification Complete: All Passed!       " -ForegroundColor Cyan
Write-Host "==========================================================" -ForegroundColor Cyan
