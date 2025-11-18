import 'package:flutter/material.dart';
import 'dart:math';

class ReusableWaveAnimation extends StatefulWidget {
  final double height;
  final Color color;
  final Duration duration;

  const ReusableWaveAnimation({Key? key, this.height = 80, this.color = Colors.blueAccent, this.duration = const Duration(seconds:2)}) : super(key: key);

  @override
  State<ReusableWaveAnimation> createState() => _ReusableWaveAnimationState();
}

class _ReusableWaveAnimationState extends State<ReusableWaveAnimation> with SingleTickerProviderStateMixin {
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
    return SizedBox(
      height: widget.height,
      width: double.infinity,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return CustomPaint(
            painter: _WavePainter(progress: _controller.value, color: widget.color),
          );
        },
      ),
    );
  }
}

class _WavePainter extends CustomPainter {
  final double progress;
  final Color color;
  _WavePainter({required this.progress, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color.withOpacity(0.7);
    final path = Path();
    final amplitude = size.height * 0.2;
    final wavelength = size.width / 1.5;
    path.moveTo(0, size.height/2);
    for (double x=0; x<=size.width; x++) {
      final y = size.height/2 + sin((x / wavelength * 2 * pi) + (progress * 2 * pi)) * amplitude;
      path.lineTo(x, y);
    }
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _WavePainter oldDelegate) => oldDelegate.progress != progress;
}
