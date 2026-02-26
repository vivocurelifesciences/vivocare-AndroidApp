enum HttpMethod { get, post, put, patch, delete }

extension HttpMethodX on HttpMethod {
  String get value => name.toUpperCase();
}
