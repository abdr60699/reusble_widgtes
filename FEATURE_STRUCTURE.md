# Feature-Based Architecture Guide

**One folder per feature. Everything related to that feature stays inside.**

This guide shows how to organize your Flutter app with self-contained feature modules where all code, UI, tests, and documentation for a feature live in one folder.

## Why Feature-Based Architecture?

### Problems with Traditional Structure:
```
❌ Traditional (Messy):
lib/
├─ services/
│  ├─ auth_service.dart
│  ├─ fcm_service.dart
│  └─ connectivity_service.dart
├─ models/
│  ├─ user.dart
│  ├─ notification.dart
│  └─ connection_state.dart
├─ screens/
│  ├─ login/
│  ├─ home/
│  └─ settings/
└─ widgets/
   ├─ auth_widgets/
   └─ shared/

Problems:
- Auth code spread across 4+ folders
- Hard to find all related files
- Difficult to test one feature
- Can't reuse feature in another app
- Unclear dependencies
```

### Feature-Based Solution:
```
✅ Feature-Based (Clean):
lib/
├─ features/
│  ├─ supabase_auth/          ← Everything auth-related here
│  ├─ fcm/                    ← Everything FCM-related here
│  ├─ connectivity_hive/      ← Everything connectivity-related here
│  └─ theme/                  ← Everything theme-related here
├─ core/                      ← Shared utilities only
└─ main.dart

Benefits:
- All auth code in one folder
- Easy to find everything
- Easy to test entire feature
- Can copy folder to another app
- Clear dependencies
```

---

## Complete Feature Folder Structure

### General Pattern

```
lib/features/<feature_name>/
├─ README.md                      ← Feature overview, setup, usage
├─ <feature_name>.dart            ← Public API (exports everything public)
├─ models/                        ← Data models
│  ├─ user_model.dart
│  └─ auth_result.dart
├─ services/                      ← Business logic
│  └─ <feature>_service.dart
├─ repository/                    ← Data layer
│  └─ <feature>_repository.dart
├─ ui/                            ← Screens
│  ├─ sign_in_screen.dart
│  └─ sign_up_screen.dart
├─ widgets/                       ← Reusable widgets for this feature
│  ├─ auth_button.dart
│  └─ password_field.dart
├─ providers/                     ← State management (Provider/Riverpod/Bloc)
│  └─ auth_provider.dart
├─ utils/                         ← Feature-specific utilities
│  └─ validators.dart
├─ constants/                     ← Feature-specific constants
│  └─ auth_constants.dart
├─ tests/                         ← All tests for this feature
│  ├─ services_test.dart
│  └─ ui_test.dart
└─ assets/                        ← Feature-specific assets (optional)
   └─ icons/
```

---

## Feature Examples

### 1. Supabase Auth Feature

```
lib/features/supabase_auth/
├─ README.md                              ← Setup, configuration, usage
├─ supabase_auth.dart                     ← Public exports
│
├─ models/
│  ├─ user_profile.dart                   ← User data model
│  ├─ auth_result.dart                    ← Sign-in/sign-up result
│  └─ auth_error.dart                     ← Error models
│
├─ services/
│  ├─ supabase_auth_service.dart          ← Main auth service
│  └─ token_manager.dart                  ← Token management
│
├─ repository/
│  └─ supabase_auth_repository.dart       ← Auth data persistence
│
├─ ui/
│  ├─ sign_in_screen.dart                 ← Sign-in UI
│  ├─ sign_up_screen.dart                 ← Sign-up UI
│  ├─ forgot_password_screen.dart         ← Password reset UI
│  ├─ profile_screen.dart                 ← User profile UI
│  └─ magic_link_screen.dart              ← Magic link UI
│
├─ widgets/
│  ├─ auth_text_field.dart                ← Custom text field
│  ├─ oauth_button.dart                   ← OAuth provider button
│  ├─ password_strength_indicator.dart    ← Password strength
│  └─ email_verification_banner.dart      ← Verification prompt
│
├─ providers/
│  ├─ auth_provider.dart                  ← Provider wrapper
│  ├─ auth_notifier.dart                  ← Riverpod notifier
│  └─ auth_bloc.dart                      ← Bloc (if using Bloc)
│
├─ utils/
│  ├─ validators.dart                     ← Email/password validation
│  └─ error_mapper.dart                   ← Error code to message
│
├─ constants/
│  └─ supabase_constants.dart             ← Supabase URLs, keys
│
├─ tests/
│  ├─ services/
│  │  └─ supabase_auth_service_test.dart
│  ├─ ui/
│  │  └─ sign_in_screen_test.dart
│  └─ utils/
│     └─ validators_test.dart
│
└─ assets/
   └─ icons/
      ├─ google_logo.png
      └─ apple_logo.png
```

