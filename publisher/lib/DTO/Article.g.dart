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
    json['likeCount'] as int,
    json['liked'] as bool,
  )..author = json['author'] == null
      ? null
      : AppUser.fromJson(json['author'] as Map<String, dynamic>);
}

Map<String, dynamic> _$ArticleToJson(Article instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'createdAt': instance.createdAt,
      'author': instance.author?.toJson(),
      'likeCount': instance.likeCount,
      'liked': instance.liked,
    };
