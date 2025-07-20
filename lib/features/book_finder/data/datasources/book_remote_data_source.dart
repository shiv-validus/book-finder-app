
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../models/book_model.dart';

abstract class BookRemoteDataSource {
  Future<List<BookModel>> searchBooks(String query, {required int page});
}

class BookRemoteDataSourceImpl implements BookRemoteDataSource {
  final Dio dio;

  BookRemoteDataSourceImpl({required this.dio});

  @override
  Future<List<BookModel>> searchBooks(String query, {required int page}) async {
    try {
      debugPrint('🌍 Fetching books from API for: $query at page $page');

      final response = await dio.get(
        'https://openlibrary.org/search.json',
        queryParameters: {
          'q': query,
          'page': page,
          'limit': 15,
        },
      );

      final docs = response.data['docs'] as List<dynamic>?;

      if (docs == null || docs.isEmpty) {
        debugPrint('📭 No books found for query "$query"');
        return [];
      }

      debugPrint('📚 Total books received: ${docs.length}');
      debugPrint('🧪 Sample first book: ${docs.first}');

      return docs.map((doc) => BookModel.fromJson(doc)).toList();
    } catch (e, stackTrace) {
      debugPrint('❌ API Error: $e');
      debugPrint(stackTrace.toString());
      rethrow;
    }
  }
}
