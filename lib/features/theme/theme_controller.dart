import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Controller for managing theme state
/// Handles theme switching and persistence
class ThemeController extends ChangeNotifier {
  // ==================== CONSTANTS ====================

  static const String _themePrefsKey = 'app_theme_mode';

  // ==================== STATE ====================

  ThemeMode _themeMode = ThemeMode.system;
  SharedPreferences? _prefs;
  bool _isInitialized = false;

  // ==================== GETTERS ====================

  /// Current theme mode
  ThemeMode get themeMode => _themeMode;

  /// Check if theme is dark
  bool get isDark => _themeMode == ThemeMode.dark;

  /// Check if theme is light
  bool get isLight => _themeMode == ThemeMode.light;

  /// Check if theme follows system
  bool get isSystem => _themeMode == ThemeMode.system;

  /// Check if controller is initialized
  bool get isInitialized => _isInitialized;

  // ==================== INITIALIZATION ====================

  /// Initialize controller and load saved theme
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      _prefs = await SharedPreferences.getInstance();
      await _loadThemeMode();
      _isInitialized = true;
      notifyListeners();
    } catch (e) {
      debugPrint('Failed to initialize ThemeController: $e');
      _isInitialized = true;
      notifyListeners();
    }
  }

  // ==================== THEME SWITCHING ====================

  /// Set theme to light mode
  Future<void> setLightMode() async {
    await _setThemeMode(ThemeMode.light);
  }

  /// Set theme to dark mode
  Future<void> setDarkMode() async {
    await _setThemeMode(ThemeMode.dark);
  }

  /// Set theme to system mode
  Future<void> setSystemMode() async {
    await _setThemeMode(ThemeMode.system);
  }

  /// Set specific theme mode
  Future<void> setThemeMode(ThemeMode mode) async {
    await _setThemeMode(mode);
  }

  /// Toggle between light and dark mode
  Future<void> toggleTheme() async {
    if (_themeMode == ThemeMode.light) {
      await setDarkMode();
    } else {
      await setLightMode();
    }
  }

  // ==================== PRIVATE METHODS ====================

  /// Internal method to set theme mode
  Future<void> _setThemeMode(ThemeMode mode) async {
    if (_themeMode == mode) return;

    _themeMode = mode;
    notifyListeners();
    await _saveThemeMode();
  }

  /// Load theme mode from storage
  Future<void> _loadThemeMode() async {
    try {
      final themeModeString = _prefs?.getString(_themePrefsKey);
      if (themeModeString != null) {
        _themeMode = _parseThemeMode(themeModeString);
      }
    } catch (e) {
      debugPrint('Failed to load theme mode: $e');
    }
  }

  /// Save theme mode to storage
  Future<void> _saveThemeMode() async {
    try {
      await _prefs?.setString(_themePrefsKey, _themeModeToString(_themeMode));
    } catch (e) {
      debugPrint('Failed to save theme mode: $e');
    }
  }

  /// Convert ThemeMode to string
  String _themeModeToString(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light:
        return 'light';
      case ThemeMode.dark:
        return 'dark';
      case ThemeMode.system:
        return 'system';
    }
  }

  /// Parse ThemeMode from string
  ThemeMode _parseThemeMode(String value) {
    switch (value) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      case 'system':
      default:
        return ThemeMode.system;
    }
  }

  // ==================== HELPER METHODS ====================

  /// Get actual brightness based on theme mode and platform brightness
  Brightness getActualBrightness(Brightness platformBrightness) {
    if (_themeMode == ThemeMode.light) {
      return Brightness.light;
    } else if (_themeMode == ThemeMode.dark) {
      return Brightness.dark;
    } else {
      return platformBrightness;
    }
  }

  /// Check if current theme is dark (considering system theme)
  bool isCurrentlyDark(Brightness platformBrightness) {
    return getActualBrightness(platformBrightness) == Brightness.dark;
  }

  /// Get theme mode display name
  String get themeModeDisplayName {
    switch (_themeMode) {
      case ThemeMode.light:
        return 'Light';
      case ThemeMode.dark:
        return 'Dark';
      case ThemeMode.system:
        return 'System';
    }
  }

  /// Get theme mode icon
  IconData get themeModeIcon {
    switch (_themeMode) {
      case ThemeMode.light:
        return Icons.light_mode;
      case ThemeMode.dark:
        return Icons.dark_mode;
      case ThemeMode.system:
        return Icons.brightness_auto;
    }
  }

  /// Reset theme to default (system)
  Future<void> reset() async {
    await setSystemMode();
  }

  // ==================== DISPOSE ====================

  @override
  void dispose() {
    super.dispose();
  }
}
