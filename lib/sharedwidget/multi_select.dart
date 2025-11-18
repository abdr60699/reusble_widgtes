import 'package:flutter/material.dart';

class ReusableMultiSelect extends StatefulWidget {
  final List<String> items;
  final List<String> initialSelected;
  final String label;
  final void Function(List<String>) onChanged;

  const ReusableMultiSelect({
    Key? key,
    required this.items,
    required this.initialSelected,
    required this.label,
    required this.onChanged,
  }) : super(key: key);

  @override
  State<ReusableMultiSelect> createState() => _ReusableMultiSelectState();
}

class _ReusableMultiSelectState extends State<ReusableMultiSelect> {
  late List<String> selected;

  @override
  void initState() {
    super.initState();
    selected = List.from(widget.initialSelected);
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        await showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: Text(widget.label),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: widget.items.map((item) {
                return CheckboxListTile(
                  title: Text(item),
                  value: selected.contains(item),
                  onChanged: (v) {
                    setState(() {
                      v! ? selected.add(item) : selected.remove(item);
                    });
                  },
                );
              }).toList(),
            ),
            actions: [
              TextButton(onPressed: () => Navigator.pop(context), child: Text("Cancel")),
              ElevatedButton(
                onPressed: () {
                  widget.onChanged(selected);
                  Navigator.pop(context);
                },
                child: Text("OK"),
              )
            ],
          ),
        );
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 10),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Text(selected.isEmpty ? "Select..." : selected.join(", ")),
      ),
    );
  }
}
