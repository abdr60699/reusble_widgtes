import 'package:flutter/material.dart';

class ReusableBreakpointBuilder extends StatelessWidget {
  final Widget? small;
  final Widget? medium;
  final Widget? large;

  const ReusableBreakpointBuilder({Key? key, this.small, this.medium, this.large}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    if (w < 600) return small ?? SizedBox.shrink();
    if (w < 1024) return medium ?? small ?? SizedBox.shrink();
    return large ?? medium ?? small ?? SizedBox.shrink();
  }
}
