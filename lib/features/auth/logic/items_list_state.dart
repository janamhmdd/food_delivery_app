import 'package:equatable/equatable.dart';
import '../domain/entities/menu_item.dart';

enum ItemsListStatus { loading, success, error }

class ItemsListState extends Equatable {
  final ItemsListStatus status;
  final List<MenuItem> items;
  final String? errorMessage;

  const ItemsListState({
    this.status = ItemsListStatus.loading,
    this.items = const [],
    this.errorMessage,
  });

  ItemsListState copyWith({
    ItemsListStatus? status,
    List<MenuItem>? items,
    String? errorMessage,
  }) {
    return ItemsListState(
      status: status ?? this.status,
      items: items ?? this.items,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, items, errorMessage];
}