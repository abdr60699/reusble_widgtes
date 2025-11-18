
// reusable_accordion.dart
import 'package:flutter/material.dart';

class ReusableAccordionSection {
  final String title;
  final Widget content;
  final bool initiallyOpen;

  ReusableAccordionSection({required this.title, required this.content, this.initiallyOpen = false});
}

class ReusableAccordion extends StatefulWidget {
  final List<ReusableAccordionSection> sections;

  const ReusableAccordion({Key? key, required this.sections}) : super(key: key);

  @override
  State<ReusableAccordion> createState() => _ReusableAccordionState();
}

class _ReusableAccordionState extends State<ReusableAccordion> {
  late List<bool> _open;

  @override
  void initState() {
    super.initState();
    _open = widget.sections.map((s) => s.initiallyOpen).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: widget.sections.asMap().entries.map((e) {
        final i = e.key;
        final s = e.value;
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 6),
          child: Column(
            children: [
              ListTile(
                title: Text(s.title),
                trailing: IconButton(
                  icon: Icon(_open[i] ? Icons.expand_less : Icons.expand_more),
                  onPressed: () => setState(() => _open[i] = !_open[i]),
                ),
              ),
              AnimatedCrossFade(
                firstChild: const SizedBox.shrink(),
                secondChild: Padding(padding: const EdgeInsets.all(12.0), child: s.content),
                crossFadeState: _open[i] ? CrossFadeState.showSecond : CrossFadeState.showFirst,
                duration: const Duration(milliseconds: 200),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
