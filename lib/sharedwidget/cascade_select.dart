import 'package:flutter/material.dart';

class ReusableCascadeSelect extends StatefulWidget {
  final Map<String, List<String>> data;
  final String labelParent;
  final String labelChild;
  final void Function(String parent, String child) onChanged;

  const ReusableCascadeSelect({
    Key? key,
    required this.data,
    required this.labelParent,
    required this.labelChild,
    required this.onChanged,
  }) : super(key: key);

  @override
  State<ReusableCascadeSelect> createState() => _ReusableCascadeSelectState();
}

class _ReusableCascadeSelectState extends State<ReusableCascadeSelect> {
  String? selectedParent;
  String? selectedChild;

  @override
  Widget build(BuildContext context) {
    List<String> parents = widget.data.keys.toList();
    List<String> children = selectedParent != null ? widget.data[selectedParent]! : [];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.labelParent),
        DropdownButton<String>(
          value: selectedParent,
          isExpanded: true,
          hint: Text("Select ${widget.labelParent}"),
          items: parents.map((p) => DropdownMenuItem(value: p, child: Text(p))).toList(),
          onChanged: (v) {
            setState(() {
              selectedParent = v;
              selectedChild = null;
            });
          },
        ),
        SizedBox(height: 12),
        Text(widget.labelChild),
        DropdownButton<String>(
          value: selectedChild,
          isExpanded: true,
          hint: Text("Select ${widget.labelChild}"),
          items: children.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
          onChanged: (v) {
            setState(() {
              selectedChild = v;
            });
            if (selectedParent != null && selectedChild != null) {
              widget.onChanged(selectedParent!, selectedChild!);
            }
          },
        ),
      ],
    );
  }
}
