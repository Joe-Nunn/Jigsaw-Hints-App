import 'dart:io';
import 'package:flutter/material.dart';

class ImagesProvider extends ChangeNotifier {
  List<File> _capturedImages = List.empty(growable: true);

  List<File> get capturedImages => _capturedImages;

  set capturedImages(List<File> capturedImages) {
    if (_capturedImages != capturedImages) {
      _capturedImages = capturedImages;
      notifyListeners();
    }
  }
}
