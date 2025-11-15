import 'dart:typed_data';
import '../models/upload_result.dart';
import '../models/download_result.dart';
import '../models/file_info.dart';
import '../models/storage_error.dart';
import '../config/supabase_storage_config.dart';

/// Abstract interface for storage services
abstract class StorageService {
  /// Upload a file to storage
  ///
  /// [bucket] - Bucket name (uses default bucket if not specified)
  /// [path] - File path within the bucket
  /// [data] - File data as bytes
  /// [options] - Optional upload options
  ///
  /// Returns [UploadResult] on success
  /// Throws [StorageError] on failure
  Future<UploadResult> uploadFile({
    String? bucket,
    required String path,
    required Uint8List data,
    UploadOptions? options,
  });

  /// Upload a file from a local file path
  ///
  /// [bucket] - Bucket name (uses default bucket if not specified)
  /// [path] - Destination path within the bucket
  /// [filePath] - Local file path to upload
  /// [options] - Optional upload options
  ///
  /// Returns [UploadResult] on success
  /// Throws [StorageError] on failure
  Future<UploadResult> uploadFileFromPath({
    String? bucket,
    required String path,
    required String filePath,
    UploadOptions? options,
  });

  /// Download a file from storage
  ///
  /// [bucket] - Bucket name (uses default bucket if not specified)
  /// [path] - File path within the bucket
  ///
  /// Returns [DownloadResult] with file data on success
  /// Throws [StorageError] on failure
  Future<DownloadResult> downloadFile({
    String? bucket,
    required String path,
  });

  /// Download a file and save it to a local path
  ///
  /// [bucket] - Bucket name (uses default bucket if not specified)
  /// [path] - File path within the bucket
  /// [savePath] - Local path to save the file
  ///
  /// Returns [DownloadResult] on success
  /// Throws [StorageError] on failure
  Future<DownloadResult> downloadFileToPath({
    String? bucket,
    required String path,
    required String savePath,
  });

  /// Delete a file from storage
  ///
  /// [bucket] - Bucket name (uses default bucket if not specified)
  /// [path] - File path within the bucket
  ///
  /// Returns true if deletion was successful
  /// Throws [StorageError] on failure
  Future<bool> deleteFile({
    String? bucket,
    required String path,
  });

  /// Delete multiple files from storage
  ///
  /// [bucket] - Bucket name (uses default bucket if not specified)
  /// [paths] - List of file paths to delete
  ///
  /// Returns list of successfully deleted paths
  /// Throws [StorageError] on failure
  Future<List<String>> deleteFiles({
    String? bucket,
    required List<String> paths,
  });

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
  /// Throws [StorageError] on failure
  Future<List<FileInfo>> listFiles({
    String? bucket,
    String? path,
    int? limit,
    int? offset,
    String? sortBy,
    String? sortOrder,
  });

  /// Get file metadata without downloading
  ///
  /// [bucket] - Bucket name (uses default bucket if not specified)
  /// [path] - File path within the bucket
  ///
  /// Returns [FileInfo] with file metadata
  /// Throws [StorageError] on failure
  Future<FileInfo> getFileInfo({
    String? bucket,
    required String path,
  });

  /// Get public URL for a file
  ///
  /// [bucket] - Bucket name (uses default bucket if not specified)
  /// [path] - File path within the bucket
  ///
  /// Returns public URL string (only works for public buckets)
  /// Throws [StorageError] on failure
  String getPublicUrl({
    String? bucket,
    required String path,
  });

  /// Create a signed URL for temporary access to a private file
  ///
  /// [bucket] - Bucket name (uses default bucket if not specified)
  /// [path] - File path within the bucket
  /// [expiresIn] - Duration until the URL expires (default: 1 hour)
  ///
  /// Returns signed URL string
  /// Throws [StorageError] on failure
  Future<String> createSignedUrl({
    String? bucket,
    required String path,
    Duration expiresIn = const Duration(hours: 1),
  });

  /// Move a file from one location to another
  ///
  /// [bucket] - Source bucket name (uses default bucket if not specified)
  /// [fromPath] - Source file path
  /// [toPath] - Destination file path
  /// [destinationBucket] - Destination bucket (uses source bucket if not specified)
  ///
  /// Returns true if move was successful
  /// Throws [StorageError] on failure
  Future<bool> moveFile({
    String? bucket,
    required String fromPath,
    required String toPath,
    String? destinationBucket,
  });

  /// Copy a file from one location to another
  ///
  /// [bucket] - Source bucket name (uses default bucket if not specified)
  /// [fromPath] - Source file path
  /// [toPath] - Destination file path
  /// [destinationBucket] - Destination bucket (uses source bucket if not specified)
  ///
  /// Returns true if copy was successful
  /// Throws [StorageError] on failure
  Future<bool> copyFile({
    String? bucket,
    required String fromPath,
    required String toPath,
    String? destinationBucket,
  });

  /// Check if a file exists
  ///
  /// [bucket] - Bucket name (uses default bucket if not specified)
  /// [path] - File path within the bucket
  ///
  /// Returns true if file exists
  Future<bool> fileExists({
    String? bucket,
    required String path,
  });

  /// Create an empty bucket
  ///
  /// [bucket] - Bucket name to create
  /// [public] - Whether the bucket should be publicly accessible
  ///
  /// Returns true if bucket was created
  /// Throws [StorageError] on failure
  Future<bool> createBucket({
    required String bucket,
    bool public = false,
  });

  /// Delete a bucket
  ///
  /// [bucket] - Bucket name to delete
  ///
  /// Returns true if bucket was deleted
  /// Throws [StorageError] on failure
  Future<bool> deleteBucket({
    required String bucket,
  });

  /// List all buckets
  ///
  /// Returns list of bucket names
  /// Throws [StorageError] on failure
  Future<List<String>> listBuckets();

  /// Empty a bucket (delete all files)
  ///
  /// [bucket] - Bucket name to empty
  ///
  /// Returns number of files deleted
  /// Throws [StorageError] on failure
  Future<int> emptyBucket({
    String? bucket,
  });
}
