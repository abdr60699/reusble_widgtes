import 'package:equatable/equatable.dart';

/// Represents a single search result
class SearchResult extends Equatable {
  /// The title of the search result
  final String title;

  /// The URL of the search result
  final String url;

  /// A brief snippet/description of the result
  final String snippet;

  /// The domain of the URL (e.g., "example.com")
  final String domain;

  /// URL to the favicon or Open Graph image
  final String? imageUrl;

  /// Published or last modified date (if available)
  final DateTime? publishedDate;

  /// Open Graph metadata (if fetched)
  final OpenGraphData? openGraph;

  /// Unique identifier for the result
  final String id;

  /// Additional metadata
  final Map<String, dynamic>? metadata;

  const SearchResult({
    required this.title,
    required this.url,
    required this.snippet,
    required this.domain,
    this.imageUrl,
    this.publishedDate,
    this.openGraph,
    String? id,
    this.metadata,
  }) : id = id ?? url;

  /// Create a copy with updated fields
  SearchResult copyWith({
    String? title,
    String? url,
    String? snippet,
    String? domain,
    String? imageUrl,
    DateTime? publishedDate,
    OpenGraphData? openGraph,
    String? id,
    Map<String, dynamic>? metadata,
  }) {
    return SearchResult(
      title: title ?? this.title,
      url: url ?? this.url,
      snippet: snippet ?? this.snippet,
      domain: domain ?? this.domain,
      imageUrl: imageUrl ?? this.imageUrl,
      publishedDate: publishedDate ?? this.publishedDate,
      openGraph: openGraph ?? this.openGraph,
      id: id ?? this.id,
      metadata: metadata ?? this.metadata,
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'url': url,
      'snippet': snippet,
      'domain': domain,
      'imageUrl': imageUrl,
      'publishedDate': publishedDate?.toIso8601String(),
      'openGraph': openGraph?.toJson(),
      'id': id,
      'metadata': metadata,
    };
  }

  /// Create from JSON
  factory SearchResult.fromJson(Map<String, dynamic> json) {
    return SearchResult(
      title: json['title'] as String,
      url: json['url'] as String,
      snippet: json['snippet'] as String,
      domain: json['domain'] as String,
      imageUrl: json['imageUrl'] as String?,
      publishedDate: json['publishedDate'] != null
          ? DateTime.parse(json['publishedDate'] as String)
          : null,
      openGraph: json['openGraph'] != null
          ? OpenGraphData.fromJson(json['openGraph'] as Map<String, dynamic>)
          : null,
      id: json['id'] as String?,
      metadata: json['metadata'] as Map<String, dynamic>?,
    );
  }

  @override
  List<Object?> get props => [
        title,
        url,
        snippet,
        domain,
        imageUrl,
        publishedDate,
        openGraph,
        id,
        metadata,
      ];
}

/// Open Graph metadata for rich previews
class OpenGraphData extends Equatable {
  final String? title;
  final String? description;
  final String? image;
  final String? siteName;
  final String? type;
  final String? url;

  /// Twitter Card data
  final String? twitterCard;
  final String? twitterTitle;
  final String? twitterDescription;
  final String? twitterImage;

  const OpenGraphData({
    this.title,
    this.description,
    this.image,
    this.siteName,
    this.type,
    this.url,
    this.twitterCard,
    this.twitterTitle,
    this.twitterDescription,
    this.twitterImage,
  });

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'image': image,
      'siteName': siteName,
      'type': type,
      'url': url,
      'twitterCard': twitterCard,
      'twitterTitle': twitterTitle,
      'twitterDescription': twitterDescription,
      'twitterImage': twitterImage,
    };
  }

  factory OpenGraphData.fromJson(Map<String, dynamic> json) {
    return OpenGraphData(
      title: json['title'] as String?,
      description: json['description'] as String?,
      image: json['image'] as String?,
      siteName: json['siteName'] as String?,
      type: json['type'] as String?,
      url: json['url'] as String?,
      twitterCard: json['twitterCard'] as String?,
      twitterTitle: json['twitterTitle'] as String?,
      twitterDescription: json['twitterDescription'] as String?,
      twitterImage: json['twitterImage'] as String?,
    );
  }

  @override
  List<Object?> get props => [
        title,
        description,
        image,
        siteName,
        type,
        url,
        twitterCard,
        twitterTitle,
        twitterDescription,
        twitterImage,
      ];
}
