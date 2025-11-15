import 'dart:io';
import 'dart:typed_data';
import '../repository/storage_repository.dart';
import '../models/file_info.dart';
import '../models/upload_result.dart';
import '../models/download_result.dart';
import '../errors/storage_error.dart';
import '../utils/storage_config.dart';

/// High-level service for Firebase Storage operations
///
/// This is the service facade that provides a clean API for storage operations.
/// It orchestrates calls to the repository layer.
class StorageService {
  final StorageRepository _repository;

  StorageService({
    required StorageRepository repository,
  }) : _repository = repository;

  /// Get storage configuration
  StorageConfig get config => _repository.config;

  // ========== Upload Operations ==========

  /// Upload bytes to storage
  ///
  /// [path] - Destination path in storage (e.g., 'images/avatar.png')
  /// [data] - File data as bytes
  /// [bucket] - Optional bucket name (uses default if not specified)
  /// [options] - Optional upload options (content type, cache control, etc.)
  /// [onProgress] - Optional callback for upload progress
  ///
  /// Returns [UploadResult] with file info and download URL on success
  ///
  /// Throws [StorageError] on failure
  Future<UploadResult> uploadBytes({
    required String path,
    required Uint8List data,
    String? bucket,
    UploadOptions? options,
    void Function(int bytesTransferred, int totalBytes)? onProgress,
  }) {
    return _repository.uploadBytes(
      path: path,
      data: data,
      bucket: bucket,
      options: options,
      onProgress: onProgress,
    );
  }

  /// Upload file from local file system
  ///
  /// [path] - Destination path in storage (e.g., 'images/avatar.png')
  /// [file] - Local file to upload
  /// [bucket] - Optional bucket name (uses default if not specified)
  /// [options] - Optional upload options (content type, cache control, etc.)
  /// [onProgress] - Optional callback for upload progress
  ///
  /// Returns [UploadResult] with file info and download URL on success
  ///
  /// Throws [StorageError] on failure
  Future<UploadResult> uploadFile({
    required String path,
    required File file,
    String? bucket,
    UploadOptions? options,
    void Function(int bytesTransferred, int totalBytes)? onProgress,
  }) {
    return _repository.uploadFile(
      path: path,
      file: file,
      bucket: bucket,
      options: options,
      onProgress: onProgress,
    );
  }

  /// Upload file from file path
  ///
  /// Convenience method that creates File object from path
  Future<UploadResult> uploadFromPath({
    required String path,
    required String filePath,
    String? bucket,
    UploadOptions? options,
    void Function(int bytesTransferred, int totalBytes)? onProgress,
  }) {
    return uploadFile(
      path: path,
      file: File(filePath),
      bucket: bucket,
      options: options,
      onProgress: onProgress,
    );
  }

  // ========== Download Operations ==========

  /// Download file to memory
  ///
  /// [path] - File path in storage
  /// [bucket] - Optional bucket name (uses default if not specified)
  /// [maxSize] - Optional maximum size in bytes
  ///
  /// Returns [DownloadResult] with file data on success
  ///
  /// Throws [StorageError] on failure
  Future<DownloadResult> downloadBytes({
    required String path,
    String? bucket,
    int? maxSize,
  }) {
    return _repository.downloadBytes(
      path: path,
      bucket: bucket,
      maxSize: maxSize,
    );
  }

  /// Download file to local file system
  ///
  /// [path] - File path in storage
  /// [destination] - Local file to save to
  /// [bucket] - Optional bucket name (uses default if not specified)
  ///
  /// Returns [DownloadResult] with file data on success
  ///
  /// Throws [StorageError] on failure
  Future<DownloadResult> downloadFile({
    required String path,
    required File destination,
    String? bucket,
  }) {
    return _repository.downloadFile(
      path: path,
      destination: destination,
      bucket: bucket,
    );
  }

  /// Download file to file path
  ///
  /// Convenience method that creates File object from path
  Future<DownloadResult> downloadToPath({
    required String path,
    required String savePath,
    String? bucket,
  }) {
    return downloadFile(
      path: path,
      destination: File(savePath),
      bucket: bucket,
    );
  }

