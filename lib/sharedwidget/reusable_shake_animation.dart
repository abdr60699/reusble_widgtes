// reusable_shake_animation.dart
import 'package:flutter/material.dart';

/// Shake animation used for error indication.
class ReusableShakeAnimation extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final double offset;
  final bool shake;

  const ReusableShakeAnimation({
    Key? key,
    required this.child,
    this.duration = const Duration(milliseconds: 500),
    this.offset = 8.0,
    this.shake = false,
  }) : super(key: key);

  @override
  State<ReusableShakeAnimation> createState() => _ReusableShakeAnimationState();
}

class _ReusableShakeAnimationState extends State<ReusableShakeAnimation> with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: widget.duration);
    _anim = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0, end: -widget.offset), weight: 10),
      TweenSequenceItem(tween: Tween(begin: -widget.offset, end: widget.offset), weight: 20),
      TweenSequenceItem(tween: Tween(begin: widget.offset, end: -widget.offset), weight: 20),
      TweenSequenceItem(tween: Tween(begin: -widget.offset, end: widget.offset / 2), weight: 20),
      TweenSequenceItem(tween: Tween(begin: widget.offset / 2, end: 0), weight: 30),
    ]).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOut));

    if (widget.shake) {
      _ctrl.forward();
    }
  }

  @override
  void didUpdateWidget(covariant ReusableShakeAnimation oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.shake && !oldWidget.shake) {
      _ctrl.forward(from: 0);
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
        return Transform.translate(offset: Offset(_anim.value, 0), child: child);
      },
      child: widget.child,
    );
  }
}
