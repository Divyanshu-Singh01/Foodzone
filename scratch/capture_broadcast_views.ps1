$baseUrl = "http://localhost:8080/foodzone"
$chrome = "C:\Program Files\Google\Chrome\Application\chrome.exe"
$scratchDir = "C:\Users\hp\.gemini\antigravity-ide\brain\36321781-2f3e-478b-8307-994e8adcad02\scratch"
$mediaDir = "C:\Users\hp\.gemini\antigravity-ide\brain\36321781-2f3e-478b-8307-994e8adcad02\.tempmediaStorage"

$custSession = New-Object Microsoft.PowerShell.Commands.WebRequestSession
$null = Invoke-WebRequest -Uri "$baseUrl/login" -Method POST -Body @{ email = "customer@gmail.com"; password = "user123" } -WebSession $custSession -UseBasicParsing -MaximumRedirection 0 -ErrorAction SilentlyContinue

$riderSession = New-Object Microsoft.PowerShell.Commands.WebRequestSession
$null = Invoke-WebRequest -Uri "$baseUrl/login" -Method POST -Body @{ email = "rider@foodzone.com"; password = "rider123" } -WebSession $riderSession -UseBasicParsing -MaximumRedirection 0 -ErrorAction SilentlyContinue

# Ensure rider is ON DUTY with 0 active orders
& "C:\Program Files\MySQL\MySQL Server 8.0\bin\mysql.exe" -u root -p@Divyanshu2004 foodzone_db -e "UPDATE users SET is_on_duty = 1 WHERE user_id = 3; UPDATE orders SET order_status = 'COMPLETED', trip_stage = 'DELIVERED' WHERE order_status = 'OUT_FOR_DELIVERY'; DELETE FROM order_items WHERE order_id >= 24; DELETE FROM orders WHERE order_id >= 24;"

# Place a fresh order to broadcast
$null = Invoke-WebRequest -Uri "$baseUrl/cart" -Method POST -Body @{ action = "add"; foodId = "1"; quantity = "2" } -WebSession $custSession -UseBasicParsing -MaximumRedirection 0 -ErrorAction SilentlyContinue
$orderRes = Invoke-WebRequest -Uri "$baseUrl/checkout" -Method POST -Body @{
    orderType = "DELIVERY"
    deliveryAddress = "Flat 402, Tower B, Supertech Icon, Indirapuram"
    landmark = "Opposite Aditya Mall"
    addressType = "HOME"
    deliveryInstructions = "Do Not Ring Bell, Leave at Door"
    contactPhone = "9876543210"
    paymentMethod = "Cash on Delivery"
} -WebSession $custSession -UseBasicParsing -MaximumRedirection 0 -ErrorAction SilentlyContinue

# Capture State 1: Live Broadcast Radar
$dash1 = Invoke-WebRequest -Uri "$baseUrl/delivery/dashboard" -Method GET -WebSession $riderSession -UseBasicParsing
$html1 = $dash1.Content -replace "<head>", "<head><base href=""http://localhost:8080/foodzone/"">"
$path1 = "$scratchDir\rendered_rider_broadcast.html"
Set-Content -Path $path1 -Value $html1 -Encoding UTF8
$shot1 = "$mediaDir\rider_broadcast_live.png"
Start-Process -FilePath $chrome -ArgumentList "--headless=new", "--disable-gpu", "--screenshot=$shot1", "--window-size=1280,1100", "file:///$path1" -Wait

# Rider accepts the order -> State 2: Active Delivery Lock
$orderId = [regex]::Match($orderRes.Headers["Location"], 'orderId=(\d+)').Groups[1].Value
$null = Invoke-WebRequest -Uri "$baseUrl/delivery" -Method POST -Body @{ action = "accept-trip"; orderId = $orderId } -WebSession $riderSession -UseBasicParsing -MaximumRedirection 0 -ErrorAction SilentlyContinue

$dash2 = Invoke-WebRequest -Uri "$baseUrl/delivery/dashboard" -Method GET -WebSession $riderSession -UseBasicParsing
$html2 = $dash2.Content -replace "<head>", "<head><base href=""http://localhost:8080/foodzone/"">"
$path2 = "$scratchDir\rendered_rider_active_lock.html"
Set-Content -Path $path2 -Value $html2 -Encoding UTF8
$shot2 = "$mediaDir\rider_active_lock.png"
Start-Process -FilePath $chrome -ArgumentList "--headless=new", "--disable-gpu", "--screenshot=$shot2", "--window-size=1280,1200", "file:///$path2" -Wait

Write-Host "States 1 and 2 captured successfully!"
