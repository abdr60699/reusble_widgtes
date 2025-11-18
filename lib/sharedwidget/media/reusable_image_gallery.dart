
// reusable_image_gallery.dart
import 'package:flutter/material.dart';

/// Simple gallery viewer with page view and thumbnails.
class ReusableImageGallery extends StatefulWidget {
  final List<ImageProvider> images;
  final int initialIndex;

  const ReusableImageGallery({Key? key, required this.images, this.initialIndex = 0}) : super(key: key);

  @override
  State<ReusableImageGallery> createState() => _ReusableImageGalleryState();
}

class _ReusableImageGalleryState extends State<ReusableImageGallery> {
  late final PageController _controller;
  late int _index;

  @override
  void initState() {
    super.initState();
    _index = widget.initialIndex;
    _controller = PageController(initialPage: _index);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: PageView.builder(
            controller: _controller,
            itemCount: widget.images.length,
            onPageChanged: (i) => setState(() => _index = i),
            itemBuilder: (_, i) => InteractiveViewer(
              child: Image(image: widget.images[i], fit: BoxFit.contain),
            ),
          ),
        ),
        SizedBox(
          height: 80,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: widget.images.length,
            itemBuilder: (context, i) {
              return GestureDetector(
                onTap: () {
                  _controller.jumpToPage(i);
                  setState(() => _index = i);
                },
                child: Container(
                  margin: const EdgeInsets.all(8),
                  width: 64,
                  decoration: BoxDecoration(
                    border: Border.all(color: i == _index ? Theme.of(context).colorScheme.primary : Colors.transparent, width: 2),
                  ),
                  child: Image(image: widget.images[i], fit: BoxFit.cover),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
