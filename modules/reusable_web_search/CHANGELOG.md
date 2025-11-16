# Changelog

All notable changes to the reusable_web_search package will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.1.0] - 2025-11-16

### Changed - Package Updates

#### Dependencies Updated to Latest Versions
- `http`: ^1.1.0 → ^1.2.2
- `dio`: ^5.4.0 → ^5.9.0
- `html`: ^0.15.4 → ^0.15.5
- `webview_flutter`: ^4.4.4 → ^4.10.0
- `webview_flutter_android`: ^3.13.1 → ^3.16.10
- `webview_flutter_wkwebview`: ^3.10.1 → ^3.16.3
- `shared_preferences`: ^2.2.2 → ^2.5.3
- `path_provider`: ^2.1.1 → ^2.1.5
- `url_launcher`: ^6.2.2 → ^6.3.1
- `share_plus`: ^7.2.1 → ^10.1.2
- `cached_network_image`: ^3.3.1 → ^3.4.1
- `provider`: ^6.1.1 → ^6.1.2
- `intl`: ^0.18.1 → ^0.19.0
- `equatable`: ^2.0.5 → ^2.0.7

#### Dev Dependencies Updated
- `flutter_lints`: ^3.0.0 → ^6.0.0
- `build_runner`: ^2.4.7 → ^2.10.3
- `test`: ^1.24.9 → ^1.25.8

#### SDK Requirements Updated
- Dart SDK: '>=3.0.0' → '>=3.2.0'
- Flutter: '>=3.10.0' → '>=3.16.0'

### Fixed

- **Deprecated API Removal**: Replaced `WillPopScope` with `PopScope` in WebViewScreen for Flutter 3.16+ compatibility
- **Lint Compatibility**: Updated `analysis_options.yaml` for flutter_lints 6.0.0 compatibility
- **Type Safety**: Enabled strict analyzer modes (strict-casts, strict-inference, strict-raw-types)

### Added

- **UPGRADE_GUIDE.md**: Comprehensive migration guide from v1.0.0 to v1.1.0
- **Enhanced Lint Rules**: Added modern lint rules for better code quality:
  - `prefer_const_constructors_in_immutables`
  - `prefer_const_declarations`
  - `prefer_const_literals_to_create_immutables`
  - `prefer_final_in_for_each`
  - `prefer_final_locals`
  - `sort_constructors_first`
  - `sort_unnamed_constructors_first`
  - `unnecessary_await_in_return`
  - `use_super_parameters`

### Technical Details

- **Breaking Changes**: None for standard usage
- **API Compatibility**: Fully backward compatible
- **Migration Time**: ~5 minutes (dependency update only)
- **Performance**: Benefits from performance improvements in updated packages

---

## [1.0.0] - 2025-11-16

### Added

#### Core Features
- **Multiple Search Providers**: Support for Google Custom Search, Bing Web Search API, and DuckDuckGo
- **Plugin Architecture**: Abstract `SearchProvider` interface for easy provider swapping
- **Search Filtering**: Safe search levels, site-specific search, date ranges, language, region, and file type filters
- **Pagination**: Infinite scroll and "load more" functionality

#### Data Management
- **Caching Service**: Search result caching with configurable TTL (Time To Live)
- **History Service**: Track and manage search history with automatic size limits
- **Favorites Service**: Bookmark/favorite search results with tags and notes
- **Data Export**: Export favorites as JSON for backup/portability

#### Metadata & Content
- **Open Graph Fetcher**: Extract Open Graph and Twitter Card metadata from web pages
- **Readability Service**: Extract readable content from web pages using simplified Readability algorithm
- **Favicon Support**: Automatic favicon fetching and display
- **Rich Result Display**: Show titles, snippets, domains, images, and published dates

#### UI Components
- **SearchScreen**: Complete search interface with input, filters, and results
- **SearchResultCard**: Rich result cards with metadata and action buttons
- **SearchResultsList**: Scrollable results list with infinite scroll
- **WebViewScreen**: In-app browser with navigation controls

#### User Actions
- **Share**: Share search results via platform share sheet
- **Copy URL**: Copy result URLs to clipboard
- **Open Externally**: Open results in external browser
- **Favorite/Bookmark**: Save results for later access

#### Developer Features
- **Type Safety**: Full null safety and type-safe APIs
- **Comprehensive Documentation**: Detailed README, API docs, and privacy guide
- **Example App**: Complete example demonstrating all features
- **Customizable**: All widgets and services can be customized or replaced

### Documentation
- Comprehensive README with quick start guide
- Privacy policy and TOS guidance (PRIVACY.md)
- API reference documentation
- Example application with multiple provider support

### Security & Privacy
- Local-only data storage (no remote servers)
- Privacy-focused design
- GDPR compliance guidance
- API key security best practices

## [Unreleased]

### Planned Features
- Additional search providers (Yahoo, Yandex, etc.)
- Advanced filtering UI
- Search suggestions/autocomplete
- Voice search integration
- Offline mode improvements
- Analytics integration (opt-in)
- More comprehensive tests

---

## Version History

- **1.0.0** - Initial production release (2025-11-16)
