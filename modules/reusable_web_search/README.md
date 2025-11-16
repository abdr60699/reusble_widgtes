# Reusable Web Search

A production-ready, plug-and-play Flutter package for in-app web search with support for multiple search providers, caching, history, favorites, and rich metadata extraction.

## Features

### Core Functionality
- **Multiple Search Providers**: Google Custom Search, Bing Web Search API, DuckDuckGo
- **Plugin Architecture**: Easy to swap providers or implement custom search APIs
- **Safe Search & Filtering**: Configurable safe search levels and content filtering
- **Site-Specific Search**: Filter results by domain
- **Advanced Filters**: Date range, language, region, file type filters

### Rich Results Display
- **Metadata Extraction**: Title, snippet, URL, favicon, Open Graph images
- **Published Dates**: Display when content was published
- **Domain Display**: Clean domain extraction and display
- **Thumbnails**: Open Graph and Twitter Card image support

### Content Features
- **In-App WebView**: Browse results without leaving the app
- **Open Graph/Twitter Card**: Fetch rich preview metadata
- **Readability Extraction**: Extract main content from web pages
- **Content Preview**: Display readable summaries

### User Features
- **Pagination/Infinite Scroll**: Load more results seamlessly
- **Caching with TTL**: Cache search results with configurable expiry
- **Search History**: Track recent searches
- **Favorites/Bookmarks**: Save results for later
- **Share Actions**: Share results via platform share sheet
- **Copy/Open Actions**: Copy URL or open in external browser

### Developer Features
- **Comprehensive Tests**: Unit and widget tests included
- **Type-Safe**: Full type safety with null safety
- **Documented**: Extensive documentation and examples
- **Customizable UI**: All widgets can be customized or replaced

## Installation

Add this to your package's `pubspec.yaml` file:

```yaml
dependencies:
  reusable_web_search: ^1.0.0
```

Then run:

```bash
flutter pub get
```

## Quick Start

### 1. Set Up Search Provider

#### Google Custom Search (Recommended)

