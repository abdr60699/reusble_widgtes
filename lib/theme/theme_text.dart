import 'package:flutter/material.dart';

/// Design tokens for typography following Material 3 guidelines
/// Provides semantic text styles for consistent typography across the app
class ThemeText {
  // Private constructor to prevent instantiation
  ThemeText._();

  // ==================== FONT FAMILY ====================

  /// Default font family for the app
  /// You can change this to your custom font family
  static const String fontFamily = 'Roboto';
  static const String fontFamilyDisplay = 'Roboto'; // For large display text

  // ==================== DISPLAY TEXT STYLES ====================
  // Large, expressive text for hero sections and marketing

  /// Display Large - 57px / 64px line height
  /// Use for: Hero headlines, marketing headers
  static const TextStyle displayLarge = TextStyle(
    fontFamily: fontFamilyDisplay,
    fontSize: 57.0,
    height: 1.12,
    letterSpacing: -0.25,
    fontWeight: FontWeight.w400,
  );

  /// Display Medium - 45px / 52px line height
  /// Use for: Section headlines
  static const TextStyle displayMedium = TextStyle(
    fontFamily: fontFamilyDisplay,
    fontSize: 45.0,
    height: 1.16,
    letterSpacing: 0.0,
    fontWeight: FontWeight.w400,
  );

  /// Display Small - 36px / 44px line height
  /// Use for: Subsection headlines
  static const TextStyle displaySmall = TextStyle(
    fontFamily: fontFamilyDisplay,
    fontSize: 36.0,
    height: 1.22,
    letterSpacing: 0.0,
    fontWeight: FontWeight.w400,
  );

  // ==================== HEADLINE TEXT STYLES ====================
  // For page titles and important content

  /// Headline Large - 32px / 40px line height
  /// Use for: Screen titles, card headers
  static const TextStyle headlineLarge = TextStyle(
    fontFamily: fontFamily,
    fontSize: 32.0,
    height: 1.25,
    letterSpacing: 0.0,
    fontWeight: FontWeight.w400,
  );

  /// Headline Medium - 28px / 36px line height
  /// Use for: Section headers
  static const TextStyle headlineMedium = TextStyle(
    fontFamily: fontFamily,
    fontSize: 28.0,
    height: 1.29,
    letterSpacing: 0.0,
    fontWeight: FontWeight.w400,
  );

  /// Headline Small - 24px / 32px line height
  /// Use for: Subsection headers
  static const TextStyle headlineSmall = TextStyle(
    fontFamily: fontFamily,
    fontSize: 24.0,
    height: 1.33,
    letterSpacing: 0.0,
    fontWeight: FontWeight.w400,
  );

  // ==================== TITLE TEXT STYLES ====================
  // For list items, dialogs, and cards

  /// Title Large - 22px / 28px line height
  /// Use for: Dialog titles, prominent list items
  static const TextStyle titleLarge = TextStyle(
    fontFamily: fontFamily,
    fontSize: 22.0,
    height: 1.27,
    letterSpacing: 0.0,
    fontWeight: FontWeight.w400,
  );

