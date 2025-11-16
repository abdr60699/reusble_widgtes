# Changelog

All notable changes to the reusable_web_search package will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

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
