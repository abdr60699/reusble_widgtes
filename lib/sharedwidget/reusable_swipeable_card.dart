// reusable_swipeable_card.dart
import 'package:flutter/material.dart';

/// Simple swipeable card (left/right) with callbacks and optional thresholds.
class ReusableSwipeableCard extends StatefulWidget {
  final Widget child;
  final void Function()? onSwipeLeft;
  final void Function()? onSwipeRight;
  final double threshold;

  const ReusableSwipeableCard({
    Key? key,
    required this.child,
    this.onSwipeLeft,
    this.onSwipeRight,
    this.threshold = 0.25,
  }) : super(key: key);

  @override
  State<ReusableSwipeableCard> createState() => _ReusableSwipeableCardState();
}

class _ReusableSwipeableCardState extends State<ReusableSwipeableCard> with SingleTickerProviderStateMixin {
  Offset _drag = Offset.zero;
  late final AnimationController _ctrl;
  late Animation<Offset> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 300));
    _anim = Tween<Offset>(begin: Offset.zero, end: Offset.zero).animate(_ctrl);
  }

  void _runResetAnimation() {
    _anim = Tween<Offset>(begin: _drag, end: Offset.zero).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOut));
    _ctrl.forward(from: 0).then((_) {
      setState(() => _drag = Offset.zero);
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanUpdate: (details) {
        setState(() => _drag += details.delta);
      },
      onPanEnd: (details) {
        final width = context.size?.width ?? MediaQuery.of(context).size.width;
        final dx = _drag.dx.abs();
        if (dx > width * widget.threshold) {
          if (_drag.dx > 0) {
            widget.onSwipeRight?.call();
          } else {
            widget.onSwipeLeft?.call();
          }
          // animate out
          _anim = Tween<Offset>(begin: _drag, end: Offset(_drag.dx.sign * width, 0)).animate(_ctrl);
          _ctrl.forward(from: 0).then((_) {
            // reset
            setState(() => _drag = Offset.zero);
          });
        } else {
          _runResetAnimation();
        }
      },
      child: AnimatedBuilder(
        animation: _anim,
        builder: (context, child) {
          final off = _anim.value + _drag;
          final rot = off.dx / (context.size?.width ?? MediaQuery.of(context).size.width) * 0.08;
          return Transform.translate(
            offset: off,
            child: Transform.rotate(angle: rot, child: child),
          );
        },
        child: widget.child,
      ),
    );
  }
}
