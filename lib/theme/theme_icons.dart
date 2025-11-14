import 'package:flutter/material.dart';

/// Design tokens for icon sizes and elevations
/// Provides consistent icon sizing and shadow elevations across the app
class ThemeIcons {
  // Private constructor to prevent instantiation
  ThemeIcons._();

  // ==================== ICON SIZE VALUES ====================

  /// Extra small icon - 12px
  /// Use for: Inline icons, small badges
  static const double xs = 12.0;

  /// Small icon - 16px
  /// Use for: List item icons, small buttons
  static const double sm = 16.0;

  /// Medium icon - 24px (Material standard)
  /// Use for: Standard buttons, app bar icons
  static const double md = 24.0;

  /// Large icon - 32px
  /// Use for: Prominent buttons, featured icons
  static const double lg = 32.0;

  /// Extra large icon - 48px
  /// Use for: Large action buttons, empty states
  static const double xl = 48.0;

  /// Extra extra large icon - 64px
  /// Use for: Hero icons, splash screens
  static const double xxl = 64.0;

  /// Extra extra extra large icon - 96px
  /// Use for: Large empty states, onboarding
  static const double xxxl = 96.0;

  // ==================== SEMANTIC ICON SIZES ====================

  /// Standard app bar icon size
  static const double appBarIcon = md;

  /// Standard navigation bar icon size
  static const double navBarIcon = md;

  /// Standard floating action button icon size
  static const double fabIcon = md;

  /// Standard button icon size
  static const double buttonIcon = sm;

  /// Standard list tile leading icon size
  static const double listIcon = md;

  /// Standard avatar icon size
  static const double avatarIcon = xl;

  /// Standard badge icon size
  static const double badgeIcon = xs;

  // ==================== ELEVATION VALUES ====================
  // Material Design elevation levels for consistent shadows

  /// No elevation - 0dp
  static const double elevationNone = 0.0;

  /// Extra small elevation - 1dp
  /// Use for: Cards at rest
  static const double elevationXs = 1.0;

  /// Small elevation - 2dp
  /// Use for: Raised buttons at rest
  static const double elevationSm = 2.0;

  /// Medium elevation - 4dp
  /// Use for: App bar, raised buttons on hover
  static const double elevationMd = 4.0;

  /// Large elevation - 6dp
  /// Use for: FAB at rest, snackbar
  static const double elevationLg = 6.0;

  /// Extra large elevation - 8dp
  /// Use for: Bottom navigation bar, dialogs, drawers
  static const double elevationXl = 8.0;

  /// Extra extra large elevation - 12dp
  /// Use for: FAB on hover
  static const double elevationXxl = 12.0;

  /// Maximum elevation - 16dp
  /// Use for: Modal bottom sheets
  static const double elevationMax = 16.0;

  // ==================== SEMANTIC ELEVATIONS ====================

  /// Standard card elevation
  static const double cardElevation = elevationXs;

  /// Standard button elevation
  static const double buttonElevation = elevationSm;

  /// Standard app bar elevation
  static const double appBarElevation = elevationMd;

  /// Standard dialog elevation
  static const double dialogElevation = elevationXl;

  /// Standard bottom sheet elevation
  static const double bottomSheetElevation = elevationMax;

  /// Standard FAB elevation
  static const double fabElevation = elevationLg;

  /// Standard drawer elevation
  static const double drawerElevation = elevationMax;

  // ==================== ICON DATA WITH SIZE ====================

  /// Create IconThemeData with size
  static IconThemeData iconTheme(double size, Color color) {
    return IconThemeData(
      size: size,
      color: color,
    );
  }

  // ==================== SHADOW HELPERS ====================

  /// Get box shadow for elevation
  static List<BoxShadow> shadowForElevation(double elevation) {
    if (elevation == 0) return [];

    return [
      BoxShadow(
        color: Colors.black.withOpacity(0.14),
        offset: Offset(0, elevation / 2),
        blurRadius: elevation,
        spreadRadius: 0,
      ),
      BoxShadow(
        color: Colors.black.withOpacity(0.12),
        offset: Offset(0, elevation / 4),
        blurRadius: elevation * 1.5,
        spreadRadius: 0,
      ),
      BoxShadow(
        color: Colors.black.withOpacity(0.20),
        offset: Offset(0, elevation / 8),
        blurRadius: elevation / 2,
        spreadRadius: 0,
      ),
    ];
  }

  /// Get Material elevation overlay color for dark theme
  /// Material Design applies white overlay on dark surfaces based on elevation
  static Color elevationOverlay(Color baseColor, double elevation) {
    if (elevation == 0) return baseColor;

    // Calculate overlay opacity based on elevation
    // Material Design uses these specific values
    final double opacity = (4.5 * math.log(elevation + 1) + 2) / 100;

    return Color.alphaBlend(
      Colors.white.withOpacity(opacity.clamp(0.0, 1.0)),
      baseColor,
    );
  }
}

/// Import math for logarithm calculation
import 'dart:math' as math;
