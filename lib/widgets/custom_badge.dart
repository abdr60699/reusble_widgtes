import 'package:flutter/material.dart';

class CustomBadge extends StatelessWidget {
  final Widget child;
  final String? label;
  final int? count;
  final Color? badgeColor;
  final Color? textColor;
  final bool showBadge;

  const CustomBadge({
    Key? key,
    required this.child,
    this.label,
    this.count,
    this.badgeColor,
    this.textColor,
    this.showBadge = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        child,
        if (showBadge && (label != null || count != null))
          Positioned(
            right: -8,
            top: -8,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: badgeColor ?? Colors.red,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              constraints: const BoxConstraints(
                minWidth: 20,
                minHeight: 20,
              ),
              child: Center(
                child: Text(
                  label ?? (count != null ? (count! > 99 ? '99+' : count.toString()) : ''),
                  style: TextStyle(
                    color: textColor ?? Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
