import 'dart:io';

import 'package:flutter/material.dart';
import 'package:jigsaw_hints/provider/images.dart';
import 'package:jigsaw_hints/utils/constants.dart';
import 'package:provider/provider.dart';

import '../ui/menus/app_bar.dart';

class GalleryScreen extends StatefulWidget {
  const GalleryScreen({super.key});

  @override
  State<GalleryScreen> createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen> {
  int pictureSelected = 0;

  void selectPicture(int index) {
    setState(() {
      pictureSelected = index;
    });
  }

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
          child: body(context, images),
        ),
      );
    });
  }

  Widget body(context, ImagesProvider images) {
    return images.capturedImages.isEmpty
        ? emptyGallery(context)
        : selectableGallery(images);
  }

  GridView selectableGallery(ImagesProvider images) {
    return GridView.count(
      crossAxisCount: 3,
      mainAxisSpacing: 2,
      crossAxisSpacing: 2,
      children: images.capturedImages.reversed
          .map((image) => GalleryPicture(
              image: image,
              onTap: () =>
                  selectPicture(images.capturedImages.indexOf(image) + 1),
              selected:
                  pictureSelected == images.capturedImages.indexOf(image) + 1))
          .toList(),
    );
  }

  Center emptyGallery(context) {
    return Center(
      child: Column(
        // mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.6,
            child: Text(
              "Looks like you don't have any saved boxes yet! 😲",
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.info_outline,
                color: Colors.blue,
                size: defaultIconSize,
              ),
              const SizedBox(width: defaultSmallWhitespace),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.5,
                child: Text(
                  "Go ahead a take your first picture of the jigsaw box,   it will be show up here. 📷",
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(backgroundColor: Colors.grey[200]),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

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
    return InkWell(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          decoration: BoxDecoration(
            border:
                selected ? Border.all(color: themeLightBlue, width: 5) : null,
          ),
          child: Image.file(
            image,
            fit: BoxFit.cover,
            colorBlendMode: BlendMode.darken,
            color: selected ? Colors.black.withOpacity(0.2) : null,
          ),
        ));
  }
}
