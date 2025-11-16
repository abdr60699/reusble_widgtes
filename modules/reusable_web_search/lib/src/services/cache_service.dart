import 'dart:convert';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/models.dart';

/// Service for caching search results with TTL (Time To Live)
class CacheService {
  static const String _cacheBoxName = 'search_cache';
  Box<CachedSearchResult>? _cacheBox;

  /// Default TTL in minutes (60 minutes = 1 hour)
  final int defaultTtlMinutes;

  /// Maximum cache size (number of items)
  final int maxCacheSize;

  CacheService({
    this.defaultTtlMinutes = 60,
    this.maxCacheSize = 100,
  });

  /// Initialize the cache service
  Future<void> initialize() async {
    if (_cacheBox != null && _cacheBox!.isOpen) return;

    await Hive.initFlutter();

    // Register adapters if not already registered
    if (!Hive.isAdapterRegistered(2)) {
      Hive.registerAdapter(CachedSearchResultAdapter());
    }

    _cacheBox = await Hive.openBox<CachedSearchResult>(_cacheBoxName);

    // Clean up expired entries on initialization
    await _cleanExpiredEntries();
  }

  /// Generate a cache key from a search query
  String _generateCacheKey(SearchQuery query) {
    final keyData = {
      'query': query.query,
      'site': query.siteFilter,
      'safe': query.safeSearch.name,
      'lang': query.language,
      'region': query.region,
      'page': query.page,
      'perPage': query.resultsPerPage,
    };
    return base64Encode(utf8.encode(jsonEncode(keyData)));
  }

  /// Get cached search response
  Future<SearchResponse?> get(SearchQuery query) async {
    await _ensureInitialized();

    final key = _generateCacheKey(query);
    final cached = _cacheBox!.get(key);

    if (cached == null) return null;

    // Check if expired
    if (cached.isExpired) {
      await _cacheBox!.delete(key);
      return null;
    }

    try {
      final responseJson = jsonDecode(cached.responseJson) as Map<String, dynamic>;
      return SearchResponse.fromJson(responseJson);
    } catch (e) {
      // Invalid cache entry, delete it
      await _cacheBox!.delete(key);
      return null;
    }
  }

  /// Cache a search response
  Future<void> put(
    SearchQuery query,
    SearchResponse response, {
    int? ttlMinutes,
  }) async {
    await _ensureInitialized();

    final key = _generateCacheKey(query);
    final cached = CachedSearchResult(
      query: query.query,
      responseJson: jsonEncode(response.toJson()),
      cachedAt: DateTime.now(),
      ttlMinutes: ttlMinutes ?? defaultTtlMinutes,
      cacheKey: key,
    );

    await _cacheBox!.put(key, cached);

    // Enforce max cache size
    if (_cacheBox!.length > maxCacheSize) {
      await _evictOldest();
    }
  }

  /// Check if a query is cached and not expired
  Future<bool> has(SearchQuery query) async {
    await _ensureInitialized();

    final key = _generateCacheKey(query);
    final cached = _cacheBox!.get(key);

    if (cached == null) return false;
    if (cached.isExpired) {
      await _cacheBox!.delete(key);
      return false;
    }

    return true;
  }

  /// Clear all cached entries
  Future<void> clear() async {
    await _ensureInitialized();
    await _cacheBox!.clear();
  }

  /// Clear expired entries
  Future<void> clearExpired() async {
    await _ensureInitialized();
    await _cleanExpiredEntries();
  }

  /// Get cache statistics
  Future<CacheStats> getStats() async {
    await _ensureInitialized();

    final entries = _cacheBox!.values.toList();
    final expired = entries.where((e) => e.isExpired).length;
    final valid = entries.length - expired;

    int totalSize = 0;
    for (final entry in entries) {
      totalSize += entry.responseJson.length;
    }

    return CacheStats(
      totalEntries: entries.length,
      validEntries: valid,
      expiredEntries: expired,
      totalSizeBytes: totalSize,
      maxCacheSize: maxCacheSize,
    );
  }

  /// Evict oldest entries to maintain max cache size
  Future<void> _evictOldest() async {
    final entries = _cacheBox!.toMap().entries.toList();

    // Sort by cached time (oldest first)
    entries.sort((a, b) => a.value.cachedAt.compareTo(b.value.cachedAt));

    // Remove oldest entries until we're under the limit
    final toRemove = entries.length - maxCacheSize;
    for (var i = 0; i < toRemove && i < entries.length; i++) {
      await _cacheBox!.delete(entries[i].key);
    }
  }

  /// Clean up expired entries
  Future<void> _cleanExpiredEntries() async {
    final expiredKeys = <String>[];

    for (final entry in _cacheBox!.toMap().entries) {
      if (entry.value.isExpired) {
        expiredKeys.add(entry.key as String);
      }
    }

    for (final key in expiredKeys) {
      await _cacheBox!.delete(key);
    }
  }

  /// Ensure the service is initialized
  Future<void> _ensureInitialized() async {
    if (_cacheBox == null || !_cacheBox!.isOpen) {
      await initialize();
    }
  }

  /// Dispose resources
  Future<void> dispose() async {
    await _cacheBox?.close();
  }
}

/// Cache statistics
class CacheStats {
  final int totalEntries;
  final int validEntries;
  final int expiredEntries;
  final int totalSizeBytes;
  final int maxCacheSize;

  const CacheStats({
    required this.totalEntries,
    required this.validEntries,
    required this.expiredEntries,
    required this.totalSizeBytes,
    required this.maxCacheSize,
  });

  double get utilizationPercent =>
      maxCacheSize > 0 ? (totalEntries / maxCacheSize) * 100 : 0;

  String get totalSizeFormatted {
    if (totalSizeBytes < 1024) return '$totalSizeBytes B';
    if (totalSizeBytes < 1024 * 1024) {
      return '${(totalSizeBytes / 1024).toStringAsFixed(2)} KB';
    }
    return '${(totalSizeBytes / (1024 * 1024)).toStringAsFixed(2)} MB';
  }
}

/// Hive adapter for CachedSearchResult
class CachedSearchResultAdapter extends TypeAdapter<CachedSearchResult> {
  @override
  final int typeId = 2;

  @override
  CachedSearchResult read(BinaryReader reader) {
    return CachedSearchResult(
      query: reader.readString(),
      responseJson: reader.readString(),
      cachedAt: DateTime.fromMillisecondsSinceEpoch(reader.readInt()),
      ttlMinutes: reader.readInt(),
      cacheKey: reader.readString(),
    );
  }

  @override
  void write(BinaryWriter writer, CachedSearchResult obj) {
    writer.writeString(obj.query);
    writer.writeString(obj.responseJson);
    writer.writeInt(obj.cachedAt.millisecondsSinceEpoch);
    writer.writeInt(obj.ttlMinutes);
    writer.writeString(obj.cacheKey);
  }
}
