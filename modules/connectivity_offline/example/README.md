# Connectivity & Offline Support Example

This example demonstrates all features of the connectivity and offline support module.

## Features Demonstrated

- ✅ Real-time connectivity monitoring
- ✅ Disk caching with Hive
- ✅ Offline request queueing
- ✅ Manual sync trigger
- ✅ Event logging

## Running the Example

```bash
cd modules/connectivity_offline/example
flutter pub get
flutter run
```

## What to Try

1. **Connectivity Monitoring**
   - Toggle airplane mode on your device
   - Switch between WiFi and mobile data
   - Observe status changes in real-time

2. **Cache Testing**
   - Tap "Test Cache" to store and retrieve data
   - Data persists across app restarts
   - Check logs for cache operations

3. **Queue Testing**
   - Go offline (airplane mode)
   - Tap "Queue Request" multiple times
   - Go back online
   - Requests automatically sync

4. **Manual Sync**
   - Queue some requests while offline
   - Tap "Sync Now" when back online
   - Observe sync progress in logs

## Testing Offline Scenarios

### On Emulator/Simulator

**Android Emulator:**
- Press "..." (Extended controls)
- Go to "Cellular" section
- Toggle "Data" off

**iOS Simulator:**
- Not directly supported - use Mac network settings

### On Physical Device

- Enable airplane mode
- Disable WiFi/mobile data
- Use device settings

## Understanding the Logs

The example app logs all important events:

- `🔄` - Sync operations
- `✅` - Successful operations
- `❌` - Errors
- `📋` - Status information

## Configuration

The example uses development configuration:

```dart
OfflineSupport.initialize(
  config: OfflineConfig.development(),
);
```

For production, use:

```dart
OfflineSupport.initialize(
  config: OfflineConfig.production(),
);
```

## Next Steps

1. Run the example
2. Test all features
3. Integrate into your own app
4. Customize configuration as needed

## Troubleshooting

**Cache Not Working:**
- Ensure Hive is properly initialized
- Check file system permissions
- Run `flutter clean` and rebuild

**Sync Not Triggering:**
- Verify connectivity is actually restored
- Check sync policy configuration
- Look for errors in logs

**Build Errors:**
- Run `flutter pub get`
- Ensure all dependencies are installed
- Check minimum SDK versions
