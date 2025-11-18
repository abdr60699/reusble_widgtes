import 'package:flutter/material.dart';

/// Simple walkthrough overlay that highlights a list of GlobalKeys in sequence.
class WalkthroughStep {
  final GlobalKey key;
  final String title;
  final String? description;

  WalkthroughStep({required this.key, required this.title, this.description});
}

class ReusableWalkthrough extends StatefulWidget {
  final List<WalkthroughStep> steps;
  final VoidCallback? onFinish;

  const ReusableWalkthrough({Key? key, required this.steps, this.onFinish}) : super(key: key);

  @override
  State<ReusableWalkthrough> createState() => _ReusableWalkthroughState();
}

class _ReusableWalkthroughState extends State<ReusableWalkthrough> {
  int _index = 0;

  void _next() {
    if (_index < widget.steps.length - 1) setState(() => _index++);
    else widget.onFinish?.call();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.steps.isEmpty) return SizedBox.shrink();
    final step = widget.steps[_index];
    final renderBox = step.key.currentContext?.findRenderObject() as RenderBox?;
    final offset = renderBox?.localToGlobal(Offset.zero);
    final size = renderBox?.size;
    final rect = (offset != null && size != null) ? offset & size : null;
    return Stack(children: [
      // dark overlay
      Positioned.fill(child: GestureDetector(onTap: _next, child: Container(color: Colors.black54))),
      if (rect != null) Positioned.fromRect(rect: rect, child: IgnorePointer(child: Container(decoration: BoxDecoration(border: Border.all(color: Colors.yellow, width: 3), borderRadius: BorderRadius.circular(8))))),
      Positioned(bottom: 40, left: 20, right: 20, child: Card(child: Padding(padding: EdgeInsets.all(12), child: Column(children: [Text(step.title, style: TextStyle(fontWeight: FontWeight.bold)), if (step.description!=null) Text(step.description!)])))),
    ]);
  }
}
