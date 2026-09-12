
class OrderLineItem {
  final String itemName;
  final int quantity;

  const OrderLineItem({required this.itemName, required this.quantity});

  Map<String, dynamic> toJson() => {
        'itemName': itemName,
        'quantity': quantity,
      };

factory OrderLineItem.fromJson(Map<String, dynamic> json) => OrderLineItem(
      itemName: json['itemName'] as String? ?? '',
      quantity: json['quantity'] as int? ?? 1,
    );
}

