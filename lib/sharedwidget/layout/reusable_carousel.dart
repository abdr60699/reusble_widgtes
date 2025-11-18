import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

/// A reusable carousel widget for displaying sliding content.
///
/// Supports images, widgets, and customizable indicators.
///
/// Example:
/// ```dart
/// ReusableCarousel(
///   items: [
///     Container(color: Colors.red),
///     Container(color: Colors.blue),
///     Container(color: Colors.green),
///   ],
///   height: 200,
///   autoPlay: true,
/// )
/// ```
class ReusableCarousel extends StatefulWidget {
  /// List of widgets to display in carousel
  final List<Widget> items;

  /// Height of the carousel
  final double height;

  /// Whether to auto-play the carousel
  final bool autoPlay;

  /// Auto-play duration
  final Duration autoPlayInterval;

  /// Whether to show page indicators
  final bool showIndicators;

  /// Whether carousel is infinite (loops)
  final bool enableInfiniteScroll;

  /// Callback when page changes
  final Function(int)? onPageChanged;

  const ReusableCarousel({
    super.key,
    required this.items,
    this.height = 200.0,
    this.autoPlay = false,
    this.autoPlayInterval = const Duration(seconds: 3),
    this.showIndicators = true,
    this.enableInfiniteScroll = true,
    this.onPageChanged,
  });

  @override
  State<ReusableCarousel> createState() => _ReusableCarouselState();
}

class _ReusableCarouselState extends State<ReusableCarousel> {
  int _currentIndex = 0;
  final CarouselController _carouselController = CarouselController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CarouselSlider(
          carouselController: _carouselController,
          options: CarouselOptions(
            height: widget.height,
            autoPlay: widget.autoPlay,
            autoPlayInterval: widget.autoPlayInterval,
            enableInfiniteScroll: widget.enableInfiniteScroll,
            enlargeCenterPage: true,
            onPageChanged: (index, reason) {
              setState(() {
                _currentIndex = index;
              });
              widget.onPageChanged?.call(index);
            },
          ),
          items: widget.items.map((item) {
            return Builder(
              builder: (BuildContext context) {
                return Container(
                  width: MediaQuery.of(context).size.width,
                  margin: const EdgeInsets.symmetric(horizontal: 5.0),
                  child: item,
                );
              },
            );
          }).toList(),
        ),
        if (widget.showIndicators) ...[
          const SizedBox(height: 12),
          _buildIndicators(),
        ],
      ],
    );
  }

  Widget _buildIndicators() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: widget.items.asMap().entries.map((entry) {
        return GestureDetector(
          onTap: () => _carouselController.animateToPage(entry.key),
          child: Container(
            width: _currentIndex == entry.key ? 12 : 8,
            height: 8,
            margin: const EdgeInsets.symmetric(horizontal: 4),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              color: Theme.of(context).colorScheme.primary.withOpacity(
                _currentIndex == entry.key ? 1.0 : 0.3,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
