// reusable_draggable_sheet.dart
import 'package:flutter/material.dart';

/// A simple wrapper around showModalBottomSheet with draggable behavior.
class ReusableDraggableSheet {
  static Future<T?> show<T>({
    required BuildContext context,
    required Widget Function(BuildContext, ScrollController) builder,
    double initialChildSize = 0.5,
    double minChildSize = 0.25,
    double maxChildSize = 0.95,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: true,
      builder: (ctx) {
        return DraggableScrollableSheet(
          initialChildSize: initialChildSize,
          minChildSize: minChildSize,
          maxChildSize: maxChildSize,
          expand: false,
          builder: (context, controller) {
            return builder(context, controller);
          },
        );
      },
    );
  }
}
