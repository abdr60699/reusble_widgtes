import 'dart:ui';
import 'package:flutter/material.dart';

class ReusableGlassMorphism extends StatelessWidget {
  final double blur;
  final Color tint;
  final Widget? child;
  final BorderRadius? borderRadius;
  final EdgeInsets padding;

  const ReusableGlassMorphism({
    Key? key,
    this.blur = 10,
    this.tint = const Color.fromRGBO(255,255,255,0.1),
    this.child,
    this.borderRadius,
    this.padding = const EdgeInsets.all(12),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: borderRadius ?? BorderRadius.circular(12),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
        child: Container(
          padding: padding,
          decoration: BoxDecoration(
            color: tint,
            borderRadius: borderRadius ?? BorderRadius.circular(12),
            border: Border.all(color: Colors.white.withOpacity(0.12)),
          ),
          child: child,
        ),
      ),
    );
  }
}
