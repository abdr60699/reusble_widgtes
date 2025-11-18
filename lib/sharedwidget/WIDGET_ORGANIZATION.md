# Widget Organization Guide

This guide explains how reusable widgets are organized in this package and how to add new widgets.

## 📁 Folder Structure

```
lib/sharedwidget/
├── animations/          # Animation widgets
│   ├── animation_widgets.dart (export file)
│   ├── reusable_animated_switcher.dart
│   └── reusable_shimmer.dart
├── basic/               # Basic UI components
│   ├── basic_widgets.dart (export file)
│   ├── reusable_badge.dart
│   ├── reusable_circle_avatar.dart
│   ├── reusable_container.dart
│   ├── reusable_divider.dart
│   ├── reusable_image.dart
│   └── reusable_svg_icon.dart
├── buttons/             # Button components
│   ├── button_widgets.dart (export file)
│   └── reusable_icon_button.dart
├── feedback/            # User feedback components
│   ├── feedback_widgets.dart (export file)
│   ├── reusabel_snackbar.dart
│   ├── reusable_error_view.dart
│   ├── reusable_refresh_indicator.dart
│   └── reusable_toast.dart
├── forms/               # Form input components
│   ├── form_widgets.dart (export file)
│   ├── reusable_datepicker.dart
│   ├── reusable_dropdown.dart
│   ├── reusable_radiogroup.dart
│   └── reusable_text_form_field.dart
├── layout/              # Layout components
│   ├── layout_widgets.dart (export file)
│   ├── reusable_scaffold.dart
│   └── reusable_stepper.dart
├── navigation/          # Navigation components
│   ├── navigation_widgets.dart (export file)
│   ├── reusable_app_bar.dart
│   ├── reusable_bottom_nav_bar.dart
│   ├── reusable_drawer.dart
│   └── reusable_tab_bar.dart
├── media/               # Media components (future)
└── shared_widgets.dart  # Main export file
```

---

## 📚 Widget Categories

### 1. **animations/** - Animation Components
Widgets that provide animated transitions and effects.

**Examples:**
- `ReusableAnimatedSwitcher` - Animated content switching
- `ReusableShimmer` - Loading shimmer effect

**When to add here:**
- Custom animation widgets
- Transition effects
- Loading animations
- Micro-interactions

---

### 2. **basic/** - Basic UI Components
Fundamental UI building blocks used throughout the app.

**Examples:**
- `ReusableContainer` - Styled containers
- `ReusableBadge` - Badge labels
- `ReusableCircleAvatar` - Circular avatars
- `ReusableDivider` - Section dividers
- `ReusableImage` - Image display
- `ReusableSvgIcon` - SVG icons

**When to add here:**
- Core UI primitives
- Visual elements without complex logic
- Styling wrappers
- Simple display components

---

### 3. **buttons/** - Button Components
All button variants and interactive elements.

**Examples:**
- `ReusableIconButton` - Icon buttons

**When to add here:**
- Button widgets
- Action triggers
- Interactive icons
- FABs (Floating Action Buttons)

---

### 4. **feedback/** - User Feedback Components
Components that provide feedback to user actions.

**Examples:**
- `ReusableToast` - Toast notifications
- `ReusableSnackbar` - Snackbar messages
- `ReusableErrorView` - Error displays
- `ReusableRefreshIndicator` - Pull-to-refresh

**When to add here:**
- Notifications
- Alerts
- Status messages
- Progress indicators
- Error/success feedback

---

### 5. **forms/** - Form Input Components
Form-related widgets for user input.

**Examples:**
- `ReusableTextFormField` - Text inputs
- `ReusableDropdown` - Dropdown selectors
- `ReusableDatePicker` - Date selection
- `ReusableRadioGroup` - Radio button groups

**When to add here:**
- Input fields
- Selectors
- Form controls
- Validation components

---

### 6. **layout/** - Layout Components
Widgets that define page structure and layout.

**Examples:**
- `ReusableScaffold` - Page scaffold
- `ReusableStepper` - Step progression

**When to add here:**
- Page templates
- Section layouts
- Grid/list layouts
- Responsive wrappers

---

### 7. **navigation/** - Navigation Components
Widgets for app navigation and routing.

**Examples:**
- `ReusableAppBar` - App bar/toolbar
- `ReusableBottomNavBar` - Bottom navigation
- `ReusableDrawer` - Side drawer
- `ReusableTabBar` - Tab navigation

**When to add here:**
- Navigation bars
- Menu systems
- Breadcrumbs
- Page indicators

---

### 8. **media/** - Media Components (Future)
Components for handling media content.

**Future widgets:**
- Image galleries
- Video players
- Audio players
- PDF viewers
- QR scanners

---

## ✨ Adding a New Widget

### Step 1: Choose the Right Category

Decide which category your widget belongs to based on its primary purpose:

| If your widget is... | Place it in... |
|---------------------|----------------|
| A basic visual element | `basic/` |
| A button or action trigger | `buttons/` |
| For user input/forms | `forms/` |
| For navigation | `navigation/` |
| For user feedback | `feedback/` |
| An animation/transition | `animations/` |
| For page layout | `layout/` |
| For media (images/video) | `media/` |

### Step 2: Create the Widget File

1. Create your widget file in the appropriate category folder
2. Follow the naming convention: `reusable_<widget_name>.dart`
3. Use PascalCase for the class name: `Reusable<WidgetName>`

