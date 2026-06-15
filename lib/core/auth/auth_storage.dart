import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

/// Secure session/credential storage.
///
/// Tokens, the saved username and the offline password verifier live in the
/// platform keystore (flutter_secure_storage). Passwords are NEVER stored in
/// plaintext anymore — offline login verifies against a salted PBKDF2 hash.
///
/// The static API is kept compatible with the previous SharedPreferences
/// implementation so call sites did not have to change shape.
class AuthStorage {
  static const FlutterSecureStorage _storage = FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
  );

  static const String _savedUsernameKey = 'saved_login_username';
  static const String _accessTokenKey = 'auth_access_token';
  static const String _refreshTokenKey = 'auth_refresh_token';
  static const String _tokenTypeKey = 'auth_token_type';
  static const String _verifierKey = 'offline_login_verifier';
  static const String _userProfileKey = 'auth_user_profile';
  static const String _lastLoginAtKey = 'auth_last_login_at';
  static const String _lastActivityAtKey = 'auth_last_activity_at';

  /// Sessions silently expire after this much inactivity (measured from the
  /// later of last login / last app activity). The rep then has to sign in
  /// again — online or via the offline verifier.
  static const Duration sessionLifetime = Duration(days: 15);

  // Legacy SharedPreferences keys (migrated then wiped).
  static const List<String> _legacyKeys = <String>[
    'saved_login_username',
    'saved_login_password',
    'auth_access_token',
    'auth_refresh_token',
    'auth_token_type',
  ];

  /// One-time migration of tokens out of SharedPreferences; deletes the
  /// legacy plaintext password unconditionally.
  static Future<void> migrateFromSharedPreferences() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? legacyAccess = prefs.getString('auth_access_token');
    if (legacyAccess != null && legacyAccess.isNotEmpty) {
      await saveSession(
        accessToken: legacyAccess,
        refreshToken: prefs.getString('auth_refresh_token') ?? '',
        tokenType: prefs.getString('auth_token_type') ?? '',
      );
    }
    final String? legacyUsername = prefs.getString('saved_login_username');
    if (legacyUsername != null && legacyUsername.isNotEmpty) {
      await _storage.write(key: _savedUsernameKey, value: legacyUsername);
    }
    for (final String key in _legacyKeys) {
      await prefs.remove(key);
    }
  }

  static Future<SavedLoginCredentials> loadSavedCredentials() async {
    final String username = await _storage.read(key: _savedUsernameKey) ?? '';
    // Password intentionally always empty: plaintext passwords are not stored.
    return SavedLoginCredentials(username: username, password: '');
  }

  static Future<void> saveCredentials({
    required String username,
    required String password,
  }) async {
    await _storage.write(key: _savedUsernameKey, value: username);
    if (password.isNotEmpty) {
      await _saveOfflineVerifier(username: username, password: password);
    }
  }

  static Future<void> saveSession({
    required String accessToken,
    required String refreshToken,
    required String tokenType,
  }) async {
    await _storage.write(key: _accessTokenKey, value: accessToken);
    await _storage.write(key: _refreshTokenKey, value: refreshToken);
    await _storage.write(key: _tokenTypeKey, value: tokenType);
  }

  static Future<AuthSession> loadSession() async {
    return AuthSession(
      accessToken: await _storage.read(key: _accessTokenKey) ?? '',
      refreshToken: await _storage.read(key: _refreshTokenKey) ?? '',
      tokenType: await _storage.read(key: _tokenTypeKey) ?? '',
    );
  }

  static Future<void> clearSession() async {
    await _storage.delete(key: _accessTokenKey);
    await _storage.delete(key: _refreshTokenKey);
    await _storage.delete(key: _tokenTypeKey);
  }

  /// Full wipe (logout): session + verifier + profile. Keeps saved username.
  static Future<void> clearAll() async {
    await clearSession();
    await _storage.delete(key: _verifierKey);
    await _storage.delete(key: _userProfileKey);
    await _storage.delete(key: _lastLoginAtKey);
    await _storage.delete(key: _lastActivityAtKey);
  }

  // -------------------------------------------------------- session lifetime

  /// Records a successful sign-in (online or offline-verified). Resets the
  /// 15-day expiry window.
  static Future<void> markLogin() async {
    final String now = DateTime.now().toUtc().toIso8601String();
    await _storage.write(key: _lastLoginAtKey, value: now);
    await _storage.write(key: _lastActivityAtKey, value: now);
  }

  /// Slides the inactivity window forward; call on app open/resume.
  static Future<void> touchActivity() => _storage.write(
    key: _lastActivityAtKey,
    value: DateTime.now().toUtc().toIso8601String(),
  );

  /// True when the rep has been inactive longer than [sessionLifetime].
  /// Pre-existing sessions without a recorded timestamp are grandfathered in:
  /// the window starts counting from this first check.
  static Future<bool> isSessionExpired() async {
    final String? activity = await _storage.read(key: _lastActivityAtKey);
    final String? login = await _storage.read(key: _lastLoginAtKey);
    final DateTime? reference =
        DateTime.tryParse(activity ?? '') ?? DateTime.tryParse(login ?? '');
    if (reference == null) {
      await markLogin();
      return false;
    }
    return DateTime.now().toUtc().difference(reference.toUtc()) >
        sessionLifetime;
  }

  // ------------------------------------------------------------ user profile

  static Future<void> saveUserProfile(Map<String, dynamic> profile) =>
      _storage.write(key: _userProfileKey, value: jsonEncode(profile));

  static Future<Map<String, dynamic>?> loadUserProfile() async {
    final String? raw = await _storage.read(key: _userProfileKey);
    if (raw == null || raw.isEmpty) {
      return null;
    }
    final dynamic decoded = jsonDecode(raw);
    return decoded is Map<String, dynamic> ? decoded : null;
  }

  // ----------------------------------------------------------- offline login

  static const int _pbkdf2Rounds = 30000;

  static Future<void> _saveOfflineVerifier({
    required String username,
    required String password,
  }) async {
    final String salt = const Uuid().v4();
    final String hash = _pbkdf2(password, salt);
    await _storage.write(
      key: _verifierKey,
      value: jsonEncode(<String, String>{
        'username': username.toLowerCase(),
        'salt': salt,
        'hash': hash,
      }),
    );
  }

  /// Validates credentials against the locally stored verifier so a rep can
  /// re-enter the app with zero connectivity. Returns false when no verifier
  /// exists (user must login online once first).
  static Future<bool> verifyOffline({
    required String username,
    required String password,
  }) async {
    final String? raw = await _storage.read(key: _verifierKey);
    if (raw == null || raw.isEmpty) {
      return false;
    }
    try {
      final Map<String, dynamic> verifier =
          jsonDecode(raw) as Map<String, dynamic>;
      if ((verifier['username'] as String? ?? '') != username.toLowerCase()) {
        return false;
      }
      final String expected = verifier['hash'] as String? ?? '';
      final String salt = verifier['salt'] as String? ?? '';
      return expected.isNotEmpty && _pbkdf2(password, salt) == expected;
    } catch (_) {
      return false;
    }
  }

  /// PBKDF2-HMAC-SHA256, single block (32-byte output).
  static String _pbkdf2(String password, String salt) {
    final Hmac hmac = Hmac(sha256, utf8.encode(password));
    List<int> block = hmac.convert(<int>[
      ...utf8.encode(salt),
      0,
      0,
      0,
      1,
    ]).bytes;
    List<int> result = List<int>.from(block);
    for (int i = 1; i < _pbkdf2Rounds; i++) {
      block = hmac.convert(block).bytes;
      for (int j = 0; j < result.length; j++) {
        result[j] ^= block[j];
      }
    }
    return base64Encode(result);
  }
}

class SavedLoginCredentials {
  const SavedLoginCredentials({required this.username, required this.password});

  final String username;
  final String password;
}

class AuthSession {
  const AuthSession({
    required this.accessToken,
    required this.refreshToken,
    required this.tokenType,
  });

  final String accessToken;
  final String refreshToken;
  final String tokenType;

  bool get hasAccessToken => accessToken.trim().isNotEmpty;

  String get authorizationHeader {
    final String normalizedType = tokenType.trim().toLowerCase();
    final String resolvedType =
        normalizedType == 'bearer' || normalizedType.isEmpty
        ? 'Bearer'
        : tokenType.trim();
    return '$resolvedType $accessToken'.trim();
  }
}
