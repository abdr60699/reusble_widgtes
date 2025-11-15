import 'dart:io';
import 'dart:typed_data';
import 'package:supabase_flutter/supabase_flutter.dart' as supabase;
import '../models/upload_result.dart';
import '../models/download_result.dart';
import '../models/file_info.dart';
import '../models/storage_error.dart';
import '../config/supabase_storage_config.dart';
import 'storage_service.dart';

/// Implementation of [StorageService] using Supabase Storage as the backend
class SupabaseStorageService implements StorageService {
  final SupabaseStorageConfig config;
  supabase.SupabaseClient? _client;

  SupabaseStorageService({
    required this.config,
  });

  /// Initialize Supabase client
  Future<void> initialize() async {
    try {
      // Check if Supabase is already initialized
      if (supabase.Supabase.instance.initialized) {
        _client = supabase.Supabase.instance.client;
        if (config.enableLogging) {
          print('SupabaseStorageService: Using existing Supabase client');
        }
      } else {
        // Initialize new Supabase client
        await supabase.Supabase.initialize(
          url: config.supabaseUrl,
          anonKey: config.supabaseAnonKey,
        );
        _client = supabase.Supabase.instance.client;
        if (config.enableLogging) {
          print('SupabaseStorageService: Initialized new Supabase client');
        }
      }
    } catch (e, stackTrace) {
      throw StorageError.fromException(e, stackTrace);
    }
  }

  supabase.SupabaseClient get client {
    if (_client == null) {
      throw StorageError.configurationError(
        'Supabase client not initialized. Call initialize() first.',
      );
    }
    return _client!;
  }

  String _getBucket(String? bucket) {
    final bucketName = bucket ?? config.defaultBucket;
    if (bucketName == null || bucketName.isEmpty) {
      throw StorageError.configurationError(
        'No bucket specified and no default bucket configured',
      );
    }
    return bucketName;
  }

  void _validateFile(String path, Uint8List data) {
    // Check file size
    if (!config.isFileSizeAllowed(data.length)) {
      throw StorageError.fileSizeLimitExceeded(
        data.length,
        config.maxFileSizeBytes,
      );
    }

    // Check file extension if restrictions exist
    if (config.allowedExtensions != null) {
      final extension = path.split('.').last.toLowerCase();
      if (!config.isExtensionAllowed(extension)) {
        throw StorageError.invalidFileExtension(
          extension,
          config.allowedExtensions!,
        );
      }
    }
  }

  @override
  Future<UploadResult> uploadFile({
    String? bucket,
    required String path,
    required Uint8List data,
    UploadOptions? options,
  }) async {
    final startTime = DateTime.now();
    try {
      final bucketName = _getBucket(bucket);
      _validateFile(path, data);

      final uploadOptions = options ?? config.defaultUploadOptions;

      if (config.enableLogging) {
        print('Uploading file: $path to bucket: $bucketName (${data.length} bytes)');
      }

      final result = await client.storage.from(bucketName).uploadBinary(
            path,
            data,
            fileOptions: supabase.FileOptions(
              cacheControl: uploadOptions.cacheControl,
              contentType: uploadOptions.contentType,
              upsert: uploadOptions.upsert,
            ),
          );

      final fileInfo = FileInfo(
        name: path.split('/').last,
        path: path,
        bucket: bucketName,
        size: data.length,
        mimeType: uploadOptions.contentType,
      );

      final duration = DateTime.now().difference(startTime);

      // Try to get public URL if available
      String? publicUrl;
      try {
        publicUrl = client.storage.from(bucketName).getPublicUrl(path);
      } catch (_) {
        // Bucket might be private, ignore
      }

      if (config.enableLogging) {
        print('Upload successful: $path (${duration.inMilliseconds}ms)');
      }

      return UploadResult.successResult(
        fileInfo: fileInfo,
        publicUrl: publicUrl,
        duration: duration,
      );
    } on supabase.StorageException catch (e) {
      return UploadResult.failure(_mapStorageError(e, bucket, path));
    } catch (e, stackTrace) {
      if (e is StorageError) rethrow;
      return UploadResult.failure(
        StorageError.fromException(e, stackTrace, bucket, path),
      );
    }
  }

