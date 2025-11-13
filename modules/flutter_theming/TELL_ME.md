# TELL ME - How to Test Flutter Theming System

This guide shows you what screens to create to test your theming system implementation.

**Note**: Flutter Theming is a design specification (no code). You implement it based on the docs. This guide shows what UI to build to test your implementation.

## Main File Setup

### Add Navigation Button in main.dart

```
Button: "Test Theming System"
OnPressed: Navigate to ThemeTestScreen
```

## Screens to Create

### Screen 1: ThemeTestScreen (Main Menu)

**Purpose**: Test all theming features

**UI Elements**:
```
AppBar: "Theme System Testing"
  Actions:
    IconButton: Theme switcher (sun/moon icon)

Sections in ScrollView:

1. Current Theme Info
   Text: "Current Theme: Light" (or Dark/Custom)
   Text: "Mode: AppThemeMode.light"
   Container: Shows primary color swatch

2. Theme Switcher
   SegmentedButton or Tabs:
     - Light
     - Dark
     - System
     - Custom (if you have custom themes)

3. Quick Actions
   Button: "Switch to Dark" → Sets dark theme
   Button: "Switch to Light" → Sets light theme
   Button: "Follow System" → Sets system theme
   Button: "Custom Accent Color" → Opens color picker

4. Component Showcase
   Button: "View All Components" → Navigate to ComponentShowcaseScreen
   Button: "Test Token Access" → Navigate to TokenDisplayScreen
   Button: "Test Scoped Themes" → Navigate to ScopedThemeTestScreen

5. Persistence Test
   Button: "Restart App Simulation" → Restarts app to test persistence
   Text: "Theme should persist after restart"

Bottom:
  Text: "Primary Color: #6200EE"
  Text: "Background: #FFFFFF"
  Text: "Last Changed: [timestamp]"
```

**What You Need to Do**:
1. Open app → See this screen
2. Current theme shown (likely Light by default)
3. Tap different theme options
4. See UI update immediately

**What You Should See**:
- Tapping "Dark" → Entire app becomes dark
- Tapping "Light" → Entire app becomes light
- Tapping "System" → Matches phone's system theme
- UI updates instantly (no flicker)
- Colors, text, spacing all update together

---

### Screen 2: ComponentShowcaseScreen

**Purpose**: See all components with current theme applied

**UI Elements**:
```
AppBar: "Component Showcase"

ScrollView with sections:

Section 1: Buttons
  ElevatedButton: "Primary Button"
  TextButton: "Text Button"
  OutlinedButton: "Outlined Button"
  IconButton: Favorite icon
  FloatingActionButton: Add icon

Section 2: Text Styles
  Text: "Display 1" (display1 style)
  Text: "Headline 1" (h1 style)
  Text: "Headline 2" (h2 style)
  Text: "Body Text" (body1 style)
  Text: "Caption Text" (caption style)

Section 3: Inputs
  TextField: "Email" (filled style)
  TextField: "Password" (outlined style)
  Checkbox: "Accept terms"
  Radio: Options 1, 2, 3
  Switch: "Enable notifications"

Section 4: Cards & Surfaces
  Card:
    Title: "Card Title"
    Content: "Card content with surface color"
    Actions: Two buttons

  Card with Image:
    Image at top
    Title and description
    Action buttons

Section 5: Dialogs & Sheets
  Button: "Show Dialog" → Opens AlertDialog
  Button: "Show Bottom Sheet" → Opens ModalBottomSheet
  Button: "Show Snackbar" → Shows Snackbar

Section 6: Lists
  ListTile: "Item 1" with leading icon
  ListTile: "Item 2" with trailing icon
  Divider
  ListTile: "Item 3"

Section 7: Other Components
  Chip: "Tag 1", "Tag 2"
  CircularProgressIndicator
  LinearProgressIndicator
  Badge: "3" on icon
```

**What You Need to Do**:
1. Navigate to this screen
2. Scroll through all sections
3. Switch theme using AppBar icon
4. Watch all components update

