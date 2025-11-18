// reusable_rotate_animation.dart
import 'package:flutter/material.dart';

class ReusableRotateAnimation extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final bool autoRotate;

  const ReusableRotateAnimation({Key? key, required this.child, this.duration = const Duration(seconds: 2), this.autoRotate = true}) : super(key: key);

  @override
  State<ReusableRotateAnimation> createState() => _ReusableRotateAnimationState();
}

class _ReusableRotateAnimationState extends State<ReusableRotateAnimation> with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: widget.duration);
    if (widget.autoRotate) _ctrl.repeat();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RotationTransition(turns: _ctrl, child: widget.child);
  }
}
