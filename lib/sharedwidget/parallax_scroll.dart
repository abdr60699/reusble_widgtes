import 'package:flutter/material.dart';

/// Very simple parallax scroll: each item provides a background builder and a foreground builder.
class ReusableParallaxScroll extends StatelessWidget {
  final ScrollController? controller;
  final List<Widget Function(BuildContext, double)> items; // builder(context, offset)

  const ReusableParallaxScroll({Key? key, this.controller, required this.items}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ctrl = controller ?? ScrollController();
    return ListView.builder(
      controller: ctrl,
      itemCount: items.length,
      itemBuilder: (context, index) {
        return LayoutBuilder(builder: (context, constraints) {
          // offset approximation: list scroll offset relative to item
          final offset = ctrl.hasClients ? (ctrl.offset - index * constraints.maxHeight) : 0.0;
          return items[index](context, offset);
        });
      },
    );
  }
}
