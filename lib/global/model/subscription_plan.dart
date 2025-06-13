class SubscriptionPlan {
  final int id;
  final String name;
  final String planId;
  final int durationDays;
  final String price;

  SubscriptionPlan({
    required this.id,
    required this.name,
    required this.planId,
    required this.durationDays,
    required this.price,
  });

  factory SubscriptionPlan.fromJson(Map<String, dynamic> json) {
    return SubscriptionPlan(
      id: json['id'],
      name: json['name'],
      planId: json['plan_id'],
      durationDays: json['duration_days'],
      price: json['price'],
    );
  }
}
