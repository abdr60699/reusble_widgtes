import 'package:flutter/material.dart';

class ReusableFloatingActionButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;
  final Color? backgroundColor;
  final String? tooltip;

  const ReusableFloatingActionButton({
    super.key,
    required this.icon,
    required this.onPressed,
    this.backgroundColor,
    this.tooltip,
  });

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      tooltip: tooltip,
      backgroundColor: backgroundColor,
      onPressed: onPressed,
      child: Icon(icon),
    );
  }
}
