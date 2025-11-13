# Design Tokens Specification

This document provides the complete catalog of design tokens, their purposes, recommended values, and usage guidelines. Design tokens are the atomic design decisions that define your visual language.

## Table of Contents

1. [Token Philosophy](#token-philosophy)
2. [Color Tokens](#color-tokens)
3. [Typography Tokens](#typography-tokens)
4. [Spacing Tokens](#spacing-tokens)
5. [Radii Tokens](#radii-tokens)
6. [Elevation Tokens](#elevation-tokens)
7. [Icon Tokens](#icon-tokens)
8. [Motion Tokens](#motion-tokens)
9. [Opacity Tokens](#opacity-tokens)
10. [Semantic vs Raw Tokens](#semantic-vs-raw-tokens)
11. [Token Mapping](#token-mapping)
12. [Light vs Dark Themes](#light-vs-dark-themes)
13. [Dynamic Color Support](#dynamic-color-support)

---

## Token Philosophy

### Design Principles

1. **Semantic Naming**: Tokens describe purpose, not appearance
   - Good: `colors.primary`, `spacing.contentPadding`
   - Bad: `colors.blue`, `spacing.sixteen`

2. **Consistency**: Use tokens for all design decisions, avoid hard-coded values
   - Use: `padding: tokens.spacing.md`
   - Avoid: `padding: 16.0`

3. **Maintainability**: Changing a token value updates everywhere it's used
   - Update `colors.primary` once → all buttons, AppBars, links update

4. **Accessibility**: All tokens consider accessibility (contrast, readability, touch targets)

5. **Scalability**: Token system grows with app (add new tokens without breaking existing)

### Token Hierarchy

```
Raw Palette Tokens (Foundation)
  ↓
Semantic Tokens (Meaning)
  ↓
Component Tokens (Usage)
```

**Example**:
```
Raw: blue500 = #2196F3
Semantic: primary = blue500
Component: buttonBackground = primary
```

This allows changing brand color (blue → green) by updating one token, cascading everywhere.

---

## Color Tokens

### Color Categories

1. **Brand Colors**: Primary, secondary branding
2. **Surface Colors**: Backgrounds, surfaces, cards
3. **Semantic Colors**: Error, success, warning, info
4. **Neutral Colors**: Grays for borders, dividers, disabled states
5. **Interactive Colors**: Links, focus, hover states

### Brand Colors

#### Primary Color System

| Token | Purpose | Light Value | Dark Value | Usage |
|-------|---------|-------------|------------|-------|
| `primary` | Main brand color | #6200EE (Purple) | #BB86FC (Light Purple) | Buttons, AppBar, FAB, active states |
| `onPrimary` | Text on primary | #FFFFFF (White) | #000000 (Black) | Button text, AppBar text/icons |
| `primaryVariant` | Primary shade | #3700B3 (Dark Purple) | #3700B3 (Dark Purple) | Pressed states, gradients |
| `primaryContainer` | Primary surface | #F3E5FF (Tint) | #4A148C (Tone) | Chips, selection highlights |
| `onPrimaryContainer` | Text on container | #21005E (Dark) | #E0B0FF (Light) | Text in primary containers |

#### Secondary Color System

| Token | Purpose | Light Value | Dark Value | Usage |
|-------|---------|-------------|------------|-------|
| `secondary` | Accent color | #03DAC6 (Teal) | #03DAC6 (Teal) | Secondary buttons, highlights |
| `onSecondary` | Text on secondary | #000000 (Black) | #000000 (Black) | Text on secondary buttons |
| `secondaryVariant` | Secondary shade | #018786 (Dark Teal) | #03DAC6 (Teal) | Hover, pressed states |
| `secondaryContainer` | Secondary surface | #B2FFF7 (Tint) | #005047 (Tone) | Secondary chips |
| `onSecondaryContainer` | Text on container | #00201D (Dark) | #70FFF5 (Light) | Text in secondary containers |

### Surface Colors

| Token | Purpose | Light Value | Dark Value | Contrast Requirement |
|-------|---------|-------------|------------|---------------------|
| `background` | App background | #FFFFFF (White) | #121212 (Almost Black) | Base surface |
| `onBackground` | Text on background | #000000 (Black) | #FFFFFF (White) | 4.5:1 with background |
| `surface` | Card/sheet background | #FFFFFF (White) | #1E1E1E (Dark Gray) | Elevated above background |
| `onSurface` | Text on surface | #000000 (Black) | #FFFFFF (White) | 4.5:1 with surface |
| `surfaceVariant` | Alternative surface | #F5F5F5 (Light Gray) | #2C2C2C (Gray) | Subtle differentiation |
| `onSurfaceVariant` | Text on variant | #49454F (Dark Gray) | #CAC4D0 (Light Gray) | 4.5:1 with variant |
| `inverseSurface` | Inverse surface | #313033 (Dark) | #E6E1E5 (Light) | For tooltips, snackbars |
| `inverseOnSurface` | Text on inverse | #F4EFF4 (Light) | #313033 (Dark) | High contrast inverse |

### Semantic Colors

#### Error States

| Token | Purpose | Light Value | Dark Value | Usage |
|-------|---------|-------------|------------|-------|
| `error` | Error color | #B00020 (Red) | #CF6679 (Pink) | Error messages, validation |
| `onError` | Text on error | #FFFFFF (White) | #000000 (Black) | Error button text |
| `errorContainer` | Error surface | #FDEAED (Light Pink) | #93000A (Dark Red) | Error backgrounds |
| `onErrorContainer` | Text in container | #410002 (Dark) | #FFDAD6 (Light) | Error text in containers |

#### Success States

| Token | Purpose | Light Value | Dark Value | Usage |
|-------|---------|-------------|------------|-------|
| `success` | Success color | #4CAF50 (Green) | #81C784 (Light Green) | Success messages, confirmations |
| `onSuccess` | Text on success | #FFFFFF (White) | #000000 (Black) | Success button text |
| `successContainer` | Success surface | #E8F5E9 (Light Green) | #1B5E20 (Dark Green) | Success backgrounds |
| `onSuccessContainer` | Text in container | #1B5E20 (Dark) | #A5D6A7 (Light) | Success text |

#### Warning States

| Token | Purpose | Light Value | Dark Value | Usage |
|-------|---------|-------------|------------|-------|
| `warning` | Warning color | #FF9800 (Orange) | #FFB74D (Light Orange) | Warning messages, caution |
| `onWarning` | Text on warning | #000000 (Black) | #000000 (Black) | Warning button text |
| `warningContainer` | Warning surface | #FFF3E0 (Light Orange) | #E65100 (Dark Orange) | Warning backgrounds |
| `onWarningContainer` | Text in container | #E65100 (Dark) | #FFCCBC (Light) | Warning text |

#### Info States

| Token | Purpose | Light Value | Dark Value | Usage |
|-------|---------|-------------|------------|-------|
| `info` | Info color | #2196F3 (Blue) | #64B5F6 (Light Blue) | Info messages, hints |
| `onInfo` | Text on info | #FFFFFF (White) | #000000 (Black) | Info button text |
| `infoContainer` | Info surface | #E3F2FD (Light Blue) | #0D47A1 (Dark Blue) | Info backgrounds |
| `onInfoContainer` | Text in container | #0D47A1 (Dark) | #90CAF9 (Light) | Info text |

### Neutral Colors (Grayscale)

| Token | Purpose | Light Value | Dark Value | Usage |
|-------|---------|-------------|------------|-------|
| `neutral50` | Lightest gray | #FAFAFA | #0A0A0A | Very subtle backgrounds |
| `neutral100` | Very light gray | #F5F5F5 | #141414 | Subtle backgrounds |
| `neutral200` | Light gray | #EEEEEE | #1E1E1E | Borders, dividers (light) |
| `neutral300` | Light-medium gray | #E0E0E0 | #2C2C2C | Borders, inactive states |
| `neutral400` | Medium-light gray | #BDBDBD | #3F3F3F | Placeholder text |
| `neutral500` | True gray | #9E9E9E | #666666 | Secondary text, icons |
| `neutral600` | Medium-dark gray | #757575 | #8C8C8C | Primary text (light mode) |
| `neutral700` | Dark gray | #616161 | #A3A3A3| Emphasis text |
| `neutral800` | Darker gray | #424242 | #CCCCCC | High emphasis text |
| `neutral900` | Darkest gray | #212121 | #E5E5E5 | Maximum contrast text |

### Interactive Colors

| Token | Purpose | Light Value | Dark Value | Usage |
|-------|---------|-------------|------------|-------|
| `link` | Hyperlinks | #1976D2 (Blue) | #90CAF9 (Light Blue) | Text links, navigation |
| `linkVisited` | Visited links | #9C27B0 (Purple) | #CE93D8 (Light Purple) | Visited link states |
| `linkHover` | Link hover state | #1565C0 (Dark Blue) | #64B5F6 (Lighter Blue) | Link hover effect |
| `focus` | Focus indicator | #6200EE (Primary) | #BB86FC (Light Primary) | Focus rings, outlines |
| `hover` | Hover overlay | rgba(0,0,0,0.04) | rgba(255,255,255,0.08) | Hover state overlay |
| `pressed` | Pressed overlay | rgba(0,0,0,0.12) | rgba(255,255,255,0.16) | Pressed state overlay |
| `dragged` | Drag overlay | rgba(0,0,0,0.08) | rgba(255,255,255,0.12) | Dragged element overlay |
| `disabled` | Disabled state | rgba(0,0,0,0.38) | rgba(255,255,255,0.38) | Disabled text, icons |

### Overlay Colors

| Token | Purpose | Light Value | Dark Value | Usage |
|-------|---------|-------------|------------|-------|
| `scrim` | Modal scrim | rgba(0,0,0,0.5) | rgba(0,0,0,0.7) | Behind dialogs, drawers |
| `shadow` | Shadows | rgba(0,0,0,0.2) | rgba(0,0,0,0.4) | Drop shadows |
| `outline` | Outlines | #79747E | #938F99 | Borders, dividers |
| `outlineVariant` | Subtle outline | #CAC4D0 | #49454F | Subtle borders |

---

## Typography Tokens

### Typography Scale

Based on Material Design typography scale with semantic naming.

| Token | Size (sp) | Weight | Line Height | Letter Spacing | Usage |
|-------|-----------|--------|-------------|----------------|-------|
| `display1` | 96 | Light (300) | 1.0 | -1.5 | Extra large display, hero text |
| `display2` | 60 | Light (300) | 1.0 | -0.5 | Large display headers |
| `display3` | 48 | Regular (400) | 1.0 | 0 | Medium display headers |
| `h1` | 34 | Regular (400) | 1.235 | 0.25 | Page titles |
| `h2` | 24 | Regular (400) | 1.334 | 0 | Section headers |
| `h3` | 20 | Medium (500) | 1.4 | 0.15 | Subsection headers |
| `h4` | 16 | Medium (500) | 1.5 | 0.15 | Small headers |
| `h5` | 14 | Medium (500) | 1.57 | 0.1 | List headers |
| `h6` | 12 | Medium (500) | 1.667 | 0.1 | Tiny headers |
| `subtitle1` | 16 | Medium (500) | 1.75 | 0.15 | Subtitles, secondary headers |
| `subtitle2` | 14 | Medium (500) | 1.57 | 0.1 | Smaller subtitles |
| `body1` | 16 | Regular (400) | 1.5 | 0.5 | Primary body text, paragraphs |
| `body2` | 14 | Regular (400) | 1.43 | 0.25 | Secondary body text |
| `button` | 14 | Medium (500) | 1.14 | 1.25 | Button labels (uppercase) |
| `caption` | 12 | Regular (400) | 1.33 | 0.4 | Captions, helper text |
| `overline` | 10 | Medium (500) | 1.6 | 1.5 | Overlines, labels (uppercase) |

### Font Families

#### Primary Font Family

| Token | Value | Usage |
|-------|-------|-------|
| `primaryFontFamily` | 'Roboto', sans-serif | Primary text, UI elements |
| `displayFontFamily` | 'Roboto', sans-serif | Display/headline text |
| `monospaceFontFamily` | 'Roboto Mono', monospace | Code, numbers, tabular data |

#### Font Fallbacks

Provide fallback fonts for different platforms:

```
Primary: 'Roboto', -apple-system, BlinkMacSystemFont, 'Segoe UI', 'Helvetica Neue', Arial, sans-serif

Monospace: 'Roboto Mono', 'SF Mono', Monaco, 'Cascadia Code', 'Courier New', monospace
```

#### Localization Font Families

| Language | Font Family | Token |
|----------|-------------|-------|
| Arabic | 'Noto Sans Arabic' | `arabicFontFamily` |
| Chinese (Simplified) | 'Noto Sans SC' | `chineseSimplifiedFontFamily` |
| Chinese (Traditional) | 'Noto Sans TC' | `chineseTraditionalFontFamily` |
| Japanese | 'Noto Sans JP' | `japaneseFontFamily` |
| Korean | 'Noto Sans KR' | `koreanFontFamily` |
| Hebrew | 'Noto Sans Hebrew' | `hebrewFontFamily` |
| Thai | 'Noto Sans Thai' | `thaiFontFamily` |

---

## Spacing Tokens

### Spacing Scale (8pt Grid)

Based on 8-point grid system for consistency.

| Token | Value (px) | Rem | Usage |
|-------|------------|-----|-------|
| `xs` | 4 | 0.25rem | Tight spacing, small gaps, icon padding |
| `sm` | 8 | 0.5rem | Small spacing, compact layouts |
| `md` | 16 | 1rem | Standard spacing, default gaps |
| `lg` | 24 | 1.5rem | Large spacing, section gaps |
| `xl` | 32 | 2rem | Extra large spacing, major sections |
| `xxl` | 48 | 3rem | Maximum spacing, wide gutters |
| `xxxl` | 64 | 4rem | Huge spacing, hero sections |

### Semantic Spacing

| Token | Value | Usage |
|-------|-------|-------|
| `contentPadding` | md (16) | Standard content padding |
| `screenMargin` | md (16) or lg (24) | Edge margins for screens |
| `cardPadding` | md (16) | Internal card padding |
| `listItemPadding` | md (16) | List item internal padding |
| `sectionGap` | xl (32) | Gap between major sections |
| `componentGap` | md (16) | Gap between related components |
| `inputPadding` | sm (8) or md (16) | Input field padding |
| `buttonPadding` | sm (8) horizontal, md (16) vertical | Button padding |

### Layout Spacing

| Token | Value | Usage |
|-------|-------|-------|
| `gridGap` | md (16) | Gap in grid layouts |
| `columnGap` | lg (24) | Gap between columns |
| `rowGap` | md (16) | Gap between rows |
| `containerMaxWidth` | 1200px | Max width for content containers |
| `contentMaxWidth` | 800px | Max width for readable content |

---

## Radii Tokens

### Border Radius Scale

| Token | Value (px) | Usage |
|-------|------------|-------|
| `none` | 0 | Sharp corners, no rounding |
| `xs` | 2 | Very subtle rounding |
| `sm` | 4 | Small rounded corners, chips |
| `md` | 8 | Standard rounded corners, buttons |
| `lg` | 16 | Large rounded corners, cards |
| `xl` | 24 | Extra large rounding, dialogs |
| `xxl` | 32 | Maximum rounding |
| `circle` | 9999 (or 50%) | Full circular shape, avatars |

### Semantic Radii

| Token | Value | Usage |
|-------|-------|-------|
| `buttonRadius` | md (8) | Button border radius |
| `cardRadius` | lg (16) | Card border radius |
| `dialogRadius` | lg (16) | Dialog border radius |
| `inputRadius` | sm (4) | Input field border radius |
| `chipRadius` | circle | Chip/tag border radius |
| `avatarRadius` | circle | Avatar border radius |
| `imageRadius` | md (8) | Image border radius |
| `sheetRadius` | xl (24) | Bottom sheet top corners |

---

## Elevation Tokens

### Elevation Scale (Material Design)

Elevation creates depth through shadows.

| Token | Value (dp) | Shadow Description | Usage |
|-------|------------|-------------------|-------|
| `none` | 0 | No shadow | Flat elements, backgrounds |
| `low` | 2 | Subtle shadow, slight lift | Hover states, subtle elevation |
| `medium` | 4 | Standard shadow | Cards, sheets |
| `high` | 8 | Prominent shadow | Dialogs, dropdowns, menus |
| `veryHigh` | 16 | Strong shadow | Modals, floating action button |
| `maximum` | 24 | Maximum shadow | Maximum emphasis |

### Shadow Definitions

Each elevation level has corresponding shadow values (Material Design shadow formula):

```
Elevation 2:
  Shadow 1: 0px 1px 2px rgba(0, 0, 0, 0.3)
  Shadow 2: 0px 1px 3px rgba(0, 0, 0, 0.15)

Elevation 4:
  Shadow 1: 0px 2px 4px rgba(0, 0, 0, 0.3)
  Shadow 2: 0px 1px 5px rgba(0, 0, 0, 0.15)

Elevation 8:
  Shadow 1: 0px 4px 8px rgba(0, 0, 0, 0.3)
  Shadow 2: 0px 2px 10px rgba(0, 0, 0, 0.15)

Elevation 16:
  Shadow 1: 0px 8px 16px rgba(0, 0, 0, 0.3)
  Shadow 2: 0px 4px 20px rgba(0, 0, 0, 0.15)

Elevation 24:
  Shadow 1: 0px 12px 24px rgba(0, 0, 0, 0.3)
  Shadow 2: 0px 6px 30px rgba(0, 0, 0, 0.15)
```

Dark mode elevations use lighter shadows or surface tinting instead of pure shadows.

---

## Icon Tokens

### Icon Sizes

| Token | Value (px) | Usage |
|-------|------------|-------|
| `iconXs` | 16 | Extra small icons, inline with text |
| `iconSm` | 20 | Small icons, compact UI |
| `iconMd` | 24 | Standard icons, most common |
| `iconLg` | 32 | Large icons, emphasis |
| `iconXl` | 48 | Extra large icons, hero icons |
| `iconXxl` | 64 | Maximum icon size |

### Icon Colors

| Token | Value | Usage |
|-------|-------|-------|
| `iconPrimary` | onSurface | Primary icon color |
| `iconSecondary` | onSurface (60% opacity) | Secondary icon color |
| `iconDisabled` | disabled | Disabled icon color |
| `iconOnPrimary` | onPrimary | Icon color on primary surfaces |
| `iconOnError` | onError | Icon color on error surfaces |

---

## Motion Tokens

### Duration Tokens

Animation durations for different interactions.

| Token | Value (ms) | Usage |
|-------|-----------|-------|
| `durationInstant` | 0 | No animation, instant change |
| `durationFastest` | 100 | Very quick transitions, micro-interactions |
| `durationFast` | 200 | Fast transitions, hover effects |
| `durationMedium` | 300 | Standard transitions, most animations |
| `durationSlow` | 500 | Slow transitions, page transitions |
| `durationSlower` | 700 | Very slow transitions, emphasis |
| `durationSlowest` | 1000 | Maximum duration |

### Easing Curves

Animation timing functions.

| Token | Curve | Usage |
|-------|-------|-------|
| `easeStandard` | cubic-bezier(0.4, 0.0, 0.2, 1) | Standard easing, most animations |
| `easeDecelerate` | cubic-bezier(0.0, 0.0, 0.2, 1) | Elements entering screen |
| `easeAccelerate` | cubic-bezier(0.4, 0.0, 1, 1) | Elements leaving screen |
| `easeEmphasized` | cubic-bezier(0.2, 0.0, 0, 1) | Emphasized motion, important changes |
| `easeLinear` | linear | Linear motion, progress indicators |

### Motion Preferences

| Token | Value | Usage |
|-------|-------|-------|
| `prefersReducedMotion` | true/false | User prefers reduced motion (accessibility) |
| `reducedDuration` | durationFast (200ms) | Duration when reduced motion enabled |

---

## Opacity Tokens

### Opacity Scale

| Token | Value | Usage |
|-------|-------|-------|
| `opacityTransparent` | 0.0 | Fully transparent, invisible |
| `opacitySubtle` | 0.12 | Very subtle overlay, hover states |
| `opacityLight` | 0.24 | Light overlay, disabled states |
| `opacityMedium` | 0.38 | Medium overlay, secondary text |
| `opacityHigh` | 0.60 | High visibility, dimmed content |
| `opacityAlmostOpaque` | 0.87 | Almost fully visible, primary text |
| `opacityOpaque` | 1.0 | Fully opaque, no transparency |

### Semantic Opacity

| Token | Value | Usage |
|-------|-------|-------|
| `disabledOpacity` | 0.38 | Disabled elements |
| `secondaryTextOpacity` | 0.60 | Secondary text on surfaces |
| `dividerOpacity` | 0.12 | Dividers, borders |
| `hoverOpacity` | 0.04 | Hover state overlay |
| `pressedOpacity` | 0.12 | Pressed state overlay |

---

## Semantic vs Raw Tokens

### Raw Palette Tokens

Raw tokens are the foundation - actual color values:

```
Raw palette:
  blue100 = #BBDEFB
  blue500 = #2196F3
  blue700 = #1976D2
  green500 = #4CAF50
  red500 = #F44336
```

### Semantic Tokens

Semantic tokens have meaning and purpose:

```
Semantic tokens (mapped from raw):
  primary = blue500
  primaryVariant = blue700
  success = green500
  error = red500
```

### Benefits of Semantic Tokens

1. **Rebrand easily**: Change raw values, semantic meaning remains
2. **Clarity**: Understand purpose from name
3. **Consistency**: Use same token for same purpose everywhere
4. **Theme variants**: Light/dark map to different raw values

### Token Mapping Example

```
Light Theme:
  background = neutral50 (#FAFAFA)
  onBackground = neutral900 (#212121)
  surface = neutral0 (#FFFFFF)
  onSurface = neutral900 (#212121)

Dark Theme:
  background = neutral900 (#121212)
  onBackground = neutral50 (#FAFAFA)
  surface = neutral800 (#1E1E1E)
  onSurface = neutral50 (#FAFAFA)
```

Same semantic token (`background`) maps to different raw values in each theme.

---

## Light vs Dark Themes

### Color Strategy

**Light Theme**:
- Background: Light colors (white, light gray)
- Text: Dark colors (black, dark gray)
- Primary: Medium-dark saturated colors
- Surfaces: White or very light gray

**Dark Theme**:
- Background: Dark colors (near-black)
- Text: Light colors (white, light gray)
- Primary: Medium-light desaturated colors
- Surfaces: Elevated dark grays (not pure black)

### Contrast Requirements

**Light Theme**:
- Text on background: 4.5:1 minimum (WCAG AA)
- Large text: 3:1 minimum
- UI components: 3:1 minimum

**Dark Theme**:
- Same requirements but with light text on dark backgrounds
- Avoid pure black (#000000) - use #121212 or similar
- Use surface elevation tinting for depth (lighter grays for elevated surfaces)

### Material Design Dark Theme Principles

1. **Depth with Elevation**: Higher surfaces are lighter
   ```
   Background: #121212
   Surface 1dp: #1E1E1E
   Surface 2dp: #232323
   Surface 4dp: #272727
   Surface 8dp: #2C2C2C
   ```

2. **Desaturated Colors**: Reduce color saturation for less eye strain
   ```
   Light primary: #6200EE (saturated purple)
   Dark primary: #BB86FC (desaturated lighter purple)
   ```

3. **Limited High Brightness**: Avoid pure white text, use #FFFFFF at 87% opacity

---

## Dynamic Color Support

### Material You / Dynamic Color

Material 3 supports dynamic color generation from user's wallpaper (Android 12+).

#### Dynamic Color Flow

1. **Extract Colors**: System extracts color palette from wallpaper
2. **Generate Scheme**: System generates complete color scheme (primary, secondary, etc.)
3. **Apply to App**: App uses generated colors via ThemeService

#### Implementation Strategy

**Option 1: Full Dynamic**
- Use system-generated colors entirely
- Provides maximum personalization
- May not align with brand

**Option 2: Hybrid**
- Use dynamic colors for accents
- Keep brand colors for primary
- Balance personalization and branding

**Option 3: Opt-Out**
- Use static brand colors
- Ignore system dynamic colors
- Full brand control

#### Token Mapping for Dynamic Colors

```
If dynamic colors available:
  primary = dynamicColorScheme.primary
  secondary = dynamicColorScheme.secondary
  tertiary = dynamicColorScheme.tertiary
  (and so on...)

Else:
  primary = staticBrandPrimary
  secondary = staticBrandSecondary
  (fallback to static theme)
```

### Platform Color Detection

Different platforms provide different dynamic color APIs:

**Android 12+**:
- Use `dynamicColorScheme()` from material_color_utilities
- Generates complete color scheme from seed color (wallpaper)

**iOS 13+**:
- Use `UITraitCollection.userInterfaceStyle` to detect light/dark
- iOS doesn't provide wallpaper-based dynamic colors (as of iOS 15)
- Follow system light/dark mode

**Web**:
- Use `prefers-color-scheme` media query for light/dark detection
- No wallpaper-based colors on web

**Desktop (macOS/Windows/Linux)**:
- Detect system theme (light/dark) via platform channels
- No dynamic colors from wallpapers

### Implementing Dynamic Color Support

**Step 1: Detect Platform Capability**
```
Check if platform supports dynamic colors (Android 12+)
If yes, extract dynamic color scheme
If no, use static theme
```

**Step 2: Generate Color Scheme**
```
If dynamic:
  Seed color from wallpaper
  Generate TonalPalette (Material 3)
  Create ColorScheme with generated tones
Else:
  Use static ColorScheme from preset
```

**Step 3: Apply to Theme**
```
Create AppTheme with ColorScheme
Map colors to tokens
Apply via ThemeService.setCustomTheme()
```

**Step 4: Persist User Preference**
```
Save user's choice:
  - "Follow wallpaper" (dynamic)
  - "Static brand theme"
  - "Custom theme"
```

---

## Token Usage Guidelines

### When to Use Each Token

**Colors**:
- Use semantic colors (`primary`, `error`) not raw palette
- Always pair with contrasting "on" color (`primary` with `onPrimary`)
- Use neutral grays for borders, dividers, disabled states

**Typography**:
- Use semantic styles (`h1`, `body1`) not raw sizes
- Maintain hierarchy (don't skip levels: h1 → h2 → h3)
- Use `button` style for all buttons (consistency)

**Spacing**:
- Stick to spacing scale (xs, sm, md, lg, xl)
- Avoid arbitrary values (use `md` not `15px`)
- Use semantic spacing (`contentPadding`) when available

**Radii**:
- Be consistent within component types (all buttons use same radius)
- Use `circle` for avatars, icon buttons
- Use `lg` for large surfaces (cards, dialogs)

**Elevation**:
- Higher elevation = more important (dialogs > cards)
- Don't overuse high elevations (visual hierarchy breaks down)
- In dark theme, consider surface tinting instead of shadows

### Anti-Patterns to Avoid

❌ **Hardcoding Values**:
```
Container(
  color: Color(0xFF2196F3),  // Bad: hardcoded color
  padding: EdgeInsets.all(17),  // Bad: arbitrary spacing
)
```

✅ **Using Tokens**:
```
Container(
  color: tokens.colors.primary,  // Good: semantic token
  padding: EdgeInsets.all(tokens.spacing.md),  // Good: scale value
)
```

❌ **Skipping Semantic Tokens**:
```
// Bad: using raw palette directly
color: tokens.colors.blue500
```

✅ **Using Semantic Tokens**:
```
// Good: using semantic token
color: tokens.colors.primary
```

❌ **Inconsistent Component Styling**:
```
// Bad: different radii for similar buttons
Button1: borderRadius: 4
Button2: borderRadius: 8
```

✅ **Consistent Component Styling**:
```
// Good: all buttons use same radius
AllButtons: borderRadius: tokens.radii.buttonRadius
```

---

## Summary

This token system provides:

- **300+ design tokens** covering all visual aspects
- **Semantic naming** for clarity and maintainability
- **Light and dark variants** for all tokens
- **Accessibility compliance** with WCAG contrast requirements
- **Dynamic color support** for Material You personalization
- **Platform flexibility** with fallbacks for all platforms
- **Scalability** to add new tokens without breaking existing

Use these tokens consistently throughout your app for a cohesive, maintainable, and accessible design system.
