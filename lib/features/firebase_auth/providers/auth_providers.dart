/// Dependency Injection Providers for Firebase Authentication Module
///
/// This file provides examples for integrating the auth module with popular
/// dependency injection solutions:
/// - Riverpod (recommended for new projects)
/// - GetIt (popular service locator)
///
/// Choose the approach that best fits your app's architecture.
library;

import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../models/user_model.dart';
import '../repository/auth_repository.dart';
import '../services/auth_service.dart';
import '../storage/token_store.dart';

// =============================================================================
// RIVERPOD PROVIDERS
// =============================================================================

/// Firebase Auth instance provider
///
/// Provides the singleton Firebase Auth instance
final firebaseAuthProvider = Provider<firebase_auth.FirebaseAuth>((ref) {
  return firebase_auth.FirebaseAuth.instance;
});

/// Google Sign-In instance provider
///
/// Provides the Google Sign-In instance with default configuration
final googleSignInProvider = Provider<GoogleSignIn>((ref) {
  return GoogleSignIn(
    scopes: ['email', 'profile'],
  );
});

/// Token Store provider
///
/// Provides secure token storage using the hybrid approach
/// (secure storage for tokens, SharedPreferences for session data)
final tokenStoreProvider = Provider<TokenStore>((ref) {
  return HybridTokenStore();
});

/// Auth Repository provider
///
/// Provides the authentication repository that wraps Firebase SDK
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository(
    firebaseAuth: ref.watch(firebaseAuthProvider),
    googleSignIn: ref.watch(googleSignInProvider),
    tokenStore: ref.watch(tokenStoreProvider),
  );
});

/// Auth Service provider
///
/// Provides the main authentication service - this is what your app should use
///
/// Example:
/// ```dart
/// class MyWidget extends ConsumerWidget {
///   @override
///   Widget build(BuildContext context, WidgetRef ref) {
///     final authService = ref.watch(authServiceProvider);
///
///     return ElevatedButton(
///       onPressed: () async {
///         await authService.signInWithGoogle();
///       },
///       child: Text('Sign in with Google'),
///     );
///   }
/// }
/// ```
final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService(
    repository: ref.watch(authRepositoryProvider),
  );
});

/// Current user provider
///
/// Provides the currently signed-in user (synchronous)
/// Returns null if no user is signed in
///
/// Example:
/// ```dart
/// class ProfileWidget extends ConsumerWidget {
///   @override
///   Widget build(BuildContext context, WidgetRef ref) {
///     final user = ref.watch(currentUserProvider);
///
///     if (user == null) {
///       return Text('Not signed in');
///     }
///
///     return Text('Hello, ${user.displayName ?? user.email}!');
///   }
/// }
/// ```
final currentUserProvider = Provider<UserModel?>((ref) {
  final authService = ref.watch(authServiceProvider);
  return authService.currentUser;
});

/// Auth state stream provider
///
/// Provides a stream of authentication state changes
/// Emits null when user signs out, UserModel when signed in
///
/// This provider automatically rebuilds widgets when auth state changes
///
/// Example:
/// ```dart
/// class AuthGate extends ConsumerWidget {
///   @override
///   Widget build(BuildContext context, WidgetRef ref) {
///     final authState = ref.watch(authStateProvider);
///
///     return authState.when(
///       data: (user) {
///         if (user != null) {
///           return HomeScreen();
///         } else {
///           return SignInScreen();
///         }
///       },
///       loading: () => CircularProgressIndicator(),
///       error: (error, stack) => ErrorScreen(error: error),
///     );
///   }
/// }
/// ```
final authStateProvider = StreamProvider<UserModel?>((ref) {
  final authService = ref.watch(authServiceProvider);
  return authService.authStateChanges;
});

/// User changes stream provider
///
/// Provides a stream that includes profile updates (not just sign-in/sign-out)
/// Use this when you need to react to profile changes like display name updates
///
/// Example:
/// ```dart
/// class ProfileCard extends ConsumerWidget {
///   @override
///   Widget build(BuildContext context, WidgetRef ref) {
///     final userAsync = ref.watch(userChangesProvider);
///
///     return userAsync.when(
///       data: (user) {
///         if (user == null) return SizedBox();
///         return ListTile(
///           leading: CircleAvatar(
///             backgroundImage: user.photoUrl != null
///                 ? NetworkImage(user.photoUrl!)
///                 : null,
///           ),
///           title: Text(user.displayName ?? 'No name'),
///           subtitle: Text(user.email ?? ''),
///         );
///       },
///       loading: () => CircularProgressIndicator(),
///       error: (error, stack) => Text('Error: $error'),
///     );
///   }
/// }
/// ```
final userChangesProvider = StreamProvider<UserModel?>((ref) {
  final authService = ref.watch(authServiceProvider);
  return authService.userChanges;
});

/// Is signed in provider
///
/// Simple boolean provider indicating if user is signed in
///
/// Example:
/// ```dart
/// class HomeScreen extends ConsumerWidget {
///   @override
///   Widget build(BuildContext context, WidgetRef ref) {
///     final isSignedIn = ref.watch(isSignedInProvider);
///
///     if (!isSignedIn) {
///       return SignInPrompt();
///     }
///
///     return DashboardContent();
///   }
/// }
/// ```
final isSignedInProvider = Provider<bool>((ref) {
  final authService = ref.watch(authServiceProvider);
  return authService.isSignedIn;
});

