import 'package:flutter/material.dart';

/// LazyLoader: wraps child and shows a placeholder while the loaderFuture completes.
class ReusableLazyLoader<T> extends StatefulWidget {
  final Future<T> future;
  final Widget Function(BuildContext, T) builder;
  final Widget placeholder;
  final Duration minDelay;

  const ReusableLazyLoader({Key? key, required this.future, required this.builder, this.placeholder = const SizedBox.shrink(), this.minDelay = const Duration(milliseconds: 200)}) : super(key: key);

  @override
  State<ReusableLazyLoader<T>> createState() => _ReusableLazyLoaderState<T>();
}

class _ReusableLazyLoaderState<T> extends State<ReusableLazyLoader<T>> {
  T? _result;
  bool _done = false;

  @override
  void initState() {
    super.initState();
    widget.future.then((value) async {
      // ensure small delay so placeholder flashes less often
      await Future.delayed(widget.minDelay);
      if (mounted) setState(() { _result = value; _done = true; });
    }).catchError((e) {
      if (mounted) setState(() { _done = true; _result = null; });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_done) return widget.placeholder;
    if (_result == null) return Center(child: Text('Failed to load'));
    return widget.builder(context, _result as T);
  }
}
