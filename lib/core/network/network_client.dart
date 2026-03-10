import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:vivocare/core/network/http_method.dart';
import 'package:vivocare/core/network/network_exception.dart';
import 'package:vivocare/core/network/network_response.dart';

class NetworkClient {
  NetworkClient({
    required String scheme,
    required String host,
    Duration timeout = const Duration(seconds: 25),
    http.Client? httpClient,
    Map<String, String>? defaultHeaders,
  }) : _scheme = scheme,
       _host = host,
       _timeout = timeout,
       _httpClient = httpClient ?? http.Client(),
       _defaultHeaders = <String, String>{
         'Accept': 'application/json',
         ...?defaultHeaders,
       };

  final String _scheme;
  final String _host;
  final Duration _timeout;
  final http.Client _httpClient;
  final Map<String, String> _defaultHeaders;

  Future<NetworkResponse<dynamic>> get(
    String path, {
    Map<String, String>? headers,
    Map<String, dynamic>? queryParameters,
  }) {
    return request(
      method: HttpMethod.get,
      path: path,
      headers: headers,
      queryParameters: queryParameters,
    );
  }

  Future<NetworkResponse<dynamic>> post(
    String path, {
    Object? body,
    Map<String, String>? headers,
    Map<String, dynamic>? queryParameters,
  }) {
    return request(
      method: HttpMethod.post,
      path: path,
      body: body,
      headers: headers,
      queryParameters: queryParameters,
    );
  }

  Future<NetworkResponse<dynamic>> put(
    String path, {
    Object? body,
    Map<String, String>? headers,
    Map<String, dynamic>? queryParameters,
  }) {
    return request(
      method: HttpMethod.put,
      path: path,
      body: body,
      headers: headers,
      queryParameters: queryParameters,
    );
  }

  Future<NetworkResponse<dynamic>> patch(
    String path, {
    Object? body,
    Map<String, String>? headers,
    Map<String, dynamic>? queryParameters,
  }) {
    return request(
      method: HttpMethod.patch,
      path: path,
      body: body,
      headers: headers,
      queryParameters: queryParameters,
    );
  }

  Future<NetworkResponse<dynamic>> delete(
    String path, {
    Object? body,
    Map<String, String>? headers,
    Map<String, dynamic>? queryParameters,
  }) {
    return request(
      method: HttpMethod.delete,
      path: path,
      body: body,
      headers: headers,
      queryParameters: queryParameters,
    );
  }

