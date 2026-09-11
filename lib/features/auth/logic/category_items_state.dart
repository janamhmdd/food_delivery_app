import 'package:equatable/equatable.dart';
import '../domain/entities/menu_item.dart';

enum CategoryItemsStatus { loading, success, error }

class CategoryItemsState extends Equatable {
  final String category;
  final CategoryItemsStatus status;
  final List<MenuItem> items;
  final String? errorMessage;

  const CategoryItemsState({
    required this.category,
    this.status = CategoryItemsStatus.loading,
    this.items = const [],
    this.errorMessage,
  });

  CategoryItemsState copyWith({
    String? category,
    CategoryItemsStatus? status,
    List<MenuItem>? items,
    String? errorMessage,
  }) {
    return CategoryItemsState(
      category: category ?? this.category,
      status: status ?? this.status,
      items: items ?? this.items,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [category, status, items, errorMessage];
}