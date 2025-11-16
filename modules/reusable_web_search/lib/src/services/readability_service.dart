import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as html_parser;
import 'package:html/dom.dart';

/// Service for extracting readable content from web pages
/// Implements a simplified version of Mozilla's Readability algorithm
class ReadabilityService {
  final http.Client _client;
  final Duration timeout;

  ReadabilityService({
    http.Client? client,
    this.timeout = const Duration(seconds: 10),
  }) : _client = client ?? http.Client();

  /// Extract readable content from a URL
  Future<ReadableContent?> extractContent(String url) async {
    try {
      final uri = Uri.tryParse(url);
      if (uri == null || (!uri.isScheme('http') && !uri.isScheme('https'))) {
        return null;
      }

      final response = await _client.get(uri).timeout(
            timeout,
            onTimeout: () => throw ReadabilityException(
              'Request timed out after ${timeout.inSeconds}s',
            ),
          );

      if (response.statusCode != 200) {
        throw ReadabilityException('HTTP error ${response.statusCode}');
      }

      return _parseContent(response.body, url);
    } catch (e) {
      if (e is ReadabilityException) rethrow;
      return null;
    }
  }

  /// Parse HTML and extract main content
  ReadableContent? _parseContent(String html, String url) {
    try {
      final document = html_parser.parse(html);

      // Remove unwanted elements
      _removeUnwantedElements(document);

      // Find the main content container
      final contentElement = _findMainContent(document);

      if (contentElement == null) {
        return null;
      }

      // Extract text content
      final textContent = _extractText(contentElement);

      if (textContent.isEmpty) {
        return null;
      }

      // Get title
      final title = document.querySelector('title')?.text ??
          document.querySelector('h1')?.text ??
          'Untitled';

      // Extract author if available
      final author = _extractAuthor(document);

      // Estimate reading time (avg 200 words per minute)
      final wordCount = textContent.split(RegExp(r'\s+')).length;
      final readingTimeMinutes = (wordCount / 200).ceil();

      // Generate excerpt (first 200 characters)
      final excerpt = textContent.length > 200
          ? '${textContent.substring(0, 200)}...'
          : textContent;

      return ReadableContent(
        title: title.trim(),
        author: author,
        content: textContent,
        excerpt: excerpt,
        wordCount: wordCount,
        readingTimeMinutes: readingTimeMinutes,
        url: url,
      );
    } catch (e) {
      return null;
    }
  }

  /// Remove scripts, styles, and other unwanted elements
  void _removeUnwantedElements(Document document) {
    const unwantedTags = [
      'script',
      'style',
      'nav',
      'header',
      'footer',
      'aside',
      'iframe',
      'noscript',
    ];

    for (final tag in unwantedTags) {
      document.querySelectorAll(tag).forEach((e) => e.remove());
    }

    // Remove elements with certain classes/ids
    const unwantedPatterns = [
      'ad',
      'advertisement',
      'banner',
      'social',
      'share',
      'comment',
      'sidebar',
      'menu',
      'navigation',
    ];

    for (final pattern in unwantedPatterns) {
      document
          .querySelectorAll('[class*="$pattern"], [id*="$pattern"]')
          .forEach((e) => e.remove());
    }
  }

  /// Find the main content container
  Element? _findMainContent(Document document) {
    // Try semantic HTML5 elements first
    var content = document.querySelector('article');
    if (content != null && _hasSignificantContent(content)) {
      return content;
    }

    content = document.querySelector('main');
    if (content != null && _hasSignificantContent(content)) {
      return content;
    }

    // Try common content containers
    final candidates = document.querySelectorAll(
      'div[class*="content"], div[class*="article"], div[class*="post"], div[id*="content"], div[id*="article"]',
    );

    Element? bestCandidate;
    int maxScore = 0;

    for (final candidate in candidates) {
      final score = _scoreElement(candidate);
      if (score > maxScore) {
        maxScore = score;
        bestCandidate = candidate;
      }
    }

    return bestCandidate ?? document.body;
  }

