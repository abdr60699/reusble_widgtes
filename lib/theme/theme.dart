/// Complete Reusable Theme System for Flutter
///
/// This library provides a production-ready, Material 3 compliant theme system
/// that can be plugged into any Flutter application.
///
/// Features:
/// - Material 3 design tokens (colors, typography, spacing, etc.)
/// - Light and dark theme support
/// - System theme support
/// - Theme persistence
/// - Instant theme switching
/// - Riverpod state management
/// - Pre-built theme widgets
///
/// Usage:
/// ```dart
/// import 'package:your_app/theme/theme.dart';
///
/// void main() async {
///   WidgetsFlutterBinding.ensureInitialized();
///   runApp(
///     ProviderScope(
///       child: MyApp(),
///     ),
///   );
/// }
///
/// class MyApp extends ConsumerWidget {
///   @override
///   Widget build(BuildContext context, WidgetRef ref) {
///     final themeMode = ref.watch(themeModeProvider);
///
///     return MaterialApp(
///       title: 'My App',
///       theme: AppTheme.lightTheme,
///       darkTheme: AppTheme.darkTheme,
///       themeMode: themeMode,
///       home: HomeScreen(),
///     );
///   }
/// }
/// ```
library theme;

// ==================== EXPORT ALL THEME COMPONENTS ====================

// Theme configuration
export 'app_theme.dart';

// Design tokens
export 'theme_colors.dart';
export 'theme_text.dart';
export 'theme_spacing.dart';
export 'theme_radii.dart';
export 'theme_icons.dart';

// State management
export 'theme_controller.dart';
export 'theme_provider.dart';

// Flutter dependencies needed for theme
export 'package:flutter/material.dart';
export 'package:flutter_riverpod/flutter_riverpod.dart';
