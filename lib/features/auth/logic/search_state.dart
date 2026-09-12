import 'package:equatable/equatable.dart';
import '../domain/entities/menu_item.dart';

enum SearchStatus { idle, loading, success, error }

class SearchState extends Equatable {
  final String query;
  final SearchStatus status;
  final List<MenuItem> results;
  final String? errorMessage;

  const SearchState({
    this.query = '',
    this.status = SearchStatus.idle,
    this.results = const [],
    this.errorMessage,
  });

  SearchState copyWith({
    String? query,
    SearchStatus? status,
    List<MenuItem>? results,
    String? errorMessage,
  }) {
    return SearchState(
      query: query ?? this.query,
      status: status ?? this.status,
      results: results ?? this.results,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [query, status, results, errorMessage];
}