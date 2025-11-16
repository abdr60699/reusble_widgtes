import 'package:flutter/material.dart';
import 'package:reusable_web_search/reusable_web_search.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Web Search Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late WebSearchService _searchService;
  late FavoritesService _favoritesService;
  late HistoryService _historyService;
  late CacheService _cacheService;

  bool _isInitialized = false;
  String _selectedProvider = 'Google';

  @override
  void initState() {
    super.initState();
    _initializeServices();
  }

  Future<void> _initializeServices() async {
    // Initialize services
    _cacheService = CacheService();
    _historyService = HistoryService();
    _favoritesService = FavoritesService();

    await _cacheService.initialize();
    await _historyService.initialize();
    await _favoritesService.initialize();

    // Configure search provider
    // IMPORTANT: Replace with your actual API keys!
    final config = SearchProviderConfig(
      apiKey: 'YOUR_GOOGLE_API_KEY_HERE',
      searchEngineId: 'YOUR_SEARCH_ENGINE_ID_HERE',
    );

    final provider = GoogleSearchProvider(config: config);

    _searchService = WebSearchService(
      provider: provider,
      cacheService: _cacheService,
      historyService: _historyService,
      metadataFetcher: MetadataFetcher(),
      readabilityService: ReadabilityService(),
    );

    await _searchService.initialize();

    setState(() {
      _isInitialized = true;
    });
  }

  void _changeProvider(String providerName) {
    setState(() {
      _selectedProvider = providerName;
    });

    SearchProvider provider;

    switch (providerName) {
      case 'Google':
        provider = GoogleSearchProvider(
          config: SearchProviderConfig(
            apiKey: 'YOUR_GOOGLE_API_KEY_HERE',
            searchEngineId: 'YOUR_SEARCH_ENGINE_ID_HERE',
          ),
        );
        break;
      case 'Bing':
        provider = BingSearchProvider(
          config: SearchProviderConfig(
            apiKey: 'YOUR_BING_API_KEY_HERE',
          ),
        );
        break;
      case 'DuckDuckGo':
        provider = DuckDuckGoSearchProvider(
          config: const SearchProviderConfig(),
        );
        break;
      default:
        provider = DuckDuckGoSearchProvider(
          config: const SearchProviderConfig(),
        );
    }

    _searchService = WebSearchService(
      provider: provider,
      cacheService: _cacheService,
      historyService: _historyService,
      metadataFetcher: MetadataFetcher(),
      readabilityService: ReadabilityService(),
    );
  }

  @override
  void dispose() {
    _searchService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized) {
      return Scaffold(
        appBar: AppBar(title: const Text('Web Search Example')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Web Search Example'),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.swap_horiz),
            tooltip: 'Change Provider',
            onSelected: _changeProvider,
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'Google',
                child: Text('Google Search'),
              ),
              const PopupMenuItem(
                value: 'Bing',
                child: Text('Bing Search'),
              ),
              const PopupMenuItem(
                value: 'DuckDuckGo',
                child: Text('DuckDuckGo'),
              ),
            ],
          ),
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () => _showHistory(),
            tooltip: 'Search History',
          ),
          IconButton(
            icon: const Icon(Icons.bookmark),
            onPressed: () => _showFavorites(),
            tooltip: 'Favorites',
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.blue[50],
            child: Column(
              children: [
                Text(
                  'Current Provider: $_selectedProvider',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                Text(
                  'Note: Configure API keys in main.dart for full functionality',
                  style: Theme.of(context).textTheme.bodySmall,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          Expanded(
            child: SearchScreen(
              searchService: _searchService,
              favoritesService: _favoritesService,
              appBarTitle: const Text('Search'),
            ),
          ),
        ],
      ),
    );
  }

  void _showHistory() async {
    final history = await _historyService.getRecent(limit: 20);

    if (!mounted) return;

    showModalBottomSheet(
      context: context,
      builder: (context) => ListView.builder(
        itemCount: history.length,
        itemBuilder: (context, index) {
          final item = history[index];
          return ListTile(
            leading: const Icon(Icons.history),
            title: Text(item.query),
            subtitle: Text('${item.resultCount} results'),
            trailing: Text(
              _formatDate(item.timestamp),
              style: Theme.of(context).textTheme.bodySmall,
            ),
            onTap: () {
              Navigator.pop(context);
              // Navigate to search with this query
            },
          );
        },
      ),
    );
  }

  void _showFavorites() async {
    final favorites = await _favoritesService.getAll();

    if (!mounted) return;

    showModalBottomSheet(
      context: context,
      builder: (context) => ListView.builder(
        itemCount: favorites.length,
        itemBuilder: (context, index) {
          final item = favorites[index];
          return ListTile(
            leading: const Icon(Icons.bookmark),
            title: Text(item.title),
            subtitle: Text(item.domain),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => WebViewScreen(
                    url: item.url,
                    title: item.title,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);

    if (diff.inMinutes < 60) {
      return '${diff.inMinutes}m ago';
    } else if (diff.inHours < 24) {
      return '${diff.inHours}h ago';
    } else if (diff.inDays < 7) {
      return '${diff.inDays}d ago';
    } else {
      return '${(diff.inDays / 7).floor()}w ago';
    }
  }
}
