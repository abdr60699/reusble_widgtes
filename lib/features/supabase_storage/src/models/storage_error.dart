/// Error codes for storage operations
enum StorageErrorCode {
  /// File not found
  fileNotFound,

  /// Network connection error
  networkError,

  /// File size exceeds limit
  fileSizeLimitExceeded,

  /// File extension not allowed
  invalidFileExtension,

  /// Bucket not found
  bucketNotFound,

  /// Permission denied
  permissionDenied,

  /// Invalid file path
  invalidPath,

  /// Upload failed
  uploadFailed,

  /// Download failed
  downloadFailed,

  /// Delete failed
  deleteFailed,

  /// List operation failed
  listFailed,

  /// File already exists
  fileAlreadyExists,

  /// Invalid bucket name
  invalidBucketName,

  /// Storage quota exceeded
  quotaExceeded,

  /// Authentication required
  authenticationRequired,

  /// Configuration error
  configurationError,

  /// Rate limit exceeded
  rateLimitExceeded,

  /// Invalid file data
  invalidFileData,

  /// Unknown error
  unknownError,
}

/// Represents a storage error
class StorageError implements Exception {
  /// Error code
  final StorageErrorCode code;

  /// Human-readable error message
  final String message;

  /// Optional bucket name
  final String? bucket;

  /// Optional file path
  final String? path;

  /// Optional stack trace
  final StackTrace? stackTrace;

  /// Original error object
  final Object? originalError;

  const StorageError({
    required this.code,
    required this.message,
    this.bucket,
    this.path,
    this.stackTrace,
    this.originalError,
  });

  /// Create error for file not found
  factory StorageError.fileNotFound(String path, [String? bucket]) {
    return StorageError(
      code: StorageErrorCode.fileNotFound,
      message: 'File not found: $path',
      bucket: bucket,
      path: path,
    );
  }

  /// Create error for network issues
  factory StorageError.networkError([String? details]) {
    return StorageError(
      code: StorageErrorCode.networkError,
      message:
          details ?? 'Network connection error. Please check your internet connection.',
    );
  }

  /// Create error for file size limit
  factory StorageError.fileSizeLimitExceeded(int fileSize, int maxSize) {
    return StorageError(
      code: StorageErrorCode.fileSizeLimitExceeded,
      message:
          'File size ($fileSize bytes) exceeds maximum allowed size ($maxSize bytes)',
    );
  }

  /// Create error for invalid file extension
  factory StorageError.invalidFileExtension(String extension, List<String> allowed) {
    return StorageError(
      code: StorageErrorCode.invalidFileExtension,
      message:
          'File extension "$extension" is not allowed. Allowed extensions: ${allowed.join(", ")}',
    );
  }

  /// Create error for bucket not found
  factory StorageError.bucketNotFound(String bucket) {
    return StorageError(
      code: StorageErrorCode.bucketNotFound,
      message: 'Bucket not found: $bucket',
      bucket: bucket,
    );
  }

  /// Create error for permission denied
  factory StorageError.permissionDenied([String? details]) {
    return StorageError(
      code: StorageErrorCode.permissionDenied,
      message: details ?? 'Permission denied. You do not have access to this resource.',
    );
  }

  /// Create error for invalid path
  factory StorageError.invalidPath(String path) {
    return StorageError(
      code: StorageErrorCode.invalidPath,
      message: 'Invalid file path: $path',
      path: path,
    );
  }

  /// Create error for upload failure
  factory StorageError.uploadFailed([String? details]) {
    return StorageError(
      code: StorageErrorCode.uploadFailed,
      message: details ?? 'File upload failed',
    );
  }

  /// Create error for download failure
  factory StorageError.downloadFailed([String? details]) {
    return StorageError(
      code: StorageErrorCode.downloadFailed,
      message: details ?? 'File download failed',
    );
  }

  /// Create error for delete failure
  factory StorageError.deleteFailed([String? details]) {
    return StorageError(
      code: StorageErrorCode.deleteFailed,
      message: details ?? 'File deletion failed',
    );
  }

  /// Create error for list failure
  factory StorageError.listFailed([String? details]) {
    return StorageError(
      code: StorageErrorCode.listFailed,
      message: details ?? 'Failed to list files',
    );
  }

  /// Create error for file already exists
  factory StorageError.fileAlreadyExists(String path, [String? bucket]) {
    return StorageError(
      code: StorageErrorCode.fileAlreadyExists,
      message: 'File already exists: $path',
      bucket: bucket,
      path: path,
    );
  }

  /// Create error for invalid bucket name
  factory StorageError.invalidBucketName(String bucket) {
    return StorageError(
      code: StorageErrorCode.invalidBucketName,
      message: 'Invalid bucket name: $bucket',
      bucket: bucket,
    );
  }

  /// Create error for quota exceeded
  factory StorageError.quotaExceeded() {
    return const StorageError(
      code: StorageErrorCode.quotaExceeded,
      message: 'Storage quota exceeded',
    );
  }

  /// Create error for authentication required
  factory StorageError.authenticationRequired() {
    return const StorageError(
      code: StorageErrorCode.authenticationRequired,
      message: 'Authentication required for this operation',
    );
  }

  /// Create error for configuration issues
  factory StorageError.configurationError(String details) {
    return StorageError(
      code: StorageErrorCode.configurationError,
      message: 'Configuration error: $details',
    );
  }

  /// Create error for rate limiting
  factory StorageError.rateLimitExceeded() {
    return const StorageError(
      code: StorageErrorCode.rateLimitExceeded,
      message: 'Too many requests. Please try again later.',
    );
  }

  /// Create error for invalid file data
  factory StorageError.invalidFileData([String? details]) {
    return StorageError(
      code: StorageErrorCode.invalidFileData,
      message: details ?? 'Invalid file data',
    );
  }

  /// Create error from exception
  factory StorageError.fromException(
    Object error, [
    StackTrace? stackTrace,
    String? bucket,
    String? path,
  ]) {
    return StorageError(
      code: StorageErrorCode.unknownError,
      message: error.toString(),
      bucket: bucket,
      path: path,
      stackTrace: stackTrace,
      originalError: error,
    );
  }

  @override
  String toString() {
    return 'StorageError(code: $code, message: $message, bucket: $bucket, path: $path)';
  }

  Map<String, dynamic> toJson() {
    return {
      'code': code.name,
      'message': message,
      'bucket': bucket,
      'path': path,
    };
  }
}
