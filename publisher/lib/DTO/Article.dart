import 'package:json_annotation/json_annotation.dart';
import 'package:publisher/DTO/Abstract.dart';
import 'package:publisher/DTO/AppUser.dart';

part 'Article.g.dart';

@JsonSerializable(explicitToJson: true)
class Article extends Abstract {
  String title;
  String createdAt;
  AppUser author;
  int likeCount;
  bool liked;

  Article(String id, this.title, this.createdAt, this.likeCount, this.liked) : super(id);

  factory Article.fromJson(Map<String, dynamic> json) =>
      _$ArticleFromJson(json);

  Map<String, dynamic> toJson() => _$ArticleToJson(this);
}
