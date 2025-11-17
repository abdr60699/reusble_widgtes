# Reusable Widgets Test App

A comprehensive example app to test and demonstrate all reusable widgets and features from the main package.

## Overview

This example app provides interactive demos for:
- 25+ reusable UI widgets
- Form components (TextFields, Dropdowns, DatePickers, Radio Groups)
- Theme system (Material 3, dark/light mode)
- Navigation patterns (Drawer, Bottom Nav, Tabs)
- API client with HTTP requests
- Offline storage with Hive

## Getting Started

### Prerequisites

- Flutter SDK 3.4.1 or higher
- Dart SDK 3.0.0 or higher

### Installation

1. Navigate to the example app directory:
```bash
cd example/exampletestapp
```

2. Get dependencies:
```bash
flutter pub get
```

3. Run the app:
```bash
flutter run
```

### Running on Specific Platforms

```bash
# Android
flutter run -d android

# iOS
flutter run -d ios

# Web
flutter run -d chrome

# macOS
flutter run -d macos

# Windows
flutter run -d windows

# Linux
flutter run -d linux
```

## Features Demonstrated

### 1. Widget Gallery
Test all 25+ reusable UI widgets including:
- Containers with custom styling
- Badges
- Circle Avatars
- Icon Buttons
- Dividers (horizontal and vertical)
- Shimmer loading states
- Error views
- Animated switchers
- Toasts and Snackbars

### 2. Form Widgets
Interactive form with validation:
- Text form fields (name, email, password, phone)
- Dropdowns for selection
- Date pickers
- Radio button groups
- Form validation and submission

### 3. Theme System
Material 3 theming demonstration:
- Light/Dark mode toggle
- Color palette showcase
- Typography samples
- Component theming
- Custom widgets with theme support

### 4. Navigation
Multiple navigation patterns:
- Drawer navigation
- Bottom navigation bar
- Tab bar navigation
- Stack navigation (push/pop)
- Navigation with parameters

### 5. API Client
HTTP request demonstrations:
- GET requests (list and single item)
- POST requests
- Error handling
- Loading states
- Response parsing

Uses JSONPlaceholder API for testing: https://jsonplaceholder.typicode.com

### 6. Offline & Connectivity
Hive local storage testing:
- Save data to local cache
- Read cached data
- Delete individual items
- Clear all cache
- Persist data across app restarts

## Project Structure

```
lib/
├── main.dart                           # App entry point
└── screens/
    ├── home_screen.dart                # Main navigation screen
    ├── widget_gallery_screen.dart      # UI widgets demo
    ├── form_widgets_screen.dart        # Form components demo
    ├── theme_demo_screen.dart          # Theme system demo
    ├── navigation_demo_screen.dart     # Navigation patterns demo
    ├── api_client_screen.dart          # HTTP requests demo
    └── offline_connectivity_screen.dart # Hive caching demo
```

## Testing the Package

### As a Developer

1. **Test Individual Widgets**: Navigate to Widget Gallery to see all widgets in action
2. **Test Forms**: Try the form validation and submission
3. **Test Theme**: Toggle between light/dark modes
4. **Test API Calls**: Make HTTP requests and see responses
5. **Test Offline Storage**: Save and retrieve data using Hive

### Integration with Your App

To use the reusable widgets in your own app:

1. Add the package as a dependency:
```yaml
dependencies:
  reuablewidgets:
    path: ../../  # Adjust path as needed
```

2. Import the widgets you need:
```dart
import 'package:reuablewidgets/sharedwidget/reusable_app_bar.dart';
import 'package:reuablewidgets/sharedwidget/reusable_button.dart';
// ... other imports
```

3. Use the widgets:
```dart
ReusableAppBar(
  title: 'My App',
  showBackButton: true,
)
```

## Development Workflow

### Hot Reload
The app supports Flutter's hot reload for rapid development:
```bash
# Press 'r' in the terminal to hot reload
# Press 'R' in the terminal to hot restart
```

### Making Changes

1. Edit widget files in the main package (`../../lib/sharedwidget/`)
2. Changes will reflect immediately in the example app with hot reload
3. Test the changes in the relevant demo screen

### Adding New Demo Screens

1. Create a new screen in `lib/screens/`
2. Add navigation item in `home_screen.dart`
3. Test the new screen functionality

## Troubleshooting

### Build Errors

If you encounter build errors:

1. Clean the build:
```bash
flutter clean
flutter pub get
```

2. Rebuild:
```bash
flutter run
```

### Path Dependency Issues

If the package is not found:

1. Verify the path in `pubspec.yaml` points to the root package
2. Run `flutter pub get` again
3. Check that the main package has a valid `pubspec.yaml`

### Platform-Specific Issues

**Android**: Ensure minimum SDK version is 21 or higher in `android/app/build.gradle`

**iOS**: Run `pod install` in the `ios` folder if needed

**Web**: Some features (like Hive file storage) may have limited functionality on web

## Testing Checklist

Use this checklist to ensure all features work correctly:

- [ ] Widget Gallery loads and displays all widgets
- [ ] Form validation works correctly
- [ ] Theme can be toggled
- [ ] All navigation patterns work
- [ ] API requests succeed and handle errors
- [ ] Data persists in Hive storage
- [ ] Hot reload works
- [ ] App runs on target platform (Android/iOS/Web/Desktop)

## Contributing

When adding new widgets to the main package:

1. Add the widget to the appropriate category
2. Create a demo in the example app
3. Update this README with the new feature
4. Test thoroughly before committing

## Resources

- [Flutter Documentation](https://flutter.dev/docs)
- [Material 3 Design](https://m3.material.io/)
- [Hive Documentation](https://docs.hivedb.dev/)
- [HTTP Package](https://pub.dev/packages/http)

## License

This example app is part of the reusable widgets package.

## Support

If you encounter any issues or have questions:
1. Check the main package documentation
2. Review the example code in this app
3. Open an issue in the repository
