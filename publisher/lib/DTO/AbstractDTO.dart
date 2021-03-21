class AbstractDTO {
  final String id;
  
  AbstractDTO({this.id});

  factory AbstractDTO.fromJson(Map<String, dynamic> json) {
    return AbstractDTO(
      id: json['id'],
    );
  }
}