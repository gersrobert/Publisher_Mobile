// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'AppUser.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AppUser _$AppUserFromJson(Map<String, dynamic> json) {
  return AppUser(
    json['id'] as String,
    json['firstName'] as String,
    json['lastName'] as String,
    json['userName'] as String,
    (json['articles'] as List)
        ?.map((e) =>
            e == null ? null : Article.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$AppUserToJson(AppUser instance) => <String, dynamic>{
      'id': instance.id,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'userName': instance.userName,
      'articles': instance.articles,
    };
