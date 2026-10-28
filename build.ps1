# ========================================================
# FoodZone: 1-Click Build, Deploy & Run (PowerShell)
# ========================================================

param (
    [switch]$BuildOnly
)

$ErrorActionPreference = "Stop"

$projectRoot = $PSScriptRoot
if (-not $projectRoot) { $projectRoot = (Get-Location).Path }

# 0. Ensure MySQL service is running
$mysqlService = Get-Service -Name "*mysql*" -ErrorAction SilentlyContinue | Select-Object -First 1
if ($mysqlService -and $mysqlService.Status -ne 'Running') {
    Write-Host "[MySQL] Starting database service ($($mysqlService.Name))..." -ForegroundColor Yellow
    Start-Service $mysqlService.Name -ErrorAction SilentlyContinue
}

# 1. Detect Java JDK & Compiler
$javacExec = "javac"
$jarExec = "jar"
$javaHome = $env:JAVA_HOME

if (-not $javaHome -or -not (Test-Path "$javaHome\bin\javac.exe")) {
    $foundJavac = Get-ChildItem -Path 'C:\Program Files\Java', 'C:\Program Files\Eclipse Adoptium' -Filter 'javac.exe' -Recurse -ErrorAction SilentlyContinue | Select-Object -First 1
    if ($foundJavac) {
        $javaHome = $foundJavac.Directory.Parent.FullName
        $javacExec = $foundJavac.FullName
        $jarExec = Join-Path $foundJavac.DirectoryName "jar.exe"
    }
} else {
    $javacExec = Join-Path $javaHome "bin\javac.exe"
    $jarExec = Join-Path $javaHome "bin\jar.exe"
}

# 2. Detect Apache Tomcat 10.1
$tomcatHome = $env:CATALINA_HOME
if (-not $tomcatHome -or -not (Test-Path $tomcatHome)) {
    if (Test-Path "C:\apache-tomcat-10.1") {
        $tomcatHome = "C:\apache-tomcat-10.1"
    }
}

$webappDir = Join-Path $projectRoot "src\main\webapp"
$classesDir = Join-Path $webappDir "WEB-INF\classes"
$targetDir = Join-Path $projectRoot "target"

$tomcatLib = if ($tomcatHome -and (Test-Path "$tomcatHome\lib\servlet-api.jar")) {
    Join-Path $tomcatHome "lib\servlet-api.jar"
} else {
    Join-Path $webappDir "WEB-INF\lib\servlet-api.jar"
}

Write-Host "========================================================" -ForegroundColor Cyan
Write-Host "       FoodZone: 1-Click Build & Run Script            " -ForegroundColor Cyan
Write-Host "========================================================" -ForegroundColor Cyan

# 3. Prepare target and classes folders
if (-not (Test-Path $classesDir)) { New-Item -ItemType Directory -Path $classesDir | Out-Null }
if (-not (Test-Path $targetDir)) { New-Item -ItemType Directory -Path $targetDir | Out-Null }

# 4. Copy runtime db.properties into classes
Write-Host "[1/4] Copying runtime database configuration..." -ForegroundColor Yellow
Copy-Item (Join-Path $projectRoot "src\main\resources\db.properties") (Join-Path $classesDir "db.properties") -Force

# 5. Compile Java source files
Write-Host "[2/4] Compiling Java source files with javac..." -ForegroundColor Yellow
$sources = (Get-ChildItem -Recurse -Filter "*.java" -Path (Join-Path $projectRoot "src\main\java")).FullName
$cp = "$classesDir;$tomcatLib;$webappDir\WEB-INF\lib\*"

& $javacExec -cp $cp -d $classesDir $sources

# 6. Package standalone WAR file
Write-Host "[3/4] Packaging standalone deployable target\foodzone.war..." -ForegroundColor Yellow
$warFile = Join-Path $targetDir "foodzone.war"
if (Test-Path $warFile) { Remove-Item -Force $warFile }

& $jarExec -cvf $warFile -C $webappDir . | Out-Null
Write-Host "[SUCCESS] target\foodzone.war packaged successfully!" -ForegroundColor Green

# 7. Deploy to Tomcat
if ($tomcatHome -and (Test-Path "$tomcatHome\webapps")) {
    Write-Host "[4/4] Deploying FoodZone into Tomcat webapps..." -ForegroundColor Yellow
    # Exploded deployment for instant sync
    Copy-Item -Recurse -Force $webappDir (Join-Path $tomcatHome "webapps\foodzone")
    # WAR deployment
    Copy-Item -Force $warFile (Join-Path $tomcatHome "webapps\foodzone.war")
    Write-Host "[SUCCESS] Deployed to $tomcatHome\webapps\foodzone" -ForegroundColor Green
}

# 8. Start Tomcat and Open Browser (unless -BuildOnly is specified)
if (-not $BuildOnly) {
    if ($tomcatHome -and (Test-Path "$tomcatHome\bin\startup.bat")) {
        $env:CATALINA_HOME = $tomcatHome
        $env:JAVA_HOME = $javaHome
        $env:JRE_HOME = $javaHome

        $isListening = Get-NetTCPConnection -LocalPort 8080 -ErrorAction SilentlyContinue
        if (-not $isListening) {
            Write-Host "`n[Server] Launching Apache Tomcat 10.1 in background window..." -ForegroundColor Cyan
            $startupBat = Join-Path $tomcatHome "bin\startup.bat"
            Start-Process -FilePath "cmd.exe" -ArgumentList "/c `"`"$startupBat`"`"" -WorkingDirectory (Join-Path $tomcatHome "bin")
            Write-Host "Waiting 5 seconds for server initialization..." -ForegroundColor Cyan
            Start-Sleep -Seconds 5
        } else {
            Write-Host "`n[Server] Apache Tomcat is already running on port 8080. Hot reloaded!" -ForegroundColor Green
        }

        $appUrl = "http://localhost:8080/foodzone/home"
        Write-Host "========================================================" -ForegroundColor Green
        Write-Host "   🚀 FoodZone is LIVE at: $appUrl" -ForegroundColor Green
        Write-Host "========================================================" -ForegroundColor Green
        Write-Host "Demo Credentials:" -ForegroundColor Yellow
        Write-Host "  * Admin:    admin@foodzone.com  / admin123" -ForegroundColor White
        Write-Host "  * Customer: customer@gmail.com  / user123" -ForegroundColor White
        Write-Host "========================================================`n" -ForegroundColor Green

        Start-Process $appUrl
    } else {
        Write-Host "[WARN] Apache Tomcat 10.1 not found at $tomcatHome. Please check your Tomcat path." -ForegroundColor Yellow
    }
}

