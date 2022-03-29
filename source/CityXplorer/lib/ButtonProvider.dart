import 'package:flutter/material.dart';

bool _isLoading = false;

class ButtonProvider with ChangeNotifier {
  bool get isLoading => _isLoading;

  void startLoading() {
    _isLoading = true;
    notifyListeners();
  }

  void stopLoading() {
    _isLoading = false;
    notifyListeners();
  }
}
