import 'package:flutter/material.dart';

/// Design tokens for border radius following Material 3 guidelines
/// Provides consistent border radius values for components
class ThemeRadii {
  // Private constructor to prevent instantiation
  ThemeRadii._();

  // ==================== BASE RADIUS VALUES ====================

  /// No radius - 0px
  /// Use for: Sharp corners, strict layouts
  static const double none = 0.0;

  /// Extra small radius - 4px
  /// Use for: Small chips, badges
  static const double xs = 4.0;

  /// Small radius - 8px
  /// Use for: Buttons, cards
  static const double sm = 8.0;

  /// Medium radius - 12px (Material 3 standard)
  /// Use for: Cards, dialogs, bottom sheets
  static const double md = 12.0;

  /// Large radius - 16px
  /// Use for: Large cards, containers
  static const double lg = 16.0;

  /// Extra large radius - 20px
  /// Use for: Prominent cards, modals
  static const double xl = 20.0;

  /// Extra extra large radius - 28px
  /// Use for: Hero sections, featured cards
  static const double xxl = 28.0;

  /// Full radius - 9999px (Pill shape)
  /// Use for: Pills, rounded buttons, avatars
  static const double full = 9999.0;

  // ==================== BORDER RADIUS SHORTCUTS ====================

  /// No border radius
  static const BorderRadius radiusNone = BorderRadius.zero;

  /// Extra small border radius (4px)
  static const BorderRadius radiusXs = BorderRadius.all(Radius.circular(xs));

  /// Small border radius (8px)
  static const BorderRadius radiusSm = BorderRadius.all(Radius.circular(sm));

  /// Medium border radius (12px)
  static const BorderRadius radiusMd = BorderRadius.all(Radius.circular(md));

  /// Large border radius (16px)
  static const BorderRadius radiusLg = BorderRadius.all(Radius.circular(lg));

  /// Extra large border radius (20px)
  static const BorderRadius radiusXl = BorderRadius.all(Radius.circular(xl));

  /// Extra extra large border radius (28px)
  static const BorderRadius radiusXxl = BorderRadius.all(Radius.circular(xxl));

  /// Full border radius (pill shape)
  static const BorderRadius radiusFull = BorderRadius.all(Radius.circular(full));

  // ==================== CIRCULAR BORDER RADIUS ====================

  /// Circular border radius variants
  static Radius circularXs = const Radius.circular(xs);
  static Radius circularSm = const Radius.circular(sm);
  static Radius circularMd = const Radius.circular(md);
  static Radius circularLg = const Radius.circular(lg);
  static Radius circularXl = const Radius.circular(xl);
  static Radius circularXxl = const Radius.circular(xxl);
  static Radius circularFull = const Radius.circular(full);

  // ==================== SEMANTIC RADII ====================

  /// Standard button border radius
  static const BorderRadius buttonRadius = radiusMd;

  /// Standard card border radius
  static const BorderRadius cardRadius = radiusMd;

  /// Standard input field border radius
  static const BorderRadius inputRadius = radiusSm;

  /// Standard dialog border radius
  static const BorderRadius dialogRadius = radiusXl;

  /// Standard bottom sheet border radius
  static const BorderRadius bottomSheetRadius = BorderRadius.only(
    topLeft: Radius.circular(xl),
    topRight: Radius.circular(xl),
  );

  /// Standard chip/badge border radius
  static const BorderRadius chipRadius = radiusSm;

  /// Standard avatar border radius (circular)
  static const BorderRadius avatarRadius = radiusFull;

  /// Standard snackbar border radius
  static const BorderRadius snackbarRadius = radiusSm;

  // ==================== TOP-ONLY RADIUS ====================

  /// Top-only border radius variants
  static BorderRadius topXs = const BorderRadius.only(
    topLeft: Radius.circular(xs),
    topRight: Radius.circular(xs),
  );

  static BorderRadius topSm = const BorderRadius.only(
    topLeft: Radius.circular(sm),
    topRight: Radius.circular(sm),
  );

  static BorderRadius topMd = const BorderRadius.only(
    topLeft: Radius.circular(md),
    topRight: Radius.circular(md),
  );

