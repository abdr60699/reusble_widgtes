import 'package:flutter/material.dart';

class ReusablePageIndicator extends StatelessWidget {
  final int count;
  final int currentIndex;
  final double size;
  final Color? activeColor;
  final Color? inactiveColor;

  const ReusablePageIndicator({
    super.key,
    required this.count,
    required this.currentIndex,
    this.size = 10,
    this.activeColor,
    this.inactiveColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(count, (i) {
        final isActive = i == currentIndex;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: isActive ? size * 1.6 : size,
          height: size,
          decoration: BoxDecoration(
            color: isActive
                ? activeColor ?? Theme.of(context).primaryColor
                : inactiveColor ?? Colors.grey,
            borderRadius: BorderRadius.circular(20),
          ),
        );
      }),
    );
  }
}
