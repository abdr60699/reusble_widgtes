import 'package:flutter/material.dart';

class ReusableMetricCard extends StatelessWidget {
  final String metric;
  final String label;
  final IconData? icon;

  const ReusableMetricCard({Key? key, required this.metric, required this.label, this.icon}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(padding: EdgeInsets.all(12), child: Row(
        children: [
          if (icon != null) Icon(icon, size: 32),
          if (icon != null) SizedBox(width: 12),
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(metric, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            SizedBox(height: 4),
            Text(label, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
          ])
        ],
      )),
    );
  }
}
