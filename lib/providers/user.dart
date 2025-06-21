import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:message_expense_tracker/models/user_state.dart';
import 'package:message_expense_tracker/models/users.dart';
import 'package:message_expense_tracker/providers/auth.dart';
import 'package:message_expense_tracker/providers/loading_state.dart';
import 'package:message_expense_tracker/services/user_service.dart';

class UserNotifier extends StateNotifier<UserState> {
  UserService _userService;
  Ref _ref;

  UserNotifier(this._userService, this._ref) : super(const UserInitial());

  void setUser(LoggedInUser user) {
    state = UserPresent(user);
  }

  Future<void> registerUser(RegisterRequest req) async {
    final loadingState = _ref.read(loadingProvider.notifier);
    final authState = _ref.read(authProvider.notifier);
    final userState = _ref.read(userProvider.notifier);

    loadingState.startLoading();
    try {
      final registerRequest = RegisterRequest(
        password: req.password,
        email: req.email,
        username: req.username,
      );
      final loginResponse = await _userService.registerUser(registerRequest);
      if (loginResponse != null) {
        loadingState.setSucess();
        authState.markAuthenticated(loginResponse);
        userState.setUser(loginResponse.user);
      } else {
        loadingState.setError("Something went wrong");
        authState.logout();
      }
    } catch (err) {
      loadingState.setError("Something went wrong");
      authState.logout();
    }
  }
}

final userProvider = StateNotifierProvider<UserNotifier, UserState>(
  (ref) => UserNotifier(UserService(), ref),
);
