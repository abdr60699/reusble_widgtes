/// Supabase Storage module for Flutter
///
/// This module provides a comprehensive, reusable, and testable implementation
/// for Supabase Storage operations including file upload, download, list, and delete.
///
/// Features:
/// - Upload files from bytes or local file paths
/// - Download files to memory or local paths
/// - List files with filtering and sorting
/// - Delete single or multiple files
/// - Get public URLs or create signed URLs for private files
/// - Move and copy files
/// - Bucket management
/// - Comprehensive error handling
/// - Configurable file size limits and extension restrictions
/// - Integration with existing Supabase Auth
///
/// Example usage:
/// ```dart
/// // Initialize from existing auth config
/// final authConfig = SupabaseAuthConfig.fromEnvironment(env: Platform.environment);
/// final storageConfig = SupabaseStorageConfig.fromAuthConfig(
///   authConfig,
///   defaultBucket: 'my-bucket',
/// );
///
/// // Initialize repository
/// final storage = await StorageRepository.initialize(storageConfig);
///
/// // Upload a file
/// final uploadResult = await storage.uploadFile(
///   path: 'images/avatar.png',
///   data: imageBytes,
/// );
///
/// if (uploadResult.success) {
///   print('File uploaded: ${uploadResult.url}');
/// }
///
/// // List files
/// final files = await storage.listFiles(path: 'images');
/// for (var file in files) {
///   print('${file.name} - ${file.formattedSize}');
/// }
///
/// // Download a file
/// final downloadResult = await storage.downloadFile(path: 'images/avatar.png');
/// if (downloadResult.success) {
///   print('Downloaded ${downloadResult.formattedSize}');
/// }
///
/// // Delete a file
/// await storage.deleteFile(path: 'images/old-avatar.png');
/// ```
library supabase_storage;

// Configuration
export 'src/config/supabase_storage_config.dart';

// Models
export 'src/models/storage_error.dart';
export 'src/models/file_info.dart';
export 'src/models/upload_result.dart';
export 'src/models/download_result.dart';

// Services
export 'src/services/storage_service.dart';
export 'src/services/supabase_storage_service.dart';

// Facade
export 'src/facade/storage_repository.dart';
