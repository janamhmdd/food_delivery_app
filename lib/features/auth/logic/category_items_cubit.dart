import 'package:flutter_bloc/flutter_bloc.dart';
import '../domain/repositories/restaurant_repository.dart';
import 'category_items_state.dart';

class CategoryItemsCubit extends Cubit<CategoryItemsState> {
  final RestaurantRepository _repository;

  CategoryItemsCubit(this._repository, String initialCategory)
      : super(CategoryItemsState(category: initialCategory));

  Future<void> fetch() async {
    emit(state.copyWith(status: CategoryItemsStatus.loading));
    final result = await _repository.getItemsByCategory(state.category);

    if (result.isSuccess && result.data != null) {
      emit(state.copyWith(status: CategoryItemsStatus.success, items: result.data!));
    } else {
      emit(state.copyWith(
        status: CategoryItemsStatus.error,
        errorMessage: result.errorMessage ?? 'Failed to load items',
      ));
    }
  }

  Future<void> switchCategory(String category) async {
    if (category == state.category) return;
    emit(state.copyWith(category: category, items: []));
    await fetch();
  }
}