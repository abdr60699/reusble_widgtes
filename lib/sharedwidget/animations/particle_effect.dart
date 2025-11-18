import 'package:flutter/material.dart';
import 'dart:math';

class _Particle {
  Offset pos;
  Offset velocity;
  double size;
  Color color;
  _Particle(this.pos, this.velocity, this.size, this.color);
}

class ReusableParticleEffect extends StatefulWidget {
  final int count;
  final Color color;
  final double speed;
  final Duration duration;

  const ReusableParticleEffect({Key? key, this.count = 30, this.color = Colors.white, this.speed = 30, this.duration = const Duration(seconds: 20)}) : super(key: key);

  @override
  State<ReusableParticleEffect> createState() => _ReusableParticleEffectState();
}

class _ReusableParticleEffectState extends State<ReusableParticleEffect> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  final List<_Particle> _particles = [];
  final Random _rnd = Random();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration)..repeat();
  }

  void _init(Size size) {
    if (_particles.isNotEmpty) return;
    for (int i=0;i<widget.count;i++) {
      final pos = Offset(_rnd.nextDouble()*size.width, _rnd.nextDouble()*size.height);
      final angle = _rnd.nextDouble()*2*pi;
      final speed = _rnd.nextDouble()*widget.speed;
      final vel = Offset(cos(angle)*speed, sin(angle)*speed);
      _particles.add(_Particle(pos, vel, _rnd.nextDouble()*3+1, widget.color.withOpacity(0.6+_rnd.nextDouble()*0.4)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      _init(constraints.biggest);
      return AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          final dt = 1/60;
          for (var p in _particles) {
            p.pos = Offset((p.pos.dx + p.velocity.dx*dt) % constraints.maxWidth, (p.pos.dy + p.velocity.dy*dt) % constraints.maxHeight);
          }
          return CustomPaint(painter: _ParticlePainter(List.from(_particles)), size: constraints.biggest);
        },
      );
    });
  }
}

class _ParticlePainter extends CustomPainter {
  final List<_Particle> particles;
  _ParticlePainter(this.particles);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    for (var p in particles) {
      paint.color = p.color;
      canvas.drawCircle(p.pos, p.size, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _ParticlePainter oldDelegate) => true;
}
