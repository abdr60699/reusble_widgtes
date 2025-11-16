# Privacy Policy & Data Collection Notice

## Overview

The **Reusable Web Search** package is designed with privacy in mind. This document explains what data is collected, how it's used, and your responsibilities when integrating this package into your app.

## Data Collection by This Package

### Local Data Storage

The package stores the following data **locally on the user's device**:

1. **Search History**
   - Search queries entered by the user
   - Timestamps of searches
   - Number of results returned
   - Site filters (if used)
   - **Storage**: Device local storage (Hive database)
   - **Retention**: Until manually cleared or device storage cleared
   - **Purpose**: Provide quick access to recent searches

2. **Favorites/Bookmarks**
   - Saved search results (title, URL, snippet, domain)
   - User-added tags and notes
   - Timestamp when favorited
   - **Storage**: Device local storage (Hive database)
   - **Retention**: Until manually removed or device storage cleared
   - **Purpose**: Allow users to save interesting results

3. **Cache Data**
   - Search responses from providers
   - Cached with Time-To-Live (TTL) expiration
   - **Storage**: Device local storage (Hive database)
   - **Retention**: Expires after TTL (default: 60 minutes)
   - **Purpose**: Improve performance and reduce API calls

### Data Transmitted to Third Parties

The package transmits data to third-party services **only when necessary**:

1. **Search Provider APIs** (Google, Bing, or DuckDuckGo)
   - **What**: User's search query and filter parameters
   - **When**: Each time a search is performed (unless cached)
   - **Why**: Required to retrieve search results
   - **Who**: Selected search provider (Google, Microsoft, or DuckDuckGo)

2. **Web Page Requests** (for metadata/content extraction)
   - **What**: HTTP requests to fetch page content
   - **When**: When fetching Open Graph metadata or readable content
   - **Why**: Extract page titles, descriptions, images, and content
   - **Who**: The website being accessed

### Data NOT Collected

This package **does NOT**:

- ❌ Collect or transmit personally identifiable information (PII)
- ❌ Use analytics or tracking services
- ❌ Share data with third parties (except search providers as described)
- ❌ Store data on remote servers
- ❌ Access device contacts, location, or other sensitive data
- ❌ Inject ads or tracking scripts

## Third-Party Service Privacy Policies

When using this package, user data is subject to the privacy policies of the search provider you choose:

### Google Custom Search
- **Privacy Policy**: https://policies.google.com/privacy
- **Terms of Service**: https://policies.google.com/terms
- **Data Use**: Google may collect search queries, IP addresses, and usage data according to their privacy policy
- **Compliance**: GDPR, CCPA compliant

### Microsoft Bing Web Search
- **Privacy Policy**: https://privacy.microsoft.com/privacystatement
- **Terms of Service**: https://www.microsoft.com/servicesagreement
- **Data Use**: Microsoft may collect search queries and usage data according to their privacy policy
- **Compliance**: GDPR, CCPA compliant

### DuckDuckGo
- **Privacy Policy**: https://duckduckgo.com/privacy
- **Terms of Service**: https://duckduckgo.com/terms
- **Data Use**: DuckDuckGo does not track or profile users
- **Notable**: Privacy-focused, no personalized results

## Your Responsibilities as an Integrator

When you integrate this package into your app, **YOU are responsible for**:

### 1. User Consent

**You must obtain appropriate user consent** for:
- Using third-party search APIs
- Storing search history locally
- Accessing web content for metadata extraction

**Recommended approach**:
```dart
// Show privacy notice before first use
await showDialog(
  context: context,
  builder: (context) => AlertDialog(
    title: Text('Privacy Notice'),
    content: Text(
      'This app uses ${providerName} to provide search functionality. '
      'Your searches are sent to ${providerName} and subject to their privacy policy. '
      'Search history is stored locally on your device.'
    ),
    actions: [
      TextButton(
        onPressed: () => Navigator.pop(context, false),
        child: Text('Decline'),
      ),
      TextButton(
        onPressed: () => Navigator.pop(context, true),
        child: Text('Accept'),
      ),
    ],
  ),
);
```

### 2. Privacy Policy

**You must disclose in your app's privacy policy**:
- That you use this package for web search
- Which search provider(s) you use
- What data is sent to search providers
- What data is stored locally
- How users can delete their data

