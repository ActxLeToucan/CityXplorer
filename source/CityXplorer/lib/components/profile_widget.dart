import 'package:cityxplorer/models/user_connected.dart';
import 'package:flutter/material.dart';

import '../models/user.dart';
import '../conf.dart';

class ProfileWidget extends StatelessWidget {
  final User user;
  final bool isEdit;
  final VoidCallback onClicked;

  const ProfileWidget({
    Key? key,
    required this.user,
    this.isEdit = false,
    required this.onClicked,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.primary;

    Widget icon = Container();
    if (user is UserConneted) {
      icon = Positioned(
        bottom: 0,
        right: 4,
        child: buildIcon(color, isEdit ? Icons.add_a_photo : Icons.edit),
      );
    } else if (user.niveauAcces >= 2) {
      icon = Positioned(
        bottom: 0,
        right: 4,
        child: buildIcon(color, Icons.shield),
      );
    }

    return Center(
      child: Stack(
        children: [
          buildImage(),
          icon,
        ],
      ),
    );
  }

  Widget buildImage() {
    final image =
        NetworkImage("${Conf.bddDomainUrl}/img/avatar/${user.avatar}");

    return ClipOval(
      child: Material(
        color: Colors.transparent,
        child: Ink.image(
          image: image,
          fit: BoxFit.cover,
          width: 128,
          height: 128,
          child: InkWell(onTap: onClicked),
        ),
      ),
    );
  }

  Widget buildIcon(Color color, IconData iconData) => buildCircle(
        color: Colors.white,
        all: 3,
        child: buildCircle(
          color: color,
          all: 8,
          child: Icon(
            iconData,
            color: Colors.white,
            size: 20,
          ),
        ),
      );

  Widget buildCircle({
    required Widget child,
    required double all,
    required Color color,
  }) =>
      ClipOval(
        child: Container(
          padding: EdgeInsets.all(all),
          color: color,
          child: child,
        ),
      );
}
