import 'package:equatable/equatable.dart';

/// Represents a search query with filters and options
class SearchQuery extends Equatable {
  /// The search query string
  final String query;

  /// Optional site-specific search (e.g., "site:stackoverflow.com")
  final String? siteFilter;

  /// Safe search level
  final SafeSearchLevel safeSearch;

  /// Language filter (e.g., "en", "es")
  final String? language;

  /// Country/region filter (e.g., "us", "uk")
  final String? region;

  /// Number of results per page
  final int resultsPerPage;

  /// Current page number (for pagination)
  final int page;

  /// Date range filter
  final DateRangeFilter? dateRange;

  /// File type filter (e.g., "pdf", "doc")
  final String? fileType;

  /// Additional custom parameters
  final Map<String, dynamic>? customParams;

  const SearchQuery({
    required this.query,
    this.siteFilter,
    this.safeSearch = SafeSearchLevel.moderate,
    this.language,
    this.region,
    this.resultsPerPage = 10,
    this.page = 1,
    this.dateRange,
    this.fileType,
    this.customParams,
  });

  /// Create a copy with updated fields
  SearchQuery copyWith({
    String? query,
    String? siteFilter,
    SafeSearchLevel? safeSearch,
    String? language,
    String? region,
    int? resultsPerPage,
    int? page,
    DateRangeFilter? dateRange,
    String? fileType,
    Map<String, dynamic>? customParams,
  }) {
    return SearchQuery(
      query: query ?? this.query,
      siteFilter: siteFilter ?? this.siteFilter,
      safeSearch: safeSearch ?? this.safeSearch,
      language: language ?? this.language,
      region: region ?? this.region,
      resultsPerPage: resultsPerPage ?? this.resultsPerPage,
      page: page ?? this.page,
      dateRange: dateRange ?? this.dateRange,
      fileType: fileType ?? this.fileType,
      customParams: customParams ?? this.customParams,
    );
  }

  /// Get the full query string with filters
  String get fullQueryString {
    final parts = <String>[query];

    if (siteFilter != null && siteFilter!.isNotEmpty) {
      parts.add('site:$siteFilter');
    }

    if (fileType != null && fileType!.isNotEmpty) {
      parts.add('filetype:$fileType');
    }

    return parts.join(' ');
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'query': query,
      'siteFilter': siteFilter,
      'safeSearch': safeSearch.name,
      'language': language,
      'region': region,
      'resultsPerPage': resultsPerPage,
      'page': page,
      'dateRange': dateRange?.toJson(),
      'fileType': fileType,
      'customParams': customParams,
    };
  }

  /// Create from JSON
  factory SearchQuery.fromJson(Map<String, dynamic> json) {
    return SearchQuery(
      query: json['query'] as String,
      siteFilter: json['siteFilter'] as String?,
      safeSearch: SafeSearchLevel.values.firstWhere(
        (e) => e.name == json['safeSearch'],
        orElse: () => SafeSearchLevel.moderate,
      ),
      language: json['language'] as String?,
      region: json['region'] as String?,
      resultsPerPage: json['resultsPerPage'] as int? ?? 10,
      page: json['page'] as int? ?? 1,
      dateRange: json['dateRange'] != null
          ? DateRangeFilter.fromJson(json['dateRange'] as Map<String, dynamic>)
          : null,
      fileType: json['fileType'] as String?,
      customParams: json['customParams'] as Map<String, dynamic>?,
    );
  }

  @override
  List<Object?> get props => [
        query,
        siteFilter,
        safeSearch,
        language,
        region,
        resultsPerPage,
        page,
        dateRange,
        fileType,
        customParams,
      ];
}

/// Safe search filtering levels
enum SafeSearchLevel {
  off,
  moderate,
  strict,
}

/// Date range filter for search results
class DateRangeFilter extends Equatable {
  final DateTime? startDate;
  final DateTime? endDate;
  final DateRangePreset? preset;

  const DateRangeFilter({
    this.startDate,
    this.endDate,
    this.preset,
  });

  Map<String, dynamic> toJson() {
    return {
      'startDate': startDate?.toIso8601String(),
      'endDate': endDate?.toIso8601String(),
      'preset': preset?.name,
    };
  }

  factory DateRangeFilter.fromJson(Map<String, dynamic> json) {
    return DateRangeFilter(
      startDate: json['startDate'] != null
          ? DateTime.parse(json['startDate'] as String)
          : null,
      endDate: json['endDate'] != null
          ? DateTime.parse(json['endDate'] as String)
          : null,
      preset: json['preset'] != null
          ? DateRangePreset.values.firstWhere(
              (e) => e.name == json['preset'],
            )
          : null,
    );
  }

  @override
  List<Object?> get props => [startDate, endDate, preset];
}

/// Preset date ranges
enum DateRangePreset {
  pastHour,
  past24Hours,
  pastWeek,
  pastMonth,
  pastYear,
}
