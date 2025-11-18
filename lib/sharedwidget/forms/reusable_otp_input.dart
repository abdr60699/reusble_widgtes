import 'package:flutter/material.dart';

/// ReusableOTPInput
///
/// A simple, accessible, and test-friendly OTP/PIN input widget.
/// Features:
/// - Fixed-length pin/otp inputs (configurable length)
/// - Auto-focus move to next field on input, backspace moves back
/// - Paste support (pastes into fields if length matches)
/// - onCompleted callback when all digits entered
/// - Optional obscure/secure mode for PINs
/// - Exposes a controller for programmatic set/clear

class ReusableOtpController {
  ReusableOtpController({String? initial}) : _value = initial ?? '';

  String _value;
  VoidCallback? _onChange;

  String get value => _value;

  set value(String v) {
    _value = v;
    _onChange?.call();
  }

  void clear() {
    _value = '';
    _onChange?.call();
  }

  void _attach(VoidCallback onChange) => _onChange = onChange;
  void _detach() => _onChange = null;
}

class ReusableOTPInput extends StatefulWidget {
  final int length;
  final double boxSize;
  final double boxSpacing;
  final TextStyle? textStyle;
  final bool obscureText;
  final Duration cursorBlinkDuration;
  final Color? boxColor;
  final Color? boxBorderColor;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onCompleted;
  final ReusableOtpController? controller;
  final InputDecoration? inputDecoration;

  const ReusableOTPInput({
    Key? key,
    this.length = 6,
    this.boxSize = 56,
    this.boxSpacing = 8,
    this.textStyle,
    this.obscureText = false,
    this.cursorBlinkDuration = const Duration(milliseconds: 500),
    this.boxColor,
    this.boxBorderColor,
    this.onChanged,
    this.onCompleted,
    this.controller,
    this.inputDecoration,
  })  : assert(length > 0 && length <= 8),
        super(key: key);

  @override
  State<ReusableOTPInput> createState() => _ReusableOTPInputState();
}

class _ReusableOTPInputState extends State<ReusableOTPInput> {
  late List<TextEditingController> _controllers;
  late List<FocusNode> _focusNodes;
  late ReusableOtpController _externalController;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(widget.length, (_) => TextEditingController());
    _focusNodes = List.generate(widget.length, (_) => FocusNode());

    _externalController = widget.controller ?? ReusableOtpController();
    _externalController._attach(_applyExternalValue);

    // If controller already has value, populate
    if (_externalController.value.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _applyExternalValue());
    }
  }

  @override
  void dispose() {
    for (final c in _controllers) {
      c.dispose();
    }
    for (final f in _focusNodes) {
      f.dispose();
    }
    _externalController._detach();
    super.dispose();
  }

  void _applyExternalValue() {
    final v = _externalController.value;
    for (int i = 0; i < widget.length; i++) {
      _controllers[i].text = i < v.length ? v[i] : '';
    }
    _notifyChanged();
  }

  void _setValueFromControllers() {
    final combined = _controllers.map((c) => c.text).join();
    _externalController._value = combined;
    widget.onChanged?.call(combined);
    if (combined.length == widget.length) widget.onCompleted?.call(combined);
  }

  void _notifyChanged() => _setValueFromControllers();

  void _handlePaste(String pasted) {
    final only = pasted.replaceAll(RegExp(r'[^0-9A-Za-z]'), '');
    if (only.length != widget.length) return; // ignore mismatched paste
    for (int i = 0; i < widget.length; i++) {
      _controllers[i].text = only[i];
    }
    setState(() {});
    _notifyChanged();
    _focusNodes.last.requestFocus();
  }

  Widget _buildBox(int index) {
    return SizedBox(
      width: widget.boxSize,
      height: widget.boxSize,
      child: TextField(
        controller: _controllers[index],
        focusNode: _focusNodes[index],
        keyboardType: TextInputType.text,
        textAlign: TextAlign.center,
        maxLength: 1,
        style: widget.textStyle ?? Theme.of(context).textTheme.titleLarge,
        obscureText: widget.obscureText,
        decoration: widget.inputDecoration ?? InputDecoration(counterText: ''),
        onChanged: (v) {
          if (v.isEmpty) {
            // moved back or cleared
            if (index > 0) {
              _focusNodes[index].unfocus();
              _focusNodes[index - 1].requestFocus();
            }
          } else {
            // only keep first char
            if (v.length > 1) {
              // likely a paste
              _handlePaste(v);
              return;
            }
            // move to next
            if (index + 1 < widget.length) {
              _focusNodes[index + 1].requestFocus();
            } else {
              _focusNodes[index].unfocus();
            }
          }
          _notifyChanged();
        },
        onSubmitted: (_) => _notifyChanged(),
        inputFormatters: [],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        for (final f in _focusNodes) {
          if (f.canRequestFocus) {
            _focusNodes[0].requestFocus();
            break;
          }
        }
      },
      child: Semantics(
        textField: true,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(widget.length * 2 - 1, (i) {
            if (i.isOdd) return SizedBox(width: widget.boxSpacing);
            final idx = i ~/ 2;
            return _buildBox(idx);
          }),
        ),
      ),
    );
  }
}
