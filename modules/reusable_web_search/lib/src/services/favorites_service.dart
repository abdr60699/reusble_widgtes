import 'dart:convert';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/models.dart';

/// Service for managing favorite/bookmarked search results
class FavoritesService {
  static const String _favoritesBoxName = 'search_favorites';
  Box<FavoriteItem>? _favoritesBox;

  /// Initialize the favorites service
  Future<void> initialize() async {
    if (_favoritesBox != null && _favoritesBox!.isOpen) return;

    await Hive.initFlutter();

    // Register adapters if not already registered
    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(FavoriteItemAdapter());
    }

    _favoritesBox = await Hive.openBox<FavoriteItem>(_favoritesBoxName);
  }

  /// Add a search result to favorites
  Future<void> add(
    SearchResult result, {
    List<String>? tags,
    String? notes,
  }) async {
    await _ensureInitialized();

    // Check if already exists
    if (await isFavorite(result.url)) {
      throw FavoritesException('This item is already in favorites');
    }

    final favorite = FavoriteItem.fromSearchResult(
      result,
      tags: tags,
      notes: notes,
    );

    await _favoritesBox!.add(favorite);
  }

  /// Remove a favorite by URL
  Future<void> remove(String url) async {
    await _ensureInitialized();

    final key = _favoritesBox!.keys.firstWhere(
      (k) => (_favoritesBox!.get(k) as FavoriteItem).url == url,
      orElse: () => null,
    );

    if (key != null) {
      await _favoritesBox!.delete(key);
    }
  }

  /// Toggle favorite status
  Future<bool> toggle(
    SearchResult result, {
    List<String>? tags,
    String? notes,
  }) async {
    await _ensureInitialized();

    if (await isFavorite(result.url)) {
      await remove(result.url);
      return false;
    } else {
      await add(result, tags: tags, notes: notes);
      return true;
    }
  }

  /// Check if a URL is favorited
  Future<bool> isFavorite(String url) async {
    await _ensureInitialized();

    return _favoritesBox!.values.any((f) => f.url == url);
  }

  /// Get all favorites
  Future<List<FavoriteItem>> getAll({String? sortBy}) async {
    await _ensureInitialized();

    final items = _favoritesBox!.values.toList();

    // Sort by specified field
    switch (sortBy) {
      case 'title':
        items.sort((a, b) => a.title.compareTo(b.title));
        break;
      case 'domain':
        items.sort((a, b) => a.domain.compareTo(b.domain));
        break;
      case 'oldest':
        items.sort((a, b) => a.addedAt.compareTo(b.addedAt));
        break;
      case 'newest':
      default:
        items.sort((a, b) => b.addedAt.compareTo(a.addedAt));
        break;
    }

    return items;
  }

  /// Get favorites by tag
  Future<List<FavoriteItem>> getByTag(String tag) async {
    await _ensureInitialized();

    final items = _favoritesBox!.values
        .where((f) => f.tags != null && f.tags!.contains(tag))
        .toList();

    // Sort by most recent
    items.sort((a, b) => b.addedAt.compareTo(a.addedAt));

    return items;
  }

  /// Search favorites
  Future<List<FavoriteItem>> search(String query) async {
    await _ensureInitialized();

    final lowerQuery = query.toLowerCase();
    final items = _favoritesBox!.values.where((f) {
      return f.title.toLowerCase().contains(lowerQuery) ||
          f.snippet.toLowerCase().contains(lowerQuery) ||
          f.url.toLowerCase().contains(lowerQuery) ||
          (f.tags != null &&
              f.tags!.any((t) => t.toLowerCase().contains(lowerQuery))) ||
          (f.notes != null && f.notes!.toLowerCase().contains(lowerQuery));
    }).toList();

    // Sort by most recent
    items.sort((a, b) => b.addedAt.compareTo(a.addedAt));

    return items;
  }

  /// Update a favorite's tags and notes
  Future<void> update(
    String url, {
    List<String>? tags,
    String? notes,
  }) async {
    await _ensureInitialized();

    final entry = _favoritesBox!.toMap().entries.firstWhere(
          (e) => e.value.url == url,
          orElse: () => throw FavoritesException('Favorite not found'),
        );

    final updated = entry.value.copyWith(
      tags: tags,
      notes: notes,
    );

    await _favoritesBox!.put(entry.key, updated);
  }

  /// Get all unique tags
  Future<List<String>> getAllTags() async {
    await _ensureInitialized();

    final tags = <String>{};

    for (final favorite in _favoritesBox!.values) {
      if (favorite.tags != null) {
        tags.addAll(favorite.tags!);
      }
    }

    final tagList = tags.toList();
    tagList.sort();

    return tagList;
  }

  /// Get favorites count
  Future<int> getCount() async {
    await _ensureInitialized();
    return _favoritesBox!.length;
  }

  /// Clear all favorites
  Future<void> clear() async {
    await _ensureInitialized();
    await _favoritesBox!.clear();
  }

  /// Export favorites as JSON
  Future<String> exportAsJson() async {
    await _ensureInitialized();

    final items = _favoritesBox!.values.map((f) => f.toJson()).toList();
    return jsonEncode(items);
  }

  /// Import favorites from JSON
  Future<void> importFromJson(String jsonStr) async {
    await _ensureInitialized();

    try {
      final List<dynamic> items = jsonDecode(jsonStr) as List;

      for (final item in items) {
        final favorite = FavoriteItem.fromJson(item as Map<String, dynamic>);
        await _favoritesBox!.add(favorite);
      }
    } catch (e) {
      throw FavoritesException('Failed to import favorites: ${e.toString()}');
    }
  }

  /// Get favorites statistics
  Future<FavoritesStats> getStats() async {
    await _ensureInitialized();

    final items = _favoritesBox!.values.toList();
    if (items.isEmpty) {
      return const FavoritesStats(
        totalFavorites: 0,
        uniqueDomains: 0,
        totalTags: 0,
        oldestFavorite: null,
        newestFavorite: null,
      );
    }

    final domains = items.map((i) => i.domain).toSet().length;
    final tags = <String>{};
    for (final item in items) {
      if (item.tags != null) tags.addAll(item.tags!);
    }

    items.sort((a, b) => a.addedAt.compareTo(b.addedAt));
    final oldest = items.first.addedAt;
    final newest = items.last.addedAt;

    return FavoritesStats(
      totalFavorites: items.length,
      uniqueDomains: domains,
      totalTags: tags.length,
      oldestFavorite: oldest,
      newestFavorite: newest,
    );
  }

  /// Ensure the service is initialized
  Future<void> _ensureInitialized() async {
    if (_favoritesBox == null || !_favoritesBox!.isOpen) {
      await initialize();
    }
  }

  /// Dispose resources
  Future<void> dispose() async {
    await _favoritesBox?.close();
  }
}

