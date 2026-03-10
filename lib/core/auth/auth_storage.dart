import 'package:shared_preferences/shared_preferences.dart';

class AuthStorage {
  static const String _savedUsernameKey = 'saved_login_username';
  static const String _savedPasswordKey = 'saved_login_password';
  static const String _accessTokenKey = 'auth_access_token';
  static const String _refreshTokenKey = 'auth_refresh_token';
  static const String _tokenTypeKey = 'auth_token_type';

  static Future<SavedLoginCredentials> loadSavedCredentials() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return SavedLoginCredentials(
      username: prefs.getString(_savedUsernameKey) ?? '',
      password: prefs.getString(_savedPasswordKey) ?? '',
    );
  }

  static Future<void> saveCredentials({
    required String username,
    required String password,
  }) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_savedUsernameKey, username);
    await prefs.setString(_savedPasswordKey, password);
  }

  static Future<void> saveSession({
    required String accessToken,
    required String refreshToken,
    required String tokenType,
  }) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_accessTokenKey, accessToken);
    await prefs.setString(_refreshTokenKey, refreshToken);
    await prefs.setString(_tokenTypeKey, tokenType);
  }

  static Future<AuthSession> loadSession() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return AuthSession(
      accessToken: prefs.getString(_accessTokenKey) ?? '',
      refreshToken: prefs.getString(_refreshTokenKey) ?? '',
      tokenType: prefs.getString(_tokenTypeKey) ?? '',
    );
  }

  static Future<void> clearSession() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(_accessTokenKey);
    await prefs.remove(_refreshTokenKey);
    await prefs.remove(_tokenTypeKey);
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
