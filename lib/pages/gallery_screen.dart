import 'package:flutter/material.dart';
import 'package:jigsaw_hints/provider/images.dart';
import 'package:provider/provider.dart';

import '../ui/app_bar.dart';

class GalleryScreen extends StatelessWidget {
  const GalleryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<ImagesProvider>(builder: (context, images, child) {
      return Scaffold(
        appBar: const JigsawAppBar(
          title: "Saved Boxes",
        ),
        body: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: GridView.count(
            crossAxisCount: 3,
            mainAxisSpacing: 2,
            crossAxisSpacing: 2,
            children: images.capturedImages.reversed
                .map((image) => Image.file(image, fit: BoxFit.cover))
                .toList(),
          ),
        ),
      );
    });
  }
}
