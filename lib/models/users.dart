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
  final int id;
  final String username;
  final String email;
  final double credit;
  final double debit;
  final double balance;

  const LoggedInUser({
    required this.id,
    required this.username,
    required this.email,
    required this.credit,
    required this.debit,
    required this.balance,
  });

  factory LoggedInUser.fromJson(Map<String, dynamic> json) {
    final credit = (json['credit'] as num).toDouble();
    final debit = (json['debit'] as num).toDouble();
    return LoggedInUser(
      id: json['id'],
      username: json['username'],
      email: json['email'],
      debit: debit,
      credit: credit,
      balance: credit - debit,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'debit': debit,
      'credit': credit,
    };
  }
}
