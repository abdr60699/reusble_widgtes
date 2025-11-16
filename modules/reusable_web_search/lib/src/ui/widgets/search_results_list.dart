import 'package:flutter/material.dart';
import '../../models/models.dart';
import 'search_result_card.dart';

/// Widget to display a list of search results with pagination support
class SearchResultsList extends StatefulWidget {
  final List<SearchResult> results;
  final bool hasMore;
  final bool isLoading;
  final VoidCallback? onLoadMore;
  final Function(SearchResult)? onResultTap;
  final Function(SearchResult)? onFavoriteToggle;
  final Set<String> favoriteUrls;
  final ScrollController? scrollController;
  final Widget? emptyWidget;
  final Widget? errorWidget;

  const SearchResultsList({
    super.key,
    required this.results,
    this.hasMore = false,
    this.isLoading = false,
    this.onLoadMore,
    this.onResultTap,
    this.onFavoriteToggle,
    this.favoriteUrls = const {},
    this.scrollController,
    this.emptyWidget,
    this.errorWidget,
  });

  @override
  State<SearchResultsList> createState() => _SearchResultsListState();
}

class _SearchResultsListState extends State<SearchResultsList> {
  late ScrollController _scrollController;
  bool _isLoadingMore = false;

  @override
  void initState() {
    super.initState();
    _scrollController = widget.scrollController ?? ScrollController();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    if (widget.scrollController == null) {
      _scrollController.dispose();
    }
    super.dispose();
  }

  void _onScroll() {
    if (_isLoadingMore || !widget.hasMore) return;

    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;
    final threshold = maxScroll * 0.8; // 80% threshold

    if (currentScroll >= threshold) {
      _loadMore();
    }
  }

  Future<void> _loadMore() async {
    if (_isLoadingMore || !widget.hasMore || widget.onLoadMore == null) {
      return;
    }

    setState(() {
      _isLoadingMore = true;
    });

    widget.onLoadMore!();

    // Reset loading state after a delay
    await Future.delayed(const Duration(milliseconds: 500));
    if (mounted) {
      setState(() {
        _isLoadingMore = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.results.isEmpty) {
      return widget.emptyWidget ??
          const Center(
            child: Padding(
              padding: EdgeInsets.all(32.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.search_off, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    'No results found',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                ],
              ),
            ),
          );
    }

    return ListView.builder(
      controller: _scrollController,
      itemCount: widget.results.length + (widget.hasMore ? 1 : 0),
      itemBuilder: (context, index) {
        // Show loading indicator at the end
        if (index >= widget.results.length) {
          return _buildLoadingIndicator();
        }

        final result = widget.results[index];
        return SearchResultCard(
          result: result,
          onTap: () => widget.onResultTap?.call(result),
          onFavorite: () => widget.onFavoriteToggle?.call(result),
          isFavorite: widget.favoriteUrls.contains(result.url),
        );
      },
    );
  }

  Widget _buildLoadingIndicator() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      alignment: Alignment.center,
      child: const CircularProgressIndicator(),
    );
  }
}
