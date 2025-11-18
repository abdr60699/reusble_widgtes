
// reusable_skeleton_loader.dart
import 'package:flutter/material.dart';

/// A lightweight skeleton placeholder box
class ReusableSkeleton extends StatelessWidget {
  final double height;
  final double? width;
  final BorderRadius borderRadius;
  final EdgeInsets margin;

  const ReusableSkeleton({
    Key? key,
    this.height = 12,
    this.width,
    this.borderRadius = const BorderRadius.all(Radius.circular(6)),
    this.margin = EdgeInsets.zero,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final base = Theme.of(context).colorScheme.surfaceVariant;
    final highlight = Theme.of(context).colorScheme.surface;
    return Container(
      margin: margin,
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: base,
        borderRadius: borderRadius,
        gradient: LinearGradient(
          colors: [base, highlight, base],
          begin: Alignment(-1.0, -0.3),
          end: Alignment(1.0, 0.3),
          stops: const [0.0, 0.5, 1.0],
        ),
      ),
    );
  }
}

/// Multiple skeleton lines helper
class ReusableSkeletonList extends StatelessWidget {
  final int lines;
  final double spacing;

  const ReusableSkeletonList({Key? key, this.lines = 3, this.spacing = 8}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(lines, (i) => Padding(
        padding: EdgeInsets.only(bottom: i == lines - 1 ? 0 : spacing),
        child: ReusableSkeleton(height: 12, width: double.infinity),
      )),
    );
  }
}
