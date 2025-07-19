part of 'search_book_bloc.dart';

abstract class SearchBookEvent extends Equatable {
  const SearchBookEvent();

  @override
  List<Object?> get props => [];
}

class SearchBookQueryChanged extends SearchBookEvent {
  final String query;
  final int page;

  const SearchBookQueryChanged(this.query, {this.page = 1});

  @override
  List<Object?> get props => [query, page];
}

class SearchBookLoadMore extends SearchBookEvent {
  const SearchBookLoadMore();

  @override
  List<Object?> get props => [];
}
