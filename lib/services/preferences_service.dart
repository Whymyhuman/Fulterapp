import 'package:shared_preferences/shared_preferences.dart';

class PreferencesService {
  static final PreferencesService _instance = PreferencesService._internal();
  factory PreferencesService() => _instance;
  PreferencesService._internal();

  static SharedPreferences? _prefs;

  Future<SharedPreferences> get prefs async {
    if (_prefs != null) return _prefs!;
    _prefs = await SharedPreferences.getInstance();
    return _prefs!;
  }

  // Theme preferences
  Future<bool> isDarkMode() async {
    final preferences = await prefs;
    return preferences.getBool('isDarkMode') ?? false;
  }

  Future<void> setDarkMode(bool isDark) async {
    final preferences = await prefs;
    await preferences.setBool('isDarkMode', isDark);
  }

  // View preferences
  Future<bool> isGridView() async {
    final preferences = await prefs;
    return preferences.getBool('isGridView') ?? true;
  }

  Future<void> setGridView(bool isGrid) async {
    final preferences = await prefs;
    await preferences.setBool('isGridView', isGrid);
  }

  // Sort preferences
  Future<String> getSortBy() async {
    final preferences = await prefs;
    return preferences.getString('sortBy') ?? 'updatedAt';
  }

  Future<void> setSortBy(String sortBy) async {
    final preferences = await prefs;
    await preferences.setString('sortBy', sortBy);
  }

  Future<bool> isSortAscending() async {
    final preferences = await prefs;
    return preferences.getBool('isSortAscending') ?? false;
  }

  Future<void> setSortAscending(bool isAscending) async {
    final preferences = await prefs;
    await preferences.setBool('isSortAscending', isAscending);
  }

  // Search preferences
  Future<List<String>> getRecentSearches() async {
    final preferences = await prefs;
    return preferences.getStringList('recentSearches') ?? [];
  }

  Future<void> addRecentSearch(String search) async {
    final preferences = await prefs;
    List<String> searches = await getRecentSearches();
    
    // Remove if already exists
    searches.remove(search);
    
    // Add to beginning
    searches.insert(0, search);
    
    // Keep only last 10 searches
    if (searches.length > 10) {
      searches = searches.take(10).toList();
    }
    
    await preferences.setStringList('recentSearches', searches);
  }

  Future<void> clearRecentSearches() async {
    final preferences = await prefs;
    await preferences.remove('recentSearches');
  }

  // Export/Import preferences
  Future<String> getLastExportPath() async {
    final preferences = await prefs;
    return preferences.getString('lastExportPath') ?? '';
  }

  Future<void> setLastExportPath(String path) async {
    final preferences = await prefs;
    await preferences.setString('lastExportPath', path);
  }

  // App settings
  Future<bool> isFirstLaunch() async {
    final preferences = await prefs;
    return preferences.getBool('isFirstLaunch') ?? true;
  }

  Future<void> setFirstLaunch(bool isFirst) async {
    final preferences = await prefs;
    await preferences.setBool('isFirstLaunch', isFirst);
  }

  Future<int> getAppLaunchCount() async {
    final preferences = await prefs;
    return preferences.getInt('appLaunchCount') ?? 0;
  }

  Future<void> incrementAppLaunchCount() async {
    final preferences = await prefs;
    int count = await getAppLaunchCount();
    await preferences.setInt('appLaunchCount', count + 1);
  }

  // Clear all preferences
  Future<void> clearAll() async {
    final preferences = await prefs;
    await preferences.clear();
  }
}

