# Reusable Flutter Modules

This directory contains production-ready, standalone Flutter modules that can be easily integrated into any project.

## 📦 Available Modules

### 1. Connectivity & Offline Support (`connectivity_offline/`)

A comprehensive module for handling connectivity monitoring and offline functionality.

**Features:**
- Real-time connectivity monitoring
- Intelligent disk caching with Hive
- Offline request queueing
- Automatic sync when connection restores
- Multiple cache strategies (FIFO, LRU, LFU, TTL)
- Platform-agnostic design

**Quick Start:**
```dart
await OfflineSupport.initialize();

OfflineSupport.instance.connectivityStream.listen((state) {
  print('Connection: ${state.status}');
});
```

[📖 View Full Documentation](connectivity_offline/README.md)

---

### 2. Social Authentication (`social_auth/`)

Production-ready social sign-in module supporting multiple providers.

**Features:**
- Google Sign-In (OAuth 2.0)
- Apple Sign-In (iOS/macOS/Web)
- Facebook Login (Graph API)
- Pluggable backend integration
- Secure token storage
- Customizable UI components
- Comprehensive error handling

**Quick Start:**
```dart
SocialAuth.initialize(
  enableGoogle: true,
  enableApple: true,
  enableFacebook: true,
);

final result = await SocialAuth.instance.signInWithGoogle();
```

[📖 View Full Documentation](social_auth/README.md)

---

### 3. Supabase Authentication (`supabase_auth/`)

Production-ready authentication module with Supabase backend.

**Features:**
- Email/password authentication
- Magic link (passwordless) authentication
- OAuth providers (Google, Apple, Facebook, Twitter, GitHub)
- Password reset and email verification
- Reactive auth state management
- Secure token storage
- Reusable UI screens (SignIn, SignUp, ForgotPassword)
- Configurable password requirements

**Quick Start:**
```dart
await AuthRepository.initialize(
  SupabaseAuthConfig(
    supabaseUrl: 'YOUR_SUPABASE_URL',
    supabaseAnonKey: 'YOUR_ANON_KEY',
  ),
);

final result = await AuthRepository.instance.signInWithEmail(
  email: 'user@example.com',
  password: 'password',
);
```

[📖 View Full Documentation](supabase_auth/README.md)

---

### 4. Firebase Cloud Messaging (`fcm_notifications/`)

Production-ready FCM push notifications module for Flutter.

**Features:**
- Foreground, background, and terminated state notification handling
- Topic subscription and unsubscription
- FCM token management and refresh
- Local notifications for foreground display
- Android notification channels
- iOS APNs integration
- Deep linking support
- Data payload handling
- Stream-based notification delivery
- Permission request (iOS)
- Analytics integration (optional)

**Quick Start:**
```dart
await FCMService.initialize(FCMConfig.production);

FCMService.instance.notificationStream.listen((notification) {
  print('${notification.title}: ${notification.body}');
});

final token = await FCMService.instance.getToken();
await FCMService.instance.subscribeToTopic('news');
```

[📖 View Full Documentation](fcm_notifications/README.md)

---

### 5. Flutter Theming System (`flutter_theming/`)

Comprehensive, production-ready theming system for consistent design across your app.

**Features:**
- Complete design token system (colors, typography, spacing, radii, elevations, motion)
- Dynamic theme switching (light, dark, system, custom)
- Persistent theme preferences
- WCAG AA/AAA accessibility compliance
- Custom theme creation and validation
- Scoped theme overrides
- Material 3 / Dynamic color support
- High contrast mode for accessibility
- Theme import/export (JSON)
- State management agnostic (Provider, Riverpod, Bloc, GetIt)

**Quick Start:**
```
Conceptual usage (see docs for implementation):
1. Initialize ThemeService in main()
2. Wrap app with ThemeObserver or state management provider
3. Access tokens: ThemeService.instance.tokens.colors.primary
4. Switch themes: ThemeService.instance.setTheme(AppThemeMode.dark)
```

[📖 View Full Documentation](flutter_theming/README.md)

---

## 🚀 Installation

### Option 1: Path Dependency (Monorepo)

