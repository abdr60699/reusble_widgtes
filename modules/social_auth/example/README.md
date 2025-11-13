# Social Auth Example App

This example demonstrates how to use the Social Auth module in a Flutter application.

## Features Demonstrated

- Google Sign-In
- Apple Sign-In
- Facebook Login
- Error handling
- Loading states
- User profile display
- Sign out functionality

## Running the Example

### Prerequisites

Before running this example, you must configure each social provider. Follow the setup instructions in the main [Social Auth README](../README.md):

1. **Google Sign-In Setup** - See main README section on Google setup
2. **Apple Sign-In Setup** - See main README section on Apple setup
3. **Facebook Login Setup** - See main README section on Facebook setup

### Run the App

```bash
cd example
flutter pub get
flutter run
```

## What This Example Shows

### 1. Initialization

The app initializes the Social Auth module in `main()`:

```dart
SocialAuth.initialize(
  logger: ConsoleLogger(),
  enableGoogle: true,
  enableApple: true,
  enableFacebook: true,
);
```

### 2. Login Screen

The `LoginScreen` demonstrates:

- Using `SocialSignInRow` widget for multiple providers
- Handling loading states per provider
- Error handling with user-friendly messages
- Provider-specific error codes

### 3. Home Screen

The `HomeScreen` demonstrates:

- Displaying user information from `AuthResult`
- Showing profile picture
- Accessing tokens (for debugging)
- Sign out functionality

### 4. Error Handling

The app shows proper error handling:

```dart
try {
  final result = await SocialAuth.instance.signInWithGoogle();
  // Handle success
} on SocialAuthError catch (e) {
  // Handle specific social auth errors
  switch (e.code) {
    case SocialAuthErrorCode.userCancelled:
      // User cancelled the sign-in
      break;
    case SocialAuthErrorCode.networkError:
      // Network issue
      break;
    // ... other cases
  }
} catch (e) {
  // Handle unexpected errors
}
```

## Testing Without Backend

This example works without a backend service. It only uses the social provider authentication.

To integrate with a backend:

1. Create an `AuthService` implementation:

```dart
class MyBackendAuthService implements AuthService {
  @override
  Future<Map<String, dynamic>> authenticateWithProvider(
    AuthResult authResult,
  ) async {
    // Send authResult to your backend
    // Return your app's session token
  }
}
```

2. Pass it during initialization:

```dart
SocialAuth.initialize(
  authService: MyBackendAuthService(),
  tokenStorage: SecureTokenStorage(),
);
```

## Platform-Specific Notes

### iOS

- Requires iOS 13+ for Apple Sign-In
- Must enable "Sign in with Apple" capability in Xcode
- Must configure URL schemes in Info.plist

### Android

- Requires minimum SDK 21
- Must add SHA certificates to Google/Facebook consoles
- Must configure AndroidManifest.xml for each provider

### Web

- Requires additional configuration for Apple Sign-In
- Must register redirect URIs
- May require CORS configuration on your backend

## Troubleshooting

### Google Sign-In Not Working

1. Check SHA-1/SHA-256 certificates are registered
2. Verify `google-services.json` is in place
3. Check package name matches registered app

### Apple Sign-In Not Working

1. Verify capability is enabled in Xcode
2. Check Services ID is configured (for Android/Web)
3. Ensure app uses correct bundle ID

### Facebook Login Not Working

1. Verify App ID is correct in `strings.xml` (Android) or `Info.plist` (iOS)
2. Check key hashes are registered
3. Ensure Facebook app is in "Live" mode (not Development)

For more detailed troubleshooting, see the main [Social Auth README](../README.md).

## Next Steps

1. Configure your social providers
2. Run the example app
3. Test each sign-in flow
4. Integrate the module into your own app
5. Add backend authentication if needed

## License

MIT License - See main LICENSE file
