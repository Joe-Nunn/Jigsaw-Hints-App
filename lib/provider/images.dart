import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:jigsaw_hints/provider/box_cover.dart';
import 'package:path_provider/path_provider.dart';

class ImagesProvider extends ChangeNotifier {
  List<BoxCover> _capturedImages = List.empty(growable: true);

  List<BoxCover> get capturedImages => _capturedImages;

  set capturedImages(List<BoxCover> capturedImages) {
    if (_capturedImages != capturedImages) {
      _capturedImages = capturedImages;
      notifyListeners();
    }
  }

  void removeImage(BoxCover selectedBoxCover) {
    capturedImages.remove(selectedBoxCover);
    notifyListeners();
  }

  Future<void> loadImagesFromDisk() async {
    final dataDirectory = await getApplicationDocumentsDirectory();
    final files = await dataDirectory.list().toList();
    final capturedImages = <BoxCover>[];

    for (final file in files) {
      if (file is File && file.path.endsWith('.meta')) {
        final path = file.path.substring(0, file.path.length - 5);
        final boxCover = await load(path);
        capturedImages.add(boxCover);
      }
    }
    this.capturedImages = capturedImages;
  }

  static Future<BoxCover> load(String path) async {
    final imagePath = '$path.jpg';
    final metaFilePath = '$path.meta';
    final image = File(imagePath);
    final metaFile = File(metaFilePath);

    final meta = await metaFile.readAsString();
    final data = json.decode(meta) as Map<String, dynamic>;
    final numberOfPieces = data['numberOfPieces'] as int;

    return BoxCover(
        image: image,
        numberOfPieces: numberOfPieces,
        imagePath: imagePath,
        metaFilePath: metaFilePath);
  }
}
