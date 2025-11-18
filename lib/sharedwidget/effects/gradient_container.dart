import 'package:flutter/material.dart';

class ReusableGradientContainer extends StatelessWidget {
  final Widget? child;
  final Gradient gradient;
  final BorderRadius? borderRadius;
  final EdgeInsets padding;

  const ReusableGradientContainer({
    Key? key,
    this.child,
    required this.gradient,
    this.borderRadius,
    this.padding = const EdgeInsets.all(12),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: borderRadius ?? BorderRadius.circular(12),
      ),
      child: child,
    );
  }
}
