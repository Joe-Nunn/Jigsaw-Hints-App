import 'dart:io';
import 'package:flutter/material.dart';
import 'package:jigsaw_hints/provider/box_cover.dart';

class ImagesProvider extends ChangeNotifier {
  List<BoxCover> _capturedImages = List.empty(growable: true);

  List<BoxCover> get capturedImages => _capturedImages;

  set capturedImages(List<BoxCover> capturedImages) {
    if (_capturedImages != capturedImages) {
      _capturedImages = capturedImages;
      notifyListeners();
    }
  }
}
