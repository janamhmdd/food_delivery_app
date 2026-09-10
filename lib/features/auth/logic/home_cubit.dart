import 'package:flutter_bloc/flutter_bloc.dart';
import '../domain/repositories/restaurant_repository.dart';
import 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final RestaurantRepository _repository;

  HomeCubit(this._repository) : super(const HomeState());

  Future<void> fetchHomeData() async {
    emit(state.copyWith(status: HomeStatus.loading));

    final result = await _repository.getAllItems();

    if (result.isSuccess && result.data != null) {
      final items = List.of(result.data!);

      
      final sortedByPrice = List.of(items)
        ..sort((a, b) => b.itemPrice.compareTo(a.itemPrice));
      final bestSellers = sortedByPrice.take(4).toList();

      final bestSellerIds = bestSellers.map((i) => i.itemId).toSet();
      final recommended = items
          .where((i) => !bestSellerIds.contains(i.itemId))
          .take(2)
          .toList();

      emit(state.copyWith(
        status: HomeStatus.success,
        bestSellers: bestSellers,
        recommended: recommended,
      ));
    } else {
      emit(state.copyWith(
        status: HomeStatus.error,
        errorMessage: result.errorMessage ?? 'Failed to load home data',
      ));
    }
  }

  void selectCategory(String category) {
    emit(state.copyWith(selectedCategory: category));
  }
}