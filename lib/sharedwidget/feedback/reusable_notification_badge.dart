import 'package:flutter/material.dart';

class ReusableStatusBanner extends StatelessWidget {
  final String message;
  final IconData? icon;
  final Color? backgroundColor;
  final bool dismissible;
  final VoidCallback? onDismiss;

  const ReusableStatusBanner({
    Key? key,
    required this.message,
    this.icon,
    this.backgroundColor,
    this.dismissible = false,
    this.onDismiss,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 2,
      color: backgroundColor ?? Theme.of(context).colorScheme.primary,
      child: SafeArea(
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
          child: Row(
            children: [
              if (icon != null) Icon(icon, color: Colors.white),
              SizedBox(width: icon != null ? 12 : 0),
              Expanded(child: Text(message, style: TextStyle(color: Colors.white))),
              if (dismissible)
                IconButton(
                  icon: Icon(Icons.close, color: Colors.white),
                  onPressed: onDismiss,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
