import 'dart:convert';

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
  final File image;
  final int numberOfPieces;
  String? imagePath;
  String? metaFilePath;

  BoxCover(
      {required this.image,
      required this.numberOfPieces,
      this.imagePath,
      this.metaFilePath});

  File get getImage => image;
  int get getNumberOfPieces => numberOfPieces;

  Future<void> save(Directory dataDir) async {
    final data = <String, dynamic>{
      'numberOfPieces': numberOfPieces,
    };
    final meta = json.encode(data);

    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final metaFile = File('${dataDir.path}/$timestamp.meta');
    await metaFile.writeAsString(meta);

    final pictureBytes = await image.readAsBytes();
    await File('${dataDir.path}/$timestamp.jpg').writeAsBytes(pictureBytes);
  }

  Future<void> delete() async {
    final metaFile = File(imagePath!);
    final imageFile = File(metaFilePath!);

    await metaFile.delete();
    await imageFile.delete();
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is BoxCover && image == other.image;
  }

  @override
  int get hashCode => image.hashCode;
}
