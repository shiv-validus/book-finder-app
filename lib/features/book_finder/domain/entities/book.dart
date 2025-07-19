

import 'package:equatable/equatable.dart';

class Book extends Equatable {
  final String title;
  final List<String> authorName;
  final int? coverId;

  const Book({
    required this.title,
    required this.authorName,
    this.coverId,
  });

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'authorName': authorName,
      'coverId': coverId,
    };
  }

  @override
  List<Object?> get props => [title, authorName, coverId];
}
