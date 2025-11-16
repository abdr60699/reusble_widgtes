import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/models.dart';
import '../../services/web_search_service.dart';
import '../../services/favorites_service.dart';
import '../widgets/search_results_list.dart';
import 'web_view_screen.dart';

/// Main search screen with search bar and results
class SearchScreen extends StatefulWidget {
  final WebSearchService searchService;
  final FavoritesService? favoritesService;
  final String? initialQuery;
  final Widget? appBarTitle;

  const SearchScreen({
    super.key,
    required this.searchService,
    this.favoritesService,
    this.initialQuery,
    this.appBarTitle,
  });

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocus = FocusNode();

  List<SearchResult> _results = [];
  bool _isLoading = false;
  bool _hasMore = false;
  String? _errorMessage;
  int _currentPage = 1;
  SearchQuery? _currentQuery;
  Set<String> _favoriteUrls = {};

  @override
  void initState() {
    super.initState();
    if (widget.initialQuery != null) {
      _searchController.text = widget.initialQuery!;
      _performSearch();
    }
    _loadFavorites();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocus.dispose();
    super.dispose();
  }

  Future<void> _loadFavorites() async {
    if (widget.favoritesService == null) return;

    final favorites = await widget.favoritesService!.getAll();
    setState(() {
      _favoriteUrls = favorites.map((f) => f.url).toSet();
    });
  }

  Future<void> _performSearch({bool loadMore = false}) async {
    final query = _searchController.text.trim();
    if (query.isEmpty) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
      if (!loadMore) {
        _results = [];
        _currentPage = 1;
      }
    });

    try {
      final searchQuery = SearchQuery(
        query: query,
        page: loadMore ? _currentPage + 1 : 1,
        resultsPerPage: 10,
      );

      final response = await widget.searchService.search(searchQuery);

      setState(() {
        if (loadMore) {
          _results.addAll(response.results);
          _currentPage++;
        } else {
          _results = response.results;
          _currentPage = 1;
        }
        _hasMore = response.hasMore;
        _currentQuery = searchQuery;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Search failed: ${e.toString()}';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _toggleFavorite(SearchResult result) async {
    if (widget.favoritesService == null) return;

    try {
      final isFavorite = await widget.favoritesService!.toggle(result);

      setState(() {
        if (isFavorite) {
          _favoriteUrls.add(result.url);
        } else {
          _favoriteUrls.remove(result.url);
        }
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              isFavorite
                  ? 'Added to favorites'
                  : 'Removed from favorites',
            ),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}')),
        );
      }
    }
  }

  void _openResult(SearchResult result) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => WebViewScreen(
          url: result.url,
          title: result.title,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: widget.appBarTitle ?? const Text('Web Search'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(64),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: _buildSearchBar(),
          ),
        ),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildSearchBar() {
    return TextField(
      controller: _searchController,
      focusNode: _searchFocus,
      decoration: InputDecoration(
        hintText: 'Search the web...',
        prefixIcon: const Icon(Icons.search),
        suffixIcon: _searchController.text.isNotEmpty
            ? IconButton(
                icon: const Icon(Icons.clear),
                onPressed: () {
                  _searchController.clear();
                  setState(() {
                    _results = [];
                    _errorMessage = null;
                  });
                },
              )
            : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        filled: true,
        fillColor: Colors.white,
      ),
      textInputAction: TextInputAction.search,
      onSubmitted: (_) => _performSearch(),
      onChanged: (value) => setState(() {}),
    );
  }

  Widget _buildBody() {
    if (_isLoading && _results.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_errorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              Text(
                _errorMessage!,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _performSearch,
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    if (_results.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              'Enter a search query to get started',
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
          ],
        ),
      );
    }

    return SearchResultsList(
      results: _results,
      hasMore: _hasMore,
      isLoading: _isLoading,
      onLoadMore: () => _performSearch(loadMore: true),
      onResultTap: _openResult,
      onFavoriteToggle: _toggleFavorite,
      favoriteUrls: _favoriteUrls,
    );
  }
}
