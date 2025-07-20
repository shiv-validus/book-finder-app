// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'book_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BookModel _$BookModelFromJson(Map<String, dynamic> json) => BookModel(
  title: json['title'] as String,
  authorName: (json['author_name'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
  coverI: (json['cover_i'] as num?)?.toInt(),
);

Map<String, dynamic> _$BookModelToJson(BookModel instance) => <String, dynamic>{
  'title': instance.title,
  'author_name': instance.authorName,
  'cover_i': instance.coverI,
};
