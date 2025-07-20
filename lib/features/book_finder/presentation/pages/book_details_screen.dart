import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '../../data/datasources/local_database.dart';
import '../../domain/entities/book.dart';

class BookDetailsScreen extends StatefulWidget {
  final Book book;

  const BookDetailsScreen({super.key, required this.book});

  @override
  State<BookDetailsScreen> createState() => _BookDetailsScreenState();
}

class _BookDetailsScreenState extends State<BookDetailsScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _tiltAnimation;
  bool _imageLoaded = false;

  String get coverUrl => widget.book.coverId != null
      ? 'https://covers.openlibrary.org/b/id/${widget.book.coverId}-L.jpg'
      : '';

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _tiltAnimation = Tween<double>(
      begin: -0.02,
      end: 0.02,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
Widget _buildCoverWithLoader() {
  return SizedBox(
    height: 250,
    child: Center(
      child: Stack(
        alignment: Alignment.center,
        children: [
          if (!_imageLoaded)
            Lottie.asset(
              'assets/lottie/book_loader.json',
              width: 100,
              height: 100,
              repeat: true,
            ),
          AnimatedOpacity(
            opacity: _imageLoaded ? 1.0 : 0.0,
            duration: const Duration(milliseconds: 300),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                coverUrl,
                width: 180,
                height: 250,
                fit: BoxFit.cover,
                frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
                  if (frame != null || wasSynchronouslyLoaded) {
                    Future.delayed(const Duration(milliseconds: 300), () {
                      if (mounted) setState(() => _imageLoaded = true);
                    });
                  }
                  return child;
                },
                errorBuilder: (_, __, ___) =>
                    const Icon(Icons.broken_image, size: 100),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Book Details')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildCoverWithLoader(),
            const SizedBox(height: 24),
            Text(
              widget.book.title,
              textAlign: TextAlign.center,
              style: theme.textTheme.headlineSmall,
            ),
            const SizedBox(height: 12),
            Text(
              widget.book.authorName.join(', '),
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () async {
                await LocalDatabase.instance.insertBook(widget.book);
                if (!mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('✅ Book saved to favorites!')),
                );
              },
              icon: const Icon(Icons.save_alt),
              label: const Text('Save to Favorites'),
            ),
          ],
        ),
      ),
    );
  }
}
