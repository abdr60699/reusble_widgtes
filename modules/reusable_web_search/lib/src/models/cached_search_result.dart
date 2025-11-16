import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';
import 'search_response.dart';

part 'cached_search_result.g.dart';

/// Cached search response with TTL
@HiveType(typeId: 2)
class CachedSearchResult extends Equatable {
  @HiveField(0)
  final String query;

  @HiveField(1)
  final String responseJson;

  @HiveField(2)
  final DateTime cachedAt;

  @HiveField(3)
  final int ttlMinutes;

  @HiveField(4)
  final String cacheKey;

  const CachedSearchResult({
    required this.query,
    required this.responseJson,
    required this.cachedAt,
    required this.ttlMinutes,
    required this.cacheKey,
  });

  /// Check if the cache has expired
  bool get isExpired {
    final expiryTime = cachedAt.add(Duration(minutes: ttlMinutes));
    return DateTime.now().isAfter(expiryTime);
  }

  /// Get remaining TTL in minutes
  int get remainingTtlMinutes {
    if (isExpired) return 0;
    final expiryTime = cachedAt.add(Duration(minutes: ttlMinutes));
    return expiryTime.difference(DateTime.now()).inMinutes;
  }

  Map<String, dynamic> toJson() {
    return {
      'query': query,
      'responseJson': responseJson,
      'cachedAt': cachedAt.toIso8601String(),
      'ttlMinutes': ttlMinutes,
      'cacheKey': cacheKey,
    };
  }

  factory CachedSearchResult.fromJson(Map<String, dynamic> json) {
    return CachedSearchResult(
      query: json['query'] as String,
      responseJson: json['responseJson'] as String,
      cachedAt: DateTime.parse(json['cachedAt'] as String),
      ttlMinutes: json['ttlMinutes'] as int,
      cacheKey: json['cacheKey'] as String,
    );
  }

  @override
  List<Object?> get props =>
      [query, responseJson, cachedAt, ttlMinutes, cacheKey];
}
