import 'package:book_finder_app/features/book_finder/domain/entities/book.dart';
import 'package:book_finder_app/features/book_finder/domain/repositories/book_repository.dart';

class SearchBooks {
  final BookRepository repository;

  SearchBooks(this.repository);

  Future<List<Book>> call(String query, {int page = 1}) {
    return repository.searchBooks(query, page: page);
  }
}