**What You Should See - Light Theme**:
- Buttons: Purple primary color
- Background: White
- Text: Black/dark gray
- Cards: White with subtle shadow
- Inputs: Light fill color

**What You Should See - Dark Theme**:
- Buttons: Light purple primary
- Background: Dark gray (#121212)
- Text: White/light gray
- Cards: Elevated dark surface (#1E1E1E)
- Inputs: Dark fill color

**All components should**:
- Use tokens (no hard-coded colors)
- Update instantly on theme change
- Maintain proper contrast
- Look cohesive together

---

### Screen 3: TokenDisplayScreen

**Purpose**: Show all design tokens being used

**UI Elements**:
```
AppBar: "Design Tokens"

Tabs:
  - Colors
  - Typography
  - Spacing
  - Radii
  - Elevations

Tab 1: Colors
  Grid of color swatches:
    Each swatch shows:
      - Color box (actual color)
      - Token name: "primary"
      - Hex value: "#6200EE"

  Colors to show:
    - primary, onPrimary
    - secondary, onSecondary
    - background, onBackground
    - surface, onSurface
    - error, onError
    - success, warning, info
    - Neutral palette (50-900)

Tab 2: Typography
  List of text samples:
    "Display 1" (in display1 style)
    Shows: Size 96px, Weight Light

    "Headline 1" (in h1 style)
    Shows: Size 34px, Weight Regular

    ... for all text styles

Tab 3: Spacing
  Visual spacing examples:
    Box with xs padding (4px)
    Box with sm padding (8px)
    Box with md padding (16px)
    Box with lg padding (24px)
    Box with xl padding (32px)

Tab 4: Radii
  Boxes with different border radius:
    Square (none): 0px
    Rounded sm: 4px
    Rounded md: 8px
    Rounded lg: 16px
    Circle: 9999px

Tab 5: Elevations
  Cards at different elevations:
    Elevation 0 (flat)
    Elevation 2 (subtle shadow)
    Elevation 4 (card shadow)
    Elevation 8 (dialog shadow)
    Elevation 16 (modal shadow)
```

**What You Need to Do**:
1. Navigate to this screen
2. Browse each tab
3. Switch theme
4. See token values update

**What You Should See**:
- All tokens displayed with values
- Switching theme updates all tokens
- Light theme: Dark text on light bg
- Dark theme: Light text on dark bg
- Proper visual hierarchy

---

### Screen 4: CustomAccentScreen

**Purpose**: Test custom accent color selection

**UI Elements**:
```
AppBar: "Custom Accent Color"

Current Accent:
  Large circle showing current primary color
  Text: "Current: #6200EE"

Color Picker:
  Color wheel or grid picker
  Recent colors row

Preview Section:
  Text: "Preview with selected color:"
  Button: "Sample Button" (with selected color)
  Card: Sample content (using selected color for accents)
  Text: Shows contrast ratio with background

Buttons:
  "Apply Color" (if contrast is valid)
  "Reset to Default"

Warning (if contrast too low):
  "⚠️ Contrast ratio 2.1:1 is below recommended 4.5:1"
  "Try darker/lighter color for better accessibility"
```

**What You Need to Do**:
1. Navigate to this screen
2. Pick a color from picker (e.g., orange)
3. See preview update
4. Check contrast ratio
5. Tap "Apply Color"
6. Navigate back

**What You Should See**:
- Color picker shows current primary color
- Moving picker updates preview in real-time
- Contrast warning appears if color fails WCAG
- After applying:
  - All primary-colored elements update
  - Buttons, AppBar, FAB use new color
  - Theme persists after app restart

**Contrast Testing**:
- Pick very light color on light theme → Warning shown
- Pick very dark color on dark theme → Warning shown
- Pick medium saturation color → Valid, can apply

---

### Screen 5: ScopedThemeTestScreen

**Purpose**: Test scoped theme overrides

**UI Elements**:
```
AppBar: "Scoped Themes"

Main content (using base theme):
  Container: Background color from theme
  Text: "This uses base theme colors"
  Button: "Base Theme Button"

Scoped Section (with theme override):
  Container with custom background (e.g., orange)
  Text: "This section has custom theme"
  Text: Custom primary color applied here
  Button: "Scoped Button" (custom color)
  Card: Uses scoped theme colors

  Text: "Only this section is affected"

Back to base theme:
  Container: Background from base theme again
  Text: "Base theme restored"
  Button: "Base Theme Button"
```

**What You Need to Do**:
1. Navigate to this screen
2. Scroll through sections
3. Notice color differences

**What You Should See**:
- Top section: Normal theme colors
- Middle section: Custom orange theme
  - Different background
  - Different primary color
  - Only affects that section
- Bottom section: Back to normal theme
- Switching app theme doesn't affect scoped override

**Implementation**:
```
Use ThemeScopeProvider around middle section:
  ThemeScopeProvider(
    overrides: {
      'colors.primary': Color(0xFFFF5722),
      'colors.background': Color(0xFFFFF3E0),
    },
    child: ScopedContent(),
  )
```

---

### Screen 6: ThemePresetsScreen

**Purpose**: Test switching between theme presets

**UI Elements**:
```
AppBar: "Theme Presets"

Grid of theme cards:

Card: "Light Theme"
  Preview: Shows light colors
  Text: "Default light theme"
  Button: "Apply"

Card: "Dark Theme"
  Preview: Shows dark colors
  Text: "Default dark theme"
  Button: "Apply"

Card: "High Contrast"
  Preview: Pure black/white
  Text: "High contrast for accessibility"
  Button: "Apply"

Card: "Corporate"
  Preview: Professional blue/gray
  Text: "Professional theme"
  Button: "Apply"

Card: "Soft Pastel"
  Preview: Soft muted colors
  Text: "Soft, low-saturation theme"
  Button: "Apply"

Bottom:
  Button: "Create Custom Theme"
```

**What You Need to Do**:
1. Navigate to this screen
2. See all available presets
3. Tap "Apply" on any card
4. Theme changes immediately
5. Navigate back to see theme applied

**What You Should See**:
- Each card shows preview of that theme
- Tapping "Apply" switches entire app
- High contrast: Black background, white text, high contrast buttons
- Corporate: Blue primary, gray accents, professional look
- Soft Pastel: Muted colors, low saturation

---

### Screen 7: FontScalingTestScreen

**Purpose**: Test theme with different font scales

**UI Elements**:
```
AppBar: "Font Scaling Test"

Slider:
  Label: "Text Scale Factor"
  Min: 0.5
  Max: 3.0
  Current: 1.0
  OnChanged: Updates text scale

Content (updates with slider):
  Text: "Display Text" (display1 style)
  Text: "Headline Text" (h1 style)
  Text: "Body Text" (body1 style)
  Text: "Caption Text" (caption style)

  Card with text content
  Button with text
  List with text items

Bottom:
  Text: "Current scale: 1.5x"
  Button: "Reset to 1.0"
```

**What You Need to Do**:
1. Navigate to this screen
2. Move slider to different values
3. Watch text size change
4. Check if layouts adapt

**What You Should See**:
- At 1.0: Normal text size
- At 1.5: All text 50% larger
- At 2.0: All text double size
- At 3.0: Very large text
- Layouts should not overflow
- Buttons should remain usable
- Cards should expand to fit text

**Accessibility Test**:
- Move to 2.0 (200%)
- All text should be readable
- No text cut off or overflow
- Interactive elements still tappable

---

## Testing Checklist

### Basic Theme Switching
- [ ] Switch from Light to Dark - entire app updates
- [ ] Switch from Dark to Light - entire app updates
- [ ] Switch to System - follows phone theme
- [ ] All components update colors correctly
- [ ] No white flashes or glitches during switch
- [ ] Theme change is smooth and instant

### Persistence
- [ ] Set theme to Dark
- [ ] Close app completely
- [ ] Reopen app
- [ ] App opens in Dark theme ✓
- [ ] Theme preference saved correctly

### Custom Colors
- [ ] Pick custom accent color
- [ ] See preview update in real-time
- [ ] Contrast warning shows if needed
- [ ] Apply color - all primary elements update
- [ ] Restart app - custom color persists

### Scoped Themes
- [ ] Navigate to scoped theme screen
- [ ] Middle section has different colors
- [ ] Top and bottom sections unaffected
- [ ] Switching app theme doesn't affect scoped section
- [ ] Leaving screen removes scoped override

### Presets
- [ ] Apply each preset
- [ ] Each looks visually distinct
- [ ] High contrast has strong contrast
- [ ] Corporate looks professional
- [ ] All presets are accessible (readable text)

### Font Scaling
- [ ] Scale to 1.5x - text larger, no overflow
- [ ] Scale to 2.0x - text much larger, still usable
- [ ] Scale to 0.75x - text smaller, still readable
- [ ] All layouts adapt gracefully

### Accessibility
- [ ] High contrast mode has 15:1+ ratios
- [ ] All text/background pairs meet WCAG AA (4.5:1)
- [ ] Custom colors validate contrast
- [ ] Font scaling works up to 200%
- [ ] Focus indicators visible

### Components
- [ ] All buttons use theme colors
- [ ] All text uses theme typography
- [ ] All cards use theme surface color
- [ ] All inputs use theme colors
- [ ] All spacing consistent from tokens

---

## Quick Test Script

**5-Minute Theme Test**:
1. Open app → Theme Test Screen
2. See current theme (Light)
3. Tap "Dark" → App becomes dark ✓
4. Tap "Light" → App becomes light ✓
5. Tap "System" → Matches phone ✓
6. Go to "Component Showcase"
7. Scroll through all components
8. Switch to Dark from AppBar
9. All components update ✓
10. Close and reopen app → Theme persists ✓

**Custom Color Test**:
1. Go to "Custom Accent Color"
2. Pick orange color
3. See preview update ✓
4. Contrast check passes ✓
5. Tap "Apply"
6. Navigate back → All buttons orange ✓
7. Restart app → Orange persists ✓

**Font Scale Test**:
1. Go to "Font Scaling Test"
2. Move slider to 2.0
3. All text doubles in size ✓
4. No overflow errors ✓
5. Buttons still work ✓

---

## What to Expect

### Success Signs:
- ✓ Theme changes instantly (no delays)
- ✓ All components update together
- ✓ Colors maintain proper contrast
- ✓ Text is always readable
- ✓ Theme persists after restart
- ✓ Custom colors validate and apply
- ✓ Scoped themes work as expected
- ✓ Font scaling doesn't break layouts

### Visual Consistency:
- All primary buttons same color
- All text uses theme typography
- All spacing consistent
- All cards have same shadow
- All borders use same radius
- Everything looks cohesive

### Performance:
- Theme switch is instant (<100ms)
- No flickering or flashing
- Smooth transitions (if animated)
- App remains responsive

### Common Issues:
- **Theme doesn't persist**: Not saving to storage, check persistence implementation
- **Some widgets not updating**: Not using tokens, hard-coded colors
- **White flash on switch**: Not using stream/provider correctly
- **Overflow on font scale**: Fixed heights, need flexible layouts

---

## Additional Test Scenarios

### Multi-Screen Test:
```
1. Navigate to Screen A (using theme)
2. Switch theme to Dark
3. Navigate to Screen B
4. Screen B should be dark too ✓
5. Navigate back to A
6. Screen A should be dark ✓
```

### Hot Reload Test (During Development):
```
1. Make theme change in code
2. Hot reload
3. Theme should update in running app
4. No need to restart
```

### State Management Test:
```
1. Use Provider/Riverpod/Bloc
2. Theme changes notify listeners
3. Only affected widgets rebuild
4. Performance remains good
```

---

## Monitoring

**What to Watch**:
- Theme switch time (should be <100ms)
- Number of rebuilds (minimize unnecessary rebuilds)
- Memory usage (themes should be lightweight)
- Token access speed (should be instant)

**Debug Info to Display**:
- Current theme ID
- Current theme mode
- Number of theme changes (session)
- Time of last theme change
- Loaded tokens count
- Custom color (if applied)

---

That's it! Build these screens and follow the tests to see your theming system working perfectly across your entire app.
