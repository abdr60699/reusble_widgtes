import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';
import 'search_result.dart';

part 'favorite_item.g.dart';

/// Represents a bookmarked/favorited search result
@HiveType(typeId: 1)
class FavoriteItem extends Equatable {
  @HiveField(0)
  final String title;

  @HiveField(1)
  final String url;

  @HiveField(2)
  final String snippet;

  @HiveField(3)
  final String domain;

  @HiveField(4)
  final String? imageUrl;

  @HiveField(5)
  final DateTime addedAt;

  @HiveField(6)
  final String id;

  @HiveField(7)
  final List<String>? tags;

  @HiveField(8)
  final String? notes;

  const FavoriteItem({
    required this.title,
    required this.url,
    required this.snippet,
    required this.domain,
    this.imageUrl,
    required this.addedAt,
    String? id,
    this.tags,
    this.notes,
  }) : id = id ?? url;

  /// Create from SearchResult
  factory FavoriteItem.fromSearchResult(
    SearchResult result, {
    List<String>? tags,
    String? notes,
  }) {
    return FavoriteItem(
      title: result.title,
      url: result.url,
      snippet: result.snippet,
      domain: result.domain,
      imageUrl: result.imageUrl,
      addedAt: DateTime.now(),
      id: result.id,
      tags: tags,
      notes: notes,
    );
  }

  /// Convert to SearchResult
  SearchResult toSearchResult() {
    return SearchResult(
      title: title,
      url: url,
      snippet: snippet,
      domain: domain,
      imageUrl: imageUrl,
      id: id,
    );
  }

  FavoriteItem copyWith({
    String? title,
    String? url,
    String? snippet,
    String? domain,
    String? imageUrl,
    DateTime? addedAt,
    String? id,
    List<String>? tags,
    String? notes,
  }) {
    return FavoriteItem(
      title: title ?? this.title,
      url: url ?? this.url,
      snippet: snippet ?? this.snippet,
      domain: domain ?? this.domain,
      imageUrl: imageUrl ?? this.imageUrl,
      addedAt: addedAt ?? this.addedAt,
      id: id ?? this.id,
      tags: tags ?? this.tags,
      notes: notes ?? this.notes,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'url': url,
      'snippet': snippet,
      'domain': domain,
      'imageUrl': imageUrl,
      'addedAt': addedAt.toIso8601String(),
      'id': id,
      'tags': tags,
      'notes': notes,
    };
  }

  factory FavoriteItem.fromJson(Map<String, dynamic> json) {
    return FavoriteItem(
      title: json['title'] as String,
      url: json['url'] as String,
      snippet: json['snippet'] as String,
      domain: json['domain'] as String,
      imageUrl: json['imageUrl'] as String?,
      addedAt: DateTime.parse(json['addedAt'] as String),
      id: json['id'] as String?,
      tags: (json['tags'] as List?)?.cast<String>(),
      notes: json['notes'] as String?,
    );
  }

  @override
  List<Object?> get props => [
        title,
        url,
        snippet,
        domain,
        imageUrl,
        addedAt,
        id,
        tags,
        notes,
      ];
}
