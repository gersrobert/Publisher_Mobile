import 'package:json_annotation/json_annotation.dart';
import 'package:publisher/DTO/Article.dart';

part 'Articles.g.dart';

@JsonSerializable(explicitToJson: true)
class Articles {
  List<Article> content;
  // unimplemented pagable;
  int totalPages;
  int totalElements;
  bool last;
  int size;
  int number;
  // unimplemented sort;
  bool first;
  int numberOfElements;
  bool empty;

  Articles(this.content, this.totalPages, this.last, this.size, this.number,
      this.first, this.numberOfElements, this.empty);

  factory Articles.fromJson(Map<String, dynamic> json) =>
      _$ArticlesFromJson(json);

  Map<String, dynamic> toJson() => _$ArticlesToJson(this);
}
