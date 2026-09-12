import 'order_line_item.dart';

enum OrderLocalStatus { active, completed, cancelled }

OrderLocalStatus _statusFromString(String value) {
  return OrderLocalStatus.values.firstWhere(
    (s) => s.name == value,
    orElse: () => OrderLocalStatus.active,
  );
}

class OrderRecord {
  final String id;
  final int restaurantId;
  final String title;
  final String imageUrl;
  final int itemCount;
  final double totalPrice;
  final DateTime placedAt;
  final OrderLocalStatus status;
  final List<OrderLineItem> lineItems;
  final String? cancelReason;

  const OrderRecord({
    required this.id,
    required this.restaurantId,
    required this.title,
    required this.imageUrl,
    required this.itemCount,
    required this.totalPrice,
    required this.placedAt,
    this.status = OrderLocalStatus.active,
    this.lineItems = const [],
    this.cancelReason,
  });

  OrderRecord copyWith({
    OrderLocalStatus? status,
    String? cancelReason,
  }) {
    return OrderRecord(
      id: id,
      restaurantId: restaurantId,
      title: title,
      imageUrl: imageUrl,
      itemCount: itemCount,
      totalPrice: totalPrice,
      placedAt: placedAt,
      status: status ?? this.status,
      lineItems: lineItems,
      cancelReason: cancelReason ?? this.cancelReason,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'restaurantId': restaurantId,
        'title': title,
        'imageUrl': imageUrl,
        'itemCount': itemCount,
        'totalPrice': totalPrice,
        'placedAt': placedAt.toIso8601String(),
        'status': status.name,
        'lineItems': lineItems.map((i) => i.toJson()).toList(),
        'cancelReason': cancelReason,
      };

  factory OrderRecord.fromJson(Map<String, dynamic> json) {
    return OrderRecord(
      id: json['id'] as String,
      restaurantId: json['restaurantId'] as int? ?? 0,
      title: json['title'] as String? ?? '',
      imageUrl: json['imageUrl'] as String? ?? '',
      itemCount: json['itemCount'] as int? ?? 1,
      totalPrice: (json['totalPrice'] as num?)?.toDouble() ?? 0.0,
      placedAt: DateTime.tryParse(json['placedAt'] as String? ?? '') ?? DateTime.now(),
      status: _statusFromString(json['status'] as String? ?? 'active'),
      lineItems: (json['lineItems'] as List<dynamic>? ?? [])
          .map((e) => OrderLineItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      cancelReason: json['cancelReason'] as String?,
    );
  }
}