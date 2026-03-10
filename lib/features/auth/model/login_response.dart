class LoginResponse {
  const LoginResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  final bool success;
  final String message;
  final LoginSessionData data;

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    final Map<String, dynamic> bodyData = _asMap(json['data']);
    final Map<String, dynamic> payload = _resolvePayload(
      root: json,
      bodyData: bodyData,
    );
    final String accessToken = _stringValue(payload['access_token']);
    final String refreshToken = _stringValue(payload['refresh_token']);
    final bool hasTokenPayload =
        accessToken.isNotEmpty || refreshToken.isNotEmpty;
    final String message = _firstNonEmpty(<String?>[
      json['message'] as String?,
      json['msg'] as String?,
      json['detail'] as String?,
      payload['message'] as String?,
      payload['msg'] as String?,
      payload['detail'] as String?,
    ]);

    return LoginResponse(
      success: json['success'] == true || hasTokenPayload,
      message: message,
      data: LoginSessionData.fromJson(payload),
    );
  }
}

class LoginSessionData {
  const LoginSessionData({
    required this.accessToken,
    required this.refreshToken,
    required this.tokenType,
    required this.accessExpiresIn,
    required this.refreshExpiresIn,
    required this.user,
  });

  final String accessToken;
  final String refreshToken;
  final String tokenType;
  final int accessExpiresIn;
  final int refreshExpiresIn;
  final LoginUserData user;

  String get username => user.username;

  factory LoginSessionData.fromJson(Map<String, dynamic> json) {
    final Map<String, dynamic> userJson = _asMap(json['user']);
    final Map<String, dynamic> resolvedUser = userJson.isNotEmpty
        ? userJson
        : json;

    return LoginSessionData(
      accessToken: _stringValue(json['access_token']),
      refreshToken: _stringValue(json['refresh_token']),
      tokenType: _stringValue(json['token_type']),
      accessExpiresIn: _intValue(json['access_expires_in']),
      refreshExpiresIn: _intValue(json['refresh_expires_in']),
      user: LoginUserData.fromJson(resolvedUser),
    );
  }
}

class LoginUserData {
  const LoginUserData({
    required this.id,
    required this.employeeCode,
    required this.fullName,
    required this.email,
    required this.roleId,
    required this.roleName,
    required this.username,
  });

  final String id;
  final String employeeCode;
  final String fullName;
  final String email;
  final String roleId;
  final String roleName;
  final String username;

  factory LoginUserData.fromJson(Map<String, dynamic> json) {
    final List<String?> candidates = <String?>[
      json['username'] as String?,
      json['full_name'] as String?,
      json['email'] as String?,
      json['employee_code'] as String?,
    ];

    String resolved = '';
    for (final String? candidate in candidates) {
      final String trimmed = (candidate ?? '').trim();
      if (trimmed.isNotEmpty) {
        resolved = trimmed;
        break;
      }
    }

    return LoginUserData(
      id: _stringValue(json['id']),
      employeeCode: _stringValue(json['employee_code']),
      fullName: _stringValue(json['full_name']),
      email: _stringValue(json['email']),
      roleId: _stringValue(json['role_id']),
      roleName: _stringValue(json['role_name']),
      username: resolved,
    );
  }
}

Map<String, dynamic> _asMap(Object? value) {
  if (value is Map<String, dynamic>) {
    return value;
  }
  if (value is Map) {
    return value.map((Object? key, Object? value) {
      return MapEntry<String, dynamic>(key.toString(), value);
    });
  }
  return <String, dynamic>{};
}

Map<String, dynamic> _resolvePayload({
  required Map<String, dynamic> root,
  required Map<String, dynamic> bodyData,
}) {
  final String rootToken = _stringValue(root['access_token']);
  final String bodyToken = _stringValue(bodyData['access_token']);

  if (rootToken.isNotEmpty) {
    return root;
  }
  if (bodyToken.isNotEmpty) {
    return bodyData;
  }
  if (bodyData.isNotEmpty) {
    return bodyData;
  }
  return root;
}

String _firstNonEmpty(List<String?> values) {
  for (final String? value in values) {
    final String trimmed = (value ?? '').trim();
    if (trimmed.isNotEmpty) {
      return trimmed;
    }
  }
  return '';
}

String _stringValue(Object? value) {
  if (value is String) {
    return value.trim();
  }
  if (value == null) {
    return '';
  }
  return value.toString().trim();
}

int _intValue(Object? value) {
  if (value is int) {
    return value;
  }
  if (value is String) {
    return int.tryParse(value.trim()) ?? 0;
  }
  return 0;
}
