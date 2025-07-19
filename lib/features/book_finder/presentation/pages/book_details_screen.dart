
import 'package:flutter/material.dart';
import 'dart:math' as math;

import '../../domain/entities/book.dart';
import '../../data/datasources/local_database.dart';

class BookDetailsScreen extends StatefulWidget {
  final Book book;

  const BookDetailsScreen({super.key, required this.book});

  @override
  State<BookDetailsScreen> createState() => _BookDetailsScreenState();
}

class _BookDetailsScreenState extends State<BookDetailsScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _rotation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _rotation = Tween<double>(begin: -0.05, end: 0.05).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String get coverUrl => widget.book.coverId != null
      ? 'https://covers.openlibrary.org/b/id/${widget.book.coverId}-L.jpg'
      : '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Book Details')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            RotationTransition(
              turns: _rotation,
              child: coverUrl.isNotEmpty
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        coverUrl,
                        height: 250,
                        fit: BoxFit.cover,
                      ),
                    )
                  : const Icon(Icons.book, size: 100),
            ),
            const SizedBox(height: 24),
            Text(
              widget.book.title,
              style: Theme.of(context).textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              widget.book.authorName.join(', '),
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge
                  ?.copyWith(color: Colors.grey[700]),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              icon: const Icon(Icons.save_alt),
              label: const Text('Save to Favorites'),
              onPressed: () async {
                await LocalDatabase.instance.insertBook(widget.book);
                if (!mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('✅ Book saved to favorites!')),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
