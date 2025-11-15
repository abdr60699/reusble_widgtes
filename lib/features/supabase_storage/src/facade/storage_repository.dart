import 'dart:typed_data';
import '../models/upload_result.dart';
import '../models/download_result.dart';
import '../models/file_info.dart';
import '../models/storage_error.dart';
import '../config/supabase_storage_config.dart';
import '../services/storage_service.dart';
import '../services/supabase_storage_service.dart';

/// Facade for storage operations with simplified API
class StorageRepository {
  final StorageService _storageService;

  static StorageRepository? _instance;

  StorageRepository._internal(this._storageService);

  /// Get singleton instance
  static StorageRepository get instance {
    if (_instance == null) {
      throw StorageError.configurationError(
        'StorageRepository not initialized. Call initialize() first.',
      );
    }
    return _instance!;
  }

  /// Initialize the storage repository with configuration
  static Future<StorageRepository> initialize(
    SupabaseStorageConfig config,
  ) async {
    final storageService = SupabaseStorageService(config: config);
    await storageService.initialize();

    _instance = StorageRepository._internal(storageService);

    return _instance!;
  }

  /// Upload a file to storage
  ///
  /// [bucket] - Bucket name (uses default bucket if not specified)
  /// [path] - File path within the bucket
  /// [data] - File data as bytes
  /// [options] - Optional upload options
  ///
  /// Returns [UploadResult] on success
  Future<UploadResult> uploadFile({
    String? bucket,
    required String path,
    required Uint8List data,
    UploadOptions? options,
  }) {
    return _storageService.uploadFile(
      bucket: bucket,
      path: path,
      data: data,
      options: options,
    );
  }

  /// Upload a file from a local file path
  ///
  /// [bucket] - Bucket name (uses default bucket if not specified)
  /// [path] - Destination path within the bucket
  /// [filePath] - Local file path to upload
  /// [options] - Optional upload options
  ///
  /// Returns [UploadResult] on success
  Future<UploadResult> uploadFileFromPath({
    String? bucket,
    required String path,
    required String filePath,
    UploadOptions? options,
  }) {
    return _storageService.uploadFileFromPath(
      bucket: bucket,
      path: path,
      filePath: filePath,
      options: options,
    );
  }

  /// Download a file from storage
  ///
  /// [bucket] - Bucket name (uses default bucket if not specified)
  /// [path] - File path within the bucket
  ///
  /// Returns [DownloadResult] with file data on success
  Future<DownloadResult> downloadFile({
    String? bucket,
    required String path,
  }) {
    return _storageService.downloadFile(
      bucket: bucket,
      path: path,
    );
  }

  /// Download a file and save it to a local path
  ///
  /// [bucket] - Bucket name (uses default bucket if not specified)
  /// [path] - File path within the bucket
  /// [savePath] - Local path to save the file
  ///
  /// Returns [DownloadResult] on success
  Future<DownloadResult> downloadFileToPath({
    String? bucket,
    required String path,
    required String savePath,
  }) {
    return _storageService.downloadFileToPath(
      bucket: bucket,
      path: path,
      savePath: savePath,
    );
  }

  /// Delete a file from storage
  ///
  /// [bucket] - Bucket name (uses default bucket if not specified)
  /// [path] - File path within the bucket
  ///
  /// Returns true if deletion was successful
  Future<bool> deleteFile({
    String? bucket,
    required String path,
  }) {
    return _storageService.deleteFile(
      bucket: bucket,
      path: path,
    );
  }

  /// Delete multiple files from storage
  ///
  /// [bucket] - Bucket name (uses default bucket if not specified)
  /// [paths] - List of file paths to delete
  ///
  /// Returns list of successfully deleted paths
  Future<List<String>> deleteFiles({
    String? bucket,
    required List<String> paths,
  }) {
    return _storageService.deleteFiles(
      bucket: bucket,
      paths: paths,
    );
  }

  /// List files in a bucket or folder
  ///
  /// [bucket] - Bucket name (uses default bucket if not specified)
  /// [path] - Folder path (null or empty for root)
  /// [limit] - Maximum number of files to return
  /// [offset] - Number of files to skip
  /// [sortBy] - Sort column (name, created_at, updated_at)
  /// [sortOrder] - Sort order (asc or desc)
  ///
  /// Returns list of [FileInfo]
  Future<List<FileInfo>> listFiles({
    String? bucket,
    String? path,
    int? limit,
    int? offset,
    String? sortBy,
    String? sortOrder,
  }) {
    return _storageService.listFiles(
      bucket: bucket,
      path: path,
      limit: limit,
      offset: offset,
      sortBy: sortBy,
      sortOrder: sortOrder,
    );
  }

