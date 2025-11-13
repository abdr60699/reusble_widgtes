# Flutter Theming System - Production-Ready Design Guide

A comprehensive, production-ready reusable theming system for Flutter that can be plugged into any app. This guide provides complete architecture, API design, integration patterns, and best practices for implementing consistent, accessible, and dynamic themes.

## Overview

This theming system provides:

- **Comprehensive Design Tokens**: Colors, typography, spacing, radii, elevations, and more
- **Dynamic Theme Switching**: Light, dark, system, and custom themes with runtime switching
- **Persistence**: Save and restore user theme preferences
- **Accessibility**: WCAG-compliant contrast ratios, high-contrast mode, and font scaling
- **Extensibility**: Custom themes, presets, and component-level overrides
- **Performance**: Optimized rebuilds and token memoization
- **State Management Agnostic**: Works with Provider, Riverpod, Bloc, GetIt, etc.

## Quick Start (10 Minutes)

### Integration Checklist

1. **Add Theming Module** to your project dependencies
2. **Initialize ThemeService** in your app's main() before runApp()
3. **Wrap your MaterialApp** with ThemeObserver/Provider
4. **Access tokens** in widgets via ThemeService.instance.tokens
5. **Switch themes** using ThemeService.instance.setTheme()
6. **Persist preferences** by configuring PersistenceAdapter

### Minimal Integration Example (Conceptual)

```
Step 1: Initialize in main()
  - Register ThemeService in dependency injection
  - Load saved theme preference from persistence
  - Initialize ThemeService with default or saved theme

Step 2: Wrap app with theme provider
  - Provide ThemeService to widget tree
  - Attach ThemeObserver to rebuild on theme changes

Step 3: Use tokens in widgets
  - Access colors: ThemeService.instance.tokens.colors.primary
  - Access typography: ThemeService.instance.tokens.typography.h1
  - Access spacing: ThemeService.instance.tokens.spacing.md

Step 4: Switch themes
  - ThemeService.instance.setTheme(AppThemeMode.dark)
  - ThemeService.instance.setCustomAccent(Color(0xFF6200EE))
```

## Features

### Core Capabilities

- **Design Token System**: Semantic tokens for colors, typography, spacing, radii, elevations, iconography, and motion
- **Multiple Theme Modes**: Light, dark, system-based, time-based, and fully custom themes
- **Material 3 Support**: Dynamic color, color schemes, and Material You integration
- **Runtime Switching**: Instant theme changes with optimized rebuilds
- **User Preferences**: Persistent theme selection with conflict resolution
- **Scoped Overrides**: Per-screen or per-component theme customization
- **Theme Presets**: Built-in presets (Corporate, High Contrast, Soft Pastel, etc.)
- **Custom Themes**: User-created themes with validation and contrast checking

### Accessibility Features

- **WCAG Compliance**: Automatic contrast ratio validation (AA/AAA levels)
- **High Contrast Mode**: Enhanced visibility for users with visual impairments
- **Font Scaling**: Respect platform font size preferences
- **Motion Reduction**: Honor prefers-reduced-motion for animations
- **Screen Reader Support**: Semantic labels for theme states

### Advanced Features

- **Theme Import/Export**: JSON-based theme configuration sharing
- **Localization Support**: RTL layouts, language-specific fonts
- **Performance Optimization**: Fine-grained rebuilds, token memoization
- **Version Migration**: Automatic upgrade of saved theme configs
- **Visual Regression Testing**: Golden test support for theme consistency

## Documentation

### Core Documentation

- **[ARCHITECTURE.md](docs/ARCHITECTURE.md)**: Complete system architecture, components, and interaction flows
- **[API_CONTRACTS.md](docs/API_CONTRACTS.md)**: Detailed API surface for all services and components
- **[DESIGN_TOKENS.md](docs/DESIGN_TOKENS.md)**: Complete token catalog and usage guidelines

### Integration & Usage

- **[INTEGRATION_GUIDE.md](docs/INTEGRATION_GUIDE.md)**: Step-by-step integration with state management solutions
- **[THEMING_GUIDE.md](docs/THEMING_GUIDE.md)**: Component theming, customization, and extension patterns
- **[ACCESSIBILITY_GUIDE.md](docs/ACCESSIBILITY_GUIDE.md)**: Accessibility requirements and testing

### Testing & Maintenance

