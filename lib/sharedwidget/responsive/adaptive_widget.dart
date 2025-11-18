import 'package:flutter/material.dart';
import 'dart:io' show Platform;

class ReusableAdaptiveWidget extends StatelessWidget {
  final Widget mobile;
  final Widget desktop;
  final Widget web;

  const ReusableAdaptiveWidget({Key? key, required this.mobile, required this.desktop, required this.web}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    try {
      if (Platform.isAndroid || Platform.isIOS) return mobile;
      if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) return desktop;
    } catch (e) {
      // fallback for web where Platform may not be available
    }
    return web;
  }
}
