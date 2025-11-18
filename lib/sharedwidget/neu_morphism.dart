import 'package:flutter/material.dart';

class ReusableNeuMorphism extends StatelessWidget {
  final Widget child;
  final double depth;
  final Color? backgroundColor;
  final BorderRadius? borderRadius;
  final EdgeInsets padding;

  const ReusableNeuMorphism({
    Key? key,
    required this.child,
    this.depth = 6.0,
    this.backgroundColor,
    this.borderRadius,
    this.padding = const EdgeInsets.all(12),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bg = backgroundColor ?? Theme.of(context).scaffoldBackgroundColor;
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: bg,
        borderRadius: borderRadius ?? BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.12), offset: Offset(depth, depth), blurRadius: depth),
          BoxShadow(color: Colors.white.withOpacity(0.7), offset: Offset(-depth/2, -depth/2), blurRadius: depth/2),
        ],
      ),
      child: child,
    );
  }
}
