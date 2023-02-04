import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class SolvedJigsawPuzzle extends StatelessWidget {
  final Map<String, dynamic> data;
  final File base;
  const SolvedJigsawPuzzle({
    super.key,
    required this.data,
    required this.base,
  });

  @override
  Widget build(BuildContext context) {
    double x = data["solved_x"];
    double y = data["solved_y"];
    double xCorrection = 0.04;
    double yCorrection = -0.15;
    double size = 300.0;
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      child: LayoutBuilder(builder: (context, constraints) {
        return Stack(
          clipBehavior: Clip.none,
          children: [
            Image.file(
              base,
              width: size,
              height: size,
              fit: BoxFit.fill,
            ),
            Positioned(
              top: (x + xCorrection) * constraints.maxHeight,
              left: (y + yCorrection) * constraints.maxWidth,
              child: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  border: Border.all(
                    width: 5,
                    color: Colors.red,
                  ),
                ),
              )
                  .animate(delay: 2.seconds)
                  .fade(duration: 1.seconds)
                  .then(delay: 1.seconds)
                  .shake(),
            )
          ],
        );
      }),
    );
  }
}
