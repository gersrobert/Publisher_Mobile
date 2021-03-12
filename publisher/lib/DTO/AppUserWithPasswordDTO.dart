import 'package:publisher/DTO/AppUserDTO.dart';

class AppUserWithPasswordDTO extends AppUserDTO {
  final String passwordHash;

  AppUserWithPasswordDTO(
      {String id,
      String firstName,
      String lastName,
      String userName,
      this.passwordHash})
      : super(
            id: id,
            firstName: firstName,
            lastName: lastName,
            userName: userName);

  factory AppUserWithPasswordDTO.fromJson(Map<String, dynamic> json) {
    return AppUserWithPasswordDTO(
      id: json['id'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      userName: json['userName'],
      passwordHash: json['passwordHash'],
    );
  }

  Map<String, dynamic> toJson() => {
        'firstName': this.firstName,
        'lastName': this.lastName,
        'userName': this.userName,
        'passwordHash': this.passwordHash,
      };
}
