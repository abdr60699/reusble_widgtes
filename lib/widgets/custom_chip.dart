import 'package:flutter/material.dart';

class CustomChip extends StatelessWidget {
  final String label;
  final Color? backgroundColor;
  final Color? textColor;
  final IconData? icon;
  final VoidCallback? onDeleted;
  final VoidCallback? onTap;

  const CustomChip({
    Key? key,
    required this.label,
    this.backgroundColor,
    this.textColor,
    this.icon,
    this.onDeleted,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Chip(
        avatar: icon != null
            ? Icon(
                icon,
                size: 18,
                color: textColor ?? Colors.white,
              )
            : null,
        label: Text(
          label,
          style: TextStyle(
            color: textColor ?? Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
        deleteIcon: onDeleted != null
            ? Icon(
                Icons.close,
                size: 18,
                color: textColor ?? Colors.white,
              )
            : null,
        onDeleted: onDeleted,
        backgroundColor: backgroundColor ?? Colors.blue,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    );
  }
}
