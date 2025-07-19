
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../../domain/entities/book.dart';
import '../pages/book_details_screen.dart'; // ✅ Import for details screen

class BookListTile extends StatelessWidget {
  final Book book;

  const BookListTile({super.key, required this.book});

  @override
  Widget build(BuildContext context) {
    final coverUrl = book.coverId != null
        ? 'https://covers.openlibrary.org/b/id/${book.coverId}-M.jpg'
        : null;

    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => BookDetailsScreen(book: book),
          ),
        );
      },
      child: ListTile(
        leading: SizedBox(
          width: 50,
          height: 75,
          child: coverUrl != null
              ? Image.network(
                  coverUrl,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Shimmer.fromColors(
                      baseColor: Colors.grey.shade300,
                      highlightColor: Colors.grey.shade100,
                      child: Container(
                        color: Colors.white,
                        width: 50,
                        height: 75,
                      ),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) => const Icon(
                    Icons.broken_image_outlined,
                    size: 50,
                    color: Colors.grey,
                  ),
                )
              : const Icon(Icons.menu_book_rounded, size: 50),
        ),
        title: Text(
          book.title,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text(
          book.authorName.join(', '),
          style: const TextStyle(color: Colors.grey),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }
}
