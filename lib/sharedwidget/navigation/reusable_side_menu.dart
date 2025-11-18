import 'package:flutter/material.dart';

class ReusableSideMenu extends StatelessWidget {
  final List<Widget> items;
  final double width;
  final Color? backgroundColor;

  const ReusableSideMenu({
    super.key,
    required this.items,
    this.width = 250,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      color: backgroundColor ?? Theme.of(context).colorScheme.surface,
      child: ListView(children: items),
    );
  }
}
