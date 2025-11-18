/// Shared Widgets - Reusable UI Components
///
/// This library exports all reusable widgets that can be used across the app.
/// Widgets are organized by category for better organization and discoverability.
///
/// Categories:
/// - **Basic**: Containers, badges, avatars, dividers, images
/// - **Buttons**: Icon buttons and other button variants
/// - **Forms**: Text fields, dropdowns, date pickers, radio groups
/// - **Navigation**: App bars, bottom nav, drawers, tabs
/// - **Feedback**: Toasts, snackbars, error views, refresh indicators
/// - **Animations**: Animated transitions and loading effects
/// - **Layout**: Scaffolds, steppers, and layout helpers
///
/// Usage:
/// ```dart
/// // Import all widgets
/// import 'package:reuablewidgets/sharedwidget/shared_widgets.dart';
///
/// // Or import specific categories
/// import 'package:reuablewidgets/sharedwidget/basic/basic_widgets.dart';
/// import 'package:reuablewidgets/sharedwidget/forms/form_widgets.dart';
/// ```
library shared_widgets;

// Export all widget categories
export 'animations/animation_widgets.dart';
export 'basic/basic_widgets.dart';
export 'buttons/button_widgets.dart';
export 'feedback/feedback_widgets.dart';
export 'forms/form_widgets.dart';
export 'layout/layout_widgets.dart';
export 'navigation/navigation_widgets.dart';
