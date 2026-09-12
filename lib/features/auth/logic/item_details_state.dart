import 'package:equatable/equatable.dart';

class ItemDetailsState extends Equatable {
  final int quantity;
  final Set<String> selectedAddOns;
  final String selectedPortion;

  const ItemDetailsState({
    this.quantity = 1,
    this.selectedAddOns = const {},
    this.selectedPortion = 'Personal (4 Slices)',
  });

  ItemDetailsState copyWith({
    int? quantity,
    Set<String>? selectedAddOns,
    String? selectedPortion,
  }) {
    return ItemDetailsState(
      quantity: quantity ?? this.quantity,
      selectedAddOns: selectedAddOns ?? this.selectedAddOns,
      selectedPortion: selectedPortion ?? this.selectedPortion,
    );
  }

  @override
  List<Object?> get props => [quantity, selectedAddOns, selectedPortion];
}