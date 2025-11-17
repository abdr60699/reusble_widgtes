# App Customization Guide

This guide shows you how to customize the app name, icon, and splash screen for your Flutter application.

## Table of Contents
1. [Changing App Name](#changing-app-name)
2. [Adding App Icon](#adding-app-icon)
3. [Adding Splash Screen](#adding-splash-screen)

---

## Changing App Name

The app name appears in different locations depending on the platform. Here's how to change it for all platforms:

### Android

**1. Update AndroidManifest.xml**

File: `android/app/src/main/AndroidManifest.xml`

```xml
<application
    android:label="Your App Name"  <!-- Change this -->
    android:name="${applicationName}"
    android:icon="@mipmap/ic_launcher">
```

**2. Update build.gradle (Optional - for package name)**

File: `android/app/build.gradle`

```gradle
defaultConfig {
    applicationId "com.yourcompany.yourapp"  // Change package name
    minSdkVersion flutter.minSdkVersion
    targetSdkVersion flutter.targetSdkVersion
    versionCode flutterVersionCode.toInteger()
    versionName flutterVersionName
}
```

### iOS

**1. Update Info.plist**

File: `ios/Runner/Info.plist`

```xml
<key>CFBundleName</key>
<string>Your App Name</string>
<key>CFBundleDisplayName</key>
<string>Your App Name</string>
```

**2. Update in Xcode (Alternative)**

1. Open `ios/Runner.xcworkspace` in Xcode
2. Select Runner in the navigator
3. Go to General tab
4. Change "Display Name" field

### macOS

File: `macos/Runner/Configs/AppInfo.xcconfig`

```
PRODUCT_NAME = Your App Name
PRODUCT_BUNDLE_IDENTIFIER = com.yourcompany.yourapp
```

### Windows

File: `windows/runner/Runner.rc`

Find and update:
```
VALUE "ProductName", "Your App Name"
VALUE "FileDescription", "Your App Name"
```

### Linux

File: `linux/my_application.cc`

```cpp
gtk_header_bar_set_title(header_bar, "Your App Name");
```

### Web

File: `web/index.html`

```html
<head>
  <title>Your App Name</title>
</head>
```

File: `web/manifest.json`

```json
{
  "name": "Your App Name",
  "short_name": "App Name",
  "description": "Your app description"
}
```

---

## Adding App Icon

### Method 1: Using flutter_launcher_icons Package (Recommended)

This is the easiest way to add app icons across all platforms.

**Step 1: Add dependency**

Add to `pubspec.yaml`:

```yaml
dev_dependencies:
  flutter_launcher_icons: ^0.13.1
```

**Step 2: Configure the package**

Add to `pubspec.yaml`:

```yaml
flutter_launcher_icons:
  android: true
  ios: true
  image_path: "assets/icon/app_icon.png"

  # Optional: Different icons for platforms
  # image_path_android: "assets/icon/icon_android.png"
  # image_path_ios: "assets/icon/icon_ios.png"

  # Android adaptive icon
  adaptive_icon_background: "#ffffff"
  adaptive_icon_foreground: "assets/icon/app_icon_foreground.png"

  # iOS specific
  ios_content_mode: "scaleAspectFit"

  # Web
  web:
    generate: true
    image_path: "assets/icon/app_icon.png"
    background_color: "#ffffff"
    theme_color: "#0175C2"

  # Windows
  windows:
    generate: true
    image_path: "assets/icon/app_icon.png"
    icon_size: 48

  # macOS
  macos:
    generate: true
    image_path: "assets/icon/app_icon.png"
```

**Step 3: Prepare your icon**

1. Create an icon image (1024x1024 PNG recommended)
2. Place it in `assets/icon/app_icon.png`

**Icon Requirements:**
- **Format:** PNG with transparency
- **Size:** 1024x1024 pixels minimum
- **No text:** Avoid small text (iOS rejects it)
- **Safe area:** Keep important content in center 70%

**Step 4: Generate icons**

```bash
flutter pub get
flutter pub run flutter_launcher_icons
```

**Step 5: Verify**

- Android: Check `android/app/src/main/res/mipmap-*/ic_launcher.png`
- iOS: Check `ios/Runner/Assets.xcassets/AppIcon.appiconset/`

---

### Method 2: Manual Icon Setup

If you want to manually add icons for each platform:

#### Android

**1. Generate icon sizes**

You need multiple sizes:
- mipmap-mdpi: 48x48
- mipmap-hdpi: 72x72
- mipmap-xhdpi: 96x96
- mipmap-xxhdpi: 144x144
- mipmap-xxxhdpi: 192x192

**2. Place icons**

Put icons in: `android/app/src/main/res/mipmap-{density}/ic_launcher.png`

**3. For Android 8.0+ (Adaptive Icons)**

Create foreground and background layers:

File: `android/app/src/main/res/mipmap-anydpi-v26/ic_launcher.xml`

```xml
<?xml version="1.0" encoding="utf-8"?>
<adaptive-icon xmlns:android="http://schemas.android.com/apk/res/android">
    <background android:drawable="@color/ic_launcher_background"/>
    <foreground android:drawable="@mipmap/ic_launcher_foreground"/>
</adaptive-icon>
```

#### iOS

**1. Prepare icon sizes**

Required sizes:
- 20x20 (iPhone Notification)
- 29x29 (iPhone Settings)
- 40x40 (iPhone Spotlight)
- 60x60 (iPhone App)
- 76x76 (iPad App)
- 83.5x83.5 (iPad Pro)
- 1024x1024 (App Store)

All at 1x, 2x, and 3x scales.

**2. Add to Xcode**

1. Open `ios/Runner.xcworkspace` in Xcode
2. Navigate to `Runner > Assets.xcassets > AppIcon`
3. Drag and drop each icon to the appropriate slot

---

## Adding Splash Screen

### Method 1: Using flutter_native_splash Package (Recommended)

**Step 1: Add dependency**

```yaml
dev_dependencies:
  flutter_native_splash: ^2.3.6
```

**Step 2: Configure**

Add to `pubspec.yaml`:

```yaml
flutter_native_splash:
  # Splash screen background color
  color: "#ffffff"

  # Splash screen image
  image: assets/splash/splash_logo.png

  # Branding image (shown at bottom)
  branding: assets/splash/branding.png

  # Image fill mode
  image_fill: contain  # or 'cover'

  # Platform specific
  android: true
  ios: true
  web: true

  # Android 12+ specific
  android_12:
    image: assets/splash/splash_logo_android12.png
    icon_background_color: "#ffffff"

  # Dark mode splash (optional)
  color_dark: "#000000"
  image_dark: assets/splash/splash_logo_dark.png

  # Full screen on Android
  fullscreen: true

  # Info.plist settings for iOS
  info_plist_files:
    - 'ios/Runner/Info.plist'
```

**Step 3: Prepare splash image**

1. Create splash logo (recommended: 1242x1242 PNG)
2. Place in `assets/splash/splash_logo.png`
3. Keep important content in center (safe area)

**Image Guidelines:**
- **Format:** PNG with transparency
- **Size:** Square, at least 1242x1242
- **Content:** Logo/branding only
- **Safe area:** 60% center for essential content

**Step 4: Create assets folder**

```yaml
# Add to pubspec.yaml
flutter:
  assets:
    - assets/splash/
```

**Step 5: Generate splash screens**

```bash
flutter pub get
flutter pub run flutter_native_splash:create
```

**Step 6: Remove splash screen (in code)**

The splash automatically hides when your app is ready. But you can control it:

```dart
import 'package:flutter_native_splash/flutter_native_splash.dart';

void main() {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  runApp(MyApp());

  // Remove splash after initialization
  FlutterNativeSplash.remove();
}
```

**Or delay removal:**

```dart
void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  // Do initialization
  await initializeApp();

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    initialization();
  }

  void initialization() async {
    // Simulate some initialization
    await Future.delayed(const Duration(seconds: 2));
    FlutterNativeSplash.remove();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomeScreen(),
    );
  }
}
```

---

### Method 2: Manual Splash Screen Setup

#### Android

**1. Create splash drawable**

File: `android/app/src/main/res/drawable/splash.xml`

```xml
<?xml version="1.0" encoding="utf-8"?>
<layer-list xmlns:android="http://schemas.android.com/apk/res/android">
    <!-- Background color -->
    <item android:drawable="@android:color/white" />

    <!-- Splash image centered -->
    <item>
        <bitmap
            android:gravity="center"
            android:src="@drawable/splash_logo" />
    </item>
</layer-list>
```

**2. Add splash image**

Place your splash logo in:
- `android/app/src/main/res/drawable/splash_logo.png`
- Or in multiple densities: `drawable-mdpi`, `drawable-hdpi`, etc.

**3. Update styles**

File: `android/app/src/main/res/values/styles.xml`

```xml
<?xml version="1.0" encoding="utf-8"?>
<resources>
    <style name="LaunchTheme" parent="@android:style/Theme.Light.NoTitleBar">
        <item name="android:windowBackground">@drawable/splash</item>
    </style>

    <style name="NormalTheme" parent="@android:style/Theme.Light.NoTitleBar">
        <item name="android:windowBackground">?android:colorBackground</item>
    </style>
</resources>
```

**4. For Android 12+**

File: `android/app/src/main/res/values-v31/styles.xml`

```xml
<?xml version="1.0" encoding="utf-8"?>
<resources>
    <style name="LaunchTheme" parent="@android:style/Theme.Black.NoTitleBar">
        <item name="android:windowSplashScreenBackground">@android:color/white</item>
        <item name="android:windowSplashScreenAnimatedIcon">@drawable/splash_logo</item>
    </style>
</resources>
```

#### iOS

**1. Use LaunchScreen.storyboard**

File: `ios/Runner/Base.lproj/LaunchScreen.storyboard`

Open in Xcode and design your launch screen visually, or edit XML:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<document type="com.apple.InterfaceBuilder3.CocoaTouch.Storyboard.XIB" version="3.0">
    <scenes>
        <scene sceneID="EHf-IW-A2E">
            <objects>
                <viewController id="01J-lp-oVM" sceneMemberID="viewController">
                    <view key="view" contentMode="scaleToFill" id="Ze5-6b-2t3">
                        <rect key="frame" x="0.0" y="0.0" width="414" height="896"/>
                        <subviews>
                            <!-- Background -->
                            <view contentMode="scaleToFill" id="background">
                                <rect key="frame" x="0.0" y="0.0" width="414" height="896"/>
                                <color key="backgroundColor" red="1" green="1" blue="1" alpha="1"/>
                            </view>

                            <!-- Logo Image -->
                            <imageView contentMode="scaleAspectFit" image="splash_logo" id="logo">
                                <rect key="frame" x="107" y="348" width="200" height="200"/>
                            </imageView>
                        </subviews>
                        <color key="backgroundColor" red="1" green="1" blue="1" alpha="1"/>
                    </view>
                </viewController>
            </objects>
        </scene>
    </scenes>
    <resources>
        <image name="splash_logo" width="200" height="200"/>
    </resources>
</document>
```

**2. Add splash image to Assets**

1. Open `ios/Runner.xcworkspace` in Xcode
2. Add image to `Assets.xcassets`
3. Name it `splash_logo`

---

## Complete Setup Example

Here's a complete example setup in your `pubspec.yaml`:

```yaml
name: your_app
description: Your app description

dependencies:
  flutter:
    sdk: flutter

dev_dependencies:
  flutter_launcher_icons: ^0.13.1
  flutter_native_splash: ^2.3.6

# App Icons Configuration
flutter_launcher_icons:
  android: true
  ios: true
  image_path: "assets/icon/app_icon.png"

  adaptive_icon_background: "#ffffff"
  adaptive_icon_foreground: "assets/icon/app_icon_foreground.png"

  web:
    generate: true
    image_path: "assets/icon/app_icon.png"

  windows:
    generate: true
    image_path: "assets/icon/app_icon.png"

  macos:
    generate: true
    image_path: "assets/icon/app_icon.png"

# Splash Screen Configuration
flutter_native_splash:
  color: "#ffffff"
  image: assets/splash/splash_logo.png
  branding: assets/splash/branding.png

  android_12:
    image: assets/splash/splash_logo.png
    icon_background_color: "#ffffff"

  android: true
  ios: true
  web: true

# Assets
flutter:
  uses-material-design: true
  assets:
    - assets/icon/
    - assets/splash/
```

**Setup Steps:**

```bash
# 1. Create folders
mkdir -p assets/icon
mkdir -p assets/splash

# 2. Add your images
# - Place app_icon.png (1024x1024) in assets/icon/
# - Place splash_logo.png (1242x1242) in assets/splash/

# 3. Install dependencies
flutter pub get

# 4. Generate icons
flutter pub run flutter_launcher_icons

# 5. Generate splash screens
flutter pub run flutter_native_splash:create

# 6. Run the app
flutter run
```

---

## Asset Preparation Tips

### App Icon Best Practices

1. **Size:** Create at 1024x1024 minimum
2. **Format:** PNG with transparency
3. **No text:** Avoid small text
4. **Testing:** Test on light and dark backgrounds
5. **Simplicity:** Simple icons work better at small sizes
6. **Branding:** Keep it consistent with your brand

### Splash Screen Best Practices

1. **Size:** Create at 1242x1242 (square)
2. **Format:** PNG with transparency
3. **Safe area:** Keep logo in center 60%
4. **Duration:** Keep it short (1-2 seconds)
5. **Consistency:** Match app's main theme
6. **Testing:** Test on different screen sizes

### Image Optimization

Use tools to optimize your assets:

```bash
# Install ImageMagick
brew install imagemagick  # macOS
sudo apt-get install imagemagick  # Linux

# Optimize PNG
convert input.png -strip -quality 85 output.png

# Resize image
convert input.png -resize 1024x1024 output.png
```

---

## Platform-Specific Notes

### Android

- **Adaptive icons:** Required for Android 8.0+
- **Safe area:** 66dp diameter for adaptive icon
- **Testing:** Test with different launcher themes
- **Format:** Both PNG and vector (XML) supported

### iOS

- **App Store:** Requires 1024x1024 icon
- **No transparency:** App Store icon cannot be transparent
- **Testing:** Test on different device sizes
- **Human Interface:** Follow Apple's guidelines

### Web

- **Favicon:** Also add `favicon.png` to `web/` folder
- **PWA:** Configure `manifest.json` properly
- **Multiple sizes:** Provide 192x192 and 512x512

### Desktop (Windows/macOS/Linux)

- **Windows:** Supports ICO format
- **macOS:** Uses ICNS format (auto-generated)
- **Linux:** Uses PNG (multiple sizes)

---

## Troubleshooting

### Icons not showing

1. Clean build and rebuild:
```bash
flutter clean
flutter pub get
flutter pub run flutter_launcher_icons
flutter run
```

2. For iOS, open Xcode and clean build folder

3. Uninstall app and reinstall

### Splash screen not appearing

1. Verify image paths in `pubspec.yaml`
2. Run generation command again
3. Check `flutter_native_splash.yaml` was created
4. Rebuild app completely

### Adaptive icon issues (Android)

1. Ensure foreground is transparent PNG
2. Keep important content in center circle (66dp)
3. Test with different launcher themes
4. Use Android Studio to preview

---

## Quick Reference Commands

```bash
# Generate app icons
flutter pub run flutter_launcher_icons

# Generate splash screens
flutter pub run flutter_native_splash:create

# Remove splash screens (if needed)
flutter pub run flutter_native_splash:remove

# Clean and rebuild
flutter clean
flutter pub get
flutter run

# Test on specific platform
flutter run -d android
flutter run -d ios
flutter run -d chrome
flutter run -d windows
```

---

## Resources

- [Flutter Launcher Icons Package](https://pub.dev/packages/flutter_launcher_icons)
- [Flutter Native Splash Package](https://pub.dev/packages/flutter_native_splash)
- [Android Icon Guidelines](https://developer.android.com/guide/practices/ui_guidelines/icon_design_adaptive)
- [iOS Icon Guidelines](https://developer.apple.com/design/human-interface-guidelines/app-icons)
- [Material Design Icons](https://m3.material.io/styles/icons/overview)

---

## Need Help?

If you encounter issues:
1. Check package documentation
2. Verify image paths and formats
3. Clean and rebuild
4. Check platform-specific requirements
5. Open an issue on GitHub

Happy customizing! 🎨
