import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import '../models/user_model.dart';
import '../errors/auth_error.dart';
import '../storage/token_store.dart';

/// Repository for Firebase Authentication operations
///
/// Handles all Firebase SDK interactions and maps responses to domain models
class AuthRepository {
  final firebase_auth.FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;
  final TokenStore _tokenStore;

  /// Current verification ID for phone auth
  String? _verificationId;

  /// Resend token for phone auth
  int? _resendToken;

  AuthRepository({
    firebase_auth.FirebaseAuth? firebaseAuth,
    GoogleSignIn? googleSignIn,
    required TokenStore tokenStore,
  })  : _firebaseAuth = firebaseAuth ?? firebase_auth.FirebaseAuth.instance,
        _googleSignIn = googleSignIn ?? GoogleSignIn(),
        _tokenStore = tokenStore;

  /// Get current Firebase user
  firebase_auth.User? get currentFirebaseUser => _firebaseAuth.currentUser;

  /// Stream of authentication state changes
  Stream<UserModel?> get authStateChanges {
    return _firebaseAuth.authStateChanges().map((user) {
      return user != null ? UserModel.fromFirebaseUser(user) : null;
    });
  }

  /// Stream of user changes (includes user data updates)
  Stream<UserModel?> get userChanges {
    return _firebaseAuth.userChanges().map((user) {
      return user != null ? UserModel.fromFirebaseUser(user) : null;
    });
  }

  /// Get current user model
  UserModel? getCurrentUser() {
    final user = _firebaseAuth.currentUser;
    return user != null ? UserModel.fromFirebaseUser(user) : null;
  }

  /// Sign up with email and password
  Future<UserModel> signUpWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (credential.user == null) {
        throw AuthError.unknown('Sign up failed');
      }

