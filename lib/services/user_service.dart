import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:message_expense_tracker/models/login.dart';
import 'package:message_expense_tracker/models/users.dart';

class UserService {
  Future<LoginResponse> registerUser(RegisterRequest request) async {
    final uri = Uri.parse(
      "https://267c-2401-4900-1c96-7bf7-cc90-8a3c-ca24-e837.ngrok-free.app/users/register",
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
    } else {
      throw Exception("Something went wrong");
    }
  }
}