  Future<NetworkResponse<dynamic>> request({
    required HttpMethod method,
    required String path,
    Object? body,
    Map<String, String>? headers,
    Map<String, dynamic>? queryParameters,
  }) async {
    final Uri uri = _buildUri(path, queryParameters: queryParameters);
    final http.Request request = http.Request(method.value, uri)
      ..headers.addAll(_defaultHeaders)
      ..headers.addAll(headers ?? <String, String>{});

    if (body != null) {
      if (body is String) {
        request.headers['Content-Type'] ??= 'text/plain; charset=utf-8';
        request.body = body;
      } else {
        // Force JSON content-type before assigning request.body so it does not
        // default to text/plain and break backend payload validation.
        request.headers['Content-Type'] = 'application/json';
        request.body = jsonEncode(body);
      }
    }

    final String fullUrl = uri.toString();
    _logApi('REQUEST ${method.value} URL: $fullUrl');
    _logApi('REQUEST_HEADERS: ${request.headers}');
    _logApi('REQUEST_BODY: ${request.body.isEmpty ? '<empty>' : request.body}');

    try {
      final http.StreamedResponse streamedResponse = await _httpClient
          .send(request)
          .timeout(_timeout);
      final http.Response response = await http.Response.fromStream(
        streamedResponse,
      );

      _logApi('RESPONSE URL: $fullUrl STATUS: ${response.statusCode}');
      _logApi('RESPONSE_BODY: ${response.body}');

      final dynamic data = _decodeBody(response);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return NetworkResponse<dynamic>(
          statusCode: response.statusCode,
          headers: response.headers,
          data: data,
        );
      }

      throw NetworkException.fromStatusCode(
        statusCode: response.statusCode,
        message:
            _extractMessage(data) ?? _defaultErrorMessage(response.statusCode),
        data: data,
      );
    } on NetworkException {
      rethrow;
    } on TimeoutException {
      throw const NetworkException(
        message: 'Request timed out. Please try again.',
        type: NetworkExceptionType.timeout,
      );
    } on SocketException {
      throw const NetworkException(
        message: 'No internet connection. Please check your network and retry.',
        type: NetworkExceptionType.noInternet,
      );
    } on FormatException {
      throw const NetworkException(
        message: 'Unable to parse server response.',
        type: NetworkExceptionType.invalidResponse,
      );
    } on http.ClientException catch (error) {
      throw NetworkException(
        message: error.message,
        type: NetworkExceptionType.unknown,
      );
    } catch (_) {
      throw const NetworkException(
        message: 'Unexpected error occurred. Please try again.',
        type: NetworkExceptionType.unknown,
      );
    }
  }

  Uri _buildUri(String path, {Map<String, dynamic>? queryParameters}) {
    final String normalizedPath = path.startsWith('/')
        ? path.substring(1)
        : path;

    return Uri(
      scheme: _scheme,
      host: _host,
      path: normalizedPath,
      queryParameters: queryParameters?.map(
        (String key, dynamic value) =>
            MapEntry<String, String>(key, value.toString()),
      ),
    );
  }

  dynamic _decodeBody(http.Response response) {
    if (response.bodyBytes.isEmpty) {
      return null;
    }

    final String rawBody = utf8.decode(response.bodyBytes);
    if (rawBody.trim().isEmpty) {
      return null;
    }

    final String contentType = response.headers['content-type'] ?? '';
    final bool isJson =
        contentType.contains('application/json') || _looksLikeJson(rawBody);

    if (!isJson) {
      return rawBody;
    }

    return jsonDecode(rawBody);
  }

  bool _looksLikeJson(String value) {
    final String trimmed = value.trimLeft();
    return trimmed.startsWith('{') || trimmed.startsWith('[');
  }

  String? _extractMessage(dynamic data) {
    if (data is String && data.trim().isNotEmpty) {
      return data.trim();
    }

    if (data is List) {
      for (final dynamic item in data) {
        final String? extracted = _extractMessage(item);
        if (extracted != null && extracted.isNotEmpty) {
          return extracted;
        }
      }
      return null;
    }

    if (data is! Map<String, dynamic>) {
      return null;
    }

    const List<String> preferredKeys = <String>[
      'message',
      'msg',
      'error',
      'detail',
      'error_details',
      'description',
    ];

    for (final String key in preferredKeys) {
      final String? extracted = _extractMessage(data[key]);
      if (extracted != null && extracted.isNotEmpty) {
        return extracted;
      }
    }

    for (final Object? value in data.values) {
      final String? extracted = _extractMessage(value);
      if (extracted != null && extracted.isNotEmpty) {
        return extracted;
      }
    }

    return null;
  }

  String _defaultErrorMessage(int statusCode) {
    if (statusCode == 400) {
      return 'Bad request.';
    }
    if (statusCode == 401) {
      return 'Unauthorized request.';
    }
    if (statusCode == 403) {
      return 'Access forbidden.';
    }
    if (statusCode == 404) {
      return 'Resource not found.';
    }
    if (statusCode >= 500) {
      return 'Server error. Please try again later.';
    }
    return 'Request failed with status code $statusCode.';
  }

  void close() {
    _httpClient.close();
  }

  void _logApi(String message) {
    // Use synchronous + chunked logging so logs are not dropped/truncated.
    const int chunkSize = 900;
    final String prefixed = '[API] $message';
    for (int start = 0; start < prefixed.length; start += chunkSize) {
      final int end = (start + chunkSize).clamp(0, prefixed.length);
      debugPrintSynchronously(prefixed.substring(start, end));
    }
  }
}
