
// reusable_pdf_viewer.dart
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:pdfx/pdfx.dart';
import 'package:http/http.dart' as http;

/// Simple PDF viewer using pdfx package.
///
/// Note: Add 'http: ^1.1.0' to your pubspec.yaml dependencies
class ReusablePdfViewer extends StatefulWidget {
  final String assetOrUrl; // either asset path or network url
  final bool fromAsset;

  const ReusablePdfViewer({
    Key? key,
    required this.assetOrUrl,
    this.fromAsset = true,
  }) : super(key: key);

  @override
  State<ReusablePdfViewer> createState() => _ReusablePdfViewerState();
}

class _ReusablePdfViewerState extends State<ReusablePdfViewer> {
  late PdfControllerPinch _controller;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _initializePdf();
  }

  Future<void> _initializePdf() async {
    try {
      if (widget.fromAsset) {
        _controller = PdfControllerPinch(
          document: PdfDocument.openAsset(widget.assetOrUrl),
        );
      } else {
        _controller = PdfControllerPinch(
          document: PdfDocument.openData(
            _fetchPdfBytes(widget.assetOrUrl),
          ),
        );
      }
      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Failed to load PDF: $e';
        _isLoading = false;
      });
    }
  }

  Future<Uint8List> _fetchPdfBytes(String url) async {
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      return response.bodyBytes;
    } else {
      throw Exception('Failed to load PDF from URL: ${response.statusCode}');
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            _error!,
            style: const TextStyle(color: Colors.red),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    return PdfViewPinch(controller: _controller);
  }
}