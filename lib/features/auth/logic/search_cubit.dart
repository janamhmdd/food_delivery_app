import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../domain/repositories/restaurant_repository.dart';
import 'search_state.dart';

/// Hits the real `ItemName` filter on GET /api/Restaurant/items, debounced
/// so it doesn't fire a request on every keystroke.
class SearchCubit extends Cubit<SearchState> {
  final RestaurantRepository _repository;
  Timer? _debounce;

  SearchCubit(this._repository) : super(const SearchState());

  void onQueryChanged(String query) {
    _debounce?.cancel();
    emit(state.copyWith(query: query));

    if (query.trim().isEmpty) {
      emit(state.copyWith(status: SearchStatus.idle, results: []));
      return;
    }

    _debounce = Timer(const Duration(milliseconds: 400), () => _search(query.trim()));
  }

  Future<void> _search(String query) async {
    // The query could have changed again while we were waiting — bail out
    // if this call is stale.
    if (query != state.query.trim()) return;

    emit(state.copyWith(status: SearchStatus.loading));
    final result = await _repository.getAllItems(itemName: query);

    if (query != state.query.trim()) return; // stale response, ignore

    if (result.isSuccess && result.data != null) {
      emit(state.copyWith(status: SearchStatus.success, results: result.data!));
    } else {
      emit(state.copyWith(
        status: SearchStatus.error,
        errorMessage: result.errorMessage ?? 'Search failed',
      ));
    }
  }

  @override
  Future<void> close() {
    _debounce?.cancel();
    return super.close();
  }
}