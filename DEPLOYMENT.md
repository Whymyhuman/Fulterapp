# Deployment Guide

This guide provides step-by-step instructions for deploying the Notes App to GitHub and setting up automated builds.

## 📋 Prerequisites

Before deploying, ensure you have:

- [x] Flutter SDK installed (3.22.2 or higher)
- [x] Android SDK and tools configured
- [x] Git installed and configured
- [x] GitHub account
- [x] Android keystore for signing (optional for development)

## 🚀 Quick Deployment

### 1. Repository Setup

1. **Create a new repository** on GitHub:
   ```
   Repository name: notes-app (or your preferred name)
   Description: A comprehensive notes application built with Flutter
   Visibility: Public or Private
   ```

2. **Clone this project** to your local machine:
   ```bash
   git clone <your-repo-url>
   cd notes-app
   ```

3. **Initialize Git** (if not already done):
   ```bash
   git init
   git add .
   git commit -m "Initial commit: Complete Notes App implementation"
   git branch -M main
   git remote add origin <your-repo-url>
   git push -u origin main
   ```

### 2. GitHub Actions Setup

The repository includes pre-configured GitHub Actions workflows:

- **build-and-release.yml**: Automatic builds on push to main
- **pr-check.yml**: Code quality checks on pull requests
- **signed-release.yml**: Production-ready signed builds

#### Configure Secrets (Optional - for signed releases)

1. Go to your GitHub repository
2. Navigate to **Settings** → **Secrets and variables** → **Actions**
3. Add the following repository secrets:

```
STORE_PASSWORD=your_keystore_password
KEY_PASSWORD=your_key_password
KEY_ALIAS=your_key_alias
SIGNING_KEY=base64_encoded_keystore_content
```

#### Generate Keystore (if needed)

```bash
keytool -genkey -v -keystore notes-app-key.jks \
        -keyalg RSA -keysize 2048 -validity 10000 \
        -alias notes-app
```

Convert to base64:
```bash
base64 -i notes-app-key.jks | tr -d '\n'
```

### 3. First Build

Push any change to trigger the first automated build:

```bash
git add .
git commit -m "Trigger first automated build"
git push origin main
```

## 📱 Manual Build Process

### Development Build

```bash
# Setup environment
./scripts/setup.sh

# Build debug APK
./scripts/build.sh debug
```

### Production Build

```bash
# Build release APK (requires signing configuration)
./scripts/build.sh release

# Build App Bundle for Play Store
./scripts/build.sh bundle
```

## 🔧 Configuration

### App Configuration

Edit the following files to customize your app:

1. **pubspec.yaml**: App name, version, dependencies
2. **android/app/build.gradle**: Package name, version codes
3. **android/app/src/main/AndroidManifest.xml**: App permissions, metadata

### Signing Configuration

1. Copy the template:
   ```bash
   cp android/key.properties.template android/key.properties
   ```

2. Edit `android/key.properties` with your keystore details:
   ```properties
   storePassword=your_store_password
   keyPassword=your_key_password
   keyAlias=your_key_alias
   storeFile=../path/to/your/keystore.jks
   ```

## 🌐 GitHub Pages (Optional)

To deploy documentation to GitHub Pages:

1. Enable GitHub Pages in repository settings
2. Select source: GitHub Actions
3. The documentation will be available at: `https://yourusername.github.io/notes-app`

## 📦 Release Process

### Automatic Releases

Releases are automatically created when:
- Pushing to the `main` branch
- Creating a tag with format `v*` (e.g., `v1.0.0`)

### Manual Release

1. **Create a tag**:
   ```bash
   git tag v1.0.0
   git push origin v1.0.0
   ```

2. **Use GitHub interface**:
   - Go to Releases → Create a new release
   - Choose the tag or create a new one
   - Add release notes
   - Upload APK files manually if needed

### Version Management

Version numbers are managed in `pubspec.yaml`:

```yaml
version: 1.0.0+1
#        ^     ^
#        |     build number
#        version name
```

The build number is automatically incremented by GitHub Actions.

## 🔍 Monitoring

### Build Status

Monitor build status through:
- GitHub Actions tab in your repository
- Email notifications (if enabled)
- Status badges in README.md

### Release Monitoring

Track releases through:
- GitHub Releases page
- Download statistics
- User feedback and issues

## 🐛 Troubleshooting

### Common Issues

1. **Build Failures**:
   - Check GitHub Actions logs
   - Verify Flutter and Dart versions
   - Ensure all dependencies are compatible

2. **Signing Issues**:
   - Verify keystore file and passwords
   - Check base64 encoding of keystore
   - Ensure secrets are correctly configured

3. **Test Failures**:
   - Run tests locally: `flutter test`
   - Check for breaking changes in dependencies
   - Update test expectations if needed

### Debug Commands

```bash
# Check Flutter installation
flutter doctor

# Analyze code issues
flutter analyze

# Run tests with verbose output
flutter test --verbose

# Clean and rebuild
flutter clean && flutter pub get
```

## 📊 Analytics and Monitoring

### GitHub Insights

Monitor your repository through GitHub Insights:
- Traffic and clones
- Popular content
- Community engagement

### App Performance

Consider integrating:
- Firebase Analytics
- Crashlytics for crash reporting
- Performance monitoring tools

## 🔄 Continuous Integration

The project includes comprehensive CI/CD:

### On Pull Requests:
- Code formatting checks
- Static analysis
- Unit and widget tests
- Debug build verification

### On Main Branch:
- All PR checks
- Release build creation
- Automatic GitHub release
- Version number increment

### On Tags:
- Signed release builds
- Production-ready artifacts
- Comprehensive release notes

## 📚 Additional Resources

- [Flutter Deployment Guide](https://flutter.dev/docs/deployment)
- [GitHub Actions Documentation](https://docs.github.com/en/actions)
- [Android App Signing](https://developer.android.com/studio/publish/app-signing)
- [Google Play Console](https://play.google.com/console)

## 🆘 Support

If you encounter issues during deployment:

1. Check the troubleshooting section above
2. Review GitHub Actions logs
3. Create an issue in the repository
4. Contact the maintainers

---

**Happy Deploying! 🚀**

