import 'package:flutter/material.dart';
import 'package:jigsaw_hints/provider/images.dart';
import 'package:jigsaw_hints/utils/constants.dart';
import 'package:provider/provider.dart';

import '../ui/menus/app_bar.dart';

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
          child: body(context, images),
        ),
      );
    });
  }

  Widget body(context, ImagesProvider images) {
    return images.capturedImages.isEmpty
        ? Center(
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
          )
        : GridView.count(
            crossAxisCount: 3,
            mainAxisSpacing: 2,
            crossAxisSpacing: 2,
            children: images.capturedImages.reversed
                .map((image) => Image.file(image, fit: BoxFit.cover))
                .toList(),
          );
  }
}
