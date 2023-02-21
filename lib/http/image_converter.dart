

import 'dart:convert';
import 'dart:core';
import 'dart:io';
import 'dart:typed_data';

class ImageConverter {
  static String encodeToBase64(File image) {
    List<int> imageBytes = image.readAsBytesSync();
    String base64Image = base64Encode(imageBytes);
    return base64Image;
  }

    static String stringFromBase64(String base64String) {
      List<int> imageBytes = base64Decode(base64String);
      String image = String.fromCharCodes(imageBytes);
      return image;
    }

    static Uint8List dataFromBase64(String base64String) {
  return base64Decode(base64String);
}
}


