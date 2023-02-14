import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:jigsaw_hints/http/image_converter.dart';
import 'package:zoom_pinch_overlay/zoom_pinch_overlay.dart';

class SolvedJigsawPuzzle extends StatelessWidget {
  final Map<String, dynamic> data;
  const SolvedJigsawPuzzle({
    super.key,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    String? base64Image = data["solved_data"];
    if (base64Image == null) {
      return const Center(
        child: Text("Puzzle could not be solved 😔. Please try again 🧩."),
      );
    }
    // Decode the base64 image
    Uint8List solvedImage = ImageConverter.dataFromBase64(base64Image);
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
