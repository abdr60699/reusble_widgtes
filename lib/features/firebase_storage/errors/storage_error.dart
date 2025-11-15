import 'package:firebase_storage/firebase_storage.dart' as fb_storage;

/// Normalized storage error codes
enum StorageErrorCode {
  /// Object (file) not found
  objectNotFound,

  /// Bucket not found
  bucketNotFound,

  /// Project not found
  projectNotFound,

  /// Quota exceeded
  quotaExceeded,

  /// Unauthenticated user
  unauthenticated,

  /// Unauthorized access
  unauthorized,

  /// Retry limit exceeded
  retryLimitExceeded,

  /// Invalid checksum
  invalidChecksum,

  /// Operation canceled
  canceled,

  /// Invalid event name
  invalidEventName,

  /// Invalid URL
  invalidUrl,

  /// Invalid argument
  invalidArgument,

  /// No default bucket
  noDefaultBucket,

  /// Cannot slice blob
  cannotSliceBlob,

  /// Server file wrong size
  serverFileWrongSize,

  /// File size limit exceeded
  fileSizeLimitExceeded,

  /// Invalid file extension
  invalidFileExtension,

  /// Upload failed
  uploadFailed,

  /// Download failed
  downloadFailed,

  /// Delete failed
  deleteFailed,

  /// List failed
  listFailed,

  /// Network error
  networkError,

  /// Invalid path
  invalidPath,

  /// File already exists
  fileAlreadyExists,

  /// Invalid metadata
  invalidMetadata,

  /// Unknown error
  unknown,
}

/// Storage error with friendly message and recovery suggestions
class StorageError implements Exception {
  /// Error code
  final StorageErrorCode code;

  /// User-friendly error message
  final String message;

  /// Technical error details (for logging)
  final String? details;

  /// Recovery suggestion for the user
  final String? recoverySuggestion;

  /// Optional bucket name
  final String? bucket;

  /// Optional file path
  final String? path;

  /// Original Firebase Storage error
  final Object? originalError;

  /// Stack trace
  final StackTrace? stackTrace;

  const StorageError({
    required this.code,
    required this.message,
    this.details,
    this.recoverySuggestion,
    this.bucket,
    this.path,
    this.originalError,
    this.stackTrace,
  });

  /// Create error from Firebase Storage exception
  factory StorageError.fromFirebaseException(
    fb_storage.FirebaseException exception, {
    String? bucket,
    String? path,
    StackTrace? stackTrace,
  }) {
    final code = _mapFirebaseErrorCode(exception.code);
    final message = _getErrorMessage(code, exception);
    final recoverySuggestion = _getRecoverySuggestion(code);

    return StorageError(
      code: code,
      message: message,
      details: exception.message,
      recoverySuggestion: recoverySuggestion,
      bucket: bucket,
      path: path,
      originalError: exception,
      stackTrace: stackTrace ?? exception.stackTrace,
    );
  }

  /// Create error for object not found
  factory StorageError.objectNotFound(String path, [String? bucket]) {
    return StorageError(
      code: StorageErrorCode.objectNotFound,
      message: 'File not found: $path',
      recoverySuggestion: 'Please check that the file exists and the path is correct.',
      bucket: bucket,
      path: path,
    );
  }

  /// Create error for file size limit exceeded
  factory StorageError.fileSizeLimitExceeded(int fileSize, int maxSize) {
    return StorageError(
      code: StorageErrorCode.fileSizeLimitExceeded,
      message: 'File size ($fileSize bytes) exceeds maximum allowed size ($maxSize bytes)',
      recoverySuggestion: 'Please reduce the file size or contact support to increase the limit.',
    );
  }

  /// Create error for invalid file extension
  factory StorageError.invalidFileExtension(String extension, List<String> allowed) {
    return StorageError(
      code: StorageErrorCode.invalidFileExtension,
      message: 'File extension "$extension" is not allowed',
      details: 'Allowed extensions: ${allowed.join(", ")}',
      recoverySuggestion: 'Please use one of the allowed file types: ${allowed.join(", ")}',
    );
  }

  /// Create error for unauthenticated user
  factory StorageError.unauthenticated() {
    return const StorageError(
      code: StorageErrorCode.unauthenticated,
      message: 'Authentication required',
      recoverySuggestion: 'Please sign in to access this file.',
    );
  }

  /// Create error for unauthorized access
  factory StorageError.unauthorized([String? details]) {
    return StorageError(
      code: StorageErrorCode.unauthorized,
      message: 'Permission denied',
      details: details,
      recoverySuggestion: 'You do not have permission to access this file.',
    );
  }

