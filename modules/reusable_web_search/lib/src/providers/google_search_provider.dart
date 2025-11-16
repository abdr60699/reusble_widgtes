import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/models.dart';
import 'search_provider.dart';

/// Google Custom Search API provider
/// Requires API key and Custom Search Engine ID from Google Cloud Console
/// Documentation: https://developers.google.com/custom-search/v1/overview
class GoogleSearchProvider implements SearchProvider {
  final SearchProviderConfig config;
  final http.Client _client;

  static const String _baseUrl =
      'https://www.googleapis.com/customsearch/v1';

  GoogleSearchProvider({
    required this.config,
    http.Client? client,
  }) : _client = client ?? http.Client();

  @override
  String get name => 'Google';

  @override
  bool get requiresApiKey => true;

  @override
  bool get supportsSafeSearch => true;

  @override
  bool get supportsSiteFilter => true;

  @override
  bool get supportsDateFilter => true;

  @override
  int get maxResultsPerPage => 10;

  @override
  Future<SearchResponse> search(SearchQuery query) async {
    final stopwatch = Stopwatch()..start();

    try {
      // Validate configuration
      await validateConfiguration();

      // Build query parameters
      final params = _buildQueryParams(query);

      // Make the API request
      final uri = Uri.parse(_baseUrl).replace(queryParameters: params);
      final response = await _client
          .get(uri)
          .timeout(config.timeout, onTimeout: () {
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
      'key': config.apiKey!,
      'cx': config.searchEngineId!,
      'q': query.fullQueryString,
      'num': query.resultsPerPage.clamp(1, maxResultsPerPage).toString(),
      'start': ((query.page - 1) * query.resultsPerPage + 1).toString(),
    };

    // Safe search
    if (query.safeSearch != SafeSearchLevel.off) {
      params['safe'] = query.safeSearch == SafeSearchLevel.strict
          ? 'active'
          : 'medium';
    }

    // Language
    if (query.language != null) {
      params['lr'] = 'lang_${query.language}';
    }

    // Region
    if (query.region != null) {
      params['cr'] = 'country${query.region!.toUpperCase()}';
    }

    // Date filter
    if (query.dateRange != null) {
      params['dateRestrict'] = _getDateRestrict(query.dateRange!);
    }

    // File type
    if (query.fileType != null) {
      params['fileType'] = query.fileType!;
    }

    return params;
  }

  String _getDateRestrict(DateRangeFilter dateRange) {
    if (dateRange.preset != null) {
      switch (dateRange.preset!) {
        case DateRangePreset.pastHour:
          return 'h1';
        case DateRangePreset.past24Hours:
          return 'd1';
        case DateRangePreset.pastWeek:
          return 'w1';
        case DateRangePreset.pastMonth:
          return 'm1';
        case DateRangePreset.pastYear:
          return 'y1';
      }
    }
    // Custom date range not directly supported by Google API
    return 'd7'; // Default to past week
  }

  SearchResponse _parseResponse(
    String body,
    SearchQuery query,
    int searchTime,
  ) {
    try {
      final json = jsonDecode(body) as Map<String, dynamic>;
      final items = json['items'] as List?;

      if (items == null || items.isEmpty) {
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

      final results = items.map((item) {
        final itemMap = item as Map<String, dynamic>;
        final url = itemMap['link'] as String;
        final uri = Uri.tryParse(url);

        return SearchResult(
          title: itemMap['title'] as String? ?? '',
          url: url,
          snippet: itemMap['snippet'] as String? ?? '',
          domain: uri?.host ?? '',
          imageUrl: _getImageUrl(itemMap),
          publishedDate: _getPublishedDate(itemMap),
          metadata: {
            'displayLink': itemMap['displayLink'],
            'cacheId': itemMap['cacheId'],
            'formattedUrl': itemMap['formattedUrl'],
          },
        );
      }).toList();

      final searchInfo = json['searchInformation'] as Map<String, dynamic>?;
      final totalResults = searchInfo?['totalResults'] != null
          ? int.tryParse(searchInfo!['totalResults'] as String)
          : null;

      return SearchResponse(
        results: results,
        totalResults: totalResults,
        page: query.page,
        resultsPerPage: query.resultsPerPage,
        hasMore: results.length >= query.resultsPerPage,
        query: query.query,
        searchTime: searchTime,
        provider: name,
        metadata: {
          'searchTime': searchInfo?['searchTime'],
          'formattedSearchTime': searchInfo?['formattedSearchTime'],
        },
      );
    } catch (e) {
      throw SearchProviderException(
        message: 'Failed to parse Google search response: ${e.toString()}',
        provider: name,
        originalError: e,
      );
    }
  }

  String? _getImageUrl(Map<String, dynamic> item) {
    final pagemap = item['pagemap'] as Map<String, dynamic>?;
    if (pagemap == null) return null;

    // Try to get Open Graph image
    final metatags = pagemap['metatags'] as List?;
    if (metatags != null && metatags.isNotEmpty) {
      final meta = metatags.first as Map<String, dynamic>;
      if (meta['og:image'] != null) {
        return meta['og:image'] as String;
      }
    }

    // Try to get thumbnail
    final thumbnails = pagemap['cse_thumbnail'] as List?;
    if (thumbnails != null && thumbnails.isNotEmpty) {
      final thumb = thumbnails.first as Map<String, dynamic>;
      return thumb['src'] as String?;
    }

    return null;
  }

  DateTime? _getPublishedDate(Map<String, dynamic> item) {
    final pagemap = item['pagemap'] as Map<String, dynamic>?;
    if (pagemap == null) return null;

    final metatags = pagemap['metatags'] as List?;
    if (metatags != null && metatags.isNotEmpty) {
      final meta = metatags.first as Map<String, dynamic>;
      final dateStr = meta['article:published_time'] as String? ??
          meta['datePublished'] as String?;

      if (dateStr != null) {
        try {
          return DateTime.parse(dateStr);
        } catch (_) {
          return null;
        }
      }
    }

    return null;
  }

  String _getErrorMessage(int statusCode, String body) {
    try {
      final json = jsonDecode(body) as Map<String, dynamic>;
      final error = json['error'] as Map<String, dynamic>?;
      if (error != null) {
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
        return 'Quota exceeded or access forbidden';
      case 404:
        return 'Invalid Search Engine ID';
      case 429:
        return 'Rate limit exceeded';
      case 500:
      case 503:
        return 'Google API service error';
      default:
        return 'HTTP error $statusCode';
    }
  }

  @override
  Future<bool> validateConfiguration() async {
    if (config.apiKey == null || config.apiKey!.isEmpty) {
      throw SearchProviderException(
        message: 'Google API key is required',
        provider: name,
      );
    }

    if (config.searchEngineId == null || config.searchEngineId!.isEmpty) {
      throw SearchProviderException(
        message: 'Google Custom Search Engine ID is required',
        provider: name,
      );
    }

    return true;
  }

  @override
  Map<String, String> getConfigurationRequirements() {
    return {
      'apiKey': 'Google Cloud API key with Custom Search API enabled',
      'searchEngineId':
          'Custom Search Engine ID from programmablesearchengine.google.com',
    };
  }

  @override
  void dispose() {
    _client.close();
  }
}
