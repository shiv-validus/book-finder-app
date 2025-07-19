// lib/features/book_finder/domain/repositories/book_repository.dart

import '../entities/book.dart';

abstract class BookRepository {
  Future<List<Book>> searchBooks(String query, {required int page});
}
