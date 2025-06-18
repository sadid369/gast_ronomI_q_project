class ReceiptItem {
  final String date;
  final String product;
  final String category;
  final double amount;
  final String status;

  ReceiptItem({
    required this.date,
    required this.product,
    required this.category,
    required this.amount,
    this.status = "Processed",
  });

  // no longer used; we'll construct from receipt + item JSON
  factory ReceiptItem.fromJson(Map<String, dynamic> json, String date) {
    return ReceiptItem(
      date: date,
      product: json['item_name'] ?? '',
      category: json['category'] ?? '',
      amount: (json['price'] ?? 0.0).toDouble(),
    );
  }
}
