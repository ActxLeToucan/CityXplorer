import 'package:cityxplorer/models/user.dart';
import 'package:get/get.dart';

import '../router/delegate.dart';

class UserConneted extends User {
  final String token;

  UserConneted(
      {required this.token,
      required String pseudo,
      required String name,
      required String avatar,
      required int niveauAcces,
      required String description,
      required List<int?> likes})
      : super(
            pseudo: pseudo,
            name: name,
            avatar: avatar,
            niveauAcces: niveauAcces,
            description: description,
            likes: likes);

  factory UserConneted.fromJson(Map<String, dynamic> json) {
    return UserConneted(
        token: json['token'],
        pseudo: json['pseudo'],
        name: json['name'],
        avatar: json['avatar'],
        niveauAcces: json['niveauAcces'],
        description: json['description'],
        likes: List<int>.from(json['likes']));
  }

  factory UserConneted.empty() {
    return UserConneted(
        token: "",
        pseudo: "",
        name: "",
        avatar: "",
        niveauAcces: 0,
        description: "",
        likes: []);
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      "token": this.token,
      "pseudo": this.pseudo,
      "name": this.name,
      "avatar": this.avatar,
      "niveauAcces": this.niveauAcces,
      "description": this.description,
      "likes": this.likes
    };
  }

  updateWith(User user) {
    return UserConneted(
        token: this.token,
        pseudo: user.pseudo,
        name: user.name,
        avatar: user.avatar,
        niveauAcces: user.niveauAcces,
        description: user.description,
        likes: user.likes);
  }

  void pushEditPage() {
    final routerDelegate = Get.find<MyRouterDelegate>();
    routerDelegate.pushPage(name: '/edit_profile', arguments: this);
  }
}
