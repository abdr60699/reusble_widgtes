# Basic Theme Guide

A simple, easy-to-use theme system for Flutter apps with light, dark, and system mode support.

## 🎨 What You Get

- ✅ Light and Dark themes
- ✅ System default mode (follows device setting)
- ✅ Easy color customization
- ✅ Simple font settings
- ✅ Theme switching with one line of code
- ✅ Persistent theme preference
- ✅ Pre-built toggle buttons

---

## 📦 Installation

### Step 1: Add Dependency

Add this to your `pubspec.yaml`:

```yaml
dependencies:
  shared_preferences: ^2.2.2
```

Run: `flutter pub get`

### Step 2: Setup in main.dart

```dart
import 'package:flutter/material.dart';
import 'features/basic_theme/basic_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Create and initialize theme manager
  final themeManager = BasicThemeManager();
  await themeManager.initialize();

  runApp(MyApp(themeManager: themeManager));
}

class MyApp extends StatefulWidget {
  final BasicThemeManager themeManager;

  const MyApp({super.key, required this.themeManager});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    // Listen to theme changes
    widget.themeManager.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My App',
      theme: BasicThemeConfig.lightTheme,
      darkTheme: BasicThemeConfig.darkTheme,
      themeMode: widget.themeManager.themeMode,
      home: HomePage(themeManager: widget.themeManager),
    );
  }
}
```

**That's it! Your app now has a complete theme system.**

---

## 🎯 Quick Usage

### Add Theme Toggle Button

Add a theme switcher to your app bar:

```dart
AppBar(
  title: const Text('My App'),
  actions: [
    BasicThemeToggleButton(themeManager: themeManager),
  ],
)
```

This button cycles through: **Light** → **Dark** → **System** → **Light**

### Show Theme Selector

Show all theme options in a settings screen:

```dart
Card(
  child: BasicThemeModeSelector(themeManager: themeManager),
)
```

### Change Theme Programmatically

```dart
// Set to light mode
themeManager.setLightMode();

// Set to dark mode
themeManager.setDarkMode();

// Set to system mode (follows device)
themeManager.setSystemMode();

// Toggle between light and dark
themeManager.toggleTheme();
```

---

## 🎨 Customize Colors

Edit `lib/features/basic_theme/basic_colors.dart`:

```dart
class BasicColors {
  // LIGHT THEME COLORS
  static const Color lightPrimary = Color(0xFF2196F3);      // Your brand color
  static const Color lightSecondary = Color(0xFF03DAC6);    // Accent color
  static const Color lightBackground = Color(0xFFFFFFFF);   // Page background
  static const Color lightSurface = Color(0xFFFAFAFA);      // Card background
  static const Color lightError = Color(0xFFB00020);        // Error color

  // DARK THEME COLORS
  static const Color darkPrimary = Color(0xFF90CAF9);       // Your brand color (dark)
  static const Color darkSecondary = Color(0xFF03DAC6);     // Accent color (dark)
  static const Color darkBackground = Color(0xFF121212);    // Page background (dark)
  static const Color darkSurface = Color(0xFF1E1E1E);       // Card background (dark)
  static const Color darkError = Color(0xFFCF6679);         // Error color (dark)
}
```

### Color Picker Tool

