
// reusable_image_picker.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

/// Wrapper around image_picker for gallery/camera selection.
class ReusableImagePicker extends StatefulWidget {
  final void Function(File? file) onPicked;
  final ImageSource preferredSource;

  const ReusableImagePicker({Key? key, required this.onPicked, this.preferredSource = ImageSource.gallery}) : super(key: key);

  @override
  State<ReusableImagePicker> createState() => _ReusableImagePickerState();
}

class _ReusableImagePickerState extends State<ReusableImagePicker> {
  final ImagePicker _picker = ImagePicker();
  File? _last;

  Future<void> _pick(ImageSource src) async {
    final x = await _picker.pickImage(source: src, imageQuality: 85);
    if (x == null) return widget.onPicked.call(null);
    final f = File(x.path);
    setState(() => _last = f);
    widget.onPicked.call(f);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ElevatedButton.icon(onPressed: () => _pick(ImageSource.camera), icon: const Icon(Icons.camera_alt), label: const Text('Camera')),
        const SizedBox(width: 8),
        ElevatedButton.icon(onPressed: () => _pick(ImageSource.gallery), icon: const Icon(Icons.photo), label: const Text('Gallery')),
        const SizedBox(width: 8),
        if (_last != null) SizedBox(width: 60, height: 60, child: Image.file(_last!, fit: BoxFit.cover)),
      ],
    );
  }
}