Add to your project's `pubspec.yaml`:

```yaml
dependencies:
  connectivity_offline:
    path: ../modules/connectivity_offline

  social_auth:
    path: ../modules/social_auth

  supabase_auth:
    path: ../modules/supabase_auth

  fcm_notifications:
    path: ../modules/fcm_notifications

  flutter_theming:
    path: ../modules/flutter_theming
```

### Option 2: Copy Module

Copy the entire module folder to your project:

```bash
cp -r modules/connectivity_offline /path/to/your/project/packages/
```

Then reference it:

```yaml
dependencies:
  connectivity_offline:
    path: packages/connectivity_offline
```

### Option 3: Git Submodule

```bash
git submodule add <repo-url> modules
```

---

## 📂 Module Structure

Each module follows a consistent structure:

```
module_name/
├── lib/
│   ├── src/              # Internal implementation
│   └── module_name.dart  # Public API exports
├── test/                 # Unit and widget tests
├── example/              # Example application
├── pubspec.yaml          # Dependencies
└── README.md             # Documentation
```

---

## 🧪 Running Tests

Test a specific module:

```bash
cd modules/connectivity_offline
flutter test
```

Test all modules:

```bash
for dir in modules/*/; do
  echo "Testing $dir..."
  cd "$dir" && flutter test && cd ../..
done
```

---

## 💡 Running Examples

Each module includes a working example app:

```bash
cd modules/connectivity_offline/example
flutter run
```

```bash
cd modules/social_auth/example
flutter run
```

```bash
cd modules/supabase_auth/example
flutter run
```

```bash
cd modules/fcm_notifications/example
flutter run
```

**Note:** The flutter_theming module is a design specification (documentation only). See its README and docs/ folder for implementation guidance.

---

## 🏗️ Architecture Principles

All modules follow these principles:

1. **Standalone**: Each module is self-contained and independently usable
2. **Type-Safe**: Full Dart null safety support
3. **Platform-Agnostic**: Works on iOS, Android, Web, and Desktop (where applicable)
4. **Well-Documented**: Comprehensive README and inline documentation
5. **Tested**: Includes unit and widget tests
6. **Example-Driven**: Working example app for each module
7. **Configurable**: Flexible configuration options
8. **Production-Ready**: Battle-tested patterns and best practices

---

## 🔧 Development Guidelines

### Adding a New Module

1. Create module directory structure:
```bash
mkdir -p modules/new_module/{lib,test,example}
```

2. Create `pubspec.yaml` with proper dependencies

3. Implement in `lib/src/` folder

4. Export public API in `lib/new_module.dart`

5. Add tests in `test/`

6. Create example app in `example/`

7. Write comprehensive README.md

### Module Naming Convention

- **Folder name**: `snake_case` (e.g., `social_auth`)
- **Package name**: Same as folder (e.g., `social_auth`)
- **Import**: `import 'package:social_auth/social_auth.dart';`

---

## 📊 Module Comparison

| Module | Size | Dependencies | Platforms | Use Case |
|--------|------|-------------|-----------|----------|
| connectivity_offline | Medium | Hive, connectivity_plus | All | Apps needing offline support |
| social_auth | Medium | Provider SDKs | All (provider-specific) | Apps with social login |
| supabase_auth | Medium | Supabase, secure storage | All | Apps using Supabase backend |
| fcm_notifications | Medium | Firebase, local notifications | Android, iOS, Web | Apps needing push notifications |
| flutter_theming | Documentation | Persistence adapter (your choice) | All | Apps needing consistent theming |

---

## 🤝 Contributing

When adding or updating modules:

1. Follow the existing structure
2. Include comprehensive tests
3. Add working example app
4. Update this README
5. Document all public APIs
6. Follow Dart style guide

---

## 📄 License

Each module is independently licensed. See individual module LICENSE files.

---

## 🔗 Related Resources

- [Flutter Documentation](https://docs.flutter.dev/)
- [Dart Packages](https://pub.dev/)
- [Flutter Community](https://flutter.dev/community)

---

## 📞 Support

For issues with specific modules, see the module's README for troubleshooting guides.

For general questions, refer to the main project README.
