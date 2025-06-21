import 'package:message_expense_tracker/models/users.dart';

class LoginRequest {
  final String username;
  final String email = "";
  final String password;

  const LoginRequest({required this.username, required this.password});

  Map<String, dynamic> toJson() {
    return {'username': username, 'password': password, 'email': email};
  }
}

class LoginResponse {
  final String accessToken;
  final String tokenType;
  final LoggedInUser user;

  const LoginResponse({
    required this.accessToken,
    required this.tokenType,
    required this.user,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      accessToken: json['access_token'],
      tokenType: json['token_type'],
      user: LoggedInUser.fromJson(json['user']),
    );
  }
}
