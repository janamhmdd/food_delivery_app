import 'package:equatable/equatable.dart';

class ItemDetailsState extends Equatable {
  final int quantity;
  final Set<String> selectedAddOns;

  const ItemDetailsState({
    this.quantity = 1,
    this.selectedAddOns = const {},
  });

  ItemDetailsState copyWith({
    int? quantity,
    Set<String>? selectedAddOns,
  }) {
    return ItemDetailsState(
      quantity: quantity ?? this.quantity,
      selectedAddOns: selectedAddOns ?? this.selectedAddOns,
    );
  }

  @override
  List<Object?> get props => [quantity, selectedAddOns];
}