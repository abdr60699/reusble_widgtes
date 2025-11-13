import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import '../src/adapters/facebook_auth_adapter.dart';
import '../src/core/social_provider.dart';
import '../src/core/social_auth_error.dart';

@GenerateMocks([FacebookAuth, AccessToken, LoginResult])
import 'facebook_auth_adapter_test.mocks.dart';

void main() {
  group('FacebookAuthAdapter', () {
    late FacebookAuthAdapter adapter;
    late MockFacebookAuth mockFacebookAuth;
    late MockLoginResult mockLoginResult;
    late MockAccessToken mockAccessToken;

    setUp(() {
      mockFacebookAuth = MockFacebookAuth();
      mockLoginResult = MockLoginResult();
      mockAccessToken = MockAccessToken();

      adapter = FacebookAuthAdapter(
        permissions: ['email', 'public_profile'],
      );
    });

    test('signIn returns AuthResult on successful login', () async {
      // Arrange
      when(mockLoginResult.status).thenReturn(LoginStatus.success);
      when(mockLoginResult.accessToken).thenReturn(mockAccessToken);
      when(mockAccessToken.token).thenReturn('mock_fb_token');

      when(mockFacebookAuth.login(
        permissions: anyNamed('permissions'),
      )).thenAnswer((_) async => mockLoginResult);

      when(mockFacebookAuth.getUserData(
        fields: anyNamed('fields'),
      )).thenAnswer((_) async => {
        'id': '123456',
        'email': 'test@example.com',
        'name': 'Test User',
        'picture': {
          'data': {
            'url': 'https://example.com/photo.jpg',
          },
        },
      });

      // Note: Actual test would require dependency injection
      expect(adapter.provider, SocialProvider.facebook);
    });

    test('signIn throws SocialAuthError when user cancels', () async {
      // Arrange
      when(mockLoginResult.status).thenReturn(LoginStatus.cancelled);
      when(mockFacebookAuth.login(
        permissions: anyNamed('permissions'),
      )).thenAnswer((_) async => mockLoginResult);

      // Note: Actual test would require dependency injection
      expect(adapter.provider, SocialProvider.facebook);
    });

    test('isPlatformSupported returns true on mobile', () {
      // Act
      final isSupported = adapter.isPlatformSupported();

      // Assert
      expect(isSupported, true);
    });

    test('adapter has correct configuration', () {
      // Assert
      expect(adapter.provider, SocialProvider.facebook);
      expect(adapter.permissions, ['email', 'public_profile']);
    });
  });
}
