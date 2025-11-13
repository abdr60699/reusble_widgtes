# Theming System Architecture

This document describes the complete architecture of the Flutter theming system, including all components, their responsibilities, and how they interact at runtime.

## Table of Contents

1. [High-Level Architecture](#high-level-architecture)
2. [Core Components](#core-components)
3. [Runtime Flows](#runtime-flows)
4. [Component Interactions](#component-interactions)
5. [Dependency Relationships](#dependency-relationships)
6. [State Management Integration](#state-management-integration)

## High-Level Architecture

### System Layers

```
┌───────────────────────────────────────────────────────────────────┐
│                         Presentation Layer                         │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────────────────┐│
│  │ Themed       │  │ Theme        │  │ Theme Settings           ││
│  │ Widgets      │  │ Switcher UI  │  │ Screen                   ││
│  │ (Button,     │  │ (IconButton) │  │ (Customize, Presets)     ││
│  │  Card, etc.) │  │              │  │                          ││
│  └──────────────┘  └──────────────┘  └──────────────────────────┘│
└───────────────────────────────────────────────────────────────────┘
                              │
                              │ consumes tokens
                              ▼
┌───────────────────────────────────────────────────────────────────┐
│                      Service/Business Layer                        │
│  ┌─────────────────────────────────────────────────────────────┐ │
│  │                      ThemeService                            │ │
│  │  • Singleton pattern                                        │ │
│  │  • Manages current AppTheme                                 │ │
│  │  • Exposes DesignTokens                                     │ │
│  │  • Emits theme change events                                │ │
│  │  • Validates theme changes                                  │ │
│  │  • Coordinates with ThemeRepository                         │ │
│  └─────────────────────────────────────────────────────────────┘ │
│         │                        │                         │      │
│         │                        │                         │      │
│  ┌──────▼──────────┐  ┌──────────▼──────────┐  ┌─────────▼──────┐│
│  │ ThemeRepository │  │ ThemeValidator      │  │ ThemePresets   ││
│  │ • Load/Save     │  │ • Contrast check    │  │ • Light        ││
│  │ • Persistence   │  │ • Completeness      │  │ • Dark         ││
│  │ • Conflict      │  │ • Accessibility     │  │ • High         ││
│  │   resolution    │  │   validation        │  │   Contrast     ││
│  └─────────────────┘  └─────────────────────┘  └────────────────┘│
└───────────────────────────────────────────────────────────────────┘
                              │
                              │ persists to
                              ▼
┌───────────────────────────────────────────────────────────────────┐
│                         Data/Persistence Layer                     │
│  ┌──────────────────┐  ┌──────────────────┐  ┌─────────────────┐ │
│  │ Persistence      │  │ SharedPreferences│  │ Hive / SQLite   │ │
│  │ Adapter          │  │ Implementation   │  │ Implementation  │ │
│  │ (Interface)      │  │                  │  │                 │ │
│  └──────────────────┘  └──────────────────┘  └─────────────────┘ │
└───────────────────────────────────────────────────────────────────┘
```

### Data Flow Diagram

```
User Action (Switch Theme)
    │
    ▼
┌─────────────────────┐
│  UI Widget          │  (e.g., theme switcher button)
│  calls setTheme()   │
└──────────┬──────────┘
           │
           ▼
┌─────────────────────────────────────────────────────────────┐
│                    ThemeService                             │
│  1. Validate new theme (via ThemeValidator)                 │
│  2. Load theme preset or custom theme                       │
│  3. Update internal _currentTheme                           │
│  4. Save preference (via ThemeRepository)                   │
│  5. Emit event on _themeStreamController                    │
└──────────┬──────────────────────────────────────────────────┘
           │
           ├──────────────────────┬───────────────────────────┐
           │                      │                           │
           ▼                      ▼                           ▼
┌────────────────────┐  ┌──────────────────┐  ┌──────────────────────┐
│ ThemeRepository    │  │ ThemeObserver    │  │ ThemeController      │
│ saves preference   │  │ receives stream  │  │ (if using state mgmt)│
└────────────────────┘  │ event, rebuilds  │  └──────────────────────┘
                        │ widget tree      │
                        └──────────────────┘
                                 │
                                 ▼
                        ┌──────────────────┐
                        │ UI Updates       │
                        │ with new tokens  │
                        └──────────────────┘
```

## Core Components

### 1. ThemeService

**Purpose**: Central theme manager, single source of truth for current theme state.

**Responsibilities**:
- Maintain current `AppTheme` instance
- Expose `DesignTokens` for widget consumption
- Handle theme switching requests
- Validate theme changes
- Emit theme change events via stream
- Coordinate with ThemeRepository for persistence
- Support theme mode switching (light/dark/system/custom)
- Manage custom accent color overlays
- Handle scoped theme overrides

**Properties**:
- `currentTheme`: AppTheme - Current active theme
- `tokens`: DesignTokens - Quick access to current theme's tokens
- `mode`: AppThemeMode - Current theme mode (light/dark/system/custom)
- `themeStream`: Stream<AppTheme> - Observable stream for theme changes

**Methods**:
- `initialize()`: Async initialization, loads saved preference
- `setTheme(AppThemeMode mode)`: Switch to light/dark/system
- `setCustomTheme(AppTheme theme)`: Apply fully custom theme
- `setCustomAccent(Color accent)`: Update accent color on current theme
- `resetToDefault()`: Restore default theme
- `getAvailablePresets()`: List of built-in theme presets
- `exportThemeConfig()`: Export current theme as JSON
- `importThemeConfig(String json)`: Import and validate theme from JSON

**Singleton Pattern**:
```
ThemeService has private constructor
Static instance property
Public static initialize() method
Access via ThemeService.instance
```

### 2. DesignTokens

**Purpose**: Immutable collection of all design tokens (colors, typography, spacing, etc.).

**Responsibilities**:
- Provide semantic access to all design values
- Ensure immutability (all tokens are final)
- Support equality comparison for rebuild optimization
- Generate from raw theme config or preset

**Structure**:
```
DesignTokens:
  - ColorTokens colors
  - TypographyTokens typography
  - SpacingTokens spacing
  - RadiiTokens radii
  - ElevationTokens elevations
  - IconTokens icons
  - MotionTokens motion
  - OpacityTokens opacity
```

**Token Categories**: See [DESIGN_TOKENS.md](DESIGN_TOKENS.md) for complete specifications.

### 3. AppTheme

**Purpose**: Complete theme configuration including tokens and metadata.

**Responsibilities**:
- Bundle all design tokens together
- Provide theme metadata (id, name, description, mode)
- Support serialization to/from JSON
- Enable theme comparison and diffing

**Properties**:
- `id`: String - Unique identifier (e.g., "light", "dark", "custom_123")
- `name`: String - Display name (e.g., "Light Theme", "Dark Theme")
- `description`: String - Optional description
- `mode`: AppThemeMode - Theme classification (light/dark/custom)
- `tokens`: DesignTokens - All design tokens
- `version`: int - Schema version for migration
- `createdAt`: DateTime - Creation timestamp
- `modifiedAt`: DateTime - Last modification timestamp
- `isBuiltIn`: bool - Whether this is a preset or custom theme

**Methods**:
- `copyWith({...})`: Create variant with specific token overrides
- `toJson()`: Serialize to JSON map
- `fromJson(Map json)`: Deserialize from JSON
- `merge(AppTheme other)`: Merge with another theme (for overrides)
- `validate()`: Check completeness and accessibility

### 4. ThemeRepository

**Purpose**: Manage loading and saving of theme preferences.

**Responsibilities**:
- Load saved theme preference on app start
- Save user theme selection
- Handle persistence failures gracefully
- Manage theme config versioning
- Resolve conflicts (if syncing across devices)
- Support theme backup and restore

**Properties**:
- `persistenceAdapter`: PersistenceAdapter - Storage implementation
- `defaultThemeId`: String - Fallback theme if none saved

**Methods**:
- `initialize()`: Setup persistence adapter
- `loadSavedTheme()`: Returns saved AppTheme or null
- `saveTheme(AppTheme theme)`: Persist theme preference
- `deleteSavedTheme()`: Clear saved preference
- `getSavedThemeId()`: Returns ID of saved theme
- `migrateThemeConfig(Map oldConfig, int oldVersion)`: Upgrade old configs

**Persistence Keys**:
- `theme_preference_id`: String - ID of selected theme
- `theme_custom_config`: String (JSON) - Serialized custom theme if applicable
- `theme_config_version`: int - Schema version

### 5. PersistenceAdapter

**Purpose**: Abstract interface for theme persistence, allows pluggable storage backends.

**Responsibilities**:
- Define contract for load/save operations
- Support different storage backends (SharedPreferences, Hive, SQLite, etc.)
- Handle storage errors gracefully

**Interface Methods**:
- `initialize()`: Setup storage backend
- `saveString(String key, String value)`: Save string value
- `getString(String key)`: Retrieve string value, returns null if not found
- `saveInt(String key, int value)`: Save integer value
- `getInt(String key)`: Retrieve integer value
- `delete(String key)`: Remove stored value
- `clear()`: Clear all theme-related data
- `exists(String key)`: Check if key exists

**Implementations**:
- `SharedPreferencesPersistenceAdapter`: Uses shared_preferences package
- `HivePersistenceAdapter`: Uses Hive for local storage
- `SecureStoragePersistenceAdapter`: Uses flutter_secure_storage for sensitive data
- `InMemoryPersistenceAdapter`: For testing, non-persistent

### 6. ThemeObserver

**Purpose**: Widget that listens to ThemeService and rebuilds on theme changes.

**Responsibilities**:
- Subscribe to ThemeService.themeStream
- Rebuild child widgets when theme changes
- Optimize rebuilds (only rebuild when theme actually changes)
- Unsubscribe when disposed

**Usage Pattern**:
```
ThemeObserver wraps the widget tree (or subtree)
Provides current DesignTokens to children
Similar to StreamBuilder but specialized for themes
Children access tokens via inherited widget or context

Example tree:
MaterialApp
  └─ ThemeObserver
      └─ Home Screen
          └─ Themed widgets access tokens
```

**Optimization**: Uses `distinct()` on stream to prevent unnecessary rebuilds if theme object is same instance.

### 7. ThemeController (for state management integration)

**Purpose**: Adapter for specific state management solutions (Provider, Riverpod, Bloc, GetIt).

**Responsibilities**:
- Wrap ThemeService for specific state management pattern
- Expose theme state in framework-specific way
- Handle framework-specific lifecycle (dispose, reset)

**Variants**:

**ThemeProvider** (for Provider package):
```
ChangeNotifier wrapper around ThemeService
notifyListeners() when theme changes
Provided at app root via ChangeNotifierProvider
Widgets access via Provider.of<ThemeProvider>(context) or Consumer
```

**ThemeNotifier** (for Riverpod):
```
StateNotifier<AppTheme> wrapper
expose theme as state
update state on theme changes
Widgets access via ref.watch(themeProvider)
```

**ThemeBloc** (for Bloc pattern):
```
Bloc<ThemeEvent, ThemeState> wrapper
Events: ThemeChanged, ThemeLoaded, ThemeReset
States: ThemeInitial, ThemeLoading, ThemeLoaded, ThemeError
Widgets use BlocBuilder<ThemeBloc, ThemeState>
```

**ThemeManager** (for GetIt/injectable):
```
Registered as singleton in GetIt container
Exposes ThemeService instance
Widgets access via GetIt.I<ThemeManager>()
```

### 8. ThemePresets

**Purpose**: Factory for built-in theme configurations.

**Responsibilities**:
- Provide standard light theme
- Provide standard dark theme
- Provide high-contrast theme
- Provide additional presets (Corporate, Soft Pastel, etc.)
- Ensure all presets meet accessibility standards

**Methods**:
- `light()`: Returns standard light theme
- `dark()`: Returns standard dark theme
- `highContrast()`: Returns high-contrast theme for accessibility
- `corporate()`: Returns professional/corporate theme
- `softPastel()`: Returns soft, low-saturation theme
- `all()`: Returns list of all available presets
- `findById(String id)`: Get preset by ID

**Preset IDs**:
- `light`: Default light theme
- `dark`: Default dark theme
- `high_contrast`: High contrast theme
- `corporate`: Professional theme
- `soft_pastel`: Soft colors theme
- Custom themes: `custom_{uuid}`

### 9. ThemeValidator

**Purpose**: Validate theme configurations for completeness and accessibility.

**Responsibilities**:
- Check contrast ratios between color pairs
- Validate all required tokens are present
- Ensure accessibility compliance (WCAG AA/AAA)
- Validate custom theme imports
- Check for color blindness accessibility

**Methods**:
- `validateTheme(AppTheme theme)`: Returns validation result with errors/warnings
- `checkContrast(Color foreground, Color background, WCAGLevel level)`: Check contrast ratio
- `validateColorPalette(ColorTokens colors)`: Ensure all required colors present
- `validateTypography(TypographyTokens typography)`: Ensure all text styles defined
- `validateAccessibility(AppTheme theme)`: Comprehensive accessibility check
- `suggestFixes(ValidationResult result)`: Provide automatic fix suggestions

**Validation Results**:
```
ValidationResult:
  - isValid: bool
  - errors: List<ValidationError> (blocking issues)
  - warnings: List<ValidationWarning> (non-blocking concerns)
  - suggestions: List<String> (improvement ideas)

ValidationError:
  - code: String (e.g., "CONTRAST_TOO_LOW")
  - message: String (e.g., "Primary color on background has ratio 2.1:1, needs 4.5:1")
  - field: String (e.g., "colors.primary")
  - suggestedFix: String? (optional auto-fix)
```

### 10. ThemeScopeProvider

**Purpose**: Provide scoped theme overrides for widget subtrees.

**Responsibilities**:
- Apply theme overrides to specific widget subtrees
- Merge overrides with base theme
- Dispose overrides when scope exits
- Support nested scopes with inheritance

**Usage Pattern**:
```
Base app theme: Light theme
Marketing screen needs custom branding:

ThemeScopeProvider(
  overrides: {
    colors.primary: customBrandColor,
    colors.accent: customAccentColor,
  },
  child: MarketingScreen(),
)

Child widgets in MarketingScreen see overridden colors
Other tokens (spacing, typography) inherit from base theme
When navigating away, overrides automatically cleared
```

**Properties**:
- `overrides`: Map<String, dynamic> - Token overrides
- `mergeStrategy`: MergeStrategy - How to combine with parent (replace/merge/overlay)

## Runtime Flows

### Application Initialization Flow

```
1. App Starts (main.dart)
   │
   ▼
2. Register DI Dependencies
   - Register PersistenceAdapter (e.g., SharedPreferencesPersistenceAdapter)
   - Register ThemeRepository with adapter
   - Register ThemeValidator
   - Register ThemeService (singleton)
   │
   ▼
3. Initialize ThemeService
   │
   ├─ 3a. Initialize ThemeRepository
   │   └─ Initialize PersistenceAdapter (await adapter.initialize())
   │
   ├─ 3b. Load Saved Theme Preference
   │   ├─ Check for saved theme ID (repository.getSavedThemeId())
   │   ├─ If found: Load theme config
   │   │   ├─ If built-in preset: Load from ThemePresets
   │   │   └─ If custom: Deserialize from saved JSON
   │   └─ If not found: Determine default
   │       ├─ Check system theme preference (light/dark)
   │       └─ Fallback to ThemePresets.light()
   │
   ├─ 3c. Validate Loaded Theme
   │   ├─ Run ThemeValidator.validateTheme()
   │   ├─ If validation fails: Fallback to safe default
   │   └─ If migration needed: Migrate to current schema version
   │
   └─ 3d. Set as Current Theme
       └─ Update _currentTheme, emit initial event
   │
   ▼
4. Build Widget Tree
   │
   ├─ Wrap with State Management Provider
   │   (Provider, Riverpod, Bloc, or direct ThemeObserver)
   │
   └─ Build MaterialApp
       └─ MaterialApp gets ThemeData from tokens
   │
   ▼
5. App Ready
   - First frame renders with correct theme
   - Theme changes propagate via stream
```

### Runtime Theme Switching Flow

```
1. User Interaction
   - User taps theme switcher button
   - UI calls: ThemeService.instance.setTheme(AppThemeMode.dark)
   │
   ▼
2. ThemeService.setTheme() Processing
   │
   ├─ 2a. Load New Theme
   │   ├─ If AppThemeMode.light: Get ThemePresets.light()
   │   ├─ If AppThemeMode.dark: Get ThemePresets.dark()
   │   ├─ If AppThemeMode.system: Detect system preference
   │   └─ If AppThemeMode.custom: Use current custom theme
   │
   ├─ 2b. Validate New Theme
   │   ├─ Run ThemeValidator.validateTheme(newTheme)
   │   ├─ If errors: Throw ValidationException or show error to user
   │   └─ If warnings: Log warnings, continue
   │
   ├─ 2c. Update Internal State
   │   ├─ Set _currentTheme = newTheme
   │   ├─ Set _currentMode = mode
   │   └─ Update _tokens reference
   │
   ├─ 2d. Persist Preference
   │   ├─ Call repository.saveTheme(newTheme)
   │   └─ Repository saves theme ID (and config if custom)
   │
   └─ 2e. Notify Observers
       ├─ Emit event on _themeStreamController.add(newTheme)
       └─ If using state management, call notifyListeners() or equivalent
   │
   ▼
3. Observer Response
   │
   ├─ ThemeObserver receives stream event
   ├─ Compares new theme with previous (structural equality)
   ├─ If different: Marks widget for rebuild
   └─ If same: Skips rebuild (optimization)
   │
   ▼
4. Widget Tree Rebuild
   │
   ├─ ThemeObserver rebuilds
   ├─ Provides new DesignTokens to children via InheritedWidget
   ├─ Child widgets read new tokens
   └─ UI updates with new colors, typography, spacing
   │
   ▼
5. Animation (optional)
   - Animate theme transition (color lerp)
   - Fade between themes
   - Duration: ~300ms
   │
   ▼
6. Complete
   - UI reflects new theme
   - User preference saved
   - Ready for next theme change
```

### Custom Accent Color Flow

```
1. User Selects Custom Color
   - Color picker dialog
   - User selects Color(0xFF6200EE)
   │
   ▼
2. Validate Color
   │
   ├─ 2a. Check Contrast with Background
   │   ├─ Get current background color
   │   ├─ Calculate contrast ratio (ThemeValidator.checkContrast())
   │   ├─ If ratio < 4.5:1: Show warning or auto-adjust
   │   └─ If ratio >= 4.5:1: Valid
   │
   └─ 2b. Check Against Other Colors
       └─ Ensure sufficient contrast with surface, error, etc.
   │
   ▼
3. Generate Theme Variant
   │
   ├─ Start with current theme
   ├─ Clone current theme: newTheme = currentTheme.copyWith()
   ├─ Update primary color
   ├─ Calculate derived colors:
   │   ├─ primaryVariant (darken/lighten primary by 10%)
   │   ├─ onPrimary (calculate contrasting text color)
   │   ├─ secondary (complementary or analogous color)
   │   └─ accent (use selected color or variant)
   │
   └─ Update all color dependencies
   │
   ▼
4. Apply Theme
   │
   ├─ Call ThemeService.instance.setCustomTheme(newTheme)
   ├─ Follow standard theme switching flow
   └─ Save as custom theme with unique ID
   │
   ▼
5. UI Updates
   - All widgets using primary color update
   - Buttons, AppBar, FloatingActionButton reflect new accent
```

### Scoped Theme Override Flow

```
1. Screen Needs Custom Styling
   - Example: Marketing splash with brand colors
   │
   ▼
2. Wrap with ThemeScopeProvider
   ```
   ThemeScopeProvider(
     overrides: {
       'colors.primary': Color(0xFFFF5722),
       'colors.background': Color(0xFF121212),
     },
     child: MarketingSplashScreen(),
   )
   ```
   │
   ▼
3. Scope Initialization
   │
   ├─ 3a. Get Parent Theme
   │   └─ Access ThemeService.instance.currentTheme
   │
   ├─ 3b. Merge Overrides
   │   ├─ Clone parent theme
   │   ├─ Apply overrides to cloned tokens
   │   └─ Validate merged theme (optional, based on strictness)
   │
   └─ 3c. Provide to Child
       └─ InheritedWidget provides scoped theme to subtree
   │
   ▼
4. Child Widgets Access Tokens
   │
   ├─ Widgets within MarketingSplashScreen access theme
   ├─ ThemeScopeProvider.of(context) returns scoped theme
   └─ Widgets render with overridden colors
   │
   ▼
5. Navigate Away
   │
   ├─ User leaves MarketingSplashScreen
   ├─ ThemeScopeProvider disposed
   └─ Next screen reverts to base theme automatically
   │
   ▼
6. Base Theme Restored
   - App continues with original theme
   - No persistence of scoped overrides
```

## Component Interactions

### ThemeService ↔ ThemeRepository

```
ThemeService depends on ThemeRepository for persistence.

On initialization:
  ThemeService → ThemeRepository.loadSavedTheme()
  ThemeRepository → PersistenceAdapter.getString('theme_preference_id')
  ThemeRepository ← Returns saved theme ID or null
  ThemeService ← Returns AppTheme or null

On theme change:
  ThemeService → ThemeRepository.saveTheme(newTheme)
  ThemeRepository → PersistenceAdapter.saveString('theme_preference_id', theme.id)
  ThemeRepository → PersistenceAdapter.saveString('theme_custom_config', theme.toJson()) if custom
  ThemeRepository ← Success or error
  ThemeService ← Confirmation
```

### ThemeService ↔ ThemeValidator

```
ThemeService uses ThemeValidator before applying themes.

On theme change:
  ThemeService → ThemeValidator.validateTheme(newTheme)
  ThemeValidator ← Returns ValidationResult
  ThemeService checks result.isValid
  If valid: Proceed with theme change
  If invalid: Throw error or show validation messages to user
```

### ThemeService → ThemeObserver/State Management

```
ThemeService emits events, observers react.

On theme change:
  ThemeService updates _currentTheme
  ThemeService calls _themeStreamController.add(newTheme)
  Stream emits event

  → ThemeObserver (if using raw stream):
      Receives event
      Rebuilds widget
      Provides new tokens to children

  → ThemeProvider (if using Provider):
      Listens to stream
      Calls notifyListeners()
      Consumers rebuild

  → ThemeNotifier (if using Riverpod):
      Listens to stream
      Updates state via state = newTheme
      Watchers rebuild

  → ThemeBloc (if using Bloc):
      Listens to stream
      Emits ThemeLoaded(newTheme) state
      BlocBuilders rebuild
```

### UI Widgets → ThemeService

```
Widgets read tokens from ThemeService.

Stateless approach:
  Widget build method
  → Access ThemeService.instance.tokens.colors.primary
  → Use in widget properties: color: primaryColor

State management approach (Provider example):
  Widget build method
  → final theme = Provider.of<ThemeProvider>(context)
  → final primaryColor = theme.tokens.colors.primary
  → Use in widget properties: color: primaryColor

InheritedWidget approach (via ThemeObserver):
  Widget build method
  → final tokens = ThemeObserver.of(context)
  → final primaryColor = tokens.colors.primary
  → Use in widget properties: color: primaryColor
```

## Dependency Relationships

### Dependency Graph

```
ThemeService (core)
  ├─ depends on → ThemeRepository
  │   └─ depends on → PersistenceAdapter (interface)
  │       ├─ implements → SharedPreferencesPersistenceAdapter
  │       ├─ implements → HivePersistenceAdapter
  │       └─ implements → InMemoryPersistenceAdapter
  │
  ├─ depends on → ThemeValidator
  │   └─ no dependencies (pure validation logic)
  │
  ├─ depends on → AppTheme (data model)
  │   └─ depends on → DesignTokens
  │       ├─ ColorTokens
  │       ├─ TypographyTokens
  │       ├─ SpacingTokens
  │       └─ etc.
  │
  └─ uses → ThemePresets (factory)
      └─ creates → AppTheme instances

ThemeObserver (UI integration)
  └─ depends on → ThemeService (reads stream, accesses tokens)

ThemeController variants (state management adapters)
  └─ depends on → ThemeService (wraps service for specific framework)

ThemeScopeProvider (scoped overrides)
  ├─ depends on → ThemeService (reads parent theme)
  └─ depends on → AppTheme (merges overrides)

UI Widgets (consumers)
  └─ depends on → ThemeService or ThemeController (reads tokens)
```

### Injection Order

For dependency injection (e.g., GetIt, injectable):

```
1. Register PersistenceAdapter (e.g., SharedPreferencesPersistenceAdapter)
   - Singleton
   - No dependencies

2. Register ThemeValidator
   - Singleton or factory
   - No dependencies

3. Register ThemePresets
   - Singleton or factory
   - No dependencies

4. Register ThemeRepository
   - Singleton
   - Depends on: PersistenceAdapter

5. Register ThemeService
   - Singleton
   - Depends on: ThemeRepository, ThemeValidator, ThemePresets
   - Call initialize() after registration

6. (Optional) Register ThemeController variant
   - Singleton
   - Depends on: ThemeService

7. Provide to widget tree
   - Wrap app with ThemeObserver or state management provider
   - Pass ThemeService or ThemeController instance
```

## State Management Integration

### Provider Integration

```
Setup:
1. Create ThemeProvider extends ChangeNotifier
2. Inject ThemeService into ThemeProvider
3. Listen to ThemeService.themeStream
4. On stream event, call notifyListeners()
5. Expose tokens via getter: get tokens => _themeService.tokens
6. Wrap MaterialApp with ChangeNotifierProvider<ThemeProvider>

Usage in widgets:
  Provider.of<ThemeProvider>(context).tokens.colors.primary
  or
  Consumer<ThemeProvider>(
    builder: (context, themeProvider, child) {
      return Container(color: themeProvider.tokens.colors.surface);
    },
  )

Optimization:
  Use Provider.of<ThemeProvider>(context, listen: false) for one-time reads
  Use Selector for fine-grained rebuilds:
    Selector<ThemeProvider, Color>(
      selector: (context, provider) => provider.tokens.colors.primary,
      builder: (context, primaryColor, child) => ...,
    )
```

### Riverpod Integration

```
Setup:
1. Create StateNotifier<AppTheme>
2. Inject ThemeService
3. Listen to ThemeService.themeStream
4. On stream event, update state: state = newTheme
5. Expose provider: final themeProvider = StateNotifierProvider(...)
6. Wrap MaterialApp with ProviderScope

Usage in widgets:
  Consumer(
    builder: (context, ref, child) {
      final theme = ref.watch(themeProvider);
      return Container(color: theme.tokens.colors.surface);
    },
  )

Optimization:
  Use ref.watch(themeProvider.select((theme) => theme.tokens.colors.primary))
  for fine-grained updates
```

### Bloc Integration

```
Setup:
1. Create ThemeBloc extends Bloc<ThemeEvent, ThemeState>
2. Inject ThemeService
3. Listen to ThemeService.themeStream in bloc
4. On stream event, emit ThemeLoaded(newTheme)
5. Wrap MaterialApp with BlocProvider<ThemeBloc>

Events:
  - ThemeLoadRequested: Initial load
  - ThemeChangeRequested(AppThemeMode mode): User changes theme
  - ThemeCustomAccentRequested(Color accent): User picks accent

States:
  - ThemeInitial: Before load
  - ThemeLoading: Loading saved theme
  - ThemeLoaded(AppTheme theme): Theme ready
  - ThemeError(String message): Failed to load/apply theme

Usage in widgets:
  BlocBuilder<ThemeBloc, ThemeState>(
    builder: (context, state) {
      if (state is ThemeLoaded) {
        return Container(color: state.theme.tokens.colors.surface);
      }
      return CircularProgressIndicator();
    },
  )
```

### GetIt Integration

```
Setup:
1. Register all dependencies in GetIt container (see Injection Order above)
2. No specific wrapper needed for widgets
3. Access directly: GetIt.I<ThemeService>()

Usage in widgets:
  final themeService = GetIt.I<ThemeService>();
  final primaryColor = themeService.tokens.colors.primary;

For reactive updates:
  Option 1: Use ValueListenableBuilder with ValueNotifier wrapper
  Option 2: Combine with Provider/Riverpod for reactivity
  Option 3: Use StreamBuilder with themeService.themeStream
```

## Summary

This architecture provides:

- **Clear separation of concerns**: Service layer, data layer, UI layer
- **Pluggable persistence**: Abstract adapter pattern
- **Framework agnostic**: Works with any state management solution
- **Type safety**: Strong typing throughout
- **Testability**: All components have clear interfaces and dependencies
- **Performance**: Fine-grained rebuilds, token memoization
- **Extensibility**: Easy to add new presets, tokens, or validators

See other documentation files for detailed API contracts, token specifications, and integration guides.
