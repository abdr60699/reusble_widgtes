import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';

part 'search_history_item.g.dart';

/// Represents a search history entry
@HiveType(typeId: 0)
class SearchHistoryItem extends Equatable {
  @HiveField(0)
  final String query;

  @HiveField(1)
  final DateTime timestamp;

  @HiveField(2)
  final String? siteFilter;

  @HiveField(3)
  final int resultCount;

  @HiveField(4)
  final String id;

  SearchHistoryItem({
    required this.query,
    required this.timestamp,
    this.siteFilter,
    this.resultCount = 0,
    String? id,
  }) : id = id ?? '${query}_${timestamp.millisecondsSinceEpoch}';

  Map<String, dynamic> toJson() {
    return {
      'query': query,
      'timestamp': timestamp.toIso8601String(),
      'siteFilter': siteFilter,
      'resultCount': resultCount,
      'id': id,
    };
  }

  factory SearchHistoryItem.fromJson(Map<String, dynamic> json) {
    return SearchHistoryItem(
      query: json['query'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      siteFilter: json['siteFilter'] as String?,
      resultCount: json['resultCount'] as int? ?? 0,
      id: json['id'] as String?,
    );
  }

  @override
  List<Object?> get props => [query, timestamp, siteFilter, resultCount, id];
}
