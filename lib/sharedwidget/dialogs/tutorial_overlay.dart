import 'package:flutter/material.dart';

/// TutorialOverlay: highlights arbitrary rects and shows hints. Simple utility used by walkthrough.
class ReusableTutorialOverlay extends StatelessWidget {
  final List<Rect> highlights;
  final Widget? hint;

  const ReusableTutorialOverlay({Key? key, required this.highlights, this.hint}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Positioned.fill(child: Container(color: Colors.black54)),
      ...highlights.map((r)=> Positioned.fromRect(rect: r, child: Container(decoration: BoxDecoration(border: Border.all(color: Colors.white, width: 2), color: Colors.transparent)))),
      if (hint != null) Positioned(bottom: 40, left: 20, right: 20, child: hint!)
    ]);
  }
}
