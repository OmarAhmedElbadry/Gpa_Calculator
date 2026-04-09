@echo off
REM GPA Calculator - Quick Setup Script for Windows
REM This script automates the setup process for the Flutter app

echo ================================================
echo   GPA Calculator - Quick Setup Script
echo ================================================
echo.

REM Check if Flutter is installed
echo Checking Flutter installation...
where flutter >nul 2>&1
if %errorlevel% neq 0 (
    echo [ERROR] Flutter is not installed!
    echo Please install Flutter from: https://flutter.dev/docs/get-started/install
    pause
    exit /b 1
)
echo [OK] Flutter is installed
echo.

REM Check Flutter version
echo Checking Flutter version...
flutter --version
echo.

REM Run Flutter Doctor
echo Running Flutter Doctor...
flutter doctor
echo.

REM Get dependencies
echo ================================================
echo Installing dependencies...
echo ================================================
flutter pub get

if %errorlevel% neq 0 (
    echo [ERROR] Failed to install dependencies
    pause
    exit /b 1
)
echo [OK] Dependencies installed successfully
echo.

REM Check for available devices
echo ================================================
echo Checking available devices...
echo ================================================
flutter devices
echo.

REM Analyze code
echo ================================================
echo Analyzing code...
echo ================================================
flutter analyze
echo.

REM Build success message
echo ================================================
echo [OK] Setup Complete!
echo ================================================
echo.
echo To run the app:
echo   1. Connect a device or start an emulator
echo   2. Run: flutter run
echo.
echo To build release:
echo   Android: flutter build apk --release
echo   iOS: flutter build ios --release
echo.
echo For more information, see:
echo   - README.md
echo   - SETUP_GUIDE.md
echo   - PROJECT_STRUCTURE.md
echo.
echo Happy coding!
echo.
pause
