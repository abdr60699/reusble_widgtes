import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/models.dart';
import 'search_provider.dart';

/// Bing Web Search API provider
/// Requires API key from Azure Cognitive Services
/// Documentation: https://learn.microsoft.com/en-us/bing/search-apis/bing-web-search/overview
class BingSearchProvider implements SearchProvider {
  final SearchProviderConfig config;
  final http.Client _client;

  static const String _baseUrl = 'https://api.bing.microsoft.com/v7.0/search';

  BingSearchProvider({
    required this.config,
    http.Client? client,
  }) : _client = client ?? http.Client();

  @override
  String get name => 'Bing';

  @override
  bool get requiresApiKey => true;

  @override
  bool get supportsSafeSearch => true;

  @override
  bool get supportsSiteFilter => true;

  @override
  bool get supportsDateFilter => true;

  @override
  int get maxResultsPerPage => 50;

  @override
  Future<SearchResponse> search(SearchQuery query) async {
    final stopwatch = Stopwatch()..start();

    try {
      // Validate configuration
      await validateConfiguration();

      // Build query parameters
      final params = _buildQueryParams(query);

      // Make the API request
      final uri = Uri.parse(config.customEndpoint ?? _baseUrl)
          .replace(queryParameters: params);

      final response = await _client.get(
        uri,
        headers: {
          'Ocp-Apim-Subscription-Key': config.apiKey!,
        },
      ).timeout(config.timeout, onTimeout: () {
        throw SearchProviderException(
          message: 'Request timed out after ${config.timeout.inSeconds}s',
          provider: name,
        );
      });

      stopwatch.stop();

      // Handle response
      if (response.statusCode == 200) {
        return _parseResponse(
          response.body,
          query,
          stopwatch.elapsedMilliseconds,
        );
      } else {
        throw SearchProviderException(
          message: _getErrorMessage(response.statusCode, response.body),
          provider: name,
          statusCode: response.statusCode,
        );
      }
    } catch (e) {
      if (e is SearchProviderException) rethrow;
      throw SearchProviderException(
        message: 'Failed to perform search: ${e.toString()}',
        provider: name,
        originalError: e,
      );
    }
  }

  Map<String, String> _buildQueryParams(SearchQuery query) {
    final params = <String, String>{
      'q': query.fullQueryString,
      'count': query.resultsPerPage.clamp(1, maxResultsPerPage).toString(),
      'offset': ((query.page - 1) * query.resultsPerPage).toString(),
      'responseFilter': 'Webpages',
      'textDecorations': 'false',
      'textFormat': 'Raw',
    };

    // Safe search
    switch (query.safeSearch) {
      case SafeSearchLevel.off:
        params['safeSearch'] = 'Off';
        break;
      case SafeSearchLevel.moderate:
        params['safeSearch'] = 'Moderate';
        break;
      case SafeSearchLevel.strict:
        params['safeSearch'] = 'Strict';
        break;
    }

    // Language
    if (query.language != null) {
      params['setLang'] = query.language!;
    }

    // Market/Region
    if (query.region != null) {
      params['mkt'] = '${query.language ?? 'en'}-${query.region!.toUpperCase()}';
    }

    // Date freshness
    if (query.dateRange != null) {
      params['freshness'] = _getFreshness(query.dateRange!);
    }

    return params;
  }

  String _getFreshness(DateRangeFilter dateRange) {
    if (dateRange.preset != null) {
      switch (dateRange.preset!) {
        case DateRangePreset.pastHour:
        case DateRangePreset.past24Hours:
          return 'Day';
        case DateRangePreset.pastWeek:
          return 'Week';
        case DateRangePreset.pastMonth:
          return 'Month';
        case DateRangePreset.pastYear:
          return 'Year';
      }
    }
    return 'Month';
  }

