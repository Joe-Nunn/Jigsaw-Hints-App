import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:jigsaw_hints/http/image_converter.dart';
import 'package:pinch_zoom/pinch_zoom.dart';

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
    return SizedBox(
      height: 200,
      child: PinchZoom(
        resetDuration: const Duration(milliseconds: 100),
        maxScale: 2.5,
        child: Image.memory(solvedImage),
      ),
    );
  }
}