  // ========== Delete Operations ==========

  /// Delete a file from storage
  ///
  /// [path] - File path in storage
  /// [bucket] - Optional bucket name (uses default if not specified)
  ///
  /// Throws [StorageError] on failure
  Future<void> deleteFile({
    required String path,
    String? bucket,
  }) {
    return _repository.deleteFile(path: path, bucket: bucket);
  }

  /// Delete multiple files
  ///
  /// [paths] - List of file paths to delete
  /// [bucket] - Optional bucket name (uses default if not specified)
  ///
  /// Returns list of paths that were successfully deleted
  Future<List<String>> deleteFiles({
    required List<String> paths,
    String? bucket,
  }) async {
    final deleted = <String>[];

    for (final path in paths) {
      try {
        await deleteFile(path: path, bucket: bucket);
        deleted.add(path);
      } catch (e) {
        // Continue with next file
        if (config.enableLogging) {
          print('[StorageService] Failed to delete $path: $e');
        }
      }
    }

    return deleted;
  }

  // ========== List Operations ==========

  /// List files in a directory
  ///
  /// [path] - Directory path in storage
  /// [bucket] - Optional bucket name (uses default if not specified)
  /// [maxResults] - Optional maximum number of results
  ///
  /// Returns list of [FileInfo] for files in the directory
  ///
  /// Throws [StorageError] on failure
  Future<List<FileInfo>> listFiles({
    required String path,
    String? bucket,
    int? maxResults,
  }) {
    return _repository.listFiles(
      path: path,
      bucket: bucket,
      maxResults: maxResults,
    );
  }

  /// List all files in the root directory
  Future<List<FileInfo>> listAllFiles({
    String? bucket,
    int? maxResults,
  }) {
    return listFiles(
      path: '',
      bucket: bucket,
      maxResults: maxResults,
    );
  }

  // ========== Metadata Operations ==========

  /// Get file metadata without downloading
  ///
  /// [path] - File path in storage
  /// [bucket] - Optional bucket name (uses default if not specified)
  ///
  /// Returns [FileInfo] with file metadata
  ///
  /// Throws [StorageError] on failure
  Future<FileInfo> getFileInfo({
    required String path,
    String? bucket,
  }) {
    return _repository.getMetadata(path: path, bucket: bucket);
  }

  /// Check if a file exists
  ///
  /// [path] - File path in storage
  /// [bucket] - Optional bucket name (uses default if not specified)
  ///
  /// Returns true if file exists, false otherwise
  Future<bool> fileExists({
    required String path,
    String? bucket,
  }) async {
    try {
      await getFileInfo(path: path, bucket: bucket);
      return true;
    } on StorageError catch (e) {
      if (e.code == StorageErrorCode.objectNotFound) {
        return false;
      }
      rethrow;
    }
  }

  // ========== URL Operations ==========

  /// Get download URL for a file
  ///
  /// [path] - File path in storage
  /// [bucket] - Optional bucket name (uses default if not specified)
  ///
  /// Returns download URL string
  ///
  /// Throws [StorageError] on failure
  Future<String> getDownloadUrl({
    required String path,
    String? bucket,
  }) {
    return _repository.getDownloadUrl(path: path, bucket: bucket);
  }

  // ========== Helper Methods ==========

  /// Validate if a file can be uploaded
  ///
  /// [path] - File path
  /// [fileSize] - File size in bytes
  ///
  /// Returns true if valid, throws [StorageError] if invalid
  bool validateUpload({
    required String path,
    required int fileSize,
  }) {
    // Check file size
    if (config.validateFileSize && !config.isFileSizeAllowed(fileSize)) {
      throw StorageError.fileSizeLimitExceeded(
        fileSize,
        config.maxFileSizeBytes,
      );
    }

    // Check file extension
    if (config.validateExtensions && config.allowedExtensions != null) {
      final extension = path.split('.').last.toLowerCase();
      if (!config.isExtensionAllowed(extension)) {
        throw StorageError.invalidFileExtension(
          extension,
          config.allowedExtensions!,
        );
      }
    }

    return true;
  }

  /// Get storage configuration
  StorageConfig getConfig() => config;
}
