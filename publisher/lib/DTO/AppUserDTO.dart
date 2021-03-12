import 'package:publisher/DTO/AbstractDTO.dart';

class AppUserDTO extends AbstractDTO {
  final String firstName;
  final String lastName;
  final String userName;

  AppUserDTO({String id, this.firstName, this.lastName, this.userName}) : super(id: id);

  factory AppUserDTO.fromJson(Map<String, dynamic> json) {
    return AppUserDTO(
      id: json['id'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      userName: json['userName'],
    );
  }
}