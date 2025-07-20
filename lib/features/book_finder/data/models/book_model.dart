import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/book.dart';

part 'book_model.g.dart';

@JsonSerializable()
class BookModel {
  final String title;

  @JsonKey(name: 'author_name')
  final List<String>? authorName;

  @JsonKey(name: 'cover_i')
  final int? coverI;

  const BookModel({
    required this.title,
    this.authorName,
    this.coverI,
  });

  factory BookModel.fromJson(Map<String, dynamic> json) =>
      _$BookModelFromJson(json);

  Map<String, dynamic> toJson() => _$BookModelToJson(this);

  Book toEntity() {
    return Book(
      title: title,
      authorName: authorName ?? [],
      coverId: coverI,
    );
  }
}
