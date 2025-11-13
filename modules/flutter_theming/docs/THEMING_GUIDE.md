# Theming Guide

Component theming, customization, and extension patterns.

## Table of Contents

1. [Theming Core Components](#theming-core-components)
2. [Custom Component Theming](#custom-component-theming)
3. [Scoped Themes](#scoped-themes)
4. [Third-Party Widget Integration](#third-party-widget-integration)
5. [Creating Theme Presets](#creating-theme-presets)
6. [Theme Extensions](#theme-extensions)

---

## Theming Core Components

### AppBar Theming

**Tokens Used**:
- `colors.surface` - Background
- `colors.onSurface` - Text/icons
- `elevations.low` - Elevation
- `typography.h2` - Title text

**Implementation**:
```
AppBar(
  backgroundColor: tokens.colors.surface,
  foregroundColor: tokens.colors.onSurface,
  elevation: tokens.elevations.low,
  titleTextStyle: TextStyle(
    fontSize: tokens.typography.h2.fontSize,
    fontWeight: tokens.typography.h2.fontWeight,
    color: tokens.colors.onSurface,
  ),
)
```

### Button Theming

**Elevated Button**:
- Background: `colors.primary`
- Foreground: `colors.onPrimary`
- Padding: `spacing.sm` vertical, `spacing.md` horizontal
- Border Radius: `radii.buttonRadius`
- Elevation: `elevations.low`

**Text Button**:
- Foreground: `colors.primary`
- No background
- Padding: same as elevated

**Outlined Button**:
- Border: `colors.outline`
- Foreground: `colors.primary`
- No background

### Input Field Theming

**TextField/TextFormField**:
- Fill Color: `colors.surfaceVariant`
- Border: `colors.outline`
- Text: `typography.body1`
- Label: `typography.caption`
- Error: `colors.error`
- Padding: `spacing.inputPadding`
- Border Radius: `radii.inputRadius`

### Card Theming

**Card**:
- Background: `colors.surface`
- Elevation: `elevations.medium`
- Border Radius: `radii.cardRadius`
- Content Padding: `spacing.cardPadding`

### Dialog Theming

**AlertDialog/Dialog**:
- Background: `colors.surface`
- Border Radius: `radii.dialogRadius`
- Elevation: `elevations.high`
- Title: `typography.h3`
- Content: `typography.body1`
- Actions: Themed buttons

### BottomSheet Theming

**BottomSheet/ModalBottomSheet**:
- Background: `colors.surface`
- Top Corners Radius: `radii.sheetRadius`
- Elevation: `elevations.veryHigh`
- Handle: `colors.onSurfaceVariant` with `opacity.medium`

### Snackbar Theming

**SnackBar**:
- Background: `colors.inverseSurface`
- Text: `colors.inverseOnSurface`
- Action: `colors.primary` or `colors.inversePrimary`
- Elevation: `elevations.high`

---

## Custom Component Theming

### Building Themed Widgets

**Example: ThemedCard**

```
Class: ThemedCard extends StatelessWidget

Properties:
  - child: Widget
  - onTap: VoidCallback?
  - elevation: double? (optional override)

Build:
  final tokens = ThemeService.instance.tokens;

  return Material(
    color: tokens.colors.surface,
    elevation: elevation ?? tokens.elevations.medium,
    borderRadius: BorderRadius.circular(tokens.radii.cardRadius),
    child: InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(tokens.radii.cardRadius),
      child: Padding(
        padding: EdgeInsets.all(tokens.spacing.cardPadding),
        child: child,
      ),
    ),
  );
```

**Example: ThemedButton**

```
Enum: ButtonVariant { primary, secondary, outlined, text }

Class: ThemedButton extends StatelessWidget

Properties:
  - label: String
  - onPressed: VoidCallback?
  - variant: ButtonVariant
  - icon: IconData?

Build:
  final tokens = ThemeService.instance.tokens;

  switch (variant) {
    case ButtonVariant.primary:
      return ElevatedButton.icon(
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
        icon: icon != null ? Icon(icon) : null,
        label: Text(label),
        onPressed: onPressed,
      );

    case ButtonVariant.outlined:
      // Similar with OutlinedButton
    // etc.
  }
```

### Component Theme Classes

Create reusable theme configurations for component families:

**ButtonThemeConfig**:
```
Class: ButtonThemeConfig

Properties:
  - backgroundColor: Color
  - foregroundColor: Color
  - borderColor: Color?
  - padding: EdgeInsets
  - borderRadius: double
  - elevation: double
  - textStyle: TextStyle

Static Factory Methods:
  - primary(DesignTokens tokens) → ButtonThemeConfig
  - secondary(DesignTokens tokens) → ButtonThemeConfig
  - outlined(DesignTokens tokens) → ButtonThemeConfig
  - text(DesignTokens tokens) → ButtonThemeConfig
```

Usage:
```
final buttonTheme = ButtonThemeConfig.primary(tokens);

ElevatedButton(
  style: ElevatedButton.styleFrom(
    backgroundColor: buttonTheme.backgroundColor,
    foregroundColor: buttonTheme.foregroundColor,
    padding: buttonTheme.padding,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(buttonTheme.borderRadius),
    ),
  ),
  child: Text(label),
)
```

---

## Scoped Themes

### ThemeScopeProvider Implementation

**Purpose**: Override specific tokens for widget subtrees

**Use Cases**:
- Feature-specific branding
- Marketing screens with custom colors
- Third-party module integration
- A/B testing variants
- Per-tenant customization

**Implementation Concept**:

```
Class: ThemeScopeProvider extends InheritedWidget

Properties:
  - overrides: Map<String, dynamic>
  - mergeStrategy: MergeStrategy (replace, merge, overlay)
  - parent: AppTheme (inherited from ThemeService)
  - child: Widget

Constructor:
  1. Get parent theme from ThemeService or parent ThemeScopeProvider
  2. Merge overrides with parent theme
  3. Create scopedTheme

Static Method: of(BuildContext context) → AppTheme
  Returns nearest scoped theme or root theme

Build:
  return _InheritedTheme(
    theme: scopedTheme,
    child: child,
  );
```

**Usage Example**:

```
// Root app uses default theme

ThemeScopeProvider(
  overrides: {
    'colors.primary': Color(0xFFFF5722),  // Custom orange
    'colors.background': Color(0xFF121212),  // Dark background
  },
  child: MarketingSplashScreen(),
)

// Inside MarketingSplashScreen:
final theme = ThemeScopeProvider.of(context);
// theme.tokens.colors.primary returns custom orange
// theme.tokens.spacing.md still returns root theme value
```

### Nested Scopes

Scopes can be nested, each inheriting from parent:

```
Root Theme (Light)
└─ Scope 1 (overrides primary color)
    └─ Scope 2 (overrides background)
        └─ Widget sees: custom primary + custom background + root everything else
```

**Merge Strategies**:

1. **Replace**: Override completely replaces parent value
2. **Merge**: Deep merge (for complex objects like typography)
3. **Overlay**: Overlay with opacity/blend

---

## Third-Party Widget Integration

### Widgets Accepting ThemeData

Many third-party packages accept Flutter's `ThemeData`. Map tokens to ThemeData:

```
ThemeData buildThemeData(DesignTokens tokens) {
  return ThemeData(
    primaryColor: tokens.colors.primary,
    scaffoldBackgroundColor: tokens.colors.background,
    textTheme: TextTheme(
      bodyLarge: TextStyle(
        fontSize: tokens.typography.body1.fontSize,
        color: tokens.colors.onBackground,
      ),
    ),
    // etc.
  );
}

// Use with third-party widget:
ThirdPartyWidget(
  theme: buildThemeData(ThemeService.instance.tokens),
)
```

### Widgets Requiring Explicit Styles

For widgets needing explicit style props:

```
// Example: flutter_markdown
MarkdownBody(
  data: markdownText,
  styleSheet: MarkdownStyleSheet(
    h1: TextStyle(
      fontSize: tokens.typography.h1.fontSize,
      fontWeight: tokens.typography.h1.fontWeight,
      color: tokens.colors.onBackground,
    ),
    p: TextStyle(
      fontSize: tokens.typography.body1.fontSize,
      color: tokens.colors.onBackground,
    ),
    code: TextStyle(
      fontFamily: tokens.typography.monospaceFontFamily,
      backgroundColor: tokens.colors.surfaceVariant,
      color: tokens.colors.onSurfaceVariant,
    ),
    blockquoteBorder: tokens.colors.primary,
    // etc.
  ),
)
```

### Creating Wrapper Widgets

For frequently used third-party widgets, create themed wrappers:

```
Class: ThemedMarkdown extends StatelessWidget

Properties:
  - data: String
  - customStyles: MarkdownStyleSheet? (optional overrides)

Build:
  final tokens = ThemeService.instance.tokens;

  return MarkdownBody(
    data: data,
    styleSheet: customStyles ?? _buildDefaultStyleSheet(tokens),
  );

Static _buildDefaultStyleSheet(tokens):
  return MarkdownStyleSheet(
    // Map all tokens
  );
```

---

## Creating Theme Presets

### Define New Preset

**Steps**:

1. **Choose Color Palette**:
   - Define primary, secondary, background, surface colors
   - Ensure WCAG AA contrast compliance
   - Test in light and dark variants

2. **Create Tokens**:
```
Static Method in ThemePresets:

corporate() → AppTheme:
  return AppTheme(
    id: 'corporate',
    name: 'Corporate Theme',
    description: 'Professional theme for business apps',
    mode: AppThemeMode.light,
    tokens: DesignTokens(
      colors: ColorTokens(
        primary: Color(0xFF1565C0),  // Deep blue
        onPrimary: Color(0xFFFFFFFF),
        secondary: Color(0xFF546E7A),  // Blue gray
        onSecondary: Color(0xFFFFFFFF),
        background: Color(0xFFFAFAFA),
        onBackground: Color(0xFF212121),
        surface: Color(0xFFFFFFFF),
        onSurface: Color(0xFF212121),
        error: Color(0xFFD32F2F),
        // ... all required colors
      ),
      typography: TypographyTokens(
        primaryFontFamily: 'Open Sans',  // Professional font
        h1: TextStyle(fontSize: 32, fontWeight: FontWeight.w600),
        // ... all typography tokens
      ),
      spacing: SpacingTokens(/* standard spacing */),
      radii: RadiiTokens(
        buttonRadius: 4.0,  // Less rounded, more formal
        cardRadius: 8.0,
        // ...
      ),
      // ... all other tokens
    ),
    version: 1,
    createdAt: DateTime.now(),
    modifiedAt: DateTime.now(),
    isBuiltIn: true,
  );
```

3. **Validate Preset**:
```
final preset = ThemePresets.corporate();
final validation = ThemeValidator().validateTheme(preset);

if (!validation.isValid) {
  // Fix errors
}
```

4. **Add to Presets List**:
```
Update ThemePresets.all():
  return [
    light(),
    dark(),
    highContrast(),
    corporate(),  // Add new preset
  ];
```

5. **Test Preset**:
   - Visual testing: Review in app
   - Contrast testing: Validate all color pairs
   - Accessibility testing: Test with screen readers, font scaling

### Dark Variant of Preset

Create dark version with adjusted colors:

```
corporateDark() → AppTheme:
  // Use same structure but with dark-appropriate colors
  primary: Color(0xFF90CAF9),  // Lighter blue for dark theme
  background: Color(0xFF121212),  // Dark background
  surface: Color(0xFF1E1E1E),
  // Adjust all colors for dark theme
```

---

## Theme Extensions

### Custom Token Categories

Add app-specific token categories beyond the standard set:

**Example: Brand Tokens**

```
Class: BrandTokens

Properties:
  - logo: String (asset path)
  - logoColor: Color
  - accentGradient: Gradient
  - featureColor: Color

Add to DesignTokens:
  brand: BrandTokens(
    logo: 'assets/logo.png',
    logoColor: primary,
    accentGradient: LinearGradient(
      colors: [primary, secondaryVariant],
    ),
    featureColor: secondary,
  )

Usage:
  Image.asset(tokens.brand.logo)
  Container(gradient: tokens.brand.accentGradient)
```

### Component-Specific Tokens

For complex apps, create component-specific token sets:

**Example: ChartTokens**

```
Class: ChartTokens

Properties:
  - primaryDataColor: Color
  - secondaryDataColor: Color
  - gridColor: Color
  - labelTextStyle: TextStyle
  - axisColor: Color

Factory: fromDesignTokens(DesignTokens tokens)
  primaryDataColor = tokens.colors.primary
  secondaryDataColor = tokens.colors.secondary
  gridColor = tokens.colors.outline
  etc.

Usage:
  final chartTokens = ChartTokens.fromDesignTokens(tokens);
  // Use in chart widgets
```

### Per-Module Themes

Large apps with multiple modules may need per-module themes:

**Implementation**:
```
Each module defines:
  - ModuleThemeConfig (extends DesignTokens with module-specific tokens)
  - Module provides scoped theme via ThemeScopeProvider
  - Module components consume scoped theme

Example:
  modules/
    shopping/
      lib/
        theme/
          shopping_theme.dart  // Shopping-specific tokens
        widgets/
          product_card.dart  // Uses shopping theme
```

---

## Summary

**Key Takeaways**:

1. **Component Theming**: Use tokens consistently for all components
2. **Custom Components**: Build reusable themed widgets consuming tokens
3. **Scoped Themes**: Override tokens for specific widget subtrees
4. **Third-Party Integration**: Map tokens to third-party widget APIs
5. **Presets**: Create validated theme presets for different use cases
6. **Extensions**: Add custom token categories for app-specific needs

For production apps, create a library of themed components that your team reuses throughout the app, ensuring visual consistency and easy theme updates.
