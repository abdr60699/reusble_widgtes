# Quick Start Guide

Get up and running with the Reusable Widgets Test App in minutes.

## ⚡ Super Quick Start

```bash
# 1. Navigate to example app
cd example/exampletestapp

# 2. Get dependencies
flutter pub get

# 3. Run the app
flutter run
```

That's it! The app will launch and you can start testing all widgets.

---

## 🎯 Common Tasks

### Change App Name

**Quick Method:**

1. **Android:** Edit `android/app/src/main/AndroidManifest.xml`
   ```xml
   <application android:label="Your App Name" ...>
   ```

2. **iOS:** Edit `ios/Runner/Info.plist`
   ```xml
   <key>CFBundleDisplayName</key>
   <string>Your App Name</string>
   ```

**📖 [Full guide](APP_CUSTOMIZATION_GUIDE.md#changing-app-name)**

---

### Add App Icon

**Recommended Method (Automated):**

1. Add dependency to `pubspec.yaml`:
   ```yaml
   dev_dependencies:
     flutter_launcher_icons: ^0.13.1
   ```

2. Configure in `pubspec.yaml`:
   ```yaml
   flutter_launcher_icons:
     android: true
     ios: true
     image_path: "assets/icon/app_icon.png"
   ```

3. Create `assets/icon/app_icon.png` (1024x1024)

4. Generate:
   ```bash
   flutter pub get
   flutter pub run flutter_launcher_icons
   ```

**📖 [Full guide](APP_CUSTOMIZATION_GUIDE.md#adding-app-icon)**

---

### Add Splash Screen

**Recommended Method (Automated):**

1. Add dependency to `pubspec.yaml`:
   ```yaml
   dev_dependencies:
     flutter_native_splash: ^2.3.6
   ```

2. Configure in `pubspec.yaml`:
   ```yaml
   flutter_native_splash:
     color: "#ffffff"
     image: assets/splash/splash_logo.png
     android: true
     ios: true
   ```

3. Create `assets/splash/splash_logo.png` (1242x1242)

4. Generate:
   ```bash
   flutter pub get
   flutter pub run flutter_native_splash:create
   ```

**📖 [Full guide](APP_CUSTOMIZATION_GUIDE.md#adding-splash-screen)**

---

### Test All Widgets

Run the app and navigate through the screens:

1. **Widget Gallery** - Test 25+ UI widgets
2. **Form Widgets** - Test form components
3. **Theme Demo** - View Material 3 theming
4. **Navigation** - Test navigation patterns
5. **API Client** - Test HTTP requests
6. **Offline/Connectivity** - Test local storage

**📖 [Full testing guide](TESTING_GUIDE.md)**

---

### Use in Your Own App

1. Add to your `pubspec.yaml`:
   ```yaml
   dependencies:
     reuablewidgets:
       path: path/to/reusble_widgtes
   ```

2. Import widgets:
   ```dart
   import 'package:reuablewidgets/sharedwidget/reusable_app_bar.dart';
   ```

3. Use them:
   ```dart
   ReusableAppBar(
     title: 'My App',
     showBackButton: true,
   )
   ```

---

## 📱 Platform-Specific Setup

### Android

**Run on Android:**
```bash
flutter run -d android
```

**Build APK:**
```bash
flutter build apk --release
```

**Build App Bundle:**
```bash
flutter build appbundle --release
```

### iOS

**Run on iOS:**
```bash
flutter run -d ios
```

**Build for iOS:**
```bash
flutter build ios --release
```

**Note:** Requires macOS and Xcode

### Web

**Run on Web:**
```bash
flutter run -d chrome
```

**Build for Web:**
```bash
flutter build web --release
```

### Desktop

**Windows:**
```bash
flutter run -d windows
flutter build windows --release
```

**macOS:**
```bash
flutter run -d macos
flutter build macos --release
```

**Linux:**
```bash
flutter run -d linux
flutter build linux --release
```

---

## 🔧 Troubleshooting

### Package not found?

```bash
cd example/exampletestapp
flutter clean
flutter pub get
```

### Build errors?

```bash
flutter doctor
flutter clean
flutter pub get
flutter run
```

### Hot reload not working?

Press `R` for hot restart instead of `r`

### iOS build issues?

```bash
cd ios
pod install
cd ..
flutter run
```

---

## 📚 Documentation

- **[README.md](README.md)** - Full documentation
- **[TESTING_GUIDE.md](TESTING_GUIDE.md)** - Complete testing guide
- **[APP_CUSTOMIZATION_GUIDE.md](APP_CUSTOMIZATION_GUIDE.md)** - Customization guide

---

## 🚀 Next Steps

1. ✅ Run the example app
2. ✅ Test all demo screens
3. ✅ Customize app name and icon
4. ✅ Use widgets in your app
5. ✅ Build and deploy

---

## 💡 Pro Tips

### Faster Development

Use hot reload for instant updates:
```bash
# In terminal where app is running
r  # Hot reload
R  # Hot restart
```

### Test on Multiple Devices

```bash
# List all devices
flutter devices

# Run on specific device
flutter run -d <device-id>
```

### Check Performance

```bash
# Run with performance overlay
flutter run --profile

# Analyze app size
flutter build apk --analyze-size
```

### Debug Efficiently

```bash
# Run with verbose logging
flutter run -v

# Check logs
flutter logs
```

---

## 🎨 Customization Checklist

- [ ] Change app name
- [ ] Add app icon
- [ ] Add splash screen
- [ ] Update app colors/theme
- [ ] Test on all target platforms
- [ ] Build release version

---

## ⚠️ Important Notes

1. **Flutter SDK:** Requires Flutter 3.4.1 or higher
2. **Internet:** API Client demo requires internet connection
3. **Platform Tools:** iOS requires Xcode, Android requires Android Studio
4. **Assets:** Remember to add assets folder to pubspec.yaml
5. **Packages:** Run `flutter pub get` after any pubspec.yaml changes

---

## 🆘 Getting Help

1. Read the error message carefully
2. Check [README.md](README.md) for detailed info
3. Review [TESTING_GUIDE.md](TESTING_GUIDE.md)
4. Run `flutter doctor` to check setup
5. Clean and rebuild if needed
6. Open an issue on GitHub

---

## 📖 Additional Resources

- [Flutter Official Docs](https://flutter.dev/docs)
- [Material 3 Guidelines](https://m3.material.io/)
- [Flutter Community](https://flutter.dev/community)
- [Pub.dev Packages](https://pub.dev/)

---

Happy coding! 🎉
