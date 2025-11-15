import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Simple theme manager that handles theme mode switching
///
/// Supports:
/// - Light mode
/// - Dark mode
/// - System mode (follows device setting)
/// - Persistent storage
class BasicThemeManager extends ChangeNotifier {
  static const String _themeModeKey = 'theme_mode';

  ThemeMode _themeMode = ThemeMode.system;

  /// Get the current theme mode
  ThemeMode get themeMode => _themeMode;

  /// Check if dark mode is currently active
  bool get isDarkMode => _themeMode == ThemeMode.dark;

  /// Check if light mode is currently active
  bool get isLightMode => _themeMode == ThemeMode.light;

  /// Check if system mode is currently active
  bool get isSystemMode => _themeMode == ThemeMode.system;

  /// Initialize and load saved theme preference
  Future<void> initialize() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedMode = prefs.getString(_themeModeKey);

      if (savedMode != null) {
        switch (savedMode) {
          case 'light':
            _themeMode = ThemeMode.light;
            break;
          case 'dark':
            _themeMode = ThemeMode.dark;
            break;
          case 'system':
            _themeMode = ThemeMode.system;
            break;
        }
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error loading theme preference: $e');
    }
  }

  /// Set theme to light mode
  Future<void> setLightMode() async {
    _themeMode = ThemeMode.light;
    await _saveThemeMode('light');
    notifyListeners();
  }

  /// Set theme to dark mode
  Future<void> setDarkMode() async {
    _themeMode = ThemeMode.dark;
    await _saveThemeMode('dark');
    notifyListeners();
  }

  /// Set theme to system mode (follows device setting)
  Future<void> setSystemMode() async {
    _themeMode = ThemeMode.system;
    await _saveThemeMode('system');
    notifyListeners();
  }

  /// Toggle between light and dark mode
  /// (Does not include system mode)
  Future<void> toggleTheme() async {
    if (_themeMode == ThemeMode.light) {
      await setDarkMode();
    } else {
      await setLightMode();
    }
  }

  /// Set theme mode directly
  Future<void> setThemeMode(ThemeMode mode) async {
    _themeMode = mode;
    String modeString;
    switch (mode) {
      case ThemeMode.light:
        modeString = 'light';
        break;
      case ThemeMode.dark:
        modeString = 'dark';
        break;
      case ThemeMode.system:
        modeString = 'system';
        break;
    }
    await _saveThemeMode(modeString);
    notifyListeners();
  }

  /// Save theme mode to persistent storage
  Future<void> _saveThemeMode(String mode) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_themeModeKey, mode);
    } catch (e) {
      debugPrint('Error saving theme preference: $e');
    }
  }

  /// Get display name for current theme mode
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

  /// Get icon for current theme mode
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
}

/// Pre-built theme toggle button widget
///
/// Simple button that cycles through theme modes
class BasicThemeToggleButton extends StatelessWidget {
  final BasicThemeManager themeManager;

  const BasicThemeToggleButton({
    super.key,
    required this.themeManager,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(themeManager.themeModeIcon),
      tooltip: 'Theme: ${themeManager.themeModeDisplayName}',
      onPressed: () {
        // Cycle through modes: Light → Dark → System → Light
        if (themeManager.isLightMode) {
          themeManager.setDarkMode();
        } else if (themeManager.isDarkMode) {
          themeManager.setSystemMode();
        } else {
          themeManager.setLightMode();
        }
      },
    );
  }
}

/// Pre-built theme mode selector widget
///
/// Shows all theme options with radio buttons
class BasicThemeModeSelector extends StatelessWidget {
  final BasicThemeManager themeManager;

  const BasicThemeModeSelector({
    super.key,
    required this.themeManager,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ListTile(
          leading: const Icon(Icons.light_mode),
          title: const Text('Light'),
          trailing: Radio<ThemeMode>(
            value: ThemeMode.light,
            groupValue: themeManager.themeMode,
            onChanged: (value) {
              themeManager.setLightMode();
            },
          ),
          onTap: () => themeManager.setLightMode(),
        ),
        ListTile(
          leading: const Icon(Icons.dark_mode),
          title: const Text('Dark'),
          trailing: Radio<ThemeMode>(
            value: ThemeMode.dark,
            groupValue: themeManager.themeMode,
            onChanged: (value) {
              themeManager.setDarkMode();
            },
          ),
          onTap: () => themeManager.setDarkMode(),
        ),
        ListTile(
          leading: const Icon(Icons.brightness_auto),
          title: const Text('System'),
          subtitle: const Text('Follow device setting'),
          trailing: Radio<ThemeMode>(
            value: ThemeMode.system,
            groupValue: themeManager.themeMode,
            onChanged: (value) {
              themeManager.setSystemMode();
            },
          ),
          onTap: () => themeManager.setSystemMode(),
        ),
      ],
    );
  }
}
