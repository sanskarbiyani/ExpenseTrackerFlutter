class Account {
  final String name;
  final String description;
  final double balance;
  final int id;

  Account({
    required this.name,
    required this.description,
    required this.balance,
    required this.id,
  });

  factory Account.fromJson(Map<String, dynamic> json) {
    return Account(
      name: json['name'],
      description: json['description'],
      balance: json['balance'],
      id: json['id'],
    );
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{
      'name': name,
      'description': description,
      'balance': balance,
      'id': id,
    };
    return map;
  }
}
