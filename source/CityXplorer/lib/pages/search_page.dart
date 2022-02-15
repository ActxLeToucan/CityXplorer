import 'package:flutter/material.dart';

import '../styles.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  List<int> _searchIndexList = [];
  final List<String> _list = [
    'English Textbook',
    'Japanese Textbook',
    'English Vocabulary',
    'Japanese Vocabulary',
    'Lorem ipsum dolor sit amet.'
  ];

  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Styles.mainBackgroundColor,
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
        itemCount: _searchIndexList.length,
        itemBuilder: (context, index) {
          index = _searchIndexList[index];
          return Card(child: ListTile(title: Text(_list[index])));
        });
  }

  Widget _renderSearchBar() {
    return TextField(
      textInputAction: TextInputAction.search,
      controller: _controller,
      onSubmitted: (String text) {
        setState(() {
          _searchIndexList = [];
          for (int i = 0; i < _list.length; i++) {
            if (_list[i].toLowerCase().contains(text.toLowerCase())) {
              _searchIndexList.add(i);
            }
          }
        });
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
          hintText: 'Rechercher un utilisateur...',
          border: InputBorder.none),
    );
  }
}