Don't know what color to use? Try:
- [Material Design Color Tool](https://material.io/resources/color/)
- [Coolors.co](https://coolors.co/)
- [Adobe Color](https://color.adobe.com/)

---

## ✍️ Customize Fonts

### Change Font Family

Edit `lib/features/basic_theme/basic_fonts.dart`:

```dart
class BasicFonts {
  // Change this to your font
  static const String fontFamily = 'Roboto';
}
```

### Add Custom Font

1. **Add font files to your project:**

```
your_app/
  fonts/
    Roboto-Regular.ttf
    Roboto-Bold.ttf
```

2. **Update pubspec.yaml:**

```yaml
flutter:
  fonts:
    - family: Roboto
      fonts:
        - asset: fonts/Roboto-Regular.ttf
        - asset: fonts/Roboto-Bold.ttf
          weight: 700
```

3. **Update basic_fonts.dart:**

```dart
static const String fontFamily = 'Roboto';
```

4. **Run:** `flutter pub get`

### Free Font Resources
- [Google Fonts](https://fonts.google.com/)
- [Font Squirrel](https://www.fontsquirrel.com/)

### Customize Font Sizes

Edit `basic_fonts.dart`:

```dart
class BasicFonts {
  // Heading sizes
  static const double headingLarge = 32.0;   // Big titles
  static const double headingMedium = 24.0;  // Section titles
  static const double headingSmall = 20.0;   // Card titles

  // Body text sizes
  static const double bodyLarge = 16.0;   // Main text
  static const double bodyMedium = 14.0;  // Secondary text
  static const double bodySmall = 12.0;   // Captions
}
```

---

## 📖 Using Theme Colors

### Get Theme Colors

```dart
final colors = Theme.of(context).colorScheme;
```

### Common Colors

```dart
// Brand colors
colors.primary          // Your main brand color
colors.secondary        // Your accent color

// Backgrounds
colors.background       // Page background
colors.surface          // Card/sheet background

// Text colors
colors.onBackground     // Text on page background
colors.onSurface        // Text on cards
colors.onPrimary        // Text on primary color

// Other
colors.error            // Error/warning color
colors.outline          // Border/divider color
```

### Example: Colored Container

```dart
Container(
  color: colors.primary,
  child: Text(
    'Hello',
    style: TextStyle(color: colors.onPrimary),
  ),
)
```

### Example: Card

```dart
Card(
  color: colors.surface,
  child: Padding(
    padding: const EdgeInsets.all(16),
    child: Text(
      'Card Content',
      style: TextStyle(color: colors.onSurface),
    ),
  ),
)
```

---

## ✍️ Using Typography

### Get Text Styles

```dart
final textTheme = Theme.of(context).textTheme;
```

### Available Styles

```dart
// Large headings (page titles)
Text('Title', style: textTheme.headlineLarge)      // 32px bold

// Medium headings (section titles)
Text('Section', style: textTheme.headlineMedium)   // 24px bold

// Small headings (card titles)
Text('Card Title', style: textTheme.headlineSmall) // 20px semi-bold

// Body text (main content)
Text('Content', style: textTheme.bodyLarge)        // 16px normal
Text('Content', style: textTheme.bodyMedium)       // 14px normal
Text('Caption', style: textTheme.bodySmall)        // 12px normal

// Button text
Text('BUTTON', style: textTheme.labelLarge)        // 14px semi-bold
```

### Example: Article Layout

```dart
Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    Text('Article Title', style: textTheme.headlineMedium),
    const SizedBox(height: 8),
    Text('Article content here...', style: textTheme.bodyLarge),
    const SizedBox(height: 4),
    Text('Published: Jan 1, 2025', style: textTheme.bodySmall),
  ],
)
```

---

## 🔧 Common Use Cases

### Use Case 1: Settings Screen

```dart
class SettingsScreen extends StatelessWidget {
  final BasicThemeManager themeManager;

  const SettingsScreen({super.key, required this.themeManager});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            'Appearance',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 16),
          Card(
            child: BasicThemeModeSelector(themeManager: themeManager),
          ),
        ],
      ),
    );
  }
}
```

### Use Case 2: Custom Button

```dart
ElevatedButton(
  onPressed: () {},
  child: const Text('Click Me'),
)
```

The button automatically uses your theme colors!

### Use Case 3: Styled Card

```dart
Card(
  child: Padding(
    padding: const EdgeInsets.all(16),
    child: Column(
      children: [
        Icon(
          Icons.check_circle,
          color: Theme.of(context).colorScheme.primary,
          size: 48,
        ),
        const SizedBox(height: 8),
        Text(
          'Success!',
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ],
    ),
  ),
)
```

---

## 🎯 Best Practices

### ✅ DO

```dart
// ✅ Use theme colors
Container(color: Theme.of(context).colorScheme.primary)

// ✅ Use text styles
Text('Hello', style: Theme.of(context).textTheme.bodyLarge)

// ✅ Use "on" colors for text
Container(
  color: colors.primary,
  child: Text('Text', style: TextStyle(color: colors.onPrimary)),
)
```

### ❌ DON'T

```dart
// ❌ Don't use hard-coded colors
Container(color: Colors.blue)  // Won't adapt to theme

// ❌ Don't use hard-coded text styles
Text('Hello', style: TextStyle(fontSize: 16))  // Inconsistent

// ❌ Don't use wrong text colors
Container(
  color: colors.primary,
  child: Text('Text', style: TextStyle(color: Colors.black)),  // May not be visible
)
```

---

## 🚨 Troubleshooting

### Problem: Theme not changing

**Check:**
1. Did you wrap MaterialApp with theme settings?
2. Did you pass `themeMode: themeManager.themeMode`?
3. Did you set both `theme` and `darkTheme`?

```dart
// ✅ Correct setup
MaterialApp(
  theme: BasicThemeConfig.lightTheme,
  darkTheme: BasicThemeConfig.darkTheme,
  themeMode: themeManager.themeMode,
)
```

### Problem: Theme not persisting after restart

**Check:**
1. Did you add `shared_preferences` dependency?
2. Did you call `await themeManager.initialize()` in main?
3. Did you add `WidgetsFlutterBinding.ensureInitialized()`?

```dart
// ✅ Correct initialization
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final themeManager = BasicThemeManager();
  await themeManager.initialize();
  runApp(MyApp(themeManager: themeManager));
}
```

### Problem: Colors look wrong in dark mode

**Solution:**
- Don't use hard-coded colors like `Colors.white` or `Colors.black`
- Always use `Theme.of(context).colorScheme` colors

```dart
// ✅ Correct
final colors = Theme.of(context).colorScheme;
Container(color: colors.surface)

// ❌ Wrong
Container(color: Colors.white)  // Will look wrong in dark mode
```

### Problem: Text not visible

**Solution:**
- Always use the correct "on" color for text:
  - `primary` → use `onPrimary`
  - `surface` → use `onSurface`
  - `background` → use `onBackground`

---

## 🎓 Complete Example

Here's a complete working example:

```dart
import 'package:flutter/material.dart';
import 'features/basic_theme/basic_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final themeManager = BasicThemeManager();
  await themeManager.initialize();
  runApp(MyApp(themeManager: themeManager));
}

class MyApp extends StatefulWidget {
  final BasicThemeManager themeManager;
  const MyApp({super.key, required this.themeManager});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    widget.themeManager.addListener(() => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Basic Theme Demo',
      theme: BasicThemeConfig.lightTheme,
      darkTheme: BasicThemeConfig.darkTheme,
      themeMode: widget.themeManager.themeMode,
      home: HomePage(themeManager: widget.themeManager),
    );
  }
}

class HomePage extends StatelessWidget {
  final BasicThemeManager themeManager;
  const HomePage({super.key, required this.themeManager});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Basic Theme'),
        actions: [
          BasicThemeToggleButton(themeManager: themeManager),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text('Welcome!', style: textTheme.headlineLarge),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Icon(Icons.palette, size: 48, color: colors.primary),
                  const SizedBox(height: 8),
                  Text('Theme Settings', style: textTheme.titleLarge),
                  const SizedBox(height: 16),
                  BasicThemeModeSelector(themeManager: themeManager),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {},
            child: const Text('Elevated Button'),
          ),
          const SizedBox(height: 8),
          OutlinedButton(
            onPressed: () {},
            child: const Text('Outlined Button'),
          ),
          const SizedBox(height: 8),
          TextButton(
            onPressed: () {},
            child: const Text('Text Button'),
          ),
        ],
      ),
    );
  }
}
```

---

## 📚 Next Steps

1. **Customize your colors** - Edit `basic_colors.dart` to match your brand
2. **Add your font** - Update `basic_fonts.dart` with your chosen font
3. **Try the example** - Run the example above to see it in action
4. **Build your app** - Start using the theme in your screens!

---

## 🆚 Basic vs Advanced Theme

This repository has **two** theme systems:

### Basic Theme (This Guide)
- ✅ Simple and easy to understand
- ✅ Quick setup (5 minutes)
- ✅ Perfect for beginners
- ✅ Light/Dark/System modes
- ✅ Basic customization
- 📁 Location: `lib/features/basic_theme/`

### Advanced Theme
- ✅ Full Material 3 design system
- ✅ 100+ design tokens
- ✅ Riverpod state management
- ✅ Advanced customization
- ✅ Spacing, radius, icons system
- 📁 Location: `lib/features/theme/`
- 📖 Guide: `THEME_USAGE_GUIDE.md`

**Choose Basic Theme if:** You want something simple and easy
**Choose Advanced Theme if:** You need full design system control

---

## ❓ Need Help?

- Check the example code in this guide
- Look at `lib/features/basic_theme/` files
- For advanced features, see `THEME_USAGE_GUIDE.md`

Happy theming! 🎨
