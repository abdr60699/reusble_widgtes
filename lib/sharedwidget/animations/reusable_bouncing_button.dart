// reusable_bouncing_button.dart
import 'package:flutter/material.dart';

/// A button that bounces slightly when pressed.
class ReusableBouncingButton extends StatefulWidget {
  final Widget child;
  final VoidCallback? onPressed;
  final Duration duration;
  final double scaleDown;
  final BorderRadius? borderRadius;

  const ReusableBouncingButton({
    Key? key,
    required this.child,
    this.onPressed,
    this.duration = const Duration(milliseconds: 120),
    this.scaleDown = 0.92,
    this.borderRadius,
  }) : super(key: key);

  @override
  State<ReusableBouncingButton> createState() => _ReusableBouncingButtonState();
}

class _ReusableBouncingButtonState extends State<ReusableBouncingButton> with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: widget.duration);
    _anim = Tween<double>(begin: 1.0, end: widget.scaleDown).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOut));
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _handleTapDown(_) {
    _ctrl.forward();
  }

  void _handleTapUp(_) async {
    await _ctrl.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: widget.onPressed != null ? _handleTapDown : null,
      onTapUp: widget.onPressed != null ? _handleTapUp : null,
      onTapCancel: widget.onPressed != null ? () => _ctrl.reverse() : null,
      onTap: widget.onPressed,
      child: AnimatedBuilder(
        animation: _anim,
        builder: (context, child) {
          return Transform.scale(
            scale: _anim.value,
            child: Container(
              decoration: BoxDecoration(borderRadius: widget.borderRadius),
              child: child,
            ),
          );
        },
        child: widget.child,
      ),
    );
  }
}
