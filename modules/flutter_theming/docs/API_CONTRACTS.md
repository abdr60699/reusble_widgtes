# API Contracts and Surface

This document provides detailed API specifications for all services, components, and interfaces in the theming system. All descriptions are in plain English with expected behavior, inputs, outputs, events, and error cases.

## Table of Contents

1. [ThemeService API](#themeservice-api)
2. [DesignTokens API](#designtokens-api)
3. [AppTheme API](#apptheme-api)
4. [ThemeRepository API](#themerepository-api)
5. [PersistenceAdapter API](#persistenceadapter-api)
6. [ThemeValidator API](#themevalidator-api)
7. [ThemePresets API](#themepresets-api)
8. [ThemeObserver API](#themeobserver-api)
9. [ThemeScopeProvider API](#themescopeprovider-api)
10. [Enums and Constants](#enums-and-constants)

---

## ThemeService API

### Overview

The `ThemeService` is the central singleton managing all theme operations. It is the primary interface for reading current theme state and switching themes.

### Static Properties

#### `instance` → ThemeService
- **Description**: Singleton instance of ThemeService
- **Returns**: The initialized ThemeService instance
- **Throws**: Error if accessed before initialize() is called
- **Usage**: `ThemeService.instance.tokens.colors.primary`

### Static Methods

#### `initialize({ThemeRepository, ThemeValidator, ThemePresets})` → Future<ThemeService>
- **Description**: Initializes the ThemeService singleton with dependencies
- **Parameters**:
  - `repository`: ThemeRepository instance for persistence
  - `validator`: ThemeValidator instance for validation
  - `presets`: ThemePresets instance for built-in themes
- **Returns**: Future<ThemeService> - Initialized service ready to use
- **Side Effects**:
  - Loads saved theme preference from repository
  - If saved theme found, validates and applies it
  - If no saved theme, determines default (system or light)
  - Sets up theme stream
  - Prepares service for use
- **Errors**:
  - Throws `ThemeInitializationException` if initialization fails
  - Logs warnings if saved theme is invalid (falls back to default)
- **Example Flow**:
  ```
  1. Call ThemeService.initialize(repo, validator, presets)
  2. Service loads saved theme ID from repository
  3. If ID is "dark", loads ThemePresets.dark()
  4. Validates theme
  5. Sets as current theme
  6. Returns service instance
  7. Access via ThemeService.instance
  ```

### Instance Properties

#### `currentTheme` → AppTheme
- **Description**: The currently active theme
- **Returns**: AppTheme instance with all tokens and metadata
- **Immutable**: Yes (returns copy)
- **Updates**: Changes when setTheme() or related methods are called

#### `tokens` → DesignTokens
- **Description**: Quick access to current theme's design tokens
- **Returns**: DesignTokens from currentTheme
- **Usage**: Preferred way to access colors, typography, spacing, etc.
- **Example**: `ThemeService.instance.tokens.colors.primary`

#### `mode` → AppThemeMode
- **Description**: Current theme mode (light/dark/system/custom)
- **Returns**: AppThemeMode enum value
- **Updates**: Changes when theme mode changes

#### `themeStream` → Stream<AppTheme>
- **Description**: Observable stream emitting theme change events
- **Returns**: Broadcast stream of AppTheme
- **Events**: Emits new AppTheme whenever theme changes
- **Usage**: Listen for theme updates to rebuild UI
- **Example**: `ThemeService.instance.themeStream.listen((theme) => print(theme.name))`

#### `isSystemThemeFollowed` → bool
- **Description**: Whether currently following system theme (light/dark)
- **Returns**: true if mode is AppThemeMode.system, false otherwise

### Instance Methods

#### `setTheme(AppThemeMode mode)` → Future<void>
- **Description**: Switches to a built-in theme mode (light/dark/system)
- **Parameters**:
  - `mode`: AppThemeMode - The theme mode to activate
- **Behavior**:
  1. Loads theme based on mode:
     - `AppThemeMode.light`: Loads ThemePresets.light()
     - `AppThemeMode.dark`: Loads ThemePresets.dark()
     - `AppThemeMode.system`: Detects system preference, loads matching theme
     - `AppThemeMode.custom`: No-op (use setCustomTheme instead)
  2. Validates new theme via ThemeValidator
  3. If valid, updates currentTheme
  4. Saves preference via ThemeRepository
  5. Emits event on themeStream
  6. Notifies state management (if integrated)
- **Returns**: Future<void> - Completes when theme is applied and saved
- **Errors**:
  - Throws `ThemeValidationException` if theme fails validation
  - Throws `ThemePersistenceException` if save fails (non-critical, logs warning)
- **Side Effects**: UI rebuilds via stream observers

#### `setCustomTheme(AppTheme theme)` → Future<void>
- **Description**: Applies a fully custom theme
- **Parameters**:
  - `theme`: AppTheme - The custom theme to apply
- **Behavior**:
  1. Validates theme (contrast, completeness, accessibility)
  2. If valid, sets as current theme
  3. Saves theme config as JSON via repository
  4. Sets mode to AppThemeMode.custom
  5. Emits event on themeStream
- **Returns**: Future<void>
- **Errors**:
  - Throws `ThemeValidationException` if validation fails with errors
  - Logs warnings if validation has non-blocking issues
- **Usage**: For user-created themes or imported themes

#### `setCustomAccent(Color accent)` → Future<void>
- **Description**: Updates the accent/primary color on current theme
- **Parameters**:
  - `accent`: Color - The new accent color
- **Behavior**:
  1. Validates accent color against current background (contrast check)
  2. Creates variant of current theme with new accent
  3. Calculates derived colors:
     - primary = accent
     - primaryVariant = darken(accent, 10%)
     - onPrimary = contrasting text color (white or black)
     - secondary = complementary or analogous to accent
  4. Validates updated theme
  5. Applies updated theme via setCustomTheme()
- **Returns**: Future<void>
- **Errors**:
  - Throws `ContrastException` if accent fails contrast requirements
  - Suggests adjusted color if validation fails
- **Usage**: For apps allowing user color customization

#### `setThemePreset(String presetId)` → Future<void>
- **Description**: Applies a theme preset by ID
- **Parameters**:
  - `presetId`: String - ID of preset (e.g., "dark", "high_contrast", "corporate")
- **Behavior**:
  1. Looks up preset in ThemePresets
  2. If found, applies via setCustomTheme()
  3. If not found, throws error
- **Returns**: Future<void>
- **Errors**:
  - Throws `PresetNotFoundException` if preset ID invalid

#### `resetToDefault()` → Future<void>
- **Description**: Resets theme to default (system theme or light)
- **Parameters**: None
- **Behavior**:
  1. Clears saved theme preference
  2. Determines default theme (follow system or light)
  3. Applies default theme
- **Returns**: Future<void>
- **Side Effects**: Deletes saved preference from persistence

#### `getAvailablePresets()` → List<AppTheme>
- **Description**: Returns all available built-in theme presets
- **Parameters**: None
- **Returns**: List<AppTheme> - All presets (light, dark, high-contrast, etc.)
- **Usage**: For displaying theme picker UI

#### `exportThemeConfig()` → String
- **Description**: Exports current theme as JSON string
- **Parameters**: None
- **Returns**: String - JSON representation of current theme
- **Usage**: For theme backup, sharing, or migration
- **Format**: Valid JSON matching AppTheme schema

#### `importThemeConfig(String json)` → Future<void>
- **Description**: Imports and applies theme from JSON string
- **Parameters**:
  - `json`: String - JSON theme configuration
- **Behavior**:
  1. Parses JSON string
  2. Validates schema version
  3. Migrates if necessary (old schema → new schema)
  4. Deserializes to AppTheme
  5. Validates theme (contrast, completeness)
  6. If valid, applies via setCustomTheme()
- **Returns**: Future<void>
- **Errors**:
  - Throws `InvalidJsonException` if JSON malformed
  - Throws `SchemaVersionException` if version incompatible
  - Throws `ThemeValidationException` if theme invalid

#### `dispose()` → void
- **Description**: Cleans up resources (closes stream, removes listeners)
- **Parameters**: None
- **Returns**: void
- **Usage**: Call when app is shutting down (rare)

---

## DesignTokens API

### Overview

`DesignTokens` is an immutable collection of all design tokens. It groups tokens by category and provides semantic access to design values.

### Properties

#### `colors` → ColorTokens
- **Description**: All color tokens
- **Returns**: ColorTokens instance with primary, background, error, etc.

#### `typography` → TypographyTokens
- **Description**: All typography/text style tokens
- **Returns**: TypographyTokens instance with h1, h2, body1, button, etc.

#### `spacing` → SpacingTokens
- **Description**: All spacing/padding/margin values
- **Returns**: SpacingTokens instance with xs, sm, md, lg, xl, xxl

#### `radii` → RadiiTokens
- **Description**: All border radius values
- **Returns**: RadiiTokens instance with none, sm, md, lg, circle

#### `elevations` → ElevationTokens
- **Description**: All elevation/shadow values
- **Returns**: ElevationTokens instance with none, low, medium, high

#### `icons` → IconTokens
- **Description**: Icon sizing and styling tokens
- **Returns**: IconTokens instance with sizes (sm, md, lg) and default color

#### `motion` → MotionTokens
- **Description**: Animation duration and curve tokens
- **Returns**: MotionTokens instance with durations and curves

#### `opacity` → OpacityTokens
- **Description**: Standard opacity values
- **Returns**: OpacityTokens instance with transparent, subtle, medium, opaque

### Methods

#### `copyWith({...})` → DesignTokens
- **Description**: Creates copy with specific token overrides
- **Parameters**: Named parameters for each token category (optional)
- **Returns**: New DesignTokens instance with overrides applied
- **Usage**: For creating theme variants

#### `toJson()` → Map<String, dynamic>
- **Description**: Serializes tokens to JSON map
- **Returns**: JSON-serializable map of all tokens
- **Usage**: For exporting theme configs

#### `fromJson(Map json)` → DesignTokens (static)
- **Description**: Deserializes tokens from JSON
- **Parameters**: `json` - JSON map of tokens
- **Returns**: DesignTokens instance
- **Errors**: Throws `JsonFormatException` if structure invalid

---

## ColorTokens API

### Overview

`ColorTokens` contains all color values used in the theme. Follows Material Design color system with semantic naming.

### Primary Colors

#### `primary` → Color
- **Description**: Primary brand color, used for main UI elements
- **Usage**: Buttons, AppBar, FloatingActionButton, active states
- **Contrast**: Must have 4.5:1 ratio with `onPrimary`

#### `onPrimary` → Color
- **Description**: Text/icon color for content on primary color
- **Usage**: Text on primary buttons, AppBar icons/text
- **Contrast**: White or black, chosen for best contrast with `primary`

#### `primaryVariant` → Color
- **Description**: Variant of primary color (darker or lighter shade)
- **Usage**: Hover states, pressed states, gradients

#### `secondary` → Color
- **Description**: Secondary brand color, accents
- **Usage**: Secondary buttons, FAB variants, highlights

#### `onSecondary` → Color
- **Description**: Text/icon color for content on secondary color
- **Contrast**: Must have 4.5:1 ratio with `secondary`

### Surface Colors

#### `background` → Color
- **Description**: App background color
- **Usage**: Scaffold background, screen backgrounds

#### `onBackground` → Color
- **Description**: Text/icon color for content on background
- **Usage**: Body text, icons on main background

#### `surface` → Color
- **Description**: Surface color for cards, sheets, menus
- **Usage**: Card backgrounds, dialog backgrounds, bottom sheets

#### `onSurface` → Color
- **Description**: Text/icon color for content on surfaces
- **Usage**: Text in cards, dialog text

### Semantic Colors

#### `error` → Color
- **Description**: Error state color
- **Usage**: Error messages, validation errors, destructive actions
- **Typical Value**: Red (#F44336 or similar)

#### `onError` → Color
- **Description**: Text/icon color for content on error color
- **Contrast**: White or black for readability

#### `success` → Color
- **Description**: Success state color
- **Usage**: Success messages, confirmation states
- **Typical Value**: Green (#4CAF50 or similar)

#### `warning` → Color
- **Description**: Warning state color
- **Usage**: Warning messages, caution states
- **Typical Value**: Orange/Amber (#FF9800 or similar)

#### `info` → Color
- **Description**: Informational state color
- **Usage**: Info messages, hints
- **Typical Value**: Blue (#2196F3 or similar)

### Neutral Colors

#### `neutrals` → NeutralPalette
- **Description**: Grayscale palette for borders, dividers, disabled states
- **Properties**:
  - `n50`: Very light gray (almost white)
  - `n100`: Light gray
  - `n200`: Lighter gray
  - `n300`: Light-medium gray
  - `n400`: Medium gray
  - `n500`: True gray
  - `n600`: Medium-dark gray
  - `n700`: Darker gray
  - `n800`: Dark gray
  - `n900`: Very dark gray (almost black)
- **Usage**: Borders, dividers, disabled text, shadows

### Additional Semantic Colors

#### `link` → Color
- **Description**: Color for hyperlinks
- **Typical Value**: Blue (#1976D2 or similar)

#### `visited` → Color
- **Description**: Color for visited links
- **Typical Value**: Purple (#9C27B0 or similar)

#### `disabled` → Color
- **Description**: Color for disabled elements
- **Typical Value**: Neutral gray with reduced opacity

---

## TypographyTokens API

### Overview

`TypographyTokens` contains all text styles with font family, size, weight, line height, and letter spacing.

### Text Style Properties

Each text style has:
- `fontFamily`: String - Font family name
- `fontSize`: double - Size in logical pixels
- `fontWeight`: FontWeight - Weight (normal, bold, etc.)
- `lineHeight`: double - Line height multiplier
- `letterSpacing`: double - Letter spacing in logical pixels
- `color`: Color? - Default text color (optional, often from ColorTokens.onBackground)

### Display Styles (Large Headers)

#### `display1` → TextStyle
- **Usage**: Extra large display text, hero headers
- **Typical Size**: 96px, light weight

#### `display2` → TextStyle
- **Usage**: Large display text
- **Typical Size**: 60px, light weight

#### `display3` → TextStyle
- **Usage**: Medium display text
- **Typical Size**: 48px, regular weight

### Headline Styles

#### `h1` → TextStyle
- **Usage**: Page titles, main headers
- **Typical Size**: 34px, regular weight

#### `h2` → TextStyle
- **Usage**: Section headers
- **Typical Size**: 24px, regular weight

#### `h3` → TextStyle
- **Usage**: Subsection headers
- **Typical Size**: 20px, medium weight

#### `h4` → TextStyle
- **Usage**: Small headers
- **Typical Size**: 16px, medium weight

#### `h5` → TextStyle
- **Usage**: Very small headers, list headers
- **Typical Size**: 14px, medium weight

#### `h6` → TextStyle
- **Usage**: Tiny headers
- **Typical Size**: 12px, medium weight

### Body Styles

#### `body1` → TextStyle
- **Usage**: Primary body text, paragraphs
- **Typical Size**: 16px, regular weight, 1.5 line height

#### `body2` → TextStyle
- **Usage**: Secondary body text, less prominent
- **Typical Size**: 14px, regular weight

### Supporting Styles

#### `subtitle1` → TextStyle
- **Usage**: Subtitles, secondary headers
- **Typical Size**: 16px, medium weight

#### `subtitle2` → TextStyle
- **Usage**: Smaller subtitles
- **Typical Size**: 14px, medium weight

#### `button` → TextStyle
- **Usage**: Button text
- **Typical Size**: 14px, medium/bold weight, uppercase letter-spacing

#### `caption` → TextStyle
- **Usage**: Captions, helper text, image credits
- **Typical Size**: 12px, regular weight

#### `overline` → TextStyle
- **Usage**: Overline text, labels, metadata
- **Typical Size**: 10px, medium weight, uppercase

---

## SpacingTokens API

### Overview

`SpacingTokens` provides consistent spacing values for padding, margins, and gaps.

### Spacing Scale

#### `xs` → double
- **Value**: 4.0 logical pixels
- **Usage**: Tight spacing, small gaps

#### `sm` → double
- **Value**: 8.0 logical pixels
- **Usage**: Small spacing, compact layouts

#### `md` → double
- **Value**: 16.0 logical pixels
- **Usage**: Standard spacing, most common

#### `lg` → double
- **Value**: 24.0 logical pixels
- **Usage**: Large spacing, visual separation

#### `xl` → double
- **Value**: 32.0 logical pixels
- **Usage**: Extra large spacing, major sections

#### `xxl` → double
- **Value**: 48.0 logical pixels
- **Usage**: Maximum spacing, wide gutters

### Semantic Spacing

#### `contentPadding` → double
- **Description**: Standard padding for content containers
- **Value**: Typically `md` (16.0)

#### `screenMargin` → double
- **Description**: Margin around screen edges
- **Value**: Typically `md` or `lg` (16.0 or 24.0)

#### `cardPadding` → double
- **Description**: Internal padding for cards
- **Value**: Typically `md` (16.0)

---

## RadiiTokens API

### Overview

`RadiiTokens` provides border radius values for rounded corners.

### Radius Scale

#### `none` → double
- **Value**: 0.0 - No rounding, sharp corners

#### `sm` → double
- **Value**: 4.0 - Small rounded corners

#### `md` → double
- **Value**: 8.0 - Standard rounded corners

#### `lg` → double
- **Value**: 16.0 - Large rounded corners

#### `xl` → double
- **Value**: 24.0 - Extra large rounded corners

#### `circle` → double
- **Value**: 9999.0 - Full circular shape

### Semantic Radii

#### `buttonRadius` → double
- **Description**: Border radius for buttons
- **Value**: Typically `md` (8.0)

#### `cardRadius` → double
- **Description**: Border radius for cards
- **Value**: Typically `md` or `lg` (8.0 or 16.0)

#### `dialogRadius` → double
- **Description**: Border radius for dialogs
- **Value**: Typically `lg` (16.0)

---

## ElevationTokens API

### Overview

`ElevationTokens` provides shadow/elevation values for layered UI.

### Elevation Scale

#### `none` → double
- **Value**: 0.0 - No elevation, flat

#### `low` → double
- **Value**: 2.0 - Subtle elevation, hover states

#### `medium` → double
- **Value**: 4.0 - Standard elevation, cards

#### `high` → double
- **Value**: 8.0 - High elevation, dialogs, menus

#### `veryHigh` → double
- **Value**: 16.0 - Maximum elevation, modals

---

## AppTheme API

### Overview

`AppTheme` represents a complete theme configuration with tokens and metadata.

### Properties

#### `id` → String
- **Description**: Unique identifier for theme
- **Format**: Lowercase with underscores (e.g., "light", "dark", "custom_abc123")
- **Uniqueness**: Must be unique across all themes

#### `name` → String
- **Description**: Human-readable theme name
- **Example**: "Light Theme", "Dark Mode", "High Contrast"

#### `description` → String?
- **Description**: Optional detailed description
- **Usage**: Displayed in theme picker UI

#### `mode` → AppThemeMode
- **Description**: Theme classification
- **Values**: light, dark, custom
- **Usage**: Determines default behaviors

#### `tokens` → DesignTokens
- **Description**: All design tokens for this theme
- **Immutable**: Yes

#### `version` → int
- **Description**: Schema version for migration
- **Current**: 1
- **Usage**: Ensures compatibility across app updates

#### `createdAt` → DateTime
- **Description**: Timestamp of theme creation

#### `modifiedAt` → DateTime
- **Description**: Timestamp of last modification

#### `isBuiltIn` → bool
- **Description**: Whether this is a preset or custom theme
- **Usage**: Prevents modification of built-in themes

### Methods

#### `copyWith({...})` → AppTheme
- **Description**: Create variant with specific overrides
- **Parameters**: Named parameters for all properties (optional)
- **Returns**: New AppTheme instance
- **Usage**: For creating themed variants

#### `toJson()` → Map<String, dynamic>
- **Description**: Serialize to JSON
- **Returns**: JSON map representing theme
- **Usage**: For export and persistence

#### `fromJson(Map json)` → AppTheme (static)
- **Description**: Deserialize from JSON
- **Parameters**: `json` - Theme JSON map
- **Returns**: AppTheme instance
- **Errors**: Throws if JSON invalid

#### `validate()` → ValidationResult
- **Description**: Validates theme completeness and accessibility
- **Returns**: ValidationResult with errors/warnings
- **Usage**: Call before saving custom theme

#### `merge(AppTheme other)` → AppTheme
- **Description**: Merge with another theme (for overrides)
- **Parameters**: `other` - Theme to merge
- **Returns**: New theme with merged tokens
- **Usage**: For scoped overrides

---

## ThemeRepository API

### Overview

`ThemeRepository` handles loading and saving theme preferences via persistence adapter.

### Methods

#### `initialize()` → Future<void>
- **Description**: Initialize repository and persistence adapter
- **Side Effects**: Calls adapter.initialize()

#### `loadSavedTheme()` → Future<AppTheme?>
- **Description**: Load previously saved theme
- **Returns**: AppTheme if saved, null if none
- **Behavior**:
  1. Get saved theme ID from persistence
  2. If ID is built-in preset, load from ThemePresets
  3. If ID is custom, load JSON config and deserialize
  4. Return theme or null

#### `saveTheme(AppTheme theme)` → Future<void>
- **Description**: Save theme preference
- **Parameters**: `theme` - Theme to save
- **Behavior**:
  1. Save theme ID
  2. If custom theme, save JSON config
  3. Update timestamp

#### `deleteSavedTheme()` → Future<void>
- **Description**: Delete saved theme preference
- **Side Effects**: Clears all theme-related keys from persistence

#### `getSavedThemeId()` → Future<String?>
- **Description**: Get ID of saved theme without loading full config
- **Returns**: Theme ID string or null

---

## PersistenceAdapter API

### Overview

Abstract interface for persistence. Implementations handle actual storage.

### Methods

#### `initialize()` → Future<void>
- **Description**: Initialize storage backend

#### `saveString(String key, String value)` → Future<void>
- **Description**: Save string value

#### `getString(String key)` → Future<String?>
- **Description**: Retrieve string value, returns null if not found

#### `saveInt(String key, int value)` → Future<void>
- **Description**: Save integer value

#### `getInt(String key)` → Future<int?>
- **Description**: Retrieve integer value

#### `delete(String key)` → Future<void>
- **Description**: Remove value

#### `clear()` → Future<void>
- **Description**: Clear all data

#### `exists(String key)` → Future<bool>
- **Description**: Check if key exists

---

## ThemeValidator API

### Methods

#### `validateTheme(AppTheme theme)` → ValidationResult
- **Description**: Comprehensive theme validation
- **Checks**:
  - All required tokens present
  - Contrast ratios meet WCAG AA/AAA
  - Colors are valid
  - Typography is complete
- **Returns**: ValidationResult with errors/warnings

#### `checkContrast(Color fg, Color bg, WCAGLevel level)` → bool
- **Description**: Check if contrast meets WCAG requirements
- **Parameters**:
  - `fg`: Foreground color
  - `bg`: Background color
  - `level`: WCAGLevel.AA (4.5:1) or WCAGLevel.AAA (7:1)
- **Returns**: true if meets requirement

---

## ThemePresets API

### Methods

#### `light()` → AppTheme (static)
- **Description**: Default light theme

#### `dark()` → AppTheme (static)
- **Description**: Default dark theme

#### `highContrast()` → AppTheme (static)
- **Description**: High contrast theme for accessibility

#### `corporate()` → AppTheme (static)
- **Description**: Professional/corporate theme

#### `softPastel()` → AppTheme (static)
- **Description**: Soft, low-saturation theme

#### `all()` → List<AppTheme> (static)
- **Description**: All available presets

#### `findById(String id)` → AppTheme? (static)
- **Description**: Find preset by ID

---

## Enums and Constants

### AppThemeMode

```
enum AppThemeMode {
  light,    // Light theme
  dark,     // Dark theme
  system,   // Follow system theme
  custom,   // Custom user theme
}
```

### WCAGLevel

```
enum WCAGLevel {
  AA,   // 4.5:1 contrast ratio
  AAA,  // 7:1 contrast ratio
}
```

This completes the API contracts documentation.
