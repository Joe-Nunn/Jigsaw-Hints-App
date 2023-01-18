import 'package:flutter/material.dart';
import 'package:jigsaw_hints/camera_screen.dart';

class CameraModeProvider extends ChangeNotifier {
  /// Internal, private state of the notifier.
  CameraMode _mode = CameraMode.piece;

  CameraMode get mode => _mode;

  set mode(CameraMode mode) {
    if (mode != _mode) {
      _mode = mode;
      // This call tells the widgets that are listening to this model to rebuild.
      notifyListeners();
    }
  }
}