      return UserModel.fromFirebaseUser(credential.user!);
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw AuthError.fromFirebase(e);
    } catch (e) {
      throw AuthError.unknown(e.toString());
    }
  }

  /// Sign in with email and password
  Future<UserModel> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (credential.user == null) {
        throw AuthError.unknown('Sign in failed');
      }

      return UserModel.fromFirebaseUser(credential.user!);
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw AuthError.fromFirebase(e);
    } catch (e) {
      throw AuthError.unknown(e.toString());
    }
  }

  /// Sign in with Google
  Future<UserModel> signInWithGoogle() async {
    try {
      // Trigger Google Sign-In flow
      final googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        throw AuthError.cancelled();
      }

      // Get authentication details
      final googleAuth = await googleUser.authentication;

      // Create Firebase credential
      final credential = firebase_auth.GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in to Firebase
      final userCredential = await _firebaseAuth.signInWithCredential(credential);

      if (userCredential.user == null) {
        throw AuthError.unknown('Google sign in failed');
      }

      return UserModel.fromFirebaseUser(userCredential.user!);
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw AuthError.fromFirebase(e);
    } catch (e) {
      if (e is AuthError) rethrow;
      throw AuthError.unknown(e.toString());
    }
  }

  /// Sign in with Apple
  Future<UserModel> signInWithApple() async {
    try {
      // Request Apple ID credential
      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      // Create OAuth provider
      final oauthCredential = firebase_auth.OAuthProvider('apple.com').credential(
        idToken: appleCredential.identityToken,
        accessToken: appleCredential.authorizationCode,
      );

      // Sign in to Firebase
      final userCredential = await _firebaseAuth.signInWithCredential(oauthCredential);

      if (userCredential.user == null) {
        throw AuthError.unknown('Apple sign in failed');
      }

      // Update display name if available
      if (appleCredential.givenName != null || appleCredential.familyName != null) {
        final displayName =
            '${appleCredential.givenName ?? ''} ${appleCredential.familyName ?? ''}'.trim();
        if (displayName.isNotEmpty) {
          await userCredential.user!.updateDisplayName(displayName);
        }
      }

      return UserModel.fromFirebaseUser(userCredential.user!);
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw AuthError.fromFirebase(e);
    } on SignInWithAppleAuthorizationException catch (e) {
      if (e.code == AuthorizationErrorCode.canceled) {
        throw AuthError.cancelled();
      }
      throw AuthError.unknown(e.message);
    } catch (e) {
      if (e is AuthError) rethrow;
      throw AuthError.unknown(e.toString());
    }
  }

  /// Sign in with Facebook
  Future<UserModel> signInWithFacebook() async {
    try {
      // Trigger Facebook login
      final result = await FacebookAuth.instance.login();

      if (result.status != LoginStatus.success) {
        if (result.status == LoginStatus.cancelled) {
          throw AuthError.cancelled();
        }
        throw AuthError.unknown('Facebook login failed: ${result.message}');
      }

      // Get access token
      final accessToken = result.accessToken;
      if (accessToken == null) {
        throw AuthError.unknown('No access token received');
      }

      // Create Facebook credential
      final credential =
          firebase_auth.FacebookAuthProvider.credential(accessToken.token);

      // Sign in to Firebase
      final userCredential = await _firebaseAuth.signInWithCredential(credential);

      if (userCredential.user == null) {
        throw AuthError.unknown('Facebook sign in failed');
      }

      return UserModel.fromFirebaseUser(userCredential.user!);
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw AuthError.fromFirebase(e);
    } catch (e) {
      if (e is AuthError) rethrow;
      throw AuthError.unknown(e.toString());
    }
  }

  /// Sign in anonymously
  Future<UserModel> signInAnonymously() async {
    try {
      final credential = await _firebaseAuth.signInAnonymously();

      if (credential.user == null) {
        throw AuthError.unknown('Anonymous sign in failed');
      }

      return UserModel.fromFirebaseUser(credential.user!);
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw AuthError.fromFirebase(e);
    } catch (e) {
      throw AuthError.unknown(e.toString());
    }
  }

  /// Verify phone number and send OTP
  Future<void> verifyPhoneNumber({
    required String phoneNumber,
    required Function(String verificationId, int? resendToken) codeSent,
    required Function(firebase_auth.PhoneAuthCredential credential) verificationCompleted,
    required Function(AuthError error) verificationFailed,
    Duration timeout = const Duration(seconds: 60),
  }) async {
    try {
      await _firebaseAuth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        timeout: timeout,
        verificationCompleted: verificationCompleted,
        verificationFailed: (e) {
          verificationFailed(AuthError.fromFirebase(e));
        },
        codeSent: (verificationId, resendToken) {
          _verificationId = verificationId;
          _resendToken = resendToken;
          codeSent(verificationId, resendToken);
        },
        codeAutoRetrievalTimeout: (verificationId) {
          _verificationId = verificationId;
        },
        forceResendingToken: _resendToken,
      );
    } catch (e) {
      throw AuthError.unknown(e.toString());
    }
  }

  /// Sign in with phone credential
  Future<UserModel> signInWithPhoneCredential(
    firebase_auth.PhoneAuthCredential credential,
  ) async {
    try {
      final userCredential = await _firebaseAuth.signInWithCredential(credential);

      if (userCredential.user == null) {
        throw AuthError.unknown('Phone sign in failed');
      }

      return UserModel.fromFirebaseUser(userCredential.user!);
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw AuthError.fromFirebase(e);
    } catch (e) {
      throw AuthError.unknown(e.toString());
    }
  }

  /// Verify OTP code and sign in
  Future<UserModel> verifyPhoneOtp({
    required String verificationId,
    required String smsCode,
  }) async {
    try {
      final credential = firebase_auth.PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: smsCode,
      );

      return await signInWithPhoneCredential(credential);
    } catch (e) {
      if (e is AuthError) rethrow;
      throw AuthError.unknown(e.toString());
    }
  }

  /// Link email/password credential to current user
  Future<UserModel> linkWithEmailPassword({
    required String email,
    required String password,
  }) async {
    try {
      final user = _firebaseAuth.currentUser;
      if (user == null) {
        throw AuthError.unknown('No user signed in');
      }

      final credential = firebase_auth.EmailAuthProvider.credential(
        email: email,
        password: password,
      );

      final userCredential = await user.linkWithCredential(credential);

      if (userCredential.user == null) {
        throw AuthError.unknown('Link failed');
      }

      return UserModel.fromFirebaseUser(userCredential.user!);
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw AuthError.fromFirebase(e);
    } catch (e) {
      if (e is AuthError) rethrow;
      throw AuthError.unknown(e.toString());
    }
  }

  /// Link Google account to current user
  Future<UserModel> linkWithGoogle() async {
    try {
      final user = _firebaseAuth.currentUser;
      if (user == null) {
        throw AuthError.unknown('No user signed in');
      }

      final googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        throw AuthError.cancelled();
      }

      final googleAuth = await googleUser.authentication;
      final credential = firebase_auth.GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential = await user.linkWithCredential(credential);

      if (userCredential.user == null) {
        throw AuthError.unknown('Link failed');
      }

      return UserModel.fromFirebaseUser(userCredential.user!);
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw AuthError.fromFirebase(e);
    } catch (e) {
      if (e is AuthError) rethrow;
      throw AuthError.unknown(e.toString());
    }
  }

  /// Link Apple account to current user
  Future<UserModel> linkWithApple() async {
    try {
      final user = _firebaseAuth.currentUser;
      if (user == null) {
        throw AuthError.unknown('No user signed in');
      }

      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      final oauthCredential = firebase_auth.OAuthProvider('apple.com').credential(
        idToken: appleCredential.identityToken,
        accessToken: appleCredential.authorizationCode,
      );

      final userCredential = await user.linkWithCredential(oauthCredential);

      if (userCredential.user == null) {
        throw AuthError.unknown('Link failed');
      }

      return UserModel.fromFirebaseUser(userCredential.user!);
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw AuthError.fromFirebase(e);
    } catch (e) {
      if (e is AuthError) rethrow;
      throw AuthError.unknown(e.toString());
    }
  }

  /// Link Facebook account to current user
  Future<UserModel> linkWithFacebook() async {
    try {
      final user = _firebaseAuth.currentUser;
      if (user == null) {
        throw AuthError.unknown('No user signed in');
      }

      final result = await FacebookAuth.instance.login();
      if (result.status != LoginStatus.success) {
        throw AuthError.cancelled();
      }

      final accessToken = result.accessToken;
      if (accessToken == null) {
        throw AuthError.unknown('No access token');
      }

      final credential =
          firebase_auth.FacebookAuthProvider.credential(accessToken.token);

      final userCredential = await user.linkWithCredential(credential);

      if (userCredential.user == null) {
        throw AuthError.unknown('Link failed');
      }

      return UserModel.fromFirebaseUser(userCredential.user!);
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw AuthError.fromFirebase(e);
    } catch (e) {
      if (e is AuthError) rethrow;
      throw AuthError.unknown(e.toString());
    }
  }

  /// Unlink provider from current user
  Future<UserModel> unlinkProvider(String providerId) async {
    try {
      final user = _firebaseAuth.currentUser;
      if (user == null) {
        throw AuthError.unknown('No user signed in');
      }

      final updatedUser = await user.unlink(providerId);

      return UserModel.fromFirebaseUser(updatedUser);
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw AuthError.fromFirebase(e);
    } catch (e) {
      throw AuthError.unknown(e.toString());
    }
  }

  /// Send email verification
  Future<void> sendEmailVerification() async {
    try {
      final user = _firebaseAuth.currentUser;
      if (user == null) {
        throw AuthError.unknown('No user signed in');
      }

      await user.sendEmailVerification();
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw AuthError.fromFirebase(e);
    } catch (e) {
      throw AuthError.unknown(e.toString());
    }
  }

  /// Send password reset email
  Future<void> sendPasswordReset(String email) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw AuthError.fromFirebase(e);
    } catch (e) {
      throw AuthError.unknown(e.toString());
    }
  }

  /// Update user profile
  Future<void> updateProfile({
    String? displayName,
    String? photoUrl,
  }) async {
    try {
      final user = _firebaseAuth.currentUser;
      if (user == null) {
        throw AuthError.unknown('No user signed in');
      }

      if (displayName != null) {
        await user.updateDisplayName(displayName);
      }

      if (photoUrl != null) {
        await user.updatePhotoURL(photoUrl);
      }

      await user.reload();
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw AuthError.fromFirebase(e);
    } catch (e) {
      throw AuthError.unknown(e.toString());
    }
  }

  /// Reauthenticate with email and password
  Future<void> reauthenticateWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      final user = _firebaseAuth.currentUser;
      if (user == null) {
        throw AuthError.unknown('No user signed in');
      }

      final credential = firebase_auth.EmailAuthProvider.credential(
        email: email,
        password: password,
      );

      await user.reauthenticateWithCredential(credential);
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw AuthError.fromFirebase(e);
    } catch (e) {
      throw AuthError.unknown(e.toString());
    }
  }

  /// Change password (requires recent authentication)
  Future<void> changePassword(String newPassword) async {
    try {
      final user = _firebaseAuth.currentUser;
      if (user == null) {
        throw AuthError.unknown('No user signed in');
      }

      await user.updatePassword(newPassword);
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw AuthError.fromFirebase(e);
    } catch (e) {
      throw AuthError.unknown(e.toString());
    }
  }

  /// Delete user account (requires recent authentication)
  Future<void> deleteAccount() async {
    try {
      final user = _firebaseAuth.currentUser;
      if (user == null) {
        throw AuthError.unknown('No user signed in');
      }

      await user.delete();
      await _tokenStore.clearAll();
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw AuthError.fromFirebase(e);
    } catch (e) {
      throw AuthError.unknown(e.toString());
    }
  }

  /// Sign out
  Future<void> signOut() async {
    try {
      // Sign out from all providers
      await Future.wait([
        _firebaseAuth.signOut(),
        _googleSignIn.signOut(),
        FacebookAuth.instance.logOut(),
      ]);

      // Clear stored tokens
      await _tokenStore.clearAll();
    } catch (e) {
      throw AuthError.unknown(e.toString());
    }
  }

  /// Get ID token
  Future<String?> getIdToken({bool forceRefresh = false}) async {
    try {
      final user = _firebaseAuth.currentUser;
      if (user == null) return null;

      return await user.getIdToken(forceRefresh);
    } catch (e) {
      return null;
    }
  }

  /// Reload current user
  Future<void> reloadUser() async {
    try {
      final user = _firebaseAuth.currentUser;
      if (user == null) return;

      await user.reload();
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw AuthError.fromFirebase(e);
    } catch (e) {
      throw AuthError.unknown(e.toString());
    }
  }
}
