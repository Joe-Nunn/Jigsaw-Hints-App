import 'dart:convert';

import 'package:flutter/material.dart';
import 'dart:io';

import 'package:path_provider/path_provider.dart';

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
  String? fileName;
  String? metaFileName;
  String? dataDir;

  BoxCover({required this.file, required this.numberOfPieces});

  String get getFilePath => '$dataDir/$fileName';
  String get getMetaFilePath => '$dataDir/$metaFileName';
  File get getFile => file;
  int get getNumberOfPieces => numberOfPieces;

  Future<void> save(Directory dataDir) async {
    this.dataDir = dataDir.path;
    final data = <String, dynamic>{
      'numberOfPieces': numberOfPieces,
    };
    final meta = json.encode(data);

    final timestamp = DateTime.now().millisecondsSinceEpoch;
    metaFileName = '$timestamp.meta';
    final metaFile = File('${dataDir.path}/$metaFileName');
    await metaFile.writeAsString(meta);

    fileName = '$timestamp.jpg';
    final pictureBytes = await file.readAsBytes();
    await File('${dataDir.path}/$fileName').writeAsBytes(pictureBytes);
  }

  static Future<BoxCover> load(String path) async {
    final file = File('$path.jpg');
    final metaFile = File('$path.meta');

    final meta = await metaFile.readAsString();
    final data = json.decode(meta) as Map<String, dynamic>;
    final numberOfPieces = data['numberOfPieces'] as int;

    return BoxCover(file: file, numberOfPieces: numberOfPieces);
  }

  Future<void> delete() async {
    final metaFile = File(getMetaFilePath);
    final imageFile = File(getFilePath);

    await metaFile.delete();
    await imageFile.delete();
  }
}
