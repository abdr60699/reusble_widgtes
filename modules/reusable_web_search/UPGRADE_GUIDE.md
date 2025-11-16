# Upgrade Guide - v1.0.0 to v1.1.0

This guide helps you upgrade from reusable_web_search v1.0.0 to v1.1.0.

## Overview

Version 1.1.0 updates all dependencies to their latest versions, removes deprecated APIs, and improves compatibility with Flutter 3.16+ and Dart 3.2+.

## Breaking Changes

### 1. Minimum SDK Requirements

**Old (v1.0.0)**:
```yaml
environment:
  sdk: '>=3.0.0 <4.0.0'
  flutter: ">=3.10.0"
```

**New (v1.1.0)**:
```yaml
environment:
  sdk: '>=3.2.0 <4.0.0'
  flutter: ">=3.16.0"
```

**Action Required**: Update your project's Flutter and Dart SDK to meet the new minimum requirements.

```bash
flutter upgrade
flutter --version  # Verify Flutter 3.16.0 or higher
dart --version     # Verify Dart 3.2.0 or higher
```

### 2. WillPopScope → PopScope Migration

The WebViewScreen now uses `PopScope` instead of the deprecated `WillPopScope`.

**Impact**: If you're using WebViewScreen directly, no action required. The migration is internal.

**If you were extending WebViewScreen**: Update your code to use `PopScope`:

**Old**:
```dart
WillPopScope(
  onWillPop: () async {
    // Handle back button
    return true;
  },
  child: Scaffold(...),
)
```

**New**:
```dart
PopScope(
  canPop: false,
  onPopInvokedWithResult: (bool didPop, dynamic result) async {
    if (!didPop) {
      final shouldPop = await _handleBackButton();
      if (shouldPop && context.mounted) {
        Navigator.of(context).pop();
      }
    }
  },
  child: Scaffold(...),
)
```

## Package Updates

### Major Version Updates

| Package | Old Version | New Version | Breaking Changes |
|---------|-------------|-------------|------------------|
| http | ^1.1.0 | ^1.2.2 | No |
| dio | ^5.4.0 | ^5.9.0 | No |
| webview_flutter | ^4.4.4 | ^4.10.0 | No |
| webview_flutter_android | ^3.13.1 | ^3.16.10 | No |
| webview_flutter_wkwebview | ^3.10.1 | ^3.16.3 | No |
| shared_preferences | ^2.2.2 | ^2.5.3 | No |
| path_provider | ^2.1.1 | ^2.1.5 | No |
| url_launcher | ^6.2.2 | ^6.3.1 | No |
| share_plus | ^7.2.1 | ^10.1.2 | No |
| cached_network_image | ^3.3.1 | ^3.4.1 | No |
| provider | ^6.1.1 | ^6.1.2 | No |
| intl | ^0.18.1 | ^0.19.0 | No |
| equatable | ^2.0.5 | ^2.0.7 | No |
| html | ^0.15.4 | ^0.15.5 | No |
| flutter_lints | ^3.0.0 | ^6.0.0 | No* |
| build_runner | ^2.4.7 | ^2.10.3 | No |
| test | ^1.24.9 | ^1.25.8 | No |

*flutter_lints 6.0.0 adds new lint rules but doesn't break existing code.

### Share Plus API (v10.x)

The `share_plus` package was updated from v7.2.1 to v10.1.2. The API remains backward compatible, but here's the recommended usage:

**Old (still works)**:
```dart
Share.share('https://example.com', subject: 'Check this out');
```

**New (recommended)**:
```dart
Share.shareUri(Uri.parse('https://example.com'));
```

**Our code**: Already compatible with both versions. No changes needed.

## Lint Updates

flutter_lints 6.0.0 includes stricter lint rules. Our updated `analysis_options.yaml` is optimized for these new rules.

### New Lint Rules Added

1. `prefer_const_constructors_in_immutables`
2. `prefer_const_declarations`
3. `prefer_const_literals_to_create_immutables`
4. `prefer_final_in_for_each`
5. `prefer_final_locals`
6. `sort_constructors_first`
7. `sort_unnamed_constructors_first`
8. `unnecessary_await_in_return`
9. `use_super_parameters`

### Strict Analysis Modes

We've enabled strict modes for better type safety:

```yaml
analyzer:
  language:
    strict-casts: true
    strict-inference: true
    strict-raw-types: true
```

**Impact**: Your IDE may show more warnings. These help catch potential runtime errors at compile time.

## Migration Steps

### Step 1: Update Dependencies

Update your `pubspec.yaml`:

```yaml
dependencies:
  reusable_web_search: ^1.1.0  # Update from ^1.0.0
```

Then run:

```bash
flutter pub get
flutter pub upgrade
```

### Step 2: Check Dart/Flutter SDK

Ensure you're using Flutter 3.16.0+ and Dart 3.2.0+:

```bash
flutter upgrade
flutter --version
```

### Step 3: Update Your Code (if needed)

**If you're using the package as-is**: No code changes needed!

**If you extended WebViewScreen**: Update to use `PopScope` (see above).

**If you customized lint rules**: Review your `analysis_options.yaml` against ours.

### Step 4: Regenerate Hive Adapters

If you've made changes to models:

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

### Step 5: Test Your App

Run your app and test all search functionality:

```bash
flutter run
```

## New Features in v1.1.0

While this is primarily a maintenance release, it includes:

1. **Better Type Safety**: Strict analyzer modes catch more errors
2. **Improved Performance**: Updated dependencies include performance improvements
3. **Future-Proof**: Compatible with latest Flutter stable and beta channels
4. **Better Linting**: More comprehensive code quality checks

## Troubleshooting

### Issue: "SDK version ... is incompatible"

**Solution**: Update Flutter:
```bash
flutter upgrade
flutter pub get
```

### Issue: "WillPopScope is deprecated"

**Solution**: You're still on an older version. Update to v1.1.0:
```bash
flutter pub upgrade reusable_web_search
```

### Issue: New lint warnings

**Solution**: These are helpful warnings, not errors. Fix them gradually or disable specific rules:

```yaml
# In your analysis_options.yaml
linter:
  rules:
    prefer_final_locals: false  # Disable if needed
```

### Issue: Build runner errors

**Solution**: Clean and rebuild:
```bash
flutter clean
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs
```

### Issue: WebView not working

**Solution**: Clear cache and rebuild:
```bash
flutter clean
flutter pub get
flutter run
```

## Reverting to v1.0.0

If you encounter issues, you can temporarily revert:

```yaml
dependencies:
  reusable_web_search: ^1.0.0
```

Then run:
```bash
flutter pub get
```

**Note**: Please report any issues on GitHub so we can help!

## Getting Help

- **GitHub Issues**: https://github.com/abdr60699/reusable_widgets/issues
- **Discussions**: https://github.com/abdr60699/reusable_widgets/discussions
- **Email**: [your-email@example.com]

## Summary

✅ **No breaking API changes** - Your code should work without modifications

✅ **All dependencies updated** - Latest stable versions

✅ **Deprecated APIs removed** - Future-proof codebase

✅ **Improved linting** - Better code quality

✅ **Better type safety** - Catch errors earlier

---

**Migration Time**: ~5 minutes (just update dependencies)

**Compatibility**: Fully backward compatible for standard usage

**Recommendation**: Update at your earliest convenience to benefit from bug fixes and performance improvements in updated dependencies.
