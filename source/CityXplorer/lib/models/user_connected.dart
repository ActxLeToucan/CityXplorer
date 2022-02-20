import 'package:cityxplorer/models/user.dart';

class UserConneted extends User {
  final String token;

  UserConneted(
      {required this.token,
      required String pseudo,
      required String name,
      required String avatar,
      required int niveauAcces,
      required String description})
      : super(
            pseudo: pseudo,
            name: name,
            avatar: avatar,
            niveauAcces: niveauAcces,
            description: description);

  factory UserConneted.fromJson(Map<String, dynamic> json) {
    return UserConneted(
        token: json['token'],
        pseudo: json['pseudo'],
        name: json['name'],
        avatar: json['avatar'],
        niveauAcces: json['niveauAcces'],
        description: json['description']);
  }

  factory UserConneted.empty() {
    return UserConneted(
        token: "",
        pseudo: "",
        name: "",
        avatar: "",
        niveauAcces: 0,
        description: "");
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      "token": this.token,
      "pseudo": this.pseudo,
      "name": this.name,
      "avatar": this.avatar,
      "niveauAcces": this.niveauAcces,
      "description": this.description
    };
  }
}
