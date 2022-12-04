import 'dart:io';

import 'package:flutter/material.dart';

import 'app_bar.dart';

class GalleryScreen extends StatelessWidget {
  final List<File> images;
  const GalleryScreen({Key? key, required this.images}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
          children: images
              .map((image) => Image.file(image, fit: BoxFit.cover))
              .toList(),
        ),
      ),
    );
  }
}