  @override
  Future<UploadResult> uploadFileFromPath({
    String? bucket,
    required String path,
    required String filePath,
    UploadOptions? options,
  }) async {
    try {
      final file = File(filePath);
      if (!await file.exists()) {
        throw StorageError.fileNotFound(filePath);
      }

      final data = await file.readAsBytes();
      return uploadFile(
        bucket: bucket,
        path: path,
        data: data,
        options: options,
      );
    } catch (e, stackTrace) {
      if (e is StorageError) rethrow;
      return UploadResult.failure(
        StorageError.fromException(e, stackTrace, bucket, path),
      );
    }
  }

  @override
  Future<DownloadResult> downloadFile({
    String? bucket,
    required String path,
  }) async {
    final startTime = DateTime.now();
    try {
      final bucketName = _getBucket(bucket);

      if (config.enableLogging) {
        print('Downloading file: $path from bucket: $bucketName');
      }

      final data = await client.storage.from(bucketName).download(path);

      final fileInfo = FileInfo(
        name: path.split('/').last,
        path: path,
        bucket: bucketName,
        size: data.length,
      );

      final duration = DateTime.now().difference(startTime);

      if (config.enableLogging) {
        print('Download successful: $path (${data.length} bytes, ${duration.inMilliseconds}ms)');
      }

      return DownloadResult.successResult(
        data: data,
        fileInfo: fileInfo,
        duration: duration,
      );
    } on supabase.StorageException catch (e) {
      return DownloadResult.failure(_mapStorageError(e, bucket, path));
    } catch (e, stackTrace) {
      if (e is StorageError) rethrow;
      return DownloadResult.failure(
        StorageError.fromException(e, stackTrace, bucket, path),
      );
    }
  }

  @override
  Future<DownloadResult> downloadFileToPath({
    String? bucket,
    required String path,
    required String savePath,
  }) async {
    try {
      final downloadResult = await downloadFile(bucket: bucket, path: path);

      if (!downloadResult.success || downloadResult.data == null) {
        return downloadResult;
      }

      final file = File(savePath);
      await file.writeAsBytes(downloadResult.data!);

      if (config.enableLogging) {
        print('File saved to: $savePath');
      }

      return downloadResult;
    } catch (e, stackTrace) {
      if (e is StorageError) rethrow;
      return DownloadResult.failure(
        StorageError.fromException(e, stackTrace, bucket, path),
      );
    }
  }

  @override
  Future<bool> deleteFile({
    String? bucket,
    required String path,
  }) async {
    try {
      final bucketName = _getBucket(bucket);

      if (config.enableLogging) {
        print('Deleting file: $path from bucket: $bucketName');
      }

      await client.storage.from(bucketName).remove([path]);

      if (config.enableLogging) {
        print('Delete successful: $path');
      }

      return true;
    } on supabase.StorageException catch (e) {
      throw _mapStorageError(e, bucket, path);
    } catch (e, stackTrace) {
      if (e is StorageError) rethrow;
      throw StorageError.fromException(e, stackTrace, bucket, path);
    }
  }

  @override
  Future<List<String>> deleteFiles({
    String? bucket,
    required List<String> paths,
  }) async {
    try {
      final bucketName = _getBucket(bucket);

      if (config.enableLogging) {
        print('Deleting ${paths.length} files from bucket: $bucketName');
      }

      await client.storage.from(bucketName).remove(paths);

      if (config.enableLogging) {
        print('Delete successful: ${paths.length} files');
      }

      return paths;
    } on supabase.StorageException catch (e) {
      throw _mapStorageError(e, bucket, null);
    } catch (e, stackTrace) {
      if (e is StorageError) rethrow;
      throw StorageError.fromException(e, stackTrace, bucket, null);
    }
  }

