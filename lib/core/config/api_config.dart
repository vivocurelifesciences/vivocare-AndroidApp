class ApiConfig {
  static const String scheme = 'https';
  static const String host = 'stage-api.vivocurelifesciences.com';
  static const String apiVersionPath = '/api/v1';

  static bool get isLowerEnvironment {
    final String normalizedHost = host.toLowerCase();
    return normalizedHost.contains('stage') || normalizedHost.contains('prod');
  }
}
