import 'dart:typed_data';
import 'storage_error.dart';
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

  const DownloadResult({
    required this.success,
    this.data,
    this.fileInfo,
    this.error,
    this.duration,
  });

  /// Create successful download result
  factory DownloadResult.successResult({
    required Uint8List data,
    FileInfo? fileInfo,
    Duration? duration,
  }) {
    return DownloadResult(
      success: true,
      data: data,
      fileInfo: fileInfo,
      duration: duration,
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
  int? get sizeInBytes => data?.length;

  /// Get human-readable file size
  String get formattedSize {
    if (sizeInBytes == null) return 'Unknown';

    const units = ['B', 'KB', 'MB', 'GB', 'TB'];
    var fileSize = sizeInBytes!.toDouble();
    var unitIndex = 0;

    while (fileSize >= 1024 && unitIndex < units.length - 1) {
      fileSize /= 1024;
      unitIndex++;
    }

    return '${fileSize.toStringAsFixed(2)} ${units[unitIndex]}';
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'dataSize': sizeInBytes,
      'fileInfo': fileInfo?.toJson(),
      'error': error?.toJson(),
      'duration': duration?.inMilliseconds,
    };
  }

  @override
  String toString() {
    if (success) {
      return 'DownloadResult(success: true, size: $formattedSize, file: ${fileInfo?.name})';
    } else {
      return 'DownloadResult(success: false, error: ${error?.message})';
    }
  }
}
