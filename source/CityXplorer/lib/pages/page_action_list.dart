import 'package:cityxplorer/components/icon_menu_list_edit.dart';
import 'package:cityxplorer/models/listes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../components/appbar.dart';
import '../main.dart';
import '../models/user_connected.dart';
import '../router/delegate.dart';
import '../styles.dart';

class ActionToList extends StatefulWidget {
  final Map<String, dynamic> arguments;
  const ActionToList({Key? key, required this.arguments}) : super(key: key);

  @override
  State<ActionToList> createState() => _ActionToListState();
}

class _ActionToListState extends State<ActionToList> {
  final routerDelegate = Get.find<MyRouterDelegate>();
  List<Listes> _createdLists = [];

  final TextEditingController titre = TextEditingController();
  final TextEditingController description = TextEditingController();

  UserConnected _user = UserConnected.empty();
  bool _initialized = false;

  @override
  void initState() {
    getUser().then((u) {
      setState(() {
        _load();
        _createdLists = widget.arguments['lists'];
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (_initialized) {
      if (_createdLists.isEmpty) {
        return Scaffold(
            backgroundColor: Styles.darkMode
                ? Styles.darkBackground
                : Styles.lightBackground,
            appBar: defaultAppBar(context),
            body: Center(
                child: Text("Listes invalides.",
                    style: TextStyle(
                      color: Styles.darkMode
                          ? Styles.darkTextColor
                          : Styles.lightTextColor,
                    ))));
      } else {
        List<Widget> mesListes = []; //Listes crées
        for (var element in _createdLists) {
          mesListes.add(_renderListTile(element.nomListe, element));
        }
        return Scaffold(
            backgroundColor: Styles.darkMode
                ? Styles.darkBackground
                : Styles.lightBackground,
            appBar: defaultAppBar(context),
            body: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: mesListes,
            ));
      }
    } else {
      return Scaffold(
          backgroundColor:
              Styles.darkMode ? Styles.darkBackground : Styles.lightBackground,
          appBar: defaultAppBar(context),
          body: const Center(child: CircularProgressIndicator()));
    }
  }

  Future<void> _load() async {
    setState(() {
      _initialized = false;
    });
    UserConnected user = await getUser();
    setState(() {
      _user = user;
    });
    List<Listes> pc = await user.getListsCreated();
    setState(() {
      _createdLists = pc;
    });
    setState(() {
      _initialized = true;
    });
  }

  Widget _renderListTile(String s, Listes l) {
    return ListTile(
      textColor:
          (Styles.darkMode ? Styles.darkTextColor : Styles.lightTextColor),
      title: Text(s),
      trailing: IconMenuListEdit(
        user: _user,
        list: l,
      ),
    );
  }
}
