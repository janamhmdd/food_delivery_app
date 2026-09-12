import 'package:flutter_bloc/flutter_bloc.dart';
import '../domain/entities/menu_item.dart';
import 'generic_add_ons.dart';
import 'item_details_state.dart';

class ItemDetailsCubit extends Cubit<ItemDetailsState> {
  final MenuItem item;

  ItemDetailsCubit(this.item) : super(const ItemDetailsState());

  void incrementQuantity() => emit(state.copyWith(quantity: state.quantity + 1));

  void decrementQuantity() {
    if (state.quantity <= 1) return;
    emit(state.copyWith(quantity: state.quantity - 1));
  }

  void toggleAddOn(String addOnName) {
    final updated = Set<String>.from(state.selectedAddOns);
    if (updated.contains(addOnName)) {
      updated.remove(addOnName);
    } else {
      updated.add(addOnName);
    }
    emit(state.copyWith(selectedAddOns: updated));
  }

  /// Sum of the base item price and selected add-ons, times quantity.
  /// Add-ons are cosmetic (see generic_add_ons.dart) — not sent to the API.
  double get displayTotal {
    final addOnTotal = kGenericAddOns.where((a) => state.selectedAddOns.contains(a.name)).fold(0.0, (sum, a) => sum + a.price);
    return (item.itemPrice + addOnTotal) * state.quantity;
  }
}