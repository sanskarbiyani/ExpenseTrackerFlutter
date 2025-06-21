import 'dart:convert';

import 'package:http/http.dart' as http;
// My Imports
import 'package:message_expense_tracker/models/login.dart';

class AuthService {
  Future<LoginResponse?> login(LoginRequest request) async {
    final uri = Uri.parse(
      "https://267c-2401-4900-1c96-7bf7-cc90-8a3c-ca24-e837.ngrok-free.app/auth/login",
    );
    final jsonBody = jsonEncode(request.toJson());
    final response = await http.post(
      uri,
      body: jsonBody,
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      return LoginResponse.fromJson(json);
    } else if (response.statusCode == 401) {
      throw Exception("Invalid credentials");
    } else {
      throw Exception("Something went wrong");
    }
  }
}
