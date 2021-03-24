import 'package:json_annotation/json_annotation.dart';
import 'package:publisher/DTO/AppUser.dart';
import 'package:publisher/DTO/Article.dart';
import 'package:publisher/DTO/Category.dart';

part 'DetailedArticle.g.dart';

@JsonSerializable(explicitToJson: true)
class DetailedArticle extends Article {
  String content;

  DetailedArticle(String id, String title, String createdAt, AppUser author,
      List<Category> categories, int likeCount, bool liked, this.content)
      : super(id, title, createdAt, author, categories, likeCount, liked);

  factory DetailedArticle.fromJson(Map<String, dynamic> json) =>
      _$DetailedArticleFromJson(json);

  Map<String, dynamic> toJson() => _$DetailedArticleToJson(this);
}
