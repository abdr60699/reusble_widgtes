
// reusable_expansion_panel.dart
import 'package:flutter/material.dart';

class ReusableExpansionPanelItem {
  final Widget header;
  final Widget body;
  final bool initiallyExpanded;
  ReusableExpansionPanelItem({required this.header, required this.body, this.initiallyExpanded = false});
}

class ReusableExpansionPanelList extends StatefulWidget {
  final List<ReusableExpansionPanelItem> items;
  final bool accordion;

  const ReusableExpansionPanelList({Key? key, required this.items, this.accordion = false}) : super(key: key);

  @override
  State<ReusableExpansionPanelList> createState() => _ReusableExpansionPanelListState();
}

class _ReusableExpansionPanelListState extends State<ReusableExpansionPanelList> {
  late List<bool> _open;

  @override
  void initState() {
    super.initState();
    _open = widget.items.map((e) => e.initiallyExpanded).toList();
  }

  @override
  Widget build(BuildContext context) {
    return ExpansionPanelList(
      expansionCallback: (index, isOpen) {
        setState(() {
          if (widget.accordion) {
            for (var i = 0; i < _open.length; i++) _open[i] = false;
          }
          _open[index] = !isOpen;
        });
      },
      children: widget.items.asMap().entries.map((entry) {
        final i = entry.key;
        final item = entry.value;
        return ExpansionPanel(
          headerBuilder: (_, __) => item.header,
          body: item.body,
          isExpanded: _open[i],
        );
      }).toList(),
    );
  }
}
