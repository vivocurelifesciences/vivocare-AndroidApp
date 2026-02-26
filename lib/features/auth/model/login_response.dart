class LoginResponse {
  const LoginResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  final bool success;
  final String message;
  final LoginUserData data;

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    final Object? rawData = json['data'];

    return LoginResponse(
      success: json['success'] == true,
      message: (json['message'] as String?)?.trim() ?? '',
      data: LoginUserData.fromJson(
        rawData is Map<String, dynamic> ? rawData : <String, dynamic>{},
      ),
    );
  }
}

class LoginUserData {
  const LoginUserData({required this.username});

  final String username;

  factory LoginUserData.fromJson(Map<String, dynamic> json) {
    return LoginUserData(username: (json['username'] as String?)?.trim() ?? '');
  }
}
