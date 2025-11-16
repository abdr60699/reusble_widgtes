/// A production-ready, reusable Flutter package for in-app web search
///
/// Provides a complete web search solution with:
/// - Multiple search providers (Google, Bing, DuckDuckGo)
/// - Plugin architecture for custom providers
/// - Caching with TTL
/// - Search history and favorites
/// - Open Graph / Twitter Card metadata
/// - Readability extraction
/// - WebView integration
/// - Rich UI components
library reusable_web_search;

// Models
export 'src/models/search_result.dart';
export 'src/models/search_query.dart';
export 'src/models/search_response.dart';
export 'src/models/search_history_item.dart';
export 'src/models/favorite_item.dart';
export 'src/models/cached_search_result.dart';

// Providers
export 'src/providers/search_provider.dart';
export 'src/providers/google_search_provider.dart';
export 'src/providers/bing_search_provider.dart';
export 'src/providers/duckduckgo_search_provider.dart';

// Services
export 'src/services/web_search_service.dart';
export 'src/services/cache_service.dart';
export 'src/services/history_service.dart';
export 'src/services/favorites_service.dart';
export 'src/services/metadata_fetcher.dart';
export 'src/services/readability_service.dart';

// UI Widgets
export 'src/ui/widgets/search_result_card.dart';
export 'src/ui/widgets/search_results_list.dart';

// UI Screens
export 'src/ui/screens/search_screen.dart';
export 'src/ui/screens/web_view_screen.dart';

// Utils
export 'src/utils/url_utils.dart';

// Constants
export 'src/constants/constants.dart';
