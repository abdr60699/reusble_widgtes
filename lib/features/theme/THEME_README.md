# 🎨 Complete Reusable Theme System for Flutter

A production-ready, plug-and-play theme system based on Material 3 design principles. Copy this `theme/` folder into any Flutter project and start building beautiful, consistent UIs immediately.

## ✨ Features

- ✅ **Material 3 Design System** - Modern, beautiful design tokens
- ✅ **Light & Dark Themes** - Full support with smooth switching
- ✅ **System Theme** - Automatically follows device settings
- ✅ **Theme Persistence** - Remembers user preference across app restarts
- ✅ **Instant Switching** - No lag, immediate UI updates
- ✅ **Design Tokens** - Colors, typography, spacing, radii, elevations
- ✅ **State Management** - Built with Riverpod
- ✅ **Pre-built Widgets** - Theme toggle button, mode selector
- ✅ **Type-Safe** - Full Dart null safety
- ✅ **Production-Ready** - Used in real apps

---

## 📦 Installation

### 1. Copy Theme Folder

Copy the entire `theme/` folder into your project's `lib/` directory:

```
lib/
  theme/
    theme.dart
    app_theme.dart
    theme_colors.dart
    theme_text.dart
    theme_spacing.dart
    theme_radii.dart
    theme_icons.dart
    theme_controller.dart
    theme_provider.dart
```

### 2. Add Dependencies

Add these to your `pubspec.yaml`:

```yaml
dependencies:
  flutter:
    sdk: flutter
  flutter_riverpod: ^2.4.9
  shared_preferences: ^2.2.2
```

Run:
```bash
flutter pub get
```

---

## 🚀 Quick Start (5 Minutes)

### Step 1: Wrap App with ProviderScope

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'theme/theme.dart';

void main() {
  runApp(
    ProviderScope(
      child: MyApp(),
    ),
  );
}
```

### Step 2: Apply Theme in MaterialApp

```dart
class MyApp extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);

    return MaterialApp(
      title: 'My App',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode,
      home: HomeScreen(),
    );
  }
}
```

### Step 3: Use Theme in Widgets

```dart
class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      body: Padding(
        padding: ThemeSpacing.pageInsets,
        child: Column(
          children: [
            // Use color tokens
            Container(
              padding: ThemeSpacing.allMd,
              decoration: BoxDecoration(
                color: colors.primaryContainer,
                borderRadius: ThemeRadii.cardRadius,
              ),
              child: Text(
                'Welcome!',
                style: ThemeText.headlineMedium.copyWith(
                  color: colors.onPrimaryContainer,
                ),
              ),
            ),

            // Use spacing tokens
            ThemeSpacing.gapLg,

            // Use themed buttons
            FilledButton(
              onPressed: () {},
              child: Text('Get Started'),
            ),
          ],
        ),
      ),
    );
  }
}
```

---

## 📖 Complete Usage Guide

### 🎨 Using Colors

```dart
// Access via theme
final colors = Theme.of(context).colorScheme;

Container(
  color: colors.primary,
  child: Text(
    'Primary Text',
    style: TextStyle(color: colors.onPrimary),
  ),
)

// Available colors:
colors.primary              // Main brand color
colors.onPrimary            // Text/icons on primary
colors.primaryContainer     // Lighter primary
colors.onPrimaryContainer   // Text on primary container
colors.secondary            // Secondary brand color
colors.surface              // Card/sheet background
colors.background           // Screen background
colors.error                // Error states
// ... and many more!

// Semantic colors (from ThemeColors)
Container(color: ThemeColors.success)    // Green for success
Container(color: ThemeColors.warning)    // Orange for warnings
Container(color: ThemeColors.info)       // Blue for info
```

### ✍️ Using Typography

```dart
// Display styles (large, expressive)
Text('Hero Title', style: ThemeText.displayLarge)   // 57px
Text('Big Header', style: ThemeText.displayMedium)  // 45px
Text('Subheader', style: ThemeText.displaySmall)    // 36px

// Headline styles
Text('Page Title', style: ThemeText.headlineLarge)    // 32px
Text('Section', style: ThemeText.headlineMedium)      // 28px
Text('Subsection', style: ThemeText.headlineSmall)    // 24px

// Title styles (for cards, dialogs)
Text('Card Title', style: ThemeText.titleLarge)    // 22px
Text('List Item', style: ThemeText.titleMedium)    // 16px, medium weight
Text('Small Title', style: ThemeText.titleSmall)   // 14px

// Body text
Text('Long paragraph...', style: ThemeText.bodyLarge)   // 16px
Text('Description', style: ThemeText.bodyMedium)        // 14px
Text('Caption', style: ThemeText.bodySmall)             // 12px

// Labels (for buttons, chips)
Text('BUTTON', style: ThemeText.labelLarge)    // 14px, medium weight
Text('Chip', style: ThemeText.labelMedium)     // 12px
Text('Badge', style: ThemeText.labelSmall)     // 11px

