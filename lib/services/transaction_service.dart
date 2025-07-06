// My imports
import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:message_expense_tracker/constants.dart';
import 'package:message_expense_tracker/middleware/auth_http_client.dart';
import 'package:message_expense_tracker/models/base_response.dart';
import 'package:message_expense_tracker/models/transaction.dart';

class TransactionService {
  final String token;
  final Ref ref;
  const TransactionService({required this.token, required this.ref});

  Future<APIResponse> fetchTransactions() async {
    final client = AuthHttpClient(token);
    try {
      final response = await client.get(
        Uri.parse("${AppConstants.backendBaseUrl}/transactions"),
      );
      final json = jsonDecode(response.body);
      if (response.statusCode == 200) {
        return APIResponse.fromJson(json, (jsonData) {
          if (jsonData == null) return null;
          return (jsonData as List)
              .map((item) => Transaction.fromJson(item))
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

  Future<APIResponse> createTransaction(Transaction transaction) async {
    final client = AuthHttpClient(token);
    try {
      var body = transaction.toJson();
      final response = await client.post(
        Uri.parse("${AppConstants.backendBaseUrl}/transactions/create"),
        body: jsonEncode(body),
        headers: {'Content-Type': 'application/json'},
      );
      final jsonData = jsonDecode(response.body);
      if (response.statusCode == 200) {
        var response = APIResponse.fromJson(jsonData, (jsonData) {
          if (jsonData == null) return null;
          return BaseData.fromJson(jsonData);
        });
        return response;
      } else {
        return APIResponse.fromJson(jsonData, (jsonData) => null);
      }
    } catch (err) {
      return APIResponse(
        success: false,
        error: "Something went wrong! Please try again later",
      );
    }
  }
}
