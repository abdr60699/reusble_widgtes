import 'package:equatable/equatable.dart';
import 'search_result.dart';

/// Response from a search provider
class SearchResponse extends Equatable {
  /// List of search results
  final List<SearchResult> results;

  /// Total number of results (if available)
  final int? totalResults;

  /// Current page number
  final int page;

  /// Results per page
  final int resultsPerPage;

  /// Whether there are more results available
  final bool hasMore;

  /// The query that was executed
  final String query;

  /// Time taken to execute the search (in milliseconds)
  final int? searchTime;

  /// Provider name (e.g., "Google", "Bing", "DuckDuckGo")
  final String provider;

  /// Additional metadata from the provider
  final Map<String, dynamic>? metadata;

  const SearchResponse({
    required this.results,
    this.totalResults,
    required this.page,
    required this.resultsPerPage,
    required this.hasMore,
    required this.query,
    this.searchTime,
    required this.provider,
    this.metadata,
  });

  /// Create a copy with updated fields
  SearchResponse copyWith({
    List<SearchResult>? results,
    int? totalResults,
    int? page,
    int? resultsPerPage,
    bool? hasMore,
    String? query,
    int? searchTime,
    String? provider,
    Map<String, dynamic>? metadata,
  }) {
    return SearchResponse(
      results: results ?? this.results,
      totalResults: totalResults ?? this.totalResults,
      page: page ?? this.page,
      resultsPerPage: resultsPerPage ?? this.resultsPerPage,
      hasMore: hasMore ?? this.hasMore,
      query: query ?? this.query,
      searchTime: searchTime ?? this.searchTime,
      provider: provider ?? this.provider,
      metadata: metadata ?? this.metadata,
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'results': results.map((r) => r.toJson()).toList(),
      'totalResults': totalResults,
      'page': page,
      'resultsPerPage': resultsPerPage,
      'hasMore': hasMore,
      'query': query,
      'searchTime': searchTime,
      'provider': provider,
      'metadata': metadata,
    };
  }

  /// Create from JSON
  factory SearchResponse.fromJson(Map<String, dynamic> json) {
    return SearchResponse(
      results: (json['results'] as List)
          .map((r) => SearchResult.fromJson(r as Map<String, dynamic>))
          .toList(),
      totalResults: json['totalResults'] as int?,
      page: json['page'] as int,
      resultsPerPage: json['resultsPerPage'] as int,
      hasMore: json['hasMore'] as bool,
      query: json['query'] as String,
      searchTime: json['searchTime'] as int?,
      provider: json['provider'] as String,
      metadata: json['metadata'] as Map<String, dynamic>?,
    );
  }

  @override
  List<Object?> get props => [
        results,
        totalResults,
        page,
        resultsPerPage,
        hasMore,
        query,
        searchTime,
        provider,
        metadata,
      ];
}