**Example privacy policy snippet**:
```
Our app uses the Reusable Web Search package to provide in-app web search functionality.
When you perform a search, your query is sent to [Google/Bing/DuckDuckGo] according to
their privacy policy. Search history and favorites are stored locally on your device and
can be cleared at any time through the app settings.
```

### 3. Data Deletion

**You must provide users a way to delete their data**:

```dart
// Clear all local data
await historyService.clear();
await favoritesService.clear();
await cacheService.clear();

// Or selective deletion
await historyService.deleteOlderThan(30); // Delete history older than 30 days
await favoritesService.remove(url); // Remove specific favorite
```

### 4. GDPR Compliance (If Applicable)

If your app targets EU users, you must:

- ✅ Obtain explicit consent before using search providers
- ✅ Allow users to access their data (export favorites)
- ✅ Allow users to delete their data
- ✅ Document data retention periods
- ✅ Inform users of third-party data processors

**Example: Export user data**
```dart
// Export favorites as JSON
final json = await favoritesService.exportAsJson();
await File('user_data.json').writeAsString(json);
```

### 5. COPPA Compliance (If Applicable)

If your app targets children under 13:

- ❌ **DO NOT** use search providers without verifiable parental consent
- ❌ **DO NOT** collect search history from children
- ✅ Consider disabling history/favorites features for child accounts
- ✅ Use privacy-focused providers like DuckDuckGo

## Security Considerations

### API Key Security

**NEVER** hardcode API keys in your app:

```dart
// ❌ BAD - API key exposed in code
final config = SearchProviderConfig(
  apiKey: 'AIzaSyABC123...',
);

// ✅ GOOD - API key from environment or secure storage
final config = SearchProviderConfig(
  apiKey: await getSecureApiKey(),
);
```

### WebView Security

When using the built-in WebView:
- URLs are not validated by default
- JavaScript is enabled (required for modern web)
- **You should** validate URLs before opening:

```dart
bool isSafeUrl(String url) {
  final uri = Uri.tryParse(url);
  if (uri == null) return false;

  // Block dangerous protocols
  if (!uri.isScheme('http') && !uri.isScheme('https')) {
    return false;
  }

  // Add your own blocklist if needed
  final blockedDomains = ['malicious-site.com'];
  if (blockedDomains.contains(uri.host)) {
    return false;
  }

  return true;
}
```

### Data Encryption

Local data (history, favorites, cache) is **NOT encrypted by default**.

**To encrypt sensitive data**:
- Use `flutter_secure_storage` for API keys
- Implement custom encryption for cached data if needed
- Consider using encrypted Hive boxes

## User Rights

Users have the right to:

1. **Access**: View their search history and favorites
2. **Deletion**: Clear their search history and favorites
3. **Export**: Export their favorites data
4. **Opt-out**: Choose not to use search features

## Recommended Privacy Settings

```dart
// Privacy-focused configuration
final searchService = WebSearchService(
  provider: DuckDuckGoSearchProvider(...), // Privacy-focused provider
  enableCaching: false, // Disable caching for sensitive searches
  enableHistory: false, // Disable history for privacy-conscious users
);
```

## Changes to Privacy Practices

As this is an open-source package:
- Monitor package updates for privacy-related changes
- Review changelogs before updating
- Update your privacy policy if package behavior changes

## Contact & Questions

For privacy questions about this package:
- GitHub Issues: https://github.com/abdr60699/reusable_widgets/issues
- Email: [your-email@example.com]

---

## Compliance Checklist for Integrators

Use this checklist to ensure privacy compliance:

- [ ] Privacy policy updated with search functionality disclosure
- [ ] User consent obtained before first search
- [ ] Search provider's terms and privacy policy linked in app
- [ ] Data deletion functionality implemented
- [ ] API keys stored securely (not hardcoded)
- [ ] GDPR compliance verified (if applicable)
- [ ] COPPA compliance verified (if applicable)
- [ ] App store privacy disclosures updated
- [ ] Beta tested with privacy review
- [ ] Legal review completed (if required)

---

**Last Updated**: November 2025

**Version**: 1.0.0

This privacy notice applies to reusable_web_search package version 1.0.0 and later.
