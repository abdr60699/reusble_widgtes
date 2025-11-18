import 'package:flutter/material.dart';

/// ReusableInfiniteScroll: provides a ListView that calls onLoadMore when nearing the end.
class ReusableInfiniteScroll<T> extends StatefulWidget {
  final IndexedWidgetBuilder itemBuilder;
  final int itemCount;
  final Future<void> Function() onLoadMore;
  final ScrollController? controller;
  final Widget? loadingWidget;
  final bool hasMore;

  const ReusableInfiniteScroll({
    Key? key,
    required this.itemBuilder,
    required this.itemCount,
    required this.onLoadMore,
    this.controller,
    this.loadingWidget,
    this.hasMore = true,
  }) : super(key: key);

  @override
  State<ReusableInfiniteScroll<T>> createState() => _ReusableInfiniteScrollState<T>();
}

class _ReusableInfiniteScrollState<T> extends State<ReusableInfiniteScroll<T>> {
  late final ScrollController _ctrl;
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _ctrl = widget.controller ?? ScrollController();
    _ctrl.addListener(_onScroll);
  }

  @override
  void dispose() {
    if (widget.controller == null) _ctrl.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_ctrl.hasClients) return;
    final threshold = 200.0;
    if (_ctrl.position.maxScrollExtent - _ctrl.offset <= threshold && !_loading && widget.hasMore) {
      _loading = true;
      widget.onLoadMore().whenComplete(() {
        if (mounted) setState(() => _loading = false);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: _ctrl,
      itemCount: widget.itemCount + (widget.hasMore ? 1 : 0),
      itemBuilder: (context, index) {
        if (index < widget.itemCount) return widget.itemBuilder(context, index);
        return widget.loadingWidget ?? Padding(padding: EdgeInsets.all(12), child: Center(child: CircularProgressIndicator()));
      },
    );
  }
}
