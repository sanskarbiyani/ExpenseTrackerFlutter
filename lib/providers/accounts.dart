import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:message_expense_tracker/models/account.dart';
import 'package:message_expense_tracker/models/base_response.dart';
import 'package:message_expense_tracker/services/account_service.dart';

import 'loading_state.dart';

class AccountListNotifier extends StateNotifier<List<Account>> {
  final Ref _ref;
  final AccountService _accountService;

  AccountListNotifier(this._ref, this._accountService) : super([]);

  Future<void> fetchAccounts() async {
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
}

final accountsProvider =
    StateNotifierProvider.family<AccountListNotifier, List<Account>, String>(
      (ref, token) => AccountListNotifier(ref, AccountService(token)),
    );
