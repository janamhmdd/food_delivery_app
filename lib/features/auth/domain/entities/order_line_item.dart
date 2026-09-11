
class OrderLineItem {
  final String itemName;
  final int quantity;

  const OrderLineItem({required this.itemName, required this.quantity});

  Map<String, dynamic> toJson() => {
        'itemName': itemName,
        'quantity': quantity,
      };
}