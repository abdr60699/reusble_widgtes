import 'package:flutter/material.dart';

/// A simple data grid that lays out a list of records as cards in a grid.
class ReusableDataGrid extends StatelessWidget {
  final List<Map<String, dynamic>> items;
  final int crossAxisCount;
  final double childAspectRatio;
  final Widget Function(BuildContext, Map<String, dynamic>)? itemBuilder;

  const ReusableDataGrid({
    Key? key,
    required this.items,
    this.crossAxisCount = 2,
    this.childAspectRatio = 1.4,
    this.itemBuilder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        childAspectRatio: childAspectRatio,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        if (itemBuilder != null) return itemBuilder!(context, item);
        // default card layout
        return Card(
          elevation: 2,
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item['title']?.toString() ?? 'Item', style: Theme.of(context).textTheme.titleMedium),
                SizedBox(height: 8),
                Expanded(child: Text(item['subtitle']?.toString() ?? '', overflow: TextOverflow.ellipsis)),
                SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(item['meta']?.toString() ?? ''),
                    if (item['badge'] != null)
                      Container(padding: EdgeInsets.symmetric(horizontal:6, vertical:4), decoration: BoxDecoration(color: Colors.blue, borderRadius: BorderRadius.circular(8)), child: Text(item['badge'].toString(), style: TextStyle(color: Colors.white, fontSize:12)))
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