/// Favorites statistics
class FavoritesStats {
  final int totalFavorites;
  final int uniqueDomains;
  final int totalTags;
  final DateTime? oldestFavorite;
  final DateTime? newestFavorite;

  const FavoritesStats({
    required this.totalFavorites,
    required this.uniqueDomains,
    required this.totalTags,
    this.oldestFavorite,
    this.newestFavorite,
  });
}

/// Exception thrown by favorites service
class FavoritesException implements Exception {
  final String message;

  const FavoritesException(this.message);

  @override
  String toString() => 'FavoritesException: $message';
}

/// Hive adapter for FavoriteItem
class FavoriteItemAdapter extends TypeAdapter<FavoriteItem> {
  @override
  final int typeId = 1;

  @override
  FavoriteItem read(BinaryReader reader) {
    return FavoriteItem(
      title: reader.readString(),
      url: reader.readString(),
      snippet: reader.readString(),
      domain: reader.readString(),
      imageUrl: reader.readString(),
      addedAt: DateTime.fromMillisecondsSinceEpoch(reader.readInt()),
      id: reader.readString(),
      tags: reader.readStringList(),
      notes: reader.readString(),
    );
  }

  @override
  void write(BinaryWriter writer, FavoriteItem obj) {
    writer.writeString(obj.title);
    writer.writeString(obj.url);
    writer.writeString(obj.snippet);
    writer.writeString(obj.domain);
    writer.writeString(obj.imageUrl ?? '');
    writer.writeInt(obj.addedAt.millisecondsSinceEpoch);
    writer.writeString(obj.id);
    writer.writeStringList(obj.tags ?? []);
    writer.writeString(obj.notes ?? '');
  }
}
