import 'package:flutter/material.dart';
import 'reusable_dialog.dart';
import 'reusable_confirmation_dialog.dart';
import 'reusable_banner.dart';
import 'reusable_status_banner.dart';
import 'reusable_tooltip.dart';
import 'reusable_notification_badge.dart';

// Simple bottom sheet wrapper
class ReusableBottomSheet {
  static Future<T?> show<T>({
    required BuildContext context,
    required Widget child,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      builder: (_) => child,
    );
  }
}

// Simple alert dialog wrapper
class ReusableAlertDialog {
  static Future<void> showOk({
    required BuildContext context,
    String title = 'Alert',
    required String message,
  }) {
    return showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }
}

void main() {
  runApp(const DemoApp());
}

class DemoApp extends StatelessWidget {
  const DemoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Reusable Widgets Demo',
      home: DemoHome(),
    );
  }
}

class DemoHome extends StatefulWidget {
  @override
  State<DemoHome> createState() => _DemoHomeState();
}

class _DemoHomeState extends State<DemoHome> {
  bool showStatus = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Reusable Widgets Demo')),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          ElevatedButton(
            child: Text('Show Reusable Dialog'),
            onPressed: () {
              ReusableDialog.show(
                context: context,
                title: Text('Hello'),
                content: Text('This is a reusable dialog'),
                actions: [
                  TextButton(onPressed: () => Navigator.of(context).pop(), child: Text('Close'))
                ],
              );
            },
          ),
          ElevatedButton(
            child: Text('Show Bottom Sheet'),
            onPressed: () {
              ReusableBottomSheet.show(
                context: context,
                child: Container(
                  padding: EdgeInsets.all(16),
                  child: Text('Bottom sheet content'),
                ),
              );
            },
          ),
          ElevatedButton(
            child: Text('Show Alert Dialog'),
            onPressed: () {
              ReusableAlertDialog.showOk(context: context, message: 'Simple alert');
            },
          ),
          ElevatedButton(
            child: Text('Show Confirmation'),
            onPressed: () async {
              final res = await ReusableConfirmationDialog.showConfirm(context: context, message: 'Are you sure?');
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Result: \$res')));
            },
          ),
          ElevatedButton(
            child: Text('Show Popup'),
            onPressed: () {
              ReusablePopup.show(context, child: Padding(
                padding: EdgeInsets.all(8),
                child: Text('Popup message'),
              ), offset: Offset(100, 200));
            },
          ),
          ElevatedButton(
            child: Text('Show Flushbar (snack)'),
            onPressed: () {
              ReusableFlushbar.show(context, title: 'Heads up', message: 'This is a flushbar alternative');
            },
          ),
          SizedBox(height: 12),
          Center(
            child: ReusableNotificationBadge(
              count: 7,
              child: Icon(Icons.mail, size: 48),
            ),
          ),
          SizedBox(height: 12),
          ElevatedButton(
            child: Text('Toggle Status Banner'),
            onPressed: () => setState(() => showStatus = !showStatus),
          ),
          SizedBox(height: 12),
          if (showStatus)
            ReusableStatusBanner(
              message: 'You have unsynced changes',
              icon: Icons.sync,
              dismissible: true,
              onDismiss: () => setState(() => showStatus = false),
            ),
        ],
      ),
    );
  }
}