  @override
  Future<List<FileInfo>> listFiles({
    String? bucket,
    String? path,
    int? limit,
    int? offset,
    String? sortBy,
    String? sortOrder,
  }) async {
    try {
      final bucketName = _getBucket(bucket);

      if (config.enableLogging) {
        print('Listing files in bucket: $bucketName, path: ${path ?? "/"}');
      }

      final response = await client.storage.from(bucketName).list(
            path: path,
            searchOptions: supabase.SearchOptions(
              limit: limit,
              offset: offset,
              sortBy: sortBy != null
                  ? supabase.SortBy(
                      column: sortBy,
                      order: sortOrder == 'desc' ? 'desc' : 'asc',
                    )
                  : null,
            ),
          );

      final files = response
          .map((item) => FileInfo.fromFileObject(
                {
                  'name': item.name,
                  'metadata': {
                    'size': item.metadata?['size'],
                    'mimetype': item.metadata?['mimetype'],
                  },
                  'updated_at': item.updatedAt,
                  'created_at': item.createdAt,
                },
                bucketName,
              ))
          .toList();

      if (config.enableLogging) {
        print('Listed ${files.length} files');
      }

      return files;
    } on supabase.StorageException catch (e) {
      throw _mapStorageError(e, bucket, path);
    } catch (e, stackTrace) {
      if (e is StorageError) rethrow;
      throw StorageError.fromException(e, stackTrace, bucket, path);
    }
  }

  @override
  Future<FileInfo> getFileInfo({
    String? bucket,
    required String path,
  }) async {
    try {
      final bucketName = _getBucket(bucket);

      // Supabase doesn't have a direct "get file info" endpoint
      // We need to list files and find the specific one
      final parentPath = path.contains('/')
          ? path.substring(0, path.lastIndexOf('/'))
          : null;
      final fileName = path.split('/').last;

      final files = await listFiles(
        bucket: bucket,
        path: parentPath,
      );

      final fileInfo = files.firstWhere(
        (file) => file.name == fileName || file.path == path,
        orElse: () => throw StorageError.fileNotFound(path, bucketName),
      );

      return fileInfo;
    } catch (e, stackTrace) {
      if (e is StorageError) rethrow;
      throw StorageError.fromException(e, stackTrace, bucket, path);
    }
  }

  @override
  String getPublicUrl({
    String? bucket,
    required String path,
  }) {
    try {
      final bucketName = _getBucket(bucket);
      return client.storage.from(bucketName).getPublicUrl(path);
    } catch (e, stackTrace) {
      if (e is StorageError) rethrow;
      throw StorageError.fromException(e, stackTrace, bucket, path);
    }
  }

  @override
  Future<String> createSignedUrl({
    String? bucket,
    required String path,
    Duration expiresIn = const Duration(hours: 1),
  }) async {
    try {
      final bucketName = _getBucket(bucket);
      final url = await client.storage.from(bucketName).createSignedUrl(
            path,
            expiresIn.inSeconds,
          );
      return url;
    } on supabase.StorageException catch (e) {
      throw _mapStorageError(e, bucket, path);
    } catch (e, stackTrace) {
      if (e is StorageError) rethrow;
      throw StorageError.fromException(e, stackTrace, bucket, path);
    }
  }

  @override
  Future<bool> moveFile({
    String? bucket,
    required String fromPath,
    required String toPath,
    String? destinationBucket,
  }) async {
    try {
      final sourceBucket = _getBucket(bucket);
      final destBucket = destinationBucket ?? sourceBucket;

      if (config.enableLogging) {
        print('Moving file from $sourceBucket:$fromPath to $destBucket:$toPath');
      }

      await client.storage.from(sourceBucket).move(fromPath, toPath);

      if (config.enableLogging) {
        print('Move successful');
      }

      return true;
    } on supabase.StorageException catch (e) {
      throw _mapStorageError(e, bucket, fromPath);
    } catch (e, stackTrace) {
      if (e is StorageError) rethrow;
      throw StorageError.fromException(e, stackTrace, bucket, fromPath);
    }
  }

  @override
  Future<bool> copyFile({
    String? bucket,
    required String fromPath,
    required String toPath,
    String? destinationBucket,
  }) async {
    try {
      final sourceBucket = _getBucket(bucket);
      final destBucket = destinationBucket ?? sourceBucket;

      if (config.enableLogging) {
        print('Copying file from $sourceBucket:$fromPath to $destBucket:$toPath');
      }

      await client.storage.from(sourceBucket).copy(fromPath, toPath);

      if (config.enableLogging) {
        print('Copy successful');
      }

      return true;
    } on supabase.StorageException catch (e) {
      throw _mapStorageError(e, bucket, fromPath);
    } catch (e, stackTrace) {
      if (e is StorageError) rethrow;
      throw StorageError.fromException(e, stackTrace, bucket, fromPath);
    }
  }

