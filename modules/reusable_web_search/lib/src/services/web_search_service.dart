import '../models/models.dart';
import '../providers/search_provider.dart';
import 'cache_service.dart';
import 'history_service.dart';
import 'metadata_fetcher.dart';
import 'readability_service.dart';

/// Main service that orchestrates web search functionality
/// Coordinates search providers, caching, history, and metadata fetching
class WebSearchService {
  final SearchProvider provider;
  final CacheService? cacheService;
  final HistoryService? historyService;
  final MetadataFetcher? metadataFetcher;
  final ReadabilityService? readabilityService;

  /// Whether to enable caching
  final bool enableCaching;

  /// Whether to track search history
  final bool enableHistory;

  WebSearchService({
    required this.provider,
    this.cacheService,
    this.historyService,
    this.metadataFetcher,
    this.readabilityService,
    this.enableCaching = true,
    this.enableHistory = true,
  });

  /// Initialize all services
  Future<void> initialize() async {
    if (enableCaching && cacheService != null) {
      await cacheService!.initialize();
    }

    if (enableHistory && historyService != null) {
      await historyService!.initialize();
    }
  }

  /// Perform a search
  Future<SearchResponse> search(SearchQuery query) async {
    // Check cache first
    if (enableCaching && cacheService != null) {
      final cached = await cacheService!.get(query);
      if (cached != null) {
        return cached;
      }
    }

    // Perform the search
    final response = await provider.search(query);

    // Cache the results
    if (enableCaching && cacheService != null && response.results.isNotEmpty) {
      await cacheService!.put(query, response);
    }

    // Add to history
    if (enableHistory && historyService != null) {
      await historyService!.add(
        query,
        resultCount: response.results.length,
      );
    }

    return response;
  }

  /// Fetch metadata for a search result
  Future<OpenGraphData?> fetchMetadata(String url) async {
    if (metadataFetcher == null) return null;
    return await metadataFetcher!.fetchMetadata(url);
  }

  /// Extract readable content from a URL
  Future<ReadableContent?> extractContent(String url) async {
    if (readabilityService == null) return null;
    return await readabilityService!.extractContent(url);
  }

  /// Enrich search results with metadata
  Future<List<SearchResult>> enrichResults(
    List<SearchResult> results, {
    bool fetchMetadata = false,
  }) async {
    if (!fetchMetadata || metadataFetcher == null) {
      return results;
    }

    final enriched = <SearchResult>[];

    for (final result in results) {
      if (result.openGraph == null) {
        final metadata = await this.fetchMetadata(result.url);
        enriched.add(result.copyWith(openGraph: metadata));
      } else {
        enriched.add(result);
      }
    }

    return enriched;
  }

  /// Dispose resources
  Future<void> dispose() async {
    provider.dispose();
    await cacheService?.dispose();
    await historyService?.dispose();
    metadataFetcher?.dispose();
    readabilityService?.dispose();
  }
}
