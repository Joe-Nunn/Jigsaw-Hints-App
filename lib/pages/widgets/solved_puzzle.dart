import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jigsaw_hints/http/image_converter.dart';
import 'package:jigsaw_hints/pages/widgets/full_screen_image.dart';
import 'package:jigsaw_hints/ui/animations/animations.dart';

class SolvedJigsawPuzzle extends StatefulWidget {
  final String image;
  const SolvedJigsawPuzzle({
    super.key,
    required this.image,
  });

  @override
  State<SolvedJigsawPuzzle> createState() => _SolvedJigsawPuzzleState();
}

class _SolvedJigsawPuzzleState extends State<SolvedJigsawPuzzle> {
  @override
  Widget build(BuildContext context) {
    // Decode the base64 image
    Uint8List solvedImage = ImageConverter.dataFromBase64(widget.image);
    return GestureDetector(
      child: Hero(tag: "Solved Jigsaw Image", child: Image.memory(solvedImage)),
      onTap: () {
        Navigator.push(context, slideIn(FullScreenImage(image: solvedImage)))
            .then((_) => setScreenToVerticalOrientation());
      },
    );
  }

  void setScreenToVerticalOrientation() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }
}
