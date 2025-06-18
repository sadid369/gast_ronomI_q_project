import 'recent_item.dart';

class RecentOrder {
  final int receiptId;
  final String shopName, createdAt;
  final double totalAmount;
  final List<RecentItem> items;
  RecentOrder({
    required this.receiptId,
    required this.shopName,
    required this.createdAt,
    required this.totalAmount,
    required this.items,
  });
  factory RecentOrder.fromJson(Map<String, dynamic> j) => RecentOrder(
        receiptId: j['receipt_id'],
        shopName: j['shop_name'],
        createdAt: j['created_at'],
        totalAmount: (j['total_amount'] as num).toDouble(),
        items: (j['items'] as List).map((e) => RecentItem.fromJson(e)).toList(),
      );
}
