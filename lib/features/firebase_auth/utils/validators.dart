/// Authentication input validators
class AuthValidators {
  /// Email regex pattern
  static final RegExp _emailRegex = RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
  );

  /// Phone regex pattern (basic international format)
  static final RegExp _phoneRegex = RegExp(
    r'^\+?[1-9]\d{1,14}$',
  );

  /// Validate email address
  ///
  /// Returns null if valid, error message if invalid
  static String? validateEmail(String? email) {
    if (email == null || email.isEmpty) {
      return 'Email is required';
    }

    if (!_emailRegex.hasMatch(email)) {
      return 'Please enter a valid email address';
    }

    return null;
  }

  /// Validate password
  ///
  /// Returns null if valid, error message if invalid
  static String? validatePassword(String? password, {int minLength = 6}) {
    if (password == null || password.isEmpty) {
      return 'Password is required';
    }

    if (password.length < minLength) {
      return 'Password must be at least $minLength characters';
    }

    return null;
  }

  /// Validate password with strength requirements
  ///
  /// Requires uppercase, lowercase, number, and special character
  static String? validateStrongPassword(String? password) {
    if (password == null || password.isEmpty) {
      return 'Password is required';
    }

    if (password.length < 8) {
      return 'Password must be at least 8 characters';
    }

    if (!password.contains(RegExp(r'[A-Z]'))) {
      return 'Password must contain at least one uppercase letter';
    }

    if (!password.contains(RegExp(r'[a-z]'))) {
      return 'Password must contain at least one lowercase letter';
    }

    if (!password.contains(RegExp(r'[0-9]'))) {
      return 'Password must contain at least one number';
    }

    if (!password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
      return 'Password must contain at least one special character';
    }

    return null;
  }

  /// Validate password confirmation
  ///
  /// Returns null if passwords match, error message if they don't
  static String? validatePasswordConfirmation(
    String? password,
    String? confirmation,
  ) {
    if (confirmation == null || confirmation.isEmpty) {
      return 'Please confirm your password';
    }

    if (password != confirmation) {
      return 'Passwords do not match';
    }

    return null;
  }

  /// Validate phone number
  ///
  /// Returns null if valid, error message if invalid
  static String? validatePhone(String? phone) {
    if (phone == null || phone.isEmpty) {
      return 'Phone number is required';
    }

    // Remove spaces and dashes
    final cleanedPhone = phone.replaceAll(RegExp(r'[\s-]'), '');

    if (!_phoneRegex.hasMatch(cleanedPhone)) {
      return 'Please enter a valid phone number (e.g., +1234567890)';
    }

    return null;
  }

  /// Validate OTP code
  ///
  /// Returns null if valid, error message if invalid
  static String? validateOtp(String? otp, {int length = 6}) {
    if (otp == null || otp.isEmpty) {
      return 'Verification code is required';
    }

    if (otp.length != length) {
      return 'Verification code must be $length digits';
    }

    if (!RegExp(r'^\d+$').hasMatch(otp)) {
      return 'Verification code must contain only numbers';
    }

    return null;
  }

  /// Validate display name
  ///
  /// Returns null if valid, error message if invalid
  static String? validateDisplayName(String? name) {
    if (name == null || name.isEmpty) {
      return 'Name is required';
    }

    if (name.length < 2) {
      return 'Name must be at least 2 characters';
    }

    if (name.length > 50) {
      return 'Name must be less than 50 characters';
    }

    return null;
  }

  /// Check if email is valid (boolean)
  static bool isEmailValid(String? email) {
    return validateEmail(email) == null;
  }

  /// Check if password is valid (boolean)
  static bool isPasswordValid(String? password, {int minLength = 6}) {
    return validatePassword(password, minLength: minLength) == null;
  }

  /// Check if phone is valid (boolean)
  static bool isPhoneValid(String? phone) {
    return validatePhone(phone) == null;
  }

  /// Clean phone number (remove spaces and dashes)
  static String cleanPhone(String phone) {
    return phone.replaceAll(RegExp(r'[\s-]'), '');
  }

  /// Format phone number for display
  static String formatPhoneForDisplay(String phone) {
    final cleaned = cleanPhone(phone);

    if (cleaned.startsWith('+1') && cleaned.length == 12) {
      // US format: +1 (XXX) XXX-XXXX
      return '+1 (${cleaned.substring(2, 5)}) ${cleaned.substring(5, 8)}-${cleaned.substring(8)}';
    }

    // Default: keep original format
    return phone;
  }
}
