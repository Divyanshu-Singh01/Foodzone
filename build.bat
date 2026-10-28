@echo off
setlocal enabledelayedexpansion

echo ========================================================
echo        FoodZone: Clean Build and WAR Packager
echo ========================================================

set "JAVAC_CMD=javac"
set "JAR_CMD=jar"

where javac >nul 2>nul
if %ERRORLEVEL% neq 0 (
    if defined JAVA_HOME (
        set "JAVAC_CMD=%JAVA_HOME%\bin\javac.exe"
        set "JAR_CMD=%JAVA_HOME%\bin\jar.exe"
    ) else if exist "C:\Program Files\Java\jdk-25.0.4\bin\javac.exe" (
        set "JAVAC_CMD=C:\Program Files\Java\jdk-25.0.4\bin\javac.exe"
        set "JAR_CMD=C:\Program Files\Java\jdk-25.0.4\bin\jar.exe"
    )
)

set "PROJECT_ROOT=%~dp0"
set "WEBAPP_DIR=%PROJECT_ROOT%src\main\webapp"
set "CLASSES_DIR=%WEBAPP_DIR%\WEB-INF\classes"
set "TARGET_DIR=%PROJECT_ROOT%target"

set "TOMCAT_LIB=C:\apache-tomcat-10.1\lib\servlet-api.jar"
if not exist "%TOMCAT_LIB%" (
    set "TOMCAT_LIB=%WEBAPP_DIR%\WEB-INF\lib\servlet-api.jar"
)

if not exist "%CLASSES_DIR%" mkdir "%CLASSES_DIR%"
if not exist "%TARGET_DIR%" mkdir "%TARGET_DIR%"

echo [1/3] Copying runtime database configuration...
copy /Y "%PROJECT_ROOT%src\main\resources\db.properties" "%CLASSES_DIR%\db.properties" >nul

echo [2/3] Compiling Java source files with javac...
set "CP=%CLASSES_DIR%;%TOMCAT_LIB%;%WEBAPP_DIR%\WEB-INF\lib\*"

dir /s /B "%PROJECT_ROOT%src\main\java\*.java" > "%TARGET_DIR%\sources.txt"
"%JAVAC_CMD%" -cp "%CP%" -d "%CLASSES_DIR%" @"%TARGET_DIR%\sources.txt"

if %ERRORLEVEL% neq 0 (
    echo [ERROR] Compilation failed!
    exit /b %ERRORLEVEL%
)

echo [3/3] Creating standalone deployable foodzone.war...
"%JAR_CMD%" -cvf "%TARGET_DIR%\foodzone.war" -C "%WEBAPP_DIR%" . >nul

if %ERRORLEVEL% equ 0 (
    echo [SUCCESS] target\foodzone.war created successfully!
    if exist "C:\apache-tomcat-10.1\webapps" (
        echo [4/4] Deploying to Apache Tomcat 10.1...
        xcopy /E /I /Y /Q "%WEBAPP_DIR%" "C:\apache-tomcat-10.1\webapps\foodzone" >nul
        copy /Y "%TARGET_DIR%\foodzone.war" "C:\apache-tomcat-10.1\webapps\" >nul
        echo [SUCCESS] Deployed to C:\apache-tomcat-10.1\webapps\foodzone

        if exist "C:\apache-tomcat-10.1\bin\startup.bat" (
            echo Launching Tomcat server...
            set "CATALINA_HOME=C:\apache-tomcat-10.1"
            start "" "C:\apache-tomcat-10.1\bin\startup.bat"
            timeout /t 3 >nul
            start http://localhost:8080/foodzone/home
        )
    )
) else (
    echo [ERROR] Failed to package WAR file.
)

echo ========================================================
