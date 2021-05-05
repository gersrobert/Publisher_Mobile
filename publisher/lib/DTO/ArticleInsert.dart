import 'package:json_annotation/json_annotation.dart';
import 'package:publisher/DTO/Abstract.dart';

part 'ArticleInsert.g.dart';

@JsonSerializable(explicitToJson: true)
class ArticleInsert extends Abstract {
  String title;
  String content;
  List<String> categories;

  ArticleInsert(this.title, this.content, this.categories, [String id])
      : super(id);

  factory ArticleInsert.fromJson(Map<String, dynamic> json) =>
      _$ArticleInsertFromJson(json);

  Map<String, dynamic> toJson() => _$ArticleInsertToJson(this);
}
