import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../models/user_model.dart';
import '../repository/auth_repository.dart';
import '../services/auth_service.dart';
import '../errors/auth_error.dart';

// Generate mocks
@GenerateMocks([AuthRepository])
import 'auth_service_test.mocks.dart';

void main() {
  late MockAuthRepository mockRepository;
  late AuthService authService;

  final testUser = UserModel(
    uid: 'test-uid-123',
    email: 'test@example.com',
    displayName: 'Test User',
    emailVerified: true,
    isAnonymous: false,
    providers: ['password'],
  );

  setUp(() {
    mockRepository = MockAuthRepository();
    authService = AuthService(repository: mockRepository);
  });

  group('AuthService - Sign Up', () {
    test('signUpWithEmail returns user on success', () async {
      // Arrange
      when(mockRepository.signUpWithEmail(
        email: anyNamed('email'),
        password: anyNamed('password'),
      )).thenAnswer((_) async => testUser);

      // Act
      final result = await authService.signUpWithEmail(
        email: 'test@example.com',
        password: 'password123',
      );

      // Assert
      expect(result, testUser);
      verify(mockRepository.signUpWithEmail(
        email: 'test@example.com',
        password: 'password123',
      )).called(1);
    });

    test('signUpWithEmail updates display name if provided', () async {
      // Arrange
      when(mockRepository.signUpWithEmail(
        email: anyNamed('email'),
        password: anyNamed('password'),
      )).thenAnswer((_) async => testUser);

      when(mockRepository.updateProfile(displayName: anyNamed('displayName')))
          .thenAnswer((_) async => {});

      when(mockRepository.reloadUser()).thenAnswer((_) async => {});

      when(mockRepository.getCurrentUser()).thenReturn(testUser);

      // Act
      final result = await authService.signUpWithEmail(
        email: 'test@example.com',
        password: 'password123',
        displayName: 'John Doe',
      );

      // Assert
      expect(result, testUser);
      verify(mockRepository.updateProfile(displayName: 'John Doe')).called(1);
      verify(mockRepository.reloadUser()).called(1);
    });

    test('signUpWithEmail throws AuthError on failure', () async {
      // Arrange
      when(mockRepository.signUpWithEmail(
        email: anyNamed('email'),
        password: anyNamed('password'),
      )).thenThrow(AuthError.fromFirebase(
        code: 'email-already-in-use',
        message: 'Email is already registered',
      ));

      // Act & Assert
      expect(
        () => authService.signUpWithEmail(
          email: 'test@example.com',
          password: 'password123',
        ),
        throwsA(isA<AuthError>()),
      );
    });
  });

  group('AuthService - Sign In', () {
    test('signInWithEmail returns user on success', () async {
      // Arrange
      when(mockRepository.signInWithEmail(
        email: anyNamed('email'),
        password: anyNamed('password'),
      )).thenAnswer((_) async => testUser);

      // Act
      final result = await authService.signInWithEmail(
        email: 'test@example.com',
        password: 'password123',
      );

      // Assert
      expect(result, testUser);
      verify(mockRepository.signInWithEmail(
        email: 'test@example.com',
        password: 'password123',
      )).called(1);
    });

    test('signInWithGoogle returns user on success', () async {
      // Arrange
      final googleUser = UserModel(
        uid: 'google-uid',
        email: 'test@gmail.com',
        displayName: 'Test User',
        emailVerified: true,
        isAnonymous: false,
        providers: ['google.com'],
      );

      when(mockRepository.signInWithGoogle())
          .thenAnswer((_) async => googleUser);

      // Act
      final result = await authService.signInWithGoogle();

      // Assert
      expect(result, googleUser);
      verify(mockRepository.signInWithGoogle()).called(1);
    });

    test('signInAnonymously returns anonymous user', () async {
      // Arrange
      final anonUser = UserModel(
        uid: 'anon-uid',
        isAnonymous: true,
        emailVerified: false,
        providers: ['anonymous'],
      );

      when(mockRepository.signInAnonymously())
          .thenAnswer((_) async => anonUser);

      // Act
      final result = await authService.signInAnonymously();

      // Assert
      expect(result.isAnonymous, true);
      verify(mockRepository.signInAnonymously()).called(1);
    });
  });

  group('AuthService - Account Linking', () {
    test('linkWithEmailPassword links account successfully', () async {
      // Arrange
      final linkedUser = UserModel(
        uid: testUser.uid,
        email: 'test@example.com',
        displayName: testUser.displayName,
        emailVerified: true,
        isAnonymous: false,
        providers: ['password', 'google.com'],
      );

      when(mockRepository.linkWithEmailPassword(
        email: anyNamed('email'),
        password: anyNamed('password'),
      )).thenAnswer((_) async => linkedUser);

      // Act
      final result = await authService.linkWithEmailPassword(
        email: 'test@example.com',
        password: 'password123',
      );

      // Assert
      expect(result.providers.length, 2);
      expect(result.providers, contains('password'));
      verify(mockRepository.linkWithEmailPassword(
        email: 'test@example.com',
        password: 'password123',
      )).called(1);
    });

    test('unlinkProvider removes provider successfully', () async {
      // Arrange
      final unlinkedUser = UserModel(
        uid: testUser.uid,
        email: testUser.email,
        displayName: testUser.displayName,
        emailVerified: true,
        isAnonymous: false,
        providers: ['password'],
      );

      when(mockRepository.unlinkProvider('google.com'))
          .thenAnswer((_) async => unlinkedUser);

      // Act
      final result = await authService.unlinkProvider('google.com');

      // Assert
      expect(result.providers, ['password']);
      expect(result.providers, isNot(contains('google.com')));
      verify(mockRepository.unlinkProvider('google.com')).called(1);
    });
  });

  group('AuthService - Email Verification', () {
    test('sendEmailVerification calls repository', () async {
      // Arrange
      when(mockRepository.sendEmailVerification())
          .thenAnswer((_) async => {});

      // Act
      await authService.sendEmailVerification();

      // Assert
      verify(mockRepository.sendEmailVerification()).called(1);
    });

    test('checkEmailVerified reloads user and returns verification status',
        () async {
      // Arrange
      when(mockRepository.reloadUser()).thenAnswer((_) async => {});
      when(mockRepository.getCurrentUser()).thenReturn(
        testUser.copyWith(emailVerified: true),
      );

      // Act
      final result = await authService.checkEmailVerified();

      // Assert
      expect(result, true);
      verify(mockRepository.reloadUser()).called(1);
    });
  });

  group('AuthService - Password Management', () {
    test('sendPasswordReset calls repository', () async {
      // Arrange
      when(mockRepository.sendPasswordReset('test@example.com'))
          .thenAnswer((_) async => {});

      // Act
      await authService.sendPasswordReset('test@example.com');

      // Assert
      verify(mockRepository.sendPasswordReset('test@example.com')).called(1);
    });

    test('changePassword calls repository', () async {
      // Arrange
      when(mockRepository.changePassword('newPassword123'))
          .thenAnswer((_) async => {});

      // Act
      await authService.changePassword('newPassword123');

      // Assert
      verify(mockRepository.changePassword('newPassword123')).called(1);
    });
  });

  group('AuthService - Reauthentication', () {
    test('reauthenticateWithEmail succeeds on first call', () async {
      // Arrange
      when(mockRepository.reauthenticateWithEmail(
        email: anyNamed('email'),
        password: anyNamed('password'),
      )).thenAnswer((_) async => {});

      // Act
      await authService.reauthenticateWithEmail(
        email: 'test@example.com',
        password: 'password123',
      );

      // Assert
      verify(mockRepository.reauthenticateWithEmail(
        email: 'test@example.com',
        password: 'password123',
      )).called(1);
    });

    test('reauthenticateWithEmail prevents concurrent calls', () async {
      // Arrange
      when(mockRepository.reauthenticateWithEmail(
        email: anyNamed('email'),
        password: anyNamed('password'),
      )).thenAnswer((_) async {
        await Future.delayed(Duration(milliseconds: 100));
      });

      // Act
      final future1 = authService.reauthenticateWithEmail(
        email: 'test@example.com',
        password: 'password123',
      );

      // Try to call again while first is in progress
      expect(
        () => authService.reauthenticateWithEmail(
          email: 'test@example.com',
          password: 'password123',
        ),
        throwsA(isA<AuthError>()),
      );

      await future1;
    });
  });

  group('AuthService - Account Deletion', () {
    test('deleteAccount calls repository', () async {
      // Arrange
      when(mockRepository.deleteAccount()).thenAnswer((_) async => {});

      // Act
      await authService.deleteAccount();

      // Assert
      verify(mockRepository.deleteAccount()).called(1);
    });

    test('deleteAccount throws on requires-reauth error', () async {
      // Arrange
      when(mockRepository.deleteAccount()).thenThrow(
        AuthError.fromFirebase(
          code: 'requires-recent-login',
          message: 'Please sign in again',
        ),
      );

      // Act & Assert
      expect(
        () => authService.deleteAccount(),
        throwsA(isA<AuthError>()),
      );
    });
  });

  group('AuthService - Sign Out', () {
    test('signOut calls repository', () async {
      // Arrange
      when(mockRepository.signOut()).thenAnswer((_) async => {});

      // Act
      await authService.signOut();

      // Assert
      verify(mockRepository.signOut()).called(1);
    });
  });

  group('AuthService - Token Management', () {
    test('getIdToken returns token from repository', () async {
      // Arrange
      const token = 'test-id-token-123';
      when(mockRepository.getIdToken(forceRefresh: anyNamed('forceRefresh')))
          .thenAnswer((_) async => token);

      // Act
      final result = await authService.getIdToken();

      // Assert
      expect(result, token);
      verify(mockRepository.getIdToken(forceRefresh: false)).called(1);
    });

    test('refreshToken forces token refresh', () async {
      // Arrange
      const newToken = 'new-token-456';
      when(mockRepository.getIdToken(forceRefresh: anyNamed('forceRefresh')))
          .thenAnswer((_) async => newToken);

      // Act
      final result = await authService.refreshToken();

      // Assert
      expect(result, newToken);
      verify(mockRepository.getIdToken(forceRefresh: true)).called(1);
    });
  });

  group('AuthService - Utility Methods', () {
    test('currentUser returns user from repository', () {
      // Arrange
      when(mockRepository.getCurrentUser()).thenReturn(testUser);

      // Act
      final result = authService.currentUser;

      // Assert
      expect(result, testUser);
      verify(mockRepository.getCurrentUser()).called(1);
    });

    test('isSignedIn returns true when user exists', () {
      // Arrange
      when(mockRepository.getCurrentUser()).thenReturn(testUser);

      // Act
      final result = authService.isSignedIn;

      // Assert
      expect(result, true);
    });

    test('isSignedIn returns false when user is null', () {
      // Arrange
      when(mockRepository.getCurrentUser()).thenReturn(null);

      // Act
      final result = authService.isSignedIn;

      // Assert
      expect(result, false);
    });

    test('isEmailVerified returns verification status', () {
      // Arrange
      when(mockRepository.getCurrentUser()).thenReturn(testUser);

      // Act
      final result = authService.isEmailVerified;

      // Assert
      expect(result, testUser.emailVerified);
    });

    test('hasProvider checks if user has specific provider', () {
      // Arrange
      when(mockRepository.getCurrentUser()).thenReturn(testUser);

      // Act
      final hasPassword = authService.hasProvider('password');
      final hasGoogle = authService.hasProvider('google.com');

      // Assert
      expect(hasPassword, true);
      expect(hasGoogle, false);
    });

    test('isAnonymous returns anonymous status', () {
      // Arrange
      when(mockRepository.getCurrentUser()).thenReturn(testUser);

      // Act
      final result = authService.isAnonymous;

      // Assert
      expect(result, false);
    });
  });

  group('AuthService - Profile Management', () {
    test('updateProfile updates and reloads user', () async {
      // Arrange
      when(mockRepository.updateProfile(
        displayName: anyNamed('displayName'),
        photoUrl: anyNamed('photoUrl'),
      )).thenAnswer((_) async => {});

      when(mockRepository.reloadUser()).thenAnswer((_) async => {});

      // Act
      await authService.updateProfile(
        displayName: 'Updated Name',
        photoUrl: 'https://example.com/photo.jpg',
      );

      // Assert
      verify(mockRepository.updateProfile(
        displayName: 'Updated Name',
        photoUrl: 'https://example.com/photo.jpg',
      )).called(1);
      verify(mockRepository.reloadUser()).called(1);
    });
  });
}

// Extension for UserModel to add copyWith for testing
extension UserModelCopyWith on UserModel {
  UserModel copyWith({
    String? uid,
    String? email,
    String? phoneNumber,
    String? displayName,
    String? photoUrl,
    bool? emailVerified,
    bool? isAnonymous,
    List<String>? providers,
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
    );
  }
}
