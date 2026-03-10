import 'package:flutter/foundation.dart';
import 'package:vivocare/core/config/api_config.dart';
import 'package:vivocare/core/network/network_exception.dart';
import 'package:vivocare/core/network/network_client.dart';
import 'package:vivocare/core/network/network_response.dart';
import 'package:vivocare/features/auth/model/login_request.dart';
import 'package:vivocare/features/auth/model/login_response.dart';

abstract interface class AuthRepository {
  Future<LoginResponse> login(LoginRequest request);

  void dispose();
}

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl({required NetworkClient networkClient})
    : _networkClient = networkClient;

  final NetworkClient _networkClient;

  @override
  Future<LoginResponse> login(LoginRequest request) async {
    final NetworkResponse<dynamic> response = await _networkClient.post(
      '${ApiConfig.apiVersionPath}/auth/login',
      body: request.toJson(),
    );

    final dynamic responseData = response.data;
    debugPrintSynchronously('[API][LOGIN] STATUS: ${response.statusCode}');
    debugPrintSynchronously('[API][LOGIN] RESPONSE: $responseData');
    if (responseData is! Map<String, dynamic>) {
      throw const NetworkException(
        message: 'Invalid login response from server.',
        type: NetworkExceptionType.invalidResponse,
      );
    }

    final LoginResponse loginResponse = LoginResponse.fromJson(responseData);

    if (!loginResponse.success) {
      throw NetworkException(
        message: loginResponse.message.isEmpty
            ? 'Login failed. Please try again.'
            : loginResponse.message,
        type: NetworkExceptionType.badRequest,
        statusCode: response.statusCode,
        data: responseData,
      );
    }

    return loginResponse;
  }

  @override
  void dispose() {
    _networkClient.close();
  }
}
