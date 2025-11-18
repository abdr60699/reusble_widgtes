import 'package:flutter/material.dart';

class ReusableConfirmationDialog {
  static Future<bool?> showConfirm({
    required BuildContext context,
    String title = 'Confirm',
    required String message,
    String confirmText = 'Yes',
    String cancelText = 'No',
  }) {
    return showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(false), child: Text(cancelText)),
          ElevatedButton(onPressed: () => Navigator.of(context).pop(true), child: Text(confirmText)),
        ],
      ),
    );
  }
}
