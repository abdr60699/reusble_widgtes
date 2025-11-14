# Firebase Authentication - Simple Implementation Guide

A straightforward guide to implement Firebase Authentication in your Flutter app. No code, just clear steps and patterns.

## Quick Setup (30 Minutes)

### 1. Firebase Project Setup

**Create Project**:
1. Go to [Firebase Console](https://console.firebase.google.com)
2. Click "Add project"
3. Enter project name
4. Disable Google Analytics (or enable if needed)
5. Click "Create project"

**Enable Authentication**:
1. In Firebase Console, go to "Authentication"
2. Click "Get started"
3. Go to "Sign-in method" tab
4. Enable providers you need:
   - Email/Password: Click, toggle "Enable", Save
   - Google: Click, toggle "Enable", Save
   - Phone: Click, toggle "Enable", Save (requires billing)
   - Apple: Click, toggle "Enable", configure Service ID and key, Save
   - Facebook: Click, toggle "Enable", add App ID and Secret, Save

### 2. Platform Setup

**Android**:
1. In Firebase Console, click "Add app" → Android
2. Enter your package name (from `android/app/build.gradle`)
3. Download `google-services.json`
4. Place in `android/app/`
5. Get SHA-1 fingerprint:
   ```bash
   cd android
   ./gradlew signingReport
   ```
6. Copy SHA-1 from output
7. In Firebase Console → Project Settings → Your apps → Add fingerprint
8. Paste SHA-1, click Save

**iOS**:
1. In Firebase Console, click "Add app" → iOS
2. Enter your bundle ID (from Xcode project)
3. Download `GoogleService-Info.plist`
4. Open Xcode, drag file into project root
5. Ensure "Copy items if needed" is checked

**Web**:
1. In Firebase Console, click "Add app" → Web
2. Enter app nickname
3. Copy config object (you'll need this later)
4. In Authentication → Settings → Authorized domains
5. Add your domain (localhost is already there)

### 3. Flutter Dependencies

Add to `pubspec.yaml`:
```yaml
dependencies:
  firebase_core: ^2.24.0
  firebase_auth: ^4.16.0

  # For Google Sign-In
  google_sign_in: ^6.1.5

  # For Apple Sign-In
  sign_in_with_apple: ^5.0.0

  # For Facebook Login
  flutter_facebook_auth: ^6.0.3

  # For secure storage (optional)
  flutter_secure_storage: ^9.0.0
```

Run: `flutter pub get`

### 4. Initialize Firebase

In `main.dart`:
```
Steps:
1. Import firebase_core
2. Make main() async
3. Call WidgetsFlutterBinding.ensureInitialized()
4. Call await Firebase.initializeApp()
5. Then call runApp()

This initializes Firebase before your app starts.
```

## Implementation Patterns

### Auth Service Structure

Create a service class that wraps Firebase Auth:

**AuthService responsibilities**:
- Sign up with email/password
- Sign in with email/password
- Sign in with Google
- Sign in with Apple
- Sign in with Facebook
- Sign in with phone (OTP)
- Send email verification
- Send password reset
- Sign out
- Get current user
- Listen to auth state changes

**Singleton pattern**:
- One instance for entire app
- Access via `AuthService.instance`

### Sign-Up Flow (Email/Password)

**Steps**:
1. User enters email, password, confirm password
2. Validate inputs:
   - Email format valid
   - Password meets requirements (min 8 chars, has uppercase, lowercase, number)
   - Passwords match
3. Call Firebase Auth `createUserWithEmailAndPassword(email, password)`
4. If successful:
   - User account created
   - Send email verification
   - Show "Check your email" message
5. If error:
   - email-already-in-use: Show "Email already registered. Try signing in."
   - weak-password: Show "Password too weak. Use stronger password."
   - invalid-email: Show "Invalid email format"
   - Show generic error for others

**Email verification**:
- After sign-up, call `sendEmailVerification()`
- User receives email with link
- When they click, email is verified
- Check `user.emailVerified` before allowing sensitive actions

### Sign-In Flow (Email/Password)

**Steps**:
1. User enters email and password
2. Call Firebase Auth `signInWithEmailAndPassword(email, password)`
3. If successful:
   - User is signed in
   - Firebase automatically saves session
   - Navigate to home screen
4. If error:
   - user-not-found: Show "No account with this email. Sign up?"
   - wrong-password: Show "Incorrect password. Forgot password?"
   - user-disabled: Show "Account disabled. Contact support."
   - too-many-requests: Show "Too many attempts. Try later."

**Session persistence**:
- Firebase automatically persists session
- On app restart, check if user is signed in
- Use `FirebaseAuth.instance.authStateChanges()` stream
- If user exists, go to home. If null, show sign-in.

### Google Sign-In Flow

**Setup**:
1. Enable Google in Firebase Console
2. Add SHA-1 fingerprint (Android)
3. Add GoogleService-Info.plist (iOS)
4. Add google_sign_in dependency

**Steps**:
1. User taps "Sign in with Google"
2. Call Google Sign-In SDK
3. Google shows account picker
4. User selects account
5. Get Google credential
6. Call Firebase Auth `signInWithCredential(googleCredential)`
7. If successful: User signed in
8. If error:
   - account-exists-with-different-credential: Show linking option
   - Handle other errors

**Account linking**:
- If user already has account with same email (different provider)
- Fetch sign-in methods for email
- Show "Email already used. Sign in with [provider] to link."
- After signing in, call `linkWithCredential()` to link Google

### Apple Sign-In Flow (iOS Required)

**Setup**:
1. Enable Apple in Firebase Console
2. In Apple Developer portal:
   - Create App ID with Sign in with Apple capability
   - Create Service ID
   - Create Key for Sign in with Apple
3. Configure in Firebase Console (Service ID, Key ID, Team ID)
4. Add Sign in with Apple capability in Xcode

**Steps**:
1. User taps "Sign in with Apple"
2. Apple shows consent screen
3. User approves
4. Get Apple credential
5. Call Firebase Auth `signInWithCredential(appleCredential)`
6. User signed in

**Note**: Apple sign-in is required if you offer other social sign-in on iOS.

### Phone Sign-In Flow (OTP)

**Setup**:
1. Enable Phone in Firebase Console (requires billing enabled)
2. Add test phone numbers in Firebase Console for testing

**Steps**:
1. User enters phone number with country code (e.g., +1234567890)
2. Call `verifyPhoneNumber(phoneNumber)`
3. Firebase sends SMS with 6-digit code
4. User enters code
5. Verify code with `signInWithCredential(phoneCredential)`
6. User signed in

**Auto-retrieval** (Android):
- On Android, code can be auto-read from SMS
- Use `verificationCompleted` callback
- Sign in automatically without user entering code

**Resend code**:
- Allow resend after 30-60 seconds
- Call `verifyPhoneNumber()` again
- New code sent

### Password Reset Flow

**Steps**:
1. User taps "Forgot password"
2. User enters email
3. Call `sendPasswordResetEmail(email)`
4. User receives email with reset link
5. User clicks link (opens browser)
6. User enters new password
7. Password updated
8. User can sign in with new password

**In-app**:
- Show success message after sending email
- Don't reveal if email exists (security)
- Always show "If email exists, reset link sent"

### Sign-Out Flow

**Steps**:
1. User taps "Sign out"
2. Show confirmation: "Are you sure?"
3. Call `FirebaseAuth.instance.signOut()`
4. Clear any cached user data
5. Navigate to sign-in screen

**Complete sign-out**:
- Firebase Auth sign-out
- Google Sign-In sign-out (if used)
- Clear local storage/cache
- Reset app state

### Account Linking

**Why**: Allow users to sign in with multiple providers (email + Google + Apple)

**Steps**:
1. User signed in with email/password
2. User wants to add Google sign-in
3. Call Google Sign-In to get credential
4. Call `currentUser.linkWithCredential(googleCredential)`
5. Now user can sign in with email OR Google

**Collision handling**:
- If email already used by another account
- Error: account-exists-with-different-credential
- Fetch providers for email
- Ask user to sign in with existing provider
- Then link new provider

### Account Unlinking

**Steps**:
1. Get list of linked providers: `currentUser.providerData`
2. User selects provider to remove
3. Check if it's not the last provider (must keep at least one)
4. Call `currentUser.unlink(providerId)`
5. Provider removed

**Provider IDs**:
- Email: "password"
- Google: "google.com"
- Apple: "apple.com"
- Facebook: "facebook.com"
- Phone: "phone"

## Error Handling

### Common Error Codes

| Error Code | User Message | Action |
|------------|--------------|--------|
| email-already-in-use | "This email is already registered. Try signing in." | Link to sign-in |
| weak-password | "Password too weak. Use at least 8 characters." | Show requirements |
| user-not-found | "No account found. Sign up instead?" | Link to sign-up |
| wrong-password | "Incorrect password. Forgot password?" | Link to reset |
| invalid-email | "Invalid email format" | Fix email |
| user-disabled | "Account disabled. Contact support." | Support link |
| too-many-requests | "Too many attempts. Try again later." | Wait/CAPTCHA |
| requires-recent-login | "Please sign in again to continue" | Re-authenticate |
| network-request-failed | "Network error. Check connection." | Retry |

### Error Handler Pattern

Create a function that maps error codes to user-friendly messages:

```
Function: handleAuthError(error)
Input: Firebase error code
Output: User-friendly message + suggested action

Example:
  If error = "user-not-found"
  Return: "No account with this email. Would you like to sign up?"

  If error = "wrong-password"
  Return: "Incorrect password. Try again or reset your password."
```

## Security Best Practices

### 1. Email Verification

**Enforce for sensitive actions**:
- Check `user.emailVerified` before:
  - Changing password
  - Deleting account
  - Accessing sensitive data

**Send verification**:
- After sign-up
- After email change
- Allow resend (with rate limit)

### 2. Password Requirements

**Minimum requirements**:
- At least 8 characters
- At least one uppercase letter
- At least one lowercase letter
- At least one number
- Optional: One special character

**Show strength indicator**:
- Weak: Less than 8 chars
- Medium: Meets minimums
- Strong: 12+ chars with special chars

### 3. Re-authentication

**When required**:
- Before password change
- Before email change
- Before account deletion
- Before linking new provider

**How**:
- User enters current password
- Call `reauthenticateWithCredential(credential)`
- Then perform sensitive action
- If error: Show "Incorrect password"

### 4. Rate Limiting

**Firebase built-in**:
- Too many sign-in attempts: Temporary block
- Too many password resets: Rate limited
- SMS OTP: Limited sends per day

**App-side**:
- Disable button after click (prevent double-submit)
- Show loading state
- Implement exponential backoff on errors

### 5. Token Security

**ID Tokens**:
- Short-lived (1 hour)
- Auto-refresh by Firebase
- Never log or expose tokens
- Send to backend for verification

**Custom Claims** (Backend):
- Set user roles/permissions
- Verified by backend
- Reflected in token
- Refresh token to get new claims

## Testing

### Test Accounts

**Firebase Test Mode**:
1. In Firebase Console → Authentication → Settings
2. Add test phone numbers:
   - Phone: +1234567890
   - Code: 123456
3. Use these for testing without SMS charges

### Test Scenarios

**Email/Password**:
- [ ] Sign up with valid email/password
- [ ] Sign up with existing email (should fail)
- [ ] Sign in with correct credentials
- [ ] Sign in with wrong password (should fail)
- [ ] Send password reset email
- [ ] Verify email works

**Social Sign-In**:
- [ ] Sign in with Google
- [ ] Sign in with Apple (iOS)
- [ ] Sign in with Facebook
- [ ] Handle cancelled sign-in

**Account Linking**:
- [ ] Link Google to email account
- [ ] Link Apple to existing account
- [ ] Handle email collision
- [ ] Unlink provider

**Session**:
- [ ] Session persists after app restart
- [ ] Sign out clears session
- [ ] Token refresh works

**Errors**:
- [ ] Invalid email shows error
- [ ] Weak password shows error
- [ ] Network error handled gracefully

## Common Issues

### Android

**SHA fingerprint mismatch**:
- Run `./gradlew signingReport` in `android/`
- Copy SHA-1 and SHA-256
- Add to Firebase Console → Project Settings → Your apps
- Add for both debug and release

**Google Sign-In fails**:
- Check SHA-1 added to Firebase
- Check package name matches
- Re-download google-services.json after changes
- Clean and rebuild: `flutter clean && flutter run`

### iOS

**GoogleService-Info.plist not found**:
- Download from Firebase Console
- Drag into Xcode (not just file system)
- Check "Copy items if needed"
- Verify it's in project root, not subfolder

**Apple Sign-In fails**:
- Check Sign in with Apple capability enabled in Xcode
- Check bundle ID matches in Firebase and Apple Developer
- Verify Service ID and Key ID configured in Firebase

### Web

**OAuth fails on localhost**:
- Firebase Console → Authentication → Settings → Authorized domains
- Add `localhost` if not present
- For production, add your domain

**Redirect issues**:
- Use `signInWithPopup()` for popup flow
- Use `signInWithRedirect()` for redirect flow
- Redirect is better for mobile browsers

## Project Structure

```
lib/
├── main.dart
├── services/
│   ├── auth_service.dart          # Main auth logic
│   ├── auth_error_handler.dart    # Error mapping
│   └── validators.dart             # Email/password validation
├── models/
│   ├── user_model.dart             # User data model
│   └── auth_result.dart            # Sign-in result wrapper
├── screens/
│   ├── auth/
│   │   ├── sign_in_screen.dart
│   │   ├── sign_up_screen.dart
│   │   ├── forgot_password_screen.dart
│   │   ├── email_verification_screen.dart
│   │   └── profile_screen.dart
│   └── home_screen.dart
├── widgets/
│   ├── auth_text_field.dart        # Reusable input field
│   ├── auth_button.dart            # Styled button
│   └── social_sign_in_buttons.dart # Google/Apple/Facebook buttons
└── utils/
    └── auth_state_wrapper.dart     # Wraps app, routes based on auth
```

## Quick Reference

### Firebase Auth Methods

- `createUserWithEmailAndPassword(email, password)` - Sign up
- `signInWithEmailAndPassword(email, password)` - Sign in
- `signInWithCredential(credential)` - Sign in with provider
- `sendPasswordResetEmail(email)` - Send reset email
- `sendEmailVerification()` - Send verification email
- `signOut()` - Sign out
- `currentUser` - Get current user (null if not signed in)
- `authStateChanges()` - Stream of auth state changes
- `linkWithCredential(credential)` - Link provider
- `unlink(providerId)` - Unlink provider
- `reauthenticateWithCredential(credential)` - Re-auth for sensitive ops

### User Properties

- `uid` - Unique user ID
- `email` - User email
- `displayName` - User display name
- `photoURL` - Profile photo URL
- `emailVerified` - Email verification status
- `phoneNumber` - Phone number
- `providerData` - List of linked providers

## Next Steps

1. **Set up Firebase project** (Console configuration)
2. **Add platform configs** (google-services.json, GoogleService-Info.plist)
3. **Add dependencies** to pubspec.yaml
4. **Initialize Firebase** in main()
5. **Create AuthService** with methods
6. **Build UI screens** (sign-in, sign-up, etc.)
7. **Handle auth state** (route based on signed-in status)
8. **Test all flows** (sign-up, sign-in, reset, linking)
9. **Add error handling** (user-friendly messages)
10. **Deploy and monitor**

That's it! Follow these patterns and you'll have working authentication in 30-60 minutes.

---

**Version**: 1.0.0
**Last Updated**: 2025-11-13
**Type**: Simple Implementation Guide