- **[TESTING_GUIDE.md](docs/TESTING_GUIDE.md)**: Unit, widget, and visual regression testing strategies
- **[MIGRATION_GUIDE.md](docs/MIGRATION_GUIDE.md)**: Version management and upgrade paths
- **[FOLDER_STRUCTURE.md](docs/FOLDER_STRUCTURE.md)**: Recommended project organization

## Architecture Overview

### High-Level Components

```
┌─────────────────────────────────────────────────────────────┐
│                        Flutter App                           │
│  ┌────────────────────────────────────────────────────────┐ │
│  │              UI Layer (Widgets)                        │ │
│  │  • ThemedButton  • ThemedCard  • ThemedAppBar         │ │
│  │  • Consumes tokens via ThemeService.instance          │ │
│  └────────────────────────────────────────────────────────┘ │
│                           ▲                                  │
│                           │ observes                         │
│  ┌────────────────────────┴───────────────────────────────┐ │
│  │              ThemeObserver / Provider                  │ │
│  │  • Listens to ThemeService.themeStream                │ │
│  │  • Rebuilds widget tree on theme changes              │ │
│  └────────────────────────────────────────────────────────┘ │
│                           ▲                                  │
│                           │ notifies                         │
│  ┌────────────────────────┴───────────────────────────────┐ │
│  │                   ThemeService                         │ │
│  │  • Singleton managing current theme state             │ │
│  │  • Exposes: currentTheme, tokens, setTheme(), stream  │ │
│  │  • Validates theme changes, emits events              │ │
│  └────────────────────────────────────────────────────────┘ │
│       ▲                   ▲                   ▲              │
│       │                   │                   │              │
│  ┌────┴──────┐  ┌─────────┴────────┐  ┌──────┴──────┐      │
│  │ Theme     │  │  DesignTokens    │  │  Theme      │      │
│  │ Repository│  │  • ColorTokens   │  │  Presets    │      │
│  │ • Load    │  │  • Typography    │  │  • Light    │      │
│  │ • Save    │  │  • Spacing       │  │  • Dark     │      │
│  │ • Persist │  │  • Radii, etc.   │  │  • Custom   │      │
│  └───────────┘  └──────────────────┘  └─────────────┘      │
│       ▲                                                      │
│       │                                                      │
│  ┌────┴──────────────────┐                                  │
│  │  PersistenceAdapter   │                                  │
│  │  • SharedPreferences  │                                  │
│  │  • Hive / Local DB    │                                  │
│  └───────────────────────┘                                  │
└─────────────────────────────────────────────────────────────┘
```

### Component Responsibilities

| Component | Purpose |
|-----------|---------|
| **ThemeService** | Central theme manager, exposes current theme, handles switching, emits change events |
| **DesignTokens** | Immutable token collections (colors, typography, spacing, etc.) |
| **ThemeRepository** | Loads/saves theme preferences, manages persistence adapter |
| **PersistenceAdapter** | Abstract interface for storage (SharedPreferences, Hive, etc.) |
| **ThemeObserver** | Widget that rebuilds on theme changes (similar to StreamBuilder) |
| **AppTheme** | Complete theme configuration (tokens + metadata like id, name, mode) |
| **ThemePresets** | Factory for built-in themes (light, dark, high-contrast, etc.) |
| **ThemeValidator** | Validates custom themes for contrast, completeness, accessibility |

## Usage Patterns

### Reading Current Theme Tokens

Access design tokens anywhere in your app:

```
Flow:
1. Widget needs color for background
2. Access: ThemeService.instance.tokens.colors.surface
3. Apply to widget: Container(color: surfaceColor)

Token categories available:
- colors.primary, colors.onPrimary, colors.error, etc.
- typography.h1, typography.body1, typography.caption, etc.
- spacing.xs, spacing.sm, spacing.md, spacing.lg, spacing.xl
- radii.sm, radii.md, radii.lg, radii.circle
- elevations.none, elevations.low, elevations.medium, elevations.high
```

### Switching Themes at Runtime

Allow users to change themes instantly:

```
Flow:
1. User taps "Dark Mode" button
2. Call: ThemeService.instance.setTheme(AppThemeMode.dark)
3. ThemeService:
   a. Loads dark theme preset
   b. Validates theme
   c. Updates internal state
   d. Emits event on themeStream
   e. Saves preference via ThemeRepository
4. ThemeObserver receives event
5. Widget tree rebuilds with new tokens
6. UI reflects dark theme instantly
```

