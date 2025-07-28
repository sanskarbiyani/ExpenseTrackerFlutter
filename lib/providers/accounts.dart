import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:message_expense_tracker/models/account.dart';
import 'package:message_expense_tracker/models/base_response.dart';
import 'package:message_expense_tracker/models/transaction.dart';
import 'package:message_expense_tracker/services/account_service.dart';

import 'loading_state.dart';

class AccountListNotifier extends StateNotifier<List<Account>> {
  final Ref _ref;
  final AccountService _accountService;

  AccountListNotifier(this._ref, this._accountService) : super([]);

  Future<void> fetchAccounts() async {
    if (state.isNotEmpty) return;
    final loadingState = _ref.read(loadingProvider.notifier);
    loadingState.startLoading();

    try {
      final APIResponse apiResponse = await _accountService.fetchAccounts();
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

  Future<bool> addAccount(Account acc) async {
    final loadingState = _ref.read(loadingProvider.notifier);
    loadingState.startLoading();

    try {
      final apiResponse = await _accountService.addAccount(acc);
      if (apiResponse.success) {
        state = [apiResponse.data!, ...state];
        loadingState.setSucess();
        return true;
      } else {
        loadingState.setError(apiResponse.error ?? "Something went wrong");
        return false;
      }
    } catch (err) {
      loadingState.setError("Something went wrong");
      return false;
    }
  }

  Future<void> updateAccount(Transaction transaction) async {
    // Finding the account
    Account account = state.firstWhere(
      (acc) => acc.id == transaction.accountId,
      orElse: () => Account(name: '', description: '', balance: 0),
    );
    if (account.name.isEmpty && account.description.isEmpty) return;

    // Updating the account
    if (transaction.transactionType == TransactionType.income) {
      account.balance += transaction.amount;
    } else if (transaction.transactionType == TransactionType.expense) {
      account.balance -= transaction.amount;
    }
  }
}

final accountsProvider =
    StateNotifierProvider.family<AccountListNotifier, List<Account>, String>(
      (ref, token) => AccountListNotifier(ref, AccountService(token)),
    );
