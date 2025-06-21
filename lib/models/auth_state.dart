// My Library imports

sealed class AuthState {
  const AuthState();
}

class Authenticated extends AuthState {
  final String accessToken;
  final String tokenType;

  const Authenticated({required this.accessToken, required this.tokenType});
}

class UnAuthenticated extends AuthState {
  const UnAuthenticated();
}
