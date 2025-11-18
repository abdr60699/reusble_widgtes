
// reusable_no_data.dart
import 'package:flutter/material.dart';

class ReusableNoData extends StatelessWidget {
  final String message;
  final IconData? icon;
  final Widget? action;

  const ReusableNoData({Key? key, this.message = 'No data available', this.icon = Icons.search_off, this.action}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 56, color: Theme.of(context).colorScheme.tertiary),
          const SizedBox(height: 12),
          Text(message, style: Theme.of(context).textTheme.titleMedium),
          if (action != null) ...[ const SizedBox(height: 12), action! ],
        ],
      ),
    );
  }
}
