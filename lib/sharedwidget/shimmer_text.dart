import 'package:flutter/material.dart';

class ReusableShimmerText extends StatefulWidget {
  final String text;
  final TextStyle? style;
  final Duration duration;

  const ReusableShimmerText({Key? key, required this.text, this.style, this.duration = const Duration(seconds:2)}) : super(key: key);

  @override
  State<ReusableShimmerText> createState() => _ReusableShimmerTextState();
}

class _ReusableShimmerTextState extends State<ReusableShimmerText> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration)..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final text = widget.text;
    final style = widget.style ?? Theme.of(context).textTheme.titleLarge;
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return ShaderMask(
          shaderCallback: (rect) {
            return LinearGradient(
              colors: [Colors.grey, Colors.white, Colors.grey],
              stops: [0.0, 0.5, 1.0],
              begin: Alignment(-1 - _controller.value*2, 0),
              end: Alignment(1 - _controller.value*2, 0),
            ).createShader(rect);
          },
          blendMode: BlendMode.srcIn,
          child: Text(text, style: style),
        );
      },
    );
  }
}