  /// Get file metadata without downloading
  ///
  /// [bucket] - Bucket name (uses default bucket if not specified)
  /// [path] - File path within the bucket
  ///
  /// Returns [FileInfo] with file metadata
  Future<FileInfo> getFileInfo({
    String? bucket,
    required String path,
  }) {
    return _storageService.getFileInfo(
      bucket: bucket,
      path: path,
    );
  }

  /// Get public URL for a file
  ///
  /// [bucket] - Bucket name (uses default bucket if not specified)
  /// [path] - File path within the bucket
  ///
  /// Returns public URL string (only works for public buckets)
  String getPublicUrl({
    String? bucket,
    required String path,
  }) {
    return _storageService.getPublicUrl(
      bucket: bucket,
      path: path,
    );
  }

  /// Create a signed URL for temporary access to a private file
  ///
  /// [bucket] - Bucket name (uses default bucket if not specified)
  /// [path] - File path within the bucket
  /// [expiresIn] - Duration until the URL expires (default: 1 hour)
  ///
  /// Returns signed URL string
  Future<String> createSignedUrl({
    String? bucket,
    required String path,
    Duration expiresIn = const Duration(hours: 1),
  }) {
    return _storageService.createSignedUrl(
      bucket: bucket,
      path: path,
      expiresIn: expiresIn,
    );
  }

  /// Move a file from one location to another
  ///
  /// [bucket] - Source bucket name (uses default bucket if not specified)
  /// [fromPath] - Source file path
  /// [toPath] - Destination file path
  /// [destinationBucket] - Destination bucket (uses source bucket if not specified)
  ///
  /// Returns true if move was successful
  Future<bool> moveFile({
    String? bucket,
    required String fromPath,
    required String toPath,
    String? destinationBucket,
  }) {
    return _storageService.moveFile(
      bucket: bucket,
      fromPath: fromPath,
      toPath: toPath,
      destinationBucket: destinationBucket,
    );
  }

  /// Copy a file from one location to another
  ///
  /// [bucket] - Source bucket name (uses default bucket if not specified)
  /// [fromPath] - Source file path
  /// [toPath] - Destination file path
  /// [destinationBucket] - Destination bucket (uses source bucket if not specified)
  ///
  /// Returns true if copy was successful
  Future<bool> copyFile({
    String? bucket,
    required String fromPath,
    required String toPath,
    String? destinationBucket,
  }) {
    return _storageService.copyFile(
      bucket: bucket,
      fromPath: fromPath,
      toPath: toPath,
      destinationBucket: destinationBucket,
    );
  }

  /// Check if a file exists
  ///
  /// [bucket] - Bucket name (uses default bucket if not specified)
  /// [path] - File path within the bucket
  ///
  /// Returns true if file exists
  Future<bool> fileExists({
    String? bucket,
    required String path,
  }) {
    return _storageService.fileExists(
      bucket: bucket,
      path: path,
    );
  }

  /// Create an empty bucket
  ///
  /// [bucket] - Bucket name to create
  /// [public] - Whether the bucket should be publicly accessible
  ///
  /// Returns true if bucket was created
  Future<bool> createBucket({
    required String bucket,
    bool public = false,
  }) {
    return _storageService.createBucket(
      bucket: bucket,
      public: public,
    );
  }

  /// Delete a bucket
  ///
  /// [bucket] - Bucket name to delete
  ///
  /// Returns true if bucket was deleted
  Future<bool> deleteBucket({
    required String bucket,
  }) {
    return _storageService.deleteBucket(bucket: bucket);
  }

  /// List all buckets
  ///
  /// Returns list of bucket names
  Future<List<String>> listBuckets() {
    return _storageService.listBuckets();
  }

  /// Empty a bucket (delete all files)
  ///
  /// [bucket] - Bucket name to empty
  ///
  /// Returns number of files deleted (-1 if unknown)
  Future<int> emptyBucket({
    String? bucket,
  }) {
    return _storageService.emptyBucket(bucket: bucket);
  }
}