**Example:**
```dart
// File: lib/sharedwidget/buttons/reusable_button.dart
import 'package:flutter/material.dart';

class ReusableButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final Color? backgroundColor;
  final Color? textColor;

  const ReusableButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.backgroundColor,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        foregroundColor: textColor,
      ),
      child: Text(label),
    );
  }
}
```

### Step 3: Add Export to Category File

Add your new widget to the category's export file.

**Example:**
```dart
// File: lib/sharedwidget/buttons/button_widgets.dart
library button_widgets;

export 'reusable_icon_button.dart';
export 'reusable_button.dart';  // Add this line
```

### Step 4: Widget is Now Available!

Your widget is automatically available through:

```dart
// Import all widgets
import 'package:reuablewidgets/sharedwidget/shared_widgets.dart';

// Or import just the category
import 'package:reuablewidgets/sharedwidget/buttons/button_widgets.dart';

// Or import specific widget
import 'package:reuablewidgets/sharedwidget/buttons/reusable_button.dart';
```

---

## 🎯 Best Practices

### 1. **Naming Conventions**

- **Files:** `reusable_<widget_name>.dart` (snake_case)
- **Classes:** `Reusable<WidgetName>` (PascalCase)
- **Prefix:** Always use `Reusable` prefix

### 2. **Documentation**

Add comprehensive documentation to your widget:

```dart
/// A customizable button widget with consistent styling.
///
/// This button provides a unified look across the app with
/// customizable colors and actions.
///
/// Example:
/// ```dart
/// ReusableButton(
///   label: 'Click Me',
///   onPressed: () => print('Clicked!'),
///   backgroundColor: Colors.blue,
/// )
/// ```
class ReusableButton extends StatelessWidget {
  /// The text displayed on the button
  final String label;

  /// Callback when button is pressed
  final VoidCallback onPressed;

  // ... rest of code
}
```

### 3. **Customization**

Make widgets customizable but provide sensible defaults:

```dart
class ReusableCard extends StatelessWidget {
  final Widget child;
  final Color? backgroundColor;
  final double? elevation;
  final EdgeInsets? padding;

  const ReusableCard({
    super.key,
    required this.child,
    this.backgroundColor,      // Optional, uses theme default
    this.elevation = 2.0,       // Default value
    this.padding = const EdgeInsets.all(16),  // Default padding
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: backgroundColor ?? Theme.of(context).cardColor,
      elevation: elevation,
      child: Padding(
        padding: padding!,
        child: child,
      ),
    );
  }
}
```

### 4. **Theme Integration**

Use theme colors and text styles:

```dart
@override
Widget build(BuildContext context) {
  final theme = Theme.of(context);

  return Container(
    color: backgroundColor ?? theme.primaryColor,
    child: Text(
      label,
      style: textStyle ?? theme.textTheme.labelLarge,
    ),
  );
}
```

### 5. **Null Safety**

Ensure all widgets are null-safe:

```dart
class ReusableWidget extends StatelessWidget {
  final String? optionalText;
  final String requiredText;

  const ReusableWidget({
    super.key,
    this.optionalText,        // Nullable
    required this.requiredText,  // Required
  });
}
```

---

## 🔄 Migrating Existing Code

If you have existing code using the old import paths, update them:

**Old:**
```dart
import 'package:reuablewidgets/sharedwidget/reusable_button.dart';
import 'package:reuablewidgets/sharedwidget/reusable_text_form_field.dart';
```

**New (Option 1 - Import all):**
```dart
import 'package:reuablewidgets/sharedwidget/shared_widgets.dart';
```

**New (Option 2 - Import by category):**
```dart
import 'package:reuablewidgets/sharedwidget/buttons/button_widgets.dart';
import 'package:reuablewidgets/sharedwidget/forms/form_widgets.dart';
```

**New (Option 3 - Import specific widget):**
```dart
import 'package:reuablewidgets/sharedwidget/buttons/reusable_button.dart';
import 'package:reuablewidgets/sharedwidget/forms/reusable_text_form_field.dart';
```

---

## 📝 Widget Checklist

Before submitting a new widget, ensure:

- [ ] Widget is in the correct category folder
- [ ] File name follows `reusable_<name>.dart` convention
- [ ] Class name follows `Reusable<Name>` convention
- [ ] Widget is exported in category export file
- [ ] Documentation comments are added
- [ ] Parameters are well-documented
- [ ] Example usage is provided in comments
- [ ] Theme integration is used where appropriate
- [ ] Widget is null-safe
- [ ] Default values are sensible
- [ ] Widget is tested in example app

---

## 🚀 Quick Reference

### Create New Widget (Complete Steps)

1. **Create file** in appropriate category:
   ```bash
   touch lib/sharedwidget/buttons/reusable_my_button.dart
   ```

2. **Write widget code** with documentation

3. **Add export** to category file:
   ```dart
   // lib/sharedwidget/buttons/button_widgets.dart
   export 'reusable_my_button.dart';
   ```

4. **Test** in example app

5. **Commit** changes

### Import Patterns

```dart
// All widgets
import 'package:reuablewidgets/sharedwidget/shared_widgets.dart';

// Category
import 'package:reuablewidgets/sharedwidget/buttons/button_widgets.dart';

// Specific widget
import 'package:reuablewidgets/sharedwidget/buttons/reusable_button.dart';
```

---

## 📧 Questions?

If you're unsure where a widget should go:

1. Consider its primary purpose
2. Look at similar existing widgets
3. Choose the closest category
4. Add to the category export file
5. It can always be moved later if needed

Happy coding! 🎉
