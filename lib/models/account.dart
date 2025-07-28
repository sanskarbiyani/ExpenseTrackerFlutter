class Account {
  final String name;
  final String description;
  double balance;
  int? id;

  Account({
    required this.name,
    required this.description,
    required this.balance,
    this.id,
  });

  factory Account.fromJson(Map<String, dynamic> json) {
    return Account(
      name: json['name'],
      description: json['description'],
      balance: json['balance'],
      id: json['id'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{
      'name': name,
      'description': description,
      'balance': balance,
    };
    if (id != null) {
      map['id'] = id;
    }
    return map;
  }
}
