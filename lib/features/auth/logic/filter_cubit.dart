import 'package:flutter_bloc/flutter_bloc.dart';
import 'filter_state.dart';

class RestaurantFilter {
  final String topCategory;
  final Set<String> subCategories;
  final int ratingFilter;
  final double priceStop;

  const RestaurantFilter({
    required this.topCategory,
    required this.subCategories,
    required this.ratingFilter,
    required this.priceStop,
  });

  String get apiCategoryParam => topCategory;

    bool matchesType(String type) {
    if (subCategories.isEmpty) return true;
    final lower = type.toLowerCase();
    return subCategories.any((s) => lower.contains(s.toLowerCase()));
  }
}

class FilterCubit extends Cubit<FilterState> {
  FilterCubit() : super(const FilterState());

  void selectTopCategory(String category) {
    
     emit(state.copyWith(topCategory: category, selectedSubCategories: {}));
  }

  void toggleSubCategory(String subCategory) {
    final updated = Set<String>.from(state.selectedSubCategories);
    if (updated.contains(subCategory)) {
      updated.remove(subCategory);
    } else {
      updated.add(subCategory);
    }
    emit(state.copyWith(selectedSubCategories: updated));
  }

  void setRating(int rating) {
   
    emit(state.copyWith(ratingFilter: state.ratingFilter == rating ? 0 : rating));
  }

  void setPriceStop(double stop) {
    emit(state.copyWith(priceStop: stop));
  }

  RestaurantFilter buildFilter() {
    return RestaurantFilter(
      topCategory: state.topCategory,
      subCategories: state.selectedSubCategories,
      ratingFilter: state.ratingFilter,
      priceStop: state.priceStop,
    );
  }
}