import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:login_tutorial/pages/login-screen.dart';


class RoundedButton extends StatelessWidget {
  const RoundedButton({
    Key key,
    @required this.buttonName,
    @required this.methode
  }) : super(key: key);

  static Widget userName = Text("data");
  final String buttonName;
  final VoidCallback methode;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      height: size.height * 0.08,
      width: size.width * 0.8,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Color(-14532561),
      ),
      child: FlatButton(
        onPressed: () {
          methode;
        },
        child: Text(
          buttonName,
          style: TextStyle(fontSize: 22, color: Colors.white, height: 1.5).copyWith(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