**Public Export File** (`supabase_auth.dart`):
```
Export only public APIs:

export 'services/supabase_auth_service.dart';
export 'models/user_profile.dart';
export 'models/auth_result.dart';
export 'ui/sign_in_screen.dart';
export 'ui/sign_up_screen.dart';
export 'providers/auth_provider.dart';

Do NOT export:
- Internal utilities
- Private models
- Test files
```

---

### 2. Firebase Auth Feature

```
lib/features/firebase_auth/
├─ README.md
├─ firebase_auth.dart                     ← Public exports
│
├─ models/
│  ├─ firebase_user.dart
│  ├─ auth_credential.dart
│  └─ auth_state.dart
│
├─ services/
│  ├─ firebase_auth_service.dart          ← Main service
│  ├─ google_sign_in_service.dart         ← Google OAuth
│  ├─ apple_sign_in_service.dart          ← Apple OAuth
│  └─ phone_auth_service.dart             ← Phone OTP
│
├─ repository/
│  └─ firebase_auth_repository.dart       ← Session persistence
│
├─ ui/
│  ├─ sign_in_screen.dart
│  ├─ sign_up_screen.dart
│  ├─ phone_verification_screen.dart
│  ├─ password_reset_screen.dart
│  └─ profile_screen.dart
│
├─ widgets/
│  ├─ social_sign_in_button.dart          ← Google/Apple/Facebook button
│  ├─ phone_input.dart                    ← Phone number input
│  └─ otp_input.dart                      ← OTP code input
│
├─ providers/
│  └─ firebase_auth_provider.dart
│
├─ utils/
│  ├─ auth_validators.dart
│  └─ error_handler.dart
│
├─ constants/
│  └─ firebase_constants.dart
│
└─ tests/
   └─ ...
```

---

### 3. FCM Notifications Feature

```
lib/features/fcm/
├─ README.md
├─ fcm.dart                               ← Public exports
│
├─ models/
│  ├─ push_notification.dart              ← Notification model
│  ├─ fcm_config.dart                     ← Configuration
│  └─ notification_payload.dart           ← Data payload
│
├─ services/
│  ├─ fcm_service.dart                    ← Main FCM service
│  ├─ notification_handler.dart           ← Handle notifications
│  └─ topic_manager.dart                  ← Topic subscriptions
│
├─ repository/
│  └─ fcm_repository.dart                 ← Token persistence
│
├─ ui/
│  ├─ notification_settings_screen.dart   ← Settings UI
│  └─ notification_history_screen.dart    ← History UI
│
├─ widgets/
│  ├─ notification_banner.dart            ← In-app notification
│  └─ notification_list_item.dart         ← History item
│
├─ providers/
│  └─ fcm_provider.dart
│
├─ utils/
│  ├─ notification_builder.dart           ← Build local notifications
│  └─ deep_link_handler.dart              ← Handle notification taps
│
├─ constants/
│  └─ fcm_constants.dart                  ← Channel IDs, defaults
│
└─ tests/
   └─ ...
```

