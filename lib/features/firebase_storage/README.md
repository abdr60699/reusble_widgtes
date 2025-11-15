# Firebase Storage Module

A production-ready, reusable Flutter storage module with Firebase Storage backend supporting file upload, download, listing, and deletion with comprehensive security features.

## 📂 Module Structure

```
firebase_storage/
├── errors/
│   └── storage_error.dart         # Error codes & handling
├── models/
│   ├── file_info.dart             # File metadata model
│   ├── upload_result.dart         # Upload operation result
│   └── download_result.dart       # Download operation result
├── utils/
│   └── storage_config.dart        # Configuration & upload options
├── repository/
│   └── storage_repository.dart    # Firebase SDK wrapper (data layer)
├── services/
│   └── storage_service.dart       # Service facade (business logic)
├── providers/
│   ├── storage_providers.dart     # Riverpod providers
│   └── getit_registration.dart    # GetIt registration
└── firebase_storage.dart          # Main entry point
```

## 🚀 Features

### Storage Operations
- ✅ **Upload Files** - From bytes or local file paths
- ✅ **Download Files** - To memory or local file system
- ✅ **List Files** - In directories with metadata
- ✅ **Delete Files** - Single or batch deletion
- ✅ **File Metadata** - Get file info without downloading
- ✅ **Progress Tracking** - For uploads and downloads

### Security & Validation
- ✅ **File Size Limits** - Configurable maximum file size
- ✅ **Extension Restrictions** - Whitelist allowed file types
- ✅ **Automatic Validation** - Before upload
- ✅ **Firebase Auth Integration** - Secure with auth rules
- ✅ **Error Handling** - Comprehensive error codes

### Developer Experience
- ✅ **Type-Safe** - Full Dart null safety
- ✅ **Layered Architecture** - Repository + Service pattern
- ✅ **Dual DI Support** - Riverpod OR GetIt
- ✅ **Well-Documented** - Inline documentation
- ✅ **Testable** - Interface-based design
- ✅ **Logging Support** - Optional debug logging

## 📦 Installation

The `firebase_storage` package has been added to `pubspec.yaml`:

```yaml
dependencies:
  firebase_storage: ^12.3.4
  firebase_core: ^4.2.1  # Already included
```

Run:
```bash
flutter pub get
```

## 🔧 Quick Start

### 1. Set Up Firebase Project

