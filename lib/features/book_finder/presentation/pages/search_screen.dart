import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';

import '../bloc/search_book_bloc.dart';
import '../widgets/book_list_tile.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _didTriggerAutoLoad = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
  }

  void _scrollListener() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 100) {
      final bloc = context.read<SearchBookBloc>();
      final state = bloc.state;
      final hasMore = (state is SearchBookLoaded && state.hasMore) ||
                      (state is SearchBookLoadingMore && state.hasMore);

      if (hasMore) {
        bloc.add(SearchBookLoadMore());
      }
    }
  }

  void _onSearchChanged(String value) {
    final trimmed = value.trim();
    _didTriggerAutoLoad = false;
    context.read<SearchBookBloc>().add(SearchBookQueryChanged(trimmed));
  }

  void _triggerAutoLoadIfNeeded(List books, bool hasMore) {
    if (_didTriggerAutoLoad || !hasMore) return;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final position = _scrollController.position;
      final isScrollable = position.maxScrollExtent > position.viewportDimension;

      if (!isScrollable) {
        context.read<SearchBookBloc>().add(SearchBookLoadMore());
      }
    });

    _didTriggerAutoLoad = true;
  }

  Widget _buildShimmerList() {
    return ListView.builder(
      controller: _scrollController,
      itemCount: 6,
      itemBuilder: (context, index) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8),
        child: Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Row(
            children: [
              Container(width: 50, height: 70, color: Colors.white),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(height: 16, color: Colors.white),
                    const SizedBox(height: 8),
                    Container(height: 14, width: 150, color: Colors.white),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBottomLoader() {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 24),
      child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Book Finder')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              controller: _controller,
              onChanged: _onSearchChanged,
              decoration: InputDecoration(
                hintText: 'Search books...',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _controller.clear();
                    _didTriggerAutoLoad = false;
                    context.read<SearchBookBloc>().add(const SearchBookQueryChanged(''));
                  },
                ),
              ),
            ),
          ),
          Expanded(
            child: BlocBuilder<SearchBookBloc, SearchBookState>(
              builder: (context, state) {
                if (state is SearchBookLoading) {
                  return _buildShimmerList();
                } else if (state is SearchBookLoaded || state is SearchBookLoadingMore) {
                  final books = state is SearchBookLoaded
                      ? state.books
                      : (state as SearchBookLoadingMore).books;
                  final hasMore = state is SearchBookLoaded
                      ? state.hasMore
                      : (state as SearchBookLoadingMore).hasMore;

                  if (books.isEmpty) {
                    return const Center(child: Text('😢 No books found. Try another keyword.'));
                  }

                  _triggerAutoLoadIfNeeded(books, hasMore);

                  return RefreshIndicator(
                    onRefresh: () async {
                      _didTriggerAutoLoad = false;
                      context.read<SearchBookBloc>().add(SearchBookQueryChanged(_controller.text.trim()));
                    },
                    child: ListView.builder(
                      controller: _scrollController,
                      itemCount: books.length + (hasMore ? 1 : 0),
                      itemBuilder: (context, index) {
                        if (index < books.length) {
                          return BookListTile(book: books[index]);
                        } else {
                          return _buildBottomLoader();
                        }
                      },
                    ),
                  );
                } else if (state is SearchBookError) {
                  return Center(child: Text('❌ ${state.message}'));
                }
                return const Center(child: Text('🔍 Start typing to find great books'));
              },
            ),
          ),
        ],
      ),
    );
  }
}