---

### 4. Connectivity + Offline Feature

```
lib/features/connectivity_hive/
├─ README.md
├─ connectivity_hive.dart                 ← Public exports
│
├─ models/
│  ├─ connection_state.dart               ← Connection status
│  ├─ cached_response.dart                ← Cache entry
│  └─ offline_request.dart                ← Queued request
│
├─ services/
│  ├─ connectivity_service.dart           ← Monitor connectivity
│  ├─ cache_service.dart                  ← Hive caching
│  └─ offline_queue_service.dart          ← Request queue
│
├─ repository/
│  ├─ connectivity_repository.dart        ← Connection data
│  └─ cache_repository.dart               ← Cache persistence
│
├─ ui/
│  ├─ connection_status_banner.dart       ← Online/offline banner
│  └─ offline_screen.dart                 ← Offline fallback
│
├─ widgets/
│  ├─ connection_indicator.dart           ← WiFi/mobile/offline icon
│  └─ sync_button.dart                    ← Manual sync
│
├─ providers/
│  └─ connectivity_provider.dart
│
├─ utils/
│  ├─ cache_strategy.dart                 ← FIFO, LRU, LFU, TTL
│  └─ retry_policy.dart                   ← Exponential backoff
│
├─ constants/
│  └─ connectivity_constants.dart
│
└─ tests/
   └─ ...
```

---

### 5. Theme System Feature

```
lib/features/theme/
├─ README.md
├─ theme.dart                             ← Public exports
│
├─ models/
│  ├─ app_theme.dart                      ← Theme model
│  ├─ design_tokens.dart                  ← Tokens
│  ├─ color_tokens.dart                   ← Color tokens
│  └─ typography_tokens.dart              ← Typography tokens
│
├─ services/
│  ├─ theme_service.dart                  ← Theme management
│  ├─ theme_validator.dart                ← Validate themes
│  └─ theme_presets.dart                  ← Built-in themes
│
├─ repository/
│  └─ theme_repository.dart               ← Theme persistence
│
├─ ui/
│  ├─ theme_settings_screen.dart          ← Theme picker UI
│  ├─ custom_theme_screen.dart            ← Create custom theme
│  └─ theme_preview_screen.dart           ← Preview theme
│
├─ widgets/
│  ├─ theme_switcher.dart                 ← Quick switch button
│  ├─ color_picker.dart                   ← Custom color picker
│  ├─ themed_button.dart                  ← Button with theme
│  └─ themed_card.dart                    ← Card with theme
│
├─ providers/
│  ├─ theme_provider.dart                 ← Provider wrapper
│  └─ theme_notifier.dart                 ← Riverpod notifier
│
├─ utils/
│  ├─ color_utils.dart                    ← Color calculations
│  └─ contrast_checker.dart               ← WCAG compliance
│
├─ constants/
│  └─ theme_constants.dart                ← Default values
│
└─ tests/
   └─ ...
```

---

### 6. Social Auth Feature

```
lib/features/social_auth/
├─ README.md
├─ social_auth.dart                       ← Public exports
│
├─ models/
│  ├─ social_user.dart                    ← Social profile
│  ├─ social_provider.dart                ← Provider enum
│  └─ oauth_result.dart                   ← OAuth result
│
├─ services/
│  ├─ social_auth_service.dart            ← Main service
│  ├─ google_auth_service.dart            ← Google-specific
│  ├─ apple_auth_service.dart             ← Apple-specific
│  └─ facebook_auth_service.dart          ← Facebook-specific
│
├─ repository/
│  └─ social_auth_repository.dart         ← OAuth data
│
├─ ui/
│  ├─ social_sign_in_screen.dart          ← Social sign-in UI
│  └─ account_linking_screen.dart         ← Link providers UI
│
├─ widgets/
│  ├─ google_sign_in_button.dart          ← Google button
│  ├─ apple_sign_in_button.dart           ← Apple button
│  └─ facebook_sign_in_button.dart        ← Facebook button
│
├─ providers/
│  └─ social_auth_provider.dart
│
├─ utils/
│  └─ provider_config.dart                ← OAuth configs
│
├─ constants/
│  └─ social_constants.dart
│
└─ tests/
   └─ ...
```