1. Get API Key from [Google Cloud Console](https://console.cloud.google.com/)
   - Enable "Custom Search API"
   - Create API credentials

2. Create a Custom Search Engine at [programmablesearchengine.google.com](https://programmablesearchengine.google.com/)
   - Get your Search Engine ID

```dart
final googleProvider = GoogleSearchProvider(
  config: SearchProviderConfig(
    apiKey: 'YOUR_GOOGLE_API_KEY',
    searchEngineId: 'YOUR_SEARCH_ENGINE_ID',
  ),
);
```

#### Bing Web Search

1. Get API Key from [Azure Portal](https://portal.azure.com/)
   - Create Bing Search API resource
   - Get subscription key

```dart
final bingProvider = BingSearchProvider(
  config: SearchProviderConfig(
    apiKey: 'YOUR_BING_API_KEY',
  ),
);
```

#### DuckDuckGo (No API Key Required)

```dart
final duckDuckGoProvider = DuckDuckGoSearchProvider(
  config: const SearchProviderConfig(),
);
```

### 2. Initialize Services

```dart
// Initialize cache service
final cacheService = CacheService(
  defaultTtlMinutes: 60,
  maxCacheSize: 100,
);
await cacheService.initialize();

// Initialize history service
final historyService = HistoryService(
  maxHistorySize: 100,
);
await historyService.initialize();

// Initialize favorites service
final favoritesService = FavoritesService();
await favoritesService.initialize();

// Create main search service
final searchService = WebSearchService(
  provider: googleProvider, // or bingProvider, duckDuckGoProvider
  cacheService: cacheService,
  historyService: historyService,
  metadataFetcher: MetadataFetcher(),
  readabilityService: ReadabilityService(),
);

await searchService.initialize();
```

### 3. Use the Search UI

The simplest way to use the package is with the built-in `SearchScreen`:

```dart
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => SearchScreen(
      searchService: searchService,
      favoritesService: favoritesService,
    ),
  ),
);
```

### 4. Or Build Your Own UI

```dart
// Perform a search
final query = SearchQuery(
  query: 'flutter development',
  safeSearch: SafeSearchLevel.moderate,
  resultsPerPage: 10,
);

final response = await searchService.search(query);

// Display results
for (final result in response.results) {
  print('${result.title} - ${result.url}');
}
```

## Advanced Usage

### Custom Search Filters

```dart
final query = SearchQuery(
  query: 'flutter',
  siteFilter: 'flutter.dev', // Only from flutter.dev
  safeSearch: SafeSearchLevel.strict,
  language: 'en',
  region: 'us',
  resultsPerPage: 20,
  dateRange: DateRangeFilter(
    preset: DateRangePreset.pastMonth,
  ),
  fileType: 'pdf', // Only PDF files
);
```

### Fetch Metadata

```dart
final metadata = await searchService.fetchMetadata('https://example.com');
print('Title: ${metadata?.title}');
print('Description: ${metadata?.description}');
print('Image: ${metadata?.image}');
```

### Extract Readable Content

```dart
final content = await searchService.extractContent('https://example.com');
print('Title: ${content?.title}');
print('Author: ${content?.author}');
print('Reading time: ${content?.readingTimeMinutes} minutes');
print('Content: ${content?.content}');
```

### Manage Favorites

```dart
// Add to favorites
await favoritesService.add(
  searchResult,
  tags: ['flutter', 'development'],
  notes: 'Great tutorial',
);

// Check if favorited
final isFavorite = await favoritesService.isFavorite(url);

// Get all favorites
final favorites = await favoritesService.getAll();

// Search favorites
final results = await favoritesService.search('flutter');

// Export favorites
final json = await favoritesService.exportAsJson();
```

### Custom UI Components

Use individual widgets to build your own search interface:

```dart
SearchResultCard(
  result: searchResult,
  onTap: () => navigateToWebView(result.url),
  onFavorite: () => toggleFavorite(result),
  isFavorite: true,
)
```

```dart
SearchResultsList(
  results: results,
  hasMore: true,
  onLoadMore: () => loadNextPage(),
  onResultTap: (result) => openResult(result),
  onFavoriteToggle: (result) => toggleFavorite(result),
)
```

## API Reference

See [API Documentation](docs/API.md) for complete API reference.

## Privacy & Terms of Service

**IMPORTANT**: By using this package, you are subject to the terms and privacy policies of the search provider you choose:

- **Google Custom Search**: [Terms of Service](https://policies.google.com/terms), [Privacy Policy](https://policies.google.com/privacy)
- **Bing Web Search**: [Terms of Service](https://www.microsoft.com/en-us/servicesagreement), [Privacy Policy](https://privacy.microsoft.com/privacystatement)
- **DuckDuckGo**: [Terms of Service](https://duckduckgo.com/terms), [Privacy Policy](https://duckduckgo.com/privacy)

### Data Collection

This package stores the following data **locally** on the user's device:
- Search query history
- Favorited/bookmarked results
- Cached search responses

**No data is transmitted to any third party except:**
- Search queries sent to the selected search provider API
- Web page requests for metadata/content extraction

See [PRIVACY.md](PRIVACY.md) for full privacy details.

## Testing

The package includes comprehensive tests:

```bash
# Run all tests
flutter test

# Run specific test file
flutter test test/services/cache_service_test.dart
```

## Examples

See the [example](example/) directory for a complete working app demonstrating all features.

## Requirements

- Flutter SDK: >=3.10.0
- Dart SDK: >=3.0.0

## Platform Support

- ✅ Android
- ✅ iOS
- ✅ Web
- ✅ macOS
- ✅ Windows
- ✅ Linux

## Contributing

Contributions are welcome! Please read our [Contributing Guide](CONTRIBUTING.md) first.

## License

This package is licensed under the MIT License. See [LICENSE](LICENSE) for details.

## Credits

- Developed for use in reusable Flutter widget libraries
- Uses Mozilla's Readability algorithm for content extraction
- Favicon service courtesy of Google

## Support

- File issues at: [GitHub Issues](https://github.com/abdr60699/reusable_widgets/issues)
- For questions: Create a discussion on GitHub

## Changelog

See [CHANGELOG.md](CHANGELOG.md) for release notes.

## Roadmap

- [ ] Additional search providers (Yahoo, Yandex, etc.)
- [ ] Advanced filtering UI
- [ ] Search suggestions/autocomplete
- [ ] Voice search integration
- [ ] Offline mode improvements
- [ ] Analytics integration

## FAQ

### Q: Do I need an API key?

A: Google and Bing require API keys. DuckDuckGo does not but has limited features.

### Q: Is there a free tier?

A: Google Custom Search offers 100 queries/day free. Bing offers 1000 queries/month free on the basic tier.

### Q: Can I use my own search backend?

A: Yes! Implement the `SearchProvider` interface to create a custom provider.

### Q: Does this work offline?

A: The cache service allows previously searched queries to work offline, but new searches require internet.

### Q: Is the WebView secure?

A: The WebView uses platform security features. Always validate URLs before opening.

## Troubleshooting

### "Invalid API Key" error

- Verify your API key is correct
- Ensure the API is enabled in your cloud console
- Check for any usage restrictions

### "Quota exceeded" error

- You've exceeded your daily/monthly API quota
- Upgrade your API plan or wait for quota reset

### Search returns no results

- Check your search query
- Verify safe search and filter settings
- Ensure the search engine configuration is correct

## Performance Tips

1. **Enable Caching**: Reduces API calls and improves response time
2. **Adjust TTL**: Balance between fresh results and cache hits
3. **Limit Results**: Request only what you need per page
4. **Use Pagination**: Don't load all results at once
5. **Preload Metadata**: Fetch Open Graph data for visible results only

---

**Made with ❤️ for the Flutter community**