### Custom Accent Color

Apply user-selected accent color:

```
Flow:
1. User picks custom color from color picker
2. Validate: ThemeValidator.checkContrast(selectedColor, background)
3. If valid, call: ThemeService.instance.setCustomAccent(selectedColor)
4. ThemeService creates theme variant with new accent
5. Updates primary, primaryVariant, and dependent colors
6. Emits theme change event
7. UI rebuilds with new accent throughout app
```

### Scoped Theme Override

Override theme for specific widget subtree:

```
Flow:
1. Specific screen needs custom styling (e.g., marketing splash)
2. Wrap screen with: ThemeScopeProvider(overrides: {...})
3. Override specific tokens: colors.primary = customColor
4. Child widgets inherit base theme + overrides
5. When navigating away, scope is disposed
6. App returns to base theme automatically

Use cases:
- Feature-specific branding
- Third-party module integration
- A/B testing variants
- Per-tenant customization
```

## Default Behavior

### Initial Theme Selection Priority

1. **Saved User Preference**: If user previously selected a theme, use it
2. **System Theme**: If no saved preference, follow system (light/dark)
3. **Default Light**: If system theme unavailable, fallback to light theme

### Persistence

- Theme preference saved immediately on user change
- Restored on app launch before first frame
- Graceful fallback if saved theme no longer exists (deleted preset)

## Platform Support

- **Android**: Full support, Material 3 dynamic colors
- **iOS**: Full support, respects system dark mode
- **Web**: Full support, respects prefers-color-scheme
- **macOS/Windows/Linux**: Full support with system theme detection

## Best Practices

### Performance

- Use `ThemeObserver` only at top-level widget tree to minimize rebuilds
- Access tokens via selectors for fine-grained updates
- Avoid rebuilding entire tree on theme change
- Use `const` widgets where possible
- Memoize expensive token computations

### Accessibility

- Always validate custom theme contrast ratios
- Test with platform font scaling (100%-200%)
- Provide high-contrast theme preset
- Support motion reduction preferences
- Test with screen readers

### Customization

- Prefer semantic tokens over raw colors
- Extend presets rather than creating from scratch
- Validate all custom themes before allowing user to save
- Provide theme preview before applying
- Allow export/import for backup and sharing

## Security & Privacy

### Data Handling

- Theme preferences stored locally by default
- No sensitive data in theme configs
- If syncing to server, make opt-in and provide conflict resolution
- Allow users to delete saved preferences

### Custom Theme Validation

- Sanitize user-provided color values
- Validate JSON imports for schema compliance
- Prevent injection attacks in theme names/metadata
- Rate-limit theme switching to prevent abuse

## Migration & Versioning

### Theme Config Schema Versioning

- All saved themes include schema version number
- Automatic migration on version mismatch
- Backward compatibility for at least 2 major versions
- Graceful degradation if migration fails

### Token Evolution

- Add new tokens without breaking existing themes
- Deprecated tokens provide fallback to new equivalents
- Migration guide for app updates
- Semantic versioning for theming module

## Contributing

When extending the theming system:

1. Maintain backward compatibility
2. Add new tokens to all presets
3. Update documentation
4. Provide migration path
5. Test accessibility impact
6. Update visual regression tests

## License

MIT License - See LICENSE file

## Support

For issues and questions:
- Review documentation in `docs/` folder
- Check [TESTING_GUIDE.md](docs/TESTING_GUIDE.md) for debugging
- See [INTEGRATION_GUIDE.md](docs/INTEGRATION_GUIDE.md) for common patterns

## Next Steps

1. Read [ARCHITECTURE.md](docs/ARCHITECTURE.md) for detailed system design
2. Review [API_CONTRACTS.md](docs/API_CONTRACTS.md) for API surface
3. Study [DESIGN_TOKENS.md](docs/DESIGN_TOKENS.md) for token specifications
4. Follow [INTEGRATION_GUIDE.md](docs/INTEGRATION_GUIDE.md) to integrate with your app
5. Implement using patterns from [THEMING_GUIDE.md](docs/THEMING_GUIDE.md)

---

**Version**: 1.0.0
**Last Updated**: 2025-11-13
**Status**: Production-Ready Design Specification