/// Is email verified provider
///
/// Indicates if the current user's email is verified
///
/// Example:
/// ```dart
/// class VerificationBanner extends ConsumerWidget {
///   @override
///   Widget build(BuildContext context, WidgetRef ref) {
///     final isVerified = ref.watch(isEmailVerifiedProvider);
///
///     if (isVerified) return SizedBox();
///
///     return MaterialBanner(
///       content: Text('Please verify your email'),
///       actions: [
///         TextButton(
///           onPressed: () async {
///             final authService = ref.read(authServiceProvider);
///             await authService.sendEmailVerification();
///           },
///           child: Text('Resend'),
///         ),
///       ],
///     );
///   }
/// }
/// ```
final isEmailVerifiedProvider = Provider<bool>((ref) {
  final authService = ref.watch(authServiceProvider);
  return authService.isEmailVerified;
});

// =============================================================================
// GETIT REGISTRATION
// =============================================================================

/// Register all authentication dependencies with GetIt
///
/// Call this function once during app initialization (typically in main.dart)
/// before calling runApp().
///
/// Example:
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
///     // Access services using GetIt
///     final authService = GetIt.I<AuthService>();
///
///     return MaterialApp(
///       home: StreamBuilder<UserModel?>(
///         stream: authService.authStateChanges,
///         builder: (context, snapshot) {
///           if (snapshot.connectionState == ConnectionState.waiting) {
///             return SplashScreen();
///           }
///
///           if (snapshot.hasData) {
///             return HomeScreen();
///           }
///
///           return SignInScreen();
///         },
///       ),
///     );
///   }
/// }
/// ```
void registerAuthDependencies({GetIt? getIt}) {
  final locator = getIt ?? GetIt.instance;

  // Register Firebase Auth instance as singleton
  locator.registerLazySingleton<firebase_auth.FirebaseAuth>(
    () => firebase_auth.FirebaseAuth.instance,
  );

  // Register Google Sign-In as singleton
  locator.registerLazySingleton<GoogleSignIn>(
    () => GoogleSignIn(
      scopes: ['email', 'profile'],
    ),
  );

  // Register TokenStore as singleton
  // Using HybridTokenStore for balance of security and performance
  locator.registerLazySingleton<TokenStore>(
    () => HybridTokenStore(),
  );

  // Register AuthRepository as singleton
  locator.registerLazySingleton<AuthRepository>(
    () => AuthRepository(
      firebaseAuth: locator<firebase_auth.FirebaseAuth>(),
      googleSignIn: locator<GoogleSignIn>(),
      tokenStore: locator<TokenStore>(),
    ),
  );

  // Register AuthService as singleton
  // This is the main service your app will use
  locator.registerLazySingleton<AuthService>(
    () => AuthService(
      repository: locator<AuthRepository>(),
    ),
  );
}

/// Unregister all authentication dependencies from GetIt
///
/// Useful for testing or when you need to reset the dependency graph
///
/// Example:
/// ```dart
/// void main() {
///   setUp(() {
///     registerAuthDependencies();
///   });
///
///   tearDown(() {
///     unregisterAuthDependencies();
///   });
///
///   test('sign in test', () async {
///     final authService = GetIt.I<AuthService>();
///     // ... test code
///   });
/// }
/// ```
void unregisterAuthDependencies({GetIt? getIt}) {
  final locator = getIt ?? GetIt.instance;

  if (locator.isRegistered<AuthService>()) {
    locator.unregister<AuthService>();
  }
  if (locator.isRegistered<AuthRepository>()) {
    locator.unregister<AuthRepository>();
  }
  if (locator.isRegistered<TokenStore>()) {
    locator.unregister<TokenStore>();
  }
  if (locator.isRegistered<GoogleSignIn>()) {
    locator.unregister<GoogleSignIn>();
  }
  if (locator.isRegistered<firebase_auth.FirebaseAuth>()) {
    locator.unregister<firebase_auth.FirebaseAuth>();
  }
}

// =============================================================================
// USAGE EXAMPLES
// =============================================================================

/// Example: Using Riverpod in your app
///
/// ```dart
/// void main() async {
///   WidgetsFlutterBinding.ensureInitialized();
///   await Firebase.initializeApp();
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
///
/// // In a widget that needs to perform auth operations:
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

/// Example: Using GetIt in your app
///
/// ```dart
/// void main() async {
///   WidgetsFlutterBinding.ensureInitialized();
///   await Firebase.initializeApp();
///
///   // Register dependencies
///   registerAuthDependencies();
///
///   runApp(MyApp());
/// }
///
/// class MyApp extends StatelessWidget {
///   @override
///   Widget build(BuildContext context) {
///     // Get the auth service
///     final authService = GetIt.I<AuthService>();
///
///     return MaterialApp(
///       home: StreamBuilder<UserModel?>(
///         stream: authService.authStateChanges,
///         builder: (context, snapshot) {
///           if (snapshot.connectionState == ConnectionState.waiting) {
///             return SplashScreen();
///           }
///
///           if (snapshot.hasData) {
///             return HomeScreen();
///           }
///
///           return SignInScreen();
///         },
///       ),
///     );
///   }
/// }
///
/// // In a widget that needs to perform auth operations:
/// class SignInButton extends StatelessWidget {
///   @override
///   Widget build(BuildContext context) {
///     return ElevatedButton(
///       onPressed: () async {
///         final authService = GetIt.I<AuthService>();
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
