import 'package:flutter/material.dart';

/// Simple offline indicator that shows a banner when [isOffline] is true.
class ReusableOfflineIndicator extends StatelessWidget {
  final bool isOffline;
  final String message;
  final Color? backgroundColor;

  const ReusableOfflineIndicator({Key? key, required this.isOffline, this.message = 'You are offline', this.backgroundColor}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (!isOffline) return SizedBox.shrink();
    return Container(
      width: double.infinity,
      color: backgroundColor ?? Colors.redAccent,
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      child: SafeArea(
        child: Row(
          children: [
            Icon(Icons.signal_wifi_off, color: Colors.white),
            SizedBox(width: 8),
            Expanded(child: Text(message, style: TextStyle(color: Colors.white))),
          ],
        ),
      ),
    );
  }
}
