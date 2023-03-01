import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:photo_view/photo_view.dart';

class FullScreenImage extends StatefulWidget {
  final Uint8List image;

  const FullScreenImage({Key? key, required this.image}) : super(key: key);

  @override
  State<FullScreenImage> createState() => _FullScreenImageState();
}

class _FullScreenImageState extends State<FullScreenImage> {
  ImageOrientation orientation = ImageOrientation.vertical;

  @override
  Widget build(BuildContext context) {
    if (orientation == ImageOrientation.vertical) {
      setVorizontalMode();
    } else {
      setLandscapeMode();
    }

    return SafeArea(
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          elevation: 0,
          leading: GestureDetector(
            child: IconButton(
                icon: const Icon(Icons.arrow_back_ios),
                color: Colors.white,
                onPressed: () => Navigator.pop(context)),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          actions: [
            IconButton(
                icon: orientation == ImageOrientation.vertical
                    ? const Icon(Icons.rotate_right)
                    : const Icon(Icons.rotate_left),
                color: Colors.white,
                onPressed: () => toggleOrientation()),
          ],
          backgroundColor: Colors.transparent,
        ),
        body: LayoutBuilder(builder: (context, constraints) {
          return Center(
            child: Hero(
              tag: "Solved Jigsaw Image",
              child: PhotoView(
                customSize: Size(constraints.maxWidth, constraints.maxHeight),
                imageProvider: MemoryImage(widget.image),
                minScale: PhotoViewComputedScale.contained,
              ),
            ),
          );
        }),
      ),
    );
  }

  void setLandscapeMode() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }

  void setVorizontalMode() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  void toggleOrientation() {
    setState(() {
      if (orientation == ImageOrientation.vertical) {
        orientation = ImageOrientation.horizontal;
      } else {
        orientation = ImageOrientation.vertical;
      }
    });
  }
}

enum ImageOrientation { vertical, horizontal }
