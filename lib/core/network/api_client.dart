import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:vivocure/core/auth/auth_storage.dart';
import 'package:vivocure/core/config/api_config.dart';
import 'package:vivocure/core/network/http_method.dart';
import 'package:vivocure/core/network/network_client.dart';
import 'package:vivocure/core/network/network_exception.dart';
import 'package:vivocure/core/network/network_response.dart';

/// Authenticated API client: attaches the Bearer token automatically and
/// transparently refreshes it once on a 401 before failing.
///
/// This is the ONLY network entry point for the sync engine and auth flows.
/// Feature code (view-models, screens) must not call the network directly —
/// it reads/writes the local database via repositories.
class ApiClient {
  ApiClient({NetworkClient? networkClient})
      : _client = networkClient ??
            NetworkClient(scheme: ApiConfig.scheme, host: ApiConfig.host);

  final NetworkClient _client;
  Future<bool>? _refreshInFlight;

  static String apiPath(String path) =>
      '${ApiConfig.apiVersionPath}${path.startsWith('/') ? path : '/$path'}';

  Future<NetworkResponse<dynamic>> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
  }) =>
      _authedRequest(
        method: HttpMethod.get,
        path: path,
        queryParameters: queryParameters,
        headers: headers,
      );

  Future<NetworkResponse<dynamic>> post(
    String path, {
    Object? body,
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
  }) =>
      _authedRequest(
        method: HttpMethod.post,
        path: path,
        body: body,
        queryParameters: queryParameters,
        headers: headers,
      );

  Future<NetworkResponse<dynamic>> put(
    String path, {
    Object? body,
    Map<String, String>? headers,
  }) =>
      _authedRequest(
        method: HttpMethod.put,
        path: path,
        body: body,
        headers: headers,
      );

  Future<NetworkResponse<dynamic>> deleteRequest(
    String path, {
    Map<String, String>? headers,
  }) =>
      _authedRequest(method: HttpMethod.delete, path: path, headers: headers);

  Future<NetworkResponse<dynamic>> _authedRequest({
    required HttpMethod method,
    required String path,
    Object? body,
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
    bool isRetry = false,
  }) async {
    final AuthSession session = await AuthStorage.loadSession();
    if (!session.hasAccessToken) {
      throw const NetworkException(
        message: 'Not authenticated',
        type: NetworkExceptionType.unauthorized,
      );
    }
    try {
      return await _client.request(
        method: method,
        path: apiPath(path),
        body: body,
        queryParameters: queryParameters,
        headers: <String, String>{
          'Authorization': session.authorizationHeader,
          ...?headers,
        },
      );
    } on NetworkException catch (error) {
      final bool unauthorized =
          error.type == NetworkExceptionType.unauthorized ||
              error.statusCode == 401;
      if (!unauthorized || isRetry) {
        rethrow;
      }
      final bool refreshed = await _refreshSession(session);
      if (!refreshed) {
        rethrow;
      }
      return _authedRequest(
        method: method,
        path: path,
        body: body,
        queryParameters: queryParameters,
        headers: headers,
        isRetry: true,
      );
    }
  }

  /// Refresh access token via /auth/refresh, deduplicating concurrent calls.
  Future<bool> _refreshSession(AuthSession current) {
    return _refreshInFlight ??= _doRefresh(current).whenComplete(() {
      _refreshInFlight = null;
    });
  }

  Future<bool> _doRefresh(AuthSession current) async {
    if (current.refreshToken.trim().isEmpty) {
      return false;
    }
    try {
      final NetworkResponse<dynamic> response = await _client.post(
        apiPath('/auth/refresh'),
        body: <String, String>{'refresh_token': current.refreshToken},
      );
      final dynamic root = response.data;
      final dynamic data = root is Map<String, dynamic>
          ? (root['data'] is Map<String, dynamic> ? root['data'] : root)
          : null;
      if (data is! Map<String, dynamic>) {
        return false;
      }
      final String access = (data['access_token'] ?? '').toString();
      if (access.isEmpty) {
        return false;
      }
      await AuthStorage.saveSession(
        accessToken: access,
        refreshToken:
            (data['refresh_token'] ?? current.refreshToken).toString(),
        tokenType: (data['token_type'] ?? current.tokenType).toString(),
      );
      debugPrint('[API] Access token refreshed');
      return true;
    } catch (error) {
      debugPrint('[API] Token refresh failed: $error');
      return false;
    }
  }

  void close() => _client.close();
}
