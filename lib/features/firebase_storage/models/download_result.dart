import 'dart:typed_data';
import '../errors/storage_error.dart';
import 'file_info.dart';

/// Represents the result of a download operation
class DownloadResult {
  /// Whether the download was successful
  final bool success;

  /// Downloaded file data (if successful)
  final Uint8List? data;

  /// File information
  final FileInfo? fileInfo;

  /// Error information (if failed)
  final StorageError? error;

  /// Download duration
  final Duration? duration;

  /// Number of bytes downloaded
  final int? bytesTransferred;

  /// Total bytes to download
  final int? totalBytes;

  const DownloadResult({
    required this.success,
    this.data,
    this.fileInfo,
    this.error,
    this.duration,
    this.bytesTransferred,
    this.totalBytes,
  });

  /// Create successful download result
  factory DownloadResult.successResult({
    required Uint8List data,
    FileInfo? fileInfo,
    Duration? duration,
    int? bytesTransferred,
    int? totalBytes,
  }) {
    return DownloadResult(
      success: true,
      data: data,
      fileInfo: fileInfo,
      duration: duration,
      bytesTransferred: bytesTransferred ?? data.length,
      totalBytes: totalBytes ?? data.length,
    );
  }

  /// Create failed download result
  factory DownloadResult.failure(StorageError error) {
    return DownloadResult(
      success: false,
      error: error,
    );
  }

  /// Get file size in bytes
  int? get sizeInBytes => data?.length ?? fileInfo?.size;

  /// Get human-readable file size
  String get formattedSize {
    final size = sizeInBytes;
    if (size == null) return 'Unknown';

    const units = ['B', 'KB', 'MB', 'GB', 'TB'];
    var fileSize = size.toDouble();
    var unitIndex = 0;

    while (fileSize >= 1024 && unitIndex < units.length - 1) {
      fileSize /= 1024;
      unitIndex++;
    }

    return '${fileSize.toStringAsFixed(2)} ${units[unitIndex]}';
  }

  /// Get download progress (0.0 to 1.0)
  double? get progress {
    if (bytesTransferred == null || totalBytes == null || totalBytes == 0) {
      return null;
    }
    return bytesTransferred! / totalBytes!;
  }

  /// Get download progress as percentage (0 to 100)
  int? get progressPercentage {
    final prog = progress;
    if (prog == null) return null;
    return (prog * 100).round();
  }

  /// Check if download is complete
  bool get isComplete {
    if (!success) return false;
    if (totalBytes == null) return true; // No progress tracking
    return bytesTransferred == totalBytes;
  }

  /// Convert to JSON for serialization
  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'dataSize': sizeInBytes,
      'fileInfo': fileInfo?.toJson(),
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
      return 'DownloadResult(success: true, size: $formattedSize$progressStr, file: ${fileInfo?.name})';
    } else {
      return 'DownloadResult(success: false, error: ${error?.message})';
    }
  }
}
