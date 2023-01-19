import 'package:flutter/material.dart';

class CameraModeProvider extends ChangeNotifier {
  CameraMode _mode = CameraMode.piece;

  CameraMode get mode => _mode;

  set mode(CameraMode mode) {
    if (mode != _mode) {
      _mode = mode;
      notifyListeners();
    }
  }
}

enum CameraMode {
  piece,
  box,
}
