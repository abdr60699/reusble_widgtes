# Accessibility Guide

Ensuring themes meet accessibility standards and support all users.

## Table of Contents

1. [WCAG Compliance](#wcag-compliance)
2. [Contrast Requirements](#contrast-requirements)
3. [High Contrast Mode](#high-contrast-mode)
4. [Font Scaling](#font-scaling)
5. [Motion Reduction](#motion-reduction)
6. [Screen Reader Support](#screen-reader-support)
7. [Accessibility Testing](#accessibility-testing)

---

## WCAG Compliance

### WCAG Levels

**Level AA (Minimum Recommended)**:
- Normal text: 4.5:1 contrast ratio
- Large text (18pt+/14pt bold+): 3:1 contrast ratio
- UI components: 3:1 contrast ratio
- Focus indicators: 3:1 contrast ratio

**Level AAA (Enhanced)**:
- Normal text: 7:1 contrast ratio
- Large text: 4.5:1 contrast ratio

### Implementing WCAG Compliance

**ThemeValidator Checks**:
```
validateTheme(AppTheme theme):
  1. Check all text/background pairs:
     - onBackground vs background (4.5:1 minimum)
     - onSurface vs surface (4.5:1 minimum)
     - onPrimary vs primary (4.5:1 minimum)
     - onSecondary vs secondary (4.5:1 minimum)
     - onError vs error (4.5:1 minimum)

  2. Check UI component contrasts:
     - Button borders vs background (3:1 minimum)
     - Input borders vs background (3:1 minimum)
     - Focus indicators vs background (3:1 minimum)

  3. Return ValidationResult with:
     - errors: List of failing pairs
     - warnings: Pairs meeting AA but not AAA
     - suggestions: Adjusted colors meeting requirements
```

**Automatic Contrast Fixing**:
```
When custom color fails contrast:
  1. Calculate current contrast ratio
  2. If too low:
     a. Try darkening foreground
     b. Try lightening background
     c. Return closest color meeting requirement
  3. Suggest fix to user
  4. Optionally auto-apply if user consents
```

---

## Contrast Requirements

### Color Pair Testing

**Primary Text on Background**:
```
Required: 4.5:1 minimum (AA), 7:1 enhanced (AAA)

Light Theme:
  background: #FFFFFF (white)
  onBackground: #212121 (almost black)
  Ratio: 16.1:1 ✓ (exceeds AAA)

Dark Theme:
  background: #121212 (almost black)
  onBackground: #FFFFFF (white)
  Ratio: 15.8:1 ✓ (exceeds AAA)
```

**Primary Button**:
```
Required: 4.5:1 minimum

Light Theme:
  primary: #6200EE (purple)
  onPrimary: #FFFFFF (white)
  Ratio: 8.6:1 ✓

Dark Theme:
  primary: #BB86FC (light purple)
  onPrimary: #000000 (black)
  Ratio: 11.4:1 ✓
```

**Error Messages**:
```
Required: 4.5:1 minimum

error: #B00020 (red)
onError: #FFFFFF (white)
Ratio: 5.5:1 ✓
```

### Contrast Calculation

**Contrast Ratio Formula**:
```
1. Calculate relative luminance for each color:
   L = 0.2126 * R + 0.7152 * G + 0.0722 * B
   (where R, G, B are linearized sRGB values)

2. Contrast ratio:
   CR = (Lmax + 0.05) / (Lmin + 0.05)

3. Compare to threshold:
   - CR >= 4.5: Meets AA
   - CR >= 7.0: Meets AAA
   - CR < 4.5: Fails
```

**Implementation in ThemeValidator**:
```
double calculateContrastRatio(Color fg, Color bg):
  final fgLuminance = fg.computeLuminance()
  final bgLuminance = bg.computeLuminance()

  final lighter = max(fgLuminance, bgLuminance)
  final darker = min(fgLuminance, bgLuminance)

  return (lighter + 0.05) / (darker + 0.05)

bool meetsWCAG_AA(Color fg, Color bg, bool isLargeText):
  final ratio = calculateContrastRatio(fg, bg)
  final threshold = isLargeText ? 3.0 : 4.5
  return ratio >= threshold
```

---

## High Contrast Mode

### High Contrast Theme Preset

**Purpose**: For users with visual impairments requiring maximum contrast.

**Specifications**:
```
ThemePresets.highContrast():
  Light Variant:
    background: #FFFFFF (pure white)
    onBackground: #000000 (pure black)
    primary: #0000CC (strong blue)
    onPrimary: #FFFFFF (white)
    error: #CC0000 (strong red)
    success: #006600 (strong green)
    All ratios: 15:1 or higher

  Dark Variant:
    background: #000000 (pure black)
    onBackground: #FFFFFF (pure white)
    primary: #99CCFF (light blue)
    onPrimary: #000000 (black)
    All ratios: 15:1 or higher

  Additional:
    - Thicker borders (2px minimum)
    - Larger focus indicators
    - No gradients or transparency
    - Maximum color differentiation
```

### Detecting System High Contrast

**Platform Detection**:
```
Check platform high contrast preference:

Android:
  AccessibilityManager.isHighTextContrastEnabled()

iOS:
  UIAccessibility.isDarkerSystemColorsEnabled

Windows:
  SystemParameters.HighContrast

Web:
  @media (prefers-contrast: high)

Implementation:
  if (platformPrefersHighContrast) {
    ThemeService.instance.setThemePreset('high_contrast')
  }
```

---

## Font Scaling

### Respecting Platform Font Scaling

**MediaQuery.textScaleFactor**:
```
Platform allows users to increase font size (100% - 200%+)

Implementation:
  Widget build(BuildContext context) {
    final textScaleFactor = MediaQuery.of(context).textScaleFactor
    final baseFontSize = tokens.typography.body1.fontSize
    final scaledFontSize = baseFontSize * textScaleFactor

    return Text(
      'Content',
      style: TextStyle(fontSize: scaledFontSize),
    )
  }

Note: TextStyle.fontSize is automatically scaled by Flutter
No manual scaling needed in most cases
```

### Testing Font Scaling

**Test at Multiple Scales**:
```
Test Points:
  - 100% (default)
  - 125% (slight increase)
  - 150% (moderate increase)
  - 175% (large increase)
  - 200% (maximum recommended)

Check:
  - Text doesn't overflow containers
  - Buttons remain tappable
  - Layouts adapt gracefully
  - Multi-line text wraps correctly
```

### Minimum Font Sizes

**Accessibility Recommendations**:
```
Minimum Sizes (at 100% scale):
  - Body text: 16px minimum
  - Small text (captions): 12px minimum
  - Touch target labels: 14px minimum

Avoid:
  - Text smaller than 10px (illegible for many users)
  - Fixed-height containers with text (causes overflow)
```

---

## Motion Reduction

### Detecting Motion Preference

**Platform Detection**:
```
Check if user prefers reduced motion:

iOS/macOS:
  UIAccessibility.isReduceMotionEnabled

Android:
  Settings.Global.TRANSITION_ANIMATION_SCALE == 0

Web:
  @media (prefers-reduced-motion: reduce)

Implementation:
  final prefersReducedMotion = MediaQuery.of(context).disableAnimations ||
                                detectPlatformReducedMotion()

  final animationDuration = prefersReducedMotion
      ? tokens.motion.durationInstant  // 0ms, instant
      : tokens.motion.durationMedium   // 300ms, animated
```

### Implementing Reduced Motion

**Theme Transitions**:
```
When switching themes:
  if (prefersReducedMotion) {
    // Instant change, no animation
    setState(() { theme = newTheme })
  } else {
    // Animated transition
    AnimatedTheme(
      duration: tokens.motion.durationMedium,
      theme: newTheme,
    )
  }
```

**Motion Tokens**:
```
MotionTokens:
  // Standard durations
  durationMedium: 300ms

  // Reduced motion durations
  durationReduced: 0ms (instant) or 100ms (minimal)

Usage:
  final duration = prefersReducedMotion
      ? tokens.motion.durationReduced
      : tokens.motion.durationMedium

  AnimatedContainer(
    duration: Duration(milliseconds: duration),
    // ...
  )
```

---

## Screen Reader Support

### Semantic Labels

**Theme State Announcements**:
```
When theme changes:
  Announce to screen reader: "Theme changed to Dark Mode"

Implementation:
  import 'package:flutter/semantics.dart';

  void announceThemeChange(String themeName) {
    SemanticsService.announce(
      'Theme changed to $themeName',
      TextDirection.ltr,
    )
  }

  // Call after theme switch
  ThemeService.instance.setTheme(AppThemeMode.dark)
  announceThemeChange('Dark Mode')
```

### Color Descriptions

**Provide Semantic Labels for Colors**:
```
Instead of just color, provide semantic meaning:

Bad:
  Container(color: #6200EE)

Good:
  Semantics(
    label: 'Primary action button',
    button: true,
    child: Container(color: tokens.colors.primary),
  )
```

### Focus Indicators

**Visible Focus States**:
```
All interactive elements need visible focus:

Focus Indicator:
  - Border or outline
  - Color: tokens.colors.focus (high contrast with background)
  - Thickness: 2-3px minimum
  - Contrast: 3:1 with background (WCAG requirement)

Implementation:
  FocusableActionDetector(
    onFocusChange: (hasFocus) {
      setState(() { _hasFocus = hasFocus })
    },
    child: Container(
      decoration: BoxDecoration(
        border: _hasFocus ? Border.all(
          color: tokens.colors.focus,
          width: 2.0,
        ) : null,
      ),
    ),
  )
```

---

## Accessibility Testing

### Automated Testing

**Contrast Testing**:
```
Test all color pairs:

void testContrast() {
  final theme = ThemePresets.light()
  final validator = ThemeValidator()

  // Test specific pairs
  expect(
    validator.checkContrast(
      theme.tokens.colors.onBackground,
      theme.tokens.colors.background,
      WCAGLevel.AA,
    ),
    isTrue,
    reason: 'onBackground should have 4.5:1 contrast with background',
  )

  // Test entire theme
  final result = validator.validateTheme(theme)
  expect(result.isValid, isTrue)
  expect(result.errors, isEmpty)
}
```

**Font Scaling Testing**:
```
Test layouts at various scales:

testWidgets('Widget adapts to large font scale', (tester) async {
  await tester.pumpWidget(
    MediaQuery(
      data: MediaQueryData(textScaleFactor: 2.0),
      child: MyWidget(),
    ),
  )

  // Verify:
  // - No overflow errors
  // - Text is readable
  // - Touch targets >= 44x44 dp
})
```

### Manual Testing

**Test Scenarios**:

1. **High Contrast Mode**:
   - Enable system high contrast
   - Verify all text is readable
   - Check button/link visibility
   - Ensure focus indicators visible

2. **Font Scaling**:
   - Set system font to 200%
   - Navigate entire app
   - Check for text overflow
   - Verify buttons remain usable

3. **Screen Reader**:
   - Enable TalkBack (Android) or VoiceOver (iOS)
   - Navigate with screen reader
   - Verify theme changes are announced
   - Check all interactive elements have labels

4. **Motion Reduction**:
   - Enable reduce motion in system settings
   - Switch themes
   - Verify no jarring animations
   - Check transitions are instant or minimal

5. **Color Blindness**:
   - Test with color blindness simulators
   - Don't rely on color alone for information
   - Use icons, labels, patterns in addition to color

### Accessibility Checklist

**Theme Accessibility Audit**:

- [ ] All text/background pairs meet WCAG AA (4.5:1)
- [ ] UI components meet 3:1 contrast with background
- [ ] High contrast theme preset available
- [ ] Font scaling tested at 100%, 150%, 200%
- [ ] No fixed-height text containers
- [ ] Motion respects prefers-reduced-motion
- [ ] Theme changes announced to screen readers
- [ ] Focus indicators visible and high-contrast
- [ ] Touch targets >= 44x44 dp (48x48 recommended)
- [ ] Information not conveyed by color alone
- [ ] Tested with actual screen readers
- [ ] Tested with platform accessibility features enabled

---

## Summary

**Accessibility Priorities**:

1. **Contrast**: Meet WCAG AA minimum, aim for AAA
2. **Font Scaling**: Support 100%-200% scaling
3. **Motion**: Respect reduced motion preference
4. **Screen Readers**: Provide semantic labels, announce changes
5. **High Contrast**: Offer high-contrast preset
6. **Testing**: Test with real assistive technologies

Making themes accessible benefits all users, not just those with disabilities. Clear text, high contrast, and reduced motion create a better experience for everyone.
