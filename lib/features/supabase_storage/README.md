# Supabase Storage Module

A production-ready, reusable Flutter storage module with Supabase backend supporting file upload, download, listing, and deletion with comprehensive security features.

## 📂 Module Structure

```
supabase_storage/
├── src/
│   ├── models/             # Data models
│   │   ├── file_info.dart
│   │   ├── upload_result.dart
│   │   ├── download_result.dart
│   │   └── storage_error.dart
│   ├── config/             # Configuration
│   │   └── supabase_storage_config.dart
│   ├── services/           # Storage services
│   │   ├── storage_service.dart
│   │   └── supabase_storage_service.dart
│   └── facade/             # Repository facade
│       └── storage_repository.dart
└── supabase_storage.dart   # Main entry point
```

## 🚀 Features

### Storage Operations
- ✅ **Upload Files** - From bytes or local file paths
- ✅ **Download Files** - To memory or local file system
- ✅ **List Files** - With filtering, sorting, and pagination
- ✅ **Delete Files** - Single or batch deletion
- ✅ **Move/Copy Files** - Between paths and buckets
- ✅ **File Metadata** - Get file info without downloading

### URL Management
- ✅ **Public URLs** - For publicly accessible files
- ✅ **Signed URLs** - Temporary access to private files
- ✅ **Configurable Expiry** - Control URL expiration

### Bucket Management
- ✅ **Create Buckets** - Public or private
- ✅ **Delete Buckets** - Remove entire buckets
- ✅ **List Buckets** - View all available buckets
- ✅ **Empty Buckets** - Clear all files from a bucket

### Security & Validation
- ✅ **File Size Limits** - Configurable maximum file size
- ✅ **Extension Restrictions** - Whitelist allowed file types
- ✅ **Authentication** - Integrates with Supabase Auth
- ✅ **Permission Handling** - Proper error handling for permissions

### Developer Experience
- ✅ **Type-Safe** - Full Dart null safety
- ✅ **Interface-Based** - Pluggable architecture
- ✅ **Comprehensive Errors** - Detailed error codes and messages
- ✅ **Well-Documented** - Inline documentation
- ✅ **Testable** - Interface-based design for easy mocking
- ✅ **Logging Support** - Optional debug logging

## 📦 Installation

The module is already part of this project. Dependencies are already included in the main `pubspec.yaml`.

Required dependencies:
- `supabase_flutter: ^2.0.0` (already included)
- `path_provider: ^2.1.1` (already included)

## 🔧 Quick Start

### 1. Set Up Supabase Project

