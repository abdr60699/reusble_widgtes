import 'package:flutter/material.dart';

class ReusablePopup {
  static void show(
    BuildContext context, {
    required Widget child,
    Offset offset = Offset.zero,
  }) {
    final overlay = Overlay.of(context);
    if (overlay == null) return;

    final entry = OverlayEntry(builder: (context) {
      return Positioned(
        left: offset.dx,
        top: offset.dy,
        child: Material(
          elevation: 6,
          child: child,
        ),
      );
    });

    overlay.insert(entry);
    // auto dismiss after 3s
    Future.delayed(Duration(seconds: 3), () => entry.remove());
  }
}
