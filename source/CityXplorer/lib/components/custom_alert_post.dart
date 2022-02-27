import 'package:flutter/material.dart';

/// renvoie une boite de dialogue dynamique informant du resultat de la requete
class AdvanceCustomAlert extends StatefulWidget {
  final String message;

  /// on recupere le msg de la bdd pour l afficher a l utilisateur
  final int code;

  /// on recupere le code de retour pour adapter dynamiquement l interface en fonction de si la reponse de l api est positive ou non
  const AdvanceCustomAlert(
      {Key? key, required this.message, required this.code})
      : super(key: key);

  @override
  State<AdvanceCustomAlert> createState() => _AdvanceCustomAlertState();
}

class _AdvanceCustomAlertState extends State<AdvanceCustomAlert> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.0)),
        child: Stack(
          overflow: Overflow.visible,
          alignment: Alignment.topCenter,
          children: [
            Container(
              height: 200,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(10, 70, 10, 10),
                child: Column(
                  children: [
                    Text(
                      widget.message,
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      (noErr()
                          ? 'Et voilà le post est créé 👍'
                          : 'Une erreur est survenue 🤔'),
                      style: TextStyle(fontSize: 20),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    RaisedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      color: (noErr() ? Colors.lightGreen : Colors.redAccent),
                      child: Text(
                        (noErr() ? 'Super ! ' : 'Mince ...'),
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
                top: -60,
                child: CircleAvatar(
                  backgroundColor: (noErr() ? Colors.green : Colors.red),
                  radius: 60,
                  child: Icon(
                    (noErr() ? Icons.add_a_photo : Icons.cancel_outlined),
                    color: Colors.white,
                    size: 80,
                  ),
                )),
          ],
        ));
  }

  /// return true si l insertion est passee
  bool noErr() {
    var res = false;
    widget.code == 1 ? res = true : res = false;
    return res;
  }
}
