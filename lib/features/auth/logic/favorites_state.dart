import 'package:equatable/equatable.dart';
import '../domain/entities/menu_item.dart';

enum FavoritesStatus { loading, success, error }

class FavoritesState extends Equatable {
  final FavoritesStatus status;
  final Set<int> favoriteIds;
  final List<MenuItem> favoriteItems;
  final String? errorMessage;

  const FavoritesState({
    this.status = FavoritesStatus.loading,
    this.favoriteIds = const {},
    this.favoriteItems = const [],
    this.errorMessage,
  });

  bool isFavorite(int itemId) => favoriteIds.contains(itemId);

  FavoritesState copyWith({
    FavoritesStatus? status,
    Set<int>? favoriteIds,
    List<MenuItem>? favoriteItems,
    String? errorMessage,
  }) {
    return FavoritesState(
      status: status ?? this.status,
      favoriteIds: favoriteIds ?? this.favoriteIds,
      favoriteItems: favoriteItems ?? this.favoriteItems,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, favoriteIds, favoriteItems, errorMessage];
}