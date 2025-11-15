import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../errors/auth_error.dart';
import '../models/user_model.dart';
import '../providers/auth_providers.dart';

/// Profile Screen
///
/// Displays user profile information and allows:
/// - View linked accounts (email, Google, Apple, Facebook, phone)
/// - Link/unlink authentication providers
/// - Update display name and photo
/// - Send email verification
/// - Change password
/// - Sign out
/// - Delete account
///
/// Example usage:
/// ```dart
/// Navigator.push(
///   context,
///   MaterialPageRoute(builder: (_) => ProfileScreen()),
/// );
/// ```
class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  bool _isLoading = false;

  Future<void> _sendEmailVerification() async {
    setState(() => _isLoading = true);

    try {
      final authService = ref.read(authServiceProvider);
      await authService.sendEmailVerification();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Verification email sent! Please check your inbox.'),
            backgroundColor: Colors.green,
          ),
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

  Future<void> _linkWithGoogle() async {
    setState(() => _isLoading = true);

    try {
      final authService = ref.read(authServiceProvider);
      await authService.linkWithGoogle();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Google account linked successfully!'),
            backgroundColor: Colors.green,
          ),
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

  Future<void> _unlinkProvider(String providerId, String providerName) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Unlink Account'),
        content: Text(
          'Are you sure you want to unlink your $providerName account?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Unlink'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    setState(() => _isLoading = true);

    try {
      final authService = ref.read(authServiceProvider);
      await authService.unlinkProvider(providerId);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('$providerName account unlinked'),
            backgroundColor: Colors.green,
          ),
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

  Future<void> _signOut() async {
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

    if (confirmed != true) return;

    setState(() => _isLoading = true);

    try {
      final authService = ref.read(authServiceProvider);
      await authService.signOut();

      if (mounted) {
        Navigator.of(context).popUntil((route) => route.isFirst);
      }
    } on AuthError catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.message)),
        );
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _deleteAccount() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Account'),
        content: const Text(
          'Are you sure you want to delete your account? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    setState(() => _isLoading = true);

    try {
      final authService = ref.read(authServiceProvider);
      await authService.deleteAccount();

      if (mounted) {
        Navigator.of(context).popUntil((route) => route.isFirst);
      }
    } on AuthError catch (e) {
      if (mounted) {
        if (e.code == AuthErrorCodes.requiresReauth) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'Please sign in again before deleting your account',
              ),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(e.message)),
          );
        }
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final userAsync = ref.watch(userChangesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        elevation: 0,
      ),
      body: userAsync.when(
        data: (user) {
          if (user == null) {
            return const Center(
              child: Text('Not signed in'),
            );
          }

          return _buildProfileContent(context, user);
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Text('Error: $error'),
        ),
      ),
    );
  }

  Widget _buildProfileContent(BuildContext context, UserModel user) {
    final theme = Theme.of(context);

    return SingleChildScrollView(
      child: Column(
        children: [
          // Profile header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            color: theme.primaryColor.withOpacity(0.1),
            child: Column(
              children: [
                // Profile photo
                CircleAvatar(
                  radius: 50,
                  backgroundImage: user.photoUrl != null
                      ? NetworkImage(user.photoUrl!)
                      : null,
                  child: user.photoUrl == null
                      ? const Icon(Icons.person, size: 50)
                      : null,
                ),
                const SizedBox(height: 16),

                // Display name
                Text(
                  user.displayName ?? 'No name',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),

                // Email
                if (user.email != null)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        user.email!,
                        style: theme.textTheme.bodyMedium,
                      ),
                      const SizedBox(width: 8),
                      if (!user.emailVerified)
                        Icon(
                          Icons.warning_amber,
                          size: 16,
                          color: Colors.orange,
                        ),
                    ],
                  ),

                // Phone
                if (user.phoneNumber != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    user.phoneNumber!,
                    style: theme.textTheme.bodyMedium,
                  ),
                ],

                // Email verification banner
                if (user.email != null && !user.emailVerified) ...[
                  const SizedBox(height: 16),
                  Card(
                    color: Colors.orange.shade50,
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.warning_amber,
                            color: Colors.orange,
                          ),
                          const SizedBox(width: 12),
                          const Expanded(
                            child: Text('Email not verified'),
                          ),
                          TextButton(
                            onPressed: _isLoading ? null : _sendEmailVerification,
                            child: const Text('Verify'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),

          // Linked accounts section
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Linked Accounts',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),

                // Email/Password
                _buildProviderTile(
                  context,
                  icon: Icons.email,
                  title: 'Email',
                  subtitle: user.email ?? 'Not linked',
                  isLinked: user.hasPasswordProvider,
                  providerId: 'password',
                  providerName: 'Email',
                  user: user,
                ),

                // Google
                _buildProviderTile(
                  context,
                  icon: Icons.g_mobiledata,
                  title: 'Google',
                  subtitle: user.hasGoogleProvider ? 'Linked' : 'Not linked',
                  isLinked: user.hasGoogleProvider,
                  providerId: 'google.com',
                  providerName: 'Google',
                  user: user,
                ),

                // Apple
                _buildProviderTile(
                  context,
                  icon: Icons.apple,
                  title: 'Apple',
                  subtitle: user.hasAppleProvider ? 'Linked' : 'Not linked',
                  isLinked: user.hasAppleProvider,
                  providerId: 'apple.com',
                  providerName: 'Apple',
                  user: user,
                ),

                // Facebook
                _buildProviderTile(
                  context,
                  icon: Icons.facebook,
                  title: 'Facebook',
                  subtitle: user.hasFacebookProvider ? 'Linked' : 'Not linked',
                  isLinked: user.hasFacebookProvider,
                  providerId: 'facebook.com',
                  providerName: 'Facebook',
                  user: user,
                ),

                // Phone
                _buildProviderTile(
                  context,
                  icon: Icons.phone,
                  title: 'Phone',
                  subtitle: user.phoneNumber ?? 'Not linked',
                  isLinked: user.hasPhoneProvider,
                  providerId: 'phone',
                  providerName: 'Phone',
                  user: user,
                ),
              ],
            ),
          ),

          // Actions section
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Sign out button
                OutlinedButton.icon(
                  onPressed: _isLoading ? null : _signOut,
                  icon: const Icon(Icons.logout),
                  label: const Text('Sign Out'),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                ),
                const SizedBox(height: 12),

                // Delete account button
                OutlinedButton.icon(
                  onPressed: _isLoading ? null : _deleteAccount,
                  icon: const Icon(Icons.delete_forever),
                  label: const Text('Delete Account'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.red,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProviderTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required bool isLinked,
    required String providerId,
    required String providerName,
    required UserModel user,
  }) {
    return Card(
      child: ListTile(
        leading: Icon(icon),
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: isLinked
            ? (user.providers.length > 1
                ? IconButton(
                    icon: const Icon(Icons.link_off),
                    onPressed: _isLoading
                        ? null
                        : () => _unlinkProvider(providerId, providerName),
                  )
                : Icon(
                    Icons.check_circle,
                    color: Colors.green.shade700,
                  ))
            : IconButton(
                icon: const Icon(Icons.add_link),
                onPressed: _isLoading
                    ? null
                    : () {
                        // Only Google linking is implemented in this example
                        if (providerId == 'google.com') {
                          _linkWithGoogle();
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Linking $providerName is not implemented in this example',
                              ),
                            ),
                          );
                        }
                      },
              ),
      ),
    );
  }
}
