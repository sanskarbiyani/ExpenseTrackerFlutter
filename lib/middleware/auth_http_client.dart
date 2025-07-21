import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:message_expense_tracker/constants.dart';
import 'package:message_expense_tracker/models/base_response.dart';
import 'package:message_expense_tracker/models/login.dart';

class AuthHttpClient extends http.BaseClient {
  final http.Client _inner;
  String? _accessToken;
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();
  final Uri _refreshUri = Uri.parse(
    "${AppConstants.backendBaseUrl}/auth/validate",
  );

  AuthHttpClient(this._accessToken, [http.Client? inner])
    : _inner = inner ?? http.Client();

  /// If you want to update the access token later
  void updateAccessToken(String token) {
    _accessToken = token;
  }

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    // Attach Authorization header if access token exists
    if (_accessToken != null) {
      request.headers['Authorization'] = 'Bearer $_accessToken';
    }

    // Send the request
    http.StreamedResponse response = await _inner.send(request);

    // If Unauthorized, try to refresh
    if (response.statusCode == 401) {
      final refreshed = await refreshAccessToken();
      if (refreshed) {
        // Clone and retry the original request
        final clonedRequest = _cloneRequest(request);
        clonedRequest.headers['Authorization'] = 'Bearer $_accessToken';
        response = await _inner.send(clonedRequest);
      }
    }

    return response;
  }

  /// Refresh the access token using the refresh token from secure storage
  Future<bool> refreshAccessToken() async {
    final authDetails = await _secureStorage.read(key: 'authDetails');
    if (authDetails == null) return false;

    try {
      LoginResponse userDetails = LoginResponse.fromJson(
        jsonDecode(authDetails),
      );
      final String refreshToken = userDetails.refreshToken;
      final response = await http.post(
        _refreshUri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'token': refreshToken}),
      );

      if (response.statusCode == 200) {
        var jsonBody = jsonDecode(response.body);
        var apiResponse = APIResponse.fromJson(jsonBody, (jsonData) {
          if (jsonData == null) return null;
          return LoginResponse.fromJson(jsonData as Map<String, dynamic>);
        });
        if (apiResponse.success && apiResponse.data != null) {
          var newUserDetails = LoginResponse(
            accessToken: apiResponse.data!.accessToken,
            refreshToken: apiResponse.data!.refreshToken,
            tokenType: apiResponse.data!.tokenType,
            user: userDetails.user,
          );
          await _secureStorage.write(
            key: 'authDetails',
            value: jsonEncode(newUserDetails.toJson()),
          );
          return true;
        } else {
          await _secureStorage.delete(key: 'authDetails');
          return false;
        }
      } else {
        return false;
      }
    } catch (err) {
      return false;
    }
  }

  /// Helper to clone the request
  http.Request _cloneRequest(http.BaseRequest request) {
    if (request is http.Request) {
      final clone =
          http.Request(request.method, request.url)
            ..headers.addAll(request.headers)
            ..bodyBytes = request.bodyBytes;
      return clone;
    } else {
      throw UnsupportedError('Request type not supported for retrying');
    }
  }
}