// Apply colors to text
Text(
  'Colored Text',
  style: ThemeText.bodyLarge.copyWith(
    color: Theme.of(context).colorScheme.primary,
  ),
)
```

### 📏 Using Spacing

```dart
// Padding values
Padding(
  padding: ThemeSpacing.allMd,  // 16px all sides
  child: Text('Content'),
)

// Available sizes
ThemeSpacing.xxs   // 4px
ThemeSpacing.xs    // 8px
ThemeSpacing.sm    // 12px
ThemeSpacing.md    // 16px (base unit)
ThemeSpacing.lg    // 24px
ThemeSpacing.xl    // 32px
ThemeSpacing.xxl   // 48px
ThemeSpacing.xxxl  // 64px

// EdgeInsets shortcuts
Container(
  padding: ThemeSpacing.allMd,         // 16px all
  margin: ThemeSpacing.horizontalLg,   // 24px horizontal
)

Container(
  padding: ThemeSpacing.verticalXs,    // 8px vertical
  margin: ThemeSpacing.pageInsets,     // Page-level padding
)

// Spacing between widgets (vertical)
Column(
  children: [
    Text('Item 1'),
    ThemeSpacing.gapMd,    // 16px gap
    Text('Item 2'),
    ThemeSpacing.gapLg,    // 24px gap
    Text('Item 3'),
  ],
)

// Spacing between widgets (horizontal)
Row(
  children: [
    Icon(Icons.star),
    ThemeSpacing.hGapSm,   // 12px gap
    Text('Rating'),
  ],
)

// Custom spacing
SizedBox(height: ThemeSpacing.xl * 2)  // 64px
```

### 🔲 Using Border Radius

```dart
// Container with rounded corners
Container(
  decoration: BoxDecoration(
    color: Colors.blue,
    borderRadius: ThemeRadii.radiusMd,  // 12px
  ),
)

// Available radii
ThemeRadii.radiusNone   // 0px (sharp corners)
ThemeRadii.radiusXs     // 4px
ThemeRadii.radiusSm     // 8px
ThemeRadii.radiusMd     // 12px (Material 3 standard)
ThemeRadii.radiusLg     // 16px
ThemeRadii.radiusXl     // 20px
ThemeRadii.radiusXxl    // 28px
ThemeRadii.radiusFull   // Pill shape

// Semantic radii
Container(
  decoration: BoxDecoration(
    borderRadius: ThemeRadii.buttonRadius,  // For buttons
  ),
)

Container(
  decoration: BoxDecoration(
    borderRadius: ThemeRadii.cardRadius,    // For cards
  ),
)

// Partial radius (top only)
Container(
  decoration: BoxDecoration(
    borderRadius: ThemeRadii.topLg,  // Rounded top, flat bottom
  ),
)

// Bottom sheet radius
Container(
  decoration: BoxDecoration(
    borderRadius: ThemeRadii.bottomSheetRadius,
  ),
)

// Custom radius
Container(
  decoration: BoxDecoration(
    borderRadius: ThemeRadii.only(
      topLeft: 16,
      topRight: 16,
      bottomLeft: 8,
      bottomRight: 8,
    ),
  ),
)
```

### 🎯 Using Icon Sizes

```dart
// Icon with size
Icon(
  Icons.home,
  size: ThemeIcons.md,  // 24px (standard)
)

// Available sizes
ThemeIcons.xs     // 12px
ThemeIcons.sm     // 16px
ThemeIcons.md     // 24px (Material standard)
ThemeIcons.lg     // 32px
ThemeIcons.xl     // 48px
ThemeIcons.xxl    // 64px
ThemeIcons.xxxl   // 96px

// Semantic sizes
Icon(Icons.menu, size: ThemeIcons.appBarIcon)    // App bar
Icon(Icons.add, size: ThemeIcons.fabIcon)        // FAB
Icon(Icons.star, size: ThemeIcons.listIcon)      // List items
```

---

## 🎛️ Theme Switching

### Method 1: Using ThemeToggleButton (Easiest)

```dart
AppBar(
  actions: [
    ThemeToggleButton(),  // Icon button
  ],
)

