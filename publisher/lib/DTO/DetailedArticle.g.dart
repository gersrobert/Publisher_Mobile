// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'DetailedArticle.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DetailedArticle _$DetailedArticleFromJson(Map<String, dynamic> json) {
  return DetailedArticle(
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
    json['content'] as String,
    (json['comments'] as List)
        ?.map((e) =>
            e == null ? null : Comment.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$DetailedArticleToJson(DetailedArticle instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'createdAt': instance.createdAt,
      'author': instance.author?.toJson(),
      'categories': instance.categories?.map((e) => e?.toJson())?.toList(),
      'likeCount': instance.likeCount,
      'liked': instance.liked,
      'content': instance.content,
      'comments': instance.comments?.map((e) => e?.toJson())?.toList(),
    };
