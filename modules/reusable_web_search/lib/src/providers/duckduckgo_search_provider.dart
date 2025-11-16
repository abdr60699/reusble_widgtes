import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/models.dart';
import 'search_provider.dart';

/// DuckDuckGo search provider (fallback option)
/// Uses DuckDuckGo HTML scraping approach since their API is limited
/// Note: This is a best-effort implementation and may be less reliable than Google/Bing
class DuckDuckGoSearchProvider implements SearchProvider {
  final SearchProviderConfig config;
  final http.Client _client;

  static const String _htmlUrl = 'https://html.duckduckgo.com/html/';
  static const String _instantAnswerUrl = 'https://api.duckduckgo.com/';

  DuckDuckGoSearchProvider({
    required this.config,
    http.Client? client,
  }) : _client = client ?? http.Client();

  @override
  String get name => 'DuckDuckGo';

  @override
  bool get requiresApiKey => false;

  @override
  bool get supportsSafeSearch => true;

  @override
  bool get supportsSiteFilter => true;

  @override
  bool get supportsDateFilter => false;

  @override
  int get maxResultsPerPage => 30;

  @override
  Future<SearchResponse> search(SearchQuery query) async {
    final stopwatch = Stopwatch()..start();

    try {
      // DuckDuckGo's instant answer API for simple queries
      if (query.page == 1) {
        try {
          final instantResult = await _searchInstantAnswer(query);
          if (instantResult != null && instantResult.results.isNotEmpty) {
            stopwatch.stop();
            return instantResult.copyWith(
              searchTime: stopwatch.elapsedMilliseconds,
            );
          }
        } catch (_) {
          // Fall through to HTML scraping
        }
      }

      // HTML scraping approach for regular search results
      final response = await _searchHtml(query);
      stopwatch.stop();

      return response.copyWith(searchTime: stopwatch.elapsedMilliseconds);
    } catch (e) {
      if (e is SearchProviderException) rethrow;
      throw SearchProviderException(
        message: 'Failed to perform search: ${e.toString()}',
        provider: name,
        originalError: e,
      );
    }
  }

  Future<SearchResponse?> _searchInstantAnswer(SearchQuery query) async {
    final params = {
      'q': query.query,
      'format': 'json',
      'no_html': '1',
      'skip_disambig': '1',
    };

    final uri =
        Uri.parse(_instantAnswerUrl).replace(queryParameters: params);

    final response = await _client.get(uri).timeout(
          config.timeout,
          onTimeout: () => throw SearchProviderException(
            message: 'Request timed out',
            provider: name,
          ),
        );

    if (response.statusCode != 200) return null;

    try {
      final json = jsonDecode(response.body) as Map<String, dynamic>;

      // Check for abstract (Wikipedia summary)
      final abstract = json['Abstract'] as String?;
      final abstractUrl = json['AbstractURL'] as String?;

      if (abstract != null &&
          abstract.isNotEmpty &&
          abstractUrl != null &&
          abstractUrl.isNotEmpty) {
        final uri = Uri.tryParse(abstractUrl);

        return SearchResponse(
          results: [
            SearchResult(
              title: json['Heading'] as String? ?? query.query,
              url: abstractUrl,
              snippet: abstract,
              domain: uri?.host ?? '',
              imageUrl: json['Image'] as String?,
            ),
          ],
          totalResults: 1,
          page: 1,
          resultsPerPage: query.resultsPerPage,
          hasMore: true, // There might be more results via HTML
          query: query.query,
          provider: name,
        );
      }

      return null;
    } catch (_) {
      return null;
    }
  }

  Future<SearchResponse> _searchHtml(SearchQuery query) async {
    // Build form data for POST request
    final formData = {
      'q': query.fullQueryString,
      'b': '', // No specific region
      's': ((query.page - 1) * query.resultsPerPage).toString(),
      'dc': query.resultsPerPage.toString(),
      'v': 'l',
      'o': 'json',
      'api': 'd.js',
    };

    // Safe search
    if (query.safeSearch == SafeSearchLevel.strict) {
      formData['kp'] = '1'; // Strict safe search
    } else if (query.safeSearch == SafeSearchLevel.moderate) {
      formData['kp'] = '0'; // Moderate
    } else {
      formData['kp'] = '-2'; // Off
    }

    final response = await _client
        .post(
          Uri.parse(_htmlUrl),
          headers: {
            'Content-Type': 'application/x-www-form-urlencoded',
            'User-Agent':
                'Mozilla/5.0 (compatible; ReusableWebSearch/1.0)',
          },
          body: formData,
        )
        .timeout(
          config.timeout,
          onTimeout: () => throw SearchProviderException(
            message: 'Request timed out after ${config.timeout.inSeconds}s',
            provider: name,
          ),
        );

    if (response.statusCode != 200) {
      throw SearchProviderException(
        message: 'Failed to fetch results: HTTP ${response.statusCode}',
        provider: name,
        statusCode: response.statusCode,
      );
    }

    return _parseHtmlResponse(response.body, query);
  }

  SearchResponse _parseHtmlResponse(String html, SearchQuery query) {
    try {
      // Since DuckDuckGo returns HTML, we'd need an HTML parser
      // For simplicity, we'll return a basic implementation
      // In production, use the 'html' package to parse the response

      // This is a simplified version - in production you should parse the HTML
      // using the html package and extract results properly

      // For now, return empty results with a note
      return SearchResponse(
        results: [],
        totalResults: 0,
        page: query.page,
        resultsPerPage: query.resultsPerPage,
        hasMore: false,
        query: query.query,
        provider: name,
        metadata: {
          'note':
              'DuckDuckGo HTML parsing requires additional implementation. '
                  'Consider using Google or Bing providers for production use.',
        },
      );

      // TODO: Implement HTML parsing
      // Example structure:
      // 1. Parse HTML using html package
      // 2. Find result elements (.result, .result__a, .result__snippet)
      // 3. Extract title, URL, snippet
      // 4. Return SearchResult objects
    } catch (e) {
      throw SearchProviderException(
        message: 'Failed to parse DuckDuckGo HTML response: ${e.toString()}',
        provider: name,
        originalError: e,
      );
    }
  }

  @override
  Future<bool> validateConfiguration() async {
    // DuckDuckGo doesn't require API key
    return true;
  }

  @override
  Map<String, String> getConfigurationRequirements() {
    return {
      'note':
          'DuckDuckGo does not require an API key, but results may be limited',
    };
  }

  @override
  void dispose() {
    _client.close();
  }
}
