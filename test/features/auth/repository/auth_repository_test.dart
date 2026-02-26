import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:vivocare/core/network/network_client.dart';
import 'package:vivocare/features/auth/model/login_request.dart';
import 'package:vivocare/features/auth/repository/auth_repository.dart';

void main() {
  test('AuthRepository returns parsed login model on success', () async {
    final MockClient mockClient = MockClient((http.Request request) async {
      return http.Response(
        '{"success":true,"message":"Login successful (dummy)","data":{"username":"demo","password":"pw"}}',
        200,
        headers: <String, String>{'content-type': 'application/json'},
      );
    });

    final NetworkClient networkClient = NetworkClient(
      scheme: 'https',
      host: 'stage-api.vivocurelifesciences.com',
      httpClient: mockClient,
    );
    final AuthRepository repository = AuthRepositoryImpl(
      networkClient: networkClient,
    );

    final response = await repository.login(
      const LoginRequest(username: 'demo', password: 'pw'),
    );

    expect(response.success, true);
    expect(response.data.username, 'demo');
  });
}
