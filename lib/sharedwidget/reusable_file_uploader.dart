
// reusable_file_uploader.dart
// File/image uploader widget (pick via provided callback for portability)
import 'dart:typed_data';
import 'package:flutter/material.dart';

typedef PickFileCallback = Future<PickedFileResult?> Function();
typedef UploadCallback = Future<String?> Function(PickedFileResult file);

class PickedFileResult {
  final Uint8List bytes;
  final String filename;
  final String? mimeType;
  PickedFileResult({required this.bytes, required this.filename, this.mimeType});
}

class ReusableFileUploader extends StatefulWidget {
  final PickFileCallback? pickFile; // if null, uploader will show a message instructing integrator to provide a function
  final UploadCallback? upload;
  final String buttonLabel;

  const ReusableFileUploader({
    Key? key,
    this.pickFile,
    this.upload,
    this.buttonLabel = 'Select file',
  }) : super(key: key);

  @override
  State<ReusableFileUploader> createState() => _ReusableFileUploaderState();
}

class _ReusableFileUploaderState extends State<ReusableFileUploader> {
  PickedFileResult? _picked;
  String? _uploadedUrl;
  bool _loading = false;

  Future<void> _onPick() async {
    if (widget.pickFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('No file picker provided.')));
      return;
    }
    final res = await widget.pickFile!();
    if (res == null) return;
    setState(() => _picked = res);
  }

  Future<void> _onUpload() async {
    if (_picked == null || widget.upload == null) return;
    setState(() => _loading = true);
    final url = await widget.upload!(_picked!);
    setState(() {
      _uploadedUrl = url;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(children: [
          ElevatedButton.icon(
            onPressed: _onPick,
            icon: const Icon(Icons.attach_file),
            label: Text(widget.buttonLabel),
          ),
          const SizedBox(width: 12),
          if (_picked != null) Text(_picked!.filename),
        ]),
        const SizedBox(height: 8),
        if (_picked != null)
          Row(
            children: [
              ElevatedButton(
                onPressed: _loading ? null : _onUpload,
                child: _loading ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2)) : const Text('Upload'),
              ),
              const SizedBox(width: 12),
              if (_uploadedUrl != null) Expanded(child: Text('Uploaded: $_uploadedUrl', overflow: TextOverflow.ellipsis)),
            ],
          ),
        if (widget.pickFile == null) Padding(
          padding: const EdgeInsets.only(top:8.0),
          child: Text('Provide a pickFile callback to enable picking (e.g., using image_picker or file_picker).', style: Theme.of(context).textTheme.bodySmall),
        )
      ],
    );
  }
}
