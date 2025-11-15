import '../errors/storage_error.dart';
import 'file_info.dart';

/// Represents the result of an upload operation
class UploadResult {
  /// Whether the upload was successful
  final bool success;

  /// File information (if successful)
  final FileInfo? fileInfo;

  /// Download URL (if successful and available)
  final String? downloadUrl;

  /// Error information (if failed)
  final StorageError? error;

  /// Upload duration
  final Duration? duration;

  /// Number of bytes uploaded
  final int? bytesTransferred;

  /// Total bytes to upload
  final int? totalBytes;

  const UploadResult({
    required this.success,
    this.fileInfo,
    this.downloadUrl,
    this.error,
    this.duration,
    this.bytesTransferred,
    this.totalBytes,
  });

  /// Create successful upload result
  factory UploadResult.successResult({
    required FileInfo fileInfo,
    String? downloadUrl,
    Duration? duration,
    int? bytesTransferred,
    int? totalBytes,
  }) {
    return UploadResult(
      success: true,
      fileInfo: fileInfo,
      downloadUrl: downloadUrl ?? fileInfo.downloadUrl,
      duration: duration,
      bytesTransferred: bytesTransferred,
      totalBytes: totalBytes,
    );
  }

  /// Create failed upload result
  factory UploadResult.failure(StorageError error) {
    return UploadResult(
      success: false,
      error: error,
    );
  }

  /// Get upload progress (0.0 to 1.0)
  double? get progress {
    if (bytesTransferred == null || totalBytes == null || totalBytes == 0) {
      return null;
    }
    return bytesTransferred! / totalBytes!;
  }

  /// Get upload progress as percentage (0 to 100)
  int? get progressPercentage {
    final prog = progress;
    if (prog == null) return null;
    return (prog * 100).round();
  }

  /// Check if upload is complete
  bool get isComplete {
    if (!success) return false;
    if (totalBytes == null) return true; // No progress tracking
    return bytesTransferred == totalBytes;
  }

  /// Convert to JSON for serialization
  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'fileInfo': fileInfo?.toJson(),
      'downloadUrl': downloadUrl,
      'error': error?.toJson(),
      'duration': duration?.inMilliseconds,
      'bytesTransferred': bytesTransferred,
      'totalBytes': totalBytes,
    };
  }

  @override
  String toString() {
    if (success) {
      final progress = progressPercentage;
      final progressStr = progress != null ? ' ($progress%)' : '';
      return 'UploadResult(success: true, file: ${fileInfo?.name}$progressStr, url: $downloadUrl)';
    } else {
      return 'UploadResult(success: false, error: ${error?.message})';
    }
  }
}
