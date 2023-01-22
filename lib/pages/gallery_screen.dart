import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:jigsaw_hints/pages/widgets/gallery_picture.dart';
import 'package:jigsaw_hints/provider/box_cover.dart';
import 'package:jigsaw_hints/provider/images.dart';
import 'package:jigsaw_hints/ui/menus/app_bar.dart';
import 'package:jigsaw_hints/utils/constants.dart';
import 'package:provider/provider.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:flutter_animate/flutter_animate.dart';

class GalleryScreen extends StatefulWidget {
  const GalleryScreen({super.key});

  @override
  State<GalleryScreen> createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen> {
  final RoundedLoadingButtonController selectButtonController =
      RoundedLoadingButtonController();
  int selectedPictureIndex = 0;
  bool allowPop = true;

  void selectPicture(int index) {
    setState(() {
      selectedPictureIndex = index;
    });
  }

  void usePicture(File image, BoxCoverProvider boxCover) async {
    allowPop = false;
    Timer(const Duration(seconds: 2), () {
      allowPop = true;
      boxCover.boxCover = image;
      selectButtonController.success();
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        if (allowPop) {
          return Future.value(true);
        } else {
          return Future.value(false);
        }
      },
      child: Consumer<ImagesProvider>(builder: (context, images, child) {
        return Scaffold(
          appBar: const JigsawAppBar(
            title: "Saved Boxes",
          ),
          body: GestureDetector(
              onTap: () => setState(() => selectedPictureIndex = 0),
              child: body(context, images)),
        );
      }),
    );
  }

  Widget body(context, ImagesProvider images) {
    return images.capturedImages.isEmpty
        ? emptyGallery(context)
        : selectableGallery(images);
  }

  Widget selectableGallery(ImagesProvider images) {
    return Consumer<BoxCoverProvider>(builder: (context, box, child) {
      return Stack(children: [
        GridView.count(
          padding: const EdgeInsets.only(bottom: 100),
          crossAxisCount: 3,
          mainAxisSpacing: 2,
          crossAxisSpacing: 2,
          children: images.capturedImages.reversed
              .map((image) => GalleryPicture(
                  image: image,
                  onTap: () =>
                      selectPicture(images.capturedImages.indexOf(image) + 1),
                  selected: selectedPictureIndex ==
                      images.capturedImages.indexOf(image) + 1))
              .toList(),
        ).animate().fadeIn(duration: 500.ms).then().shimmer(),
        if (selectedPictureIndex != 0)
          Align(
              alignment: Alignment.bottomCenter,
              heightFactor: 13,
              child: usePictureButton(images, box)),
      ]);
    });
  }

  Widget usePictureButton(ImagesProvider images, BoxCoverProvider box) {
    return Animate(
      child: RoundedLoadingButton(
        controller: selectButtonController,
        color: themeLightBlue,
        successColor: Colors.green,
        borderRadius: 15,
        onPressed: () => usePicture(
            images.capturedImages.elementAt(selectedPictureIndex - 1), box),
        child: Text(
          'Use this box cover',
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
                color: Colors.white,
              ),
        ),
      ).animate().flip(),
    );
  }

  Widget emptyGallery(context) {
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
