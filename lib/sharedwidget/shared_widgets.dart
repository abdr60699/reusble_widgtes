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
// Export all reusable widgets
export 'reusable_animated_switcher.dart';
export 'reusable_app_bar.dart';
export 'reusable_badge.dart';
export 'reusable_bottom_nav_bar.dart';
export 'reusable_circle_avatar.dart';
export 'reusable_container.dart';
export 'reusable_datepicker.dart';
export 'reusable_divider.dart';
export 'reusable_drawer.dart';
export 'reusable_dropdown.dart';
export 'reusable_error_view.dart';
export 'reusable_icon_button.dart';
export 'reusable_image.dart';
export 'reusable_radiogroup.dart';
export 'reusable_refresh_indicator.dart';
export 'reusable_shimmer.dart';
export 'reusable_stepper.dart';
export 'reusable_svg_icon.dart';
export 'reusable_tab_bar.dart';
export 'reusable_text_form_field.dart';
export 'reusable_toast.dart';
export 'reusabel_snackbar.dart';
