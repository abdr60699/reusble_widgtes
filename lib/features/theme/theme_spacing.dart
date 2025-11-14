import 'package:flutter/material.dart';

/// Design tokens for spacing following 8px grid system
/// Provides consistent spacing values across the app
class ThemeSpacing {
  // Private constructor to prevent instantiation
  ThemeSpacing._();

  // ==================== BASE SPACING VALUES ====================
  // Following 8px grid system for consistency

  /// Extra extra small spacing - 4px
  /// Use for: Very tight spacing, icon padding
  static const double xxs = 4.0;

  /// Extra small spacing - 8px
  /// Use for: Icon spacing, chip padding
  static const double xs = 8.0;

  /// Small spacing - 12px
  /// Use for: Button padding, list item spacing
  static const double sm = 12.0;

  /// Medium spacing - 16px (Base unit)
  /// Use for: Standard padding, card spacing, form fields
  static const double md = 16.0;

  /// Large spacing - 24px
  /// Use for: Section spacing, card margins
  static const double lg = 24.0;

  /// Extra large spacing - 32px
  /// Use for: Large section gaps, screen margins
  static const double xl = 32.0;

  /// Extra extra large spacing - 48px
  /// Use for: Major section dividers
  static const double xxl = 48.0;

  /// Extra extra extra large spacing - 64px
  /// Use for: Hero sections, empty states
  static const double xxxl = 64.0;

  // ==================== SEMANTIC SPACING ====================

  /// Standard page padding (horizontal)
  static const double pagePadding = md;

  /// Standard page padding (vertical)
  static const double pagePaddingVertical = lg;

  /// Standard card padding
  static const double cardPadding = md;

  /// Standard list item padding
  static const double listPadding = md;

  /// Standard dialog padding
  static const double dialogPadding = lg;

  /// Standard bottom sheet padding
  static const double bottomSheetPadding = lg;

  /// Standard app bar padding
  static const double appBarPadding = md;

  /// Standard button padding (horizontal)
  static const double buttonPaddingHorizontal = lg;

  /// Standard button padding (vertical)
  static const double buttonPaddingVertical = sm;

  /// Standard form field spacing
  static const double formFieldSpacing = md;

  /// Standard section spacing
  static const double sectionSpacing = xl;

  // ==================== EDGE INSETS SHORTCUTS ====================

  /// No padding
  static const EdgeInsets zero = EdgeInsets.zero;

  /// All sides XXS padding (4px)
  static const EdgeInsets allXxs = EdgeInsets.all(xxs);

  /// All sides XS padding (8px)
  static const EdgeInsets allXs = EdgeInsets.all(xs);

  /// All sides SM padding (12px)
  static const EdgeInsets allSm = EdgeInsets.all(sm);

  /// All sides MD padding (16px)
  static const EdgeInsets allMd = EdgeInsets.all(md);

  /// All sides LG padding (24px)
  static const EdgeInsets allLg = EdgeInsets.all(lg);

  /// All sides XL padding (32px)
  static const EdgeInsets allXl = EdgeInsets.all(xl);

  /// All sides XXL padding (48px)
  static const EdgeInsets allXxl = EdgeInsets.all(xxl);

  // Horizontal padding
  static const EdgeInsets horizontalXs = EdgeInsets.symmetric(horizontal: xs);
  static const EdgeInsets horizontalSm = EdgeInsets.symmetric(horizontal: sm);
  static const EdgeInsets horizontalMd = EdgeInsets.symmetric(horizontal: md);
  static const EdgeInsets horizontalLg = EdgeInsets.symmetric(horizontal: lg);
  static const EdgeInsets horizontalXl = EdgeInsets.symmetric(horizontal: xl);

  // Vertical padding
  static const EdgeInsets verticalXs = EdgeInsets.symmetric(vertical: xs);
  static const EdgeInsets verticalSm = EdgeInsets.symmetric(vertical: sm);
  static const EdgeInsets verticalMd = EdgeInsets.symmetric(vertical: md);
  static const EdgeInsets verticalLg = EdgeInsets.symmetric(vertical: lg);
  static const EdgeInsets verticalXl = EdgeInsets.symmetric(vertical: xl);

  // Page-level padding
  static const EdgeInsets pageInsets = EdgeInsets.symmetric(
    horizontal: pagePadding,
    vertical: pagePaddingVertical,
  );

  static const EdgeInsets pageInsetsHorizontal = EdgeInsets.symmetric(
    horizontal: pagePadding,
  );

  static const EdgeInsets pageInsetsVertical = EdgeInsets.symmetric(
    vertical: pagePaddingVertical,
  );

  // Card padding
  static const EdgeInsets cardInsets = EdgeInsets.all(cardPadding);

  // List item padding
  static const EdgeInsets listItemInsets = EdgeInsets.symmetric(
    horizontal: listPadding,
    vertical: xs,
  );

  // Dialog padding
  static const EdgeInsets dialogInsets = EdgeInsets.all(dialogPadding);

  // Button padding
  static const EdgeInsets buttonInsets = EdgeInsets.symmetric(
    horizontal: buttonPaddingHorizontal,
    vertical: buttonPaddingVertical,
  );

  // ==================== SIZE BOX SHORTCUTS ====================

  /// Vertical spacing shortcuts using SizedBox
  static const Widget gapXxs = SizedBox(height: xxs);
  static const Widget gapXs = SizedBox(height: xs);
  static const Widget gapSm = SizedBox(height: sm);
  static const Widget gapMd = SizedBox(height: md);
  static const Widget gapLg = SizedBox(height: lg);
  static const Widget gapXl = SizedBox(height: xl);
  static const Widget gapXxl = SizedBox(height: xxl);
  static const Widget gapXxxl = SizedBox(height: xxxl);

  /// Horizontal spacing shortcuts using SizedBox
  static const Widget hGapXxs = SizedBox(width: xxs);
  static const Widget hGapXs = SizedBox(width: xs);
  static const Widget hGapSm = SizedBox(width: sm);
  static const Widget hGapMd = SizedBox(width: md);
  static const Widget hGapLg = SizedBox(width: lg);
  static const Widget hGapXl = SizedBox(width: xl);
  static const Widget hGapXxl = SizedBox(width: xxl);
  static const Widget hGapXxxl = SizedBox(width: xxxl);

  // ==================== HELPER METHODS ====================

  /// Custom vertical gap
  static Widget verticalGap(double height) => SizedBox(height: height);

  /// Custom horizontal gap
  static Widget horizontalGap(double width) => SizedBox(width: width);

  /// Custom all-sides padding
  static EdgeInsets all(double value) => EdgeInsets.all(value);

  /// Custom symmetric padding
  static EdgeInsets symmetric({double? horizontal, double? vertical}) {
    return EdgeInsets.symmetric(
      horizontal: horizontal ?? 0,
      vertical: vertical ?? 0,
    );
  }

  /// Custom directional padding
  static EdgeInsets only({
    double left = 0,
    double top = 0,
    double right = 0,
    double bottom = 0,
  }) {
    return EdgeInsets.only(
      left: left,
      top: top,
      right: right,
      bottom: bottom,
    );
  }

  /// Responsive padding based on screen width
  static EdgeInsets responsive(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width > 1200) {
      return allXxl; // Desktop
    } else if (width > 800) {
      return allXl; // Tablet
    } else {
      return allMd; // Mobile
    }
  }
}
