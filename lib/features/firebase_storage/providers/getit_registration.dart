import 'package:get_it/get_it.dart';
import 'package:firebase_storage/firebase_storage.dart' as fb_storage;
import '../services/storage_service.dart';
import '../repository/storage_repository.dart';
import '../utils/storage_config.dart';

/// GetIt service locator registration for Firebase Storage Module
///
/// **Usage:**
/// ```dart
/// void main() async {
///   WidgetsFlutterBinding.ensureInitialized();
///   await Firebase.initializeApp();
///
///   // Register storage module
///   await registerStorageModule();
///
///   // Or with custom config
///   await registerStorageModule(
///     config: StorageConfig.imagesOnly(),
///   );
///
///   runApp(MyApp());
/// }
///
/// // In your code
/// final storageService = GetIt.I<StorageService>();
/// final result = await storageService.uploadBytes(...);
/// ```

/// Register all storage module dependencies with GetIt
Future<void> registerStorageModule({
  GetIt? getIt,
  StorageConfig? config,
}) async {
  final locator = getIt ?? GetIt.instance;

  // Register Storage Config
  locator.registerLazySingleton<StorageConfig>(
    () => config ?? StorageConfig.defaultConfig(),
  );

  // Register Firebase Storage instance as singleton
  locator.registerLazySingleton<fb_storage.FirebaseStorage>(
    () => fb_storage.FirebaseStorage.instance,
  );

  // Register Storage Repository
  locator.registerLazySingleton<StorageRepository>(
    () => StorageRepository(
      firebaseStorage: locator<fb_storage.FirebaseStorage>(),
      config: locator<StorageConfig>(),
    ),
  );

  // Register Storage Service (Main API)
  locator.registerLazySingleton<StorageService>(
    () => StorageService(
      repository: locator<StorageRepository>(),
    ),
  );
}

/// Unregister storage module dependencies
///
/// Useful for testing or resetting the service locator
void unregisterStorageModule({GetIt? getIt}) {
  final locator = getIt ?? GetIt.instance;

  if (locator.isRegistered<StorageService>()) {
    locator.unregister<StorageService>();
  }

  if (locator.isRegistered<StorageRepository>()) {
    locator.unregister<StorageRepository>();
  }

  if (locator.isRegistered<fb_storage.FirebaseStorage>()) {
    locator.unregister<fb_storage.FirebaseStorage>();
  }

  if (locator.isRegistered<StorageConfig>()) {
    locator.unregister<StorageConfig>();
  }
}
