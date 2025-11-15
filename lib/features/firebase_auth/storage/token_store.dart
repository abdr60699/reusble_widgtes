import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Abstract token storage interface
///
/// Implement this interface to provide custom token storage
abstract class TokenStore {
  /// Save user ID token
  Future<void> saveToken(String token);

  /// Get saved token
  Future<String?> getToken();

  /// Delete saved token
  Future<void> deleteToken();

  /// Save refresh token
  Future<void> saveRefreshToken(String token);

  /// Get refresh token
  Future<String?> getRefreshToken();

  /// Delete refresh token
  Future<void> deleteRefreshToken();

  /// Save user session data
  Future<void> saveSession(Map<String, dynamic> session);

  /// Get user session data
  Future<Map<String, dynamic>?> getSession();

  /// Delete session
  Future<void> deleteSession();

  /// Clear all stored data
  Future<void> clearAll();
}

/// Secure token storage implementation using flutter_secure_storage
///
/// Uses platform-specific secure storage (Keychain on iOS, Keystore on Android)
class SecureTokenStore implements TokenStore {
  final FlutterSecureStorage _secureStorage;

  static const _keyToken = 'auth_token';
  static const _keyRefreshToken = 'auth_refresh_token';
  static const _keySession = 'auth_session';

  SecureTokenStore({FlutterSecureStorage? secureStorage})
      : _secureStorage = secureStorage ??
            const FlutterSecureStorage(
              aOptions: AndroidOptions(
                encryptedSharedPreferences: true,
              ),
              iOptions: IOSOptions(
                accessibility: KeychainAccessibility.first_unlock,
              ),
            );

  @override
  Future<void> saveToken(String token) async {
    await _secureStorage.write(key: _keyToken, value: token);
  }

  @override
  Future<String?> getToken() async {
    return await _secureStorage.read(key: _keyToken);
  }

  @override
  Future<void> deleteToken() async {
    await _secureStorage.delete(key: _keyToken);
  }

  @override
  Future<void> saveRefreshToken(String token) async {
    await _secureStorage.write(key: _keyRefreshToken, value: token);
  }

  @override
  Future<String?> getRefreshToken() async {
    return await _secureStorage.read(key: _keyRefreshToken);
  }

  @override
  Future<void> deleteRefreshToken() async {
    await _secureStorage.delete(key: _keyRefreshToken);
  }

  @override
  Future<void> saveSession(Map<String, dynamic> session) async {
    final sessionJson = _sessionToJson(session);
    await _secureStorage.write(key: _keySession, value: sessionJson);
  }

  @override
  Future<Map<String, dynamic>?> getSession() async {
    final sessionJson = await _secureStorage.read(key: _keySession);
    if (sessionJson == null) return null;

    return _sessionFromJson(sessionJson);
  }

  @override
  Future<void> deleteSession() async {
    await _secureStorage.delete(key: _keySession);
  }

  @override
  Future<void> clearAll() async {
    await Future.wait([
      deleteToken(),
      deleteRefreshToken(),
      deleteSession(),
    ]);
  }

  String _sessionToJson(Map<String, dynamic> session) {
    // Simple JSON encoding for session data
    return session.entries
        .map((e) => '${e.key}:${e.value}')
        .join(';');
  }

  Map<String, dynamic> _sessionFromJson(String json) {
    final map = <String, dynamic>{};
    for (final pair in json.split(';')) {
      final parts = pair.split(':');
      if (parts.length == 2) {
        map[parts[0]] = parts[1];
      }
    }
    return map;
  }
}

/// Token storage using SharedPreferences (less secure, for non-sensitive data)
///
/// Use this for non-sensitive session data or when secure storage is not available
class SharedPrefsTokenStore implements TokenStore {
  SharedPreferences? _prefs;

  static const _keyToken = 'auth_token';
  static const _keyRefreshToken = 'auth_refresh_token';
  static const _keySessionPrefix = 'auth_session_';

  Future<void> _ensureInitialized() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  @override
  Future<void> saveToken(String token) async {
    await _ensureInitialized();
    await _prefs!.setString(_keyToken, token);
  }

  @override
  Future<String?> getToken() async {
    await _ensureInitialized();
    return _prefs!.getString(_keyToken);
  }

  @override
  Future<void> deleteToken() async {
    await _ensureInitialized();
    await _prefs!.remove(_keyToken);
  }

  @override
  Future<void> saveRefreshToken(String token) async {
    await _ensureInitialized();
    await _prefs!.setString(_keyRefreshToken, token);
  }

  @override
  Future<String?> getRefreshToken() async {
    await _ensureInitialized();
    return _prefs!.getString(_keyRefreshToken);
  }

  @override
  Future<void> deleteRefreshToken() async {
    await _ensureInitialized();
    await _prefs!.remove(_keyRefreshToken);
  }

  @override
  Future<void> saveSession(Map<String, dynamic> session) async {
    await _ensureInitialized();
    for (final entry in session.entries) {
      final key = '$_keySessionPrefix${entry.key}';
      final value = entry.value;

      if (value is String) {
        await _prefs!.setString(key, value);
      } else if (value is int) {
        await _prefs!.setInt(key, value);
      } else if (value is bool) {
        await _prefs!.setBool(key, value);
      } else if (value is double) {
        await _prefs!.setDouble(key, value);
      }
    }
  }

  @override
  Future<Map<String, dynamic>?> getSession() async {
    await _ensureInitialized();
    final session = <String, dynamic>{};

    for (final key in _prefs!.getKeys()) {
      if (key.startsWith(_keySessionPrefix)) {
        final sessionKey = key.substring(_keySessionPrefix.length);
        session[sessionKey] = _prefs!.get(key);
      }
    }

    return session.isEmpty ? null : session;
  }

  @override
  Future<void> deleteSession() async {
    await _ensureInitialized();
    final keysToRemove = _prefs!
        .getKeys()
        .where((key) => key.startsWith(_keySessionPrefix))
        .toList();

    for (final key in keysToRemove) {
      await _prefs!.remove(key);
    }
  }

  @override
  Future<void> clearAll() async {
    await Future.wait([
      deleteToken(),
      deleteRefreshToken(),
      deleteSession(),
    ]);
  }
}

/// Hybrid token store that uses secure storage for tokens and SharedPreferences for session
///
/// Recommended approach: use secure storage for sensitive tokens,
/// SharedPreferences for non-sensitive session data
class HybridTokenStore implements TokenStore {
  final SecureTokenStore _secureStore;
  final SharedPrefsTokenStore _prefsStore;

  HybridTokenStore()
      : _secureStore = SecureTokenStore(),
        _prefsStore = SharedPrefsTokenStore();

  @override
  Future<void> saveToken(String token) => _secureStore.saveToken(token);

  @override
  Future<String?> getToken() => _secureStore.getToken();

  @override
  Future<void> deleteToken() => _secureStore.deleteToken();

  @override
  Future<void> saveRefreshToken(String token) =>
      _secureStore.saveRefreshToken(token);

  @override
  Future<String?> getRefreshToken() => _secureStore.getRefreshToken();

  @override
  Future<void> deleteRefreshToken() => _secureStore.deleteRefreshToken();

  @override
  Future<void> saveSession(Map<String, dynamic> session) =>
      _prefsStore.saveSession(session);

  @override
  Future<Map<String, dynamic>?> getSession() => _prefsStore.getSession();

  @override
  Future<void> deleteSession() => _prefsStore.deleteSession();

  @override
  Future<void> clearAll() async {
    await Future.wait([
      _secureStore.clearAll(),
      _prefsStore.clearAll(),
    ]);
  }
}
