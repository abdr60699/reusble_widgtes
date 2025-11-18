
// reusable_qr_generator.dart
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class ReusableQRGenerator extends StatelessWidget {
  final String data;
  final double size;
  final Color? foregroundColor;
  final Color? backgroundColor;

  const ReusableQRGenerator({
    Key? key,
    required this.data,
    this.size = 200,
    this.foregroundColor,
    this.backgroundColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: backgroundColor ?? Colors.white,
      padding: const EdgeInsets.all(8),
      child: QrImageView(
        data: data,
        size: size,
        eyeStyle: QrEyeStyle(
          eyeShape: QrEyeShape.square,
          color: foregroundColor ?? Theme.of(context).colorScheme.onSurface,
        ),
        dataModuleStyle: QrDataModuleStyle(
          dataModuleShape: QrDataModuleShape.square,
          color: foregroundColor ?? Theme.of(context).colorScheme.onSurface,
        ),
      ),
    );
  }
}
