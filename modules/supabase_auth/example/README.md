# Supabase Auth Example App

Complete example demonstrating all features of the Supabase Auth module.

## Features Demonstrated

- ✅ Email/password sign up with validation
- ✅ Email/password sign in
- ✅ Forgot password flow
- ✅ Password strength indicator
- ✅ Auth state management with streams
- ✅ User profile display
- ✅ Sign out functionality

## Setup

### 1. Create Supabase Project

1. Go to [supabase.com](https://supabase.com) and create a new project
2. Wait for project initialization (takes ~2 minutes)
3. Go to Settings → API
4. Copy your project URL and anon key

### 2. Configure the App

Edit `lib/main.dart` and replace the placeholders:

```dart
await AuthRepository.initialize(
  SupabaseAuthConfig(
    supabaseUrl: 'https://your-project.supabase.co', // Replace this
    supabaseAnonKey: 'your-anon-key-here',           // Replace this
    // ... rest of config
  ),
);
```

### 3. Enable Email Auth

In Supabase Dashboard:
1. Go to Authentication → Providers
2. Enable "Email" provider
3. (Optional) Disable "Confirm email" for testing
4. Save changes

### 4. Run the App

```bash
flutter pub get
flutter run
```

## Testing Flows

### Sign Up Flow

1. Tap "Sign Up" on welcome screen
2. Enter name, email, and password
3. Password strength indicator shows security level
4. Accept terms and conditions
5. Tap "Sign Up"
6. Check email for verification (if enabled)

### Sign In Flow

1. Tap "Sign In" on welcome screen
2. Enter email and password
3. Tap "Sign In"
4. Redirects to home screen on success

### Forgot Password Flow

1. From sign-in screen, tap "Forgot password?"
2. Enter email address
3. Tap "Send Reset Link"
4. Check email for reset instructions
5. Click link in email
6. Set new password
7. Sign in with new password

### Sign Out Flow

1. On home screen, tap logout icon
2. Returns to welcome screen

## OAuth Providers (Optional)

To test OAuth providers:

### Google

1. In Supabase Dashboard → Authentication → Providers
2. Enable Google provider
3. Add OAuth Client ID and Secret
4. Add redirect URL: `com.yourapp://auth-callback`
5. Update config:
```dart
enabledProviders: [SocialProvider.google],
redirectUrl: 'com.yourapp://auth-callback',
```

### Apple

1. Enable Apple provider in Supabase Dashboard
2. Configure Services ID and key
3. Add redirect URL
4. Enable Sign In with Apple capability in Xcode

### Facebook

1. Create Facebook app
2. Enable Facebook provider in Supabase Dashboard
3. Add App ID and Secret
4. Configure redirect URL

## Platform Configuration

### Android

Add internet permission in `android/app/src/main/AndroidManifest.xml`:

```xml
<uses-permission android:name="android.permission.INTERNET"/>
```

For OAuth deep links, add intent filter:

```xml
<intent-filter>
  <action android:name="android.intent.action.VIEW" />
  <category android:name="android.intent.category.DEFAULT" />
  <category android:name="android.intent.category.BROWSABLE" />
  <data android:scheme="com.yourapp" android:host="auth-callback" />
</intent-filter>
```

### iOS

Add URL scheme in `ios/Runner/Info.plist`:

```xml
<key>CFBundleURLTypes</key>
<array>
  <dict>
    <key>CFBundleTypeRole</key>
    <string>Editor</string>
    <key>CFBundleURLSchemes</key>
    <array>
      <string>com.yourapp</string>
    </array>
  </dict>
</array>
```

## Troubleshooting

### "Invalid API key" Error

- Double-check your supabaseUrl and supabaseAnonKey
- Make sure you're using the **anon key**, not the service role key
- Verify the URL includes https:// and ends with .supabase.co

### Email Not Sending

- Check email provider is enabled in Supabase Dashboard
- Verify SMTP settings (Settings → Authentication → Email)
- Check spam folder
- For testing, disable email confirmation

### "Network error"

- Verify internet connection
- Check firewall settings
- Ensure Supabase project is running
- Try accessing Supabase URL in browser

### Build Errors

```bash
flutter clean
flutter pub get
flutter run
```

## Next Steps

1. Customize UI colors and themes
2. Add social OAuth providers
3. Implement protected routes
4. Add user profile editing
5. Integrate with your backend API
6. Add analytics tracking

## Code Structure

```
example/
├── lib/
│   └── main.dart          # Main app with all screens
├── pubspec.yaml           # Dependencies
└── README.md              # This file
```

The example demonstrates:
- Single-file app for simplicity
- All authentication flows
- Error handling
- Loading states
- Auth state management
- Navigation patterns

## Learn More

- [Supabase Auth Module README](../README.md)
- [Supabase Documentation](https://supabase.com/docs)
- [Flutter Documentation](https://docs.flutter.dev)
