/// Firebase Storage module for Flutter
///
/// Provides a comprehensive, reusable, and testable implementation for Firebase Storage
/// operations including upload, download, list, and delete functionality.
///
/// **Features:**
/// - Upload files from bytes or local file paths
/// - Download files to memory or local paths
/// - List files in directories
/// - Delete single or multiple files
/// - Get download URLs
/// - Progress tracking for uploads and downloads
/// - Comprehensive error handling
/// - Configurable file size limits and extension restrictions
/// - Integration with Firebase Auth
/// - Dual DI support (Riverpod + GetIt)
///
/// **Quick Start (Riverpod):**
/// ```dart
/// // In main.dart
/// void main() async {
///   WidgetsFlutterBinding.ensureInitialized();
///   await Firebase.initializeApp();
///
///   runApp(
///     ProviderScope(
///       child: MyApp(),
///     ),
///   );
/// }
///
/// // In widget
/// class MyWidget extends ConsumerWidget {
///   @override
///   Widget build(BuildContext context, WidgetRef ref) {
///     final storage = ref.read(storageServiceProvider);
///
///     // Upload file
///     final result = await storage.uploadBytes(
///       path: 'images/avatar.png',
///       data: imageBytes,
///     );
///
///     if (result.success) {
///       print('Uploaded: ${result.downloadUrl}');
///     }
///   }
/// }
/// ```
///
/// **Quick Start (GetIt):**
/// ```dart
/// void main() async {
///   WidgetsFlutterBinding.ensureInitialized();
///   await Firebase.initializeApp();
///
///   // Register storage module
///   await registerStorageModule();
///
///   runApp(MyApp());
/// }
///
/// // In your code
/// final storage = GetIt.I<StorageService>();
/// final result = await storage.uploadBytes(...);
/// ```
library firebase_storage;

// Errors
export 'errors/storage_error.dart';

// Models
export 'models/file_info.dart';
export 'models/upload_result.dart';
export 'models/download_result.dart';

// Utils / Config
export 'utils/storage_config.dart';

// Repository (Data Layer)
export 'repository/storage_repository.dart';

// Services (Business Logic Layer)
export 'services/storage_service.dart';

// Providers (Dependency Injection)
export 'providers/storage_providers.dart';
export 'providers/getit_registration.dart';
