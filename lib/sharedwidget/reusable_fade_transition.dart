// reusable_fade_transition.dart
import 'package:flutter/material.dart';

class ReusableFadeTransition extends StatelessWidget {
  final Widget child;
  final Animation<double> animation;

  const ReusableFadeTransition({Key? key, required this.child, required this.animation}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FadeTransition(opacity: animation, child: child);
  }
}
