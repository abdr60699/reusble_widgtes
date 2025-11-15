import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_storage/firebase_storage.dart' as fb_storage;
import '../repository/storage_repository.dart';
import '../services/storage_service.dart';
import '../utils/storage_config.dart';

/// Riverpod providers for Firebase Storage Module
///
/// **Usage:**
/// ```dart
/// // In main.dart
/// runApp(
///   ProviderScope(
///     child: MyApp(),
///   ),
/// );
///
/// // In widget
/// class MyWidget extends ConsumerWidget {
///   @override
///   Widget build(BuildContext context, WidgetRef ref) {
///     final storageService = ref.read(storageServiceProvider);
///
///     // Upload a file
///     final result = await storageService.uploadBytes(
///       path: 'images/avatar.png',
///       data: imageBytes,
///     );
///   }
/// }
/// ```

// =============================================================================
// CONFIGURATION PROVIDERS
// =============================================================================

/// Storage configuration provider
///
/// Override this provider to customize storage behavior:
/// ```dart
/// ProviderScope(
///   overrides: [
///     storageConfigProvider.overrideWithValue(
///       StorageConfig.imagesOnly(maxFileSizeBytes: 5 * 1024 * 1024),
///     ),
///   ],
///   child: MyApp(),
/// )
/// ```
final storageConfigProvider = Provider<StorageConfig>((ref) {
  return StorageConfig.defaultConfig();
});

// =============================================================================
// CORE PROVIDERS
// =============================================================================

/// Firebase Storage instance provider
final firebaseStorageProvider = Provider<fb_storage.FirebaseStorage>((ref) {
  return fb_storage.FirebaseStorage.instance;
});

/// Storage repository provider
///
/// This is the data layer that wraps Firebase Storage SDK.
final storageRepositoryProvider = Provider<StorageRepository>((ref) {
  return StorageRepository(
    firebaseStorage: ref.read(firebaseStorageProvider),
    config: ref.read(storageConfigProvider),
  );
});

/// Storage service provider (Main API)
///
/// This is the primary provider you'll use for storage operations.
/// It provides a high-level API for upload, download, delete, and list operations.
final storageServiceProvider = Provider<StorageService>((ref) {
  return StorageService(
    repository: ref.read(storageRepositoryProvider),
  );
});

// =============================================================================
// HELPER PROVIDERS
// =============================================================================

/// Provider for checking if a file extension is allowed
final isExtensionAllowedProvider = Provider.family<bool, String>((ref, extension) {
  final config = ref.read(storageConfigProvider);
  return config.isExtensionAllowed(extension);
});

/// Provider for checking if a file size is allowed
final isFileSizeAllowedProvider = Provider.family<bool, int>((ref, sizeInBytes) {
  final config = ref.read(storageConfigProvider);
  return config.isFileSizeAllowed(sizeInBytes);
});

// =============================================================================
// CUSTOM CONFIGURATION PROVIDERS
// =============================================================================

/// Storage configuration for images only
final imagesOnlyConfigProvider = Provider<StorageConfig>((ref) {
  return StorageConfig.imagesOnly();
});

/// Storage configuration for documents only
final documentsOnlyConfigProvider = Provider<StorageConfig>((ref) {
  return StorageConfig.documentsOnly();
});

/// Storage configuration for media files
final mediaOnlyConfigProvider = Provider<StorageConfig>((ref) {
  return StorageConfig.mediaOnly();
});
