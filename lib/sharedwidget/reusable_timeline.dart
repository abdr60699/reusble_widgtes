
// reusable_timeline.dart
import 'package:flutter/material.dart';

class TimelineItem {
  final String title;
  final String? subtitle;
  final DateTime? time;
  final Widget? leading;

  TimelineItem({required this.title, this.subtitle, this.time, this.leading});
}

class ReusableTimeline extends StatelessWidget {
  final List<TimelineItem> items;
  final Color? lineColor;
  final double indicatorSize;

  const ReusableTimeline({
    Key? key,
    required this.items,
    this.lineColor,
    this.indicatorSize = 12,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final lc = lineColor ?? Theme.of(context).colorScheme.primaryContainer;
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: items.length,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        final item = items[index];
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                Container(
                  width: indicatorSize,
                  height: indicatorSize,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    shape: BoxShape.circle,
                  ),
                ),
                if (index != items.length - 1)
                  Container(width: 2, height: 48, color: lc),
              ],
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item.title, style: Theme.of(context).textTheme.titleMedium),
                  if (item.subtitle != null) Text(item.subtitle!, style: Theme.of(context).textTheme.bodyMedium),
                  if (item.time != null) Text('${item.time}', style: Theme.of(context).textTheme.bodySmall),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