  /// Score an element based on content and structure
  int _scoreElement(Element element) {
    int score = 0;

    // Count paragraphs
    final paragraphs = element.querySelectorAll('p');
    score += paragraphs.length * 5;

    // Count text length
    final text = element.text;
    score += (text.length / 100).floor();

    // Penalize elements with many links
    final links = element.querySelectorAll('a');
    score -= links.length * 2;

    // Bonus for article/content-related classes
    final className = element.className.toLowerCase();
    if (className.contains('content') || className.contains('article')) {
      score += 20;
    }

    return score;
  }

  /// Check if element has significant content
  bool _hasSignificantContent(Element element) {
    final text = element.text.trim();
    return text.length > 100;
  }

  /// Extract clean text from element
  String _extractText(Element element) {
    final buffer = StringBuffer();

    void extractFromElement(Element el) {
      for (final node in el.nodes) {
        if (node is Element) {
          if (node.localName == 'p' ||
              node.localName == 'div' ||
              node.localName == 'article') {
            extractFromElement(node);
            buffer.write('\n\n');
          } else if (node.localName == 'br') {
            buffer.write('\n');
          } else if (node.localName == 'h1' ||
              node.localName == 'h2' ||
              node.localName == 'h3' ||
              node.localName == 'h4' ||
              node.localName == 'h5' ||
              node.localName == 'h6') {
            buffer.write('\n\n');
            buffer.write(node.text.trim());
            buffer.write('\n\n');
          } else {
            extractFromElement(node);
          }
        } else if (node is Text) {
          final text = node.text.trim();
          if (text.isNotEmpty) {
            buffer.write(text);
            buffer.write(' ');
          }
        }
      }
    }

    extractFromElement(element);

    // Clean up multiple newlines and spaces
    var result = buffer.toString();
    result = result.replaceAll(RegExp(r'\n{3,}'), '\n\n');
    result = result.replaceAll(RegExp(r' {2,}'), ' ');

    return result.trim();
  }

  /// Extract author from metadata
  String? _extractAuthor(Document document) {
    // Try meta tags
    var author = _getMetaContent(document, 'author');
    if (author != null) return author;

    author = _getMetaContent(document, 'article:author');
    if (author != null) return author;

    // Try common author elements
    final authorElement = document.querySelector(
      '.author, .byline, [rel="author"], [class*="author"]',
    );

    if (authorElement != null) {
      return authorElement.text.trim();
    }

    return null;
  }

  /// Get content from meta tag
  String? _getMetaContent(Document document, String name) {
    var element = document.querySelector('meta[name="$name"]');
    if (element != null) {
      return element.attributes['content'];
    }

    element = document.querySelector('meta[property="$name"]');
    if (element != null) {
      return element.attributes['content'];
    }

    return null;
  }

  /// Dispose resources
  void dispose() {
    _client.close();
  }
}

/// Extracted readable content from a web page
class ReadableContent {
  final String title;
  final String? author;
  final String content;
  final String excerpt;
  final int wordCount;
  final int readingTimeMinutes;
  final String url;

  const ReadableContent({
    required this.title,
    this.author,
    required this.content,
    required this.excerpt,
    required this.wordCount,
    required this.readingTimeMinutes,
    required this.url,
  });

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'author': author,
      'content': content,
      'excerpt': excerpt,
      'wordCount': wordCount,
      'readingTimeMinutes': readingTimeMinutes,
      'url': url,
    };
  }

  factory ReadableContent.fromJson(Map<String, dynamic> json) {
    return ReadableContent(
      title: json['title'] as String,
      author: json['author'] as String?,
      content: json['content'] as String,
      excerpt: json['excerpt'] as String,
      wordCount: json['wordCount'] as int,
      readingTimeMinutes: json['readingTimeMinutes'] as int,
      url: json['url'] as String,
    );
  }
}

/// Exception thrown by readability service
class ReadabilityException implements Exception {
  final String message;

  const ReadabilityException(this.message);

  @override
  String toString() => 'ReadabilityException: $message';
}
