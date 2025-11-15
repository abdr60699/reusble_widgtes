import 'package:firebase_storage/firebase_storage.dart' as fb_storage;

/// Represents metadata about a file in Firebase Storage
class FileInfo {
  /// File name
  final String name;

  /// Full path to the file in the bucket
  final String path;

  /// Bucket name
  final String bucket;

  /// File size in bytes
  final int? size;

  /// MIME type / Content type
  final String? contentType;

  /// Time the file was created
  final DateTime? createdAt;

  /// Time the file was last updated
  final DateTime? updatedAt;

  /// MD5 hash of the file
  final String? md5Hash;

  /// Download URL (if available)
  final String? downloadUrl;

  /// Custom metadata
  final Map<String, String>? customMetadata;

  /// Content encoding (e.g., gzip)
  final String? contentEncoding;

  /// Content language
  final String? contentLanguage;

  /// Cache control header
  final String? cacheControl;

  /// Content disposition header
  final String? contentDisposition;

  const FileInfo({
    required this.name,
    required this.path,
    required this.bucket,
    this.size,
    this.contentType,
    this.createdAt,
    this.updatedAt,
    this.md5Hash,
    this.downloadUrl,
    this.customMetadata,
    this.contentEncoding,
    this.contentLanguage,
    this.cacheControl,
    this.contentDisposition,
  });

  /// Create FileInfo from Firebase Storage metadata
  factory FileInfo.fromMetadata(
    fb_storage.FullMetadata metadata, {
    String? downloadUrl,
  }) {
    return FileInfo(
      name: metadata.name ?? '',
      path: metadata.fullPath,
      bucket: metadata.bucket,
      size: metadata.size,
      contentType: metadata.contentType,
      createdAt: metadata.timeCreated,
      updatedAt: metadata.updated,
      md5Hash: metadata.md5Hash,
      downloadUrl: downloadUrl,
      customMetadata: metadata.customMetadata,
      contentEncoding: metadata.contentEncoding,
      contentLanguage: metadata.contentLanguage,
      cacheControl: metadata.cacheControl,
      contentDisposition: metadata.contentDisposition,
    );
  }

  /// Create FileInfo from Firebase Storage Reference
  factory FileInfo.fromReference(
    fb_storage.Reference ref, {
    fb_storage.FullMetadata? metadata,
    String? downloadUrl,
  }) {
    if (metadata != null) {
      return FileInfo.fromMetadata(metadata, downloadUrl: downloadUrl);
    }

    return FileInfo(
      name: ref.name,
      path: ref.fullPath,
      bucket: ref.bucket,
      downloadUrl: downloadUrl,
    );
  }

  /// Get file extension
  String? get extension {
    final lastDot = name.lastIndexOf('.');
    if (lastDot == -1 || lastDot == name.length - 1) {
      return null;
    }
    return name.substring(lastDot + 1).toLowerCase();
  }

  /// Check if file is an image
  bool get isImage {
    return contentType?.startsWith('image/') ?? _isImageExtension(extension);
  }

  /// Check if file is a video
  bool get isVideo {
    return contentType?.startsWith('video/') ?? _isVideoExtension(extension);
  }

  /// Check if file is audio
  bool get isAudio {
    return contentType?.startsWith('audio/') ?? _isAudioExtension(extension);
  }

  /// Check if file is a document
  bool get isDocument {
    if (contentType != null) {
      return _isDocumentContentType(contentType!);
    }
    return _isDocumentExtension(extension);
  }

  /// Get human-readable file size
  String get formattedSize {
    if (size == null) return 'Unknown';

    const units = ['B', 'KB', 'MB', 'GB', 'TB'];
    var fileSize = size!.toDouble();
    var unitIndex = 0;

    while (fileSize >= 1024 && unitIndex < units.length - 1) {
      fileSize /= 1024;
      unitIndex++;
    }

    return '${fileSize.toStringAsFixed(2)} ${units[unitIndex]}';
  }

  /// Get parent folder path
  String? get parentPath {
    final lastSlash = path.lastIndexOf('/');
    if (lastSlash == -1) return null;
    return path.substring(0, lastSlash);
  }

