enum NetworkExceptionType {
  badRequest,
  unauthorized,
  forbidden,
  notFound,
  timeout,
  noInternet,
  invalidResponse,
  serverError,
  unknown,
}

class NetworkException implements Exception {
  const NetworkException({
    required this.message,
    required this.type,
    this.statusCode,
    this.data,
  });

  final String message;
  final NetworkExceptionType type;
  final int? statusCode;
  final Object? data;

  factory NetworkException.fromStatusCode({
    required int statusCode,
    required String message,
    Object? data,
  }) {
    if (statusCode == 400) {
      return NetworkException(
        message: message,
        type: NetworkExceptionType.badRequest,
        statusCode: statusCode,
        data: data,
      );
    }

    if (statusCode == 401) {
      return NetworkException(
        message: message,
        type: NetworkExceptionType.unauthorized,
        statusCode: statusCode,
        data: data,
      );
    }

    if (statusCode == 403) {
      return NetworkException(
        message: message,
        type: NetworkExceptionType.forbidden,
        statusCode: statusCode,
        data: data,
      );
    }

    if (statusCode == 404) {
      return NetworkException(
        message: message,
        type: NetworkExceptionType.notFound,
        statusCode: statusCode,
        data: data,
      );
    }

    if (statusCode >= 500) {
      return NetworkException(
        message: message,
        type: NetworkExceptionType.serverError,
        statusCode: statusCode,
        data: data,
      );
    }

    return NetworkException(
      message: message,
      type: NetworkExceptionType.unknown,
      statusCode: statusCode,
      data: data,
    );
  }

  @override
  String toString() {
    return 'NetworkException(type: $type, statusCode: $statusCode, message: $message)';
  }
}
