import 'package:flutter/material.dart';

/// Permission request UI: shows an explanation and buttons to open settings or continue.
class ReusablePermissionRequest extends StatelessWidget {
  final String title;
  final String description;
  final VoidCallback? onGrant;
  final VoidCallback? onOpenSettings;

  const ReusablePermissionRequest({Key? key, this.title = 'Permission required', this.description = 'This feature needs permission to continue.', this.onGrant, this.onOpenSettings}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
          SizedBox(height: 8),
          Text(description),
          SizedBox(height: 12),
          Row(mainAxisAlignment: MainAxisAlignment.end, children: [
            TextButton(onPressed: onOpenSettings, child: Text('Open settings')),
            ElevatedButton(onPressed: onGrant, child: Text('Grant')),
          ])
        ]),
      ),
    );
  }
}
