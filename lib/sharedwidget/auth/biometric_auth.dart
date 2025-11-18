import 'package:flutter/material.dart';

/// BiometricAuth UI stub: UI only; actual biometric logic should integrate with `local_auth` plugin.
class ReusableBiometricAuth extends StatelessWidget {
  final String title;
  final String subtitle;
  final VoidCallback? onAuthenticate;
  final VoidCallback? onCancel;

  const ReusableBiometricAuth({Key? key, this.title = 'Biometric Authentication', this.subtitle = 'Use fingerprint or face to continue.', this.onAuthenticate, this.onCancel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(child: Padding(padding: EdgeInsets.all(12), child: Column(mainAxisSize: MainAxisSize.min, children: [
      ListTile(leading: Icon(Icons.fingerprint, size: 40), title: Text(title), subtitle: Text(subtitle)),
      SizedBox(height: 8),
      Row(mainAxisAlignment: MainAxisAlignment.end, children: [
        TextButton(onPressed: onCancel, child: Text('Cancel')),
        ElevatedButton(onPressed: onAuthenticate, child: Text('Authenticate')),
      ])
    ])));
  }
}
