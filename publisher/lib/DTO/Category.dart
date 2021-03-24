import 'package:json_annotation/json_annotation.dart';
import 'package:publisher/DTO/Abstract.dart';
import 'package:publisher/DTO/Article.dart';

part 'Category.g.dart';

@JsonSerializable(explicitToJson: true)
class Category extends Abstract {
  String name;

  Category(String id, this.name) : super(id);

  factory Category.fromJson(Map<String, dynamic> json) =>
      _$CategoryFromJson(json);

  Map<String, dynamic> toJson() => _$CategoryToJson(this);
}
