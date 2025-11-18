import 'dart:ui';
import 'package:flutter/material.dart';

class ReusableBlurredBackground extends StatelessWidget {
  final Widget child;
  final ImageProvider background;
  final double blur;
  final Color? overlayColor;

  const ReusableBlurredBackground({Key? key, required this.child, required this.background, this.blur = 6.0, this.overlayColor}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Image(image: background, fit: BoxFit.cover),
        BackdropFilter(filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur), child: Container(color: overlayColor ?? Colors.black.withOpacity(0.25))),
        child,
      ],
    );
  }
}
