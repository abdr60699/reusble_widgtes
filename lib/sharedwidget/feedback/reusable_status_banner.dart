import 'package:flutter/material.dart';

class ReusableFlushbar {
  static void show(
    BuildContext context, {
    required String message,
    String? title,
    Duration duration = const Duration(seconds: 3),
    VoidCallback? onTap,
    Color? backgroundColor,
  }) {
    final scaffold = ScaffoldMessenger.of(context);
    final snack = SnackBar(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null) Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
          Text(message),
        ],
      ),
      duration: duration,
      behavior: SnackBarBehavior.floating,
      onVisible: () {},
      action: onTap != null ? SnackBarAction(label: 'Open', onPressed: onTap) : null,
      backgroundColor: backgroundColor,
    );
    scaffold.showSnackBar(snack);
  }
}
