
// reusable_carousel.dart
import 'package:flutter/material.dart';

class ReusableCarousel extends StatefulWidget {
  final List<Widget> items;
  final double height;
  final bool autoPlay;
  final Duration autoPlayInterval;

  const ReusableCarousel({
    Key? key,
    required this.items,
    this.height = 200,
    this.autoPlay = false,
    this.autoPlayInterval = const Duration(seconds: 4),
  }) : super(key: key);

  @override
  State<ReusableCarousel> createState() => _ReusableCarouselState();
}

class _ReusableCarouselState extends State<ReusableCarousel> {
  final PageController _controller = PageController();
  int _index = 0;

  @override
  void initState() {
    super.initState();
    if (widget.autoPlay) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _startAutoPlay());
    }
  }

  void _startAutoPlay() async {
    while (mounted && widget.autoPlay) {
      await Future.delayed(widget.autoPlayInterval);
      if (!mounted) return;
      _index = (_index + 1) % widget.items.length;
      _controller.animateToPage(_index, duration: const Duration(milliseconds: 400), curve: Curves.easeInOut);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.height,
      child: PageView.builder(
        controller: _controller,
        itemCount: widget.items.length,
        itemBuilder: (_, i) => widget.items[i],
      ),
    );
  }
}
