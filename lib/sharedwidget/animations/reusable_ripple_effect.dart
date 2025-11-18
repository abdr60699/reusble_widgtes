// reusable_ripple_effect.dart
import 'package:flutter/material.dart';

/// Custom ripple using InkWell but with adjustable radius and color
class ReusableRippleEffect extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;
  final BorderRadius? borderRadius;
  final Color? rippleColor;
  final double? radius;

  const ReusableRippleEffect({
    Key? key,
    required this.child,
    this.onTap,
    this.borderRadius,
    this.rippleColor,
    this.radius,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: borderRadius,
        splashColor: rippleColor ?? Theme.of(context).splashColor,
        radius: radius,
        child: child,
      ),
    );
  }
}
