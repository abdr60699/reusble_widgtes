import 'package:flutter/material.dart';

class ReusableCounterCard extends StatelessWidget {
  final String title;
  final int count;
  final Duration duration;

  const ReusableCounterCard({Key? key, required this.title, required this.count, this.duration = const Duration(seconds:1)}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(padding: EdgeInsets.all(12), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(title, style: Theme.of(context).textTheme.titleSmall),
        SizedBox(height: 8),
        TweenAnimationBuilder<int>(
          tween: IntTween(begin: 0, end: count),
          duration: duration,
          builder: (context, value, child) => Text(value.toString(), style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
        )
      ],)),
    );
  }
}
