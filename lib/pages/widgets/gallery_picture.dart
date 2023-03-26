import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:jigsaw_hints/utils/constants.dart';
import 'package:jigsaw_hints/utils/shared_prefs_utils.dart';

class GalleryPicture extends StatelessWidget {
  final File image;
  final VoidCallback onTap;
  final bool selected;

  const GalleryPicture(
      {super.key,
      required this.image,
      required this.onTap,
      required this.selected});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        decoration: BoxDecoration(
          border: selected ? Border.all(color: themeLightBlue, width: 5) : null,
        ),
        child: Stack(
          fit: StackFit.expand,
          alignment: Alignment.center,
          children: [
            Image.file(
              image,
              fit: BoxFit.cover,
              colorBlendMode: BlendMode.darken,
              color: selected ? Colors.black.withOpacity(0.2) : null,
            ),
            if (selected)
              Icon(Icons.check,
                      color: themeLightBlue.withOpacity(0.5), size: 50)
                  .animate()
                  .scale(duration: isAnimationEnabled(context) ? Animate.defaultDuration : 0.ms),
          ],
        ),
      ),
    );
  }
}
