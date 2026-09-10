import 'package:equatable/equatable.dart';

class FilterState extends Equatable {
  final String topCategory; 
  final Set<String> selectedSubCategories;
  final int ratingFilter; 
  final double priceStop; 

  const FilterState({
    this.topCategory = 'Snacks',
    this.selectedSubCategories = const {},
    this.ratingFilter = 0,
    this.priceStop = 1.0,
  });

  FilterState copyWith({
    String? topCategory,
    Set<String>? selectedSubCategories,
    int? ratingFilter,
    double? priceStop,
  }) {
    return FilterState(
      topCategory: topCategory ?? this.topCategory,
      selectedSubCategories: selectedSubCategories ?? this.selectedSubCategories,
      ratingFilter: ratingFilter ?? this.ratingFilter,
      priceStop: priceStop ?? this.priceStop,
    );
  }

  @override
  List<Object?> get props => [topCategory, selectedSubCategories, ratingFilter, priceStop];
}