import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as html_parser;
import 'package:html/dom.dart';
import '../models/models.dart';

/// Service for fetching Open Graph and Twitter Card metadata from web pages
class MetadataFetcher {
  final http.Client _client;
  final Duration timeout;

  MetadataFetcher({
    http.Client? client,
    this.timeout = const Duration(seconds: 10),
  }) : _client = client ?? http.Client();

  /// Fetch Open Graph metadata from a URL
  Future<OpenGraphData?> fetchMetadata(String url) async {
    try {
      final uri = Uri.tryParse(url);
      if (uri == null || (!uri.isScheme('http') && !uri.isScheme('https'))) {
        return null;
      }

      final response = await _client.get(uri).timeout(
            timeout,
            onTimeout: () => throw MetadataException(
              'Request timed out after ${timeout.inSeconds}s',
            ),
          );

      if (response.statusCode != 200) {
        throw MetadataException('HTTP error ${response.statusCode}');
      }

      return _parseMetadata(response.body, url);
    } catch (e) {
      if (e is MetadataException) rethrow;
      // Return null on error rather than throwing
      return null;
    }
  }

  /// Parse HTML and extract Open Graph/Twitter Card metadata
  OpenGraphData? _parseMetadata(String html, String url) {
    try {
      final document = html_parser.parse(html);

      final ogTitle = _getMetaContent(document, 'og:title') ??
          _getMetaContent(document, 'twitter:title') ??
          document.querySelector('title')?.text;

      final ogDescription = _getMetaContent(document, 'og:description') ??
          _getMetaContent(document, 'twitter:description') ??
          _getMetaContent(document, 'description');

      final ogImage = _getMetaContent(document, 'og:image') ??
          _getMetaContent(document, 'twitter:image') ??
          _getMetaContent(document, 'twitter:image:src');

      final ogSiteName = _getMetaContent(document, 'og:site_name');
      final ogType = _getMetaContent(document, 'og:type');
      final ogUrl = _getMetaContent(document, 'og:url') ?? url;

      final twitterCard = _getMetaContent(document, 'twitter:card');
      final twitterTitle = _getMetaContent(document, 'twitter:title');
      final twitterDescription =
          _getMetaContent(document, 'twitter:description');
      final twitterImage = _getMetaContent(document, 'twitter:image') ??
          _getMetaContent(document, 'twitter:image:src');

      // Return null if no useful metadata found
      if (ogTitle == null &&
          ogDescription == null &&
          ogImage == null &&
          twitterTitle == null) {
        return null;
      }

      return OpenGraphData(
        title: ogTitle,
        description: ogDescription,
        image: ogImage,
        siteName: ogSiteName,
        type: ogType,
        url: ogUrl,
        twitterCard: twitterCard,
        twitterTitle: twitterTitle,
        twitterDescription: twitterDescription,
        twitterImage: twitterImage,
      );
    } catch (e) {
      return null;
    }
  }

  /// Get content from meta tag
  String? _getMetaContent(Document document, String property) {
    // Try property attribute (og: tags)
    var element = document.querySelector('meta[property="$property"]');
    if (element != null) {
      return element.attributes['content'];
    }

    // Try name attribute (twitter: and standard tags)
    element = document.querySelector('meta[name="$property"]');
    if (element != null) {
      return element.attributes['content'];
    }

    return null;
  }

  /// Fetch favicon URL for a domain
  Future<String?> fetchFavicon(String url) async {
    try {
      final uri = Uri.tryParse(url);
      if (uri == null) return null;

      final domain = '${uri.scheme}://${uri.host}';

      // Try common favicon locations
      final faviconUrls = [
        '$domain/favicon.ico',
        '$domain/favicon.png',
        '$domain/apple-touch-icon.png',
      ];

      for (final faviconUrl in faviconUrls) {
        try {
          final response = await _client.head(Uri.parse(faviconUrl)).timeout(
                const Duration(seconds: 3),
              );

          if (response.statusCode == 200) {
            return faviconUrl;
          }
        } catch (_) {
          continue;
        }
      }

      // Try to find favicon in HTML
      try {
        final response = await _client.get(Uri.parse(url)).timeout(
              const Duration(seconds: 5),
            );

        if (response.statusCode == 200) {
          final document = html_parser.parse(response.body);

          // Look for link rel="icon"
          final iconLink = document.querySelector('link[rel*="icon"]');
          if (iconLink != null) {
            var href = iconLink.attributes['href'];
            if (href != null) {
              if (href.startsWith('//')) {
                href = '${uri.scheme}:$href';
              } else if (href.startsWith('/')) {
                href = '$domain$href';
              } else if (!href.startsWith('http')) {
                href = '$domain/$href';
              }
              return href;
            }
          }
        }
      } catch (_) {
        // Ignore errors
      }

      // Fallback to Google's favicon service
      return 'https://www.google.com/s2/favicons?domain=${uri.host}&sz=64';
    } catch (e) {
      return null;
    }
  }

  /// Dispose resources
  void dispose() {
    _client.close();
  }
}

/// Exception thrown by metadata fetcher
class MetadataException implements Exception {
  final String message;

  const MetadataException(this.message);

  @override
  String toString() => 'MetadataException: $message';
}
