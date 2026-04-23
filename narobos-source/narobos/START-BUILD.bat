@echo off
echo.
echo  _   _                 _      ___  ____
echo  ^| \^| ^| __ _ _ __ ___ ^| ^|__  / _ \/ ___|
echo  ^|  \^| ^|/ _` ^| '__/ _ \^| '_ \^| ^| ^| \___ \
echo  ^| ^|\  ^| (_^| ^| ^| ^| (_) ^| ^|_) ^| ^|_^| ^|___) ^|
echo  ^|_^| \_^|\__,_^|_^|  \___/^|_.__/ \___/^|____/
echo.
echo  NarobOS Build Environment
echo  ----------------------------------------
echo.

REM Check Vagrant is installed
where vagrant >nul 2>&1
if %errorlevel% neq 0 (
    echo  ERROR: Vagrant not found.
    echo  Download from: https://developer.hashicorp.com/vagrant/downloads
    pause
    exit /b 1
)

REM Check VirtualBox is installed
where VBoxManage >nul 2>&1
if %errorlevel% neq 0 (
    echo  ERROR: VirtualBox not found.
    echo  Download from: https://www.virtualbox.org/wiki/Downloads
    pause
    exit /b 1
)

echo  [1/3] Starting VM (first run downloads Ubuntu ~500MB)...
vagrant up

if %errorlevel% neq 0 (
    echo  ERROR: VM failed to start. Check output above.
    pause
    exit /b 1
)

echo.
echo  [2/3] VM is running!
echo  [3/3] Connecting to VM...
echo.
echo  ----------------------------------------
echo  Once inside the VM, run:
echo    cd /narobos
echo    ./build.sh
echo.
echo  The finished ISO will appear in this
echo  folder when the build completes.
echo  ----------------------------------------
echo.

vagrant ssh
