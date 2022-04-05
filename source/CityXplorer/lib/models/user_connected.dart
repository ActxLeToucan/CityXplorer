import 'package:cityxplorer/models/user.dart';
import 'package:get/get.dart';

import '../router/delegate.dart';

class UserConnected extends User {
  final String token;

  UserConnected(
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

  factory UserConnected.fromJson(Map<String, dynamic> json) {
    return UserConnected(
        token: json['token'],
        pseudo: json['pseudo'],
        name: json['name'],
        avatar: json['avatar'],
        niveauAcces: json['niveauAcces'],
        description: json['description'],
        likes: List<int>.from(json['likes']));
  }

  factory UserConnected.empty() {
    return UserConnected(
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
      "token": token,
      "pseudo": pseudo,
      "name": name,
      "avatar": avatar,
      "niveauAcces": niveauAcces,
      "description": description,
      "likes": likes
    };
  }

  updateWith(User user) {
    return UserConnected(
        token: token,
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
