@echo off
SETLOCAL

:: --- Check if Python is installed ---
python --version >nul 2>&1
IF %ERRORLEVEL% EQU 0 (
    echo Python is already installed.
) ELSE (
    echo Python not found. Installing Python via Chocolatey...
    :: Check if Chocolatey is installed
    choco -v >nul 2>&1
    IF %ERRORLEVEL% NEQ 0 (
        echo Chocolatey not found. Installing Chocolatey...
        @powershell -NoProfile -ExecutionPolicy Bypass -Command ^
        "Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))"
        IF %ERRORLEVEL% NEQ 0 (
            echo Failed to install Chocolatey. Exiting.
            pause
            exit /b 1
        )
    )

    :: Install Python using Chocolatey
    choco install -y python
    IF %ERRORLEVEL% NEQ 0 (
        echo Failed to install Python. Exiting.
        pause
        exit /b 1
    )
)

:: --- Run the Python script ---
echo Running genvideos.py...
python "%~dp0genvideos.py"

IF %ERRORLEVEL% EQU 0 (
    echo genvideos.py finished successfully.
) ELSE (
    echo genvideos.py encountered an error.
)

pause
ENDLOCAL
