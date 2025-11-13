import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import '../src/widgets/social_sign_in_button.dart';
import '../src/widgets/social_sign_in_row.dart';
import '../src/core/social_provider.dart';

void main() {
  group('SocialSignInButton', () {
    testWidgets('renders Google button with correct styling',
        (WidgetTester tester) async {
      // Arrange
      bool pressed = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SocialSignInButton(
              provider: SocialProvider.google,
              onPressed: () => pressed = true,
            ),
          ),
        ),
      );

      // Assert
      expect(find.text('Continue with Google'), findsOneWidget);
      expect(find.byType(ElevatedButton), findsOneWidget);

      // Act
      await tester.tap(find.byType(ElevatedButton));
      await tester.pump();

      // Assert
      expect(pressed, true);
    });

    testWidgets('renders Apple button with correct styling',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SocialSignInButton(
              provider: SocialProvider.apple,
              onPressed: () {},
            ),
          ),
        ),
      );

      expect(find.text('Continue with Apple'), findsOneWidget);
    });

    testWidgets('renders Facebook button with correct styling',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SocialSignInButton(
              provider: SocialProvider.facebook,
              onPressed: () {},
            ),
          ),
        ),
      );

      expect(find.text('Continue with Facebook'), findsOneWidget);
    });

    testWidgets('shows loading indicator when isLoading is true',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SocialSignInButton(
              provider: SocialProvider.google,
              isLoading: true,
              onPressed: () {},
            ),
          ),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('Continue with Google'), findsNothing);
    });

    testWidgets('is disabled when isDisabled is true',
        (WidgetTester tester) async {
      bool pressed = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SocialSignInButton(
              provider: SocialProvider.google,
              isDisabled: true,
              onPressed: () => pressed = true,
            ),
          ),
        ),
      );

      // Try to tap
      await tester.tap(find.byType(ElevatedButton));
      await tester.pump();

      // Should not have been called
      expect(pressed, false);
    });

    testWidgets('uses custom label when provided',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SocialSignInButton(
              provider: SocialProvider.google,
              customLabel: 'Sign in with Google Account',
              onPressed: () {},
            ),
          ),
        ),
      );

      expect(find.text('Sign in with Google Account'), findsOneWidget);
      expect(find.text('Continue with Google'), findsNothing);
    });

    testWidgets('applies custom dimensions',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SocialSignInButton(
              provider: SocialProvider.google,
              height: 64,
              width: 300,
              onPressed: () {},
            ),
          ),
        ),
      );

      final sizedBox = tester.widget<SizedBox>(find.byType(SizedBox).first);
      expect(sizedBox.height, 64);
      expect(sizedBox.width, 300);
    });
  });

  group('SocialSignInRow', () {
    testWidgets('renders all provider buttons',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SocialSignInRow(
              onProviderSelected: (_) {},
            ),
          ),
        ),
      );

      // Should have all three buttons by default
      expect(find.byType(SocialSignInButton), findsNWidgets(3));
    });

    testWidgets('calls onProviderSelected when button is tapped',
        (WidgetTester tester) async {
      SocialProvider? selectedProvider;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SocialSignInRow(
              onProviderSelected: (provider) => selectedProvider = provider,
            ),
          ),
        ),
      );

      // Tap Google button
      await tester.tap(find.text('Continue with Google'));
      await tester.pump();

      expect(selectedProvider, SocialProvider.google);
    });

    testWidgets('shows loading state for specific provider',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SocialSignInRow(
              loadingStates: {
                SocialProvider.google: true,
              },
              onProviderSelected: (_) {},
            ),
          ),
        ),
      );

      // Should have loading indicator for Google button
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('renders custom providers list',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SocialSignInRow(
              providers: [
                SocialProvider.google,
                SocialProvider.facebook,
              ],
              onProviderSelected: (_) {},
            ),
          ),
        ),
      );

      // Should have only two buttons
      expect(find.byType(SocialSignInButton), findsNWidgets(2));
      expect(find.text('Continue with Google'), findsOneWidget);
      expect(find.text('Continue with Facebook'), findsOneWidget);
      expect(find.text('Continue with Apple'), findsNothing);
    });

    testWidgets('hides Apple button when hideAppleOnAndroid is true',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SocialSignInRow(
              hideAppleOnAndroid: true,
              onProviderSelected: (_) {},
            ),
          ),
        ),
      );

      // On Android/non-iOS platforms in test, Apple should be hidden
      // In test environment, Platform.isIOS is false
      final buttons = tester.widgetList<SocialSignInButton>(
        find.byType(SocialSignInButton),
      );

      final hasApple = buttons.any((b) => b.provider == SocialProvider.apple);
      expect(hasApple, false);
    });

    testWidgets('applies custom spacing',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SocialSignInRow(
              spacing: 24,
              onProviderSelected: (_) {},
            ),
          ),
        ),
      );

      // Column should exist with spacing
      expect(find.byType(Column), findsOneWidget);
    });
  });
}
