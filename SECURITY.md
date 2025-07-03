# Security Guidelines

## App Signing and Security

### Keystore Management

This app uses Android app signing for release builds. The signing process is automated through GitHub Actions.

#### Required Secrets

For automated builds, the following secrets must be configured in your GitHub repository:

1. **STORE_PASSWORD**: Password for the keystore file
2. **KEY_PASSWORD**: Password for the signing key
3. **KEY_ALIAS**: Alias name for the signing key
4. **SIGNING_KEY**: Base64 encoded keystore file

#### Setting up Secrets

1. Go to your GitHub repository
2. Navigate to Settings → Secrets and variables → Actions
3. Add the following repository secrets:

```
STORE_PASSWORD=your_keystore_password
KEY_PASSWORD=your_key_password
KEY_ALIAS=your_key_alias
SIGNING_KEY=base64_encoded_keystore_content
```

#### Generating a Keystore

To generate a new keystore for your app:

```bash
keytool -genkey -v -keystore notes-app-key.jks \
        -keyalg RSA -keysize 2048 -validity 10000 \
        -alias notes-app
```

Follow the prompts to set passwords and certificate information.

#### Converting Keystore to Base64

To convert your keystore file to base64 for GitHub secrets:

```bash
base64 -i notes-app-key.jks | tr -d '\n'
```

Copy the output and use it as the `SIGNING_KEY` secret.

### Local Development

For local development, create a `key.properties` file in the `android/` directory:

```properties
storePassword=your_store_password
keyPassword=your_key_password
keyAlias=your_key_alias
storeFile=../path/to/your/keystore.jks
```

**Important**: Never commit `key.properties` or keystore files to version control!

### Security Best Practices

1. **Keystore Security**:
   - Store keystore files securely
   - Use strong passwords
   - Keep backup copies in secure locations
   - Never share keystore files publicly

2. **GitHub Secrets**:
   - Only repository administrators should have access
   - Regularly rotate secrets if compromised
   - Use environment-specific secrets for different deployment stages

3. **Code Security**:
   - Code obfuscation is enabled for release builds
   - ProGuard rules are configured to protect sensitive code
   - No sensitive data is hardcoded in the app

4. **Data Security**:
   - All user data is stored locally on device
   - No data is transmitted to external servers
   - SQLite database is not encrypted (consider encryption for sensitive data)

### Vulnerability Reporting

If you discover a security vulnerability, please report it by:

1. **Do not** create a public GitHub issue
2. Email the maintainers directly
3. Provide detailed information about the vulnerability
4. Allow time for the issue to be addressed before public disclosure

### Security Updates

- Security patches will be released as soon as possible
- Users will be notified through GitHub releases
- Critical security updates will be marked as such in release notes

### Compliance

This app:
- Does not collect personal data
- Stores all data locally on the user's device
- Does not require internet permissions for core functionality
- Follows Android security best practices

### Third-Party Dependencies

All dependencies are regularly updated to their latest secure versions. Security vulnerabilities in dependencies are monitored and addressed promptly.

### Build Security

- All builds are performed in isolated GitHub Actions runners
- Secrets are only accessible during the build process
- Build artifacts are scanned for potential security issues
- Release builds are signed with production certificates

For more information about Android app security, refer to the [Android Security Documentation](https://developer.android.com/topic/security).

