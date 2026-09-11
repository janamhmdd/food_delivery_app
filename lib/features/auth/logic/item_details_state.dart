import 'package:equatable/equatable.dart';

enum OrderStatus { idle, placing, success, error }

class ItemDetailsState extends Equatable {
  final int quantity;
  final Set<String> selectedAddOns;
  final OrderStatus orderStatus;
  final String? errorMessage;

  const ItemDetailsState({
    this.quantity = 1,
    this.selectedAddOns = const {},
    this.orderStatus = OrderStatus.idle,
    this.errorMessage,
  });

  ItemDetailsState copyWith({
    int? quantity,
    Set<String>? selectedAddOns,
    OrderStatus? orderStatus,
    String? errorMessage,
  }) {
    return ItemDetailsState(
      quantity: quantity ?? this.quantity,
      selectedAddOns: selectedAddOns ?? this.selectedAddOns,
      orderStatus: orderStatus ?? this.orderStatus,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [quantity, selectedAddOns, orderStatus, errorMessage];
}