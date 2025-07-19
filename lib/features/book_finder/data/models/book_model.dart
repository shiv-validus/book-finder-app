import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/book.dart';

part 'book_model.g.dart';

@JsonSerializable()
class BookModel {
  final String title;
  final List<String> authorName;
  @JsonKey(name: 'cover_i')
  final int? coverI;

  const BookModel({
    required this.title,
    required this.authorName,
    this.coverI,
  });

  // factory BookModel.fromJson(Map<String, dynamic> json) =>
  //     _$BookModelFromJson(json);

  factory BookModel.fromJson(Map<String, dynamic> json) {
  return BookModel(
    title: json['title'] ?? 'No Title',
    authorName: (json['author_name'] as List?)?.map((e) => e.toString()).toList() ?? [],
    coverI: json['cover_i'],
  );
}


  Map<String, dynamic> toJson() => _$BookModelToJson(this);

  // ✅ convert Model → Entity
  Book toEntity() {
    return Book(
      title: title,
      authorName: authorName,
      coverId: coverI,
    );
  }
}
