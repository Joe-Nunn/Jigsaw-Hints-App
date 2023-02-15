import 'package:flutter/material.dart';
import 'dart:io';

class BoxCoverProvider extends ChangeNotifier {
  /// Currently used box cover.
  BoxCover? _boxCover;

  /// Get currently used box cover.
  BoxCover? get boxCover => _boxCover;

  /// Set currently used box cover and notify listeners.
  set boxCover(BoxCover? boxCover) {
    if (_boxCover != boxCover) {
      _boxCover = boxCover;
      notifyListeners();
    }
  }
}

class BoxCover {
  final File file;
  final int numberOfPieces;

  BoxCover({required this.file, required this.numberOfPieces});

  File get getFile => file;
  int get getNumberOfPieces => numberOfPieces;
}
