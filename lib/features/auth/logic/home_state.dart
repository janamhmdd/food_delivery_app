import 'package:equatable/equatable.dart';
import '../domain/entities/menu_item.dart';

enum HomeStatus { initial, loading, success, error }

class HomeState extends Equatable {
  final HomeStatus status;
  final List<MenuItem> bestSellers;
  final List<MenuItem> recommended;
  final String selectedCategory; // cosmetic chip selection, see HomeCubit.selectCategory
  final String? errorMessage;

  const HomeState({
    this.status = HomeStatus.initial,
    this.bestSellers = const [],
    this.recommended = const [],
    this.selectedCategory = 'Snacks',
    this.errorMessage,
  });

  HomeState copyWith({
    HomeStatus? status,
    List<MenuItem>? bestSellers,
    List<MenuItem>? recommended,
    String? selectedCategory,
    String? errorMessage,
  }) {
    return HomeState(
      status: status ?? this.status,
      bestSellers: bestSellers ?? this.bestSellers,
      recommended: recommended ?? this.recommended,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, bestSellers, recommended, selectedCategory, errorMessage];
}