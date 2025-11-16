/// Constants for the reusable web search package

class SearchConstants {
  // Default values
  static const int defaultResultsPerPage = 10;
  static const int defaultCacheTtl = 60; // minutes
  static const int defaultMaxCacheSize = 100;
  static const int defaultMaxHistorySize = 100;

  // UI constants
  static const double searchBarHeight = 56.0;
  static const double resultCardPadding = 16.0;
  static const double resultCardSpacing = 12.0;
  static const double faviconSize = 24.0;
  static const double thumbnailSize = 80.0;

  // Timeouts
  static const Duration searchTimeout = Duration(seconds: 30);
  static const Duration metadataTimeout = Duration(seconds: 10);
  static const Duration cacheCleanupInterval = Duration(hours: 1);

  // Pagination
  static const double scrollThreshold = 0.8; // 80% scroll triggers load more

  // Error messages
  static const String errorNoInternet = 'No internet connection';
  static const String errorSearchFailed = 'Search failed. Please try again.';
  static const String errorNoResults = 'No results found';
  static const String errorInvalidQuery = 'Please enter a search query';

  // Privacy & TOS
  static const String privacyNoticeGoogle =
      'Search results provided by Google Custom Search. '
      'By using this feature, you agree to Google\'s Terms of Service and Privacy Policy.';

  static const String privacyNoticeBing =
      'Search results provided by Microsoft Bing. '
      'By using this feature, you agree to Microsoft\'s Terms of Service and Privacy Policy.';

  static const String privacyNoticeDuckDuckGo =
      'Search results provided by DuckDuckGo. '
      'DuckDuckGo does not track your searches.';

  static const String dataCollectionNotice =
      'This app stores search history and favorites locally on your device. '
      'No data is shared with third parties except the search provider APIs.';
}
