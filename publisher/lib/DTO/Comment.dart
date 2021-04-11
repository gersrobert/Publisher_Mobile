import 'package:json_annotation/json_annotation.dart';
import 'package:publisher/DTO/Abstract.dart';
import 'package:publisher/DTO/AppUser.dart';

part 'Comment.g.dart';

@JsonSerializable(explicitToJson: true)
class Comment extends Abstract {
  String content;
  AppUser author;
  String createdAt;

  Comment(String id, this.content, this.author, this.createdAt) : super(id);

  factory Comment.fromJson(Map<String, dynamic> json) =>
      _$CommentFromJson(json);

  Map<String, dynamic> toJson() => _$CommentToJson(this);
}
