import 'package:http/http.dart' as http;

class AuthHttpClient extends http.BaseClient {
  final String token;
  final http.Client _inner;

  AuthHttpClient(this.token, [http.Client? inner])
    : _inner = inner ?? http.Client();

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) {
    request.headers['Authorization'] = 'Bearer $token';
    return _inner.send(request);
  }
}
