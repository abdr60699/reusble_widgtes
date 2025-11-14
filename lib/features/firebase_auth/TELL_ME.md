# TELL ME - How to Test Firebase Authentication

This guide shows you exactly what screens to create, what buttons to add, and how to test each authentication feature.

## Main File Setup

### 1. Add Navigation Button in main.dart

In your main.dart or home screen, add a button to navigate to the Auth Test Screen:

```
Button: "Test Firebase Auth"
OnPressed: Navigate to AuthTestScreen
```

## Screens to Create

### Screen 1: AuthTestScreen (Main Menu)

**Purpose**: Navigation hub to test all auth features

**UI Elements**:
```
AppBar: "Firebase Auth Testing"

Buttons (in a ListView):
1. "Email/Password Sign Up" → Navigate to SignUpScreen
2. "Email/Password Sign In" → Navigate to SignInScreen
3. "Google Sign-In" → Navigate to GoogleSignInScreen
4. "Apple Sign-In" → Navigate to AppleSignInScreen
5. "Phone Sign-In (OTP)" → Navigate to PhoneSignInScreen
6. "Password Reset" → Navigate to PasswordResetScreen
7. "Account Linking" → Navigate to AccountLinkingScreen
8. "Current User Info" → Navigate to UserProfileScreen
9. "Sign Out" → Call signOut(), then show success message

Bottom section:
Text: "Auth State: [Signed In / Signed Out]"
Text: "User Email: [email or 'Not signed in']"
```

**What You Need to Do**:
- Open app
- See this menu screen
- Tap any button to test that feature

---

### Screen 2: SignUpScreen

**Purpose**: Test email/password sign-up with email verification

**UI Elements**:
```
AppBar: "Sign Up"

Input Fields:
1. TextField: "Email" (with email keyboard)
2. TextField: "Password" (obscureText: true, with eye icon to toggle)
3. TextField: "Confirm Password" (obscureText: true)
4. TextField: "Display Name" (optional)

Button: "Sign Up"

Text Area: Shows success/error messages
```

**What You Need to Do**:
1. Enter email: `test@example.com`
2. Enter password: `Test1234` (must meet requirements)
3. Confirm password: `Test1234` (same as password)
4. Enter name: `Test User`
5. Tap "Sign Up" button

**What You Should See**:
- Success: "Account created! Check your email for verification link."
- Error examples:
  - "Email already in use" (if you sign up twice)
  - "Password too weak" (if password is simple)
  - "Invalid email format" (if email is wrong)

**After Success**:
- Check your email inbox
- You should receive verification email from Firebase
- Click link in email to verify

**Implementation Notes**:
```
On "Sign Up" button press:
1. Validate email format (contains @)
2. Validate password (min 8 chars, has uppercase, lowercase, number)
3. Check passwords match
4. Call: FirebaseAuth.instance.createUserWithEmailAndPassword(email, password)
5. If successful:
   - Update profile: currentUser.updateDisplayName(displayName)
   - Send verification: currentUser.sendEmailVerification()
   - Show success message
6. If error:
   - Map error code to friendly message (see error table in README)
   - Show error message
```

---

### Screen 3: SignInScreen

**Purpose**: Test email/password sign-in

**UI Elements**:
```
AppBar: "Sign In"

Input Fields:
1. TextField: "Email"
2. TextField: "Password" (obscureText: true)

Checkbox: "Remember me" (always checked for Firebase - auto-persists)

Buttons:
1. "Sign In" (primary button)
2. "Forgot Password?" (text button)

Text Area: Shows success/error messages
```

**What You Need to Do**:
1. Enter email: `test@example.com` (account you created in sign-up)
2. Enter password: `Test1234`
3. Tap "Sign In" button

