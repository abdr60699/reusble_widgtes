import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

/// A reusable QR code generator widget.
///
/// Generates QR codes from text/URLs with customizable appearance.
///
/// Example:
/// ```dart
/// ReusableQRGenerator(
///   data: 'https://example.com',
///   size: 200,
///   foregroundColor: Colors.black,
///   backgroundColor: Colors.white,
/// )
/// ```
class ReusableQRGenerator extends StatelessWidget {
  /// Data to encode in QR code
  final String data;

  /// Size of the QR code
  final double size;

  /// Foreground color (QR code color)
  final Color foregroundColor;

  /// Background color
  final Color backgroundColor;

  /// Whether to show the data text below QR code
  final bool showDataText;

  /// Optional logo to display in center
  final ImageProvider? embeddedImage;

  /// Size of embedded logo
  final double embeddedImageSize;

  const ReusableQRGenerator({
    super.key,
    required this.data,
    this.size = 200.0,
    this.foregroundColor = Colors.black,
    this.backgroundColor = Colors.white,
    this.showDataText = false,
    this.embeddedImage,
    this.embeddedImageSize = 40.0,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(12),
          ),
          child: QrImageView(
            data: data,
            version: QrVersions.auto,
            size: size,
            gapless: false,
            eyeStyle: QrEyeStyle(
              eyeShape: QrEyeShape.square,
              color: foregroundColor,
            ),
            dataModuleStyle: QrDataModuleStyle(
              dataModuleShape: QrDataModuleShape.square,
              color: foregroundColor,
            ),
            embeddedImage: embeddedImage,
            embeddedImageStyle: QrEmbeddedImageStyle(
              size: Size(embeddedImageSize, embeddedImageSize),
            ),
          ),
        ),
        if (showDataText) ...[
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceVariant,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              data,
              style: Theme.of(context).textTheme.bodySmall,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ],
    );
  }
}
