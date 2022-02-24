import 'dart:convert';

import 'package:cityxplorer/pages/user_profile.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

import '../conf.dart';
import '../models/user.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  List<User> _list = [];

  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Container(
        width: double.infinity,
        height: 40,
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(5)),
        child: Center(
          child: _renderSearchBar(),
        ),
      )),
      body: _searchListView(),
    );
  }

  Widget _searchListView() {
    return ListView.builder(
        physics: const BouncingScrollPhysics(),
        itemCount: _list.length,
        itemBuilder: (context, index) {
          return Card(
              child: GestureDetector(
            child: ListTile(
                title: Text(_list[index].name),
                subtitle: Text("@${_list[index].pseudo}")),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => UserProfile(user: _list[index]),
                ),
              );
            },
          ));
        });
  }

  Widget _renderSearchBar() {
    return TextField(
      textInputAction: TextInputAction.search,
      controller: _controller,
      onSubmitted: (String text) async {
        String url =
            Conf.bddDomainUrl + Conf.bddPath + "/users?q=${text.toLowerCase()}";

        _list = [];
        try {
          var response = await http.get(Uri.parse(url));
          final List<dynamic> data = json.decode(response.body);

          if (data.isEmpty) {
            Fluttertoast.showToast(msg: "Aucun résultat.");
          } else {
            for (var user in data) {
              _list.add(User.fromJson(user));
            }
          }
        } catch (e) {
          print(e);
          Fluttertoast.showToast(
              msg: "Impossible d'accéder à la base de données.");
        }

        setState(() {});
      },
      autocorrect: false,
      autofocus: true,
      decoration: InputDecoration(
          prefixIcon: const Icon(Icons.search),
          suffixIcon: IconButton(
            icon: const Icon(Icons.clear),
            onPressed: () {
              _controller.text = "";
            },
          ),
          hintText: 'Pseudo...',
          border: InputBorder.none),
    );
  }
}
