import 'package:flutter/material.dart';

class BackgroundImage extends StatelessWidget {
  const BackgroundImage({Key? key, required this.image}) : super(key: key);

  final ImageProvider image;

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (rect) => const LinearGradient(
        begin: Alignment.bottomCenter,
        end: Alignment.center,
        colors: [Color(0x00073e16), Colors.transparent],
      ).createShader(rect),
      blendMode: BlendMode.darken,
      child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: image,
            fit: BoxFit.cover,
            //colorFilter: ColorFilter.mode(Colors.red, BlendMode.darken),
          ),
        ),
      ),
    );
  }
}
