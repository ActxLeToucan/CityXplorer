import 'package:flutter/material.dart';
import 'circle_image.dart';
// Bandeau superieur de l application
class AppBarPerso extends StatelessWidget {

  final String authorName;
  final String title;
  final ImageProvider? imageProvider;

  const AppBarPerso({
    Key? key,
    required this.authorName,
    required this.title,
    this.imageProvider,
  }) : super(key: key);
  //
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 24),
      child: Container(
          decoration: BoxDecoration(
          border: Border.all(width: 2),
          borderRadius : BorderRadius.all(Radius.circular(0)),
          ),
          padding: const EdgeInsets.all(10),
          child: Row(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                      CircleImage(
                        imageProvider: imageProvider,
                        imageRadius: 28,

                      ),
                      const SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            "Alexis",
                          ),
                          Text(
                            "Lopes Vaz",
                          )],
                      ),
                    IconButton(
                      icon: const Icon(Icons.settings),
                      iconSize: 28,
                      color: Colors.black,
                      onPressed: () {
                        const snackBar = SnackBar(content: Text('parameters'));
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      },
                    ),
                ],
              ),
              const Spacer(),//--> OP
              IconButton(
                icon: const Icon(Icons.person_search),
                iconSize: 35,
                color: Colors.black,
                onPressed: () {
                  const snackBar = SnackBar(content: Text('rechercher'));
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                },
              ),

            ],
          ),
        ),
    );
  }
}
