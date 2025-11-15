import 'storage_error.dart';
import 'file_info.dart';

/// Represents the result of an upload operation
class UploadResult {
  /// Whether the upload was successful
  final bool success;

  /// File information (if successful)
  final FileInfo? fileInfo;

  /// Public URL to the uploaded file (if publicly accessible)
  final String? publicUrl;

  /// Signed URL to the uploaded file (if authentication required)
  final String? signedUrl;

  /// Error information (if failed)
  final StorageError? error;

  /// Upload duration
  final Duration? duration;

  const UploadResult({
    required this.success,
    this.fileInfo,
    this.publicUrl,
    this.signedUrl,
    this.error,
    this.duration,
  });

  /// Create successful upload result
  factory UploadResult.successResult({
    required FileInfo fileInfo,
    String? publicUrl,
    String? signedUrl,
    Duration? duration,
  }) {
    return UploadResult(
      success: true,
      fileInfo: fileInfo,
      publicUrl: publicUrl,
      signedUrl: signedUrl,
      duration: duration,
    );
  }

  /// Create failed upload result
  factory UploadResult.failure(StorageError error) {
    return UploadResult(
      success: false,
      error: error,
    );
  }

  /// Get the best available URL (public or signed)
  String? get url => publicUrl ?? signedUrl;

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'fileInfo': fileInfo?.toJson(),
      'publicUrl': publicUrl,
      'signedUrl': signedUrl,
      'error': error?.toJson(),
      'duration': duration?.inMilliseconds,
    };
  }

  @override
  String toString() {
    if (success) {
      return 'UploadResult(success: true, file: ${fileInfo?.name}, url: $url)';
    } else {
      return 'UploadResult(success: false, error: ${error?.message})';
    }
  }
}
