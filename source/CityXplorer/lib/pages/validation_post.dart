import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../router/delegate.dart';

class ValidationPost extends StatelessWidget {
  final routerDelegate = Get.find<MyRouterDelegate>();

  ValidationPost({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => routerDelegate.popRoute(),
        ),
        title: const Text(
          'Crédits',
        ),
      ),
      body: Text("Validation"),
    );
  }
}
