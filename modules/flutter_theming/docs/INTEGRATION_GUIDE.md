# Integration Guide

This guide provides step-by-step integration instructions for the theming system with various state management solutions and common Flutter patterns.

## Table of Contents

1. [General Integration Steps](#general-integration-steps)
2. [Provider Integration](#provider-integration)
3. [Riverpod Integration](#riverpod-integration)
4. [Bloc Integration](#bloc-integration)
5. [GetIt Integration](#getit-integration)
6. [Raw Stream Integration](#raw-stream-integration)
7. [Material App Integration](#material-app-integration)
8. [Component Integration](#component-integration)
9. [Initialization Lifecycle](#initialization-lifecycle)
10. [Common Patterns](#common-patterns)
11. [Troubleshooting](#troubleshooting)

---

## General Integration Steps

Regardless of state management choice, follow these general steps:

### Step 1: Add Dependencies

Add theming module to `pubspec.yaml`:

```yaml
dependencies:
  flutter_theming:
    path: ../modules/flutter_theming

  # Choose your persistence adapter:
  shared_preferences: ^2.2.0  # For SharedPreferences
  # OR
  hive: ^2.2.3  # For Hive
  hive_flutter: ^1.1.0
```

### Step 2: Register Dependencies

Set up dependency injection (choose one approach):

**Approach A: Manual Singleton**
```
In your app's main() or initialization:

1. Create PersistenceAdapter instance
2. Create ThemeRepository with adapter
3. Create ThemeValidator instance
4. Create ThemePresets instance
5. Initialize ThemeService with all dependencies
```

**Approach B: Using GetIt**
```
Register all services in GetIt container:

getIt.registerSingleton<PersistenceAdapter>(SharedPreferencesPersistenceAdapter());
getIt.registerSingleton<ThemeValidator>(ThemeValidator());
getIt.registerSingleton<ThemeRepository>(ThemeRepository(getIt<PersistenceAdapter>()));
getIt.registerSingleton<ThemeService>(await ThemeService.initialize(
  repository: getIt<ThemeRepository>(),
  validator: getIt<ThemeValidator>(),
  presets: ThemePresets(),
));
```

### Step 3: Initialize Before runApp()

In `main()`, initialize theming before building widget tree:

```
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize persistence (e.g., SharedPreferences)
  await SharedPreferences.getInstance();

  // Initialize theming system
  await ThemeService.initialize(...);

  runApp(MyApp());
}
```

### Step 4: Provide to Widget Tree

Wrap your app with appropriate provider based on state management choice (see sections below).

### Step 5: Consume in Widgets

Access theme tokens in widgets:

```
In widget build():
  Get tokens: ThemeService.instance.tokens
  Use color: Container(color: tokens.colors.primary)
  Use spacing: Padding(padding: EdgeInsets.all(tokens.spacing.md))
```

---

## Provider Integration

### Setup

**Step 1: Add Provider Dependency**

```yaml
dependencies:
  provider: ^6.1.1
```

**Step 2: Create ThemeProvider**

Create a `ChangeNotifier` wrapper for ThemeService:

```
Class: ThemeProvider extends ChangeNotifier

Properties:
  - _themeService: ThemeService (injected)
  - _subscription: StreamSubscription<AppTheme>?

Constructor:
  - Accepts ThemeService instance
  - Subscribes to themeService.themeStream
  - On stream event, calls notifyListeners()

Getters:
  - currentTheme: Returns _themeService.currentTheme
  - tokens: Returns _themeService.tokens
  - mode: Returns _themeService.mode

Methods:
  - setTheme(AppThemeMode mode): Calls _themeService.setTheme(mode)
  - setCustomAccent(Color color): Calls _themeService.setCustomAccent(color)
  - setCustomTheme(AppTheme theme): Calls _themeService.setCustomTheme(theme)

Dispose:
  - Cancel _subscription
  - Call super.dispose()
```

**Step 3: Provide at App Root**

In `main.dart`:

```
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize theming
  final themeService = await ThemeService.initialize(...);
  final themeProvider = ThemeProvider(themeService);

  runApp(
    ChangeNotifierProvider.value(
      value: themeProvider,
      child: MyApp(),
    ),
  );
}
```

### Consuming in Widgets

**Option 1: Provider.of**

```
Widget build(BuildContext context) {
  final theme = Provider.of<ThemeProvider>(context);

  return Container(
    color: theme.tokens.colors.surface,
    child: Text(
      'Hello',
      style: TextStyle(
        fontSize: theme.tokens.typography.body1.fontSize,
        color: theme.tokens.colors.onSurface,
      ),
    ),
  );
}
```

**Option 2: Consumer**

```
Widget build(BuildContext context) {
  return Consumer<ThemeProvider>(
    builder: (context, theme, child) {
      return Container(
        color: theme.tokens.colors.surface,
        child: Text('Hello'),
      );
    },
  );
}
```

**Option 3: Selector (Optimized)**

For fine-grained updates, use `Selector` to rebuild only when specific token changes:

```
Widget build(BuildContext context) {
  return Selector<ThemeProvider, Color>(
    selector: (context, theme) => theme.tokens.colors.primary,
    builder: (context, primaryColor, child) {
      return Container(color: primaryColor);
    },
  );
}
```

**Benefit**: Widget only rebuilds when `primary` color changes, not on every theme change.

### Switching Themes

```
// In button or settings screen:

void _switchToDark(BuildContext context) {
  final theme = Provider.of<ThemeProvider>(context, listen: false);
  theme.setTheme(AppThemeMode.dark);
}

void _setCustomAccent(BuildContext context, Color accent) {
  final theme = Provider.of<ThemeProvider>(context, listen: false);
  theme.setCustomAccent(accent);
}
```

**Note**: Use `listen: false` when calling methods to avoid unnecessary rebuilds.

---

## Riverpod Integration

### Setup

**Step 1: Add Riverpod Dependency**

```yaml
dependencies:
  flutter_riverpod: ^2.4.9
```

**Step 2: Create ThemeNotifier**

Create a `StateNotifier<AppTheme>`:

```
Class: ThemeNotifier extends StateNotifier<AppTheme>

Properties:
  - _themeService: ThemeService
  - _subscription: StreamSubscription<AppTheme>?

Constructor:
  - Accepts ThemeService
  - Sets initial state: super(_themeService.currentTheme)
  - Subscribes to themeService.themeStream
  - On stream event, updates state: state = newTheme

Methods:
  - setTheme(AppThemeMode mode): Calls _themeService.setTheme(mode)
  - setCustomAccent(Color color): Calls _themeService.setCustomAccent(color)
  - setCustomTheme(AppTheme theme): Calls _themeService.setCustomTheme(theme)

Dispose:
  - Cancel _subscription
  - Call super.dispose()
```

**Step 3: Create Provider**

```
Create StateNotifierProvider:

final themeProvider = StateNotifierProvider<ThemeNotifier, AppTheme>((ref) {
  final themeService = ref.watch(themeServiceProvider);
  return ThemeNotifier(themeService);
});

Also create provider for ThemeService itself:

final themeServiceProvider = Provider<ThemeService>((ref) {
  return ThemeService.instance;
});
```

**Step 4: Wrap App with ProviderScope**

```
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize theming
  await ThemeService.initialize(...);

  runApp(
    ProviderScope(
      child: MyApp(),
    ),
  );
}
```

### Consuming in Widgets

**Option 1: ConsumerWidget**

```
class MyWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.watch(themeProvider);

    return Container(
      color: theme.tokens.colors.surface,
      child: Text('Hello'),
    );
  }
}
```

**Option 2: Consumer**

```
class MyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final theme = ref.watch(themeProvider);
        return Container(color: theme.tokens.colors.surface);
      },
    );
  }
}
```

**Option 3: Select (Optimized)**

Rebuild only when specific token changes:

```
class MyWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final primaryColor = ref.watch(
      themeProvider.select((theme) => theme.tokens.colors.primary),
    );

    return Container(color: primaryColor);
  }
}
```

### Switching Themes

```
class ThemeSettingsScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeNotifier = ref.read(themeProvider.notifier);

    return ElevatedButton(
      onPressed: () => themeNotifier.setTheme(AppThemeMode.dark),
      child: Text('Switch to Dark'),
    );
  }
}
```

**Note**: Use `ref.read()` to access notifier for calling methods (no rebuild).

---

## Bloc Integration

### Setup

**Step 1: Add Bloc Dependencies**

```yaml
dependencies:
  flutter_bloc: ^8.1.3
```

**Step 2: Define Events**

```
Abstract class ThemeEvent

Concrete events:
  - ThemeLoadRequested: Initial theme load
  - ThemeChangeRequested(AppThemeMode mode): User switches theme
  - ThemeCustomAccentRequested(Color accent): User picks accent
  - ThemeCustomRequested(AppTheme theme): User applies custom theme
  - ThemeResetRequested: User resets to default
```

**Step 3: Define States**

```
Abstract class ThemeState

Concrete states:
  - ThemeInitial: Before theme is loaded
  - ThemeLoading: Loading saved theme
  - ThemeLoaded(AppTheme theme): Theme ready
  - ThemeError(String message): Failed to load/apply
```

**Step 4: Create ThemeBloc**

```
Class: ThemeBloc extends Bloc<ThemeEvent, ThemeState>

Properties:
  - _themeService: ThemeService

Constructor:
  - Accepts ThemeService
  - Initial state: ThemeInitial()
  - Registers event handlers:
    - on<ThemeLoadRequested>(_onLoadRequested)
    - on<ThemeChangeRequested>(_onChangeRequested)
    - on<ThemeCustomAccentRequested>(_onCustomAccentRequested)
    - etc.

Event Handlers:

_onLoadRequested(event, emit):
  emit(ThemeLoading())
  try:
    Current theme from _themeService.currentTheme
    emit(ThemeLoaded(theme))
  catch error:
    emit(ThemeError(error.toString()))

_onChangeRequested(event, emit):
  emit(ThemeLoading())
  try:
    await _themeService.setTheme(event.mode)
    Updated theme from _themeService.currentTheme
    emit(ThemeLoaded(theme))
  catch error:
    emit(ThemeError(error.toString()))

(Similar for other events)
```

**Step 5: Provide Bloc at App Root**

```
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final themeService = await ThemeService.initialize(...);
  final themeBloc = ThemeBloc(themeService);

  // Trigger initial load
  themeBloc.add(ThemeLoadRequested());

  runApp(
    BlocProvider.value(
      value: themeBloc,
      child: MyApp(),
    ),
  );
}
```

### Consuming in Widgets

**Option 1: BlocBuilder**

```
Widget build(BuildContext context) {
  return BlocBuilder<ThemeBloc, ThemeState>(
    builder: (context, state) {
      if (state is ThemeLoaded) {
        return Container(color: state.theme.tokens.colors.surface);
      } else if (state is ThemeLoading) {
        return CircularProgressIndicator();
      } else if (state is ThemeError) {
        return Text('Error: ${state.message}');
      }
      return SizedBox.shrink();
    },
  );
}
```

**Option 2: BlocSelector (Optimized)**

Rebuild only when specific value changes:

```
Widget build(BuildContext context) {
  return BlocSelector<ThemeBloc, ThemeState, Color>(
    selector: (state) {
      if (state is ThemeLoaded) {
        return state.theme.tokens.colors.primary;
      }
      return Colors.transparent;
    },
    builder: (context, primaryColor) {
      return Container(color: primaryColor);
    },
  );
}
```

### Switching Themes

```
class ThemeSettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        context.read<ThemeBloc>().add(
          ThemeChangeRequested(AppThemeMode.dark),
        );
      },
      child: Text('Switch to Dark'),
    );
  }
}
```

---

## GetIt Integration

### Setup

**Step 1: Add GetIt Dependency**

```yaml
dependencies:
  get_it: ^7.6.4
```

**Step 2: Register Services**

In initialization file (e.g., `service_locator.dart`):

```
final getIt = GetIt.instance;

Future<void> setupServiceLocator() async {
  // Register persistence adapter
  getIt.registerSingleton<PersistenceAdapter>(
    SharedPreferencesPersistenceAdapter(),
  );

  // Register validator
  getIt.registerSingleton<ThemeValidator>(
    ThemeValidator(),
  );

  // Register repository
  getIt.registerSingleton<ThemeRepository>(
    ThemeRepository(getIt<PersistenceAdapter>()),
  );

  // Initialize and register theme service
  final themeService = await ThemeService.initialize(
    repository: getIt<ThemeRepository>(),
    validator: getIt<ThemeValidator>(),
    presets: ThemePresets(),
  );
  getIt.registerSingleton<ThemeService>(themeService);
}
```

**Step 3: Initialize Before runApp**

```
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await setupServiceLocator();

  runApp(MyApp());
}
```

### Consuming in Widgets

**Option 1: Direct Access**

```
Widget build(BuildContext context) {
  final themeService = getIt<ThemeService>();

  return Container(
    color: themeService.tokens.colors.surface,
    child: Text('Hello'),
  );
}
```

**Option 2: With StreamBuilder (Reactive)**

```
Widget build(BuildContext context) {
  final themeService = getIt<ThemeService>();

  return StreamBuilder<AppTheme>(
    stream: themeService.themeStream,
    initialData: themeService.currentTheme,
    builder: (context, snapshot) {
      if (!snapshot.hasData) return SizedBox.shrink();

      final theme = snapshot.data!;
      return Container(color: theme.tokens.colors.surface);
    },
  );
}
```

**Option 3: Combine with Provider**

For reactivity, combine GetIt with Provider:

```
// In main():
runApp(
  ChangeNotifierProvider(
    create: (_) => ThemeProvider(getIt<ThemeService>()),
    child: MyApp(),
  ),
);

// In widgets:
final theme = Provider.of<ThemeProvider>(context);
```

### Switching Themes

```
void _switchTheme() {
  final themeService = getIt<ThemeService>();
  themeService.setTheme(AppThemeMode.dark);
}
```

---

## Raw Stream Integration

If not using a state management library, use raw `StreamBuilder`.

### Setup

**Step 1: Initialize ThemeService**

```
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ThemeService.initialize(...);
  runApp(MyApp());
}
```

**Step 2: Create ThemeObserver Widget**

Create a custom observer widget:

```
Class: ThemeObserver extends StatelessWidget

Properties:
  - builder: Widget Function(BuildContext, AppTheme)

Build method:
  return StreamBuilder<AppTheme>(
    stream: ThemeService.instance.themeStream,
    initialData: ThemeService.instance.currentTheme,
    builder: (context, snapshot) {
      if (!snapshot.hasData) {
        return CircularProgressIndicator();
      }
      return builder(context, snapshot.data!);
    },
  );
```

**Step 3: Wrap App with ThemeObserver**

```
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ThemeObserver(
      builder: (context, theme) {
        return MaterialApp(
          theme: _buildThemeData(theme),
          home: HomeScreen(),
        );
      },
    );
  }

  ThemeData _buildThemeData(AppTheme theme) {
    return ThemeData(
      primaryColor: theme.tokens.colors.primary,
      scaffoldBackgroundColor: theme.tokens.colors.background,
      // ... map other tokens
    );
  }
}
```

### Consuming in Widgets

Use ThemeService.instance directly or pass theme down via InheritedWidget:

```
Widget build(BuildContext context) {
  final tokens = ThemeService.instance.tokens;

  return Container(
    color: tokens.colors.surface,
    padding: EdgeInsets.all(tokens.spacing.md),
  );
}
```

### Switching Themes

```
void _switchTheme() {
  ThemeService.instance.setTheme(AppThemeMode.dark);
}
```

---

## Material App Integration

### Mapping Tokens to ThemeData

Convert design tokens to Material `ThemeData`:

```
ThemeData buildMaterialTheme(DesignTokens tokens) {
  return ThemeData(
    useMaterial3: true,

    // Color Scheme
    colorScheme: ColorScheme(
      brightness: _determineBrightness(tokens),
      primary: tokens.colors.primary,
      onPrimary: tokens.colors.onPrimary,
      primaryContainer: tokens.colors.primaryContainer,
      onPrimaryContainer: tokens.colors.onPrimaryContainer,
      secondary: tokens.colors.secondary,
      onSecondary: tokens.colors.onSecondary,
      error: tokens.colors.error,
      onError: tokens.colors.onError,
      background: tokens.colors.background,
      onBackground: tokens.colors.onBackground,
      surface: tokens.colors.surface,
      onSurface: tokens.colors.onSurface,
      surfaceVariant: tokens.colors.surfaceVariant,
      onSurfaceVariant: tokens.colors.onSurfaceVariant,
      outline: tokens.colors.outline,
    ),

    // Typography
    textTheme: TextTheme(
      displayLarge: TextStyle(
        fontSize: tokens.typography.display1.fontSize,
        fontWeight: tokens.typography.display1.fontWeight,
        fontFamily: tokens.typography.primaryFontFamily,
      ),
      headlineLarge: TextStyle(
        fontSize: tokens.typography.h1.fontSize,
        fontWeight: tokens.typography.h1.fontWeight,
      ),
      bodyLarge: TextStyle(
        fontSize: tokens.typography.body1.fontSize,
        fontWeight: tokens.typography.body1.fontWeight,
      ),
      // ... map all typography tokens
    ),

    // Component Themes
    appBarTheme: AppBarTheme(
      backgroundColor: tokens.colors.surface,
      foregroundColor: tokens.colors.onSurface,
      elevation: tokens.elevations.low,
    ),

    cardTheme: CardTheme(
      color: tokens.colors.surface,
      elevation: tokens.elevations.medium,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(tokens.radii.cardRadius),
      ),
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: tokens.colors.primary,
        foregroundColor: tokens.colors.onPrimary,
        padding: EdgeInsets.symmetric(
          horizontal: tokens.spacing.md,
          vertical: tokens.spacing.sm,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(tokens.radii.buttonRadius),
        ),
      ),
    ),

    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: tokens.colors.surfaceVariant,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(tokens.radii.inputRadius),
      ),
      contentPadding: EdgeInsets.all(tokens.spacing.inputPadding),
    ),

    // ... map other component themes
  );
}

Brightness _determineBrightness(DesignTokens tokens) {
  // Determine if theme is light or dark based on background luminance
  final bgLuminance = tokens.colors.background.computeLuminance();
  return bgLuminance > 0.5 ? Brightness.light : Brightness.dark;
}
```

### Using in MaterialApp

```
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ThemeObserver(  // or Provider/Riverpod equivalent
      builder: (context, theme) {
        return MaterialApp(
          theme: buildMaterialTheme(theme.tokens),
          home: HomeScreen(),
        );
      },
    );
  }
}
```

---

## Component Integration

### Creating Themed Components

Build reusable components that consume tokens:

**Example: ThemedButton**

```
Class: ThemedButton extends StatelessWidget

Properties:
  - label: String
  - onPressed: VoidCallback?
  - variant: ButtonVariant (primary, secondary, outlined)

Build method:
  1. Get tokens: ThemeService.instance.tokens (or via Provider/Riverpod)
  2. Determine colors based on variant:
     - primary: tokens.colors.primary background
     - secondary: tokens.colors.secondary background
     - outlined: transparent background, primary border
  3. Build ElevatedButton/OutlinedButton with:
     - Appropriate background color
     - Text color from onPrimary/onSecondary
     - Padding from tokens.spacing.buttonPadding
     - Border radius from tokens.radii.buttonRadius
  4. Return button widget
```

**Example: ThemedCard**

```
Class: ThemedCard extends StatelessWidget

Properties:
  - child: Widget
  - elevation: double? (optional, defaults to token value)
  - padding: double? (optional, defaults to token value)

Build method:
  1. Get tokens
  2. Build Card with:
     - color: tokens.colors.surface
     - elevation: elevation ?? tokens.elevations.medium
     - shape: RoundedRectangleBorder with tokens.radii.cardRadius
  3. Wrap child with Padding using tokens.spacing.cardPadding
  4. Return card widget
```

### Component Theme Inheritance

Create component-specific theme classes:

```
Class: ButtonTheme

Properties:
  - backgroundColor: Color
  - textColor: Color
  - padding: EdgeInsets
  - borderRadius: double
  - elevation: double

Static method: fromTokens(DesignTokens tokens, ButtonVariant variant)
  Returns ButtonTheme with appropriate values based on variant
```

Usage in components:

```
class ThemedButton extends StatelessWidget {
  final ButtonVariant variant;

  @override
  Widget build(BuildContext context) {
    final tokens = ThemeService.instance.tokens;
    final buttonTheme = ButtonTheme.fromTokens(tokens, variant);

    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: buttonTheme.backgroundColor,
        foregroundColor: buttonTheme.textColor,
        padding: buttonTheme.padding,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(buttonTheme.borderRadius),
        ),
      ),
      onPressed: onPressed,
      child: Text(label),
    );
  }
}
```

---

## Initialization Lifecycle

### Complete Initialization Sequence

```
1. App Starts
   └─ main() function called

2. Flutter Binding Initialization
   └─ WidgetsFlutterBinding.ensureInitialized()
   Purpose: Ensures Flutter framework is ready before async operations

3. Persistence Initialization
   └─ await SharedPreferences.getInstance()
   Purpose: Initialize storage backend before theme service needs it

4. Dependency Registration
   └─ Create and register all services (GetIt/manual)
   Order:
     a. PersistenceAdapter (no dependencies)
     b. ThemeValidator (no dependencies)
     c. ThemePresets (no dependencies)
     d. ThemeRepository (depends on PersistenceAdapter)
     e. ThemeService (depends on Repository, Validator, Presets)

5. ThemeService Initialization
   └─ await ThemeService.initialize(...)
   Internal steps:
     a. Store dependencies
     b. Initialize ThemeRepository
     c. Load saved theme preference (ID)
     d. If saved theme exists:
        - Load theme (from preset or custom JSON)
        - Validate theme
        - If valid, set as current
        - If invalid, log warning, use default
     e. If no saved theme:
        - Detect system theme preference (light/dark)
        - Load matching preset
     f. Set up theme stream controller
     g. Mark service as initialized

6. State Management Setup
   └─ Create Provider/Riverpod/Bloc wrapper (if used)
   └─ Subscribe to ThemeService.themeStream

7. Build Widget Tree
   └─ runApp(MyApp())
   └─ Wrap with state management provider (if used)
   └─ MaterialApp built with theme from tokens

8. First Frame Rendered
   └─ UI displays with correct theme
   └─ Ready for user interaction

9. Runtime Operations
   └─ User changes theme
   └─ ThemeService.setTheme() called
   └─ Stream emits event
   └─ Observers rebuild
   └─ UI updates
```

### Initialization Error Handling

```
Graceful fallback strategy:

1. If persistence initialization fails:
   └─ Log error
   └─ Use InMemoryPersistenceAdapter as fallback
   └─ Continue with default theme (no persistence)

2. If saved theme load fails:
   └─ Log warning
   └─ Use system theme or light theme as default
   └─ Continue initialization

3. If theme validation fails:
   └─ Log validation errors
   └─ Use closest valid preset
   └─ Continue initialization

4. If all fails:
   └─ Use hardcoded safe default theme
   └─ Display warning to user
   └─ Allow manual theme selection
```

---

## Common Patterns

### Pattern 1: Theme Switcher Button

```
Widget: ThemeSwitcherButton

Displays current theme mode
Toggles between light and dark on tap

Implementation:
  1. Get current theme mode from ThemeService/Provider
  2. Display icon: sun for light, moon for dark
  3. On tap:
     - If light, switch to dark
     - If dark, switch to light
  4. Call appropriate setTheme method
```

### Pattern 2: Theme Picker Dialog

```
Widget: ThemePickerDialog

Shows list of available presets
Allows user to select theme

Implementation:
  1. Get available presets: ThemeService.instance.getAvailablePresets()
  2. Display in list/grid with previews
  3. Highlight currently active theme
  4. On selection:
     - Call setThemePreset(selectedId)
     - Close dialog
  5. Apply theme instantly (user sees change)
```

### Pattern 3: Custom Accent Picker

```
Widget: AccentColorPicker

Color picker dialog for custom accent

Implementation:
  1. Display color picker (use flutter_colorpicker or custom)
  2. As user picks, preview color against current theme
  3. Validate contrast in real-time
  4. If valid, enable "Apply" button
  5. On apply:
     - Call setCustomAccent(selectedColor)
     - Close picker
  6. If invalid, show warning and suggestions
```

### Pattern 4: Scoped Theme Override

```
Use case: Feature with custom branding

Implementation:
  1. Wrap feature screen with ThemeScopeProvider
  2. Specify overrides (e.g., primary color, logo)
  3. Feature screens consume scoped theme
  4. When navigating away, scope disposed, base theme restored

Example:
  ThemeScopeProvider(
    overrides: {
      'colors.primary': featureBrandColor,
    },
    child: FeatureScreen(),
  )
```

### Pattern 5: Persistent Theme Preference

```
Flow:
  1. User selects theme in settings
  2. setTheme() called
  3. ThemeService applies theme
  4. ThemeRepository persists preference
  5. App restarts
  6. ThemeService.initialize() loads saved preference
  7. User sees their chosen theme on restart
```

---

## Troubleshooting

### Issue: Theme not persisting across app restarts

**Symptoms**: Theme resets to default on app restart

**Possible Causes**:
1. PersistenceAdapter not initialized before ThemeService
2. ThemeRepository.saveTheme() not being called
3. Persistence storage cleared by system/user

**Solutions**:
- Ensure PersistenceAdapter.initialize() awaited before ThemeService.initialize()
- Verify saveTheme() is called in setTheme() method
- Check storage permissions on device
- Test persistence: manually check storage (SharedPreferences/Hive) for saved keys

### Issue: UI not updating when theme changes

**Symptoms**: setTheme() called but UI doesn't update

**Possible Causes**:
1. Widgets not subscribed to theme stream
2. Using cached theme reference instead of current
3. Improper state management setup

**Solutions**:
- Verify ThemeObserver/Provider/Riverpod wrapping app
- Use stream/provider to access theme, not cached reference
- Check that notifyListeners() or stream emit is called
- Rebuild MaterialApp when theme changes (theme: buildMaterialTheme(tokens))

### Issue: Theme validation failing on custom themes

**Symptoms**: Custom theme rejected, validation errors

**Possible Causes**:
1. Contrast ratios below WCAG requirements
2. Missing required tokens
3. Invalid color values

**Solutions**:
- Check ValidationResult.errors for specific issues
- Use ThemeValidator.checkContrast() to test color pairs
- Ensure all required tokens present
- Use suggested fixes from validator
- Test with built-in presets first to rule out other issues

### Issue: Performance issues when switching themes

**Symptoms**: Lag or jank when changing theme

**Possible Causes**:
1. Entire app rebuilding unnecessarily
2. Heavy computations in build methods
3. Lack of const widgets

**Solutions**:
- Use Selector/BlocSelector for fine-grained updates
- Minimize rebuilds (only affected widgets should rebuild)
- Use const constructors where possible
- Profile rebuilds with Flutter DevTools
- Consider animating theme transition instead of instant switch

### Issue: Theme tokens not accessible in widget

**Symptoms**: Cannot access ThemeService.instance or tokens are null

**Possible Causes**:
1. ThemeService not initialized before accessing
2. Accessed before runApp()
3. State management provider not wrapping widget

**Solutions**:
- Ensure ThemeService.initialize() called and awaited in main()
- Access tokens only in widget build methods (after initialization)
- Verify provider wraps widget tree
- Check that widget is descendant of provider

---

## Next Steps

After integration:

1. Review [THEMING_GUIDE.md](THEMING_GUIDE.md) for component customization
2. Implement accessibility features from [ACCESSIBILITY_GUIDE.md](ACCESSIBILITY_GUIDE.md)
3. Add tests following [TESTING_GUIDE.md](TESTING_GUIDE.md)
4. Plan theme evolution with [MIGRATION_GUIDE.md](MIGRATION_GUIDE.md)

---

**Integration complete! Your app now has a robust, maintainable theming system.**
