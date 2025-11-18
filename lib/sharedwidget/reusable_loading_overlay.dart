
// reusable_loading_overlay.dart
import 'package:flutter/material.dart';

class ReusableLoadingOverlay extends StatelessWidget {
  final bool loading;
  final Widget child;
  final String? message;

  const ReusableLoadingOverlay({
    Key? key,
    required this.loading,
    required this.child,
    this.message,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        if (loading)
          Positioned.fill(
            child: Container(
              color: Colors.black.withOpacity(0.45),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const CircularProgressIndicator(),
                    if (message != null) ...[
                      const SizedBox(height: 12),
                      Text(message!, style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.white)),
                    ],
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }
}
