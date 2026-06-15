class ApiConfig {
  /// Override host/scheme at build time when needed, e.g. local development:
  ///   flutter run --dart-define=API_HOST=10.0.2.2:8000 --dart-define=API_SCHEME=http
  static const String _hostOverride = String.fromEnvironment('API_HOST');
  static const String _schemeOverride = String.fromEnvironment('API_SCHEME');

  static const String _defaultHost = 'prod-api.vivocurelifesciences.com';
  static const String _defaultScheme = 'https';

  static const String apiVersionPath = '/api/v1';

  static String get host =>
      _hostOverride.isNotEmpty ? _hostOverride : _defaultHost;

  static String get scheme =>
      _schemeOverride.isNotEmpty ? _schemeOverride : _defaultScheme;

  static bool get isLowerEnvironment {
    final String normalizedHost = host.toLowerCase();
    return normalizedHost.contains('stage') || normalizedHost.contains('prod');
  }
}
