import 'package:flutter/material.dart';

class User with ChangeNotifier {
  String _name = "Your Name";

  String get name => _name;

  set name(String newValue) {
    _name = newValue;
    notifyListeners();
  }
}
