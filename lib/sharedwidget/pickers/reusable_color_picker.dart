
// reusable_color_picker.dart
// Simple color grid picker dialog and widget
import 'package:flutter/material.dart';

typedef ColorChanged = void Function(Color color);

class ReusableColorPicker extends StatelessWidget {
  final List<Color>? colors;
  final Color? selected;
  final ColorChanged? onColorSelected;
  final int columns;

  const ReusableColorPicker({
    Key? key,
    this.colors,
    this.selected,
    this.onColorSelected,
    this.columns = 5,
  }) : super(key: key);

  static Future<Color?> showPicker(BuildContext context, {List<Color>? colors, Color? initial}) {
    return showDialog<Color>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Pick a color'),
        content: SizedBox(
          width: double.maxFinite,
          child: ReusableColorPicker(colors: colors, selected: initial),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Cancel')),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final palette = colors ??
        [
          Colors.red,
          Colors.pink,
          Colors.purple,
          Colors.deepPurple,
          Colors.indigo,
          Colors.blue,
          Colors.lightBlue,
          Colors.cyan,
          Colors.teal,
          Colors.green,
          Colors.lightGreen,
          Colors.lime,
          Colors.yellow,
          Colors.amber,
          Colors.orange,
          Colors.deepOrange,
          Colors.brown,
          Colors.grey,
          Colors.blueGrey,
        ];

    return GridView.count(
      shrinkWrap: true,
      crossAxisCount: columns,
      mainAxisSpacing: 8,
      crossAxisSpacing: 8,
      children: palette.map((c) {
        final isSelected = selected != null && selected!.value == c.value;
        return InkResponse(
          onTap: () {
            onColorSelected?.call(c);
            if (Navigator.canPop(context)) Navigator.of(context).pop(c);
          },
          child: Container(
            decoration: BoxDecoration(
              color: c,
              borderRadius: BorderRadius.circular(8),
              border: isSelected ? Border.all(color: Theme.of(context).colorScheme.onPrimary, width: 3) : null,
            ),
            height: 44,
            width: 44,
          ),
        );
      }).toList(),
    );
  }
}
