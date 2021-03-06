// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Article.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Article _$ArticleFromJson(Map<String, dynamic> json) {
  return Article(
    json['id'] as String,
    json['title'] as String,
    json['createdAt'] as String,
    json['author'] == null
        ? null
        : AppUser.fromJson(json['author'] as Map<String, dynamic>),
    (json['categories'] as List)
        ?.map((e) =>
            e == null ? null : Category.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    json['likeCount'] as int,
    json['liked'] as bool,
  );
}

Map<String, dynamic> _$ArticleToJson(Article instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'createdAt': instance.createdAt,
      'author': instance.author?.toJson(),
      'categories': instance.categories?.map((e) => e?.toJson())?.toList(),
      'likeCount': instance.likeCount,
      'liked': instance.liked,
    };
