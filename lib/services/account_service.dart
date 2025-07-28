import 'dart:convert';

import 'package:message_expense_tracker/middleware/auth_http_client.dart';
import 'package:message_expense_tracker/models/account.dart';
import 'package:message_expense_tracker/models/base_response.dart';

import '../constants.dart';

class AccountService {
  final String token;

  const AccountService(this.token);

  Future<APIResponse> fetchAccounts() async {
    final client = AuthHttpClient(token);
    try {
      final response = await client.get(
        Uri.parse("${AppConstants.backendBaseUrl}/accounts"),
      );
      final json = jsonDecode(response.body);
      if (response.statusCode == 200) {
        return APIResponse.fromJson(json, (jsonData) {
          if (jsonData == null) return null;
          return (jsonData as List)
              .map((item) => Account.fromJson(item))
              .toList();
        });
      } else {
        return APIResponse.fromJson(json, (jsonData) => null);
      }
    } catch (err) {
      return APIResponse(
        success: false,
        error: "Something went wrong! Please try again later.",
      );
    }
  }

  Future<APIResponse> addAccount(Account acc) async {
    final client = AuthHttpClient(token);
    try {
      final jsonBody = jsonEncode(acc.toJson());
      final response = await client.post(
        Uri.parse("${AppConstants.backendBaseUrl}/accounts/create"),
        body: jsonBody,
        headers: {'Content-Type': 'application/json'},
      );

      final jsonData = jsonDecode(response.body);
      if (response.statusCode == 200) {
        return APIResponse.fromJson(jsonData, (jsonData) {
          if (jsonData == null) return null;
          return Account.fromJson(jsonData as Map<String, dynamic>);
        });
      } else {
        return APIResponse.fromJson(jsonData, (jsonData) => null);
      }
    } catch (err) {
      return APIResponse(
        success: false,
        data: null,
        error: "Something went wrong! Please try again later.",
      );
    }
  }
}
