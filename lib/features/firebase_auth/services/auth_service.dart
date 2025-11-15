import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import '../models/user_model.dart';
import '../repository/auth_repository.dart';
import '../errors/auth_error.dart';

/// High-level authentication service
///
/// Provides a clean API for all authentication operations.
/// This is the main entry point that your app should use.
///
/// Example:
/// ```dart
/// final authService = AuthService(repository: authRepository);
///
/// // Sign up
/// final user = await authService.signUpWithEmail(
///   email: 'user@example.com',
///   password: 'password123',
/// );
///
/// // Listen to auth state
/// authService.authStateChanges.listen((user) {
///   if (user != null) {
///     // User is signed in
///   } else {
///     // User is signed out
///   }
/// });
/// ```
class AuthService {
  final AuthRepository _repository;

  /// Lock for preventing concurrent reauthentication
  bool _isReauthenticating = false;

  AuthService({required AuthRepository repository})
      : _repository = repository;

  /// Stream of authentication state changes
  ///
  /// Emits `null` when user is signed out, `UserModel` when signed in
  Stream<UserModel?> get authStateChanges => _repository.authStateChanges;

  /// Stream of user changes (includes profile updates)
  Stream<UserModel?> get userChanges => _repository.userChanges;

  /// Get current user
  ///
  /// Returns `null` if no user is signed in
  UserModel? get currentUser => _repository.getCurrentUser();

  /// Check if user is signed in
  bool get isSignedIn => currentUser != null;

  /// Check if current user's email is verified
  bool get isEmailVerified => currentUser?.emailVerified ?? false;

  // ==================== Sign Up ====================

  /// Sign up with email and password
  ///
  /// Returns [UserModel] on success
  /// Throws [AuthError] on failure
  ///
  /// Example:
  /// ```dart
  /// try {
  ///   final user = await authService.signUpWithEmail(
  ///     email: 'user@example.com',
  ///     password: 'securePassword123',
  ///   );
  ///   print('Signed up: ${user.email}');
  /// } on AuthError catch (e) {
  ///   print('Error: ${e.message}');
  /// }
  /// ```
  Future<UserModel> signUpWithEmail({
    required String email,
    required String password,
    String? displayName,
  }) async {
    final user = await _repository.signUpWithEmail(
      email: email,
      password: password,
    );

    // Update display name if provided
    if (displayName != null && displayName.isNotEmpty) {
      await _repository.updateProfile(displayName: displayName);
      await _repository.reloadUser();
      return _repository.getCurrentUser()!;
    }

    return user;
  }

  // ==================== Sign In ====================

  /// Sign in with email and password
  ///
  /// Returns [UserModel] on success
  /// Throws [AuthError] on failure
  Future<UserModel> signInWithEmail({
    required String email,
    required String password,
  }) async {
    return await _repository.signInWithEmail(
      email: email,
      password: password,
    );
  }

  /// Sign in with Google
  ///
  /// Returns [UserModel] on success
  /// Throws [AuthError] on failure (including [AuthErrorCodes.cancelled] if user cancels)
  Future<UserModel> signInWithGoogle() async {
    return await _repository.signInWithGoogle();
  }

  /// Sign in with Apple
  ///
  /// Returns [UserModel] on success
  /// Throws [AuthError] on failure (including [AuthErrorCodes.cancelled] if user cancels)
  Future<UserModel> signInWithApple() async {
    return await _repository.signInWithApple();
  }

  /// Sign in with Facebook
  ///
  /// Returns [UserModel] on success
  /// Throws [AuthError] on failure (including [AuthErrorCodes.cancelled] if user cancels)
  Future<UserModel> signInWithFacebook() async {
    return await _repository.signInWithFacebook();
  }

  /// Sign in anonymously
  ///
  /// Returns [UserModel] on success
  /// Throws [AuthError] on failure
  ///
  /// Use this for allowing users to use the app without creating an account.
  /// You can later upgrade the anonymous account to a permanent account by linking credentials.
  Future<UserModel> signInAnonymously() async {
    return await _repository.signInAnonymously();
  }

  // ==================== Phone Authentication ====================

