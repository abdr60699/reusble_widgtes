import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'theme_controller.dart';
import 'app_theme.dart';

/// Riverpod provider for theme management
/// Provides access to theme state and controls throughout the app

// ==================== THEME CONTROLLER PROVIDER ====================

/// Provider for ThemeController
/// This manages the theme state and persistence
final themeControllerProvider = ChangeNotifierProvider<ThemeController>((ref) {
  final controller = ThemeController();
  // Initialize controller asynchronously
  controller.initialize();
  return controller;
});

// ==================== THEME MODE PROVIDER ====================

/// Provider for current ThemeMode
/// Watches the theme controller and provides the current theme mode
final themeModeProvider = Provider<ThemeMode>((ref) {
  final controller = ref.watch(themeControllerProvider);
  return controller.themeMode;
});

// ==================== THEME DATA PROVIDERS ====================

/// Provider for light ThemeData
final lightThemeProvider = Provider<ThemeData>((ref) {
  return AppTheme.lightTheme;
});

/// Provider for dark ThemeData
final darkThemeProvider = Provider<ThemeData>((ref) {
  return AppTheme.darkTheme;
});

/// Provider for current ThemeData based on ThemeMode
/// Automatically switches between light and dark based on system settings
final currentThemeProvider = Provider<ThemeData>((ref) {
  final themeMode = ref.watch(themeModeProvider);
  final platformBrightness = WidgetsBinding.instance.platformDispatcher.platformBrightness;

  return AppTheme.getTheme(themeMode, platformBrightness);
});

// ==================== BRIGHTNESS PROVIDER ====================

/// Provider for current brightness (light/dark)
/// Takes into account system theme when in system mode
final currentBrightnessProvider = Provider<Brightness>((ref) {
  final controller = ref.watch(themeControllerProvider);
  final platformBrightness = WidgetsBinding.instance.platformDispatcher.platformBrightness;

  return controller.getActualBrightness(platformBrightness);
});

/// Provider to check if current theme is dark
final isDarkThemeProvider = Provider<bool>((ref) {
  final brightness = ref.watch(currentBrightnessProvider);
  return brightness == Brightness.dark;
});

// ==================== THEME ACTIONS ====================

/// Helper class for theme-related actions
/// Use this to trigger theme changes from widgets
class ThemeActions {
  final WidgetRef ref;

  ThemeActions(this.ref);

  /// Set light theme
  Future<void> setLightMode() async {
    await ref.read(themeControllerProvider).setLightMode();
  }

  /// Set dark theme
  Future<void> setDarkMode() async {
    await ref.read(themeControllerProvider).setDarkMode();
  }

  /// Set system theme
  Future<void> setSystemMode() async {
    await ref.read(themeControllerProvider).setSystemMode();
  }

  /// Toggle between light and dark
  Future<void> toggleTheme() async {
    await ref.read(themeControllerProvider).toggleTheme();
  }

  /// Set specific theme mode
  Future<void> setThemeMode(ThemeMode mode) async {
    await ref.read(themeControllerProvider).setThemeMode(mode);
  }

  /// Reset to system theme
  Future<void> reset() async {
    await ref.read(themeControllerProvider).reset();
  }
}

// ==================== HELPER EXTENSION ====================

/// Extension on WidgetRef for easier theme access
extension ThemeRefExtension on WidgetRef {
  /// Get theme actions
  ThemeActions get themeActions => ThemeActions(this);

  /// Get current theme mode
  ThemeMode get themeMode => watch(themeModeProvider);

  /// Get current theme data
  ThemeData get currentTheme => watch(currentThemeProvider);

  /// Check if dark theme is active
  bool get isDarkTheme => watch(isDarkThemeProvider);

  /// Get current brightness
  Brightness get brightness => watch(currentBrightnessProvider);
}

// ==================== CONSUMER WIDGETS ====================

/// Convenient widget to access theme in widget tree
/// Alternative to Consumer/ConsumerWidget when you only need theme
class ThemeBuilder extends ConsumerWidget {
  final Widget Function(BuildContext context, ThemeData theme, bool isDark) builder;

  const ThemeBuilder({
    Key? key,
    required this.builder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.watch(currentThemeProvider);
    final isDark = ref.watch(isDarkThemeProvider);

    return builder(context, theme, isDark);
  }
}

/// Theme toggle button widget
/// Pre-built widget for theme switching
class ThemeToggleButton extends ConsumerWidget {
  final bool showLabel;
  final IconData? lightIcon;
  final IconData? darkIcon;
  final IconData? systemIcon;

  const ThemeToggleButton({
    Key? key,
    this.showLabel = false,
    this.lightIcon,
    this.darkIcon,
    this.systemIcon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(themeControllerProvider);
    final themeMode = controller.themeMode;

    IconData icon;
    String label;

    switch (themeMode) {
      case ThemeMode.light:
        icon = lightIcon ?? Icons.light_mode;
        label = 'Light';
        break;
      case ThemeMode.dark:
        icon = darkIcon ?? Icons.dark_mode;
        label = 'Dark';
        break;
      case ThemeMode.system:
        icon = systemIcon ?? Icons.brightness_auto;
        label = 'System';
        break;
    }

    if (showLabel) {
      return TextButton.icon(
        onPressed: () => controller.toggleTheme(),
        icon: Icon(icon),
        label: Text(label),
      );
    }

    return IconButton(
      icon: Icon(icon),
      onPressed: () => controller.toggleTheme(),
      tooltip: 'Toggle theme',
    );
  }
}

/// Theme mode selector widget
/// Shows all theme options (Light, Dark, System)
class ThemeModeSelector extends ConsumerWidget {
  final bool showIcons;

  const ThemeModeSelector({
    Key? key,
    this.showIcons = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(themeControllerProvider);
    final currentMode = controller.themeMode;

    return SegmentedButton<ThemeMode>(
      segments: [
        ButtonSegment<ThemeMode>(
          value: ThemeMode.light,
          label: Text('Light'),
          icon: showIcons ? const Icon(Icons.light_mode) : null,
        ),
        ButtonSegment<ThemeMode>(
          value: ThemeMode.dark,
          label: Text('Dark'),
          icon: showIcons ? const Icon(Icons.dark_mode) : null,
        ),
        ButtonSegment<ThemeMode>(
          value: ThemeMode.system,
          label: Text('System'),
          icon: showIcons ? const Icon(Icons.brightness_auto) : null,
        ),
      ],
      selected: {currentMode},
      onSelectionChanged: (Set<ThemeMode> selected) {
        controller.setThemeMode(selected.first);
      },
    );
  }
}