  /// Title Medium - 16px / 24px line height
  /// Use for: Card titles, list items
  static const TextStyle titleMedium = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16.0,
    height: 1.5,
    letterSpacing: 0.15,
    fontWeight: FontWeight.w500,
  );

  /// Title Small - 14px / 20px line height
  /// Use for: Smaller card titles, dense lists
  static const TextStyle titleSmall = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14.0,
    height: 1.43,
    letterSpacing: 0.1,
    fontWeight: FontWeight.w500,
  );

  // ==================== BODY TEXT STYLES ====================
  // For main content and paragraphs

  /// Body Large - 16px / 24px line height
  /// Use for: Primary content, long-form text
  static const TextStyle bodyLarge = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16.0,
    height: 1.5,
    letterSpacing: 0.5,
    fontWeight: FontWeight.w400,
  );

  /// Body Medium - 14px / 20px line height
  /// Use for: Secondary content, descriptions
  static const TextStyle bodyMedium = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14.0,
    height: 1.43,
    letterSpacing: 0.25,
    fontWeight: FontWeight.w400,
  );

  /// Body Small - 12px / 16px line height
  /// Use for: Supporting text, captions
  static const TextStyle bodySmall = TextStyle(
    fontFamily: fontFamily,
    fontSize: 12.0,
    height: 1.33,
    letterSpacing: 0.4,
    fontWeight: FontWeight.w400,
  );

  // ==================== LABEL TEXT STYLES ====================
  // For buttons, chips, and labels

  /// Label Large - 14px / 20px line height
  /// Use for: Buttons, prominent labels
  static const TextStyle labelLarge = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14.0,
    height: 1.43,
    letterSpacing: 0.1,
    fontWeight: FontWeight.w500,
  );

  /// Label Medium - 12px / 16px line height
  /// Use for: Chips, small buttons
  static const TextStyle labelMedium = TextStyle(
    fontFamily: fontFamily,
    fontSize: 12.0,
    height: 1.33,
    letterSpacing: 0.5,
    fontWeight: FontWeight.w500,
  );

  /// Label Small - 11px / 16px line height
  /// Use for: Overlines, metadata
  static const TextStyle labelSmall = TextStyle(
    fontFamily: fontFamily,
    fontSize: 11.0,
    height: 1.45,
    letterSpacing: 0.5,
    fontWeight: FontWeight.w500,
  );

  // ==================== CUSTOM VARIANTS ====================

  /// Bold variant of body text
  static const TextStyle bodyBold = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16.0,
    height: 1.5,
    letterSpacing: 0.5,
    fontWeight: FontWeight.w700,
  );

  /// Italic variant of body text
  static const TextStyle bodyItalic = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16.0,
    height: 1.5,
    letterSpacing: 0.5,
    fontWeight: FontWeight.w400,
    fontStyle: FontStyle.italic,
  );

  /// Monospace for code or technical content
  static const TextStyle mono = TextStyle(
    fontFamily: 'monospace',
    fontSize: 14.0,
    height: 1.5,
    letterSpacing: 0.0,
    fontWeight: FontWeight.w400,
  );

  // ==================== TEXT THEME BUILDER ====================

  /// Build Material 3 TextTheme from our tokens
  static TextTheme buildTextTheme(Color textColor) {
    return TextTheme(
      displayLarge: displayLarge.copyWith(color: textColor),
      displayMedium: displayMedium.copyWith(color: textColor),
      displaySmall: displaySmall.copyWith(color: textColor),
      headlineLarge: headlineLarge.copyWith(color: textColor),
      headlineMedium: headlineMedium.copyWith(color: textColor),
      headlineSmall: headlineSmall.copyWith(color: textColor),
      titleLarge: titleLarge.copyWith(color: textColor),
      titleMedium: titleMedium.copyWith(color: textColor),
      titleSmall: titleSmall.copyWith(color: textColor),
      bodyLarge: bodyLarge.copyWith(color: textColor),
      bodyMedium: bodyMedium.copyWith(color: textColor),
      bodySmall: bodySmall.copyWith(color: textColor),
      labelLarge: labelLarge.copyWith(color: textColor),
      labelMedium: labelMedium.copyWith(color: textColor),
      labelSmall: labelSmall.copyWith(color: textColor),
    );
  }

  // ==================== HELPER METHODS ====================

  /// Apply color to any text style
  static TextStyle withColor(TextStyle style, Color color) {
    return style.copyWith(color: color);
  }

  /// Apply weight to any text style
  static TextStyle withWeight(TextStyle style, FontWeight weight) {
    return style.copyWith(fontWeight: weight);
  }

  /// Apply size to any text style
  static TextStyle withSize(TextStyle style, double size) {
    return style.copyWith(fontSize: size);
  }
}
