import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';

import 'features/book_finder/presentation/bloc/search_book_bloc.dart';
import 'features/book_finder/presentation/pages/search_screen.dart';
import 'features/book_finder/domain/usecases/search_books.dart';
import 'features/book_finder/data/repositories/book_repository_impl.dart';
import 'features/book_finder/data/datasources/book_remote_data_source.dart';

void main() {
  runApp(const BookFinderApp());
}

class BookFinderApp extends StatelessWidget {
  const BookFinderApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Book Finder',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: BlocProvider(
        create: (_) => SearchBookBloc(
          searchBooks: SearchBooks(
            BookRepositoryImpl(
              remoteDataSource: BookRemoteDataSourceImpl(dio: Dio()),
            ),
          ),
        ),
        child: const SearchScreen(),
      ),
    );
  }
}
