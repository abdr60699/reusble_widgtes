import 'package:flutter/material.dart';

class ReusableDialog {
  static Future<T?> show<T>({
    required BuildContext context,
    Widget? title,
    required Widget content,
    List<Widget>? actions,
    bool barrierDismissible = true,
  }) {
    return showDialog<T>(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (_) => AlertDialog(
        title: title,
        content: content,
        actions: actions,
      ),
    );
  }
}