// Or with label
ThemeToggleButton(showLabel: true)  // Icon + text button
```

### Method 2: Using ThemeModeSelector (Best UX)

```dart
// Settings screen
class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Settings')),
      body: Column(
        children: [
          ListTile(
            title: Text('Theme Mode'),
            subtitle: ThemeModeSelector(),  // Segmented button
          ),
        ],
      ),
    );
  }
}
```

### Method 3: Manual Control (Most Flexible)

```dart
class ThemeExample extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = ref.watch(isDarkThemeProvider);

    return Column(
      children: [
        // Toggle button
        Switch(
          value: isDark,
          onChanged: (_) => ref.read(themeControllerProvider).toggleTheme(),
        ),

        // Individual buttons
        ElevatedButton(
          onPressed: () => ref.read(themeControllerProvider).setLightMode(),
          child: Text('Light'),
        ),

        ElevatedButton(
          onPressed: () => ref.read(themeControllerProvider).setDarkMode(),
          child: Text('Dark'),
        ),

        ElevatedButton(
          onPressed: () => ref.read(themeControllerProvider).setSystemMode(),
          child: Text('System'),
        ),
      ],
    );
  }
}
```

### Method 4: Using Extension (Clean Syntax)

```dart
class MyWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Using extension methods
    final isDark = ref.isDarkTheme;
    final currentMode = ref.themeMode;

    return ElevatedButton(
      onPressed: () => ref.themeActions.toggleTheme(),
      child: Text(isDark ? 'Dark Mode' : 'Light Mode'),
    );
  }
}
```

---

## 🛠️ Advanced Usage

### Custom Theme-Aware Widgets

```dart
class MyCard extends ConsumerWidget {
  final String title;

  const MyCard({required this.title});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = ref.watch(isDarkThemeProvider);
    final colors = Theme.of(context).colorScheme;

    return Container(
      padding: ThemeSpacing.cardInsets,
      decoration: BoxDecoration(
        color: isDark ? colors.surfaceVariant : colors.surface,
        borderRadius: ThemeRadii.cardRadius,
        boxShadow: ThemeIcons.shadowForElevation(ThemeIcons.cardElevation),
      ),
      child: Text(
        title,
        style: ThemeText.titleMedium.copyWith(color: colors.onSurface),
      ),
    );
  }
}
```

### ThemeBuilder Widget

```dart
ThemeBuilder(
  builder: (context, theme, isDark) {
    return Container(
      color: isDark ? Colors.black : Colors.white,
      child: Text(
        'Dynamic content',
        style: theme.textTheme.bodyLarge,
      ),
    );
  },
)
```

### Checking Theme State

```dart
class StatusWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(themeControllerProvider);

    // Check current mode
    if (controller.isLight) {
      return Text('Light mode active');
    } else if (controller.isDark) {
      return Text('Dark mode active');
    } else {
      return Text('Following system (${controller.themeModeDisplayName})');
    }
  }
}
```

---

## 🎨 Customization

### Change Colors

Edit `theme_colors.dart`:

```dart
static const ColorScheme lightColorScheme = ColorScheme(
  brightness: Brightness.light,
  primary: Color(0xFFYOUR_COLOR),  // Change brand color
  // ... other colors
);
```

### Change Typography

Edit `theme_text.dart`:

```dart
static const String fontFamily = 'YourCustomFont';
static const TextStyle bodyLarge = TextStyle(
  fontFamily: fontFamily,
  fontSize: 18.0,  // Adjust size
  // ... other properties
);
```

### Change Spacing Scale

Edit `theme_spacing.dart`:

```dart
static const double md = 20.0;  // Change base spacing from 16 to 20
```

### Change Border Radius

Edit `theme_radii.dart`:

```dart
static const double md = 16.0;  // More rounded corners
```

---

## 📁 File Structure

```
lib/theme/
├── theme.dart                 # Main export (use this in imports)
├── app_theme.dart             # Complete ThemeData configuration
├── theme_colors.dart          # Color tokens (Material 3)
├── theme_text.dart            # Typography tokens
├── theme_spacing.dart         # Spacing tokens (8px grid)
├── theme_radii.dart           # Border radius tokens
├── theme_icons.dart           # Icon sizes + elevations
├── theme_controller.dart      # Theme state management
└── theme_provider.dart        # Riverpod providers
```

---

## 🔧 Troubleshooting

### Theme not persisting

Make sure `shared_preferences` is added to `pubspec.yaml` and controller is initialized:

```dart
final controller = ref.read(themeControllerProvider);
await controller.initialize();  // Called automatically
```

### Theme not switching

Ensure your MaterialApp watches the theme provider:

```dart
final themeMode = ref.watch(themeModeProvider);

MaterialApp(
  themeMode: themeMode,  // Must watch this
  // ...
)
```

### Colors not showing correctly

Make sure you're using Material 3:

```dart
ThemeData(
  useMaterial3: true,  // Required
  // ...
)
```

---

## ✅ Best Practices

1. **Always use design tokens** instead of hardcoded values
2. **Use semantic color names** (primary, surface) instead of generic names (blue, gray)
3. **Leverage spacing constants** for consistent UI spacing
4. **Test both light and dark themes** during development
5. **Use theme-aware widgets** that adapt to theme changes
6. **Provide theme toggle** in settings for user preference

---

## 📝 Examples

See `main.dart` for complete working examples.

---

## 📄 License

MIT License - Free to use in any project

---

## 🎉 You're Done!

Your theme system is ready to use. Import it in any file:

```dart
import 'package:your_app/theme/theme.dart';
```

Start building beautiful, consistent UIs with Material 3!
