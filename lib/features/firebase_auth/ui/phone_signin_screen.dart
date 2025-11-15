import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../errors/auth_error.dart';
import '../providers/auth_providers.dart';
import '../utils/validators.dart';

/// Phone Sign-In Screen
///
/// Provides UI for phone authentication with OTP verification
/// Supports international phone numbers in E.164 format
///
/// Example usage:
/// ```dart
/// Navigator.push(
///   context,
///   MaterialPageRoute(builder: (_) => PhoneSignInScreen()),
/// );
/// ```
class PhoneSignInScreen extends ConsumerStatefulWidget {
  /// Callback when sign-in is successful
  final VoidCallback? onSignInSuccess;

  /// Default country code (without +)
  final String defaultCountryCode;

  const PhoneSignInScreen({
    super.key,
    this.onSignInSuccess,
    this.defaultCountryCode = '1', // Default to US
  });

  @override
  ConsumerState<PhoneSignInScreen> createState() => _PhoneSignInScreenState();
}

class _PhoneSignInScreenState extends ConsumerState<PhoneSignInScreen> {
  final _phoneFormKey = GlobalKey<FormState>();
  final _otpFormKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  final _otpController = TextEditingController();

  bool _isLoading = false;
  bool _codeSent = false;
  String? _errorMessage;
  String? _verificationId;
  int? _resendToken;
  int _resendCountdown = 0;
  Timer? _resendTimer;

  @override
  void initState() {
    super.initState();
    // Pre-fill country code
    _phoneController.text = '+${widget.defaultCountryCode}';
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _otpController.dispose();
    _resendTimer?.cancel();
    super.dispose();
  }

  void _startResendCountdown() {
    _resendCountdown = 60; // 60 seconds cooldown
    _resendTimer?.cancel();
    _resendTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          if (_resendCountdown > 0) {
            _resendCountdown--;
          } else {
            timer.cancel();
          }
        });
      } else {
        timer.cancel();
      }
    });
  }

  Future<void> _sendOtp() async {
    if (!_phoneFormKey.currentState!.validate()) {
      return;
    }

    final phoneNumber = _phoneController.text.trim();

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final authService = ref.read(authServiceProvider);

      await authService.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        codeSent: (verificationId, resendToken) {
          if (mounted) {
            setState(() {
              _codeSent = true;
              _verificationId = verificationId;
              _resendToken = resendToken;
              _isLoading = false;
            });
            _startResendCountdown();

            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Verification code sent to your phone'),
                backgroundColor: Colors.green,
              ),
            );
          }
        },
        verificationCompleted: (credential) {
          // Auto-verification (Android only)
          _signInWithCredential(credential);
        },
        verificationFailed: (error) {
          if (mounted) {
            setState(() {
              _errorMessage = error.message;
              _isLoading = false;
            });
          }
        },
        timeout: const Duration(seconds: 60),
      );
    } on AuthError catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = e.message;
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _verifyOtp() async {
    if (!_otpFormKey.currentState!.validate()) {
      return;
    }

    if (_verificationId == null) {
      setState(() {
        _errorMessage = 'Verification ID is missing. Please resend code.';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final authService = ref.read(authServiceProvider);

      await authService.verifyPhoneOtp(
        verificationId: _verificationId!,
        smsCode: _otpController.text.trim(),
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Phone verified successfully!'),
            backgroundColor: Colors.green,
          ),
        );

        widget.onSignInSuccess?.call();
      }
    } on AuthError catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = e.message;
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _signInWithCredential(
    firebase_auth.PhoneAuthCredential credential,
  ) async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final authService = ref.read(authServiceProvider);
      await authService.signInWithPhoneCredential(credential);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Signed in successfully!'),
            backgroundColor: Colors.green,
          ),
        );

        widget.onSignInSuccess?.call();
      }
    } on AuthError catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = e.message;
          _isLoading = false;
        });
      }
    }
  }

  void _editPhoneNumber() {
    setState(() {
      _codeSent = false;
      _otpController.clear();
      _errorMessage = null;
      _resendTimer?.cancel();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Phone Sign In'),
        elevation: 0,
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Icon
                Icon(
                  Icons.phone_android,
                  size: 80,
                  color: theme.primaryColor,
                ),
                const SizedBox(height: 24),

                // Title
                Text(
                  _codeSent ? 'Verify OTP' : 'Enter Phone Number',
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  _codeSent
                      ? 'Enter the 6-digit code sent to\n${_phoneController.text}'
                      : 'We will send you a verification code',
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: theme.textTheme.bodySmall?.color,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),

                // Error message
                if (_errorMessage != null) ...[
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.errorContainer,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.error_outline,
                          color: theme.colorScheme.error,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            _errorMessage!,
                            style: TextStyle(
                              color: theme.colorScheme.onErrorContainer,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                ],

                // Phone number input or OTP input
                if (!_codeSent) ...[
                  // Phone number form
                  Form(
                    key: _phoneFormKey,
                    child: TextFormField(
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                      textInputAction: TextInputAction.done,
                      enabled: !_isLoading,
                      decoration: InputDecoration(
                        labelText: 'Phone Number',
                        hintText: '+1234567890',
                        prefixIcon: const Icon(Icons.phone),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        helperText: 'Include country code (e.g., +1 for US)',
                        helperMaxLines: 2,
                      ),
                      validator: AuthValidators.validatePhone,
                      onFieldSubmitted: (_) => _sendOtp(),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Send code button
                  FilledButton(
                    onPressed: _isLoading ? null : _sendOtp,
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.white,
                              ),
                            ),
                          )
                        : const Text(
                            'Send Code',
                            style: TextStyle(fontSize: 16),
                          ),
                  ),
                ] else ...[
                  // OTP form
                  Form(
                    key: _otpFormKey,
                    child: TextFormField(
                      controller: _otpController,
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.done,
                      enabled: !_isLoading,
                      maxLength: 6,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 32,
                        letterSpacing: 8,
                        fontWeight: FontWeight.bold,
                      ),
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        counterText: '',
                        hintText: '000000',
                      ),
                      validator: AuthValidators.validateOtp,
                      onFieldSubmitted: (_) => _verifyOtp(),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Verify button
                  FilledButton(
                    onPressed: _isLoading ? null : _verifyOtp,
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.white,
                              ),
                            ),
                          )
                        : const Text(
                            'Verify Code',
                            style: TextStyle(fontSize: 16),
                          ),
                  ),
                  const SizedBox(height: 16),

                  // Resend code button
                  if (_resendCountdown > 0)
                    Text(
                      'Resend code in $_resendCountdown seconds',
                      style: theme.textTheme.bodyMedium,
                      textAlign: TextAlign.center,
                    )
                  else
                    TextButton(
                      onPressed: _isLoading ? null : _sendOtp,
                      child: const Text('Resend Code'),
                    ),
                  const SizedBox(height: 8),

                  // Edit phone number button
                  TextButton(
                    onPressed: _isLoading ? null : _editPhoneNumber,
                    child: const Text('Change Phone Number'),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