---

## Core Folder (Shared Only)

```
lib/core/
├─ config/
│  ├─ app_config.dart                     ← App-wide configuration
│  └─ environment.dart                    ← Dev/prod environments
│
├─ network/
│  ├─ http_client.dart                    ← Shared HTTP client
│  └─ api_endpoints.dart                  ← API URLs
│
├─ logging/
│  └─ logger.dart                         ← App-wide logging
│
├─ utils/
│  ├─ date_utils.dart                     ← Date formatting
│  └─ string_utils.dart                   ← String helpers
│
├─ constants/
│  └─ app_constants.dart                  ← App-wide constants
│
└─ widgets/
   ├─ loading_indicator.dart              ← Shared loading
   └─ error_widget.dart                   ← Shared error display
```

**Rule**: Only put truly shared code in `core/`. If it's specific to one feature, it goes in that feature's folder.

---

## Main App File

```
lib/main.dart
```

**Purpose**: App entry point, initialization, routing setup

**What Goes Here**:
- Firebase initialization
- Dependency injection setup
- Root widget (MaterialApp/CupertinoApp)
- Global providers
- Route configuration

**What Does NOT Go Here**:
- Feature-specific code (goes in features/)
- Business logic (goes in feature services/)
- UI screens (go in feature ui/)

---

## Usage in Your App

### Importing a Feature

```dart
// Import the entire feature
import 'package:your_app/features/supabase_auth/supabase_auth.dart';

// Now use the public APIs
final authService = SupabaseAuthService.instance;
await authService.signIn(email, password);

// Navigate to a feature screen
Navigator.push(context, SignInScreen());
```

### Feature Independence

Each feature should:
- ✅ Be self-contained (all code in one folder)
- ✅ Have a clear public API (exported via main .dart file)
- ✅ Have its own tests
- ✅ Have its own README
- ✅ Not depend on other features directly
- ✅ Use core/ for shared utilities only

### Feature Dependencies

If Feature A needs Feature B:
```
Bad: Direct dependency
  lib/features/profile/
    ├─ profile_service.dart
        imports '../supabase_auth/services/auth_service.dart'  ❌

Good: Through public API
  lib/features/profile/
    ├─ profile_service.dart
        imports '../supabase_auth/supabase_auth.dart'  ✅
```

Or better: Use dependency injection
```
ProfileService depends on IAuthService (interface)
Inject SupabaseAuthService at runtime
```

---

## Reusing Features Across Apps

### Copying a Feature to Another App

```bash
# Copy entire feature folder
cp -r app1/lib/features/supabase_auth app2/lib/features/

# Feature works immediately (self-contained)
```

### Converting Feature to Package

```
1. Create new package:
   flutter create --template=package supabase_auth_package

2. Copy feature folder contents to package lib/:
   cp -r lib/features/supabase_auth/* supabase_auth_package/lib/

3. Update pubspec.yaml with dependencies

4. Use in any app:
   dependencies:
     supabase_auth_package:
       path: ../supabase_auth_package
```

---

## Testing

### Test Organization

```
lib/features/supabase_auth/
  tests/
    ├─ services/
    │  └─ supabase_auth_service_test.dart    ← Service unit tests
    ├─ models/
    │  └─ user_profile_test.dart             ← Model tests
    ├─ ui/
    │  └─ sign_in_screen_test.dart           ← Widget tests
    ├─ integration/
    │  └─ auth_flow_test.dart                ← Integration tests
    └─ mocks/
       └─ mock_supabase_client.dart          ← Mocks for testing
```

