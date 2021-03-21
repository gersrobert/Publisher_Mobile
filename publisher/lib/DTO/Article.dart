import 'package:json_annotation/json_annotation.dart';
import 'package:publisher/DTO/AppUser.dart';

part 'Article.g.dart';

@JsonSerializable(explicitToJson: true)
class Article {
  String id;
  String title;
  String createdAt;
  AppUser author;
  int likeCount;
  bool liked;

  Article(this.id, this.title, this.createdAt, this.likeCount, this.liked);

  factory Article.fromJson(Map<String, dynamic> json) =>
      _$ArticleFromJson(json);

  Map<String, dynamic> toJson() => _$ArticleToJson(this);
}
