import 'package:flutter_test/flutter_test.dart';
import 'package:reusble_widgtes/features/firebase_auth/utils/validators.dart';

void main() {
  group('AuthValidators', () {
    group('validateEmail', () {
      test('returns null for valid email', () {
        expect(AuthValidators.validateEmail('test@example.com'), null);
        expect(AuthValidators.validateEmail('user.name@domain.co.uk'), null);
      });

      test('returns error for invalid email', () {
        expect(AuthValidators.validateEmail('invalid'), isNot(null));
        expect(AuthValidators.validateEmail('test@'), isNot(null));
        expect(AuthValidators.validateEmail('@example.com'), isNot(null));
      });

      test('returns error for empty email', () {
        expect(AuthValidators.validateEmail(''), isNot(null));
        expect(AuthValidators.validateEmail(null), isNot(null));
      });
    });

    group('validatePassword', () {
      test('returns null for valid password', () {
        expect(AuthValidators.validatePassword('password123'), null);
        expect(AuthValidators.validatePassword('secure'), null);
      });

      test('returns error for too short password', () {
        expect(AuthValidators.validatePassword('12345'), isNot(null));
        expect(AuthValidators.validatePassword('abc'), isNot(null));
      });

      test('returns error for empty password', () {
        expect(AuthValidators.validatePassword(''), isNot(null));
        expect(AuthValidators.validatePassword(null), isNot(null));
      });

      test('respects min length parameter', () {
        expect(AuthValidators.validatePassword('1234567', minLength: 8),
            isNot(null));
        expect(AuthValidators.validatePassword('12345678', minLength: 8), null);
      });
    });

    group('validatePhoneNumber', () {
      test('returns null for valid phone number', () {
        expect(AuthValidators.validatePhoneNumber('+1234567890'), null);
        expect(AuthValidators.validatePhoneNumber('+447911123456'), null);
      });

      test('returns error for invalid phone number', () {
        expect(
            AuthValidators.validatePhoneNumber('1234567890'), isNot(null));
        expect(AuthValidators.validatePhoneNumber('+12'), isNot(null));
      });

      test('returns error for empty phone number', () {
        expect(AuthValidators.validatePhoneNumber(''), isNot(null));
        expect(AuthValidators.validatePhoneNumber(null), isNot(null));
      });
    });

    group('validateOtpCode', () {
      test('returns null for valid OTP', () {
        expect(AuthValidators.validateOtpCode('123456'), null);
      });

      test('returns error for invalid OTP length', () {
        expect(AuthValidators.validateOtpCode('12345'), isNot(null));
        expect(AuthValidators.validateOtpCode('1234567'), isNot(null));
      });

      test('returns error for non-numeric OTP', () {
        expect(AuthValidators.validateOtpCode('12345a'), isNot(null));
        expect(AuthValidators.validateOtpCode('abcdef'), isNot(null));
      });
    });

    group('sanitizePhoneNumber', () {
      test('removes formatting characters', () {
        expect(AuthValidators.sanitizePhoneNumber('+1 (555) 123-4567'),
            '+15551234567');
        expect(AuthValidators.sanitizePhoneNumber('+44 7911 123456'),
            '+447911123456');
      });
    });
  });
}
