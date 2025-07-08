import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:message_expense_tracker/constants.dart';
import 'package:message_expense_tracker/middleware/auth_http_client.dart';
import 'package:message_expense_tracker/models/base_response.dart';
import 'package:message_expense_tracker/models/login.dart';

class AuthService {
  Future<APIResponse?> login(LoginRequest request) async {
    final uri = Uri.parse("${AppConstants.backendBaseUrl}/auth/login");
    final jsonBody = jsonEncode(request.toJson());
    final response = await http.post(
      uri,
      body: jsonBody,
      headers: {'Content-Type': 'application/json'},
    );

    final json = jsonDecode(response.body);
    if (response.statusCode == 200) {
      return APIResponse.fromJson(json, (jsonData) {
        if (jsonData == null) return null;
        return LoginResponse.fromJson(jsonData as Map<String, dynamic>);
      });
    } else {
      return APIResponse.fromJson(json, (jsonData) => null);
    }
  }

  Future<APIResponse?> refreshAccessToken(String refreshToken) async {
    var authHttpClient = AuthHttpClient("");
    bool res = await authHttpClient.refreshAccessToken();
    if (res) {
      FlutterSecureStorage storage = const FlutterSecureStorage();
      String? data = await storage.read(key: "authDetails");
      if (data != null) {
        LoginResponse userDetails = LoginResponse.fromJson(jsonDecode(data));
        return APIResponse(success: true, data: userDetails);
      }
    }
    return APIResponse(success: false);
  }
}
