/// Shared Widgets - Reusable UI Components
///
/// This library exports all reusable widgets that can be used across the app.
/// Widgets are organized by category for better organization and discoverability.
///
/// Categories:
/// - **Animations**: Transitions, effects, and animated widgets
/// - **Auth**: Authentication and permission-related widgets
/// - **Basic**: Containers, badges, avatars, dividers, images
/// - **Buttons**: Icon buttons and other button variants
/// - **Cards**: Various card layouts for displaying data
/// - **Dialogs**: Modal dialogs, popups, and overlays
/// - **Ecommerce**: Shopping cart, product cards, and pricing widgets
/// - **Effects**: Visual effects like glassmorphism, gradients
/// - **Feedback**: Toasts, snackbars, error views, progress indicators
/// - **Forms**: Text fields, dropdowns, date pickers, radio groups
/// - **Layout**: Scaffolds, steppers, grids, and layout helpers
/// - **Media**: Image, video, audio, PDF, and QR code widgets
/// - **Navigation**: App bars, bottom nav, drawers, tabs, breadcrumbs
/// - **Pickers**: Date, time, color, camera, and image pickers
/// - **Responsive**: Adaptive and responsive layout widgets
/// - **Utilities**: Version checkers and other utility widgets
///
/// Usage:
/// ```dart
/// // Import all widgets
/// import 'package:reuablewidgets/sharedwidget/shared_widgets.dart';
///
/// // Or import specific categories
/// import 'package:reuablewidgets/sharedwidget/basic/basic_widgets.dart';
/// import 'package:reuablewidgets/sharedwidget/forms/forms_widgets.dart';
/// ```
library shared_widgets;

// Export all widget categories (alphabetically ordered)
export 'animations/animations_widgets.dart';
export 'auth/auth_widgets.dart';
export 'basic/basic_widgets.dart';
export 'buttons/buttons_widgets.dart';
export 'cards/cards_widgets.dart';
export 'dialogs/dialogs_widgets.dart';
export 'ecommerce/ecommerce_widgets.dart';
export 'effects/effects_widgets.dart';
export 'feedback/feedback_widgets.dart';
export 'forms/forms_widgets.dart';
export 'layout/layout_widgets.dart';
export 'media/media_widgets.dart';
export 'navigation/navigation_widgets.dart';
export 'pickers/pickers_widgets.dart';
export 'responsive/responsive_widgets.dart';
export 'utilities/utilities_widgets.dart';
