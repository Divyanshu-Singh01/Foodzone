@echo off
setlocal enabledelayedexpansion

echo ========================================================
echo        FoodZone: Clean Build and WAR Packager
echo ========================================================

set "JDK_BIN=C:\Program Files\Java\jdk-25.0.4\bin"
set "TOMCAT_LIB=C:\apache-tomcat-10.1\lib\servlet-api.jar"
set "PROJECT_ROOT=%~dp0"
set "WEBAPP_DIR=%PROJECT_ROOT%src\main\webapp"
set "CLASSES_DIR=%WEBAPP_DIR%\WEB-INF\classes"
set "TARGET_DIR=%PROJECT_ROOT%target"

if not exist "%CLASSES_DIR%" mkdir "%CLASSES_DIR%"
if not exist "%TARGET_DIR%" mkdir "%TARGET_DIR%"

echo [1/3] Copying runtime database configuration...
copy /Y "%PROJECT_ROOT%src\main\resources\db.properties" "%CLASSES_DIR%\db.properties" >nul

echo [2/3] Compiling Java source files with javac...
set "CP=%CLASSES_DIR%;%TOMCAT_LIB%;%WEBAPP_DIR%\WEB-INF\lib\*"

dir /s /B "%PROJECT_ROOT%src\main\java\*.java" > "%TARGET_DIR%\sources.txt"
"%JDK_BIN%\javac.exe" -cp "%CP%" -d "%CLASSES_DIR%" @"%TARGET_DIR%\sources.txt"

if %ERRORLEVEL% neq 0 (
    echo [ERROR] Compilation failed!
    exit /b %ERRORLEVEL%
)

echo [3/3] Creating standalone deployable foodzone.war...
"%JDK_BIN%\jar.exe" -cvf "%TARGET_DIR%\foodzone.war" -C "%WEBAPP_DIR%" . >nul

if %ERRORLEVEL% equ 0 (
    echo [SUCCESS] target\foodzone.war created successfully!
    echo To deploy to Tomcat: copy target\foodzone.war to C:\apache-tomcat-10.1\webapps\
) else (
    echo [ERROR] Failed to package WAR file.
)

echo ========================================================
