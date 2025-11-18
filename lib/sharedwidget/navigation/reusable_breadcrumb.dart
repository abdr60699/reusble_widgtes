import 'package:flutter/material.dart';

class ReusableBreadcrumb extends StatelessWidget {
  final List<String> items;
  final void Function(int index)? onTap;

  const ReusableBreadcrumb({
    super.key,
    required this.items,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(items.length, (i) {
        return Row(
          children: [
            GestureDetector(
              onTap: onTap != null ? () => onTap!(i) : null,
              child: Text(
                items[i],
                style: TextStyle(
                  color: i == items.length - 1
                      ? Colors.grey
                      : Theme.of(context).colorScheme.primary,
                  fontWeight: i == items.length - 1 ? FontWeight.bold : null,
                ),
              ),
            ),
            if (i != items.length - 1)
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8),
                child: Icon(Icons.chevron_right, size: 18),
              ),
          ],
        );
      }),
    );
  }
}
