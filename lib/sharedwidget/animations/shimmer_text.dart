import 'package:flutter/material.dart';

/// A reusable shimmer text widget with animated shimmer effect.
///
/// Creates text with a shimmer animation effect, useful for loading states
/// or to draw attention to text.
///
/// Example:
/// ```dart
/// ShimmerText(
///   'Loading...',
///   style: TextStyle(fontSize: 24),
///   baseColor: Colors.grey,
///   highlightColor: Colors.white,
/// )
/// ```
class ShimmerText extends StatefulWidget {
  /// The text to display
  final String text;

  /// Text style
  final TextStyle? style;

  /// Base color (darker color)
  final Color baseColor;

  /// Highlight color (lighter color for shimmer effect)
  final Color highlightColor;

  /// Duration of the shimmer animation
  final Duration duration;

  const ShimmerText(
    this.text, {
    super.key,
    this.style,
    this.baseColor = const Color(0xFFE0E0E0),
    this.highlightColor = const Color(0xFFF5F5F5),
    this.duration = const Duration(milliseconds: 1500),
  });

  @override
  State<ShimmerText> createState() => _ShimmerTextState();
}

class _ShimmerTextState extends State<ShimmerText>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    )..repeat();

    _animation = Tween<double>(begin: -1.0, end: 2.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textStyle = widget.style ?? theme.textTheme.titleLarge;

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return ShaderMask(
          shaderCallback: (bounds) {
            return LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.centerRight,
              stops: [
                _animation.value - 0.3,
                _animation.value,
                _animation.value + 0.3,
              ],
              colors: [
                widget.baseColor,
                widget.highlightColor,
                widget.baseColor,
              ],
            ).createShader(bounds);
          },
          child: Text(
            widget.text,
            style: textStyle?.copyWith(color: Colors.white),
          ),
        );
      },
    );
  }
}
