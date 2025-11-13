# Folder Structure

Recommended project organization for the theming system.

## Table of Contents

1. [Module Structure](#module-structure)
2. [App Integration Structure](#app-integration-structure)
3. [File Naming Conventions](#file-naming-conventions)
4. [Organization Principles](#organization-principles)

---

## Module Structure

### Complete Module Tree

```
flutter_theming/
├── lib/
│   ├── src/
│   │   ├── models/
│   │   │   ├── app_theme.dart
│   │   │   ├── design_tokens.dart
│   │   │   ├── color_tokens.dart
│   │   │   ├── typography_tokens.dart
│   │   │   ├── spacing_tokens.dart
│   │   │   ├── radii_tokens.dart
│   │   │   ├── elevation_tokens.dart
│   │   │   ├── icon_tokens.dart
│   │   │   ├── motion_tokens.dart
│   │   │   ├── opacity_tokens.dart
│   │   │   └── validation_result.dart
│   │   │
│   │   ├── services/
│   │   │   ├── theme_service.dart
│   │   │   ├── theme_repository.dart
│   │   │   ├── theme_validator.dart
│   │   │   └── theme_presets.dart
│   │   │
│   │   ├── persistence/
│   │   │   ├── persistence_adapter.dart (interface)
│   │   │   ├── shared_preferences_adapter.dart
│   │   │   ├── hive_adapter.dart
│   │   │   └── in_memory_adapter.dart
│   │   │
│   │   ├── widgets/
│   │   │   ├── theme_observer.dart
│   │   │   ├── theme_scope_provider.dart
│   │   │   └── themed_components/
│   │   │       ├── themed_button.dart
│   │   │       ├── themed_card.dart
│   │   │       ├── themed_input.dart
│   │   │       └── themed_app_bar.dart
│   │   │
│   │   ├── state_management/
│   │   │   ├── theme_provider.dart (Provider)
│   │   │   ├── theme_notifier.dart (Riverpod)
│   │   │   ├── theme_bloc.dart (Bloc)
│   │   │   └── theme_controller.dart (GetIt)
│   │   │
│   │   ├── utils/
│   │   │   ├── color_utils.dart (contrast calculation, color manipulation)
│   │   │   ├── migration_utils.dart (schema migration helpers)
│   │   │   └── platform_utils.dart (platform theme detection)
│   │   │
│   │   └── constants/
│   │       ├── theme_constants.dart (version, keys)
│   │       └── wcag_constants.dart (contrast thresholds)
│   │
│   └── flutter_theming.dart (public API exports)
│
├── test/
│   ├── models/
│   │   ├── app_theme_test.dart
│   │   └── design_tokens_test.dart
│   │
│   ├── services/
│   │   ├── theme_service_test.dart
│   │   ├── theme_repository_test.dart
│   │   └── theme_validator_test.dart
│   │
│   ├── persistence/
│   │   └── adapters_test.dart
│   │
│   ├── widgets/
│   │   ├── theme_observer_test.dart
│   │   └── themed_components_test.dart
│   │
│   ├── utils/
│   │   └── color_utils_test.dart
│   │
│   └── integration/
│       ├── theme_switching_test.dart
│       └── migration_test.dart
│
├── example/
│   ├── lib/
│   │   ├── main.dart
│   │   ├── screens/
│   │   │   ├── home_screen.dart
│   │   │   ├── theme_settings_screen.dart
│   │   │   └── theme_preview_screen.dart
│   │   └── widgets/
│   │       ├── theme_switcher.dart
│   │       ├── theme_picker.dart
│   │       └── accent_color_picker.dart
│   │
│   ├── assets/
│   │   └── screenshots/
│   │       ├── light_theme.png
│   │       └── dark_theme.png
│   │
│   └── pubspec.yaml
│
├── docs/
│   ├── ARCHITECTURE.md
│   ├── API_CONTRACTS.md
│   ├── DESIGN_TOKENS.md
│   ├── INTEGRATION_GUIDE.md
│   ├── THEMING_GUIDE.md
│   ├── ACCESSIBILITY_GUIDE.md
│   ├── TESTING_GUIDE.md
│   ├── MIGRATION_GUIDE.md
│   └── FOLDER_STRUCTURE.md (this file)
│
├── README.md
├── CHANGELOG.md
├── LICENSE
├── pubspec.yaml
└── .gitignore
```

### Purpose of Each Folder

**lib/src/models/**:
- Data classes and models
- Immutable structures
- No business logic
- Serialization/deserialization
- Examples: AppTheme, DesignTokens, ColorTokens

**lib/src/services/**:
- Business logic and orchestration
- Theme management, validation, presets
- Singleton or factory patterns
- Examples: ThemeService, ThemeRepository

**lib/src/persistence/**:
- Storage adapters
- Abstract interface + implementations
- Platform-specific code isolated here
- Examples: SharedPreferences, Hive, InMemory

**lib/src/widgets/**:
- Flutter widgets
- Theme observation and scoping
- Themed component library
- Examples: ThemeObserver, ThemedButton

**lib/src/state_management/**:
- Adapters for state management frameworks
- Provider, Riverpod, Bloc, GetIt wrappers
- Optional, import only if needed

**lib/src/utils/**:
- Helper functions
- Pure functions, no state
- Examples: Color contrast calculation, migration logic

**lib/src/constants/**:
- Constant values
- Configuration defaults
- Schema versions, storage keys

**test/**:
- Mirrors lib/ structure
- Unit tests for all components
- Integration tests for flows

**example/**:
- Working demo app
- Shows all features
- Reference implementation

**docs/**:
- Comprehensive documentation
- Architecture, API, guides

---

## App Integration Structure

### Recommended App Structure

```
your_app/
├── lib/
│   ├── main.dart
│   │
│   ├── app/
│   │   ├── app.dart (MyApp widget)
│   │   └── theme/
│   │       ├── app_theme_config.dart (app-specific theme setup)
│   │       ├── custom_presets.dart (app-specific theme presets)
│   │       └── component_themes/ (app-specific component themes)
│   │           ├── button_theme.dart
│   │           └── card_theme.dart
│   │
│   ├── core/
│   │   ├── di/
│   │   │   └── service_locator.dart (DI setup, theme service registration)
│   │   │
│   │   └── constants/
│   │       └── app_theme_keys.dart (app-specific theme constants)
│   │
│   ├── features/
│   │   ├── home/
│   │   │   ├── screens/
│   │   │   │   └── home_screen.dart
│   │   │   └── widgets/
│   │   │       └── home_widget.dart
│   │   │
│   │   ├── settings/
│   │   │   ├── screens/
│   │   │   │   └── settings_screen.dart
│   │   │   └── widgets/
│   │   │       ├── theme_settings_section.dart
│   │   │       ├── theme_switcher_tile.dart
│   │   │       └── accent_picker_dialog.dart
│   │   │
│   │   └── profile/
│   │       └── ... (other features)
│   │
│   └── shared/
│       ├── widgets/
│       │   ├── themed_components/
│       │   │   ├── app_button.dart (uses theming)
│       │   │   ├── app_card.dart (uses theming)
│       │   │   └── app_input.dart (uses theming)
│       │   │
│       │   └── common/
│       │       └── loading_indicator.dart
│       │
│       └── utils/
│           └── theme_utils.dart (app-specific theme helpers)
│
└── pubspec.yaml (includes flutter_theming dependency)
```

### Key Integration Files

**lib/main.dart**:
```
Purpose: App entry point
Responsibilities:
  - Initialize Flutter binding
  - Setup dependency injection
  - Initialize ThemeService
  - Run app with theme providers
```

**lib/app/app.dart**:
```
Purpose: Root widget
Responsibilities:
  - Wrap with theme observer/provider
  - Build MaterialApp with theme
  - Setup navigation
```

**lib/core/di/service_locator.dart**:
```
Purpose: Dependency injection setup
Responsibilities:
  - Register PersistenceAdapter
  - Register ThemeRepository
  - Register ThemeValidator
  - Register ThemeService
  - Initialize all services
```

**lib/app/theme/app_theme_config.dart**:
```
Purpose: App-specific theme configuration
Responsibilities:
  - Map tokens to Material ThemeData
  - Define app-specific presets
  - Component theme builders
```

**lib/features/settings/widgets/theme_settings_section.dart**:
```
Purpose: User-facing theme controls
Responsibilities:
  - Theme mode switcher
  - Preset selector
  - Custom accent picker
  - Theme preview
```

---

## File Naming Conventions

### General Rules

**Class Files**: `snake_case.dart`
```
Examples:
  - theme_service.dart (class: ThemeService)
  - app_theme.dart (class: AppTheme)
  - design_tokens.dart (class: DesignTokens)
```

**Test Files**: `<name>_test.dart`
```
Examples:
  - theme_service_test.dart
  - app_theme_test.dart
  - design_tokens_test.dart
```

**Widget Files**: `<widget_name>.dart`
```
Examples:
  - theme_observer.dart
  - themed_button.dart
  - accent_color_picker.dart
```

**Screen Files**: `<screen_name>_screen.dart`
```
Examples:
  - home_screen.dart
  - theme_settings_screen.dart
  - theme_preview_screen.dart
```

### Class Naming

**Services**: `<Name>Service`
```
Examples:
  - ThemeService
  - AuthService
  - ApiService
```

**Repositories**: `<Name>Repository`
```
Examples:
  - ThemeRepository
  - UserRepository
```

**Models**: `<Name>` (no suffix)
```
Examples:
  - AppTheme
  - DesignTokens
  - ColorTokens
```

**Widgets**: `<Name>` (no suffix) or `<Name>Widget`
```
Examples:
  - ThemeObserver
  - ThemedButton
  - AccentColorPicker
```

**Adapters**: `<Platform><Name>Adapter`
```
Examples:
  - SharedPreferencesPersistenceAdapter
  - HivePersistenceAdapter
```

**Controllers** (state management): `<Name>Controller` or `<Name>Notifier` or `<Name>Provider` or `<Name>Bloc`
```
Examples:
  - ThemeController (GetIt)
  - ThemeNotifier (Riverpod)
  - ThemeProvider (Provider)
  - ThemeBloc (Bloc)
```

---

## Organization Principles

### Separation of Concerns

**Models**: Data structures only
- No business logic
- Immutable
- Serialization methods only

**Services**: Business logic
- Orchestrate operations
- Coordinate between repositories, validators
- No UI code

**Widgets**: UI only
- Consume services via DI or state management
- Minimal logic (presentation only)
- No direct persistence access

**Repositories**: Data access abstraction
- Wrap persistence layer
- Convert between storage format and models
- No business logic

### Dependency Flow

```
Widgets
  ↓ depends on
Services
  ↓ depends on
Repositories / Validators
  ↓ depends on
Persistence Adapters / Models
  ↓ depends on
Platform APIs
```

**Rules**:
- Higher layers depend on lower layers
- Lower layers never depend on higher layers
- Use interfaces for testability

### Feature Organization

**Feature Folders**:
```
features/
  <feature_name>/
    screens/
    widgets/
    models/
    services/
```

**Benefits**:
- Encapsulation: All feature code together
- Modularity: Easy to add/remove features
- Clarity: Find feature code quickly

**Shared Code**:
```
shared/
  widgets/
  utils/
  constants/
```

Put code here if used by multiple features.

### Test Organization

**Mirror Production Structure**:
```
lib/src/services/theme_service.dart
  → test/services/theme_service_test.dart

lib/src/widgets/theme_observer.dart
  → test/widgets/theme_observer_test.dart
```

**Test Types**:
```
test/
  unit/           # Unit tests (pure logic)
  widget/         # Widget tests (UI components)
  integration/    # Integration tests (full flows)
  goldens/        # Golden file tests (visual regression)
```

---

## Summary

**Key Takeaways**:

1. **Clear Structure**: Organize by type (models, services, widgets)
2. **Separation**: Isolate business logic from UI
3. **Conventions**: Consistent naming and structure
4. **Testability**: Mirror production structure in tests
5. **Features**: Group related code together
6. **Shared**: Extract common code to shared folder
7. **Documentation**: Keep comprehensive docs in docs/

A well-organized structure makes the theming system maintainable, testable, and easy to understand for new developers.
