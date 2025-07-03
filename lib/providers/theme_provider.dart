import 'package:flutter/material.dart';
import '../services/preferences_service.dart';

class ThemeProvider with ChangeNotifier {
  final PreferencesService _preferencesService = PreferencesService();
  
  bool _isDarkMode = false;
  bool _isGridView = true;

  bool get isDarkMode => _isDarkMode;
  bool get isGridView => _isGridView;

  ThemeData get themeData {
    return _isDarkMode ? _darkTheme : _lightTheme;
  }

  // Light theme
  static final ThemeData _lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    colorScheme: ColorScheme.fromSeed(
      seedColor: Colors.blue,
      brightness: Brightness.light,
    ),
    appBarTheme: const AppBarTheme(
      elevation: 0,
      centerTitle: true,
      backgroundColor: Colors.transparent,
      foregroundColor: Colors.black87,
    ),
    cardTheme: CardTheme(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      elevation: 4,
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      filled: true,
      fillColor: Colors.grey[50],
    ),
  );

  // Dark theme
  static final ThemeData _darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: ColorScheme.fromSeed(
      seedColor: Colors.blue,
      brightness: Brightness.dark,
    ),
    appBarTheme: const AppBarTheme(
      elevation: 0,
      centerTitle: true,
      backgroundColor: Colors.transparent,
      foregroundColor: Colors.white,
    ),
    cardTheme: CardTheme(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      elevation: 4,
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      filled: true,
      fillColor: Colors.grey[900],
    ),
  );

  // Initialize theme from preferences
  Future<void> initializeTheme() async {
    _isDarkMode = await _preferencesService.isDarkMode();
    _isGridView = await _preferencesService.isGridView();
    notifyListeners();
  }

  // Toggle dark mode
  Future<void> toggleDarkMode() async {
    _isDarkMode = !_isDarkMode;
    await _preferencesService.setDarkMode(_isDarkMode);
    notifyListeners();
  }

  // Set dark mode
  Future<void> setDarkMode(bool isDark) async {
    if (_isDarkMode != isDark) {
      _isDarkMode = isDark;
      await _preferencesService.setDarkMode(_isDarkMode);
      notifyListeners();
    }
  }

  // Toggle grid view
  Future<void> toggleGridView() async {
    _isGridView = !_isGridView;
    await _preferencesService.setGridView(_isGridView);
    notifyListeners();
  }

  // Set grid view
  Future<void> setGridView(bool isGrid) async {
    if (_isGridView != isGrid) {
      _isGridView = isGrid;
      await _preferencesService.setGridView(_isGridView);
      notifyListeners();
    }
  }

  // Get note colors for light/dark theme
  List<Color> get noteColors {
    if (_isDarkMode) {
      return [
        Colors.grey[800]!,
        Colors.red[900]!,
        Colors.pink[900]!,
        Colors.purple[900]!,
        Colors.deepPurple[900]!,
        Colors.indigo[900]!,
        Colors.blue[900]!,
        Colors.lightBlue[900]!,
        Colors.cyan[900]!,
        Colors.teal[900]!,
        Colors.green[900]!,
        Colors.lightGreen[900]!,
        Colors.lime[900]!,
        Colors.yellow[900]!,
        Colors.amber[900]!,
        Colors.orange[900]!,
        Colors.deepOrange[900]!,
        Colors.brown[800]!,
      ];
    } else {
      return [
        Colors.white,
        Colors.red[100]!,
        Colors.pink[100]!,
        Colors.purple[100]!,
        Colors.deepPurple[100]!,
        Colors.indigo[100]!,
        Colors.blue[100]!,
        Colors.lightBlue[100]!,
        Colors.cyan[100]!,
        Colors.teal[100]!,
        Colors.green[100]!,
        Colors.lightGreen[100]!,
        Colors.lime[100]!,
        Colors.yellow[100]!,
        Colors.amber[100]!,
        Colors.orange[100]!,
        Colors.deepOrange[100]!,
        Colors.brown[100]!,
      ];
    }
  }

  // Convert color to hex string
  String colorToHex(Color color) {
    return '#${color.value.toRadixString(16).padLeft(8, '0').substring(2)}';
  }

  // Convert hex string to color
  Color hexToColor(String hex) {
    try {
      return Color(int.parse(hex.substring(1), radix: 16) + 0xFF000000);
    } catch (e) {
      return _isDarkMode ? Colors.grey[800]! : Colors.white;
    }
  }
}

