import 'package:flutter/material.dart';
import 'dart:io';

class BoxCoverProvider extends ChangeNotifier {
  /// Currently used box cover.
  File? _boxCover;

  /// Get currently used box cover.
  File? get boxCover => _boxCover;

  /// Set currently used box cover and notify listeners.
  set boxCover(File? boxCover) {
    if (_boxCover != boxCover) {
      _boxCover = boxCover;
      notifyListeners();
    }
  }
}
