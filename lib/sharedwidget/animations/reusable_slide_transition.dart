// reusable_slide_transition.dart
import 'package:flutter/material.dart';

/// Slide transition wrapper to animate entry/exit
class ReusableSlideTransition extends StatelessWidget {
  final Widget child;
  final Animation<double> animation;
  final AxisDirection direction;

  const ReusableSlideTransition({
    Key? key,
    required this.child,
    required this.animation,
    this.direction = AxisDirection.left,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Offset begin;
    switch (direction) {
      case AxisDirection.up:
        begin = const Offset(0, 1);
        break;
      case AxisDirection.down:
        begin = const Offset(0, -1);
        break;
      case AxisDirection.left:
        begin = const Offset(1, 0);
        break;
      case AxisDirection.right:
        begin = const Offset(-1, 0);
        break;
    }
    final offsetAnim = Tween<Offset>(begin: begin, end: Offset.zero).animate(CurvedAnimation(parent: animation, curve: Curves.easeOut));
    return SlideTransition(position: offsetAnim, child: child);
  }
}