  @override
  Future<bool> fileExists({
    String? bucket,
    required String path,
  }) async {
    try {
      await getFileInfo(bucket: bucket, path: path);
      return true;
    } on StorageError catch (e) {
      if (e.code == StorageErrorCode.fileNotFound) {
        return false;
      }
      rethrow;
    }
  }

  @override
  Future<bool> createBucket({
    required String bucket,
    bool public = false,
  }) async {
    try {
      if (config.enableLogging) {
        print('Creating bucket: $bucket (public: $public)');
      }

      await client.storage.createBucket(
        bucket,
        supabase.BucketOptions(public: public),
      );

      if (config.enableLogging) {
        print('Bucket created successfully');
      }

      return true;
    } on supabase.StorageException catch (e) {
      throw _mapStorageError(e, bucket, null);
    } catch (e, stackTrace) {
      if (e is StorageError) rethrow;
      throw StorageError.fromException(e, stackTrace, bucket, null);
    }
  }

  @override
  Future<bool> deleteBucket({
    required String bucket,
  }) async {
    try {
      if (config.enableLogging) {
        print('Deleting bucket: $bucket');
      }

      await client.storage.deleteBucket(bucket);

      if (config.enableLogging) {
        print('Bucket deleted successfully');
      }

      return true;
    } on supabase.StorageException catch (e) {
      throw _mapStorageError(e, bucket, null);
    } catch (e, stackTrace) {
      if (e is StorageError) rethrow;
      throw StorageError.fromException(e, stackTrace, bucket, null);
    }
  }

  @override
  Future<List<String>> listBuckets() async {
    try {
      if (config.enableLogging) {
        print('Listing all buckets');
      }

      final buckets = await client.storage.listBuckets();
      final bucketNames = buckets.map((b) => b.name).toList();

      if (config.enableLogging) {
        print('Found ${bucketNames.length} buckets');
      }

      return bucketNames;
    } on supabase.StorageException catch (e) {
      throw _mapStorageError(e, null, null);
    } catch (e, stackTrace) {
      if (e is StorageError) rethrow;
      throw StorageError.fromException(e, stackTrace, null, null);
    }
  }

  @override
  Future<int> emptyBucket({
    String? bucket,
  }) async {
    try {
      final bucketName = _getBucket(bucket);

      if (config.enableLogging) {
        print('Emptying bucket: $bucketName');
      }

      await client.storage.emptyBucket(bucketName);

      if (config.enableLogging) {
        print('Bucket emptied successfully');
      }

      // Supabase doesn't return count, so we return -1 to indicate unknown
      return -1;
    } on supabase.StorageException catch (e) {
      throw _mapStorageError(e, bucket, null);
    } catch (e, stackTrace) {
      if (e is StorageError) rethrow;
      throw StorageError.fromException(e, stackTrace, bucket, null);
    }
  }

  StorageError _mapStorageError(
    supabase.StorageException e, [
    String? bucket,
    String? path,
  ]) {
    final message = e.message.toLowerCase();

    if (message.contains('not found') || message.contains('404')) {
      if (message.contains('bucket')) {
        return StorageError.bucketNotFound(bucket ?? 'unknown');
      }
      return StorageError.fileNotFound(path ?? 'unknown', bucket);
    }

    if (message.contains('permission') ||
        message.contains('unauthorized') ||
        message.contains('403')) {
      return StorageError.permissionDenied(e.message);
    }

    if (message.contains('already exists')) {
      return StorageError.fileAlreadyExists(path ?? 'unknown', bucket);
    }

    if (message.contains('quota') || message.contains('limit')) {
      return StorageError.quotaExceeded();
    }

    if (message.contains('invalid') && message.contains('bucket')) {
      return StorageError.invalidBucketName(bucket ?? 'unknown');
    }

    if (message.contains('network') || message.contains('connection')) {
      return StorageError.networkError(e.message);
    }

    return StorageError(
      code: StorageErrorCode.unknownError,
      message: e.message,
      bucket: bucket,
      path: path,
      originalError: e,
    );
  }
}
