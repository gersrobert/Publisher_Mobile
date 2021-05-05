// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ArticleInsert.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ArticleInsert _$ArticleInsertFromJson(Map<String, dynamic> json) {
  return ArticleInsert(
    json['title'] as String,
    json['content'] as String,
    (json['categories'] as List)?.map((e) => e as String)?.toList(),
    json['id'],
  );
}

Map<String, dynamic> _$ArticleInsertToJson(ArticleInsert instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'content': instance.content,
      'categories': instance.categories,
    };
