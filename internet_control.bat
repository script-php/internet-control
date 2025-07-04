@echo off
:: Windows Internet Access Control v1.0.0
:: Run as Administrator

setlocal enabledelayedexpansion

echo ==========================================
echo   Internet Access Control
echo ==========================================
echo.

:: Check if running as administrator
net session >nul 2>&1
if %errorLevel% == 0 (
    echo Running as Administrator - OK
) else (
    echo ERROR: This script must be run as Administrator
    echo Right-click and select "Run as Administrator"
    pause
    exit /b 1
)

echo.
echo Choose an option:
echo 1. Block ALL internet access (including Windows system)
echo 2. Add application to allowed list
echo 3. Remove application from allowed list
echo 4. Restore normal internet access
echo 5. View current firewall rules
echo 6. Allow essential Windows services only
echo 7. Create desktop shortcut for quick access
echo 8. Exit
echo.

set /p choice="Enter your choice (1-6): "

if "%choice%"=="1" goto :block_all
if "%choice%"=="2" goto :add_app
if "%choice%"=="3" goto :remove_app
if "%choice%"=="4" goto :restore_access
if "%choice%"=="5" goto :view_rules
if "%choice%"=="6" goto :allow_windows_only
if "%choice%"=="7" goto :create_shortcut
if "%choice%"=="8" goto :exit
goto :invalid_choice

:block_all
echo.
echo WARNING: This will block ALL internet access including Windows system processes!
echo This may cause issues with:
echo - Windows Updates
echo - Time synchronization
echo - Microsoft Store
echo - OneDrive sync
echo - Windows activation checks
echo - Some system stability features
echo.
set /p confirm="Are you sure you want to continue? (y/N): "
if /i not "%confirm%"=="y" (
    echo Operation cancelled.
    pause
    goto :menu
)

echo.
echo Blocking ALL internet access...
echo Creating firewall rules...

:: Block all outbound connections by default - NO EXCEPTIONS
netsh advfirewall set allprofiles firewallpolicy blockinbound,blockoutbound

:: Remove any existing allow rules that might interfere
netsh advfirewall firewall delete rule name="Core Networking - DNS (UDP-Out)"
netsh advfirewall firewall delete rule name="Core Networking - DNS (TCP-Out)"

echo.
echo COMPLETE internet lockdown activated!
echo.
echo IMPORTANT: These settings will PERSIST after reboot!
echo Your computer will start up with no internet access.
echo Keep this script handy to restore access when needed.
echo.
echo NO applications can access the internet until you add them manually.
echo Use option 2 to add specific applications to the allowed list.
pause
goto :menu

:add_app
echo.
echo Adding application to allowed list...
echo.
echo Please provide the full path to the executable file.
echo Example: C:\Program Files\Firefox\firefox.exe
echo.
set /p app_path="Enter full path to application: "

if not exist "%app_path%" (
    echo ERROR: File not found: %app_path%
    pause
    goto :menu
)

:: Extract filename for rule name
for %%i in ("%app_path%") do set app_name=%%~ni

echo.
echo Adding firewall rule for: %app_name%
netsh advfirewall firewall add rule name="Allow %app_name%" dir=out action=allow program="%app_path%"

if %errorlevel% == 0 (
    echo SUCCESS: %app_name% added to allowed list
) else (
    echo ERROR: Failed to add firewall rule
)

pause
goto :menu

:remove_app
echo.
echo Removing application from allowed list...
echo.
echo Current custom rules:
netsh advfirewall firewall show rule dir=out | findstr "Allow.*exe"
echo.
set /p rule_name="Enter the exact rule name to remove: "

netsh advfirewall firewall delete rule name="%rule_name%"

if %errorlevel% == 0 (
    echo SUCCESS: Rule removed
) else (
    echo ERROR: Rule not found or failed to remove
)

pause
goto :menu

:restore_access
echo.
echo Restoring normal internet access...
echo Removing all custom firewall rules...

:: Reset firewall to default settings
netsh advfirewall reset

:: Set default policy back to allow
netsh advfirewall set allprofiles firewallpolicy blockinbound,allowoutbound

echo.
echo Internet access restored to normal!
pause
goto :menu

:view_rules
echo.
echo Current outbound firewall rules:
echo ==========================================
netsh advfirewall firewall show rule dir=out
echo ==========================================
pause
goto :menu

:allow_windows_only
echo.
echo Blocking all internet access except essential Windows services...
echo This allows Windows Updates, time sync, and basic system functions.
echo.

:: Block all outbound connections by default
netsh advfirewall set allprofiles firewallpolicy blockinbound,blockoutbound

:: Allow essential Windows services
netsh advfirewall firewall add rule name="Allow Windows Update" dir=out action=allow program="%systemroot%\system32\svchost.exe"
netsh advfirewall firewall add rule name="Allow Windows System" dir=out action=allow program="%systemroot%\system32\*.exe"
netsh advfirewall firewall add rule name="Allow DNS" dir=out action=allow protocol=UDP localport=53
netsh advfirewall firewall add rule name="Allow DNS TCP" dir=out action=allow protocol=TCP localport=53

echo.
echo Internet access blocked! Only essential Windows services allowed.
echo Use option 2 to add specific applications to the allowed list.
pause
goto :menu

:create_shortcut
echo.
echo Creating desktop shortcut for quick access...
echo.
echo This will create a shortcut on your desktop that runs this script as administrator.
echo Useful for quickly restoring internet access after reboot.
echo.

set desktop=%USERPROFILE%\Desktop
set script_path=%~dp0%~nx0

echo Creating shortcut...
powershell -Command "$WshShell = New-Object -comObject WScript.Shell; $Shortcut = $WshShell.CreateShortcut('%desktop%\Internet Control.lnk'); $Shortcut.TargetPath = '%script_path%'; $Shortcut.Arguments = ''; $Shortcut.WorkingDirectory = '%~dp0'; $Shortcut.IconLocation = 'shell32.dll,27'; $Shortcut.Description = 'Internet Access Control Script'; $Shortcut.Save()"

if exist "%desktop%\Internet Control.lnk" (
    echo SUCCESS: Desktop shortcut created!
    echo You can now quickly access this script from your desktop.
) else (
    echo ERROR: Failed to create shortcut
)

pause
goto :menu

:invalid_choice
echo.
echo Invalid choice. Please enter 1-8.
pause

:menu
cls
goto :start

:exit
echo.
echo Exiting...
exit /b 0

:start
goto :eof