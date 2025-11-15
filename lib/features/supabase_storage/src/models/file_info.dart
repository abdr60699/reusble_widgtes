/// Represents metadata about a file in storage
class FileInfo {
  /// File name
  final String name;

  /// Full path to the file in the bucket
  final String path;

  /// Bucket name
  final String bucket;

  /// File size in bytes
  final int? size;

  /// MIME type
  final String? mimeType;

  /// Last modified timestamp
  final DateTime? lastModified;

  /// Public URL (if file is publicly accessible)
  final String? publicUrl;

  /// Metadata associated with the file
  final Map<String, dynamic>? metadata;

  const FileInfo({
    required this.name,
    required this.path,
    required this.bucket,
    this.size,
    this.mimeType,
    this.lastModified,
    this.publicUrl,
    this.metadata,
  });

  /// Create FileInfo from Supabase storage object
  factory FileInfo.fromJson(Map<String, dynamic> json, String bucket) {
    return FileInfo(
      name: json['name'] as String,
      path: json['name'] as String, // In Supabase, name is the full path
      bucket: bucket,
      size: json['metadata']?['size'] as int?,
      mimeType: json['metadata']?['mimetype'] as String?,
      lastModified: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : json['created_at'] != null
              ? DateTime.parse(json['created_at'] as String)
              : null,
      metadata: json['metadata'] as Map<String, dynamic>?,
    );
  }

  /// Create FileInfo from Supabase file object (list response)
  factory FileInfo.fromFileObject(Map<String, dynamic> json, String bucket) {
    return FileInfo(
      name: json['name'] as String,
      path: json['name'] as String,
      bucket: bucket,
      size: json['metadata']?['size'] as int?,
      mimeType: json['metadata']?['mimetype'] as String?,
      lastModified: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : json['created_at'] != null
              ? DateTime.parse(json['created_at'] as String)
              : null,
      metadata: json['metadata'] as Map<String, dynamic>?,
    );
  }

  /// Get file extension
  String? get extension {
    final lastDot = name.lastIndexOf('.');
    if (lastDot == -1 || lastDot == name.length - 1) {
      return null;
    }
    return name.substring(lastDot + 1);
  }

  /// Check if file is an image
  bool get isImage {
    return mimeType?.startsWith('image/') ?? false;
  }

  /// Check if file is a video
  bool get isVideo {
    return mimeType?.startsWith('video/') ?? false;
  }

  /// Check if file is a document
  bool get isDocument {
    final docTypes = [
      'application/pdf',
      'application/msword',
      'application/vnd.openxmlformats-officedocument.wordprocessingml.document',
      'application/vnd.ms-excel',
      'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
    ];
    return mimeType != null && docTypes.contains(mimeType);
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

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'path': path,
      'bucket': bucket,
      'size': size,
      'mimeType': mimeType,
      'lastModified': lastModified?.toIso8601String(),
      'publicUrl': publicUrl,
      'metadata': metadata,
    };
  }

  FileInfo copyWith({
    String? name,
    String? path,
    String? bucket,
    int? size,
    String? mimeType,
    DateTime? lastModified,
    String? publicUrl,
    Map<String, dynamic>? metadata,
  }) {
    return FileInfo(
      name: name ?? this.name,
      path: path ?? this.path,
      bucket: bucket ?? this.bucket,
      size: size ?? this.size,
      mimeType: mimeType ?? this.mimeType,
      lastModified: lastModified ?? this.lastModified,
      publicUrl: publicUrl ?? this.publicUrl,
      metadata: metadata ?? this.metadata,
    );
  }

  @override
  String toString() {
    return 'FileInfo(name: $name, path: $path, bucket: $bucket, size: $formattedSize)';
  }
}
