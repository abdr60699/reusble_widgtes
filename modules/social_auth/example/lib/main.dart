import 'package:flutter/material.dart';
import '../../social_auth.dart';

void main() {
  // Initialize social auth
  SocialAuth.initialize(
    logger: ConsoleLogger(),
    enableGoogle: true,
    enableApple: true,
    enableFacebook: true,
  );

  runApp(const SocialAuthExampleApp());
}

class SocialAuthExampleApp extends StatelessWidget {
  const SocialAuthExampleApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Social Auth Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const LoginScreen(),
    );
  }
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final Map<SocialProvider, bool> _loadingStates = {};
  String? _errorMessage;

  Future<void> _handleSignIn(SocialProvider provider) async {
    setState(() {
      _loadingStates[provider] = true;
      _errorMessage = null;
    });

    try {
      AuthResult result;

      switch (provider) {
        case SocialProvider.google:
          result = await SocialAuth.instance.signInWithGoogle();
          break;
        case SocialProvider.apple:
          result = await SocialAuth.instance.signInWithApple();
          break;
        case SocialProvider.facebook:
          result = await SocialAuth.instance.signInWithFacebook();
          break;
      }

      // Navigate to home screen on success
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => HomeScreen(authResult: result),
          ),
        );
      }
    } on SocialAuthError catch (e) {
      setState(() {
        _errorMessage = _getErrorMessage(e);
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'An unexpected error occurred: ${e.toString()}';
      });
    } finally {
      if (mounted) {
        setState(() {
          _loadingStates[provider] = false;
        });
      }
    }
  }

  String _getErrorMessage(SocialAuthError error) {
    switch (error.code) {
      case SocialAuthErrorCode.userCancelled:
        return 'Sign-in was cancelled';
      case SocialAuthErrorCode.networkError:
        return 'Network error. Please check your connection.';
      case SocialAuthErrorCode.platformNotSupported:
        return '${error.provider.name} is not supported on this platform';
      case SocialAuthErrorCode.configurationError:
        return 'Configuration error: ${error.message}';
      default:
        return 'Error: ${error.message}';
    }
  }

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
              // App logo/title
              const Icon(
                Icons.lock_outline,
                size: 80,
                color: Colors.blue,
              ),
              const SizedBox(height: 24),
              const Text(
                'Social Auth Example',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              const Text(
                'Sign in with your social account',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 48),

              // Social sign-in buttons
              SocialSignInRow(
                loadingStates: _loadingStates,
                onProviderSelected: _handleSignIn,
              ),

              const SizedBox(height: 24),

              // Error message
              if (_errorMessage != null)
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.red.shade50,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.red.shade200),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.error_outline, color: Colors.red.shade700),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          _errorMessage!,
                          style: TextStyle(color: Colors.red.shade700),
                        ),
                      ),
                    ],
                  ),
                ),

              const SizedBox(height: 48),

              // Privacy notice
              Text(
                'By signing in, you agree to our Terms of Service and Privacy Policy',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

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
        title: const Text('Profile'),
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

            // User info
            _buildInfoCard(
              'Provider',
              _getProviderName(authResult.provider),
              Icons.login,
            ),
            _buildInfoCard(
              'Name',
              authResult.user.name ?? 'Not provided',
              Icons.person,
            ),
            _buildInfoCard(
              'Email',
              authResult.user.email ?? 'Not provided',
              Icons.email,
            ),
            _buildInfoCard(
              'User ID',
              authResult.user.id,
              Icons.fingerprint,
            ),
            _buildInfoCard(
              'Signed in at',
              _formatTimestamp(authResult.timestamp),
              Icons.access_time,
            ),

            const SizedBox(height: 24),

            // Token info (developer view)
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
                      if (authResult.idToken != null) ...[
                        const Text(
                          'ID Token:',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          _truncateToken(authResult.idToken!),
                          style: const TextStyle(
                            fontFamily: 'monospace',
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(height: 12),
                      ],
                      if (authResult.authorizationCode != null) ...[
                        const Text(
                          'Authorization Code:',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          _truncateToken(authResult.authorizationCode!),
                          style: const TextStyle(
                            fontFamily: 'monospace',
                            fontSize: 12,
                          ),
                        ),
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

  String _getProviderName(SocialProvider provider) {
    switch (provider) {
      case SocialProvider.google:
        return 'Google';
      case SocialProvider.apple:
        return 'Apple';
      case SocialProvider.facebook:
        return 'Facebook';
    }
  }

  String _formatTimestamp(DateTime timestamp) {
    return '${timestamp.day}/${timestamp.month}/${timestamp.year} '
        '${timestamp.hour.toString().padLeft(2, '0')}:'
        '${timestamp.minute.toString().padLeft(2, '0')}';
  }

  String _truncateToken(String token) {
    if (token.length <= 50) return token;
    return '${token.substring(0, 25)}...${token.substring(token.length - 25)}';
  }

  Future<void> _handleSignOut(BuildContext context) async {
    try {
      await SocialAuth.instance.signOut();

      if (context.mounted) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const LoginScreen()),
          (route) => false,
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Sign out failed: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}

/// Simple console logger for debugging
class ConsoleLogger implements SocialAuthLogger {
  const ConsoleLogger();

  @override
  void info(String message) {
    print('[INFO] $message');
  }

  @override
  void error(String message, [Object? error, StackTrace? stackTrace]) {
    print('[ERROR] $message');
    if (error != null) print('Error: $error');
    if (stackTrace != null) print('StackTrace: $stackTrace');
  }

  @override
  void debug(String message) {
    print('[DEBUG] $message');
  }

  @override
  void warning(String message) {
    print('[WARNING] $message');
  }
}
