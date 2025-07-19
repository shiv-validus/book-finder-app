
part of 'search_book_bloc.dart';

abstract class SearchBookState extends Equatable {
  const SearchBookState();

  @override
  List<Object?> get props => [];
}

class SearchBookInitial extends SearchBookState {}

class SearchBookLoading extends SearchBookState {}

class SearchBookLoaded extends SearchBookState {
  final List<Book> books;
  final bool hasMore;

  const SearchBookLoaded({required this.books, this.hasMore = false});

  @override
  List<Object?> get props => [books, hasMore];
}

class SearchBookLoadingMore extends SearchBookState {
  final List<Book> books;
  final bool hasMore;

  const SearchBookLoadingMore({required this.books, this.hasMore = false});

  @override
  List<Object?> get props => [books, hasMore];
}


class SearchBookEmpty extends SearchBookState {
  const SearchBookEmpty();
}

class SearchBookError extends SearchBookState {
  final String message;
  const SearchBookError(this.message);

  @override
  List<Object?> get props => [message];
}
