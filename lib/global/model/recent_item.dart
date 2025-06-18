class RecentItem {
  final String itemName, category, categoryImage;
  final double price;
  RecentItem({
    required this.itemName,
    required this.category,
    required this.price,
    required this.categoryImage,
  });
  factory RecentItem.fromJson(Map<String, dynamic> j) => RecentItem(
        itemName: j['item_name'],
        category: j['category'],
        price: (j['price'] as num).toDouble(),
        categoryImage: j['category_image'],
      );
}
