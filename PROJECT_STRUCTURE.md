# 📁 Project Structure - Feature-Oriented Architecture

This document describes the clean, feature-oriented structure of this Flutter project.

## 🎯 Architecture Philosophy

**Single Source of Truth**: One `pubspec.yaml` at project root only.
**Feature Isolation**: Each feature is self-contained in its own folder.
**Clear Boundaries**: Features don't cross-reference each other's internals.
**Easy Navigation**: All code for a feature is in one place.

---

## 📂 Directory Structure

```
reusable_widgets/
├── lib/
│   ├── features/              # All feature-specific code
│   │   ├── supabase_auth/     # Supabase authentication
│   │   ├── firebase_auth/     # Firebase auth documentation
│   │   ├── fcm/               # Firebase Cloud Messaging
│   │   ├── theme/             # Material 3 theme system
│   │   ├── connectivity_offline/  # Connectivity & offline support
│   │   ├── social_auth/       # Social authentication providers
│   │   └── shared_widgets/    # Reusable UI components
│   ├── core/                  # App-wide utilities only
│   │   ├── config/            # App configuration
│   │   └── utils/             # Shared utilities
│   └── main.dart              # App entry point
├── test/                      # App-level tests
├── android/                   # Android platform code
├── ios/                       # iOS platform code
├── web/                       # Web platform code
├── pubspec.yaml               # Single source of dependencies
└── backup/                    # Backup archives
    ├── modules-20251114.tar.gz
    └── lib-20251114.tar.gz
```

---

## 🎨 Feature Structure Pattern

Each feature follows this self-contained structure:

```
lib/features/<feature_name>/
├── <feature_name>.dart        # Public API (single entry point)
├── models/                    # Data models
├── services/                  # Business logic
├── repository/                # Data layer
├── ui/                        # Screens
├── widgets/                   # Feature-specific widgets
├── providers/                 # State management
├── utils/                     # Feature-specific utilities
├── constants/                 # Feature constants
├── tests/                     # Feature tests
├── README.md                  # Feature documentation
└── TELL_ME.md                 # Testing guide (optional)
```

---

## 📦 Features Overview

### 1. Supabase Auth (`lib/features/supabase_auth/`)
**Entry Point**: `supabase_auth.dart`
**Purpose**: Complete Supabase authentication implementation
**Includes**:
- Email/password auth
- Magic links
- OAuth providers (Google, Apple, Facebook)
- Session management
- Token storage

### 2. Firebase Auth (`lib/features/firebase_auth/`)
**Entry Point**: `firebase_auth.dart`
**Purpose**: Firebase authentication documentation
**Includes**:
- Implementation guides
- Testing instructions
- Best practices
**Note**: Documentation-only module

### 3. FCM (`lib/features/fcm/`)
**Entry Point**: `fcm_notifications.dart`
**Purpose**: Firebase Cloud Messaging integration
**Includes**:
- Push notification handling
- Topic subscriptions
- Token management
- Local notifications

### 4. Theme (`lib/features/theme/`)
**Entry Point**: `theme.dart`
**Purpose**: Material 3 design system
**Includes**:
- Color tokens (light/dark)
- Typography system
- Spacing tokens (8px grid)
- Border radius tokens
- Icon sizes & elevations
- Theme switching with persistence

### 5. Connectivity Offline (`lib/features/connectivity_offline/`)
**Entry Point**: `offline_support.dart`
**Purpose**: Network connectivity and offline support
**Includes**:
- Connectivity monitoring
- Hive-based caching
- Offline request queue
- Automatic sync

### 6. Social Auth (`lib/features/social_auth/`)
**Entry Point**: `social_auth.dart`
**Purpose**: Social authentication providers
**Includes**:
- Google Sign-In
- Apple Sign-In
- Facebook Login
- Adapter-based architecture

### 7. Shared Widgets (`lib/features/shared_widgets/`)
**Entry Point**: `shared_widgets.dart`
**Purpose**: Reusable UI components
**Includes**:
- 25+ reusable widgets
- Buttons, forms, navigation
- Consistent styling

---

## 📥 How to Use Features

### Import Pattern

**Always import the feature's public API (entry point file):**

```dart
// ✅ Correct: Import feature's public API
import 'package:reuablewidgets/features/theme/theme.dart';
import 'package:reuablewidgets/features/supabase_auth/supabase_auth.dart';
import 'package:reuablewidgets/features/shared_widgets/shared_widgets.dart';

// ❌ Wrong: Don't import internal files directly
import 'package:reuablewidgets/features/theme/theme_colors.dart';  // Don't do this
import 'package:reuablewidgets/features/supabase_auth/services/auth_service.dart';  // Don't do this
```

