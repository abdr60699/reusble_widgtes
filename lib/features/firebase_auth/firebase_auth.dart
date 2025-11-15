/// Firebase Authentication Module
///
/// Production-ready Firebase authentication module for Flutter apps.
///
/// Provides complete authentication functionality including:
/// - Email/Password authentication
/// - Phone OTP authentication with SMS verification
/// - Social sign-ins (Google, Apple, Facebook)
/// - Anonymous sign-in
/// - Account linking/unlinking between providers
/// - Email verification
/// - Password reset
/// - Session & token management with secure storage
/// - Reauthentication for sensitive operations
/// - Account deletion
///
/// ## Quick Start
///
/// ### 1. Initialize Firebase
///
/// ```dart
/// void main() async {
///   WidgetsFlutterBinding.ensureInitialized();
///   await Firebase.initializeApp(
///     options: DefaultFirebaseOptions.currentPlatform,
///   );
///   runApp(MyApp());
/// }
/// ```
///
/// ### 2. Set up dependency injection (Riverpod example)
///
/// ```dart
/// import 'package:flutter_riverpod/flutter_riverpod.dart';
/// import 'package:reuablewidgets/features/firebase_auth/firebase_auth.dart';
///
/// void main() async {
///   // ... Firebase initialization
///
///   runApp(
///     ProviderScope(
///       child: MyApp(),
///     ),
///   );
/// }
///
/// class MyApp extends ConsumerWidget {
///   @override
///   Widget build(BuildContext context, WidgetRef ref) {
///     final authState = ref.watch(authStateProvider);
///
///     return MaterialApp(
///       home: authState.when(
///         data: (user) => user != null ? HomeScreen() : SignInScreen(),
///         loading: () => SplashScreen(),
///         error: (error, stack) => ErrorScreen(error: error),
///       ),
///     );
///   }
/// }
/// ```
///
/// ### 3. Use authentication services
///
/// ```dart
/// class SignInButton extends ConsumerWidget {
///   @override
///   Widget build(BuildContext context, WidgetRef ref) {
///     return ElevatedButton(
///       onPressed: () async {
///         final authService = ref.read(authServiceProvider);
///         try {
///           await authService.signInWithGoogle();
///         } on AuthError catch (e) {
///           ScaffoldMessenger.of(context).showSnackBar(
///             SnackBar(content: Text(e.message)),
///           );
///         }
///       },
///       child: Text('Sign in with Google'),
///     );
///   }
/// }
/// ```
///
/// ## Using GetIt instead of Riverpod
///
/// ```dart
/// void main() async {
///   WidgetsFlutterBinding.ensureInitialized();
///   await Firebase.initializeApp();
///
///   // Register auth dependencies
///   registerAuthDependencies();
///
///   runApp(MyApp());
/// }
///
/// class MyApp extends StatelessWidget {
///   @override
///   Widget build(BuildContext context) {
///     final authService = GetIt.I<AuthService>();
///
///     return MaterialApp(
///       home: StreamBuilder<UserModel?>(
///         stream: authService.authStateChanges,
///         builder: (context, snapshot) {
///           if (snapshot.connectionState == ConnectionState.waiting) {
///             return SplashScreen();
///           }
///           return snapshot.hasData ? HomeScreen() : SignInScreen();
///         },
///       ),
///     );
///   }
/// }
/// ```
///
/// ## Available Authentication Methods
///
/// - `signUpWithEmail()` - Create account with email/password
/// - `signInWithEmail()` - Sign in with email/password
/// - `signInWithGoogle()` - Sign in with Google account
/// - `signInWithApple()` - Sign in with Apple ID (iOS)
/// - `signInWithFacebook()` - Sign in with Facebook account
/// - `signInAnonymously()` - Sign in without credentials
/// - `verifyPhoneNumber()` - Start phone authentication with OTP
/// - `verifyPhoneOtp()` - Complete phone authentication
/// - `linkWithEmailPassword()` - Link email/password to account
/// - `linkWithGoogle()` - Link Google account
/// - `linkWithApple()` - Link Apple ID
/// - `linkWithFacebook()` - Link Facebook account
/// - `unlinkProvider()` - Remove authentication provider
/// - `sendEmailVerification()` - Send verification email
/// - `sendPasswordReset()` - Send password reset email
/// - `changePassword()` - Update password
/// - `updateProfile()` - Update display name/photo
/// - `reauthenticateWithEmail()` - Reauthenticate for sensitive ops
/// - `deleteAccount()` - Permanently delete user account
/// - `signOut()` - Sign out from all providers
///
/// ## UI Components
///
/// Pre-built UI screens for common flows:
/// - `SignInScreen` - Email/password and social sign-in
/// - `SignUpScreen` - Account creation with email/password
/// - `PhoneSignInScreen` - Phone OTP authentication
/// - `ProfileScreen` - Profile management and linked accounts
///
/// ## Error Handling
///
/// All methods throw `AuthError` exceptions with user-friendly messages:
///
/// ```dart
/// try {
///   await authService.signInWithEmail(
///     email: email,
///     password: password,
///   );
/// } on AuthError catch (e) {
///   print('Error code: ${e.code}');
///   print('Message: ${e.message}');
///   print('Is recoverable: ${e.isRecoverable}');
/// }
/// ```
///
/// ## Platform Setup
///
/// See README.md for detailed platform-specific setup instructions:
/// - Android: google-services.json, SHA keys for Google Sign-In
/// - iOS: GoogleService-Info.plist, URL schemes, capabilities
/// - Web: Firebase config, authorized domains
/// - Facebook: App ID, client token
/// - Apple: Services ID, private key
///
/// ## Server-Side Token Verification
///
/// To verify ID tokens on your backend:
///
/// ```dart
/// final token = await authService.getIdToken();
///
/// // Send to your backend
/// final response = await http.post(
///   '/api/protected',
///   headers: {'Authorization': 'Bearer $token'},
/// );
/// ```
///
/// Backend verification (Node.js example):
/// ```javascript
/// const admin = require('firebase-admin');
///
/// async function verifyToken(req, res, next) {
///   const token = req.headers.authorization?.split('Bearer ')[1];
///   try {
///     const decodedToken = await admin.auth().verifyIdToken(token);
///     req.userId = decodedToken.uid;
///     next();
///   } catch (error) {
///     res.status(401).send('Unauthorized');
///   }
/// }
/// ```
///
/// For complete documentation, see README.md
library firebase_auth;

// Core models
export 'models/user_model.dart';

// Services
export 'services/auth_service.dart';
export 'repository/auth_repository.dart';

// Storage
export 'storage/token_store.dart';

// Errors
export 'errors/auth_error.dart';

// Validators
export 'utils/validators.dart';

// Dependency injection providers
export 'providers/auth_providers.dart';

// UI components
export 'ui/sign_in_screen.dart';
export 'ui/sign_up_screen.dart';
export 'ui/phone_signin_screen.dart';
export 'ui/profile_screen.dart';
