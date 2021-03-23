import 'package:json_annotation/json_annotation.dart';

part 'Abstract.g.dart';
@JsonSerializable()
class Abstract {
  String id;

  Abstract(this.id);

  factory Abstract.fromJson(Map<String, dynamic> json) =>
      _$AbstractFromJson(json);

  Map<String, dynamic> toJson() => _$AbstractToJson(this);
}
