import 'package:flutter/material.dart';

/// ReusableVersionChecker: lightweight UI to prompt user to update the app.
class ReusableVersionChecker extends StatelessWidget {
  final String currentVersion;
  final String latestVersion;
  final VoidCallback? onUpdate;
  final String title;
  final String message;

  const ReusableVersionChecker({Key? key, required this.currentVersion, required this.latestVersion, this.onUpdate, this.title = 'Update available', this.message = 'A new version is available.'}) : super(key: key);

  bool get needsUpdate {
    try {
      final cur = currentVersion.split('.').map(int.parse).toList();
      final lat = latestVersion.split('.').map(int.parse).toList();
      for (var i=0;i<cur.length && i<lat.length;i++) {
        if (lat[i] > cur[i]) return true;
        if (lat[i] < cur[i]) return false;
      }
      return lat.length > cur.length;
    } catch (e) {
      return currentVersion != latestVersion;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!needsUpdate) return SizedBox.shrink();
    return Card(
      color: Colors.orange[50],
      child: ListTile(
        leading: Icon(Icons.system_update, color: Colors.orange),
        title: Text(title),
        subtitle: Text(message),
        trailing: ElevatedButton(onPressed: onUpdate, child: Text('Update')),
      ),
    );
  }
}
