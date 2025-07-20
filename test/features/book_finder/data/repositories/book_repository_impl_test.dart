import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'package:book_finder_app/features/book_finder/data/datasources/book_remote_data_source.dart';
import 'package:book_finder_app/features/book_finder/data/repositories/book_repository_impl.dart';
import 'package:book_finder_app/features/book_finder/data/models/book_model.dart';
import 'package:book_finder_app/features/book_finder/domain/entities/book.dart';

import 'book_repository_impl_test.mocks.dart';

@GenerateMocks([BookRemoteDataSource])
void main() {
  late BookRepositoryImpl repository;
  late MockBookRemoteDataSource mockDataSource;

  setUp(() {
    mockDataSource = MockBookRemoteDataSource();
    repository = BookRepositoryImpl(remoteDataSource: mockDataSource);
  });

  test('✅ should return list of Book when data source returns data', () async {
    // arrange
    const query = 'flutter';
    const page = 1;

    final bookModels = [
      BookModel(title: 'Flutter Basics', authorName: ['Author A'], coverI: 123),
    ];

    final expectedBooks = [
      Book(title: 'Flutter Basics', authorName: ['Author A'], coverId: 123),
    ];

    when(mockDataSource.searchBooks(query, page: page)).thenAnswer((_) async => bookModels);

    // act
    final result = await repository.searchBooks(query, page: page);

    // assert
    expect(result, expectedBooks);
    verify(mockDataSource.searchBooks(query, page: page)).called(1);
    verifyNoMoreInteractions(mockDataSource);
  });
}
