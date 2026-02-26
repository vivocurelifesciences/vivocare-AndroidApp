class NetworkResponse<T> {
  const NetworkResponse({
    required this.statusCode,
    required this.headers,
    required this.data,
  });

  final int statusCode;
  final Map<String, String> headers;
  final T data;

  bool get isSuccess => statusCode >= 200 && statusCode < 300;
}
