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

    // log outgoing request
    debugPrint('➡️ HTTP ${method.value} $uri');
    debugPrint('Headers: ${request.headers}');
    if (request.body.isNotEmpty) {
      debugPrint('Body: ${request.body}');
    }

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

    try {
      final http.StreamedResponse streamedResponse = await _httpClient
          .send(request)
          .timeout(_timeout);
      final http.Response response = await http.Response.fromStream(
        streamedResponse,
      );

      // log incoming response
      debugPrint('⬅️ Response [${response.statusCode}] ${response.body}');

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
    if (data is! Map<String, dynamic>) {
      return null;
    }

    final Object? message = data['message'];
    if (message is String && message.trim().isNotEmpty) {
      return message.trim();
    }

    final Object? error = data['error'];
    if (error is String && error.trim().isNotEmpty) {
      return error.trim();
    }

    final Object? detail = data['detail'];
    if (detail is String && detail.trim().isNotEmpty) {
      return detail.trim();
    }
    if (detail is List && detail.isNotEmpty) {
      final Object first = detail.first;
      if (first is Map<String, dynamic>) {
        final Object? firstMessage = first['msg'];
        if (firstMessage is String && firstMessage.trim().isNotEmpty) {
          return firstMessage.trim();
        }
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
}