1. Create a project at [supabase.com](https://supabase.com)
2. Create a storage bucket:
   - Go to Storage
   - Click "New bucket"
   - Name your bucket (e.g., "uploads")
   - Set public/private access
3. Configure bucket policies (optional):
   - Set up Row Level Security (RLS) policies
   - Configure authentication requirements

### 2. Initialize in Your App

#### Option A: From Existing Auth Config

```dart
import 'package:supabase_auth/supabase_auth.dart';
import 'package:supabase_storage/supabase_storage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize auth first
  final authConfig = SupabaseAuthConfig(
    supabaseUrl: 'YOUR_SUPABASE_URL',
    supabaseAnonKey: 'YOUR_SUPABASE_ANON_KEY',
  );
  await AuthRepository.initialize(authConfig);

  // Initialize storage from auth config
  final storageConfig = SupabaseStorageConfig.fromAuthConfig(
    authConfig,
    defaultBucket: 'uploads',
    maxFileSizeBytes: 10 * 1024 * 1024, // 10MB
    allowedExtensions: ['jpg', 'jpeg', 'png', 'pdf'],
  );
  await StorageRepository.initialize(storageConfig);

  runApp(MyApp());
}
```

#### Option B: Standalone Configuration

```dart
import 'package:supabase_storage/supabase_storage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize storage directly
  final storageConfig = SupabaseStorageConfig(
    supabaseUrl: 'YOUR_SUPABASE_URL',
    supabaseAnonKey: 'YOUR_SUPABASE_ANON_KEY',
    defaultBucket: 'uploads',
    maxFileSizeBytes: 10 * 1024 * 1024, // 10MB
    allowedExtensions: ['jpg', 'jpeg', 'png', 'pdf'],
    enableLogging: true, // Enable debug logging
  );
  await StorageRepository.initialize(storageConfig);

  runApp(MyApp());
}
```

#### Option C: From Environment Variables

```dart
final storageConfig = SupabaseStorageConfig.fromEnvironment(
  env: Platform.environment,
  defaultBucket: 'uploads',
  maxFileSizeBytes: 10 * 1024 * 1024,
);
await StorageRepository.initialize(storageConfig);
```

Required environment variables:
- `SUPABASE_URL` - Your Supabase project URL
- `SUPABASE_ANON_KEY` - Your Supabase anonymous key
- `SUPABASE_DEFAULT_BUCKET` - (Optional) Default bucket name
- `SUPABASE_MAX_FILE_SIZE` - (Optional) Max file size in bytes

### 3. Upload Files

#### Upload from Bytes

```dart
import 'dart:typed_data';

try {
  final result = await StorageRepository.instance.uploadFile(
    path: 'avatars/user-123.png',
    data: imageBytes, // Uint8List
    options: UploadOptions(
      contentType: 'image/png',
      cacheControl: '3600',
      upsert: true, // Overwrite if exists
    ),
  );

  if (result.success) {
    print('Upload successful!');
    print('URL: ${result.url}');
    print('File: ${result.fileInfo?.name}');
  } else {
    print('Upload failed: ${result.error?.message}');
  }
} on StorageError catch (e) {
  print('Error: ${e.message}');
}
```

#### Upload from File Path

```dart
try {
  final result = await StorageRepository.instance.uploadFileFromPath(
    path: 'documents/report.pdf',
    filePath: '/path/to/local/file.pdf',
  );

  if (result.success) {
    print('Uploaded: ${result.fileInfo?.formattedSize}');
  }
} on StorageError catch (e) {
  print('Error: ${e.message}');
}
```

### 4. Download Files

#### Download to Memory

```dart
try {
  final result = await StorageRepository.instance.downloadFile(
    path: 'avatars/user-123.png',
  );

  if (result.success) {
    print('Downloaded ${result.formattedSize}');
    // Use result.data (Uint8List)
    final image = Image.memory(result.data!);
  } else {
    print('Download failed: ${result.error?.message}');
  }
} on StorageError catch (e) {
  print('Error: ${e.message}');
}
```

#### Download to File Path

```dart
try {
  final result = await StorageRepository.instance.downloadFileToPath(
    path: 'documents/report.pdf',
    savePath: '/path/to/save/report.pdf',
  );

  if (result.success) {
    print('File saved successfully');
  }
} on StorageError catch (e) {
  print('Error: ${e.message}');
}
```

### 5. List Files

```dart
try {
  final files = await StorageRepository.instance.listFiles(
    path: 'avatars', // Optional folder path
    limit: 50,
    offset: 0,
    sortBy: 'created_at',
    sortOrder: 'desc',
  );

  for (var file in files) {
    print('${file.name} - ${file.formattedSize}');
    print('  Type: ${file.mimeType}');
    print('  Modified: ${file.lastModified}');
    print('  Is image: ${file.isImage}');
  }
} on StorageError catch (e) {
  print('Error: ${e.message}');
}
```

### 6. Delete Files

#### Delete Single File

```dart
try {
  final success = await StorageRepository.instance.deleteFile(
    path: 'avatars/old-avatar.png',
  );

  if (success) {
    print('File deleted');
  }
} on StorageError catch (e) {
  print('Error: ${e.message}');
}
```

#### Delete Multiple Files

```dart
try {
  final deletedPaths = await StorageRepository.instance.deleteFiles(
    paths: [
      'temp/file1.txt',
      'temp/file2.txt',
      'temp/file3.txt',
    ],
  );

  print('Deleted ${deletedPaths.length} files');
} on StorageError catch (e) {
  print('Error: ${e.message}');
}
```

### 7. Get URLs

#### Public URL

```dart
try {
  final url = StorageRepository.instance.getPublicUrl(
    path: 'avatars/user-123.png',
  );

  print('Public URL: $url');
  // Use in Image.network(url)
} on StorageError catch (e) {
  print('Error: ${e.message}');
}
```

#### Signed URL (for private files)

```dart
try {
  final url = await StorageRepository.instance.createSignedUrl(
    path: 'private/document.pdf',
    expiresIn: Duration(hours: 1),
  );

  print('Signed URL (expires in 1 hour): $url');
} on StorageError catch (e) {
  print('Error: ${e.message}');
}
```

### 8. File Operations

#### Move File

```dart
try {
  final success = await StorageRepository.instance.moveFile(
    fromPath: 'temp/file.txt',
    toPath: 'archive/file.txt',
  );

  if (success) {
    print('File moved');
  }
} on StorageError catch (e) {
  print('Error: ${e.message}');
}
```

#### Copy File

```dart
try {
  final success = await StorageRepository.instance.copyFile(
    fromPath: 'original/file.txt',
    toPath: 'backup/file.txt',
  );

  if (success) {
    print('File copied');
  }
} on StorageError catch (e) {
  print('Error: ${e.message}');
}
```

#### Check if File Exists

```dart
final exists = await StorageRepository.instance.fileExists(
  path: 'avatars/user-123.png',
);

if (exists) {
  print('File exists');
} else {
  print('File not found');
}
```

### 9. Bucket Management

#### Create Bucket

```dart
try {
  final success = await StorageRepository.instance.createBucket(
    bucket: 'new-bucket',
    public: false, // Private bucket
  );

  if (success) {
    print('Bucket created');
  }
} on StorageError catch (e) {
  print('Error: ${e.message}');
}
```

#### List All Buckets

```dart
try {
  final buckets = await StorageRepository.instance.listBuckets();

  for (var bucket in buckets) {
    print('Bucket: $bucket');
  }
} on StorageError catch (e) {
  print('Error: ${e.message}');
}
```

#### Empty Bucket

```dart
try {
  await StorageRepository.instance.emptyBucket(
    bucket: 'temp-uploads',
  );

  print('Bucket emptied');
} on StorageError catch (e) {
  print('Error: ${e.message}');
}
```

## 🔐 Advanced Configuration

### File Size and Extension Restrictions

```dart
final config = SupabaseStorageConfig(
  supabaseUrl: 'YOUR_URL',
  supabaseAnonKey: 'YOUR_KEY',
  defaultBucket: 'uploads',

  // Limit file size to 5MB
  maxFileSizeBytes: 5 * 1024 * 1024,

  // Only allow specific file types
  allowedExtensions: ['jpg', 'jpeg', 'png', 'gif', 'pdf', 'doc', 'docx'],

  // Enable debug logging
  enableLogging: true,

  // Default upload options
  defaultUploadOptions: UploadOptions(
    cacheControl: '3600',
    upsert: false, // Don't overwrite by default
  ),
);
```

### Using Different Buckets

```dart
// Upload to specific bucket
await StorageRepository.instance.uploadFile(
  bucket: 'profile-images', // Override default bucket
  path: 'user-123.png',
  data: imageBytes,
);

// Download from specific bucket
await StorageRepository.instance.downloadFile(
  bucket: 'documents',
  path: 'report.pdf',
);
```

## 🎯 Error Handling

### Error Codes

The module provides comprehensive error codes:

```dart
enum StorageErrorCode {
  fileNotFound,
  networkError,
  fileSizeLimitExceeded,
  invalidFileExtension,
  bucketNotFound,
  permissionDenied,
  invalidPath,
  uploadFailed,
  downloadFailed,
  deleteFailed,
  listFailed,
  fileAlreadyExists,
  invalidBucketName,
  quotaExceeded,
  authenticationRequired,
  configurationError,
  rateLimitExceeded,
  invalidFileData,
  unknownError,
}
```

### Error Handling Example

```dart
try {
  final result = await StorageRepository.instance.uploadFile(
    path: 'large-file.bin',
    data: hugeData,
  );

  if (!result.success) {
    switch (result.error?.code) {
      case StorageErrorCode.fileSizeLimitExceeded:
        print('File is too large!');
        break;
      case StorageErrorCode.invalidFileExtension:
        print('File type not allowed!');
        break;
      case StorageErrorCode.permissionDenied:
        print('You don\'t have permission!');
        break;
      default:
        print('Upload failed: ${result.error?.message}');
    }
  }
} on StorageError catch (e) {
  print('Error (${e.code}): ${e.message}');

  // Access additional error details
  print('Bucket: ${e.bucket}');
  print('Path: ${e.path}');
}
```

## 📊 Models

### FileInfo

```dart
class FileInfo {
  final String name;           // File name
  final String path;           // Full path in bucket
  final String bucket;         // Bucket name
  final int? size;             // Size in bytes
  final String? mimeType;      // MIME type
  final DateTime? lastModified; // Last modified date
  final String? publicUrl;     // Public URL if available

  String get formattedSize;    // Human-readable size (e.g., "1.5 MB")
  String? get extension;       // File extension
  bool get isImage;            // Is image file
  bool get isVideo;            // Is video file
  bool get isDocument;         // Is document file
}
```

### UploadResult

```dart
class UploadResult {
  final bool success;          // Upload successful
  final FileInfo? fileInfo;    // File information
  final String? publicUrl;     // Public URL
  final String? signedUrl;     // Signed URL
  final StorageError? error;   // Error if failed
  final Duration? duration;    // Upload duration

  String? get url;             // Best available URL
}
```

### DownloadResult

```dart
class DownloadResult {
  final bool success;          // Download successful
  final Uint8List? data;       // Downloaded data
  final FileInfo? fileInfo;    // File information
  final StorageError? error;   // Error if failed
  final Duration? duration;    // Download duration

  int? get sizeInBytes;        // Data size
  String get formattedSize;    // Human-readable size
}
```

## 🧪 Testing

The module is designed to be easily testable with interface-based architecture:

```dart
// Create a mock storage service
class MockStorageService implements StorageService {
  @override
  Future<UploadResult> uploadFile({
    String? bucket,
    required String path,
    required Uint8List data,
    UploadOptions? options,
  }) async {
    // Mock implementation
    return UploadResult.successResult(
      fileInfo: FileInfo(
        name: path.split('/').last,
        path: path,
        bucket: bucket ?? 'test',
      ),
    );
  }

  // ... implement other methods
}

// Use in tests
final mockService = MockStorageService();
```

## 🔗 Integration with Auth

The storage module automatically uses the same Supabase client as the auth module when initialized from `SupabaseAuthConfig`:

```dart
// Auth and storage share the same Supabase client
final authConfig = SupabaseAuthConfig(/* ... */);
await AuthRepository.initialize(authConfig);

final storageConfig = SupabaseStorageConfig.fromAuthConfig(authConfig);
await StorageRepository.initialize(storageConfig);

// Both modules use authenticated requests
```

## 📝 Best Practices

1. **Always handle errors**: Use try-catch or check result.success
2. **Validate files client-side**: Check size and extension before upload
3. **Use signed URLs for private files**: Don't expose sensitive files publicly
4. **Clean up temporary files**: Delete files when no longer needed
5. **Use appropriate buckets**: Separate public and private content
6. **Set reasonable size limits**: Prevent abuse and manage costs
7. **Enable logging during development**: Set `enableLogging: true`
8. **Use batch operations**: Delete multiple files at once when possible

## 🐛 Troubleshooting

### "Bucket not found" error
- Verify the bucket exists in your Supabase project
- Check the bucket name is spelled correctly
- Ensure you have access to the bucket

### "Permission denied" error
- Check your bucket's RLS policies
- Verify user is authenticated (if required)
- Ensure Supabase anon key has correct permissions

### "File size limit exceeded" error
- Reduce file size or increase `maxFileSizeBytes` in config
- Compress images/videos before upload
- Check Supabase project limits

### Upload/Download fails silently
- Enable logging: `enableLogging: true` in config
- Check network connection
- Verify Supabase URL and anon key are correct

## 📄 License

This module is part of the reusable widgets project.

## 🤝 Contributing

Contributions are welcome! Please follow the existing code style and patterns.

---

For more information, visit [Supabase Storage Documentation](https://supabase.com/docs/guides/storage).
