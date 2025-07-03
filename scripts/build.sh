#!/bin/bash

# Build script for Notes App
# This script automates the build process for development and testing

set -e  # Exit on any error

echo "🚀 Starting Notes App Build Process..."

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if Flutter is installed
if ! command -v flutter &> /dev/null; then
    print_error "Flutter is not installed or not in PATH"
    exit 1
fi

# Check Flutter version
print_status "Checking Flutter version..."
flutter --version

# Clean previous builds
print_status "Cleaning previous builds..."
flutter clean

# Get dependencies
print_status "Getting dependencies..."
flutter pub get

# Generate code
print_status "Generating code..."
flutter packages pub run build_runner build --delete-conflicting-outputs

# Run static analysis
print_status "Running static analysis..."
if flutter analyze; then
    print_success "Static analysis passed"
else
    print_error "Static analysis failed"
    exit 1
fi

# Format code
print_status "Checking code formatting..."
if dart format --output=none --set-exit-if-changed .; then
    print_success "Code formatting is correct"
else
    print_warning "Code formatting issues found. Run 'dart format .' to fix them."
fi

# Run tests
print_status "Running tests..."
if flutter test; then
    print_success "All tests passed"
else
    print_error "Some tests failed"
    exit 1
fi

# Build based on argument
BUILD_TYPE=${1:-debug}

case $BUILD_TYPE in
    "debug")
        print_status "Building debug APK..."
        flutter build apk --debug
        print_success "Debug APK built successfully"
        print_status "APK location: build/app/outputs/flutter-apk/app-debug.apk"
        ;;
    "release")
        print_status "Building release APK..."
        if [ -f "android/key.properties" ]; then
            flutter build apk --release
            print_success "Release APK built successfully"
            print_status "APK location: build/app/outputs/flutter-apk/app-release.apk"
        else
            print_warning "No signing configuration found. Building unsigned release APK..."
            flutter build apk --release
            print_warning "APK is unsigned and cannot be installed on devices"
        fi
        ;;
    "bundle")
        print_status "Building App Bundle..."
        if [ -f "android/key.properties" ]; then
            flutter build appbundle --release
            print_success "App Bundle built successfully"
            print_status "AAB location: build/app/outputs/bundle/release/app-release.aab"
        else
            print_error "Signing configuration required for App Bundle"
            exit 1
        fi
        ;;
    "all")
        print_status "Building all variants..."
        
        # Debug APK
        flutter build apk --debug
        print_success "Debug APK built"
        
        # Release APK (if signing is configured)
        if [ -f "android/key.properties" ]; then
            flutter build apk --release
            print_success "Release APK built"
            
            flutter build appbundle --release
            print_success "App Bundle built"
        else
            print_warning "Skipping signed builds - no signing configuration"
        fi
        ;;
    *)
        print_error "Invalid build type: $BUILD_TYPE"
        echo "Usage: $0 [debug|release|bundle|all]"
        exit 1
        ;;
esac

# Display build information
print_status "Build Information:"
echo "  Build Type: $BUILD_TYPE"
echo "  Flutter Version: $(flutter --version | head -n 1)"
echo "  Dart Version: $(dart --version | cut -d' ' -f4)"
echo "  Build Date: $(date)"

# Check APK size (if release build)
if [ "$BUILD_TYPE" = "release" ] || [ "$BUILD_TYPE" = "all" ]; then
    if [ -f "build/app/outputs/flutter-apk/app-release.apk" ]; then
        APK_SIZE=$(du -h build/app/outputs/flutter-apk/app-release.apk | cut -f1)
        print_status "Release APK size: $APK_SIZE"
    fi
fi

print_success "Build process completed successfully! 🎉"

# Optional: Open build directory
if command -v open &> /dev/null; then
    read -p "Open build directory? (y/n): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        open build/app/outputs/flutter-apk/
    fi
elif command -v xdg-open &> /dev/null; then
    read -p "Open build directory? (y/n): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        xdg-open build/app/outputs/flutter-apk/
    fi
fi

