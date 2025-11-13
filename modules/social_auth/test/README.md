# Social Auth Module Tests

Comprehensive test suite for the Social Auth module.

## Test Coverage

### Unit Tests

**Adapter Tests:**
- `google_auth_adapter_test.dart` - Google Sign-In adapter tests
- `apple_auth_adapter_test.dart` - Apple Sign-In adapter tests
- `facebook_auth_adapter_test.dart` - Facebook Login adapter tests

**Service Tests:**
- `social_auth_manager_test.dart` - Core manager logic tests

### Widget Tests

- `widget_test.dart` - UI component tests
  - SocialSignInButton tests
  - SocialSignInRow tests

## Running Tests

### Run All Tests

```bash
flutter test
```

### Run Specific Test File

```bash
flutter test test/google_auth_adapter_test.dart
```

### Run with Coverage

```bash
flutter test --coverage
```

### Generate Mocks

The tests use Mockito for mocking. To generate mock files:

```bash
flutter pub run build_runner build
```

This will generate:
- `google_auth_adapter_test.mocks.dart`
- `facebook_auth_adapter_test.mocks.dart`
- `social_auth_manager_test.mocks.dart`

## Test Structure

### Adapter Tests

Adapter tests verify:
- ✅ Successful sign-in flow
- ✅ User cancellation handling
- ✅ Network error handling
- ✅ Sign-out functionality
- ✅ Sign-in status checking
- ✅ Platform support detection

### Manager Tests

Manager tests verify:
- ✅ Adapter orchestration
- ✅ Backend service integration
- ✅ Token storage
- ✅ Error propagation
- ✅ Configuration validation
- ✅ Platform compatibility checks

### Widget Tests

Widget tests verify:
- ✅ Button rendering for each provider
- ✅ Loading state display
- ✅ Disabled state handling
- ✅ Custom styling application
- ✅ Tap event handling
- ✅ Provider selection callbacks

## Mocking Strategy

Tests use Mockito to mock:
- `GoogleSignIn` - Google Sign-In SDK
- `FacebookAuth` - Facebook Auth SDK
- `AuthService` - Backend authentication
- `TokenStorage` - Token storage
- `SocialAuthLogger` - Logging

## Test Best Practices

1. **Arrange-Act-Assert Pattern**
   ```dart
   test('description', () async {
     // Arrange - Set up test data and mocks
     when(mockAdapter.signIn()).thenAnswer((_) async => mockResult);

     // Act - Execute the code under test
     final result = await manager.signInWithGoogle();

     // Assert - Verify the results
     expect(result, mockResult);
     verify(mockAdapter.signIn()).called(1);
   });
   ```

2. **Test Error Conditions**
   - User cancellation
   - Network errors
   - Invalid configuration
   - Platform incompatibility

3. **Verify Side Effects**
   - Backend calls made
   - Tokens stored
   - Logging occurred

4. **Test Widget Interactions**
   - Button taps
   - Loading states
   - Error displays

## Continuous Integration

Add to your CI pipeline:

```yaml
# .github/workflows/test.yml
name: Tests

on: [push, pull_request]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.16.0'
      - run: flutter pub get
      - run: flutter pub run build_runner build
      - run: flutter test --coverage
      - uses: codecov/codecov-action@v3
```

## Known Limitations

1. **Platform-Specific Tests**
   - Apple Sign-In tests are limited without iOS simulator
   - Some tests check behavior in test environment (not actual iOS/Android)

2. **SDK Mocking**
   - Some SDKs are difficult to mock without dependency injection
   - Tests focus on adapter logic rather than SDK internals

3. **Integration Tests**
   - Full OAuth flows require actual provider credentials
   - Use example app for manual integration testing

## Adding New Tests

When adding new features:

1. Create corresponding test file
2. Add mocks if needed
3. Test happy path
4. Test error conditions
5. Update this README

## Troubleshooting

### Mock Generation Fails

```bash
flutter clean
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs
```

### Tests Timeout

Increase timeout in test:

```dart
test('description', () async {
  // test code
}, timeout: const Timeout(Duration(seconds: 30)));
```

### Import Errors

Ensure all dependencies are in `pubspec.yaml` and run:

```bash
flutter pub get
```
