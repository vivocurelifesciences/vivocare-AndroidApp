class LoginRequest {
  const LoginRequest({required this.identifier, required this.password});

  final String identifier;
  final String password;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{'identifier': identifier, 'password': password};
  }
}
