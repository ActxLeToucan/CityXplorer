import 'package:cityxplorer/components/icon_menu_list_edit.dart';
import 'package:cityxplorer/models/listes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../components/appbar.dart';
import '../main.dart';
import '../models/user_connected.dart';
import '../router/delegate.dart';

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
            appBar: defaultAppBar(context),
            body: const Center(child: Text("Listes invalides.")));
      } else {
        List<Widget> mesListes = []; //Listes crées
        for (var element in _createdLists) {
          mesListes.add(_renderListTile(element.nomListe, element));
        }
        return Scaffold(
            appBar: defaultAppBar(context),
            body: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: mesListes,
            ));
      }
    } else {
      return Scaffold(
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
      title: Text(s),
      trailing: IconMenuListEdit(
        user: _user,
        list: l,
      ),
    );
  }
}
