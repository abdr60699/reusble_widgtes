import 'package:flutter/material.dart';

class ReusableToolTip extends StatelessWidget {
  final Widget child;
  final String message;
  final Duration showDuration;
  final TextStyle? textStyle;

  const ReusableToolTip({
    Key? key,
    required this.child,
    required this.message,
    this.showDuration = const Duration(seconds: 2),
    this.textStyle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: message,
      waitDuration: Duration(milliseconds: 200),
      showDuration: showDuration,
      child: child,
      textStyle: textStyle,
    );
  }
}
