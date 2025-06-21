class RegisterRequest {
  final String username;
  final String email;
  final String password;

  const RegisterRequest({
    required this.username,
    required this.email,
    required this.password,
  });

  factory RegisterRequest.fromJson(Map<String, dynamic> json) {
    return RegisterRequest(
      username: json['username'],
      email: json['email'],
      password: json['password'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'username': username, 'email': email, 'password': password};
  }
}

class LoggedInUser {
  final String username;
  final String email;
  final String? firstName;
  final String? lastName;

  const LoggedInUser({
    required this.username,
    required this.email,
    this.firstName,
    this.lastName,
  });

  factory LoggedInUser.fromJson(Map<String, dynamic> json) {
    return LoggedInUser(
      username: json['username'],
      email: json['email'],
      firstName: json['first_name'] ?? "",
      lastName: json['last_name'] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
    };
  }
}
