import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../src/adapters/google_auth_adapter.dart';
import '../src/core/social_provider.dart';
import '../src/core/social_auth_error.dart';

@GenerateMocks([GoogleSignIn, GoogleSignInAccount, GoogleSignInAuthentication])
import 'google_auth_adapter_test.mocks.dart';

void main() {
  group('GoogleAuthAdapter', () {
    late GoogleAuthAdapter adapter;
    late MockGoogleSignIn mockGoogleSignIn;
    late MockGoogleSignInAccount mockAccount;
    late MockGoogleSignInAuthentication mockAuth;

    setUp(() {
      mockGoogleSignIn = MockGoogleSignIn();
      mockAccount = MockGoogleSignInAccount();
      mockAuth = MockGoogleSignInAuthentication();

      adapter = GoogleAuthAdapter(
        scopes: ['email', 'profile'],
      );
    });

    test('signIn returns AuthResult on successful sign in', () async {
      // Arrange
      when(mockAccount.id).thenReturn('123456');
      when(mockAccount.email).thenReturn('test@example.com');
      when(mockAccount.displayName).thenReturn('Test User');
      when(mockAccount.photoUrl).thenReturn('https://example.com/photo.jpg');
      when(mockAccount.authentication).thenAnswer((_) async => mockAuth);

      when(mockAuth.accessToken).thenReturn('mock_access_token');
      when(mockAuth.idToken).thenReturn('mock_id_token');
      when(mockAuth.serverAuthCode).thenReturn('mock_auth_code');

      when(mockGoogleSignIn.signIn()).thenAnswer((_) async => mockAccount);

      // Act
      final result = await adapter.signIn();

      // Assert
      expect(result.provider, SocialProvider.google);
      expect(result.accessToken, 'mock_access_token');
      expect(result.idToken, 'mock_id_token');
      expect(result.authorizationCode, 'mock_auth_code');
      expect(result.user.id, '123456');
      expect(result.user.email, 'test@example.com');
      expect(result.user.name, 'Test User');
      expect(result.user.avatarUrl, 'https://example.com/photo.jpg');

      verify(mockGoogleSignIn.signIn()).called(1);
    });

    test('signIn throws SocialAuthError when user cancels', () async {
      // Arrange
      when(mockGoogleSignIn.signIn()).thenAnswer((_) async => null);

      // Act & Assert
      expect(
        () => adapter.signIn(),
        throwsA(isA<SocialAuthError>().having(
          (e) => e.code,
          'error code',
          SocialAuthErrorCode.userCancelled,
        )),
      );
    });

    test('signIn throws SocialAuthError on network error', () async {
      // Arrange
      when(mockGoogleSignIn.signIn()).thenThrow(
        Exception('Network error'),
      );

      // Act & Assert
      expect(
        () => adapter.signIn(),
        throwsA(isA<SocialAuthError>()),
      );
    });

    test('signOut signs out from Google', () async {
      // Act
      await adapter.signOut();

      // Assert
      verify(mockGoogleSignIn.signOut()).called(1);
    });

    test('isSignedIn returns true when user is signed in', () async {
      // Arrange
      when(mockGoogleSignIn.isSignedIn()).thenAnswer((_) async => true);

      // Act
      final isSignedIn = await adapter.isSignedIn();

      // Assert
      expect(isSignedIn, true);
      verify(mockGoogleSignIn.isSignedIn()).called(1);
    });

    test('isSignedIn returns false when user is not signed in', () async {
      // Arrange
      when(mockGoogleSignIn.isSignedIn()).thenAnswer((_) async => false);

      // Act
      final isSignedIn = await adapter.isSignedIn();

      // Assert
      expect(isSignedIn, false);
    });

    test('isPlatformSupported returns true on mobile platforms', () {
      // Act
      final isSupported = adapter.isPlatformSupported();

      // Assert
      expect(isSupported, true);
    });
  });
}