  /// Verify phone number and send OTP
  ///
  /// Initiates phone number verification. SMS with OTP will be sent to the phone number.
  ///
  /// [phoneNumber] - Phone number in E.164 format (e.g., +15551234567)
  /// [codeSent] - Callback when SMS is sent with verification ID
  /// [verificationCompleted] - Callback for auto-verification (Android only)
  /// [verificationFailed] - Callback when verification fails
  /// [timeout] - Timeout for auto-verification
  ///
  /// Example:
  /// ```dart
  /// await authService.verifyPhoneNumber(
  ///   phoneNumber: '+15551234567',
  ///   codeSent: (verificationId, resendToken) {
  ///     // Show OTP input screen
  ///   },
  ///   verificationCompleted: (credential) {
  ///     // Auto-verification succeeded (Android)
  ///   },
  ///   verificationFailed: (error) {
  ///     // Handle error
  ///   },
  /// );
  /// ```
  Future<void> verifyPhoneNumber({
    required String phoneNumber,
    required Function(String verificationId, int? resendToken) codeSent,
    required Function(firebase_auth.PhoneAuthCredential credential)
        verificationCompleted,
    required Function(AuthError error) verificationFailed,
    Duration timeout = const Duration(seconds: 60),
  }) async {
    await _repository.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      codeSent: codeSent,
      verificationCompleted: verificationCompleted,
      verificationFailed: verificationFailed,
      timeout: timeout,
    );
  }

  /// Verify OTP code and sign in
  ///
  /// [verificationId] - ID from [codeSent] callback
  /// [smsCode] - OTP code entered by user
  ///
  /// Returns [UserModel] on success
  /// Throws [AuthError] on failure
  ///
  /// Example:
  /// ```dart
  /// try {
  ///   final user = await authService.verifyPhoneOtp(
  ///     verificationId: verificationId,
  ///     smsCode: '123456',
  ///   );
  /// } on AuthError catch (e) {
  ///   if (e.code == AuthErrorCodes.invalidCode) {
  ///     // Show error: Invalid code
  ///   }
  /// }
  /// ```
  Future<UserModel> verifyPhoneOtp({
    required String verificationId,
    required String smsCode,
  }) async {
    return await _repository.verifyPhoneOtp(
      verificationId: verificationId,
      smsCode: smsCode,
    );
  }

  /// Sign in with phone credential (from auto-verification)
  Future<UserModel> signInWithPhoneCredential(
    firebase_auth.PhoneAuthCredential credential,
  ) async {
    return await _repository.signInWithPhoneCredential(credential);
  }

  // ==================== Account Linking ====================

  /// Link email/password to current user account
  ///
  /// Allows adding email/password authentication to an existing account
  /// (e.g., upgrading from anonymous or adding to a Google-only account)
  ///
  /// Returns updated [UserModel] on success
  /// Throws [AuthError] on failure
  ///
  /// Example:
  /// ```dart
  /// // User signed in anonymously, now wants to add email/password
  /// final updatedUser = await authService.linkWithEmailPassword(
  ///   email: 'user@example.com',
  ///   password: 'password123',
  /// );
  /// ```
  Future<UserModel> linkWithEmailPassword({
    required String email,
    required String password,
  }) async {
    return await _repository.linkWithEmailPassword(
      email: email,
      password: password,
    );
  }

  /// Link Google account to current user
  ///
  /// Returns updated [UserModel] on success
  /// Throws [AuthError] on failure
  Future<UserModel> linkWithGoogle() async {
    return await _repository.linkWithGoogle();
  }

  /// Link Apple account to current user
  ///
  /// Returns updated [UserModel] on success
  /// Throws [AuthError] on failure
  Future<UserModel> linkWithApple() async {
    return await _repository.linkWithApple();
  }

  /// Link Facebook account to current user
  ///
  /// Returns updated [UserModel] on success
  /// Throws [AuthError] on failure
  Future<UserModel> linkWithFacebook() async {
    return await _repository.linkWithFacebook();
  }

  /// Unlink provider from current user
  ///
  /// [providerId] - Provider to unlink (e.g., 'google.com', 'facebook.com', 'password')
  ///
  /// Returns updated [UserModel] on success
  /// Throws [AuthError] on failure
  ///
  /// Example:
  /// ```dart
  /// // Remove Google sign-in
  /// await authService.unlinkProvider('google.com');
  /// ```
  Future<UserModel> unlinkProvider(String providerId) async {
    return await _repository.unlinkProvider(providerId);
  }

  // ==================== Email Verification ====================

  /// Send email verification to current user
  ///
  /// Throws [AuthError] on failure
  ///
  /// Example:
  /// ```dart
  /// await authService.sendEmailVerification();
  /// // Show message: "Verification email sent. Please check your inbox."
  /// ```
  Future<void> sendEmailVerification() async {
    await _repository.sendEmailVerification();
  }

  /// Reload user to check if email is verified
  ///
  /// Call this after user clicks verification link in email
  ///
  /// Returns true if email is now verified, false otherwise
  Future<bool> checkEmailVerified() async {
    await _repository.reloadUser();
    return currentUser?.emailVerified ?? false;
  }

  // ==================== Password Reset ====================

  /// Send password reset email
  ///
  /// [email] - Email address to send reset link to
  ///
  /// Throws [AuthError] on failure
  ///
  /// Example:
  /// ```dart
  /// await authService.sendPasswordReset('user@example.com');
  /// // Show message: "Password reset email sent"
  /// ```
  Future<void> sendPasswordReset(String email) async {
    await _repository.sendPasswordReset(email);
  }

  /// Change password (requires recent authentication)
  ///
  /// Throws [AuthError] with [AuthErrorCodes.requiresReauth] if user needs to reauthenticate
  ///
  /// Example:
  /// ```dart
  /// try {
  ///   await authService.changePassword('newPassword123');
  /// } on AuthError catch (e) {
  ///   if (e.code == AuthErrorCodes.requiresReauth) {
  ///     // Prompt user to sign in again
  ///   }
  /// }
  /// ```
  Future<void> changePassword(String newPassword) async {
    await _repository.changePassword(newPassword);
  }

  // ==================== Profile Management ====================

  /// Update user profile
  ///
  /// [displayName] - New display name (optional)
  /// [photoUrl] - New photo URL (optional)
  ///
  /// Throws [AuthError] on failure
  Future<void> updateProfile({
    String? displayName,
    String? photoUrl,
  }) async {
    await _repository.updateProfile(
      displayName: displayName,
      photoUrl: photoUrl,
    );

    // Reload user to get updated data
    await _repository.reloadUser();
  }

  // ==================== Reauthentication ====================

  /// Reauthenticate with email and password
  ///
  /// Required before sensitive operations like changing password or deleting account
  ///
  /// Throws [AuthError] on failure
  ///
  /// Example:
  /// ```dart
  /// // Before deleting account
  /// await authService.reauthenticateWithEmail(
  ///   email: user.email!,
  ///   password: enteredPassword,
  /// );
  /// await authService.deleteAccount();
  /// ```
  Future<void> reauthenticateWithEmail({
    required String email,
    required String password,
  }) async {
    if (_isReauthenticating) {
      throw AuthError.unknown('Reauthentication already in progress');
    }

    try {
      _isReauthenticating = true;
      await _repository.reauthenticateWithEmail(
        email: email,
        password: password,
      );
    } finally {
      _isReauthenticating = false;
    }
  }

  // ==================== Account Deletion ====================

  /// Delete user account (requires recent authentication)
  ///
  /// This is permanent and cannot be undone.
  ///
  /// Throws [AuthError] with [AuthErrorCodes.requiresReauth] if user needs to reauthenticate
  ///
  /// Example:
  /// ```dart
  /// try {
  ///   await authService.deleteAccount();
  /// } on AuthError catch (e) {
  ///   if (e.code == AuthErrorCodes.requiresReauth) {
  ///     // Prompt for reauthentication
  ///   }
  /// }
  /// ```
  Future<void> deleteAccount() async {
    await _repository.deleteAccount();
  }

  // ==================== Sign Out ====================

  /// Sign out current user
  ///
  /// Signs out from all providers and clears stored tokens
  ///
  /// Throws [AuthError] on failure
  Future<void> signOut() async {
    await _repository.signOut();
  }

  // ==================== Token Management ====================

  /// Get current user's ID token
  ///
  /// [forceRefresh] - Force token refresh (default: false)
  ///
  /// Returns token string or null if no user is signed in
  ///
  /// Use this token for authenticating API requests to your backend
  ///
  /// Example:
  /// ```dart
  /// final token = await authService.getIdToken();
  /// // Send token to your backend for verification
  /// final response = await http.get(
  ///   '/api/protected',
  ///   headers: {'Authorization': 'Bearer $token'},
  /// );
  /// ```
  Future<String?> getIdToken({bool forceRefresh = false}) async {
    return await _repository.getIdToken(forceRefresh: forceRefresh);
  }

  /// Refresh ID token
  ///
  /// Returns new token string
  Future<String?> refreshToken() async {
    return await _repository.getIdToken(forceRefresh: true);
  }

  // ==================== Utility Methods ====================

  /// Reload current user data
  ///
  /// Call this to get the latest user data from Firebase
  Future<void> reloadUser() async {
    await _repository.reloadUser();
  }

  /// Check if user has specific provider linked
  bool hasProvider(String providerId) {
    return currentUser?.hasProvider(providerId) ?? false;
  }

  /// Check if user is anonymous
  bool get isAnonymous => currentUser?.isAnonymous ?? false;
}
