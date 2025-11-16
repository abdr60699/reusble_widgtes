import 'package:url_launcher/url_launcher.dart';

/// Utility class for URL handling
class UrlUtils {
  /// Extract domain from URL
  static String extractDomain(String url) {
    try {
      final uri = Uri.tryParse(url);
      if (uri != null && uri.host.isNotEmpty) {
        return uri.host.replaceAll('www.', '');
      }
      return url;
    } catch (e) {
      return url;
    }
  }

  /// Check if URL is valid
  static bool isValidUrl(String url) {
    try {
      final uri = Uri.tryParse(url);
      return uri != null &&
          uri.isAbsolute &&
          (uri.isScheme('http') || uri.isScheme('https'));
    } catch (e) {
      return false;
    }
  }

  /// Launch URL in external browser
  static Future<bool> launchExternalUrl(String url) async {
    try {
      final uri = Uri.parse(url);
      return await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );
    } catch (e) {
      return false;
    }
  }

  /// Launch URL in in-app browser
  static Future<bool> launchInAppUrl(String url) async {
    try {
      final uri = Uri.parse(url);
      return await launchUrl(
        uri,
        mode: LaunchMode.inAppWebView,
      );
    } catch (e) {
      return false;
    }
  }

  /// Get favicon URL for domain
  static String getFaviconUrl(String url, {int size = 32}) {
    final domain = extractDomain(url);
    return 'https://www.google.com/s2/favicons?domain=$domain&sz=$size';
  }

  /// Format URL for display (remove protocol, limit length)
  static String formatForDisplay(String url, {int maxLength = 50}) {
    var display = url
        .replaceAll(RegExp(r'^https?://'), '')
        .replaceAll(RegExp(r'/$'), '');

    if (display.length > maxLength) {
      display = '${display.substring(0, maxLength)}...';
    }

    return display;
  }
}
