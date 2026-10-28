# ========================================================
# FoodZone: Clean Build & WAR Packager (PowerShell)
# ========================================================

$ErrorActionPreference = "Stop"

$projectRoot = $PSScriptRoot
if (-not $projectRoot) { $projectRoot = Get-Location }

$jdkBin = "C:\Program Files\Java\jdk-25.0.4\bin"
$tomcatLib = "C:\apache-tomcat-10.1\lib\servlet-api.jar"
$webappDir = Join-Path $projectRoot "src\main\webapp"
$classesDir = Join-Path $webappDir "WEB-INF\classes"
$targetDir = Join-Path $projectRoot "target"

Write-Host "========================================================" -ForegroundColor Cyan
Write-Host "       FoodZone: Clean Build & WAR Packager            " -ForegroundColor Cyan
Write-Host "========================================================" -ForegroundColor Cyan

# 1. Prepare directories
if (-not (Test-Path $classesDir)) { New-Item -ItemType Directory -Path $classesDir | Out-Null }
if (-not (Test-Path $targetDir)) { New-Item -ItemType Directory -Path $targetDir | Out-Null }

# 2. Copy runtime db.properties
Write-Host "[1/3] Copying runtime database configuration..." -ForegroundColor Yellow
Copy-Item (Join-Path $projectRoot "src\main\resources\db.properties") (Join-Path $classesDir "db.properties") -Force

# 3. Compile Java source files
Write-Host "[2/3] Compiling Java source files with javac..." -ForegroundColor Yellow
$sources = (Get-ChildItem -Recurse -Filter "*.java" -Path (Join-Path $projectRoot "src\main\java")).FullName
$cp = "$classesDir;$tomcatLib;$webappDir\WEB-INF\lib\*"

& "$jdkBin\javac.exe" -cp $cp -d $classesDir $sources

# 4. Package standalone WAR file
Write-Host "[3/3] Packaging standalone deployable target\foodzone.war..." -ForegroundColor Yellow
$warFile = Join-Path $targetDir "foodzone.war"
if (Test-Path $warFile) { Remove-Item -Force $warFile }

& "$jdkBin\jar.exe" -cvf $warFile -C $webappDir . | Out-Null

Write-Host "[SUCCESS] target\foodzone.war created successfully!" -ForegroundColor Green
Write-Host "To deploy to Tomcat: copy target\foodzone.war to C:\apache-tomcat-10.1\webapps\" -ForegroundColor Cyan
Write-Host "========================================================" -ForegroundColor Cyan
