import 'package:flutter/material.dart';

/// Basic font configuration for your app
///
/// Customize font family, sizes, and weights
class BasicFonts {
  BasicFonts._();

  // ========================================
  // FONT FAMILY - Customize this!
  // ========================================

  /// Primary font family for your app
  ///
  /// To change the font:
  /// 1. Add your font to pubspec.yaml under fonts:
  /// 2. Change this value to your font name
  ///
  /// Example:
  /// ```yaml
  /// fonts:
  ///   - family: Roboto
  ///     fonts:
  ///       - asset: fonts/Roboto-Regular.ttf
  ///       - asset: fonts/Roboto-Bold.ttf
  ///         weight: 700
  /// ```
  static const String fontFamily = 'Roboto'; // Change to your font

  // ========================================
  // FONT SIZES - Customize these!
  // ========================================

  /// Large heading size (e.g., page titles)
  static const double headingLarge = 32.0;

  /// Medium heading size (e.g., section titles)
  static const double headingMedium = 24.0;

  /// Small heading size (e.g., card titles)
  static const double headingSmall = 20.0;

  /// Large body text size
  static const double bodyLarge = 16.0;

  /// Medium body text size (default)
  static const double bodyMedium = 14.0;

  /// Small body text size (e.g., captions)
  static const double bodySmall = 12.0;

  /// Button text size
  static const double button = 14.0;

  // ========================================
  // FONT WEIGHTS - Customize these!
  // ========================================

  /// Bold text weight
  static const FontWeight bold = FontWeight.w700;

  /// Semi-bold text weight
  static const FontWeight semiBold = FontWeight.w600;

  /// Normal text weight
  static const FontWeight normal = FontWeight.w400;

  /// Light text weight
  static const FontWeight light = FontWeight.w300;

  // ========================================
  // TEXT THEME BUILDER
  // ========================================

  /// Get the complete text theme
  static TextTheme getTextTheme({bool isDark = false}) {
    final Color textColor = isDark ? Colors.white : Colors.black;
    final Color secondaryTextColor =
        isDark ? Colors.white70 : Colors.black87;

    return TextTheme(
      // Headings
      headlineLarge: TextStyle(
        fontSize: headingLarge,
        fontWeight: bold,
        fontFamily: fontFamily,
        color: textColor,
        letterSpacing: -0.5,
      ),
      headlineMedium: TextStyle(
        fontSize: headingMedium,
        fontWeight: bold,
        fontFamily: fontFamily,
        color: textColor,
        letterSpacing: -0.25,
      ),
      headlineSmall: TextStyle(
        fontSize: headingSmall,
        fontWeight: semiBold,
        fontFamily: fontFamily,
        color: textColor,
      ),

      // Titles
      titleLarge: TextStyle(
        fontSize: 22.0,
        fontWeight: semiBold,
        fontFamily: fontFamily,
        color: textColor,
      ),
      titleMedium: TextStyle(
        fontSize: 16.0,
        fontWeight: semiBold,
        fontFamily: fontFamily,
        color: textColor,
      ),
      titleSmall: TextStyle(
        fontSize: 14.0,
        fontWeight: semiBold,
        fontFamily: fontFamily,
        color: textColor,
      ),

      // Body text
      bodyLarge: TextStyle(
        fontSize: bodyLarge,
        fontWeight: normal,
        fontFamily: fontFamily,
        color: textColor,
        height: 1.5,
      ),
      bodyMedium: TextStyle(
        fontSize: bodyMedium,
        fontWeight: normal,
        fontFamily: fontFamily,
        color: textColor,
        height: 1.5,
      ),
      bodySmall: TextStyle(
        fontSize: bodySmall,
        fontWeight: normal,
        fontFamily: fontFamily,
        color: secondaryTextColor,
        height: 1.4,
      ),

      // Labels
      labelLarge: TextStyle(
        fontSize: button,
        fontWeight: semiBold,
        fontFamily: fontFamily,
        color: textColor,
        letterSpacing: 0.5,
      ),
      labelMedium: TextStyle(
        fontSize: 12.0,
        fontWeight: normal,
        fontFamily: fontFamily,
        color: secondaryTextColor,
        letterSpacing: 0.5,
      ),
      labelSmall: TextStyle(
        fontSize: 10.0,
        fontWeight: normal,
        fontFamily: fontFamily,
        color: secondaryTextColor,
        letterSpacing: 0.5,
      ),
    );
  }
}
