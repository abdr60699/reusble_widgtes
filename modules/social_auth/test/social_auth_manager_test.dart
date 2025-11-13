import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import '../src/services/social_auth_manager.dart';
import '../src/adapters/google_auth_adapter.dart';
import '../src/adapters/apple_auth_adapter.dart';
import '../src/adapters/facebook_auth_adapter.dart';
import '../src/core/auth_service.dart';
import '../src/core/token_storage.dart';
import '../src/core/logger.dart';
import '../src/core/social_provider.dart';
import '../src/core/auth_result.dart';
import '../src/core/social_auth_error.dart';

@GenerateMocks([
  GoogleAuthAdapter,
  AppleAuthAdapter,
  FacebookAuthAdapter,
  AuthService,
  TokenStorage,
  SocialAuthLogger,
])
import 'social_auth_manager_test.mocks.dart';

void main() {
  group('SocialAuthManager', () {
    late SocialAuthManager manager;
    late MockGoogleAuthAdapter mockGoogleAdapter;
    late MockAuthService mockAuthService;
    late MockTokenStorage mockTokenStorage;
    late MockSocialAuthLogger mockLogger;

    setUp(() {
      mockGoogleAdapter = MockGoogleAuthAdapter();
      mockAuthService = MockAuthService();
      mockTokenStorage = MockTokenStorage();
      mockLogger = MockSocialAuthLogger();

      when(mockGoogleAdapter.provider).thenReturn(SocialProvider.google);
      when(mockGoogleAdapter.isPlatformSupported()).thenReturn(true);

      manager = SocialAuthManager(
        googleAdapter: mockGoogleAdapter,
        authService: mockAuthService,
        tokenStorage: mockTokenStorage,
        logger: mockLogger,
      );
    });

    test('signInWithGoogle calls adapter and auth service', () async {
      // Arrange
      final mockAuthResult = AuthResult(
        provider: SocialProvider.google,
        accessToken: 'mock_token',
        user: SocialUser(
          id: '123',
          email: 'test@example.com',
          name: 'Test User',
        ),
      );

      when(mockGoogleAdapter.signIn(
        scopes: anyNamed('scopes'),
        parameters: anyNamed('parameters'),
      )).thenAnswer((_) async => mockAuthResult);

      when(mockAuthService.authenticateWithProvider(any))
          .thenAnswer((_) async => {
                'sessionToken': 'backend_token',
                'user': {'id': 'backend_id'},
              });

      when(mockTokenStorage.saveToken(any, any))
          .thenAnswer((_) async => {});

      // Act
      final result = await manager.signInWithGoogle();

      // Assert
      expect(result, mockAuthResult);
      verify(mockGoogleAdapter.signIn(
        scopes: anyNamed('scopes'),
        parameters: anyNamed('parameters'),
      )).called(1);
      verify(mockAuthService.authenticateWithProvider(mockAuthResult))
          .called(1);
      verify(mockTokenStorage.saveToken('session_token', 'backend_token'))
          .called(1);
    });

    test('signInWithGoogle throws error when adapter not configured', () async {
      // Arrange
      final managerWithoutGoogle = SocialAuthManager();

      // Act & Assert
      expect(
        () => managerWithoutGoogle.signInWithGoogle(),
        throwsA(isA<SocialAuthError>().having(
          (e) => e.code,
          'error code',
          SocialAuthErrorCode.configurationError,
        )),
      );
    });

    test('signInWithGoogle throws error when platform not supported', () async {
      // Arrange
      when(mockGoogleAdapter.isPlatformSupported()).thenReturn(false);

      // Act & Assert
      expect(
        () => manager.signInWithGoogle(),
        throwsA(isA<SocialAuthError>().having(
          (e) => e.code,
          'error code',
          SocialAuthErrorCode.platformNotSupported,
        )),
      );
    });

    test('signOut calls all adapters and services', () async {
      // Arrange
      when(mockGoogleAdapter.signOut()).thenAnswer((_) async => {});
      when(mockAuthService.signOut()).thenAnswer((_) async => {});
      when(mockTokenStorage.deleteAll()).thenAnswer((_) async => {});

      // Act
      await manager.signOut();

      // Assert
      verify(mockGoogleAdapter.signOut()).called(1);
      verify(mockAuthService.signOut()).called(1);
      verify(mockTokenStorage.deleteAll()).called(1);
    });

    test('isSignedIn returns adapter status', () async {
      // Arrange
      when(mockGoogleAdapter.isSignedIn()).thenAnswer((_) async => true);

      // Act
      final isSignedIn = await manager.isSignedIn(SocialProvider.google);

      // Assert
      expect(isSignedIn, true);
      verify(mockGoogleAdapter.isSignedIn()).called(1);
    });

    test('isPlatformSupported returns adapter support status', () {
      // Act
      final isSupported = manager.isPlatformSupported(SocialProvider.google);

      // Assert
      expect(isSupported, true);
      verify(mockGoogleAdapter.isPlatformSupported()).called(1);
    });

    test('configuredProviders returns list of configured providers', () {
      // Act
      final providers = manager.configuredProviders;

      // Assert
      expect(providers, contains(SocialProvider.google));
      expect(providers.length, 1);
    });

    test('availableProviders returns only supported providers', () {
      // Act
      final providers = manager.availableProviders;

      // Assert
      expect(providers, contains(SocialProvider.google));
      verify(mockGoogleAdapter.isPlatformSupported()).called(1);
    });
  });
}
