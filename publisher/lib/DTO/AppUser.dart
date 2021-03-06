import 'package:json_annotation/json_annotation.dart';
import 'package:publisher/DTO/Abstract.dart';
import 'package:publisher/DTO/Article.dart';

part 'AppUser.g.dart';

@JsonSerializable()
class AppUser extends Abstract {
  String firstName;
  String lastName;
  String userName;
  List<Article> articles;
  String photo;

  AppUser(
      String id, this.firstName, this.lastName, this.userName, this.articles, this.photo)
      : super(id);

  factory AppUser.fromJson(Map<String, dynamic> json) =>
      _$AppUserFromJson(json);

  Map<String, dynamic> toJson() => _$AppUserToJson(this);
}