### Example Usage

```dart
import 'package:flutter/material.dart';
import 'package:reuablewidgets/features/theme/theme.dart';
import 'package:reuablewidgets/features/shared_widgets/shared_widgets.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      home: Scaffold(
        body: Padding(
          padding: ThemeSpacing.pageInsets,
          child: ReusableButton(
            text: 'Click Me',
            onPressed: () {},
          ),
        ),
      ),
    );
  }
}
```

---

## 🔧 Dependencies

All dependencies are managed in the **single root `pubspec.yaml`**.

### Categories:
- **Firebase**: Core, Auth, Messaging
- **Supabase**: Flutter client
- **Social Auth**: Google, Apple, Facebook
- **Offline/Storage**: Hive, Connectivity Plus, Shared Preferences
- **State Management**: Riverpod
- **UI**: Flutter SVG, Dynamic Color

---

## 🚀 Initialization Order

Features should be initialized in this order in `main.dart`:

```dart
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 1. Initialize Hive (required for offline support)
  await Hive.initFlutter();

  // 2. Register Hive adapters
  await OfflineSupport.registerHiveAdapters();

  // 3. Initialize offline support
  await OfflineSupport.initialize(
    config: OfflineConfig.production(),
  );

  // 4. Initialize theme controller
  final themeController = ThemeController();
  await themeController.initialize();

  // 5. Initialize Firebase (if using)
  // await Firebase.initializeApp();

  // 6. Initialize Supabase (if using)
  // await AuthRepository.initialize(SupabaseAuthConfig(...));

  runApp(
    ProviderScope(  // Required for Riverpod
      child: MyApp(),
    ),
  );
}
```

---

## 🧪 Testing

### Run All Tests
```bash
flutter test
```

### Test Specific Feature
```bash
flutter test test/features/theme_test.dart
```

---

## 📋 Migration Summary

### What Changed:
1. **Removed**: `modules/` folder (backed up to `backup/modules-20251114.tar.gz`)
2. **Removed**: Old scattered structure (`lib/theme/`, `lib/offline_support/`, `lib/social_auth/`, `lib/sharedwidget/`)
3. **Created**: New feature-based structure (`lib/features/`)
4. **Consolidated**: All dependencies in single root `pubspec.yaml`

### What Stayed:
1. **Root `pubspec.yaml`**: Single source of dependencies
2. **Platform folders**: android/, ios/, web/, etc.
3. **Tests**: Moved to feature folders where appropriate

---

## 🔄 Rollback Plan

If you need to rollback this refactoring:

```bash
# 1. Checkout previous branch
git checkout claude/add-missing-shared-widgets-011CV4zViPkco75PcRY7MFvr

# 2. Or restore from backups
tar -xzf backup/modules-20251114.tar.gz
tar -xzf backup/lib-20251114.tar.gz
```

---

## 📝 Adding New Features

When adding a new feature:

1. Create folder: `lib/features/my_feature/`
2. Create entry file: `my_feature.dart`
3. Add subfolders as needed: `models/`, `services/`, `ui/`, etc.
4. Export public API in entry file
5. Add dependencies to root `pubspec.yaml`
6. Document in `README.md`

Example:

```
lib/features/my_feature/
├── my_feature.dart         # Export public API
├── models/
│   └── my_model.dart
├── services/
│   └── my_service.dart
└── README.md               # Feature documentation
```

```dart
// my_feature.dart
library my_feature;

export 'models/my_model.dart';
export 'services/my_service.dart';
```

---

## ✅ Benefits

- ✅ **Single `pubspec.yaml`**: No confusion, no version conflicts
- ✅ **Self-contained features**: Easy to understand and maintain
- ✅ **Clear boundaries**: Features don't leak into each other
- ✅ **Easy navigation**: Find everything for a feature in one place
- ✅ **Reusable**: Copy a feature folder to another project
- ✅ **Scalable**: Add features without affecting existing ones
- ✅ **Team-friendly**: Different developers can work on different features

---

## 📞 Support

For questions or issues:
1. Check feature's `README.md`
2. Check feature's `TELL_ME.md` (if available)
3. Review this PROJECT_STRUCTURE.md

---

**Last Updated**: 2025-11-14
**Structure Version**: 1.0.0
**Migration Branch**: `refactor/feature-folders-20251114`
