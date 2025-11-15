import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;

/// Application-level user model
///
/// This model wraps Firebase User with serializable, safe fields.
/// Use this model throughout your app instead of Firebase User directly.
class UserModel {
  /// Unique user ID
  final String uid;

  /// User's email address (nullable)
  final String? email;

  /// User's phone number (nullable)
  final String? phoneNumber;

  /// User's display name (nullable)
  final String? displayName;

  /// User's photo URL (nullable)
  final String? photoUrl;

  /// Whether email is verified
  final bool emailVerified;

  /// Whether user is anonymous
  final bool isAnonymous;

  /// List of provider IDs (e.g., 'password', 'google.com', 'phone')
  final List<String> providers;

  /// User metadata (creation and last sign-in times)
  final UserMetadata? metadata;

  /// Custom claims (for roles, permissions)
  final Map<String, dynamic>? customClaims;

  const UserModel({
    required this.uid,
    this.email,
    this.phoneNumber,
    this.displayName,
    this.photoUrl,
    this.emailVerified = false,
    this.isAnonymous = false,
    this.providers = const [],
    this.metadata,
    this.customClaims,
  });

  /// Create UserModel from Firebase User
  factory UserModel.fromFirebaseUser(firebase_auth.User user) {
    return UserModel(
      uid: user.uid,
      email: user.email,
      phoneNumber: user.phoneNumber,
      displayName: user.displayName,
      photoUrl: user.photoURL,
      emailVerified: user.emailVerified,
      isAnonymous: user.isAnonymous,
      providers: user.providerData.map((info) => info.providerId).toList(),
      metadata: user.metadata != null
          ? UserMetadata.fromFirebaseMetadata(user.metadata!)
          : null,
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'email': email,
      'phoneNumber': phoneNumber,
      'displayName': displayName,
      'photoUrl': photoUrl,
      'emailVerified': emailVerified,
      'isAnonymous': isAnonymous,
      'providers': providers,
      'metadata': metadata?.toJson(),
      'customClaims': customClaims,
    };
  }

  /// Create from JSON
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      uid: json['uid'] as String,
      email: json['email'] as String?,
      phoneNumber: json['phoneNumber'] as String?,
      displayName: json['displayName'] as String?,
      photoUrl: json['photoUrl'] as String?,
      emailVerified: json['emailVerified'] as bool? ?? false,
      isAnonymous: json['isAnonymous'] as bool? ?? false,
      providers: (json['providers'] as List?)?.cast<String>() ?? [],
      metadata: json['metadata'] != null
          ? UserMetadata.fromJson(json['metadata'] as Map<String, dynamic>)
          : null,
      customClaims: json['customClaims'] as Map<String, dynamic>?,
    );
  }

  /// Check if user has specific provider linked
  bool hasProvider(String providerId) {
    return providers.contains(providerId);
  }

  /// Check if email/password provider is linked
  bool get hasPasswordProvider => hasProvider('password');

  /// Check if Google provider is linked
  bool get hasGoogleProvider => hasProvider('google.com');

  /// Check if Apple provider is linked
  bool get hasAppleProvider => hasProvider('apple.com');

  /// Check if Facebook provider is linked
  bool get hasFacebookProvider => hasProvider('facebook.com');

  /// Check if phone provider is linked
  bool get hasPhoneProvider => hasProvider('phone');

  /// Get primary email or phone display
  String get primaryIdentifier => email ?? phoneNumber ?? uid;

  /// Get display name or fallback
  String get displayNameOrEmail => displayName ?? email ?? phoneNumber ?? 'User';

  /// Copy with
  UserModel copyWith({
    String? uid,
    String? email,
    String? phoneNumber,
    String? displayName,
    String? photoUrl,
    bool? emailVerified,
    bool? isAnonymous,
    List<String>? providers,
    UserMetadata? metadata,
    Map<String, dynamic>? customClaims,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      displayName: displayName ?? this.displayName,
      photoUrl: photoUrl ?? this.photoUrl,
      emailVerified: emailVerified ?? this.emailVerified,
      isAnonymous: isAnonymous ?? this.isAnonymous,
      providers: providers ?? this.providers,
      metadata: metadata ?? this.metadata,
      customClaims: customClaims ?? this.customClaims,
    );
  }

  @override
  String toString() {
    return 'UserModel(uid: $uid, email: $email, providers: $providers)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is UserModel && other.uid == uid;
  }

  @override
  int get hashCode => uid.hashCode;
}

/// User metadata (creation and last sign-in times)
class UserMetadata {
  final DateTime? creationTime;
  final DateTime? lastSignInTime;

  const UserMetadata({
    this.creationTime,
    this.lastSignInTime,
  });

  factory UserMetadata.fromFirebaseMetadata(
      firebase_auth.UserMetadata metadata) {
    return UserMetadata(
      creationTime: metadata.creationTime,
      lastSignInTime: metadata.lastSignInTime,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'creationTime': creationTime?.toIso8601String(),
      'lastSignInTime': lastSignInTime?.toIso8601String(),
    };
  }

  factory UserMetadata.fromJson(Map<String, dynamic> json) {
    return UserMetadata(
      creationTime: json['creationTime'] != null
          ? DateTime.parse(json['creationTime'] as String)
          : null,
      lastSignInTime: json['lastSignInTime'] != null
          ? DateTime.parse(json['lastSignInTime'] as String)
          : null,
    );
  }
}
