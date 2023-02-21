import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:jigsaw_hints/http/image_converter.dart';
import 'package:zoom_pinch_overlay/zoom_pinch_overlay.dart';

class SolvedJigsawPuzzle extends StatelessWidget {
  final String image;
  const SolvedJigsawPuzzle({
    super.key,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    // Decode the base64 image
    Uint8List solvedImage = ImageConverter.dataFromBase64(image);
    return ZoomOverlay(
      modalBarrierColor: Colors.black12,
      minScale: 0.5,
      maxScale: 3.0,
      animationCurve: Curves.fastOutSlowIn,
      animationDuration: const Duration(milliseconds: 300),
      twoTouchOnly: true,
      child: Image.memory(solvedImage),
    );
  }
}
