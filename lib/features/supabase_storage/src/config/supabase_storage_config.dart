import '../../supabase_auth/supabase_auth.dart';

/// File upload options
class UploadOptions {
  /// Cache control header
  final String? cacheControl;

  /// Content type (MIME type)
  final String? contentType;

  /// Make file publicly accessible
  final bool upsert;

  const UploadOptions({
    this.cacheControl,
    this.contentType,
    this.upsert = false,
  });

  /// Default options for public files
  static const public = UploadOptions(
    cacheControl: '3600',
    upsert: false,
  );

  /// Default options for private files
  static const private = UploadOptions(
    cacheControl: '3600',
    upsert: false,
  );
}

/// Configuration for Supabase Storage
class SupabaseStorageConfig {
  /// Supabase project URL
  final String supabaseUrl;

  /// Supabase anonymous key
  final String supabaseAnonKey;

  /// Default bucket name for storage operations
  final String? defaultBucket;

  /// Maximum file size in bytes (default: 50MB)
  final int maxFileSizeBytes;

  /// Allowed file extensions (null means all allowed)
  final List<String>? allowedExtensions;

  /// Enable debug logging
  final bool enableLogging;

  /// Default upload options
  final UploadOptions defaultUploadOptions;

  /// Custom storage URL (for self-hosted)
  final String? storageUrl;

  const SupabaseStorageConfig({
    required this.supabaseUrl,
    required this.supabaseAnonKey,
    this.defaultBucket,
    this.maxFileSizeBytes = 52428800, // 50MB
    this.allowedExtensions,
    this.enableLogging = false,
    this.defaultUploadOptions = UploadOptions.private,
    this.storageUrl,
  });

  /// Create configuration from existing auth config
  factory SupabaseStorageConfig.fromAuthConfig(
    SupabaseAuthConfig authConfig, {
    String? defaultBucket,
    int maxFileSizeBytes = 52428800,
    List<String>? allowedExtensions,
    bool? enableLogging,
    UploadOptions defaultUploadOptions = UploadOptions.private,
    String? storageUrl,
  }) {
    return SupabaseStorageConfig(
      supabaseUrl: authConfig.supabaseUrl,
      supabaseAnonKey: authConfig.supabaseAnonKey,
      defaultBucket: defaultBucket,
      maxFileSizeBytes: maxFileSizeBytes,
      allowedExtensions: allowedExtensions,
      enableLogging: enableLogging ?? authConfig.enableLogging,
      defaultUploadOptions: defaultUploadOptions,
      storageUrl: storageUrl,
    );
  }

  /// Create configuration from environment variables
  factory SupabaseStorageConfig.fromEnvironment({
    required Map<String, String> env,
    String? defaultBucket,
    int maxFileSizeBytes = 52428800,
    List<String>? allowedExtensions,
    bool enableLogging = false,
    UploadOptions defaultUploadOptions = UploadOptions.private,
  }) {
    final supabaseUrl = env['SUPABASE_URL'];
    final supabaseAnonKey = env['SUPABASE_ANON_KEY'];

    if (supabaseUrl == null || supabaseAnonKey == null) {
      throw Exception(
        'SUPABASE_URL and SUPABASE_ANON_KEY must be set in environment',
      );
    }

    return SupabaseStorageConfig(
      supabaseUrl: supabaseUrl,
      supabaseAnonKey: supabaseAnonKey,
      defaultBucket: defaultBucket ?? env['SUPABASE_DEFAULT_BUCKET'],
      maxFileSizeBytes: int.tryParse(env['SUPABASE_MAX_FILE_SIZE'] ?? '') ??
          maxFileSizeBytes,
      allowedExtensions: allowedExtensions,
      enableLogging: enableLogging,
      defaultUploadOptions: defaultUploadOptions,
      storageUrl: env['SUPABASE_STORAGE_URL'],
    );
  }

  SupabaseStorageConfig copyWith({
    String? supabaseUrl,
    String? supabaseAnonKey,
    String? defaultBucket,
    int? maxFileSizeBytes,
    List<String>? allowedExtensions,
    bool? enableLogging,
    UploadOptions? defaultUploadOptions,
    String? storageUrl,
  }) {
    return SupabaseStorageConfig(
      supabaseUrl: supabaseUrl ?? this.supabaseUrl,
      supabaseAnonKey: supabaseAnonKey ?? this.supabaseAnonKey,
      defaultBucket: defaultBucket ?? this.defaultBucket,
      maxFileSizeBytes: maxFileSizeBytes ?? this.maxFileSizeBytes,
      allowedExtensions: allowedExtensions ?? this.allowedExtensions,
      enableLogging: enableLogging ?? this.enableLogging,
      defaultUploadOptions: defaultUploadOptions ?? this.defaultUploadOptions,
      storageUrl: storageUrl ?? this.storageUrl,
    );
  }

  /// Validate if a file extension is allowed
  bool isExtensionAllowed(String extension) {
    if (allowedExtensions == null) return true;
    return allowedExtensions!.contains(extension.toLowerCase());
  }

  /// Validate if a file size is within limits
  bool isFileSizeAllowed(int sizeInBytes) {
    return sizeInBytes <= maxFileSizeBytes;
  }
}
