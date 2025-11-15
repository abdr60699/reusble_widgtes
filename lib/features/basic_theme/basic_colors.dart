import 'package:flutter/material.dart';

/// Basic color configuration for your app
///
/// Customize these colors to match your brand
class BasicColors {
  BasicColors._();

  // ========================================
  // LIGHT THEME COLORS - Customize these!
  // ========================================

  /// Primary brand color (Light mode)
  static const Color lightPrimary = Color(0xFF2196F3); // Blue

  /// Secondary accent color (Light mode)
  static const Color lightSecondary = Color(0xFF03DAC6); // Teal

  /// Background color (Light mode)
  static const Color lightBackground = Color(0xFFFFFFFF); // White

  /// Surface color for cards, sheets (Light mode)
  static const Color lightSurface = Color(0xFFFAFAFA); // Off-white

  /// Error color (Light mode)
  static const Color lightError = Color(0xFFB00020); // Red

  /// Text color on light backgrounds
  static const Color lightOnBackground = Color(0xFF000000); // Black

  /// Text color on light surfaces
  static const Color lightOnSurface = Color(0xFF000000); // Black

  // ========================================
  // DARK THEME COLORS - Customize these!
  // ========================================

  /// Primary brand color (Dark mode)
  static const Color darkPrimary = Color(0xFF90CAF9); // Light Blue

  /// Secondary accent color (Dark mode)
  static const Color darkSecondary = Color(0xFF03DAC6); // Teal

  /// Background color (Dark mode)
  static const Color darkBackground = Color(0xFF121212); // Near black

  /// Surface color for cards, sheets (Dark mode)
  static const Color darkSurface = Color(0xFF1E1E1E); // Dark gray

  /// Error color (Dark mode)
  static const Color darkError = Color(0xFFCF6679); // Light red

  /// Text color on dark backgrounds
  static const Color darkOnBackground = Color(0xFFFFFFFF); // White

  /// Text color on dark surfaces
  static const Color darkOnSurface = Color(0xFFFFFFFF); // White

  // ========================================
  // HELPER METHODS
  // ========================================

  /// Get the light color scheme
  static ColorScheme getLightColorScheme() {
    return ColorScheme.light(
      primary: lightPrimary,
      onPrimary: Colors.white,
      primaryContainer: lightPrimary.withOpacity(0.2),
      onPrimaryContainer: lightPrimary,
      secondary: lightSecondary,
      onSecondary: Colors.white,
      secondaryContainer: lightSecondary.withOpacity(0.2),
      onSecondaryContainer: lightSecondary,
      error: lightError,
      onError: Colors.white,
      errorContainer: lightError.withOpacity(0.2),
      onErrorContainer: lightError,
      background: lightBackground,
      onBackground: lightOnBackground,
      surface: lightSurface,
      onSurface: lightOnSurface,
      surfaceVariant: const Color(0xFFF5F5F5),
      onSurfaceVariant: const Color(0xFF424242),
      outline: const Color(0xFFBDBDBD),
      shadow: Colors.black.withOpacity(0.1),
    );
  }

  /// Get the dark color scheme
  static ColorScheme getDarkColorScheme() {
    return ColorScheme.dark(
      primary: darkPrimary,
      onPrimary: Colors.black,
      primaryContainer: darkPrimary.withOpacity(0.3),
      onPrimaryContainer: darkPrimary,
      secondary: darkSecondary,
      onSecondary: Colors.black,
      secondaryContainer: darkSecondary.withOpacity(0.3),
      onSecondaryContainer: darkSecondary,
      error: darkError,
      onError: Colors.black,
      errorContainer: darkError.withOpacity(0.3),
      onErrorContainer: darkError,
      background: darkBackground,
      onBackground: darkOnBackground,
      surface: darkSurface,
      onSurface: darkOnSurface,
      surfaceVariant: const Color(0xFF2C2C2C),
      onSurfaceVariant: const Color(0xFFE0E0E0),
      outline: const Color(0xFF616161),
      shadow: Colors.black.withOpacity(0.5),
    );
  }
}
