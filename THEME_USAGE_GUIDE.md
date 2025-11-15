# Complete Theme Usage Guide

A clear and simple guide to using the advanced theme system in your Flutter app.

## 📋 Table of Contents

1. [Quick Start](#quick-start)
2. [Switching Theme Modes](#switching-theme-modes)
3. [Using Colors](#using-colors)
4. [Using Typography](#using-typography)
5. [Using Spacing](#using-spacing)
6. [Using Border Radius](#using-border-radius)
7. [Using Icons](#using-icons)
8. [Common Use Cases](#common-use-cases)
9. [Troubleshooting](#troubleshooting)

---

## Quick Start

### Step 1: Add Dependencies

Make sure these are in your `pubspec.yaml`:

```yaml
dependencies:
  flutter_riverpod: ^2.4.9
  shared_preferences: ^2.2.2
  dynamic_color: ^1.7.0
```

Run: `flutter pub get`

### Step 2: Wrap Your App

In your `main.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'features/theme/theme.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);

    return MaterialApp(
      title: 'My App',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode,
      home: const HomePage(),
    );
  }
}
```

**That's it! Your app now has a complete theme system.**

---

## Switching Theme Modes

### Method 1: Pre-built Toggle Button

The easiest way - just add this widget anywhere:

```dart
import 'features/theme/theme.dart';

// In your widget tree
ThemeToggleButton()
```

This gives you a button that cycles through: Light → Dark → System

### Method 2: Pre-built Mode Selector

Show a list of all theme options:

```dart
ThemeModeSelector()
```

This displays Light, Dark, and System options with icons.

### Method 3: Manual Control

```dart
class MyWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.read(themeControllerProvider);

    return Column(
      children: [
        ElevatedButton(
          onPressed: () => controller.setLightMode(),
          child: const Text('Light Mode'),
        ),
        ElevatedButton(
          onPressed: () => controller.setDarkMode(),
          child: const Text('Dark Mode'),
        ),
        ElevatedButton(
          onPressed: () => controller.setSystemMode(),
          child: const Text('System Mode'),
        ),
      ],
    );
  }
}
```

### Method 4: Quick Toggle

```dart
// Toggle between light and dark (skips system mode)
controller.toggleTheme();
```

### Check Current Theme

```dart
// Get current mode
final themeMode = ref.watch(themeModeProvider);

// Check if dark mode is active
final isDark = ref.watch(isDarkThemeProvider);

// Get current brightness
final brightness = ref.watch(currentBrightnessProvider);
```

---

## Using Colors

### Access Theme Colors

```dart
// Get theme colors from context
final colors = Theme.of(context).colorScheme;

Container(
  color: colors.primary,      // Primary color
  child: Text(
    'Hello',
    style: TextStyle(color: colors.onPrimary),  // Text on primary
  ),
)
```

### Available Colors

```dart
// Primary colors
colors.primary          // Main brand color
colors.onPrimary        // Text/icons on primary
colors.primaryContainer // Lighter primary variant
colors.onPrimaryContainer

// Secondary colors
colors.secondary
colors.onSecondary
colors.secondaryContainer
colors.onSecondaryContainer

// Tertiary colors
colors.tertiary
colors.onTertiary

// Error colors
colors.error
colors.onError
colors.errorContainer
colors.onErrorContainer

// Surface colors
colors.surface          // Background for cards, sheets
colors.onSurface        // Text/icons on surface
colors.surfaceVariant
colors.onSurfaceVariant

// Background colors
colors.background       // Page background
colors.onBackground     // Text/icons on background

// Other
colors.outline          // Borders, dividers
colors.shadow           // Shadow color
colors.inverseSurface   // For tooltips
colors.onInverseSurface
```

### Custom Semantic Colors

These are defined in `ThemeColors`:

```dart
// Success (green)
ThemeColors.success
ThemeColors.onSuccess

// Warning (orange/yellow)
ThemeColors.warning
ThemeColors.onWarning

// Info (blue)
ThemeColors.info
ThemeColors.onInfo
```

### Neutral Grays

```dart
ThemeColors.neutral50   // Lightest
ThemeColors.neutral100
ThemeColors.neutral200
// ... up to
ThemeColors.neutral900  // Darkest
```

### Example: Colored Card

```dart
Card(
  color: colors.primaryContainer,
  child: Padding(
    padding: const EdgeInsets.all(16),
    child: Text(
      'Featured Content',
      style: TextStyle(color: colors.onPrimaryContainer),
    ),
  ),
)
```

---

## Using Typography

### Standard Text Styles

```dart
final textTheme = Theme.of(context).textTheme;

Text('Large Display', style: textTheme.displayLarge)    // 57px
Text('Medium Display', style: textTheme.displayMedium)  // 45px
Text('Small Display', style: textTheme.displaySmall)    // 36px

Text('Large Headline', style: textTheme.headlineLarge)   // 32px
Text('Medium Headline', style: textTheme.headlineMedium) // 28px
Text('Small Headline', style: textTheme.headlineSmall)   // 24px

Text('Large Title', style: textTheme.titleLarge)   // 22px
Text('Medium Title', style: textTheme.titleMedium) // 16px
Text('Small Title', style: textTheme.titleSmall)   // 14px

Text('Large Body', style: textTheme.bodyLarge)   // 16px (default)
Text('Medium Body', style: textTheme.bodyMedium) // 14px
Text('Small Body', style: textTheme.bodySmall)   // 12px

Text('Large Label', style: textTheme.labelLarge)   // 14px
Text('Medium Label', style: textTheme.labelMedium) // 12px
Text('Small Label', style: textTheme.labelSmall)   // 11px
```

### When to Use Each Style

- **Display**: Hero text, splash screens, major headings
- **Headline**: Section headings, page titles
- **Title**: Subsection headings, card titles, list titles
- **Body**: Main content, paragraphs, descriptions
- **Label**: Button text, captions, small UI text

### Custom Text Variants

```dart
// Bold text
Text('Bold', style: ThemeText.bold(context))

// Italic text
Text('Italic', style: ThemeText.italic(context))

// Monospace (for code)
Text('Code', style: ThemeText.monospace(context))

// Combine with custom color
Text('Custom', style: ThemeText.bold(context, color: Colors.red))
```

### Example: Article Layout

```dart
Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    Text('Article Title', style: textTheme.headlineMedium),
    SizedBox(height: 8),
    Text('Subtitle', style: textTheme.titleMedium),
    SizedBox(height: 16),
    Text(
      'Article content goes here...',
      style: textTheme.bodyLarge,
    ),
    SizedBox(height: 8),
    Text('Published: Jan 1, 2025', style: textTheme.labelSmall),
  ],
)
```

---

## Using Spacing

### Basic Spacing Values

```dart
ThemeSpacing.xxs   // 4px
ThemeSpacing.xs    // 8px
ThemeSpacing.sm    // 12px
ThemeSpacing.md    // 16px (default)
ThemeSpacing.lg    // 24px
ThemeSpacing.xl    // 32px
ThemeSpacing.xxl   // 48px
ThemeSpacing.xxxl  // 64px
```

### Gaps Between Widgets

```dart
Column(
  children: [
    Text('First'),
    ThemeSpacing.verticalGapMd,   // 16px vertical gap
    Text('Second'),
    ThemeSpacing.verticalGapLg,   // 24px vertical gap
    Text('Third'),
  ],
)

Row(
  children: [
    Text('First'),
    ThemeSpacing.horizontalGapSm,  // 12px horizontal gap
    Text('Second'),
  ],
)
```

### Padding

```dart
// All sides
Padding(
  padding: ThemeSpacing.allMd,  // 16px all sides
  child: Text('Padded'),
)

// Horizontal only
Padding(
  padding: ThemeSpacing.horizontalLg,  // 24px left & right
  child: Text('Padded'),
)

// Vertical only
Padding(
  padding: ThemeSpacing.verticalSm,  // 12px top & bottom
  child: Text('Padded'),
)

// Semantic padding
Padding(
  padding: ThemeSpacing.pagePadding,    // For page content
  child: Text('Page Content'),
)

Padding(
  padding: ThemeSpacing.cardPadding,    // For cards
  child: Text('Card Content'),
)
```

### Complete Spacing Reference

```dart
// Padding EdgeInsets
ThemeSpacing.allXs          // EdgeInsets.all(8)
ThemeSpacing.allSm          // EdgeInsets.all(12)
ThemeSpacing.allMd          // EdgeInsets.all(16)
ThemeSpacing.allLg          // EdgeInsets.all(24)
ThemeSpacing.allXl          // EdgeInsets.all(32)

ThemeSpacing.horizontalXs   // EdgeInsets.symmetric(horizontal: 8)
ThemeSpacing.horizontalSm
ThemeSpacing.horizontalMd
ThemeSpacing.horizontalLg
ThemeSpacing.horizontalXl

ThemeSpacing.verticalXs     // EdgeInsets.symmetric(vertical: 8)
ThemeSpacing.verticalSm
ThemeSpacing.verticalMd
ThemeSpacing.verticalLg
ThemeSpacing.verticalXl

// Semantic padding
ThemeSpacing.pagePadding    // 16px
ThemeSpacing.cardPadding    // 16px
ThemeSpacing.sectionPadding // 24px
ThemeSpacing.buttonPadding  // 16px horizontal, 12px vertical

// Gaps
ThemeSpacing.verticalGapXs  // SizedBox(height: 8)
ThemeSpacing.verticalGapSm  // SizedBox(height: 12)
ThemeSpacing.verticalGapMd  // SizedBox(height: 16)
ThemeSpacing.verticalGapLg  // SizedBox(height: 24)

ThemeSpacing.horizontalGapXs // SizedBox(width: 8)
ThemeSpacing.horizontalGapSm
ThemeSpacing.horizontalGapMd
ThemeSpacing.horizontalGapLg
```

---

## Using Border Radius

### Basic Radius Values

```dart
ThemeRadii.none   // 0px (square corners)
ThemeRadii.sm     // 4px
ThemeRadii.md     // 8px
ThemeRadii.lg     // 12px
ThemeRadii.xl     // 16px
ThemeRadii.xxl    // 24px
ThemeRadii.full   // 9999px (pill shape)
```

### Apply to Containers

```dart
Container(
  decoration: BoxDecoration(
    color: colors.primary,
    borderRadius: ThemeRadii.md,  // 8px rounded corners
  ),
  child: Text('Rounded Container'),
)
```

### Semantic Radius

```dart
// Buttons
Container(
  decoration: BoxDecoration(
    borderRadius: ThemeRadii.buttonRadius,  // 8px
  ),
)

// Cards
Card(
  shape: RoundedRectangleBorder(
    borderRadius: ThemeRadii.cardRadius,  // 12px
  ),
)

// Dialogs
Dialog(
  shape: RoundedRectangleBorder(
    borderRadius: ThemeRadii.dialogRadius,  // 28px
  ),
)

// Bottom Sheets
Container(
  decoration: BoxDecoration(
    borderRadius: ThemeRadii.sheetRadius,  // Top corners only, 16px
  ),
)
```

### Partial Radius (Specific Corners)

```dart
// Top corners only
Container(
  decoration: BoxDecoration(
    borderRadius: ThemeRadii.topLg,  // 12px top corners only
  ),
)

// Bottom corners only
Container(
  decoration: BoxDecoration(
    borderRadius: ThemeRadii.bottomMd,  // 8px bottom corners only
  ),
)

// Left corners only
Container(
  decoration: BoxDecoration(
    borderRadius: ThemeRadii.leftSm,  // 4px left corners only
  ),
)

// Right corners only
Container(
  decoration: BoxDecoration(
    borderRadius: ThemeRadii.rightXl,  // 16px right corners only
  ),
)
```

---

## Using Icons

### Icon Sizes

```dart
Icon(Icons.home, size: ThemeIcons.xs)     // 12px
Icon(Icons.home, size: ThemeIcons.sm)     // 16px
Icon(Icons.home, size: ThemeIcons.md)     // 24px (default)
Icon(Icons.home, size: ThemeIcons.lg)     // 32px
Icon(Icons.home, size: ThemeIcons.xl)     // 48px
Icon(Icons.home, size: ThemeIcons.xxl)    // 64px
Icon(Icons.home, size: ThemeIcons.xxxl)   // 96px
```

### Semantic Icon Sizes

```dart
// App bar icons
Icon(Icons.menu, size: ThemeIcons.appBarIcon)  // 24px

// FAB (Floating Action Button)
Icon(Icons.add, size: ThemeIcons.fabIcon)      // 24px

// List item icons
Icon(Icons.star, size: ThemeIcons.listIcon)    // 24px

// Avatar icons
Icon(Icons.person, size: ThemeIcons.avatarIcon) // 40px
```

### Icon with Color

```dart
Icon(
  Icons.favorite,
  size: ThemeIcons.lg,
  color: colors.error,  // Red heart
)
```

---

## Common Use Cases

### Use Case 1: Settings Screen with Theme Switcher

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'features/theme/theme.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        padding: ThemeSpacing.pagePadding,
        children: [
          Text(
            'Appearance',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          ThemeSpacing.verticalGapMd,
          Card(
            child: Padding(
              padding: ThemeSpacing.cardPadding,
              child: ThemeModeSelector(),
            ),
          ),
        ],
      ),
    );
  }
}
```

### Use Case 2: Custom Button

```dart
class PrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const PrimaryButton({
    super.key,
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: colors.primary,
        foregroundColor: colors.onPrimary,
        padding: ThemeSpacing.buttonPadding,
        shape: RoundedRectangleBorder(
          borderRadius: ThemeRadii.buttonRadius,
        ),
      ),
      child: Text(text),
    );
  }
}
```

### Use Case 3: Styled Card

```dart
class InfoCard extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;

  const InfoCard({
    super.key,
    required this.title,
    required this.description,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Card(
      elevation: ThemeIcons.elevationLow,  // 1dp
      shape: RoundedRectangleBorder(
        borderRadius: ThemeRadii.cardRadius,
      ),
      child: Padding(
        padding: ThemeSpacing.cardPadding,
        child: Row(
          children: [
            Icon(
              icon,
              size: ThemeIcons.lg,
              color: colors.primary,
            ),
            ThemeSpacing.horizontalGapMd,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: textTheme.titleMedium),
                  ThemeSpacing.verticalGapXs,
                  Text(
                    description,
                    style: textTheme.bodySmall?.copyWith(
                      color: colors.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
```

### Use Case 4: Responsive Layout

```dart
class ResponsivePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Responsive')),
      body: Padding(
        padding: ThemeSpacing.responsivePadding(context),
        child: Column(
          children: [
            Text(
              'Content',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
    );
  }
}
```

---

## Troubleshooting

### Problem: Theme not changing

**Solution:**
- Make sure your `main.dart` wraps the app with `ProviderScope`
- Verify `themeModeProvider` is being watched in MaterialApp
- Check that both `theme` and `darkTheme` are set in MaterialApp

```dart
// ✅ Correct
class MyApp extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    return MaterialApp(
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode,  // Important!
    );
  }
}

// ❌ Wrong - not watching provider
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: AppTheme.lightTheme,
    );
  }
}
```

### Problem: Theme not persisting after app restart

**Solution:**
- Add `shared_preferences` dependency
- Theme controller automatically saves preferences
- Wait for initialization: `await controller.initialize()`

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final container = ProviderContainer();
  final controller = container.read(themeControllerProvider);
  await controller.initialize();
  runApp(UncontrolledProviderScope(
    container: container,
    child: MyApp(),
  ));
}
```

### Problem: Colors look wrong in dark mode

**Solution:**
- Use `colors.surface` instead of `Colors.white`
- Use `colors.onSurface` for text instead of `Colors.black`
- Always use theme colors, not hard-coded colors

```dart
// ✅ Correct - adapts to theme
Container(
  color: Theme.of(context).colorScheme.surface,
  child: Text(
    'Text',
    style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
  ),
)

// ❌ Wrong - hard-coded colors
Container(
  color: Colors.white,  // Will look wrong in dark mode
  child: Text(
    'Text',
    style: TextStyle(color: Colors.black),  // Will look wrong in dark mode
  ),
)
```

### Problem: Text not visible on colored backgrounds

**Solution:**
- Use corresponding "on" colors:
  - `primary` → use `onPrimary` for text
  - `secondary` → use `onSecondary` for text
  - `surface` → use `onSurface` for text

```dart
// ✅ Correct
Container(
  color: colors.primary,
  child: Text(
    'Text',
    style: TextStyle(color: colors.onPrimary),  // Guaranteed contrast
  ),
)
```

### Problem: Theme colors not updating in custom widgets

**Solution:**
- Don't cache theme colors in initState or build variables
- Always get colors from `Theme.of(context)` directly
- For StatefulWidget, call `setState` when theme changes

```dart
// ✅ Correct - gets fresh colors
@override
Widget build(BuildContext context) {
  final colors = Theme.of(context).colorScheme;  // Fresh on every build
  return Container(color: colors.primary);
}

// ❌ Wrong - caches old colors
class _MyWidgetState extends State<MyWidget> {
  late Color primaryColor;

  @override
  void initState() {
    super.initState();
    primaryColor = Theme.of(context).colorScheme.primary;  // Old color stuck
  }
}
```

### Problem: "ProviderScope not found" error

**Solution:**
- Wrap your entire app with `ProviderScope` in `main()`

```dart
void main() {
  runApp(
    const ProviderScope(  // Add this!
      child: MyApp(),
    ),
  );
}
```

---

## Quick Reference Cheatsheet

```dart
// Theme Mode
ref.read(themeControllerProvider).setLightMode()
ref.read(themeControllerProvider).setDarkMode()
ref.read(themeControllerProvider).setSystemMode()

// Colors
Theme.of(context).colorScheme.primary
Theme.of(context).colorScheme.surface
Theme.of(context).colorScheme.error

// Typography
Theme.of(context).textTheme.headlineMedium
Theme.of(context).textTheme.bodyLarge
Theme.of(context).textTheme.labelSmall

// Spacing
ThemeSpacing.md                    // 16px
ThemeSpacing.verticalGapLg         // 24px vertical gap
ThemeSpacing.allMd                 // 16px padding all sides

// Border Radius
ThemeRadii.md                      // 8px
ThemeRadii.cardRadius              // 12px
ThemeRadii.full                    // Pill shape

// Icons
ThemeIcons.md                      // 24px
ThemeIcons.lg                      // 32px

// Pre-built Widgets
ThemeToggleButton()
ThemeModeSelector()
```

---

## Next Steps

1. **See It in Action**: Run `lib/features/theme/example_main.dart` to see all features
2. **Customize**: Edit `theme_colors.dart` to match your brand colors
3. **Explore**: Check `THEME_README.md` for advanced customization
4. **Build**: Start using the theme system in your app!

---

## Need Help?

- Check the example: `lib/features/theme/example_main.dart`
- Read the full docs: `lib/features/theme/THEME_README.md`
- Review the code: `lib/features/theme/` directory

Happy theming! 🎨
