
// reusable_pagination.dart
import 'package:flutter/material.dart';

typedef PageChanged = void Function(int page);

class ReusablePagination extends StatelessWidget {
  final int currentPage;
  final int totalPages;
  final PageChanged onPageChanged;

  const ReusablePagination({
    Key? key,
    required this.currentPage,
    required this.totalPages,
    required this.onPageChanged,
  }) : super(key: key);

  List<Widget> _buildPages(BuildContext context) {
    final List<Widget> widgets = [];
    final start = (currentPage - 2).clamp(1, totalPages);
    final end = (currentPage + 2).clamp(1, totalPages);

    if (start > 1) widgets.add(_pageButton(context, 1));
    if (start > 2) widgets.add(const Padding(padding: EdgeInsets.symmetric(horizontal:4), child: Text('...')));

    for (int i = start; i <= end; i++) {
      widgets.add(_pageButton(context, i));
    }

    if (end < totalPages - 1) widgets.add(const Padding(padding: EdgeInsets.symmetric(horizontal:4), child: Text('...')));
    if (end < totalPages) widgets.add(_pageButton(context, totalPages));

    return widgets;
  }

  Widget _pageButton(BuildContext context, int page) {
    final bool active = page == currentPage;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: ElevatedButton(
        onPressed: () => onPageChanged(page),
        style: ElevatedButton.styleFrom(
          backgroundColor: active ? Theme.of(context).colorScheme.primary : null,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        ),
        child: Text('$page', style: TextStyle(color: active ? Colors.white : null)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (totalPages <= 1) return const SizedBox.shrink();
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(icon: const Icon(Icons.chevron_left), onPressed: currentPage > 1 ? () => onPageChanged(currentPage - 1) : null),
        ..._buildPages(context),
        IconButton(icon: const Icon(Icons.chevron_right), onPressed: currentPage < totalPages ? () => onPageChanged(currentPage + 1) : null),
      ],
    );
  }
}
