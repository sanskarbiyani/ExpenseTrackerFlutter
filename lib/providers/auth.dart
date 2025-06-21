import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:message_expense_tracker/models/auth_state.dart';
import 'package:message_expense_tracker/models/login.dart';
import 'package:message_expense_tracker/providers/loading_state.dart';
import 'package:message_expense_tracker/services/auth_service.dart';

class AuthNotifier extends StateNotifier<AuthState> {
  final AuthService _authService;
  final Ref _ref;

  AuthNotifier(this._authService, this._ref) : super(const UnAuthenticated());

  Future<void> login({
    required String username,
    required String password,
  }) async {
    final loadingNotifier = _ref.read(loadingProvider.notifier);
    // final userNotifier = _ref.read(userProvider.notifier);
    loadingNotifier.startLoading();
    try {
      final loginRequest = LoginRequest(username: username, password: password);
      final tokenResponse = await _authService.login(loginRequest);

      if (tokenResponse != null) {
        loadingNotifier.setSucess();
        state = Authenticated(
          accessToken: tokenResponse.accessToken,
          tokenType: tokenResponse.tokenType,
        );
      } else {
        loadingNotifier.setError("Something went wrong");
        state = const UnAuthenticated();
      }
    } catch (e) {
      loadingNotifier.setError("Something went wrong");
      state = const UnAuthenticated();
    }
  }

  Future<void> logout() async {
    state = const UnAuthenticated();
  }

  void markAuthenticated(LoginResponse response) {
    state = Authenticated(
      accessToken: response.accessToken,
      tokenType: response.tokenType,
    );
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>(
  (ref) => AuthNotifier(AuthService(), ref),
);
