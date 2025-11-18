import 'package:flutter/material.dart';

class ReusableNotificationBadge extends StatelessWidget {
  final Widget child;
  final int count;
  final Color? badgeColor;
  final double top;
  final double right;

  const ReusableNotificationBadge({
    Key? key,
    required this.child,
    required this.count,
    this.badgeColor,
    this.top = -4,
    this.right = -4,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (count <= 0) return child;
    final display = count > 99 ? '99+' : count.toString();
    return Stack(
      clipBehavior: Clip.none,
      children: [
        child,
        Positioned(
          top: top,
          right: right,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: badgeColor ?? Colors.red,
              borderRadius: BorderRadius.circular(12),
            ),
            constraints: BoxConstraints(minWidth: 20, minHeight: 16),
            child: Center(
              child: Text(display, style: TextStyle(color: Colors.white, fontSize: 12)),
            ),
          ),
        ),
      ],
    );
  }
}
