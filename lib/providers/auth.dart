import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:message_expense_tracker/models/auth_state.dart';
import 'package:message_expense_tracker/models/login.dart';
import 'package:message_expense_tracker/providers/loading_state.dart';
import 'package:message_expense_tracker/providers/user.dart';
import 'package:message_expense_tracker/services/auth_service.dart';

class AuthNotifier extends StateNotifier<AuthState> {
  final AuthService _authService;
  final Ref _ref;
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  AuthNotifier(this._authService, this._ref) : super(const UnAuthenticated());

  Future<bool> login({
    required String username,
    required String password,
  }) async {
    final loadingNotifier = _ref.read(loadingProvider.notifier);
    final userNotifier = _ref.read(userProvider.notifier);
    loadingNotifier.startLoading();
    try {
      final loginRequest = LoginRequest(username: username, password: password);
      final apiResponse = await _authService.login(loginRequest);

      if (apiResponse != null && apiResponse.success) {
        loadingNotifier.setSucess();
        final tokenResponse = apiResponse.data;
        state = Authenticated(
          accessToken: tokenResponse.accessToken,
          tokenType: tokenResponse.tokenType,
        );
        userNotifier.setUser(apiResponse.data.user);
        await _storage.write(
          key: 'authDetails',
          value: jsonEncode(apiResponse.data.toJson()),
        );
        return true;
      } else {
        loadingNotifier.setError(apiResponse?.error ?? "Something went wrong");
        state = const UnAuthenticated();
        return false;
      }
    } catch (e) {
      loadingNotifier.setError("Something went wrong");
      state = const UnAuthenticated();
      return false;
    }
  }

  Future<void> logout() async {
    state = UnAuthenticated();
  }

  void markAuthenticated(LoginResponse response) {
    state = Authenticated(
      accessToken: response.accessToken,
      tokenType: response.tokenType,
    );
  }

  Future<void> tryAutoLogin() async {
    final loadingStateProvider = _ref.read(loadingProvider.notifier);
    final userNotifier = _ref.read(userProvider.notifier);
    loadingStateProvider.startLoading();

    final authDetails = await _storage.read(key: 'authDetails');

    if (authDetails != null) {
      final LoginResponse userDetails = LoginResponse.fromJson(
        jsonDecode(authDetails),
      );
      state = Authenticated(
        accessToken: userDetails.accessToken,
        tokenType: userDetails.tokenType,
      );
      userNotifier.setUser(userDetails.user);
    }
    loadingStateProvider.setSucess();
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>(
  (ref) => AuthNotifier(AuthService(), ref),
);