**What You Should See**:
- Success: Navigate to UserProfileScreen, showing user info
- Error examples:
  - "User not found" (if email doesn't exist)
  - "Wrong password" (if password is incorrect)
  - "Too many requests" (if you try many times)

**Implementation Notes**:
```
On "Sign In" button press:
1. Validate email and password not empty
2. Call: FirebaseAuth.instance.signInWithEmailAndPassword(email, password)
3. If successful:
   - Session is automatically saved by Firebase
   - Navigate to home or profile screen
4. If error:
   - Show friendly error message
```

**Testing Session Persistence**:
1. Sign in successfully
2. Close app completely (kill from background)
3. Reopen app
4. You should still be signed in (no need to enter credentials again)

---

### Screen 4: GoogleSignInScreen

**Purpose**: Test Google Sign-In

**UI Elements**:
```
AppBar: "Google Sign-In"

Button: "Sign in with Google" (with Google logo)
  - Style: White background, Google logo on left, "Sign in with Google" text

Text Area: Shows status messages
```

**What You Need to Do**:
1. Tap "Sign in with Google" button
2. Google account picker appears (popup or sheet)
3. Select a Google account
4. Approve the consent (if first time)

**What You Should See**:
- Google account picker shows your Google accounts
- After selecting, you're signed in
- Navigate to UserProfileScreen
- See your Google email, name, and photo

**If Account Already Exists**:
- If email already used by email/password account
- Show message: "Account exists with different provider. Link accounts?"
- Offer to link (see Account Linking section)

**Implementation Notes**:
```
On "Sign in with Google" button press:
1. Initialize GoogleSignIn
2. Call: googleSignIn.signIn()
3. Get GoogleSignInAuthentication from result
4. Create credential: GoogleAuthProvider.credential(
     accessToken: googleAuth.accessToken,
     idToken: googleAuth.idToken
   )
5. Call: FirebaseAuth.instance.signInWithCredential(credential)
6. If successful: Navigate to profile
7. If error "account-exists-with-different-credential":
   - Fetch sign-in methods for email
   - Show linking UI
```

**Troubleshooting**:
- If button does nothing: Check SHA-1 fingerprint added to Firebase
- If error "10": Check google-services.json is in android/app/
- If error "12500": OAuth client not configured properly

---

### Screen 5: AppleSignInScreen

**Purpose**: Test Apple Sign-In (iOS only, or web fallback on Android)

**UI Elements**:
```
AppBar: "Apple Sign-In"

Button: "Sign in with Apple" (black button with Apple logo)
  - Style: Black background, white Apple logo, white text

Text Area: Shows status messages
```

**What You Need to Do** (iOS):
1. Tap "Sign in with Apple" button
2. FaceID/TouchID prompt appears
3. Approve with biometric
4. Choose to share or hide email
5. Approve sign-in

**What You Should See**:
- Apple authentication sheet
- After approval, signed in
- Navigate to UserProfileScreen
- See Apple-provided email (may be privaterelay email if user chose to hide)

**Implementation Notes**:
```
On "Sign in with Apple" button press:
1. Check if Apple Sign-In available (iOS 13+ or web)
2. Call: SignInWithApple.getAppleIDCredential()
3. Get credential with identityToken
4. Create OAuthCredential: OAuthProvider("apple.com").credential(
     idToken: appleIdCredential.identityToken
   )
5. Call: FirebaseAuth.instance.signInWithCredential(credential)
6. If successful: Navigate to profile
```

**Note**: On Android, you need web-based Apple sign-in flow or show "Apple Sign-In only available on iOS"

---

### Screen 6: PhoneSignInScreen

**Purpose**: Test phone authentication with OTP

**UI Elements**:
```
AppBar: "Phone Sign-In"

Step 1 - Enter Phone:
  TextField: "Phone Number" (hint: "+1234567890")
  Dropdown: Country code selector
  Button: "Send OTP"

Step 2 - Enter Code (shows after sending):
  TextField: "6-digit code"
  Button: "Verify Code"
  TextButton: "Resend Code" (enabled after 60 seconds)
  Text: "Code sent to [phone number]"
  Text: "Resend in [countdown] seconds"

Text Area: Shows status messages
```

**What You Need to Do**:
1. Enter phone number with country code: `+1234567890`
2. Tap "Send OTP"
3. Wait for SMS (or see code in console if test number)
4. Enter 6-digit code: `123456`
5. Tap "Verify Code"

**What You Should See**:
- After "Send OTP": "Code sent to +1234567890"
- SMS received on phone with 6-digit code
- On Android: Code may auto-fill (if SMS Reader permission granted)
- After verification: Signed in, navigate to profile

**For Testing Without SMS Charges**:
1. Go to Firebase Console → Authentication → Settings
2. Add test phone number: `+1234567890`
3. Set test code: `123456`
4. Use this in app - no actual SMS sent, code is always `123456`

**Implementation Notes**:
```
On "Send OTP" button press:
1. Validate phone number format (+country code + number)
2. Call: FirebaseAuth.instance.verifyPhoneNumber(
     phoneNumber: phoneNumber,
     verificationCompleted: (credential) {
       // Auto sign-in (Android auto-read)
     },
     verificationFailed: (error) {
       // Show error
     },
     codeSent: (verificationId, resendToken) {
       // Save verificationId, show code input UI
     },
     codeAutoRetrievalTimeout: (verificationId) {
       // Timeout, user must enter manually
     }
   )
3. When user enters code:
   - Create credential: PhoneAuthProvider.credential(
       verificationId: verificationId,
       smsCode: code
     )
   - Call: FirebaseAuth.instance.signInWithCredential(credential)
```

**Resend Code**:
- Use the `resendToken` from previous verification
- Call `verifyPhoneNumber()` again with `forceResendingToken: resendToken`

---

### Screen 7: PasswordResetScreen

**Purpose**: Test password reset flow

**UI Elements**:
```
AppBar: "Reset Password"

TextField: "Email"
Button: "Send Reset Email"

Text Area: Shows success/error messages
```

**What You Need to Do**:
1. Enter email of existing account: `test@example.com`
2. Tap "Send Reset Email"

**What You Should See**:
- Message: "Password reset email sent. Check your inbox."
- Check email inbox
- Receive password reset email from Firebase
- Click link in email
- Opens browser with password reset page
- Enter new password
- Confirm new password
- Password updated

**After Reset**:
1. Go back to app
2. Try signing in with OLD password - should fail
3. Sign in with NEW password - should work

**Implementation Notes**:
```
On "Send Reset Email" button press:
1. Validate email format
2. Call: FirebaseAuth.instance.sendPasswordResetEmail(email: email)
3. Always show success message (don't reveal if email exists - security)
4. Message: "If this email is registered, you'll receive a reset link."
```

**Security Note**: Don't tell user if email exists or not (prevents email enumeration)

---

### Screen 8: AccountLinkingScreen

**Purpose**: Test linking multiple providers to one account

**UI Elements**:
```
AppBar: "Link Accounts"

Section 1: Current Providers
  Text: "Currently linked providers:"
  List of chips/badges:
    - "Email: test@example.com" (if linked)
    - "Google: user@gmail.com" (if linked)
    - "Apple: privaterelay@apple.com" (if linked)
    - "Phone: +1234567890" (if linked)

Section 2: Link New Provider
  Buttons:
    - "Link Google Account"
    - "Link Apple Account"
    - "Link Phone Number"

Section 3: Unlink Provider
  Text: "Tap a provider above to unlink"
  Warning: "Must keep at least one sign-in method"

Text Area: Shows status messages
```

**What You Need to Do - Link Google**:
1. Sign in with email/password first (SignInScreen)
2. Navigate to AccountLinkingScreen
3. See "Email" badge in current providers
4. Tap "Link Google Account"
5. Google account picker appears
6. Select Google account
7. Approve

**What You Should See**:
- After linking: Both "Email" and "Google" badges shown
- Success message: "Google account linked!"
- Now you can sign in with either email/password OR Google

**What You Need to Do - Unlink Provider**:
1. Tap on "Google" badge
2. Confirm unlink
3. Google provider removed

**What You Should See**:
- Google badge disappears
- Only "Email" badge remains
- Can still sign in with email/password
- Cannot sign in with Google anymore

**Implementation Notes**:
```
To get current providers:
  final providers = FirebaseAuth.instance.currentUser?.providerData ?? []
  Show list of providers

To link Google:
  1. Get Google credential (same as sign-in)
  2. Call: currentUser.linkWithCredential(credential)
  3. If successful: Provider linked
  4. If error "credential-already-in-use":
     - Another account has this Google account
     - Cannot link

To unlink:
  1. Check providers.length > 1 (must keep at least one)
  2. Call: currentUser.unlink(providerId)
  3. Provider ID examples:
     - "password" (email/password)
     - "google.com" (Google)
     - "apple.com" (Apple)
     - "phone" (Phone)
```

**Testing Flow**:
```
1. Sign up with email/password
2. Link Google account
3. Sign out
4. Sign in with Google - works!
5. Sign in with email/password - also works!
6. Unlink email/password provider
7. Sign out
8. Try sign in with email/password - should fail
9. Sign in with Google - still works
```

---

### Screen 9: UserProfileScreen

**Purpose**: Show current user information and auth state

**UI Elements**:
```
AppBar: "User Profile"

If signed in:
  CircleAvatar: User photo (or initials if no photo)
  Text: "Name: [displayName]"
  Text: "Email: [email]"
  Text: "Phone: [phoneNumber]"
  Text: "Email Verified: [Yes/No]"
  Text: "User ID: [uid]"
  Text: "Providers: [list of linked providers]"

  Button: "Refresh Token" (tap to manually refresh)
  Button: "Send Email Verification" (if not verified)
  Button: "Sign Out"

If signed out:
  Text: "Not signed in"
  Button: "Go to Sign In"
```

**What You Need to Do**:
1. Sign in (using any method)
2. Navigate to UserProfileScreen

**What You Should See**:
- Your email address
- Your name (if provided)
- Email verified status (Yes/No)
- Unique user ID (Firebase UID)
- List of providers (e.g., "password", "google.com")

**Send Email Verification**:
1. If "Email Verified" shows "No"
2. Tap "Send Email Verification"
3. Check email inbox
4. Click verification link
5. Refresh screen (or reopen app)
6. "Email Verified" should now show "Yes"

**Implementation Notes**:
```
Get current user:
  final user = FirebaseAuth.instance.currentUser

Display info:
  Email: user?.email
  Name: user?.displayName
  Photo: user?.photoURL
  Verified: user?.emailVerified
  UID: user?.uid
  Phone: user?.phoneNumber
  Providers: user?.providerData (list of UserInfo)

Send verification:
  await user?.sendEmailVerification()

Refresh token:
  await user?.reload()
  // Then get fresh data
  final freshUser = FirebaseAuth.instance.currentUser
```

---

## Testing Checklist

### Email/Password Flow
- [ ] Create account with valid email/password
- [ ] Try creating account with same email (should fail)
- [ ] Sign in with correct credentials
- [ ] Sign in with wrong password (should show error)
- [ ] Receive and click email verification link
- [ ] Email verified status updates
- [ ] Session persists after app restart
- [ ] Reset password via email
- [ ] Sign in with new password works
- [ ] Sign out clears session

### Google Sign-In Flow
- [ ] Sign in with Google account
- [ ] See Google profile info (name, email, photo)
- [ ] Session persists after app restart
- [ ] Sign out clears Google session
- [ ] Sign in with Google again works

### Apple Sign-In Flow (iOS)
- [ ] Sign in with Apple works
- [ ] FaceID/TouchID prompt appears
- [ ] Can choose to hide email
- [ ] Session persists
- [ ] Sign out works

### Phone Authentication Flow
- [ ] Enter phone number
- [ ] Receive SMS with code
- [ ] Enter code manually
- [ ] Sign in successful
- [ ] On Android: Code auto-fills (if permission granted)
- [ ] Resend code works after 60 seconds

### Account Linking Flow
- [ ] Sign in with email/password
- [ ] Link Google account
- [ ] See both providers in profile
- [ ] Sign out
- [ ] Sign in with Google - works
- [ ] Sign in with email/password - also works
- [ ] Unlink one provider
- [ ] Can still sign in with remaining provider
- [ ] Cannot unlink last provider (error shown)

### Error Handling
- [ ] Invalid email format shows error
- [ ] Weak password shows error
- [ ] Network error handled gracefully (turn off wifi, try signing in)
- [ ] Too many attempts triggers rate limit
- [ ] All errors show user-friendly messages

### Session & Token
- [ ] Sign in, close app, reopen - still signed in
- [ ] Token auto-refreshes (happens in background)
- [ ] Sign out completely clears session
- [ ] After sign out, must sign in again

---

## Quick Test Script

**5-Minute Test (Email/Password)**:
1. Open app → Tap "Test Firebase Auth"
2. Tap "Email/Password Sign Up"
3. Enter email, password, confirm, name
4. Tap Sign Up → See success
5. Check email → Click verification link
6. Back to app → Tap "Sign Out"
7. Tap "Email/Password Sign In"
8. Enter same email/password
9. Tap Sign In → See profile with your info
10. Close app, reopen → Still signed in ✓

**10-Minute Full Test**:
1. Do 5-minute test above
2. Tap "Link Accounts" → Link Google
3. Sign out
4. Sign in with Google → Works ✓
5. Go to profile → See both Email and Google providers
6. Unlink Email provider
7. Sign out
8. Try email sign-in → Fails (provider unlinked) ✓
9. Sign in with Google → Still works ✓

**Phone Auth Test**:
1. Add test phone in Firebase Console
2. In app → Tap "Phone Sign-In"
3. Enter test phone: +1234567890
4. Tap Send OTP
5. Enter test code: 123456
6. Tap Verify → Signed in ✓

---

## What to Expect

### Success Signs:
- ✓ Firebase Console shows new users under Authentication → Users
- ✓ Email verification emails arrive in inbox
- ✓ Password reset emails arrive in inbox
- ✓ Session persists after closing and reopening app
- ✓ User info displays correctly in profile screen
- ✓ Can sign in with any linked provider
- ✓ Errors show friendly messages, not raw error codes

### Common First-Time Issues:
- **Android Google Sign-In fails**: Add SHA-1 to Firebase Console
- **iOS GoogleService-Info.plist not found**: Drag into Xcode, check "Copy items"
- **Email not received**: Check spam folder, check email is correct in Firebase Console
- **Phone OTP not received**: Use test phone numbers first, then enable billing for real SMS
- **"User not found" after sign-up**: Email not verified yet, or using wrong credentials

---

## Next Steps

1. **Implement all screens** above
2. **Add navigation** from main screen to each test screen
3. **Test each flow** using the checklists
4. **Handle errors** with friendly messages
5. **Add loading states** (spinners while waiting)
6. **Add form validation** (email format, password strength)
7. **Style the UI** to match your app design
8. **Test on real devices** (both Android and iOS)
9. **Test edge cases** (no internet, invalid input, etc.)
10. **Monitor** Firebase Console → Authentication → Users to see accounts being created

That's it! Follow these screens and test steps to see your Firebase Authentication working end-to-end.
