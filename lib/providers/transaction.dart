import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:message_expense_tracker/models/auth_state.dart';
import 'package:message_expense_tracker/models/base_response.dart';
import 'package:message_expense_tracker/models/transaction.dart';
import 'package:message_expense_tracker/providers/auth.dart';
import 'package:message_expense_tracker/providers/loading_state.dart';
import 'package:message_expense_tracker/services/transaction_service.dart';

class TransactionNotifier extends StateNotifier<List<Transaction>> {
  final TransactionService _transactionService;
  final Ref _ref;

  TransactionNotifier(this._transactionService, this._ref) : super([]);

  Future<void> fetchTransactions(String monthNumber) async {
    final loadingState = _ref.read(loadingProvider.notifier);
    loadingState.startLoading();
    try {
      final APIResponse apiResponse =
          await _transactionService.fetchTransactions();

      if (apiResponse.success) {
        state = apiResponse.data;
        loadingState.setSucess();
      } else {
        loadingState.setError(apiResponse.error ?? "Something went wrong");
      }
    } catch (err) {
      loadingState.setError("Something went wrong");
    }
  }

  Future<String> addTransaction(Transaction transaction) async {
    final loadingState = _ref.read(loadingProvider.notifier);
    loadingState.startLoading();

    try {
      final APIResponse apiResponse = await _transactionService
          .createTransaction(transaction);
      if (apiResponse.success) {
        loadingState.setSucess();
        transaction.id = apiResponse.data.id;
        state = [transaction, ...state];
        return apiResponse.data.message;
      } else {
        loadingState.setError(apiResponse.error ?? "Something went wrong");
        return apiResponse.error ?? "Something went wrong";
      }
    } catch (err) {
      loadingState.setError("Something went wrong");
      return "Something went wrong";
    }
  }
}

final transactionProvider =
    StateNotifierProvider<TransactionNotifier, List<Transaction>>((ref) {
      final authState = ref.watch(authProvider);
      final token = (authState as Authenticated).accessToken;
      return TransactionNotifier(
        TransactionService(token: token, ref: ref),
        ref,
      );
    });
