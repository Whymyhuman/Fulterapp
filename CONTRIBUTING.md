# Contributing to Notes App

Thank you for your interest in contributing to Notes App! This document provides guidelines and information for contributors.

## 🤝 How to Contribute

### Reporting Issues

Before creating an issue, please:

1. **Search existing issues** to avoid duplicates
2. **Use the issue templates** when available
3. **Provide detailed information** including:
   - Device information (Android version, device model)
   - App version
   - Steps to reproduce
   - Expected vs actual behavior
   - Screenshots or videos if applicable

### Suggesting Features

We welcome feature suggestions! Please:

1. **Check the roadmap** to see if it's already planned
2. **Create a feature request** with:
   - Clear description of the feature
   - Use cases and benefits
   - Mockups or examples if applicable
   - Implementation considerations

### Code Contributions

#### Getting Started

1. **Fork the repository**
2. **Clone your fork**
   ```bash
   git clone https://github.com/yourusername/notes-app.git
   cd notes-app
   ```

3. **Set up development environment**
   ```bash
   ./scripts/setup.sh
   ```

4. **Create a feature branch**
   ```bash
   git checkout -b feature/your-feature-name
   ```

#### Development Workflow

1. **Make your changes**
   - Follow the coding standards (see below)
   - Add tests for new functionality
   - Update documentation if needed

2. **Test your changes**
   ```bash
   flutter test
   flutter analyze
   dart format .
   ```

3. **Build and test the app**
   ```bash
   ./scripts/build.sh debug
   ```

4. **Commit your changes**
   ```bash
   git add .
   git commit -m "feat: add amazing new feature"
   ```

5. **Push to your fork**
   ```bash
   git push origin feature/your-feature-name
   ```

6. **Create a Pull Request**

## 📝 Coding Standards

### Dart/Flutter Guidelines

