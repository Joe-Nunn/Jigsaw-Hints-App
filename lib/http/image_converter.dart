

import 'dart:convert';
import 'dart:core';
import 'dart:io';

class ImageConverter {
  static String encodeToBase64(String image) {
    File file = File(image);
    List<int> imageBytes = file.readAsBytesSync();
    String base64Image = base64Encode(imageBytes);
    return base64Image;
  }

    static String decodeFromBase64(String base64Image) {
      List<int> imageBytes = base64Decode(base64Image);
      String image = String.fromCharCodes(imageBytes);
      return image;
    }
}


