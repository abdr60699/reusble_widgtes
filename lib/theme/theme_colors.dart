import 'package:flutter/material.dart';

/// Design token for colors following Material 3 guidelines
/// This class provides semantic color tokens for light and dark themes
class ThemeColors {
  // Private constructor to prevent instantiation
  ThemeColors._();

  // ==================== LIGHT THEME COLORS ====================

  /// Light theme color scheme based on Material 3
  static const ColorScheme lightColorScheme = ColorScheme(
    brightness: Brightness.light,

    // Primary colors
    primary: Color(0xFF6750A4),           // Material 3 primary
    onPrimary: Color(0xFFFFFFFF),
    primaryContainer: Color(0xFFEADDFF),
    onPrimaryContainer: Color(0xFF21005D),

    // Secondary colors
    secondary: Color(0xFF625B71),
    onSecondary: Color(0xFFFFFFFF),
    secondaryContainer: Color(0xFFE8DEF8),
    onSecondaryContainer: Color(0xFF1D192B),

    // Tertiary colors
    tertiary: Color(0xFF7D5260),
    onTertiary: Color(0xFFFFFFFF),
    tertiaryContainer: Color(0xFFFFD8E4),
    onTertiaryContainer: Color(0xFF31111D),

    // Error colors
    error: Color(0xFFB3261E),
    onError: Color(0xFFFFFFFF),
    errorContainer: Color(0xFFF9DEDC),
    onErrorContainer: Color(0xFF410E0B),

    // Background colors
    background: Color(0xFFFFFBFE),
    onBackground: Color(0xFF1C1B1F),

    // Surface colors
    surface: Color(0xFFFFFBFE),
    onSurface: Color(0xFF1C1B1F),
    surfaceVariant: Color(0xFFE7E0EC),
    onSurfaceVariant: Color(0xFF49454F),

    // Outline
    outline: Color(0xFF79747E),
    outlineVariant: Color(0xFFCAC4D0),

    // Shadow and scrim
    shadow: Color(0xFF000000),
    scrim: Color(0xFF000000),

    // Inverse colors
    inverseSurface: Color(0xFF313033),
    onInverseSurface: Color(0xFFF4EFF4),
    inversePrimary: Color(0xFFD0BCFF),
  );

  // ==================== DARK THEME COLORS ====================

  /// Dark theme color scheme based on Material 3
  static const ColorScheme darkColorScheme = ColorScheme(
    brightness: Brightness.dark,

    // Primary colors
    primary: Color(0xFFD0BCFF),
    onPrimary: Color(0xFF381E72),
    primaryContainer: Color(0xFF4F378B),
    onPrimaryContainer: Color(0xFFEADDFF),

    // Secondary colors
    secondary: Color(0xFFCCC2DC),
    onSecondary: Color(0xFF332D41),
    secondaryContainer: Color(0xFF4A4458),
    onSecondaryContainer: Color(0xFFE8DEF8),

    // Tertiary colors
    tertiary: Color(0xFFEFB8C8),
    onTertiary: Color(0xFF492532),
    tertiaryContainer: Color(0xFF633B48),
    onTertiaryContainer: Color(0xFFFFD8E4),

    // Error colors
    error: Color(0xFFF2B8B5),
    onError: Color(0xFF601410),
    errorContainer: Color(0xFF8C1D18),
    onErrorContainer: Color(0xFFF9DEDC),

    // Background colors
    background: Color(0xFF1C1B1F),
    onBackground: Color(0xFFE6E1E5),

    // Surface colors
    surface: Color(0xFF1C1B1F),
    onSurface: Color(0xFFE6E1E5),
    surfaceVariant: Color(0xFF49454F),
    onSurfaceVariant: Color(0xFFCAC4D0),

    // Outline
    outline: Color(0xFF938F99),
    outlineVariant: Color(0xFF49454F),

    // Shadow and scrim
    shadow: Color(0xFF000000),
    scrim: Color(0xFF000000),

    // Inverse colors
    inverseSurface: Color(0xFFE6E1E5),
    onInverseSurface: Color(0xFF313033),
    inversePrimary: Color(0xFF6750A4),
  );

  // ==================== SEMANTIC COLORS ====================

  /// Success color for positive actions and states
  static const Color success = Color(0xFF4CAF50);
  static const Color successLight = Color(0xFF81C784);
  static const Color successDark = Color(0xFF388E3C);

  /// Warning color for caution states
  static const Color warning = Color(0xFFFFA726);
  static const Color warningLight = Color(0xFFFFB74D);
  static const Color warningDark = Color(0xFFF57C00);

  /// Info color for informational messages
  static const Color info = Color(0xFF29B6F6);
  static const Color infoLight = Color(0xFF4FC3F7);
  static const Color infoDark = Color(0xFF0288D1);

  // ==================== NEUTRAL COLORS ====================

  /// Neutral grays for backgrounds, borders, and disabled states
  static const Color neutral50 = Color(0xFFFAFAFA);
  static const Color neutral100 = Color(0xFFF5F5F5);
  static const Color neutral200 = Color(0xFFEEEEEE);
  static const Color neutral300 = Color(0xFFE0E0E0);
  static const Color neutral400 = Color(0xFFBDBDBD);
  static const Color neutral500 = Color(0xFF9E9E9E);
  static const Color neutral600 = Color(0xFF757575);
  static const Color neutral700 = Color(0xFF616161);
  static const Color neutral800 = Color(0xFF424242);
  static const Color neutral900 = Color(0xFF212121);

  // ==================== OVERLAY COLORS ====================

  /// Overlay colors with opacity for hover, focus, and press states
  static Color get hoverOverlay => Colors.black.withOpacity(0.04);
  static Color get focusOverlay => Colors.black.withOpacity(0.12);
  static Color get pressOverlay => Colors.black.withOpacity(0.10);

  static Color get hoverOverlayDark => Colors.white.withOpacity(0.08);
  static Color get focusOverlayDark => Colors.white.withOpacity(0.12);
  static Color get pressOverlayDark => Colors.white.withOpacity(0.10);

  // ==================== HELPER METHODS ====================

  /// Get color scheme based on theme mode
  static ColorScheme getColorScheme(ThemeMode mode, Brightness platformBrightness) {
    if (mode == ThemeMode.dark) {
      return darkColorScheme;
    } else if (mode == ThemeMode.light) {
      return lightColorScheme;
    } else {
      // System mode
      return platformBrightness == Brightness.dark
          ? darkColorScheme
          : lightColorScheme;
    }
  }

  /// Check if color is light or dark
  static bool isLightColor(Color color) {
    return color.computeLuminance() > 0.5;
  }

  /// Get contrasting color (black or white) for given background
  static Color getContrastColor(Color backgroundColor) {
    return isLightColor(backgroundColor) ? Colors.black : Colors.white;
  }
}
