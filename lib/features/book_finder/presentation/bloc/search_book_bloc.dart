import 'dart:async';
import 'dart:convert';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/entities/book.dart';
import '../../domain/usecases/search_books.dart';
import 'package:flutter/foundation.dart';

part 'search_book_event.dart';
part 'search_book_state.dart';


class SearchBookBloc extends Bloc<SearchBookEvent, SearchBookState> {
  final SearchBooks searchBooks;

  static const int _pageSize = 15;
  Completer<void>? _ongoingSearch;
  String _currentQuery = '';
  int _currentPage = 1;
  bool _hasMore = true;
  List<Book> _allBooks = [];

  SearchBookBloc({required this.searchBooks}) : super(SearchBookInitial()) {
    on<SearchBookQueryChanged>(
      _onSearchChanged,
      transformer: debounce(const Duration(milliseconds: 400)),
    );
    on<SearchBookLoadMore>(_onLoadMore);
  }

  EventTransformer<SearchBookQueryChanged> debounce(Duration duration) {
    return (events, mapper) => events
        .debounceTime(duration)
        .distinct((prev, next) => prev.query.trim() == next.query.trim())
        .asyncExpand(mapper);
  }

  Future<List<Book>?> _getFromLocalCache(String key) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(key);
    if (raw == null) return null;

    try {
      final List<dynamic> jsonList = List<dynamic>.from(jsonDecode(raw));
      return jsonList
          .map(
            (e) => Book(
              title: e['title'],
              authorName: List<String>.from(e['authorName']),
              coverId: e['coverId'],
            ),
          )
          .toList();
    } catch (e) {
      _log('⚠️ Failed to parse cached books: $e');
      return null;
    }
  }

  Future<void> _onSearchChanged(
    SearchBookQueryChanged event,
    Emitter<SearchBookState> emit,
  ) async {
    final query = event.query.trim();
    _currentQuery = query;
    _currentPage = 1;
    _hasMore = true;
    _allBooks = [];

    if (query.isEmpty) {
      if (!isClosed) emit(SearchBookInitial());
      return;
    }

    if (!isClosed) emit(SearchBookLoading());

    final cached = await _getFromLocalCache(query);
    if (cached != null && cached.isNotEmpty) {
      _log('📦 Loaded ${cached.length} books from local cache for "$query"');
      _allBooks = cached;

      // Show cached books immediately
      if (!isClosed) emit(SearchBookLoaded(books: _allBooks, hasMore: true));
    }

    try {
      _ongoingSearch?.complete();
      _ongoingSearch = Completer();

      final books = await searchBooks(query, page: _currentPage);

      // Merge cache + API results (deduplicate if needed)
      if (cached != null && cached.isNotEmpty) {
        final newBooks = books
            .where((b) => !_allBooks.any((c) => c.title == b.title))
            .toList();
        _allBooks.addAll(newBooks);
      } else {
        _allBooks = books;
      }

      _hasMore = books.length == _pageSize;

      await _saveToLocalCache(query, _allBooks);

      if (!isClosed) {
        emit(
          _allBooks.isEmpty
              ? const SearchBookEmpty()
              : SearchBookLoaded(books: _allBooks, hasMore: _hasMore),
        );
      }
    } catch (e, stack) {
      _log('❌ Error: $e\n$stack');
      if (!isClosed) emit(SearchBookError('Failed to fetch books.'));
    }
  }

  Future<void> _onLoadMore(
    SearchBookLoadMore event,
    Emitter<SearchBookState> emit,
  ) async {
    if (!_hasMore || state is SearchBookLoadingMore) return;

    _currentPage++;
    _log('📤 Loading more... Page: $_currentPage');

    if (!isClosed) {
      emit(SearchBookLoadingMore(books: _allBooks, hasMore: _hasMore));
    }

    try {
      final books = await searchBooks(_currentQuery, page: _currentPage);
      _log('✅ Page $_currentPage fetched with ${books.length} books');

      if (books.isEmpty) {
        _hasMore = false;
        _log('📭 No more books to load. Turning off pagination.');
        if (!isClosed) {
          emit(SearchBookLoaded(books: _allBooks, hasMore: _hasMore));
        }
        return; // ✅ Stop here to avoid infinite loader
      }

      _allBooks.addAll(books);
      _hasMore = books.length == _pageSize;

      await _saveToLocalCache(_currentQuery, _allBooks);

      _log('📚 Total books: ${_allBooks.length} | hasMore: $_hasMore');

      if (!isClosed) {
        emit(SearchBookLoaded(books: _allBooks, hasMore: _hasMore));
      }
    } catch (e, stack) {
      _log('❌ Error during load more:\n$e\n$stack');
      if (!isClosed) {
        emit(SearchBookError('Could not load more books.'));
      }
    }
  }

  Future<void> _saveToLocalCache(String key, List<Book> books) async {
    final prefs = await SharedPreferences.getInstance();
    final bookJsonList = books
        .map(
          (e) => {
            'title': e.title,
            'authorName': e.authorName,
            'coverId': e.coverId,
          },
        )
        .toList();

    final encoded = jsonEncode(bookJsonList);
    await prefs.setString(key, encoded);
    _log('💾 Saved ${books.length} books to local cache under key "$key".');
  }

  void _log(String msg) {
    debugPrint(msg);
  }
}
