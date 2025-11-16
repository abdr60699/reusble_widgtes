import 'package:hive_flutter/hive_flutter.dart';
import '../models/models.dart';

/// Service for managing search history
class HistoryService {
  static const String _historyBoxName = 'search_history';
  Box<SearchHistoryItem>? _historyBox;

  /// Maximum number of history items to keep
  final int maxHistorySize;

  HistoryService({
    this.maxHistorySize = 100,
  });

  /// Initialize the history service
  Future<void> initialize() async {
    if (_historyBox != null && _historyBox!.isOpen) return;

    await Hive.initFlutter();

    // Register adapters if not already registered
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(SearchHistoryItemAdapter());
    }

    _historyBox = await Hive.openBox<SearchHistoryItem>(_historyBoxName);
  }

  /// Add a search query to history
  Future<void> add(SearchQuery query, {int resultCount = 0}) async {
    await _ensureInitialized();

    final item = SearchHistoryItem(
      query: query.query,
      timestamp: DateTime.now(),
      siteFilter: query.siteFilter,
      resultCount: resultCount,
    );

    // Check if this query already exists (to avoid duplicates)
    final existing = _historyBox!.values
        .where((h) => h.query.toLowerCase() == query.query.toLowerCase())
        .toList();

    // Remove existing entries for this query
    for (final existingItem in existing) {
      final key = _historyBox!.keys.firstWhere(
        (k) => (_historyBox!.get(k) as SearchHistoryItem).id == existingItem.id,
      );
      await _historyBox!.delete(key);
    }

    // Add the new entry
    await _historyBox!.add(item);

    // Enforce max history size
    if (_historyBox!.length > maxHistorySize) {
      await _evictOldest();
    }
  }

  /// Get all history items
  Future<List<SearchHistoryItem>> getAll({int? limit}) async {
    await _ensureInitialized();

    final items = _historyBox!.values.toList();

    // Sort by timestamp (most recent first)
    items.sort((a, b) => b.timestamp.compareTo(a.timestamp));

    if (limit != null && limit > 0 && items.length > limit) {
      return items.sublist(0, limit);
    }

    return items;
  }

  /// Search history by query text
  Future<List<SearchHistoryItem>> search(String queryText) async {
    await _ensureInitialized();

    final items = _historyBox!.values
        .where((item) =>
            item.query.toLowerCase().contains(queryText.toLowerCase()))
        .toList();

    // Sort by timestamp (most recent first)
    items.sort((a, b) => b.timestamp.compareTo(a.timestamp));

    return items;
  }

  /// Get recent history items
  Future<List<SearchHistoryItem>> getRecent({int limit = 10}) async {
    return getAll(limit: limit);
  }

  /// Delete a history item by ID
  Future<void> delete(String id) async {
    await _ensureInitialized();

    final key = _historyBox!.keys.firstWhere(
      (k) => (_historyBox!.get(k) as SearchHistoryItem).id == id,
      orElse: () => null,
    );

    if (key != null) {
      await _historyBox!.delete(key);
    }
  }

  /// Clear all history
  Future<void> clear() async {
    await _ensureInitialized();
    await _historyBox!.clear();
  }

  /// Delete history older than specified days
  Future<void> deleteOlderThan(int days) async {
    await _ensureInitialized();

    final cutoffDate = DateTime.now().subtract(Duration(days: days));
    final toDelete = <dynamic>[];

    for (final entry in _historyBox!.toMap().entries) {
      if (entry.value.timestamp.isBefore(cutoffDate)) {
        toDelete.add(entry.key);
      }
    }

    for (final key in toDelete) {
      await _historyBox!.delete(key);
    }
  }

  /// Get history statistics
  Future<HistoryStats> getStats() async {
    await _ensureInitialized();

    final items = _historyBox!.values.toList();
    if (items.isEmpty) {
      return const HistoryStats(
        totalQueries: 0,
        uniqueQueries: 0,
        oldestQuery: null,
        newestQuery: null,
      );
    }

    final uniqueQueries =
        items.map((i) => i.query.toLowerCase()).toSet().length;

    items.sort((a, b) => a.timestamp.compareTo(b.timestamp));
    final oldest = items.first.timestamp;
    final newest = items.last.timestamp;

    return HistoryStats(
      totalQueries: items.length,
      uniqueQueries: uniqueQueries,
      oldestQuery: oldest,
      newestQuery: newest,
    );
  }

  /// Evict oldest entries to maintain max history size
  Future<void> _evictOldest() async {
    final entries = _historyBox!.toMap().entries.toList();

    // Sort by timestamp (oldest first)
    entries.sort((a, b) => a.value.timestamp.compareTo(b.value.timestamp));

    // Remove oldest entries until we're under the limit
    final toRemove = entries.length - maxHistorySize;
    for (var i = 0; i < toRemove && i < entries.length; i++) {
      await _historyBox!.delete(entries[i].key);
    }
  }

  /// Ensure the service is initialized
  Future<void> _ensureInitialized() async {
    if (_historyBox == null || !_historyBox!.isOpen) {
      await initialize();
    }
  }

  /// Dispose resources
  Future<void> dispose() async {
    await _historyBox?.close();
  }
}

/// History statistics
class HistoryStats {
  final int totalQueries;
  final int uniqueQueries;
  final DateTime? oldestQuery;
  final DateTime? newestQuery;

  const HistoryStats({
    required this.totalQueries,
    required this.uniqueQueries,
    this.oldestQuery,
    this.newestQuery,
  });
}

/// Hive adapter for SearchHistoryItem
class SearchHistoryItemAdapter extends TypeAdapter<SearchHistoryItem> {
  @override
  final int typeId = 0;

  @override
  SearchHistoryItem read(BinaryReader reader) {
    return SearchHistoryItem(
      query: reader.readString(),
      timestamp: DateTime.fromMillisecondsSinceEpoch(reader.readInt()),
      siteFilter: reader.readString(),
      resultCount: reader.readInt(),
      id: reader.readString(),
    );
  }

  @override
  void write(BinaryWriter writer, SearchHistoryItem obj) {
    writer.writeString(obj.query);
    writer.writeInt(obj.timestamp.millisecondsSinceEpoch);
    writer.writeString(obj.siteFilter ?? '');
    writer.writeInt(obj.resultCount);
    writer.writeString(obj.id);
  }
}
