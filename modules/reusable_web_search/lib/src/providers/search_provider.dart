import '../models/models.dart';

/// Abstract interface for search providers
/// Allows swapping between Google, Bing, DuckDuckGo, or custom implementations
abstract class SearchProvider {
  /// The name of this provider (e.g., "Google", "Bing", "DuckDuckGo")
  String get name;

  /// Whether this provider requires an API key
  bool get requiresApiKey;

  /// Whether this provider supports safe search filtering
  bool get supportsSafeSearch;

  /// Whether this provider supports site-specific search
  bool get supportsSiteFilter;

  /// Whether this provider supports date range filtering
  bool get supportsDateFilter;

  /// Maximum results per page supported by this provider
  int get maxResultsPerPage;

  /// Perform a search with the given query
  /// Returns a [SearchResponse] containing the results
  /// Throws [SearchProviderException] on error
  Future<SearchResponse> search(SearchQuery query);

  /// Validate the provider configuration
  /// Returns true if the provider is properly configured
  /// Throws [SearchProviderException] if configuration is invalid
  Future<bool> validateConfiguration();

  /// Get the provider's configuration requirements
  /// Returns a map of required configuration keys and their descriptions
  Map<String, String> getConfigurationRequirements();

  /// Dispose resources
  void dispose() {}
}

/// Exception thrown by search providers
class SearchProviderException implements Exception {
  final String message;
  final String? provider;
  final int? statusCode;
  final dynamic originalError;

  const SearchProviderException({
    required this.message,
    this.provider,
    this.statusCode,
    this.originalError,
  });

  @override
  String toString() {
    final parts = ['SearchProviderException: $message'];
    if (provider != null) parts.add('Provider: $provider');
    if (statusCode != null) parts.add('Status: $statusCode');
    return parts.join(', ');
  }
}

/// Configuration for a search provider
class SearchProviderConfig {
  final String? apiKey;
  final String? searchEngineId;
  final String? customEndpoint;
  final Map<String, dynamic>? additionalParams;
  final Duration timeout;
  final int maxRetries;

  const SearchProviderConfig({
    this.apiKey,
    this.searchEngineId,
    this.customEndpoint,
    this.additionalParams,
    this.timeout = const Duration(seconds: 30),
    this.maxRetries = 3,
  });

  SearchProviderConfig copyWith({
    String? apiKey,
    String? searchEngineId,
    String? customEndpoint,
    Map<String, dynamic>? additionalParams,
    Duration? timeout,
    int? maxRetries,
  }) {
    return SearchProviderConfig(
      apiKey: apiKey ?? this.apiKey,
      searchEngineId: searchEngineId ?? this.searchEngineId,
      customEndpoint: customEndpoint ?? this.customEndpoint,
      additionalParams: additionalParams ?? this.additionalParams,
      timeout: timeout ?? this.timeout,
      maxRetries: maxRetries ?? this.maxRetries,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'apiKey': apiKey,
      'searchEngineId': searchEngineId,
      'customEndpoint': customEndpoint,
      'additionalParams': additionalParams,
      'timeout': timeout.inMilliseconds,
      'maxRetries': maxRetries,
    };
  }

  factory SearchProviderConfig.fromJson(Map<String, dynamic> json) {
    return SearchProviderConfig(
      apiKey: json['apiKey'] as String?,
      searchEngineId: json['searchEngineId'] as String?,
      customEndpoint: json['customEndpoint'] as String?,
      additionalParams: json['additionalParams'] as Map<String, dynamic>?,
      timeout: Duration(milliseconds: json['timeout'] as int? ?? 30000),
      maxRetries: json['maxRetries'] as int? ?? 3,
    );
  }
}
