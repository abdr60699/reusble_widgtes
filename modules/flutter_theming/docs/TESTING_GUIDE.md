# Testing Guide

Comprehensive testing strategies for the theming system.

## Table of Contents

1. [Unit Testing](#unit-testing)
2. [Widget Testing](#widget-testing)
3. [Integration Testing](#integration-testing)
4. [Visual Regression Testing](#visual-regression-testing)
5. [Accessibility Testing](#accessibility-testing)
6. [Manual QA Checklist](#manual-qa-checklist)

---

## Unit Testing

### Testing ThemeService

**Test: Initialization**
```
Scenario: ThemeService initializes with default theme
Given: Fresh app start with no saved preference
When: ThemeService.initialize() is called
Then: currentTheme should be system theme or light
And: tokens should be accessible
And: themeStream should be active
```

**Test: Theme Switching**
```
Scenario: User switches from light to dark theme
Given: ThemeService initialized with light theme
When: setTheme(AppThemeMode.dark) is called
Then: currentTheme.mode should be AppThemeMode.dark
And: tokens.colors.background should be dark color
And: themeStream should emit new theme
```

**Test: Custom Accent**
```
Scenario: User sets custom accent color
Given: ThemeService with current theme
When: setCustomAccent(Color(0xFF6200EE)) is called
Then: currentTheme.tokens.colors.primary should be new color
And: derived colors should update (primaryVariant, onPrimary)
And: themeStream should emit updated theme
```

**Test: Invalid Theme Rejection**
```
Scenario: Custom theme with invalid contrast fails validation
Given: Custom theme with low contrast colors
When: setCustomTheme(invalidTheme) is called
Then: ThemeValidationException should be thrown
And: currentTheme should remain unchanged
```

### Testing ThemeRepository

**Test: Save and Load**
```
Scenario: Theme preference persists across restarts
Given: User selects dark theme
When: Theme is saved via repository.saveTheme()
And: App restarts
And: repository.loadSavedTheme() is called
Then: Loaded theme should be dark theme
```

**Test: Migration**
```
Scenario: Old theme config is migrated to new version
Given: Saved theme config with version 1
When: App updates to version 2
And: repository.loadSavedTheme() is called
Then: Theme should be migrated to version 2
And: All new required tokens should have default values
```

### Testing ThemeValidator

**Test: Contrast Validation**
```
Test Case 1: Valid Contrast
  foreground: #000000 (black)
  background: #FFFFFF (white)
  Expected: Ratio 21:1, passes WCAG AAA

Test Case 2: Invalid Contrast
  foreground: #777777 (gray)
  background: #888888 (slightly darker gray)
  Expected: Ratio ~1.2:1, fails WCAG AA

Test Case 3: Borderline Contrast
  foreground: #595959
  background: #FFFFFF
  Expected: Ratio 4.5:1, passes AA, fails AAA
```

**Test: Theme Completeness**
```
Scenario: Theme missing required tokens fails validation
Given: AppTheme with incomplete ColorTokens (missing 'error' color)
When: validator.validateTheme(theme) is called
Then: result.isValid should be false
And: result.errors should contain "Missing required token: colors.error"
```

---

## Widget Testing

### Testing Themed Widgets

**Test: Widget Uses Theme Tokens**
```
testWidgets('ThemedButton uses primary color', (tester) async {
  // Arrange
  await ThemeService.initialize(...)
  final button = ThemedButton(label: 'Test', onPressed: () {})

  // Act
  await tester.pumpWidget(MaterialApp(home: Scaffold(body: button)))

  // Assert
  final container = tester.widget<Container>(find.byType(Container))
  expect(
    container.decoration.color,
    equals(ThemeService.instance.tokens.colors.primary),
  )
})
```

**Test: Widget Rebuilds on Theme Change**
```
testWidgets('Widget updates when theme changes', (tester) async {
  // Arrange
  await ThemeService.initialize(...)
  await tester.pumpWidget(MyApp())

  final initialColor = getBackgroundColor(tester)

  // Act
  ThemeService.instance.setTheme(AppThemeMode.dark)
  await tester.pumpAndSettle()  // Wait for rebuild

  // Assert
  final newColor = getBackgroundColor(tester)
  expect(newColor, isNot(equals(initialColor)))
  expect(newColor, equals(dark theme background color))
})
```

**Test: Scoped Theme Override**
```
testWidgets('ThemeScopeProvider overrides tokens', (tester) async {
  // Arrange
  final customPrimary = Color(0xFFFF5722)

  await tester.pumpWidget(
    MaterialApp(
      home: ThemeScopeProvider(
        overrides: {'colors.primary': customPrimary},
        child: ThemedButton(label: 'Test'),
      ),
    ),
  )

  // Assert
  final buttonColor = getButtonColor(tester)
  expect(buttonColor, equals(customPrimary))
})
```

### Testing with Different Themes

**Test: Widget in Light and Dark**
```
testWidgets('Widget renders correctly in light theme', (tester) async {
  await ThemeService.instance.setTheme(AppThemeMode.light)
  await tester.pumpWidget(MyWidget())
  expect(find.text('Content'), findsOneWidget)
  // Verify light theme styling
})

testWidgets('Widget renders correctly in dark theme', (tester) async {
  await ThemeService.instance.setTheme(AppThemeMode.dark)
  await tester.pumpWidget(MyWidget())
  expect(find.text('Content'), findsOneWidget)
  // Verify dark theme styling
})
```

---

## Integration Testing

### End-to-End Theme Switching

**Test: Complete Theme Switch Flow**
```
Scenario: User changes theme in settings
  1. Launch app
  2. Navigate to settings screen
  3. Tap theme switcher
  4. Select "Dark Mode"
  5. Verify:
     - Settings screen updates to dark theme
     - Navigate back to home
     - Home screen is also dark
     - Restart app
     - App opens with dark theme (preference persisted)
```

**Test: Custom Theme Creation**
```
Scenario: User creates custom theme
  1. Open theme customization screen
  2. Pick custom primary color (#FF5722)
  3. Verify preview shows new color
  4. Tap "Apply"
  5. Verify:
     - Theme applies throughout app
     - Custom theme saved
     - Restart app
     - Custom theme persists
```

---

## Visual Regression Testing

### Golden Tests

**Setup**:
```
Use flutter_test golden files to capture widget snapshots

testWidgets('Button golden test - light theme', (tester) async {
  await ThemeService.instance.setTheme(AppThemeMode.light)

  await tester.pumpWidget(
    MaterialApp(
      home: Scaffold(
        body: ThemedButton(label: 'Test Button'),
      ),
    ),
  )

  await expectLater(
    find.byType(ThemedButton),
    matchesGoldenFile('goldens/button_light.png'),
  )
})

testWidgets('Button golden test - dark theme', (tester) async {
  await ThemeService.instance.setTheme(AppThemeMode.dark)

  await tester.pumpWidget(
    MaterialApp(
      home: Scaffold(
        body: ThemedButton(label: 'Test Button'),
      ),
    ),
  )

  await expectLater(
    find.byType(ThemedButton),
    matchesGoldenFile('goldens/button_dark.png'),
  )
})
```

**Golden Test Coverage**:
```
Create goldens for:
  - All themed components (buttons, cards, inputs, etc.)
  - Each theme preset (light, dark, high-contrast)
  - Key screens (home, settings, detail)
  - Different font scales (100%, 150%, 200%)
  - Focus states
  - Error states
```

**Updating Goldens**:
```
When design changes intentionally:
  flutter test --update-goldens

Verify changes:
  - Review diff of golden files
  - Ensure changes are intentional
  - Commit updated goldens
```

### Screenshot Testing

**Automated Screenshot Tests**:
```
Use integration_test package:

testWidgets('Capture screenshots of all themes', (tester) async {
  final themes = [
    AppThemeMode.light,
    AppThemeMode.dark,
    'high_contrast',
  ]

  for (final theme in themes) {
    ThemeService.instance.setTheme(theme)
    await tester.pumpAndSettle()

    await tester.takeScreenshot('home_$theme')
    // Navigate and capture other screens
  }
})
```

---

## Accessibility Testing

### Contrast Testing

**Automated Contrast Tests**:
```
test('All theme presets meet WCAG AA', () {
  final presets = ThemePresets.all()
  final validator = ThemeValidator()

  for (final preset in presets) {
    final result = validator.validateTheme(preset)

    expect(
      result.isValid,
      isTrue,
      reason: '${preset.name} should pass validation',
    )

    expect(
      result.errors,
      isEmpty,
      reason: '${preset.name} should have no errors',
    )

    // Verify specific contrast pairs
    expect(
      validator.checkContrast(
        preset.tokens.colors.onBackground,
        preset.tokens.colors.background,
        WCAGLevel.AA,
      ),
      isTrue,
      reason: '${preset.name} onBackground/background contrast',
    )
  }
})
```

### Font Scaling Tests

**Test Layouts at Various Scales**:
```
testWidgets('Layout handles large font scale', (tester) async {
  await tester.pumpWidget(
    MediaQuery(
      data: MediaQueryData(textScaleFactor: 2.0),
      child: MaterialApp(home: MyScreen()),
    ),
  )

  await tester.pumpAndSettle()

  // Verify no overflow
  expect(tester.takeException(), isNull)

  // Verify text is visible
  expect(find.text('Content'), findsOneWidget)
})
```

---

## Manual QA Checklist

### Theme Switching Tests

- [ ] Switch from light to dark theme
  - [ ] Entire app updates
  - [ ] All screens use dark colors
  - [ ] No white flashes or glitches
  - [ ] Theme persists after restart

- [ ] Switch from dark to light theme
  - [ ] Entire app updates
  - [ ] All screens use light colors
  - [ ] Theme persists after restart

- [ ] Follow system theme
  - [ ] App matches system (light/dark)
  - [ ] Changes when system changes
  - [ ] Persists "follow system" preference

- [ ] Custom accent color
  - [ ] Color picker opens
  - [ ] Preview shows selected color
  - [ ] Apply updates all primary elements
  - [ ] Custom color persists

### Preset Tests

- [ ] Apply each preset (light, dark, high-contrast, etc.)
  - [ ] Visually distinct from others
  - [ ] All text readable
  - [ ] Buttons/links visible
  - [ ] No visual glitches

### Cross-Platform Tests

- [ ] Android
  - [ ] Light theme renders correctly
  - [ ] Dark theme renders correctly
  - [ ] System theme detection works
  - [ ] Persistence works

- [ ] iOS
  - [ ] Light theme renders correctly
  - [ ] Dark theme renders correctly
  - [ ] System theme detection works
  - [ ] Persistence works

- [ ] Web
  - [ ] Light theme renders correctly
  - [ ] Dark theme renders correctly
  - [ ] prefers-color-scheme detection works
  - [ ] Persistence works (localStorage)

- [ ] Desktop (macOS/Windows/Linux)
  - [ ] Light theme renders correctly
  - [ ] Dark theme renders correctly
  - [ ] System theme detection works

### Accessibility Tests

- [ ] High contrast mode
  - [ ] Enable system high contrast
  - [ ] App switches to high-contrast theme
  - [ ] All text has high contrast
  - [ ] Borders/outlines visible

- [ ] Font scaling
  - [ ] Set system font to 100%, 150%, 200%
  - [ ] Text scales appropriately
  - [ ] No text overflow
  - [ ] Buttons remain tappable

- [ ] Screen reader
  - [ ] Enable TalkBack/VoiceOver
  - [ ] Navigate with screen reader
  - [ ] Theme changes announced
  - [ ] All elements have labels

- [ ] Motion reduction
  - [ ] Enable reduce motion
  - [ ] Theme switches instantly (no animation)
  - [ ] No jarring transitions

### Visual QA

- [ ] Check all core components
  - [ ] AppBar
  - [ ] Buttons (Elevated, Text, Outlined)
  - [ ] Text fields
  - [ ] Cards
  - [ ] Dialogs
  - [ ] Bottom sheets
  - [ ] Snackbars
  - [ ] Lists
  - [ ] Navigation bars

- [ ] Check all screens
  - [ ] Home screen
  - [ ] Settings screen
  - [ ] Detail screens
  - [ ] Forms
  - [ ] Error states

- [ ] Check states
  - [ ] Default
  - [ ] Hover
  - [ ] Pressed
  - [ ] Focused
  - [ ] Disabled
  - [ ] Error

### Edge Cases

- [ ] Theme switch during navigation
  - [ ] Mid-navigation theme change
  - [ ] Verify no crashes
  - [ ] Destination screen has new theme

- [ ] Theme switch during async operation
  - [ ] Start long operation (API call)
  - [ ] Switch theme mid-operation
  - [ ] Verify operation completes
  - [ ] Result screen has new theme

- [ ] Rapid theme switches
  - [ ] Quickly toggle between themes
  - [ ] Verify no crashes
  - [ ] Verify final theme is correct

- [ ] App backgrounding
  - [ ] Switch theme
  - [ ] Background app
  - [ ] Return to app
  - [ ] Verify theme persists

---

## Summary

**Testing Strategy**:

1. **Unit Tests**: Test individual services and validators
2. **Widget Tests**: Test themed components in isolation
3. **Integration Tests**: Test complete theme switching flows
4. **Golden Tests**: Capture visual regressions
5. **Accessibility Tests**: Ensure WCAG compliance
6. **Manual QA**: Comprehensive visual and functional testing

**Continuous Testing**:
- Run unit and widget tests on every commit
- Run integration tests on PR merges
- Update goldens when designs change intentionally
- Manual QA before each release
- Accessibility audit quarterly

Comprehensive testing ensures theme changes don't break functionality and all users have an accessible, consistent experience.