  /// Get file name without extension
  String get nameWithoutExtension {
    final lastDot = name.lastIndexOf('.');
    if (lastDot == -1) return name;
    return name.substring(0, lastDot);
  }

  static bool _isImageExtension(String? ext) {
    if (ext == null) return false;
    const imageExts = ['jpg', 'jpeg', 'png', 'gif', 'bmp', 'webp', 'svg', 'ico'];
    return imageExts.contains(ext);
  }

  static bool _isVideoExtension(String? ext) {
    if (ext == null) return false;
    const videoExts = ['mp4', 'avi', 'mov', 'wmv', 'flv', 'webm', 'mkv'];
    return videoExts.contains(ext);
  }

  static bool _isAudioExtension(String? ext) {
    if (ext == null) return false;
    const audioExts = ['mp3', 'wav', 'ogg', 'flac', 'aac', 'm4a', 'wma'];
    return audioExts.contains(ext);
  }

  static bool _isDocumentContentType(String contentType) {
    const docTypes = [
      'application/pdf',
      'application/msword',
      'application/vnd.openxmlformats-officedocument.wordprocessingml.document',
      'application/vnd.ms-excel',
      'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
      'application/vnd.ms-powerpoint',
      'application/vnd.openxmlformats-officedocument.presentationml.presentation',
      'text/plain',
      'text/csv',
    ];
    return docTypes.contains(contentType);
  }

  static bool _isDocumentExtension(String? ext) {
    if (ext == null) return false;
    const docExts = [
      'pdf',
      'doc',
      'docx',
      'xls',
      'xlsx',
      'ppt',
      'pptx',
      'txt',
      'csv'
    ];
    return docExts.contains(ext);
  }

  /// Convert to JSON for serialization
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'path': path,
      'bucket': bucket,
      'size': size,
      'contentType': contentType,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'md5Hash': md5Hash,
      'downloadUrl': downloadUrl,
      'customMetadata': customMetadata,
      'contentEncoding': contentEncoding,
      'contentLanguage': contentLanguage,
      'cacheControl': cacheControl,
      'contentDisposition': contentDisposition,
    };
  }

  /// Create from JSON
  factory FileInfo.fromJson(Map<String, dynamic> json) {
    return FileInfo(
      name: json['name'] as String,
      path: json['path'] as String,
      bucket: json['bucket'] as String,
      size: json['size'] as int?,
      contentType: json['contentType'] as String?,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'] as String)
          : null,
      md5Hash: json['md5Hash'] as String?,
      downloadUrl: json['downloadUrl'] as String?,
      customMetadata: json['customMetadata'] != null
          ? Map<String, String>.from(json['customMetadata'] as Map)
          : null,
      contentEncoding: json['contentEncoding'] as String?,
      contentLanguage: json['contentLanguage'] as String?,
      cacheControl: json['cacheControl'] as String?,
      contentDisposition: json['contentDisposition'] as String?,
    );
  }

  /// Create a copy with updated fields
  FileInfo copyWith({
    String? name,
    String? path,
    String? bucket,
    int? size,
    String? contentType,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? md5Hash,
    String? downloadUrl,
    Map<String, String>? customMetadata,
    String? contentEncoding,
    String? contentLanguage,
    String? cacheControl,
    String? contentDisposition,
  }) {
    return FileInfo(
      name: name ?? this.name,
      path: path ?? this.path,
      bucket: bucket ?? this.bucket,
      size: size ?? this.size,
      contentType: contentType ?? this.contentType,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      md5Hash: md5Hash ?? this.md5Hash,
      downloadUrl: downloadUrl ?? this.downloadUrl,
      customMetadata: customMetadata ?? this.customMetadata,
      contentEncoding: contentEncoding ?? this.contentEncoding,
      contentLanguage: contentLanguage ?? this.contentLanguage,
      cacheControl: cacheControl ?? this.cacheControl,
      contentDisposition: contentDisposition ?? this.contentDisposition,
    );
  }

  @override
  String toString() {
    return 'FileInfo(name: $name, path: $path, size: $formattedSize)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is FileInfo && other.path == path && other.bucket == bucket;
  }

  @override
  int get hashCode => Object.hash(path, bucket);
}
