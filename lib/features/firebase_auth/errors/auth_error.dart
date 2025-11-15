import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;

/// Normalized authentication error
///
/// Maps Firebase auth errors to app-friendly error codes and messages
class AuthError implements Exception {
  /// Error code (normalized)
  final String code;

  /// User-friendly error message
  final String message;

  /// Whether the error is recoverable (user can retry)
  final bool isRecoverable;

  /// Original Firebase error code (if applicable)
  final String? firebaseCode;

  const AuthError({
    required this.code,
    required this.message,
    this.isRecoverable = true,
    this.firebaseCode,
  });

  /// Create from Firebase AuthException
  factory AuthError.fromFirebase(firebase_auth.FirebaseAuthException e) {
    return _mapFirebaseError(e);
  }

  /// Create generic error
  factory AuthError.unknown([String? message]) {
    return AuthError(
      code: 'unknown',
      message: message ?? 'An unknown error occurred',
      isRecoverable: true,
    );
  }

  /// Network error
  factory AuthError.network() {
    return const AuthError(
      code: 'network-error',
      message: 'Network error. Please check your internet connection.',
      isRecoverable: true,
    );
  }

  /// User cancelled operation
  factory AuthError.cancelled() {
    return const AuthError(
      code: 'cancelled',
      message: 'Operation cancelled by user',
      isRecoverable: false,
    );
  }

  @override
  String toString() => 'AuthError: $code - $message';
}

/// Map Firebase error to AuthError
AuthError _mapFirebaseError(firebase_auth.FirebaseAuthException e) {
  switch (e.code) {
    // Email/Password errors
    case 'email-already-in-use':
      return const AuthError(
        code: 'email-in-use',
        message: 'This email is already registered. Please sign in instead.',
        isRecoverable: false,
        firebaseCode: 'email-already-in-use',
      );

    case 'invalid-email':
      return const AuthError(
        code: 'invalid-email',
        message: 'The email address is not valid.',
        isRecoverable: true,
        firebaseCode: 'invalid-email',
      );

    case 'user-not-found':
      return const AuthError(
        code: 'user-not-found',
        message: 'No account found with this email. Please sign up.',
        isRecoverable: false,
        firebaseCode: 'user-not-found',
      );

    case 'wrong-password':
      return const AuthError(
        code: 'wrong-password',
        message: 'Incorrect password. Please try again.',
        isRecoverable: true,
        firebaseCode: 'wrong-password',
      );

    case 'weak-password':
      return const AuthError(
        code: 'weak-password',
        message: 'Password is too weak. Use at least 6 characters.',
        isRecoverable: true,
        firebaseCode: 'weak-password',
      );

    case 'operation-not-allowed':
      return const AuthError(
        code: 'not-enabled',
        message: 'This sign-in method is not enabled. Please contact support.',
        isRecoverable: false,
        firebaseCode: 'operation-not-allowed',
      );

    // Reauthentication errors
    case 'requires-recent-login':
      return const AuthError(
        code: 'requires-reauth',
        message:
            'This operation requires recent authentication. Please sign in again.',
        isRecoverable: true,
        firebaseCode: 'requires-recent-login',
      );

    // Account linking errors
    case 'credential-already-in-use':
      return const AuthError(
        code: 'credential-in-use',
        message:
            'This account is already linked with another user. Please sign in with that account.',
        isRecoverable: false,
        firebaseCode: 'credential-already-in-use',
      );

    case 'provider-already-linked':
      return const AuthError(
        code: 'provider-linked',
        message: 'This provider is already linked to your account.',
        isRecoverable: false,
        firebaseCode: 'provider-already-linked',
      );

    case 'email-already-in-use':
      return const AuthError(
        code: 'email-in-use',
        message:
            'This email is already used by another account. Sign in to link accounts.',
        isRecoverable: true,
        firebaseCode: 'email-already-in-use',
      );

    // Phone auth errors
    case 'invalid-verification-code':
      return const AuthError(
        code: 'invalid-code',
        message: 'Invalid verification code. Please try again.',
        isRecoverable: true,
        firebaseCode: 'invalid-verification-code',
      );

    case 'invalid-verification-id':
      return const AuthError(
        code: 'invalid-verification-id',
        message: 'Verification expired. Please request a new code.',
        isRecoverable: true,
        firebaseCode: 'invalid-verification-id',
      );

    case 'session-expired':
      return const AuthError(
        code: 'session-expired',
        message: 'Verification session expired. Please try again.',
        isRecoverable: true,
        firebaseCode: 'session-expired',
      );

    case 'quota-exceeded':
      return const AuthError(
        code: 'quota-exceeded',
        message: 'Too many requests. Please try again later.',
        isRecoverable: true,
        firebaseCode: 'quota-exceeded',
      );

    // Network errors
    case 'network-request-failed':
      return const AuthError(
        code: 'network-error',
        message: 'Network error. Please check your internet connection.',
        isRecoverable: true,
        firebaseCode: 'network-request-failed',
      );

    case 'too-many-requests':
      return const AuthError(
        code: 'too-many-requests',
        message:
            'Too many attempts. Please wait a few minutes and try again.',
        isRecoverable: true,
        firebaseCode: 'too-many-requests',
      );

    // Account management errors
    case 'user-disabled':
      return const AuthError(
        code: 'user-disabled',
        message: 'This account has been disabled. Please contact support.',
        isRecoverable: false,
        firebaseCode: 'user-disabled',
      );

    case 'account-exists-with-different-credential':
      return const AuthError(
        code: 'account-exists',
        message:
            'An account already exists with this email but different sign-in method.',
        isRecoverable: true,
        firebaseCode: 'account-exists-with-different-credential',
      );

    // Default
    default:
      return AuthError(
        code: 'unknown',
        message: e.message ?? 'An error occurred during authentication',
        isRecoverable: true,
        firebaseCode: e.code,
      );
  }
}

/// Error codes for reference
class AuthErrorCodes {
  static const emailInUse = 'email-in-use';
  static const invalidEmail = 'invalid-email';
  static const userNotFound = 'user-not-found';
  static const wrongPassword = 'wrong-password';
  static const weakPassword = 'weak-password';
  static const requiresReauth = 'requires-reauth';
  static const credentialInUse = 'credential-in-use';
  static const providerLinked = 'provider-linked';
  static const invalidCode = 'invalid-code';
  static const networkError = 'network-error';
  static const tooManyRequests = 'too-many-requests';
  static const userDisabled = 'user-disabled';
  static const cancelled = 'cancelled';
  static const unknown = 'unknown';
}
