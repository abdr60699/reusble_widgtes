
// reusable_qr_scanner.dart
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

/// QR / Barcode scanner using mobile_scanner
class ReusableQRScanner extends StatelessWidget {
  final void Function(String) onDetect;
  final bool allowDuplicates;

  const ReusableQRScanner({Key? key, required this.onDetect, this.allowDuplicates = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MobileScanner(
      onDetect: (capture) {
        final List<Barcode> barcodes = capture.barcodes;
        for (final b in barcodes) {
          final raw = b.rawValue ?? '';
          if (raw.isEmpty) continue;
          onDetect(raw);
          if (!allowDuplicates) break;
        }
      },
    );
  }
}
