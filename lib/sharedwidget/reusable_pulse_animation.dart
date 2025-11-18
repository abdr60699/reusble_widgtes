// reusable_pulse_animation.dart
import 'package:flutter/material.dart';

/// Simple pulse (heartbeat) animation wrapper
class ReusablePulseAnimation extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final double minScale;
  final double maxScale;
  final bool autoStart;

  const ReusablePulseAnimation({
    Key? key,
    required this.child,
    this.duration = const Duration(seconds: 1),
    this.minScale = 0.95,
    this.maxScale = 1.05,
    this.autoStart = true,
  }) : super(key: key);

  @override
  State<ReusablePulseAnimation> createState() => _ReusablePulseAnimationState();
}

class _ReusablePulseAnimationState extends State<ReusablePulseAnimation> with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: widget.duration);
    _anim = Tween<double>(begin: widget.minScale, end: widget.maxScale).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut));
    if (widget.autoStart) {
      _ctrl.repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _anim,
      builder: (context, child) {
        return Transform.scale(scale: _anim.value, child: child);
      },
      child: widget.child,
    );
  }
}
