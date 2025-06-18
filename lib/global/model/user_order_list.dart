class Category {
  final String name;
  final double amount;

  Category({required this.name, required this.amount});

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      name: json['name'] as String,
      amount: (json['amount'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'amount': amount,
    };
  }
}

class Order {
  final int receiptId;
  final String shopName;
  final double totalAmount;
  final DateTime createdAt;
  final List<Category> categories;
  final String image;

  Order({
    required this.receiptId,
    required this.shopName,
    required this.totalAmount,
    required this.createdAt,
    required this.categories,
    required this.image,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      receiptId: json['receipt_id'] as int,
      shopName: json['shop_name'] as String,
      totalAmount: (json['total_amount'] as num).toDouble(),
      createdAt:
          DateTime.parse(json['created_at'].toString().replaceFirst(' ', 'T')),
      categories: (json['categories'] as List)
          .map((e) => Category.fromJson(e as Map<String, dynamic>))
          .toList(),
      image: json['image'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'receipt_id': receiptId,
      'shop_name': shopName,
      'total_amount': totalAmount,
      'created_at': createdAt.toIso8601String(),
      'categories': categories.map((c) => c.toJson()).toList(),
      'image': image,
    };
  }
}

class UserOrderListResponse {
  final List<Order> orders;
  final int page;
  final int size;
  final int totalPages;
  final int totalElements;

  UserOrderListResponse({
    required this.orders,
    required this.page,
    required this.size,
    required this.totalPages,
    required this.totalElements,
  });

  factory UserOrderListResponse.fromJson(Map<String, dynamic> json) {
    return UserOrderListResponse(
      orders: (json['orders'] as List)
          .map((e) => Order.fromJson(e as Map<String, dynamic>))
          .toList(),
      page: json['page'] as int,
      size: json['size'] as int,
      totalPages: json['total_pages'] as int,
      totalElements: json['total_elements'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'orders': orders.map((o) => o.toJson()).toList(),
      'page': page,
      'size': size,
      'total_pages': totalPages,
      'total_elements': totalElements,
    };
  }
}