Follow the [Dart Style Guide](https://dart.dev/guides/language/effective-dart/style) and [Flutter Best Practices](https://flutter.dev/docs/development/best-practices).

#### Code Formatting

- Use `dart format .` to format code
- Line length: 80 characters
- Use trailing commas for better diffs

#### Naming Conventions

- **Classes**: PascalCase (`NoteCard`, `DatabaseService`)
- **Variables/Functions**: camelCase (`noteTitle`, `saveNote()`)
- **Constants**: lowerCamelCase (`defaultColor`, `maxNoteLength`)
- **Files**: snake_case (`note_card.dart`, `database_service.dart`)

#### Documentation

- Add documentation for public APIs
- Use `///` for documentation comments
- Include examples for complex functions

```dart
/// Creates a new note with the given [title] and [content].
/// 
/// Returns the ID of the created note, or throws an exception
/// if the note could not be saved.
/// 
/// Example:
/// ```dart
/// final noteId = await createNote('My Title', 'My content');
/// ```
Future<int> createNote(String title, String content) async {
  // Implementation
}
```

### Project Structure

Follow the established project structure:

```
lib/
├── models/          # Data models
├── providers/       # State management
├── screens/         # UI screens
├── services/        # Business logic
├── utils/           # Utilities
├── widgets/         # Reusable widgets
└── main.dart        # App entry point
```

### State Management

- Use Provider for state management
- Keep providers focused and single-responsibility
- Use `ChangeNotifier` for mutable state
- Avoid business logic in widgets

### Database

- Use the existing `DatabaseService` for all database operations
- Add proper error handling
- Use transactions for multiple operations
- Test database operations thoroughly

### UI/UX Guidelines

- Follow Material Design principles
- Support both light and dark themes
- Ensure accessibility (semantic labels, contrast)
- Test on different screen sizes
- Use consistent spacing and typography

## 🧪 Testing

### Test Requirements

All contributions must include appropriate tests:

- **Unit tests** for business logic
- **Widget tests** for UI components
- **Integration tests** for user flows

### Running Tests

```bash
# Run all tests
flutter test

# Run tests with coverage
flutter test --coverage

# Run specific test file
flutter test test/models/note_test.dart
```

### Test Guidelines

- Test both happy path and error cases
- Use descriptive test names
- Group related tests
- Mock external dependencies
- Aim for high test coverage (>80%)

Example test structure:

```dart
group('Note Model Tests', () {
  test('should create note with required fields', () {
    // Arrange
    final note = Note(
      title: 'Test',
      content: 'Content',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    // Act & Assert
    expect(note.title, 'Test');
    expect(note.content, 'Content');
  });
});
```

## 📋 Pull Request Guidelines

### Before Submitting

- [ ] Code follows style guidelines
- [ ] Tests pass (`flutter test`)
- [ ] Static analysis passes (`flutter analyze`)
- [ ] Code is formatted (`dart format .`)
- [ ] Documentation is updated
- [ ] CHANGELOG.md is updated (for significant changes)

### PR Description

Include in your PR description:

1. **Summary** of changes
2. **Motivation** for the changes
3. **Testing** performed
4. **Screenshots** for UI changes
5. **Breaking changes** (if any)
6. **Related issues** (use "Fixes #123")

### PR Template

```markdown
## Summary
Brief description of changes

## Changes
- [ ] Feature A
- [ ] Bug fix B
- [ ] Documentation update C

## Testing
- [ ] Unit tests added/updated
- [ ] Manual testing performed
- [ ] Tested on Android devices

## Screenshots
(If applicable)

## Breaking Changes
(If any)

## Related Issues
Fixes #123
```

## 🔄 Review Process

### What to Expect

1. **Automated checks** run on all PRs
2. **Code review** by maintainers
3. **Feedback** and requested changes
4. **Approval** and merge

### Review Criteria

- Code quality and style
- Test coverage
- Performance impact
- Security considerations
- Documentation completeness

## 🚀 Release Process

### Versioning

We use [Semantic Versioning](https://semver.org/):

- **MAJOR**: Breaking changes
- **MINOR**: New features (backward compatible)
- **PATCH**: Bug fixes (backward compatible)

### Release Schedule

- **Patch releases**: As needed for critical bugs
- **Minor releases**: Monthly for new features
- **Major releases**: Quarterly for significant changes

## 🏷️ Commit Message Guidelines

Use [Conventional Commits](https://www.conventionalcommits.org/):

```
<type>[optional scope]: <description>

[optional body]

[optional footer(s)]
```

### Types

- `feat`: New feature
- `fix`: Bug fix
- `docs`: Documentation changes
- `style`: Code style changes (formatting, etc.)
- `refactor`: Code refactoring
- `test`: Adding or updating tests
- `chore`: Maintenance tasks

### Examples

```
feat(notes): add color picker for notes
fix(database): resolve SQLite connection issue
docs(readme): update installation instructions
test(models): add tests for Note model
```

## 🎯 Areas for Contribution

### High Priority

- [ ] Performance optimizations
- [ ] Accessibility improvements
- [ ] Test coverage improvements
- [ ] Documentation updates

### Medium Priority

- [ ] New features from roadmap
- [ ] UI/UX enhancements
- [ ] Code refactoring
- [ ] Internationalization

### Low Priority

- [ ] Code cleanup
- [ ] Minor bug fixes
- [ ] Developer experience improvements

## 📚 Resources

### Learning Resources

- [Flutter Documentation](https://flutter.dev/docs)
- [Dart Language Tour](https://dart.dev/guides/language/language-tour)
- [Material Design Guidelines](https://material.io/design)
- [Provider Package](https://pub.dev/packages/provider)

### Development Tools

- [Flutter Inspector](https://flutter.dev/docs/development/tools/flutter-inspector)
- [Dart DevTools](https://dart.dev/tools/dart-devtools)
- [VS Code Flutter Extension](https://marketplace.visualstudio.com/items?itemName=Dart-Code.flutter)

## 🤔 Questions?

If you have questions about contributing:

1. Check existing issues and discussions
2. Create a new discussion for general questions
3. Create an issue for specific problems
4. Contact maintainers for urgent matters

## 🙏 Recognition

Contributors will be recognized in:

- README.md contributors section
- Release notes for significant contributions
- Special thanks in major releases

Thank you for contributing to Notes App! 🎉

