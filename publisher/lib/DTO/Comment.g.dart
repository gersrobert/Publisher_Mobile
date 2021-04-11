// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Comment.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Comment _$CommentFromJson(Map<String, dynamic> json) {
  return Comment(
    json['id'] as String,
    json['content'] as String,
    json['author'] == null
        ? null
        : AppUser.fromJson(json['author'] as Map<String, dynamic>),
    json['createdAt'] as String,
  );
}

Map<String, dynamic> _$CommentToJson(Comment instance) => <String, dynamic>{
      'id': instance.id,
      'content': instance.content,
      'author': instance.author?.toJson(),
      'createdAt': instance.createdAt,
    };
