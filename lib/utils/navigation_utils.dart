import 'package:flutter/material.dart';

class NavigationUtils {
  static void popAll(BuildContext context) {
    Navigator.of(context).popUntil(ModalRoute.withName('/'));
  }
}
