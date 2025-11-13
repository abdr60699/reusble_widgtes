import 'package:flutter/material.dart';
import 'package:supabase_auth/supabase_auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize auth repository with configuration
  // In production, load from environment variables
  await AuthRepository.initialize(
    SupabaseAuthConfig(
      supabaseUrl: 'YOUR_SUPABASE_URL',
      supabaseAnonKey: 'YOUR_SUPABASE_ANON_KEY',
      enabledProviders: [
        SocialProvider.google,
        SocialProvider.apple,
        SocialProvider.facebook,
      ],
      useSecureStorageForSession: true,
      redirectUrl: 'com.example.app://auth-callback',
      passwordRequirements: PasswordRequirements.secure,
      requireEmailConfirmation: true,
      enableLogging: true,
    ),
  );

  runApp(const SupabaseAuthExampleApp());
}

class SupabaseAuthExampleApp extends StatelessWidget {
  const SupabaseAuthExampleApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Supabase Auth Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const AuthGate(),
    );
  }
}

/// Auth gate that shows appropriate screen based on auth state
class AuthGate extends StatelessWidget {
  const AuthGate({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<AuthResult?>(
      stream: AuthRepository.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasData && snapshot.data != null) {
          // User is signed in
          return HomeScreen(authResult: snapshot.data!);
        } else {
          // User is not signed in
          return const WelcomeScreen();
        }
      },
    );
  }
}

/// Welcome screen with navigation to sign in/sign up
class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Icon(
                Icons.lock_outline,
                size: 80,
                color: Colors.blue,
              ),
              const SizedBox(height: 24),
              const Text(
                'Supabase Auth',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              const Text(
                'Example App',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.grey,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 48),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ReusableSignInScreen(
                        onSignedIn: (result) {
                          Navigator.pop(context);
                        },
                        onSignUpTap: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const SignUpPage(),
                            ),
                          );
                        },
                        onForgotPassword: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  const ReusableForgotPasswordScreen(),
                            ),
                          );
                        },
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text('Sign In'),
              ),
              const SizedBox(height: 16),
              OutlinedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SignUpPage(),
                    ),
                  );
                },
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text('Sign Up'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Sign up page wrapper
class SignUpPage extends StatelessWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ReusableSignUpScreen(
      onSignedUp: (result) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Account created! Please check your email to verify.'),
            backgroundColor: Colors.green,
          ),
        );
      },
      onSignInTap: () {
        Navigator.pop(context);
      },
      onError: (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(error.message),
            backgroundColor: Colors.red,
          ),
        );
      },
    );
  }
}

/// Home screen (after authentication)
class HomeScreen extends StatelessWidget {
  final AuthResult authResult;

  const HomeScreen({
    Key? key,
    required this.authResult,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => _handleSignOut(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Profile picture
            Center(
              child: CircleAvatar(
                radius: 60,
                backgroundImage: authResult.user.avatarUrl != null
                    ? NetworkImage(authResult.user.avatarUrl!)
                    : null,
                child: authResult.user.avatarUrl == null
                    ? const Icon(Icons.person, size: 60)
                    : null,
              ),
            ),
            const SizedBox(height: 24),

            // User info cards
            _buildInfoCard(
              'Provider',
              authResult.provider,
              Icons.login,
            ),
            _buildInfoCard(
              'Email',
              authResult.user.email ?? 'Not provided',
              Icons.email,
            ),
            _buildInfoCard(
              'Name',
              authResult.user.name ?? 'Not provided',
              Icons.person,
            ),
            _buildInfoCard(
              'User ID',
              authResult.user.id,
              Icons.fingerprint,
            ),
            _buildInfoCard(
              'Email Verified',
              authResult.user.isEmailConfirmed ? 'Yes' : 'No',
              authResult.user.isEmailConfirmed ? Icons.verified : Icons.warning,
            ),

            const SizedBox(height: 24),

            // Developer info
            ExpansionTile(
              title: const Text('Developer Info'),
              leading: const Icon(Icons.code),
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (authResult.accessToken != null) ...[
                        const Text(
                          'Access Token:',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          _truncateToken(authResult.accessToken!),
                          style: const TextStyle(
                            fontFamily: 'monospace',
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(height: 12),
                      ],
                      if (authResult.expiresAt != null) ...[
                        const Text(
                          'Expires At:',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(authResult.expiresAt!.toString()),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(String label, String value, IconData icon) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Icon(icon, color: Colors.blue),
        title: Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.grey,
          ),
        ),
        subtitle: Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  String _truncateToken(String token) {
    if (token.length <= 50) return token;
    return '${token.substring(0, 25)}...${token.substring(token.length - 25)}';
  }

  Future<void> _handleSignOut(BuildContext context) async {
    try {
      await AuthRepository.instance.signOut();
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Sign out failed: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}
