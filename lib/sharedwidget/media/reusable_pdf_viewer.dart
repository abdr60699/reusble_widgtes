import 'package:flutter/material.dart';

/// A reusable PDF viewer widget.
///
/// **NOTE**: This widget requires the `pdfx` package.
/// Uncomment `pdfx: ^2.6.0` in pubspec.yaml to use this widget.
///
/// Example:
/// ```dart
/// ReusablePdfViewer(
///   assetPath: 'assets/documents/sample.pdf',
/// )
/// // Or from file path
/// ReusablePdfViewer(
///   filePath: '/path/to/document.pdf',
/// )
/// ```
class ReusablePdfViewer extends StatefulWidget {
  /// Path to PDF file (use this OR assetPath)
  final String? filePath;

  /// Asset path to PDF (use this OR filePath)
  final String? assetPath;

  /// Whether to show page indicator
  final bool showPageIndicator;

  const ReusablePdfViewer({
    super.key,
    this.filePath,
    this.assetPath,
    this.showPageIndicator = true,
  }) : assert(
          filePath != null || assetPath != null,
          'Either filePath or assetPath must be provided',
        );

  @override
  State<ReusablePdfViewer> createState() => _ReusablePdfViewerState();
}

class _ReusablePdfViewerState extends State<ReusablePdfViewer> {
  @override
  Widget build(BuildContext context) {
    // This is a placeholder implementation
    // To use this widget, uncomment pdfx package in pubspec.yaml
    // and implement the actual PDF viewing functionality

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.picture_as_pdf,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'PDF Viewer',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              'To use this widget, uncomment pdfx package in pubspec.yaml',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey[600],
                  ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            widget.filePath ?? widget.assetPath ?? '',
            style: Theme.of(context).textTheme.bodySmall,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );

    /*
    // Actual implementation when pdfx is enabled:

    late PdfControllerPinch _controller;

    @override
    void initState() {
      super.initState();
      _controller = widget.assetPath != null
          ? PdfControllerPinch(
              document: PdfDocument.openAsset(widget.assetPath!),
            )
          : PdfControllerPinch(
              document: PdfDocument.openFile(widget.filePath!),
            );
    }

    @override
    void dispose() {
      _controller.dispose();
      super.dispose();
    }

    @override
    Widget build(BuildContext context) {
      return PdfViewPinch(
        controller: _controller,
      );
    }
    */
  }
}