1. Create a Firebase project at [console.firebase.google.com](https://console.firebase.google.com)
2. Add your Flutter app to the project
3. Download configuration files:
   - `google-services.json` for Android
   - `GoogleService-Info.plist` for iOS
4. Enable Firebase Storage:
   - Go to Storage in Firebase Console
   - Click "Get Started"
   - Set up security rules

### 2. Configure Security Rules

In Firebase Console → Storage → Rules, set up your security rules:

```javascript
rules_version = '2';
service firebase.storage {
  match /b/{bucket}/o {
    // Allow authenticated users to upload/download their own files
    match /users/{userId}/{allPaths=**} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }

    // Public read, authenticated write
    match /public/{allPaths=**} {
      allow read: if true;
      allow write: if request.auth != null;
    }
  }
}
```

### 3. Initialize Firebase (Already Done in Auth Module)

If you're using Firebase Auth, Firebase is already initialized. Otherwise:

```dart
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MyApp());
}
```

### 4. Choose Your DI Pattern

#### Option A: Riverpod (Recommended)

```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reuablewidgets/features/firebase_storage/firebase_storage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(
    ProviderScope(
      child: MyApp(),
    ),
  );
}
```

#### Option B: GetIt

```dart
import 'package:get_it/get_it.dart';
import 'package:reuablewidgets/features/firebase_storage/firebase_storage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // Register storage module
  await registerStorageModule();

  // Or with custom config
  await registerStorageModule(
    config: StorageConfig.imagesOnly(),
  );

  runApp(MyApp());
}
```

## 💡 Usage Examples

### Upload Files

#### Upload from Bytes (Riverpod)

```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MyWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final storage = ref.read(storageServiceProvider);

    return ElevatedButton(
      onPressed: () async {
        final result = await storage.uploadBytes(
          path: 'images/avatar.png',
          data: imageBytes,
          options: UploadOptions(
            contentType: 'image/png',
            cacheControl: 'public, max-age=3600',
          ),
          onProgress: (transferred, total) {
            print('Progress: ${(transferred / total * 100).toStringAsFixed(1)}%');
          },
        );

        if (result.success) {
          print('Upload successful!');
          print('Download URL: ${result.downloadUrl}');
        } else {
          print('Upload failed: ${result.error?.message}');
        }
      },
      child: Text('Upload Image'),
    );
  }
}
```

#### Upload from File Path (GetIt)

```dart
import 'package:get_it/get_it.dart';

final storage = GetIt.I<StorageService>();

final result = await storage.uploadFromPath(
  path: 'documents/report.pdf',
  filePath: '/path/to/local/report.pdf',
  options: UploadOptions(
    contentType: 'application/pdf',
  ),
);

if (result.success) {
  print('File uploaded: ${result.fileInfo?.name}');
  print('Size: ${result.fileInfo?.formattedSize}');
}
```

### Download Files

#### Download to Memory

```dart
final storage = ref.read(storageServiceProvider);

final result = await storage.downloadBytes(
  path: 'images/avatar.png',
);

if (result.success) {
  // Use result.data (Uint8List)
  final image = Image.memory(result.data!);
  print('Downloaded ${result.formattedSize}');
}
```

#### Download to File

```dart
final result = await storage.downloadToPath(
  path: 'documents/report.pdf',
  savePath: '/path/to/save/report.pdf',
);

if (result.success) {
  print('File saved successfully');
}
```

### List Files

```dart
final storage = ref.read(storageServiceProvider);

final files = await storage.listFiles(path: 'images');

for (var file in files) {
  print('${file.name} - ${file.formattedSize}');
  print('  Type: ${file.contentType}');
  print('  Created: ${file.createdAt}');
  print('  URL: ${file.downloadUrl}');
  print('  Is image: ${file.isImage}');
}
```

### Delete Files

#### Delete Single File

```dart
await storage.deleteFile(path: 'images/old-avatar.png');
print('File deleted');
```

#### Delete Multiple Files

```dart
final deletedPaths = await storage.deleteFiles(
  paths: [
    'temp/file1.txt',
    'temp/file2.txt',
    'temp/file3.txt',
  ],
);

print('Deleted ${deletedPaths.length} files');
```

### Get File Info

```dart
final fileInfo = await storage.getFileInfo(path: 'images/avatar.png');

print('Name: ${fileInfo.name}');
print('Size: ${fileInfo.formattedSize}');
print('Type: ${fileInfo.contentType}');
print('Created: ${fileInfo.createdAt}');
print('MD5: ${fileInfo.md5Hash}');
```

### Check if File Exists

```dart
final exists = await storage.fileExists(path: 'images/avatar.png');

if (exists) {
  print('File exists');
} else {
  print('File not found');
}
```

### Get Download URL

```dart
final url = await storage.getDownloadUrl(path: 'images/avatar.png');
print('Download URL: $url');

// Use in Image.network
Image.network(url);
```

## ⚙️ Configuration

### Default Configuration

```dart
final config = StorageConfig.defaultConfig();
// - Max file size: 100MB
// - All extensions allowed
// - Auto-generate download URLs
```

### Images Only

```dart
final config = StorageConfig.imagesOnly();
// - Max file size: 10MB
// - Extensions: jpg, jpeg, png, gif, webp, bmp, svg
// - Public upload options
```

### Documents Only

```dart
final config = StorageConfig.documentsOnly();
// - Max file size: 50MB
// - Extensions: pdf, doc, docx, xls, xlsx, ppt, pptx, txt, csv
// - Private upload options
```

### Media Files

```dart
final config = StorageConfig.mediaOnly();
// - Max file size: 500MB
// - Extensions: images, videos, audio files
// - Public upload options
```

### Custom Configuration

```dart
final config = StorageConfig(
  defaultBucket: 'my-custom-bucket',
  maxFileSizeBytes: 20 * 1024 * 1024, // 20MB
  allowedExtensions: ['jpg', 'png', 'pdf'],
  enableLogging: true,
  validateExtensions: true,
  validateFileSize: true,
  autoGenerateDownloadUrl: true,
  uploadTimeout: Duration(minutes: 5),
  downloadTimeout: Duration(minutes: 5),
  defaultUploadOptions: UploadOptions(
    cacheControl: 'public, max-age=7200',
  ),
);
```

### Override Config with Riverpod

```dart
ProviderScope(
  overrides: [
    storageConfigProvider.overrideWithValue(
      StorageConfig.imagesOnly(maxFileSizeBytes: 5 * 1024 * 1024),
    ),
  ],
  child: MyApp(),
)
```

### Set Config with GetIt

```dart
await registerStorageModule(
  config: StorageConfig.imagesOnly(),
);
```

## 🔐 Security Best Practices

### 1. Use Firebase Auth Integration

```dart
// Require authentication for uploads
final user = ref.watch(currentUserProvider); // From firebase_auth module

if (user != null) {
  await storage.uploadBytes(
    path: 'users/${user.uid}/avatar.png',
    data: imageBytes,
  );
}
```

### 2. Set Proper Storage Rules

```javascript
// User-specific files
match /users/{userId}/{allPaths=**} {
  allow read, write: if request.auth != null && request.auth.uid == userId;
}

// File size limit (5MB)
match /{allPaths=**} {
  allow write: if request.resource.size < 5 * 1024 * 1024;
}

// Image files only
match /images/{imageId} {
  allow write: if request.resource.contentType.matches('image/.*');
}
```

### 3. Validate Files Client-Side

```dart
try {
  // This will throw if file is invalid
  storage.validateUpload(
    path: 'images/file.jpg',
    fileSize: data.length,
  );
} on StorageError catch (e) {
  if (e.code == StorageErrorCode.fileSizeLimitExceeded) {
    print('File is too large!');
  } else if (e.code == StorageErrorCode.invalidFileExtension) {
    print('Invalid file type!');
  }
}
```

## 🎯 Error Handling

### Error Codes

```dart
enum StorageErrorCode {
  objectNotFound,           // File not found
  bucketNotFound,           // Bucket not found
  quotaExceeded,            // Storage quota exceeded
  unauthenticated,          // User not signed in
  unauthorized,             // Permission denied
  networkError,             // Network connection error
  fileSizeLimitExceeded,    // File too large
  invalidFileExtension,     // File type not allowed
  uploadFailed,             // Upload failed
  downloadFailed,           // Download failed
  deleteFailed,             // Delete failed
  // ... and more
}
```

### Error Handling Example

```dart
try {
  final result = await storage.uploadBytes(
    path: 'large-file.bin',
    data: hugeData,
  );

  if (!result.success) {
    switch (result.error?.code) {
      case StorageErrorCode.fileSizeLimitExceeded:
        showSnackBar('File is too large!');
        break;
      case StorageErrorCode.invalidFileExtension:
        showSnackBar('File type not allowed!');
        break;
      case StorageErrorCode.unauthenticated:
        showSnackBar('Please sign in first!');
        break;
      case StorageErrorCode.unauthorized:
        showSnackBar('You don\'t have permission!');
        break;
      default:
        showSnackBar('Upload failed: ${result.error?.message}');
    }
  }
} on StorageError catch (e) {
  print('Error: ${e.message}');
  print('Code: ${e.code}');
  print('Suggestion: ${e.recoverySuggestion}');
}
```

## 📊 Models

### FileInfo

```dart
class FileInfo {
  final String name;              // File name
  final String path;              // Full path in storage
  final String bucket;            // Bucket name
  final int? size;                // Size in bytes
  final String? contentType;      // MIME type
  final DateTime? createdAt;      // Creation timestamp
  final DateTime? updatedAt;      // Last update timestamp
  final String? md5Hash;          // MD5 checksum
  final String? downloadUrl;      // Download URL

  String get formattedSize;       // Human-readable size
  String? get extension;          // File extension
  bool get isImage;               // Is image file
  bool get isVideo;               // Is video file
  bool get isDocument;            // Is document file
  // ... and more
}
```

### UploadResult

```dart
class UploadResult {
  final bool success;             // Upload successful
  final FileInfo? fileInfo;       // File information
  final String? downloadUrl;      // Download URL
  final StorageError? error;      // Error if failed
  final Duration? duration;       // Upload duration
  final int? bytesTransferred;    // Bytes uploaded
  final int? totalBytes;          // Total bytes

  double? get progress;           // Progress (0.0 to 1.0)
  int? get progressPercentage;    // Progress (0 to 100)
}
```

### DownloadResult

```dart
class DownloadResult {
  final bool success;             // Download successful
  final Uint8List? data;          // Downloaded data
  final FileInfo? fileInfo;       // File information
  final StorageError? error;      // Error if failed
  final Duration? duration;       // Download duration

  int? get sizeInBytes;           // Data size
  String get formattedSize;       // Human-readable size
}
```

## 🧪 Testing

The module is designed to be easily testable:

```dart
// Mock the repository
class MockStorageRepository implements StorageRepository {
  @override
  Future<UploadResult> uploadBytes({...}) async {
    return UploadResult.successResult(
      fileInfo: FileInfo(...),
      downloadUrl: 'https://example.com/file.png',
    );
  }
}

// Use in tests
final mockRepo = MockStorageRepository();
final service = StorageService(repository: mockRepo);
```

## 🔗 Integration with Firebase Auth

```dart
// Initialize both modules
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(
    ProviderScope(
      child: MyApp(),
    ),
  );
}

// Use together
class UploadWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(currentUserProvider);
    final storage = ref.read(storageServiceProvider);

    if (auth == null) {
      return Text('Please sign in');
    }

    return ElevatedButton(
      onPressed: () async {
        // Upload to user-specific path
        await storage.uploadBytes(
          path: 'users/${auth.uid}/avatar.png',
          data: imageBytes,
        );
      },
      child: Text('Upload Avatar'),
    );
  }
}
```

## 📝 Best Practices

1. **Always handle errors**: Check `result.success` or use try-catch
2. **Validate files client-side**: Check size and extension before upload
3. **Use proper file paths**: Organize files in logical directories
4. **Set up security rules**: Protect sensitive files
5. **Use progress callbacks**: Show upload/download progress to users
6. **Clean up old files**: Delete files when no longer needed
7. **Set reasonable size limits**: Prevent abuse and manage costs
8. **Enable logging during development**: Set `enableLogging: true`
9. **Use appropriate content types**: Set correct MIME types
10. **Cache download URLs**: Avoid repeated getDownloadUrl calls

## 🐛 Troubleshooting

### "Permission denied" error
- Check Firebase Storage security rules
- Verify user is authenticated (if required)
- Ensure user has correct permissions

### "Object not found" error
- Verify the file exists at the specified path
- Check the bucket name is correct
- Ensure file wasn't deleted

### "Quota exceeded" error
- Check your Firebase Storage usage
- Delete old files or upgrade plan
- Implement file cleanup logic

### Upload/Download timeout
- Increase timeout in config
- Check network connection
- Reduce file size

### "No default bucket" error
- Specify bucket explicitly in upload/download calls
- Or set `defaultBucket` in StorageConfig

## 📄 License

This module is part of the reusable widgets project.

## 🤝 Contributing

Contributions are welcome! Please follow the existing code style and architecture patterns.

---

For more information, visit [Firebase Storage Documentation](https://firebase.google.com/docs/storage).
