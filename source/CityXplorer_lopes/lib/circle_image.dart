import 'package:flutter/material.dart';
import 'home_card.dart';

// composant du bandeau superieur de l app correspondant au cercle avec l image de profil de l utilisateur
class CircleImage extends StatelessWidget {
  const CircleImage({
    Key? key,
    this.imageProvider,
    this.imageRadius = 20,
  }) : super(key: key);

  final double imageRadius;
  final ImageProvider? imageProvider;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundColor: Colors.white,
      radius: imageRadius,
      child: GestureDetector(
        onTap: () {
          const snackBar = SnackBar(content: Text('Aller au profil'));
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        },
        child: CircleAvatar(
          radius: imageRadius - 5,
          backgroundImage: imageProvider,
        ),
      ),
    );
  }
}