### Running Feature Tests

```bash
# Test entire feature
flutter test lib/features/supabase_auth/tests/

# Test specific file
flutter test lib/features/supabase_auth/tests/services/supabase_auth_service_test.dart
```

---

## README Per Feature

Each feature should have a README explaining:

1. **What it does**: Brief description
2. **Setup**: Configuration needed
3. **Usage**: How to use the public API
4. **Dependencies**: What it needs
5. **Testing**: How to test
6. **Examples**: Code samples

**Example** (`lib/features/supabase_auth/README.md`):
```markdown
# Supabase Authentication Feature

Complete authentication using Supabase.

## Features
- Email/password sign-in/sign-up
- Magic link (passwordless)
- OAuth (Google, Apple, GitHub)
- Password reset
- Email verification

## Setup
1. Add to pubspec.yaml: supabase_flutter: ^1.10.0
2. Initialize in main.dart: await Supabase.initialize(...)
3. Configure Supabase dashboard (enable providers)

## Usage
```dart
import 'package:your_app/features/supabase_auth/supabase_auth.dart';

// Sign in
final result = await SupabaseAuthService.instance.signIn(email, password);

// Navigate to sign-in screen
Navigator.push(context, SignInScreen());
```

## Testing
```bash
flutter test lib/features/supabase_auth/tests/
```

## Dependencies
- supabase_flutter: ^1.10.0
- flutter_secure_storage: ^8.0.0 (for token storage)
```

---

## Migration from Traditional Structure

### Before (Traditional):
```
lib/
├─ services/
│  ├─ auth_service.dart
│  └─ cache_service.dart
├─ models/
│  ├─ user.dart
│  └─ cached_item.dart
├─ screens/
│  └─ auth/
│     ├─ login.dart
│     └─ signup.dart
└─ widgets/
   └─ auth_widgets/
```

### After (Feature-Based):
```
lib/
└─ features/
   ├─ supabase_auth/
   │  ├─ services/
   │  │  └─ supabase_auth_service.dart
   │  ├─ models/
   │  │  └─ user.dart
   │  ├─ ui/
   │  │  ├─ login_screen.dart
   │  │  └─ signup_screen.dart
   │  └─ widgets/
   │     └─ auth_button.dart
   └─ connectivity_hive/
      ├─ services/
      │  └─ cache_service.dart
      └─ models/
         └─ cached_item.dart
```

### Migration Steps:

1. Create feature folders: `lib/features/<feature_name>/`
2. Move all related files to feature folder
3. Update imports
4. Create public export file
5. Test feature independently
6. Repeat for each feature

---

## Benefits

### ✅ Easy to Find
All auth code in `lib/features/supabase_auth/`

### ✅ Easy to Update
Change only files in one folder

### ✅ Easy to Test
Test entire feature: `flutter test lib/features/supabase_auth/`

### ✅ Easy to Reuse
Copy folder to another app

### ✅ Clear Boundaries
Features don't cross into each other

### ✅ Scalable
Add new features without affecting existing

### ✅ Team-Friendly
Different developers work on different features

---

## Summary

**One Rule**: Everything for a feature stays in that feature's folder.

**Structure**:
```
lib/features/<feature_name>/
  ├─ README.md               ← How to use this feature
  ├─ <feature_name>.dart     ← Public API exports
  ├─ models/                 ← Data models
  ├─ services/               ← Business logic
  ├─ repository/             ← Data layer
  ├─ ui/                     ← Screens
  ├─ widgets/                ← Feature widgets
  ├─ providers/              ← State management
  ├─ utils/                  ← Feature utilities
  ├─ constants/              ← Feature constants
  ├─ tests/                  ← All tests
  └─ assets/                 ← Feature assets
```

**Result**: Clean, maintainable, scalable, reusable code.

---

That's it! Keep each feature in its own folder and your app stays organized no matter how large it grows.
