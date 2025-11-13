# Flutter Offline Support Module

Production-ready offline support and connectivity management for Flutter applications.

## Features

✅ Real-time connectivity monitoring across all platforms
✅ Automatic request/response caching with Hive
✅ Offline request queueing with intelligent retry
✅ Multiple cache strategies (NetworkFirst, CacheFirst, etc.)
✅ Background synchronization
✅ Conflict resolution for offline mutations
✅ Flutter widgets for connectivity state
✅ Comprehensive debugging and testing tools

## Installation

1. Add dependencies to your `pubspec.yaml`:

```yaml
dependencies:
  flutter:
    sdk: flutter
  hive: ^2.2.3
  hive_flutter: ^1.1.0
  connectivity_plus: ^5.0.2
  path_provider: ^2.1.1
  http: ^1.1.0

dev_dependencies:
  hive_generator: ^2.0.1
  build_runner: ^2.4.6
```

2. Run:
```bash
flutter pub get
flutter packages pub run build_runner build
```

## Quick Start

### 1. Initialize in main.dart

```dart
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'offline_support/offline_support.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive
  await Hive.initFlutter();

  // Register Hive adapters
  await OfflineSupport.registerHiveAdapters();

  // Initialize offline module
  await OfflineSupport.initialize(
    config: OfflineConfig.production(),
  );

  runApp(MyApp());
}
```

### 2. Use OfflineHttpClient

```dart
import 'offline_support/offline_support.dart';

class ApiService {
  final OfflineHttpClient client = OfflineSupport.instance.httpClient;

  Future<dynamic> getProducts() async {
    final response = await client.get(
      'https://api.example.com/products',
      cachePolicy: CachePolicy.networkFirst(
        ttl: Duration(hours: 1),
      ),
    );
    return response.data;
  }

  Future<void> createOrder(Map<String, dynamic> order) async {
    await client.post(
      'https://api.example.com/orders',
      body: order,
      queueIfOffline: true, // Automatically queue if offline
    );
  }
}
```

### 3. Add UI Components

```dart
import 'offline_support/offline_support.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Column(
          children: [
            OfflineBanner(), // Shows connectivity status
            Expanded(
              child: ConnectivityAwareWidget(
                builder: (context, isOnline) {
                  return isOnline
                    ? OnlineContent()
                    : OfflineContent();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
```

## Configuration

### Development Configuration

```dart
await OfflineSupport.initialize(
  config: OfflineConfig.development(),
);
```

### Custom Configuration

```dart
await OfflineSupport.initialize(
  config: OfflineConfig(
    debugMode: true,
    maxCacheSizeInMB: 100,
    cacheDuration: Duration(hours: 24),
    enableRequestQueue: true,
    retryAttempts: 5,
    enableBackgroundSync: true,
  ),
);
```

## Cache Strategies

### NetworkFirst (Default)
Try network first, fallback to cache if offline

```dart
client.get(url, cachePolicy: CachePolicy.networkFirst());
```

### CacheFirst
Use cache if available, otherwise fetch from network

```dart
client.get(url, cachePolicy: CachePolicy.cacheFirst());
```

### StaleWhileRevalidate
Return cached data immediately, refresh in background

```dart
client.get(url, cachePolicy: CachePolicy.staleWhileRevalidate());
```

### CacheOnly
Only use cache, never make network request

```dart
client.get(url, cachePolicy: CachePolicy.cacheOnly());
```

### NetworkOnly
Always fetch from network, bypass cache

```dart
client.get(url, cachePolicy: CachePolicy.networkOnly());
```

## Request Queue

When offline, requests are automatically queued and retried when connectivity is restored:

```dart
// POST requests are queued automatically
await client.post(url, body: data, queueIfOffline: true);

// Check queue status
final queueSize = OfflineSupport.instance.requestQueue.size;
final requests = await OfflineSupport.instance.requestQueue.getAll();

// Manually retry
await OfflineSupport.instance.requestQueue.retryAll();
```

## Sync Manager

```dart
final syncManager = OfflineSupport.instance.syncManager;

// Manual sync
await syncManager.sync();

// Listen to sync progress
syncManager.syncStream.listen((result) {
  print('Sync progress: ${result.progress}');
});

// Background sync (requires platform setup)
await syncManager.enableBackgroundSync();
```

## Widgets

### OfflineBanner
Shows banner when offline

```dart
OfflineBanner(
  backgroundColor: Colors.red,
  textColor: Colors.white,
  message: 'You are offline',
)
```

### ConnectivityAwareWidget
Rebuilds on connectivity changes

```dart
ConnectivityAwareWidget(
  builder: (context, isOnline) {
    return Text(isOnline ? 'Online' : 'Offline');
  },
)
```

### SyncIndicator
Shows sync progress

```dart
SyncIndicator()
```

## Testing

### Mock Connectivity

```dart
// For testing
OfflineSupport.instance.connectivityManager
  .setMockStatus(ConnectivityStatus.offline);

// Your tests
await makeRequest();

// Restore
OfflineSupport.instance.connectivityManager.clearMockStatus();
```

### Inspect Cache

```dart
final stats = await OfflineSupport.instance.cacheService.getStatistics();
print('Cache size: ${stats.sizeInBytes}');
print('Hit ratio: ${stats.hitRatio}');
```

## Platform-Specific Setup

### Android
No additional setup required. Network state permission is added automatically.

### iOS
Add to `Info.plist` for background sync:

```xml
<key>UIBackgroundModes</key>
<array>
    <string>fetch</string>
    <string>processing</string>
</array>
```

### Web
Ensure HTTPS for service worker support.

## API Reference

See full documentation at: [API Docs](./docs/api.md)

## Examples

Check the [example](./example) directory for complete working examples.

## Troubleshooting

### Cache not persisting
- Ensure Hive is initialized before OfflineSupport
- Check storage permissions
- Verify sufficient disk space

### Requests not queueing
- Check `enableRequestQueue` in config
- Ensure `queueIfOffline` is true
- Check queue size limit

### Background sync not working
- Verify platform-specific setup
- Check battery optimization settings
- Enable in configuration

## License

MIT License - see LICENSE file

## Support

For issues and questions, please open an issue on GitHub.
