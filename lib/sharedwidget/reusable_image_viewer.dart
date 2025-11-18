
// reusable_image_viewer.dart
import 'package:flutter/material.dart';

/// Fullscreen image viewer with zoom/pan
class ReusableImageViewer extends StatelessWidget {
  final ImageProvider image;
  final String? heroTag;

  const ReusableImageViewer({Key? key, required this.image, this.heroTag}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        onTap: () => Navigator.of(context).pop(),
        child: Center(
          child: Hero(
            tag: heroTag ?? image.hashCode,
            child: InteractiveViewer(
              child: Image(image: image),
            ),
          ),
        ),
      ),
    );
  }
}
