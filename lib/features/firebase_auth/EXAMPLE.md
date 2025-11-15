# Firebase Authentication Module - Complete Example

This example demonstrates a complete integration of the Firebase Authentication module in a Flutter app.

## Complete main.dart Example (Riverpod)

```dart
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:reuablewidgets/features/firebase_auth/firebase_auth.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      title: 'Firebase Auth Example',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: AuthGate(),
    );
  }
}

/// Auth gate - shows SignInScreen or HomeScreen based on auth state
class AuthGate extends ConsumerWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);

    return authState.when(
      data: (user) {
        if (user != null) {
          return HomeScreen();
        } else {
          return SignInScreen(
            onSignInSuccess: () {
              // Auth state will automatically update
            },
          );
        }
      },
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (error, stack) => Scaffold(
        body: Center(
          child: Text('Error: $error'),
        ),
      ),
    );
  }
}

/// Home screen shown after authentication
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(userChangesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ProfileScreen()),
              );
            },
          ),
        ],
      ),
      body: userAsync.when(
        data: (user) {
          if (user == null) {
            return const Center(child: Text('Not signed in'));
          }

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Welcome message
                Text(
                  'Welcome, ${user.displayName ?? user.email ?? 'User'}!',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: 24),

                // User info card
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Account Information',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 16),
                        if (user.email != null)
                          ListTile(
                            leading: const Icon(Icons.email),
                            title: const Text('Email'),
                            subtitle: Text(user.email!),
                            trailing: user.emailVerified
                                ? const Icon(Icons.verified, color: Colors.green)
                                : const Icon(Icons.warning, color: Colors.orange),
                          ),
                        if (user.phoneNumber != null)
                          ListTile(
                            leading: const Icon(Icons.phone),
                            title: const Text('Phone'),
                            subtitle: Text(user.phoneNumber!),
                          ),
                        ListTile(
                          leading: const Icon(Icons.fingerprint),
                          title: const Text('User ID'),
                          subtitle: Text(user.uid),
                        ),
                        ListTile(
                          leading: const Icon(Icons.link),
                          title: const Text('Linked Accounts'),
                          subtitle: Text(user.providers.join(', ')),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Email verification banner
                if (user.email != null && !user.emailVerified)
                  Card(
                    color: Colors.orange.shade50,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          const Icon(Icons.warning, color: Colors.orange),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Email Not Verified',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                const Text(
                                  'Please verify your email address',
                                ),
                              ],
                            ),
                          ),
                          TextButton(
                            onPressed: () async {
                              final authService = ref.read(authServiceProvider);
                              try {
                                await authService.sendEmailVerification();
                                if (context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Verification email sent'),
                                    ),
                                  );
                                }
                              } on AuthError catch (e) {
                                if (context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text(e.message)),
                                  );
                                }
                              }
                            },
                            child: const Text('Verify'),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
      ),
    );
  }
}
```

## Complete main.dart Example (GetIt)

```dart
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import 'package:reuablewidgets/features/firebase_auth/firebase_auth.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Register auth dependencies
  registerAuthDependencies();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Firebase Auth Example',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const AuthGate(),
    );
  }
}

/// Auth gate - shows SignInScreen or HomeScreen based on auth state
class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = GetIt.I<AuthService>();

    return StreamBuilder<UserModel?>(
      stream: authService.authStateChanges,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasError) {
          return Scaffold(
            body: Center(
              child: Text('Error: ${snapshot.error}'),
            ),
          );
        }

        if (snapshot.hasData) {
          return const HomeScreen();
        } else {
          return SignInScreen(
            onSignInSuccess: () {
              // Auth state will automatically update
            },
          );
        }
      },
    );
  }
}

/// Home screen shown after authentication
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = GetIt.I<AuthService>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ProfileScreen()),
              );
            },
          ),
        ],
      ),
      body: StreamBuilder<UserModel?>(
        stream: authService.userChanges,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final user = snapshot.data;
          if (user == null) {
            return const Center(child: Text('Not signed in'));
          }

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Welcome message
                Text(
                  'Welcome, ${user.displayName ?? user.email ?? 'User'}!',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: 24),

                // User info card
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Account Information',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 16),
                        if (user.email != null)
                          ListTile(
                            leading: const Icon(Icons.email),
                            title: const Text('Email'),
                            subtitle: Text(user.email!),
                            trailing: user.emailVerified
                                ? const Icon(Icons.verified, color: Colors.green)
                                : const Icon(Icons.warning, color: Colors.orange),
                          ),
                        if (user.phoneNumber != null)
                          ListTile(
                            leading: const Icon(Icons.phone),
                            title: const Text('Phone'),
                            subtitle: Text(user.phoneNumber!),
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
```

## Usage Examples

### Custom Sign-In Form