  /// Create error for network issues
  factory StorageError.networkError([String? details]) {
    return StorageError(
      code: StorageErrorCode.networkError,
      message: 'Network error occurred',
      details: details,
      recoverySuggestion: 'Please check your internet connection and try again.',
    );
  }

  /// Create error from generic exception
  factory StorageError.fromException(
    Object error, [
    StackTrace? stackTrace,
    String? bucket,
    String? path,
  ]) {
    if (error is fb_storage.FirebaseException) {
      return StorageError.fromFirebaseException(
        error,
        bucket: bucket,
        path: path,
        stackTrace: stackTrace,
      );
    }

    return StorageError(
      code: StorageErrorCode.unknown,
      message: error.toString(),
      recoverySuggestion: 'An unexpected error occurred. Please try again.',
      bucket: bucket,
      path: path,
      originalError: error,
      stackTrace: stackTrace,
    );
  }

  /// Map Firebase error code to normalized code
  static StorageErrorCode _mapFirebaseErrorCode(String? firebaseCode) {
    switch (firebaseCode) {
      case 'object-not-found':
        return StorageErrorCode.objectNotFound;
      case 'bucket-not-found':
        return StorageErrorCode.bucketNotFound;
      case 'project-not-found':
        return StorageErrorCode.projectNotFound;
      case 'quota-exceeded':
        return StorageErrorCode.quotaExceeded;
      case 'unauthenticated':
        return StorageErrorCode.unauthenticated;
      case 'unauthorized':
        return StorageErrorCode.unauthorized;
      case 'retry-limit-exceeded':
        return StorageErrorCode.retryLimitExceeded;
      case 'invalid-checksum':
        return StorageErrorCode.invalidChecksum;
      case 'canceled':
        return StorageErrorCode.canceled;
      case 'invalid-event-name':
        return StorageErrorCode.invalidEventName;
      case 'invalid-url':
        return StorageErrorCode.invalidUrl;
      case 'invalid-argument':
        return StorageErrorCode.invalidArgument;
      case 'no-default-bucket':
        return StorageErrorCode.noDefaultBucket;
      case 'cannot-slice-blob':
        return StorageErrorCode.cannotSliceBlob;
      case 'server-file-wrong-size':
        return StorageErrorCode.serverFileWrongSize;
      default:
        return StorageErrorCode.unknown;
    }
  }

  /// Get user-friendly error message
  static String _getErrorMessage(
    StorageErrorCode code,
    fb_storage.FirebaseException exception,
  ) {
    switch (code) {
      case StorageErrorCode.objectNotFound:
        return 'File not found';
      case StorageErrorCode.bucketNotFound:
        return 'Storage bucket not found';
      case StorageErrorCode.quotaExceeded:
        return 'Storage quota exceeded';
      case StorageErrorCode.unauthenticated:
        return 'Authentication required';
      case StorageErrorCode.unauthorized:
        return 'Permission denied';
      case StorageErrorCode.retryLimitExceeded:
        return 'Operation failed after multiple retries';
      case StorageErrorCode.invalidChecksum:
        return 'File integrity check failed';
      case StorageErrorCode.canceled:
        return 'Operation was canceled';
      case StorageErrorCode.networkError:
        return 'Network error occurred';
      default:
        return exception.message ?? 'An error occurred';
    }
  }

  /// Get recovery suggestion
  static String? _getRecoverySuggestion(StorageErrorCode code) {
    switch (code) {
      case StorageErrorCode.objectNotFound:
        return 'Please check that the file exists and the path is correct.';
      case StorageErrorCode.quotaExceeded:
        return 'Please delete some files or upgrade your storage plan.';
      case StorageErrorCode.unauthenticated:
        return 'Please sign in to access this file.';
      case StorageErrorCode.unauthorized:
        return 'You do not have permission to access this file.';
      case StorageErrorCode.networkError:
        return 'Please check your internet connection and try again.';
      case StorageErrorCode.retryLimitExceeded:
        return 'Please try again later.';
      default:
        return null;
    }
  }

  @override
  String toString() {
    final buffer = StringBuffer('StorageError($code): $message');
    if (path != null) buffer.write(' [path: $path]');
    if (bucket != null) buffer.write(' [bucket: $bucket]');
    if (details != null) buffer.write('\nDetails: $details');
    if (recoverySuggestion != null) buffer.write('\nSuggestion: $recoverySuggestion');
    return buffer.toString();
  }

  /// Convert to JSON for logging/serialization
  Map<String, dynamic> toJson() {
    return {
      'code': code.name,
      'message': message,
      'details': details,
      'recoverySuggestion': recoverySuggestion,
      'bucket': bucket,
      'path': path,
    };
  }
}
