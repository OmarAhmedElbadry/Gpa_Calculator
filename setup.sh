#!/bin/bash

# GPA Calculator - Quick Setup Script
# This script automates the setup process for the Flutter app

echo "================================================"
echo "  GPA Calculator - Quick Setup Script"
echo "================================================"
echo ""

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Check if Flutter is installed
echo "Checking Flutter installation..."
if ! command -v flutter &> /dev/null; then
    echo -e "${RED}❌ Flutter is not installed!${NC}"
    echo "Please install Flutter from: https://flutter.dev/docs/get-started/install"
    exit 1
fi
echo -e "${GREEN}✓ Flutter is installed${NC}"

# Check Flutter version
echo ""
echo "Checking Flutter version..."
flutter --version

# Run Flutter Doctor
echo ""
echo "Running Flutter Doctor..."
flutter doctor

# Get dependencies
echo ""
echo "================================================"
echo "Installing dependencies..."
echo "================================================"
flutter pub get

if [ $? -eq 0 ]; then
    echo -e "${GREEN}✓ Dependencies installed successfully${NC}"
else
    echo -e "${RED}❌ Failed to install dependencies${NC}"
    exit 1
fi

# Check for available devices
echo ""
echo "================================================"
echo "Checking available devices..."
echo "================================================"
flutter devices

# Analyze code
echo ""
echo "================================================"
echo "Analyzing code..."
echo "================================================"
flutter analyze

# Build success message
echo ""
echo "================================================"
echo -e "${GREEN}✓ Setup Complete!${NC}"
echo "================================================"
echo ""
echo "To run the app:"
echo "  1. Connect a device or start an emulator"
echo "  2. Run: flutter run"
echo ""
echo "To build release:"
echo "  Android: flutter build apk --release"
echo "  iOS: flutter build ios --release"
echo ""
echo "For more information, see:"
echo "  - README.md"
echo "  - SETUP_GUIDE.md"
echo "  - PROJECT_STRUCTURE.md"
echo ""
echo "Happy coding! 🚀"
