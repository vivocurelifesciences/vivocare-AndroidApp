import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:vivocare/core/network/network_client.dart';
import 'package:vivocare/core/network/network_exception.dart';

void main() {
  group('NetworkClient', () {
    test('POST sends JSON body and parses JSON response', () async {
      late http.Request capturedRequest;

      final MockClient mockClient = MockClient((http.Request request) async {
        capturedRequest = request;
        expect(request.body, '{"username":"tester","password":"secret"}');
        expect(request.headers['content-type'], 'application/json');

        return http.Response(
          '{"success":true,"message":"ok"}',
          200,
          headers: <String, String>{'content-type': 'application/json'},
        );
      });

      final NetworkClient client = NetworkClient(
        scheme: 'https',
        host: 'stage-api.vivocurelifesciences.com',
        httpClient: mockClient,
      );

      final response = await client.post(
        '/login',
        body: <String, String>{'username': 'tester', 'password': 'secret'},
      );

      expect(capturedRequest.method, 'POST');
      expect(capturedRequest.url.scheme, 'https');
      expect(capturedRequest.url.host, 'stage-api.vivocurelifesciences.com');
      expect(response.statusCode, 200);
      expect((response.data as Map<String, dynamic>)['success'], true);
    });

    test('DELETE supports query parameters', () async {
      late http.Request capturedRequest;

      final MockClient mockClient = MockClient((http.Request request) async {
        capturedRequest = request;
        return http.Response(
          '{"success":true}',
          200,
          headers: <String, String>{'content-type': 'application/json'},
        );
      });

      final NetworkClient client = NetworkClient(
        scheme: 'https',
        host: 'stage-api.vivocurelifesciences.com',
        httpClient: mockClient,
      );

      await client.delete(
        '/records',
        queryParameters: <String, dynamic>{'id': 9},
      );

      expect(capturedRequest.method, 'DELETE');
      expect(
        capturedRequest.url.toString(),
        'https://stage-api.vivocurelifesciences.com/records?id=9',
      );
    });

    test('throws NetworkException with API message for non-2xx', () async {
      final MockClient mockClient = MockClient((http.Request request) async {
        return http.Response(
          '{"message":"Invalid credentials"}',
          401,
          headers: <String, String>{'content-type': 'application/json'},
        );
      });

      final NetworkClient client = NetworkClient(
        scheme: 'https',
        host: 'stage-api.vivocurelifesciences.com',
        httpClient: mockClient,
      );

      await expectLater(
        () => client.post(
          '/login',
          body: <String, String>{'username': 'bad', 'password': 'bad'},
        ),
        throwsA(
          isA<NetworkException>()
              .having(
                (NetworkException error) => error.statusCode,
                'statusCode',
                401,
              )
              .having(
                (NetworkException error) => error.message,
                'message',
                'Invalid credentials',
              ),
        ),
      );
    });
  });
}
