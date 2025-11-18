import 'package:flutter/material.dart';

class OnboardingPage {
  final Widget content;
  final String title;
  final String? subtitle;

  OnboardingPage({required this.content, required this.title, this.subtitle});
}

class ReusableOnboarding extends StatefulWidget {
  final List<OnboardingPage> pages;
  final VoidCallback? onFinish;

  const ReusableOnboarding({Key? key, required this.pages, this.onFinish}) : super(key: key);

  @override
  State<ReusableOnboarding> createState() => _ReusableOnboardingState();
}

class _ReusableOnboardingState extends State<ReusableOnboarding> {
  final PageController _controller = PageController();
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Expanded(
        child: PageView.builder(
          controller: _controller,
          itemCount: widget.pages.length,
          onPageChanged: (i) => setState(() => _index = i),
          itemBuilder: (context, index) {
            final p = widget.pages[index];
            return Padding(padding: EdgeInsets.all(24), child: Column(children: [
              Expanded(child: p.content),
              SizedBox(height: 12),
              Text(p.title, style: Theme.of(context).textTheme.titleLarge),
              if (p.subtitle != null) Text(p.subtitle!)
            ]));
          },
        ),
      ),
      Padding(padding: EdgeInsets.all(12), child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        TextButton(onPressed: () { _controller.jumpToPage(widget.pages.length -1); }, child: Text('Skip')),
        Row(children: [...List.generate(widget.pages.length, (i) => Container(margin: EdgeInsets.symmetric(horizontal:4), width: _index==i?18:8, height:8, decoration: BoxDecoration(color: _index==i?Colors.blue:Colors.grey, borderRadius: BorderRadius.circular(8))))]),
        ElevatedButton(onPressed: () { if (_index == widget.pages.length -1) { widget.onFinish?.call(); } else { _controller.nextPage(duration: Duration(milliseconds:300), curve: Curves.easeInOut); } }, child: Text(_index==widget.pages.length-1? 'Finish' : 'Next')),
      ]))
    ]);
  }
}
