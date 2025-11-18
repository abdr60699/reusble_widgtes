
// reusable_camera_picker.dart
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

/// Simple camera preview capture wrapper.
/// Note: user must call availableCameras() in app init and pass camera list when using this widget.
class ReusableCameraPicker extends StatefulWidget {
  final CameraDescription camera;
  final void Function(XFile file) onCapture;

  const ReusableCameraPicker({Key? key, required this.camera, required this.onCapture}) : super(key: key);

  @override
  State<ReusableCameraPicker> createState() => _ReusableCameraPickerState();
}

class _ReusableCameraPickerState extends State<ReusableCameraPicker> {
  CameraController? _controller;
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    _controller = CameraController(widget.camera, ResolutionPreset.medium);
    _controller?.initialize().then((_) => setState(() => _initialized = true));
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  Future<void> _capture() async {
    if (!(_controller?.value.isInitialized ?? false)) return;
    final file = await _controller!.takePicture();
    widget.onCapture.call(file);
  }

  @override
  Widget build(BuildContext context) {
    if (!_initialized) return const Center(child: CircularProgressIndicator());
    return Column(
      children: [
        AspectRatio(aspectRatio: _controller!.value.aspectRatio, child: CameraPreview(_controller!)),
        ElevatedButton.icon(onPressed: _capture, icon: const Icon(Icons.camera), label: const Text('Capture')),
      ],
    );
  }
}
