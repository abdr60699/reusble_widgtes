import 'package:flutter/material.dart';

class ReusableStatCard extends StatelessWidget {
  final String title;
  final String value;
  final String? subtitle;
  final IconData? icon;

  const ReusableStatCard({
    Key? key,
    required this.title,
    required this.value,
    this.subtitle,
    this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            if (icon != null) Icon(icon, size: 36),
            if (icon != null) SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: TextStyle(fontSize: 12, color: Colors.grey[700])),
                  SizedBox(height: 6),
                  Text(value, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  if (subtitle != null) SizedBox(height: 6),
                  if (subtitle != null) Text(subtitle!, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