  SearchResponse _parseResponse(
    String body,
    SearchQuery query,
    int searchTime,
  ) {
    try {
      final json = jsonDecode(body) as Map<String, dynamic>;
      final webPages = json['webPages'] as Map<String, dynamic>?;

      if (webPages == null) {
        return SearchResponse(
          results: [],
          totalResults: 0,
          page: query.page,
          resultsPerPage: query.resultsPerPage,
          hasMore: false,
          query: query.query,
          searchTime: searchTime,
          provider: name,
        );
      }

      final values = webPages['value'] as List?;
      if (values == null || values.isEmpty) {
        return SearchResponse(
          results: [],
          totalResults: webPages['totalEstimatedMatches'] as int? ?? 0,
          page: query.page,
          resultsPerPage: query.resultsPerPage,
          hasMore: false,
          query: query.query,
          searchTime: searchTime,
          provider: name,
        );
      }

      final results = values.map((item) {
        final itemMap = item as Map<String, dynamic>;
        final url = itemMap['url'] as String;
        final uri = Uri.tryParse(url);

        return SearchResult(
          title: itemMap['name'] as String? ?? '',
          url: url,
          snippet: itemMap['snippet'] as String? ?? '',
          domain: uri?.host ?? itemMap['displayUrl'] as String? ?? '',
          imageUrl: _getImageUrl(itemMap),
          publishedDate: _getPublishedDate(itemMap),
          metadata: {
            'displayUrl': itemMap['displayUrl'],
            'dateLastCrawled': itemMap['dateLastCrawled'],
            'language': itemMap['language'],
          },
        );
      }).toList();

      final totalResults = webPages['totalEstimatedMatches'] as int?;

      return SearchResponse(
        results: results,
        totalResults: totalResults,
        page: query.page,
        resultsPerPage: query.resultsPerPage,
        hasMore: totalResults != null &&
            (query.page * query.resultsPerPage) < totalResults,
        query: query.query,
        searchTime: searchTime,
        provider: name,
        metadata: {
          'webSearchUrl': webPages['webSearchUrl'],
        },
      );
    } catch (e) {
      throw SearchProviderException(
        message: 'Failed to parse Bing search response: ${e.toString()}',
        provider: name,
        originalError: e,
      );
    }
  }

  String? _getImageUrl(Map<String, dynamic> item) {
    // Bing doesn't provide thumbnails in the basic response
    // Would need to enable Bing Image Search or parse the page
    return null;
  }

  DateTime? _getPublishedDate(Map<String, dynamic> item) {
    final dateStr = item['dateLastCrawled'] as String?;
    if (dateStr != null) {
      try {
        return DateTime.parse(dateStr);
      } catch (_) {
        return null;
      }
    }
    return null;
  }

  String _getErrorMessage(int statusCode, String body) {
    try {
      final json = jsonDecode(body) as Map<String, dynamic>;
      final errors = json['errors'] as List?;
      if (errors != null && errors.isNotEmpty) {
        final error = errors.first as Map<String, dynamic>;
        return error['message'] as String? ?? 'Unknown error';
      }
    } catch (_) {
      // Failed to parse error, use default message
    }

    switch (statusCode) {
      case 400:
        return 'Bad request - check your query parameters';
      case 401:
        return 'Invalid API key';
      case 403:
        return 'Access forbidden - check your subscription';
      case 429:
        return 'Rate limit exceeded';
      case 500:
      case 503:
        return 'Bing API service error';
      default:
        return 'HTTP error $statusCode';
    }
  }

  @override
  Future<bool> validateConfiguration() async {
    if (config.apiKey == null || config.apiKey!.isEmpty) {
      throw SearchProviderException(
        message: 'Bing API key is required',
        provider: name,
      );
    }

    return true;
  }

  @override
  Map<String, String> getConfigurationRequirements() {
    return {
      'apiKey':
          'Azure Cognitive Services Bing Search API key from portal.azure.com',
    };
  }

  @override
  void dispose() {
    _client.close();
  }
}
