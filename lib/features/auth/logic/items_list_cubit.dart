import 'package:flutter_bloc/flutter_bloc.dart';
import '../domain/repositories/restaurant_repository.dart';
import 'items_list_state.dart';

class ItemsListCubit extends Cubit<ItemsListState> {
  final RestaurantRepository _repository;

  ItemsListCubit(this._repository) : super(const ItemsListState());

  Future<void> fetch() async {
    emit(state.copyWith(status: ItemsListStatus.loading));
    final result = await _repository.getAllItems();
    if (result.isSuccess && result.data != null) {
      emit(state.copyWith(status: ItemsListStatus.success, items: result.data!));
    } else {
      emit(state.copyWith(
        status: ItemsListStatus.error,
        errorMessage: result.errorMessage ?? 'Failed to load items',
      ));
    }
  }
}