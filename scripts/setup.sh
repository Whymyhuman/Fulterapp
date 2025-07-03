#!/bin/bash

# Setup script for Notes App development environment
# This script sets up everything needed to develop and build the app

set -e  # Exit on any error

echo "🔧 Setting up Notes App Development Environment..."

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
print_status "Checking Flutter installation..."
if ! command -v flutter &> /dev/null; then
    print_error "Flutter is not installed!"
    echo "Please install Flutter from: https://flutter.dev/docs/get-started/install"
    exit 1
else
    print_success "Flutter is installed"
    flutter --version
fi

# Run Flutter doctor
print_status "Running Flutter doctor..."
flutter doctor

# Check for Android toolchain
if flutter doctor | grep -q "Android toolchain.*✗"; then
    print_warning "Android toolchain issues detected. Please resolve them before continuing."
fi

# Clean any existing builds
print_status "Cleaning existing builds..."
flutter clean

# Get dependencies
print_status "Getting Flutter dependencies..."
flutter pub get

# Generate code
print_status "Generating code..."
flutter packages pub run build_runner build --delete-conflicting-outputs

# Create key.properties from template if it doesn't exist
if [ ! -f "android/key.properties" ]; then
    print_status "Creating key.properties from template..."
    cp android/key.properties.template android/key.properties
    print_warning "Please edit android/key.properties with your actual signing configuration"
    print_warning "Or remove it to use debug signing for development"
fi

# Check if Android device/emulator is connected
print_status "Checking for connected devices..."
DEVICES=$(flutter devices)
if echo "$DEVICES" | grep -q "No devices detected"; then
    print_warning "No devices detected. Please connect an Android device or start an emulator."
else
    print_success "Devices found:"
    echo "$DEVICES"
fi

# Run static analysis
print_status "Running static analysis..."
if flutter analyze; then
    print_success "Static analysis passed"
else
    print_warning "Static analysis found issues. Please review and fix them."
fi

# Run tests
print_status "Running tests..."
if flutter test; then
    print_success "All tests passed"
else
    print_warning "Some tests failed. Please review and fix them."
fi

# Create necessary directories
print_status "Creating necessary directories..."
mkdir -p screenshots
mkdir -p docs
mkdir -p assets/images

# Setup Git hooks (if in a Git repository)
if [ -d ".git" ]; then
    print_status "Setting up Git hooks..."
    
    # Pre-commit hook
    cat > .git/hooks/pre-commit << 'EOF'
#!/bin/bash
echo "Running pre-commit checks..."

# Check code formatting
if ! dart format --output=none --set-exit-if-changed .; then
    echo "Code formatting issues found. Run 'dart format .' to fix them."
    exit 1
fi

# Run static analysis
if ! flutter analyze; then
    echo "Static analysis failed. Please fix the issues."
    exit 1
fi

# Run tests
if ! flutter test; then
    echo "Tests failed. Please fix the failing tests."
    exit 1
fi

echo "Pre-commit checks passed!"
EOF
    
    chmod +x .git/hooks/pre-commit
    print_success "Git pre-commit hook installed"
fi

# Setup VS Code configuration (if VS Code is being used)
if command -v code &> /dev/null; then
    print_status "Setting up VS Code configuration..."
    
    mkdir -p .vscode
    
    # VS Code settings
    cat > .vscode/settings.json << 'EOF'
{
    "dart.flutterSdkPath": null,
    "dart.lineLength": 80,
    "dart.closingLabels": true,
    "dart.insertArgumentPlaceholders": false,
    "editor.formatOnSave": true,
    "editor.rulers": [80],
    "files.associations": {
        "*.dart": "dart"
    },
    "dart.debugExternalPackageLibraries": false,
    "dart.debugSdkLibraries": false
}
EOF

    # VS Code launch configuration
    cat > .vscode/launch.json << 'EOF'
{
    "version": "0.2.0",
    "configurations": [
        {
            "name": "Debug",
            "request": "launch",
            "type": "dart",
            "program": "lib/main.dart",
            "args": ["--flavor", "development"]
        },
        {
            "name": "Profile",
            "request": "launch",
            "type": "dart",
            "flutterMode": "profile",
            "program": "lib/main.dart"
        },
        {
            "name": "Release",
            "request": "launch",
            "type": "dart",
            "flutterMode": "release",
            "program": "lib/main.dart"
        }
    ]
}
EOF

    # VS Code tasks
    cat > .vscode/tasks.json << 'EOF'
{
    "version": "2.0.0",
    "tasks": [
        {
            "label": "Flutter: Clean",
            "type": "shell",
            "command": "flutter clean",
            "group": "build"
        },
        {
            "label": "Flutter: Get Dependencies",
            "type": "shell",
            "command": "flutter pub get",
            "group": "build"
        },
        {
            "label": "Flutter: Generate Code",
            "type": "shell",
            "command": "flutter packages pub run build_runner build --delete-conflicting-outputs",
            "group": "build"
        },
        {
            "label": "Flutter: Build APK",
            "type": "shell",
            "command": "flutter build apk --debug",
            "group": "build"
        },
        {
            "label": "Flutter: Run Tests",
            "type": "shell",
            "command": "flutter test",
            "group": "test"
        }
    ]
}
EOF

    print_success "VS Code configuration created"
fi

# Display setup summary
print_success "Setup completed successfully! 🎉"
echo ""
echo "📋 Setup Summary:"
echo "  ✅ Flutter dependencies installed"
echo "  ✅ Code generated"
echo "  ✅ Static analysis completed"
echo "  ✅ Tests executed"
echo "  ✅ Development environment configured"
echo ""
echo "🚀 Next Steps:"
echo "  1. Review and update android/key.properties for signing (optional)"
echo "  2. Connect an Android device or start an emulator"
echo "  3. Run 'flutter run' to start development"
echo "  4. Use './scripts/build.sh' to build APKs"
echo ""
echo "📚 Useful Commands:"
echo "  flutter run                    # Run the app in debug mode"
echo "  flutter run --release          # Run the app in release mode"
echo "  flutter test                   # Run all tests"
echo "  flutter analyze                # Run static analysis"
echo "  dart format .                  # Format all Dart code"
echo "  ./scripts/build.sh debug       # Build debug APK"
echo "  ./scripts/build.sh release     # Build release APK"
echo ""
print_success "Happy coding! 💻"

