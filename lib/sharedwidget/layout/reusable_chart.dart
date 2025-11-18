import 'package:flutter/material.dart';

/// Simple bar chart painter that draws bars from a map of category -> value.
class ReusableChart extends StatelessWidget {
  final Map<String, double> data;
  final double height;
  final String? title;

  const ReusableChart({Key? key, required this.data, this.height = 160, this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final entries = data.entries.toList();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null) Padding(padding: EdgeInsets.only(bottom:8), child: Text(title!, style: Theme.of(context).textTheme.titleMedium)),
        SizedBox(
          height: height,
          child: CustomPaint(
            size: Size.infinite,
            painter: _BarChartPainter(entries),
          ),
        ),
      ],
    );
  }
}

class _BarChartPainter extends CustomPainter {
  final List<MapEntry<String,double>> entries;
  _BarChartPainter(this.entries);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;
    final double maxVal = entries.map((e) => e.value).fold(0.0, (a,b) => a>b?a:b);
    if (maxVal<=0) return;
    final barWidth = size.width / (entries.length * 2);
    final textPainter = TextPainter(textDirection: TextDirection.ltr);
    for (var i=0;i<entries.length;i++) {
      final e = entries[i];
      final x = (i*2+0.5) * barWidth;
      final barHeight = (e.value / maxVal) * (size.height - 20);
      paint.color = Colors.blue[(i*100)%900] ?? Colors.blue;
      final rect = Rect.fromLTWH(x, size.height - barHeight - 16, barWidth, barHeight);
      canvas.drawRRect(RRect.fromRectAndRadius(rect, Radius.circular(6)), paint);

      // label
      textPainter.text = TextSpan(text: e.key, style: TextStyle(color: Colors.black, fontSize: 10));
      textPainter.layout(minWidth: 0, maxWidth: barWidth*1.8);
      textPainter.paint(canvas, Offset(x - (textPainter.width-barWidth)/2, size.height - 14));
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
