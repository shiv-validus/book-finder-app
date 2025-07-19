import '../../domain/entities/book.dart';
import '../../domain/repositories/book_repository.dart';
import '../datasources/book_remote_data_source.dart';

class BookRepositoryImpl implements BookRepository {
  final BookRemoteDataSource remoteDataSource;

  BookRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<Book>> searchBooks(String query, {int page = 1}) async {
    final models = await remoteDataSource.searchBooks(query, page: page);
    return models.map((model) => model.toEntity()).toList();
  }
}