```dart
class CustomSignInForm extends ConsumerStatefulWidget {
  const CustomSignInForm({super.key});

  @override
  ConsumerState<CustomSignInForm> createState() => _CustomSignInFormState();
}

class _CustomSignInFormState extends ConsumerState<CustomSignInForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _signIn() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final authService = ref.read(authServiceProvider);
      await authService.signInWithEmail(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );

      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const HomeScreen()),
        );
      }
    } on AuthError catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.message)),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            controller: _emailController,
            decoration: const InputDecoration(labelText: 'Email'),
            validator: AuthValidators.validateEmail,
          ),
          TextFormField(
            controller: _passwordController,
            decoration: const InputDecoration(labelText: 'Password'),
            obscureText: true,
            validator: AuthValidators.validatePassword,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _isLoading ? null : _signIn,
            child: _isLoading
                ? const CircularProgressIndicator()
                : const Text('Sign In'),
          ),
        ],
      ),
    );
  }
}
```

### Social Sign-In Buttons

```dart
class SocialSignInButtons extends ConsumerWidget {
  const SocialSignInButtons({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        ElevatedButton.icon(
          onPressed: () async {
            try {
              final authService = ref.read(authServiceProvider);
              await authService.signInWithGoogle();
            } on AuthError catch (e) {
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(e.message)),
                );
              }
            }
          },
          icon: const Icon(Icons.g_mobiledata),
          label: const Text('Sign in with Google'),
        ),
        const SizedBox(height: 12),
        if (Theme.of(context).platform == TargetPlatform.iOS)
          ElevatedButton.icon(
            onPressed: () async {
              try {
                final authService = ref.read(authServiceProvider);
                await authService.signInWithApple();
              } on AuthError catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(e.message)),
                  );
                }
              }
            },
            icon: const Icon(Icons.apple),
            label: const Text('Sign in with Apple'),
          ),
      ],
    );
  }
}
```

### Protected Route Example

```dart
class ProtectedRoute extends ConsumerWidget {
  final Widget child;

  const ProtectedRoute({super.key, required this.child});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);

    return authState.when(
      data: (user) {
        if (user != null) {
          return child;
        } else {
          // Redirect to sign-in
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const SignInScreen()),
            );
          });
          return const SizedBox();
        }
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(child: Text('Error: $error')),
    );
  }
}

// Usage:
class SecretPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ProtectedRoute(
      child: Scaffold(
        appBar: AppBar(title: Text('Secret Page')),
        body: Center(child: Text('Protected content')),
      ),
    );
  }
}
```

## Testing Example

```dart
void main() {
  testWidgets('Sign in form validates input', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          home: Scaffold(
            body: CustomSignInForm(),
          ),
        ),
      ),
    );

    // Find email field
    final emailField = find.byType(TextFormField).first;
    await tester.enterText(emailField, 'invalid-email');

    // Find sign in button and tap
    final signInButton = find.text('Sign In');
    await tester.tap(signInButton);
    await tester.pump();

    // Should show validation error
    expect(find.text('Please enter a valid email address'), findsOneWidget);
  });
}
```

## Tips

1. **Always handle AuthError exceptions** - All auth methods can throw AuthError
2. **Check auth state on app start** - Use authStateProvider or StreamBuilder
3. **Reauthenticate before sensitive operations** - Required for password change, account deletion
4. **Verify emails** - Send verification emails and check status
5. **Test on real devices** - Some features (like SMS) don't work on simulators
6. **Handle cancellations gracefully** - User can cancel social sign-ins
7. **Use secure storage for tokens** - Already handled by the module
8. **Monitor auth state changes** - React to sign-in/sign-out events

## Common Patterns

### Sign Out Confirmation

```dart
Future<void> _confirmSignOut(BuildContext context, WidgetRef ref) async {
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Sign Out'),
      content: const Text('Are you sure you want to sign out?'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context, true),
          child: const Text('Sign Out'),
        ),
      ],
    ),
  );

  if (confirmed == true) {
    final authService = ref.read(authServiceProvider);
    await authService.signOut();
  }
}
```

### Auto-Refresh on Email Verification

```dart
class EmailVerificationChecker extends ConsumerStatefulWidget {
  @override
  ConsumerState<EmailVerificationChecker> createState() =>
      _EmailVerificationCheckerState();
}

class _EmailVerificationCheckerState
    extends ConsumerState<EmailVerificationChecker> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startPeriodicCheck();
  }

  void _startPeriodicCheck() {
    _timer = Timer.periodic(const Duration(seconds: 5), (_) async {
      final authService = ref.read(authServiceProvider);
      final isVerified = await authService.checkEmailVerified();

      if (isVerified) {
        _timer?.cancel();
        // Email verified, update UI
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // ... UI
  }
}
```
