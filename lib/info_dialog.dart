import 'dart:io';

import 'package:flutter/material.dart';
import 'package:jigsaw_hints/constants.dart';

import 'camera_screen.dart';
import 'drawer_menu.dart';
import 'gallery_screen.dart';

void showInfoDialog(BuildContext context,
    {String title = "Title",
    Color titleBgColor = Colors.blue,
    Color titleFontColor = Colors.white,
    String content = "Content",
    Widget? leftButton,
    Widget? rightButton,
    bool includePicture = false,
    Widget? picture}) {
  // Action buttons
  var actions = <Widget>[
    leftButton ?? Container(),
    rightButton ?? popButton(context),
  ];
  // Content
  var contentWidget = includePicture
      ? SizedBox(
          width: desiredPieceSize / 1.5,
          height: desiredPieceSize / 1.5,
          child: picture,
        )
      : Text(
          content,
          style: Theme.of(context).textTheme.bodyMedium,
        );

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Container(
          padding: const EdgeInsets.all(defaultDialogPadding),
          decoration: BoxDecoration(
            color: titleBgColor,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(10.0),
              topRight: Radius.circular(10.0),
            ),
          ),
          child: Center(
            child: Text(title,
                style: TextStyle(
                    color: titleFontColor, fontWeight: FontWeight.bold)),
          ),
        ),
        titlePadding: const EdgeInsets.all(0),
        content: contentWidget,
        actions: actions,
        actionsAlignment: MainAxisAlignment.spaceBetween,
        shape: const RoundedRectangleBorder(
            borderRadius:
                BorderRadius.all(Radius.circular(defaultDialogBorderRadius))),
      );
    },
  );
}

Widget imageDialog(BuildContext context, String path) {
  return Dialog(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: const Icon(Icons.close_rounded),
                color: Colors.redAccent,
              ),
              IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  showInfoDialog(context,
                      title: "Select a box picture",
                      leftButton: goToGalleryButton(context, "Saved Boxes",
                          Theme.of(context).colorScheme.tertiary),
                      rightButton: popButton(context,
                          text: "Take Photo",
                          color: Theme.of(context).colorScheme.tertiary),
                      includePicture: true,
                      picture: Image.asset("images/jigsaw_box.png"));
                },
                icon: const Icon(Icons.check_rounded),
                color: Colors.green,
              ),
            ],
          ),
        ),
        SizedBox(
          width: 220,
          height: 200,
          child: Image.file(
            File(path),
            fit: BoxFit.cover,
          ),
        ),
      ],
    ),
  );
}

Widget popButton(BuildContext context, {String text = "Ok", Color? color}) {
  return TextButton(
    child: Text(text,
        style: Theme.of(context).textTheme.labelMedium?.copyWith(color: color)),
    onPressed: () {
      Navigator.of(context).pop();
    },
  );
}

Widget goToGalleryButton(BuildContext context, String text, Color color) {
  return TextButton(
    child: Text(text,
        style: Theme.of(context).textTheme.labelMedium?.copyWith(color: color)),
    onPressed: () {
      Navigator.push(
          context, slideIn(GalleryScreen(images: CameraScreen.capturedImages)));
    },
  );
}
