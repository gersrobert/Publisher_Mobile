import 'package:json_annotation/json_annotation.dart';

part 'AppUser.g.dart';
@JsonSerializable()
class AppUser {
  String id;
  String firstName;
  String lastName;
  String userName;

  AppUser(this.id, this.firstName, this.lastName, this.userName);

  factory AppUser.fromJson(Map<String, dynamic> json) =>
      _$AppUserFromJson(json);

  Map<String, dynamic> toJson() => _$AppUserToJson(this);
}