  static BorderRadius topLg = const BorderRadius.only(
    topLeft: Radius.circular(lg),
    topRight: Radius.circular(lg),
  );

  static BorderRadius topXl = const BorderRadius.only(
    topLeft: Radius.circular(xl),
    topRight: Radius.circular(xl),
  );

  // ==================== BOTTOM-ONLY RADIUS ====================

  /// Bottom-only border radius variants
  static BorderRadius bottomXs = const BorderRadius.only(
    bottomLeft: Radius.circular(xs),
    bottomRight: Radius.circular(xs),
  );

  static BorderRadius bottomSm = const BorderRadius.only(
    bottomLeft: Radius.circular(sm),
    bottomRight: Radius.circular(sm),
  );

  static BorderRadius bottomMd = const BorderRadius.only(
    bottomLeft: Radius.circular(md),
    bottomRight: Radius.circular(md),
  );

  static BorderRadius bottomLg = const BorderRadius.only(
    bottomLeft: Radius.circular(lg),
    bottomRight: Radius.circular(lg),
  );

  static BorderRadius bottomXl = const BorderRadius.only(
    bottomLeft: Radius.circular(xl),
    bottomRight: Radius.circular(xl),
  );

  // ==================== LEFT-ONLY RADIUS ====================

  /// Left-only border radius variants
  static BorderRadius leftXs = const BorderRadius.only(
    topLeft: Radius.circular(xs),
    bottomLeft: Radius.circular(xs),
  );

  static BorderRadius leftSm = const BorderRadius.only(
    topLeft: Radius.circular(sm),
    bottomLeft: Radius.circular(sm),
  );

  static BorderRadius leftMd = const BorderRadius.only(
    topLeft: Radius.circular(md),
    bottomLeft: Radius.circular(md),
  );

  static BorderRadius leftLg = const BorderRadius.only(
    topLeft: Radius.circular(lg),
    bottomLeft: Radius.circular(lg),
  );

  // ==================== RIGHT-ONLY RADIUS ====================

  /// Right-only border radius variants
  static BorderRadius rightXs = const BorderRadius.only(
    topRight: Radius.circular(xs),
    bottomRight: Radius.circular(xs),
  );

  static BorderRadius rightSm = const BorderRadius.only(
    topRight: Radius.circular(sm),
    bottomRight: Radius.circular(sm),
  );

  static BorderRadius rightMd = const BorderRadius.only(
    topRight: Radius.circular(md),
    bottomRight: Radius.circular(md),
  );

  static BorderRadius rightLg = const BorderRadius.only(
    topRight: Radius.circular(lg),
    bottomRight: Radius.circular(lg),
  );

  // ==================== HELPER METHODS ====================

  /// Custom border radius
  static BorderRadius all(double radius) {
    return BorderRadius.all(Radius.circular(radius));
  }

  /// Custom top border radius
  static BorderRadius top(double radius) {
    return BorderRadius.only(
      topLeft: Radius.circular(radius),
      topRight: Radius.circular(radius),
    );
  }

  /// Custom bottom border radius
  static BorderRadius bottom(double radius) {
    return BorderRadius.only(
      bottomLeft: Radius.circular(radius),
      bottomRight: Radius.circular(radius),
    );
  }

  /// Custom left border radius
  static BorderRadius left(double radius) {
    return BorderRadius.only(
      topLeft: Radius.circular(radius),
      bottomLeft: Radius.circular(radius),
    );
  }

  /// Custom right border radius
  static BorderRadius right(double radius) {
    return BorderRadius.only(
      topRight: Radius.circular(radius),
      bottomRight: Radius.circular(radius),
    );
  }

  /// Custom individual corner radius
  static BorderRadius only({
    double topLeft = 0,
    double topRight = 0,
    double bottomLeft = 0,
    double bottomRight = 0,
  }) {
    return BorderRadius.only(
      topLeft: Radius.circular(topLeft),
      topRight: Radius.circular(topRight),
      bottomLeft: Radius.circular(bottomLeft),
      bottomRight: Radius.circular(bottomRight),
    );
  }
}
