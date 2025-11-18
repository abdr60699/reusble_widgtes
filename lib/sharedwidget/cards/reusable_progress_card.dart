import 'package:flutter/material.dart';

class ReusableProgressCard extends StatelessWidget {
  final String title;
  final double progress; // 0..1
  final String? subtitle;

  const ReusableProgressCard({Key? key, required this.title, required this.progress, this.subtitle}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final percent = (progress*100).clamp(0,100).toStringAsFixed(0);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: Theme.of(context).textTheme.headlineSmall),
            SizedBox(height: 8),
            LinearProgressIndicator(value: progress),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (subtitle != null) Text(subtitle!, style: TextStyle(fontSize:12)),
                Text('\$percent%'),
              ],
            )
          ],
        ),
      ),
    );
  }
}
