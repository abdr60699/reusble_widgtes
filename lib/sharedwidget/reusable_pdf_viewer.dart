
// reusable_pdf_viewer.dart
import 'package:flutter/material.dart';
import 'package:pdfx/pdfx.dart';

/// Simple PDF viewer using pdfx package.
class ReusablePdfViewer extends StatefulWidget {
  final String assetOrUrl; // either asset path or network url
  final bool fromAsset;

  const ReusablePdfViewer({Key? key, required this.assetOrUrl, this.fromAsset = true}) : super(key: key);

  @override
  State<ReusablePdfViewer> createState() => _ReusablePdfViewerState();
}

class _ReusablePdfViewerState extends State<ReusablePdfViewer> {
  late PdfControllerPinch _controller;

  @override
  void initState() {
    super.initState();
    _controller = PdfControllerPinch(
      document: widget.fromAsset
        ? PdfDocument.openAsset(widget.assetOrUrl)
        : PdfDocument.openData(Uri.parse(widget.assetOrUrl).readAsBytes()),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PdfViewPinch(controller: _controller);
  }
}
