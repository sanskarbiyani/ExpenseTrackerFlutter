import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:message_expense_tracker/constants.dart';
import 'package:message_expense_tracker/models/base_response.dart';
// My Imports
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
}
