// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Articles.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Articles _$ArticlesFromJson(Map<String, dynamic> json) {
  return Articles(
    (json['content'] as List)
        ?.map((e) =>
            e == null ? null : Article.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    json['totalPages'] as int,
    json['last'] as bool,
    json['size'] as int,
    json['number'] as int,
    json['first'] as bool,
    json['numberOfElements'] as int,
    json['empty'] as bool,
  )..totalElements = json['totalElements'] as int;
}

Map<String, dynamic> _$ArticlesToJson(Articles instance) => <String, dynamic>{
      'content': instance.content?.map((e) => e?.toJson())?.toList(),
      'totalPages': instance.totalPages,
      'totalElements': instance.totalElements,
      'last': instance.last,
      'size': instance.size,
      'number': instance.number,
      'first': instance.first,
      'numberOfElements': instance.numberOfElements,
      'empty': instance.empty,
    };
