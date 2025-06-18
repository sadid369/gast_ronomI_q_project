class TransactionHistory {
  final double totalSpending;
  final List<Transaction> transactions;

  TransactionHistory({
    required this.totalSpending,
    required this.transactions,
  });

  factory TransactionHistory.fromJson(Map<String, dynamic> json) {
    return TransactionHistory(
      totalSpending: (json['total_spending'] as num).toDouble(),
      transactions: (json['transactions'] as List)
          .map((e) => Transaction.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        'total_spending': totalSpending,
        'transactions': transactions.map((t) => t.toJson()).toList(),
      };
}

class Transaction {
  final DateTime date;
  final double total;
  final List<Item> items;

  Transaction({
    required this.date,
    required this.total,
    required this.items,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      date: DateTime.parse(json['date'] as String),
      total: (json['total'] as num).toDouble(),
      items: (json['items'] as List)
          .map((e) => Item.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        'date': date.toIso8601String().split('T').first,
        'total': total,
        'items': items.map((i) => i.toJson()).toList(),
      };
}

class Item {
  final String name;
  final double amount;

  Item({
    required this.name,
    required this.amount,
  });

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      name: json['name'] as String,
      amount: (json['amount'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'amount': amount,
      };
}
