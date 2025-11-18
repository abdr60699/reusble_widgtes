
// reusable_progress_indicator.dart
// Simple reusable progress indicator widgets (linear & circular).
import 'package:flutter/material.dart';

/// A small wrapper that shows either a linear or circular progress indicator.
/// Supports determinate (value 0..1) and indeterminate (value == null) modes.
class ReusableProgressIndicator extends StatelessWidget {
  final double? value; // null -> indeterminate
  final bool circular;
  final double size; // applies to circular
  final double height; // applies to linear
  final Color? color;
  final Color? backgroundColor;

  const ReusableProgressIndicator({
    Key? key,
    this.value,
    this.circular = false,
    this.size = 40,
    this.height = 6,
    this.color,
    this.backgroundColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final mainColor = color ?? Theme.of(context).colorScheme.primary;
    final bg = backgroundColor ?? Theme.of(context).colorScheme.surfaceVariant;

    if (circular) {
      return SizedBox(
        width: size,
        height: size,
        child: value == null
            ? CircularProgressIndicator(strokeWidth: 3, color: mainColor)
            : CircularProgressIndicator(value: value, strokeWidth: 3, color: mainColor),
      );
    } else {
      return SizedBox(
        height: height,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(height / 2),
          child: LinearProgressIndicator(
            value: value,
            color: mainColor,
            backgroundColor: bg,
            minHeight: height,
          ),
        ),
      );
    }
  }
}
