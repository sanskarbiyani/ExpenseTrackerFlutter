enum TransactionType {
  income(1),
  expense(2),
  transfer(3);

  final int value;

  const TransactionType(this.value);

  String get displayName {
    switch (this) {
      case TransactionType.expense:
        return 'Expense';
      case TransactionType.income:
        return 'Income';
      case TransactionType.transfer:
        return 'Transfer';
    }
  }

  static TransactionType? fromString(String? str) {
    if (str == null) return null;
    try {
      return TransactionType.values.firstWhere(
        (type) => type.displayName.toLowerCase() == str.toLowerCase(),
      );
    } catch (_) {
      return null;
    }
  }

  int get toInt => value;

  static TransactionType? fromInt(int? val) {
    if (val == null) return null;
    try {
      return TransactionType.values.firstWhere((type) => type.value == val);
    } catch (_) {
      return null;
    }
  }
}

class Transaction {
  final double amount;
  final String title;
  final String description;
  final TransactionType? transactionType;
  int? id;

  Transaction({
    required this.amount,
    required this.title,
    required this.description,
    required this.transactionType,
    this.id,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['id'] as int,
      amount: (json['amount'] as num).toDouble(),
      title: json['title'],
      description: json['description'],
      transactionType: TransactionType.fromInt(
        json['transaction_type'] as int?,
      ),
    );
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{
      'amount': amount,
      'title': title,
      'description': description,
      'transaction_type': transactionType?.toInt,
    };
    if (id != null) {
      map['id'] = id;
    }
    return map;
  }
}
