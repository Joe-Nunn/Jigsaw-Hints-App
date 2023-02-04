import 'dart:io';

import 'package:flutter/material.dart';
import 'package:jigsaw_hints/provider/images.dart';
import 'package:jigsaw_hints/utils/constants.dart';
import 'package:provider/provider.dart';

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
          style: Theme.of(context).textTheme.bodyLarge,
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
              topLeft: Radius.circular(defaultDialogBorderRadiusSmall),
              topRight: Radius.circular(defaultDialogBorderRadiusSmall),
            ),
          ),
          child: Center(
            child: Text(title,
                style: TextStyle(
                    color: titleFontColor,
                    fontWeight: FontWeight.bold,
                    fontSize:
                        Theme.of(context).textTheme.labelMedium?.fontSize)),
          ),
        ),
        titlePadding: const EdgeInsets.all(0),
        content: contentWidget,
        actions: actions,
        actionsAlignment: MainAxisAlignment.spaceBetween,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
                Radius.circular(defaultDialogBorderRadiusBig))),
      );
    },
  );
}

Widget imageDialog(BuildContext context, String path) {
  return Dialog(
    child: Column(
      mainAxisSize: MainAxisSize.min,
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
                  // Add image to provider
                  Provider.of<ImagesProvider>(context, listen: false)
                      .capturedImages
                      .add(File(path));
                  Navigator.of(context).pop();
                },
                icon: const Icon(Icons.check_rounded),
                color: Colors.green,
              ),
            ],
          ),
        ),
        Image.file(
          File(path),
          fit: BoxFit.cover,
        ),
      ],
    ),
  );
}

Widget popButton(BuildContext context,
    {String text = "Ok", Color? color, VoidCallback? onPressed}) {
  return TextButton(
    onPressed: onPressed ?? () => Navigator.of(context).pop(),
    child: Text(text,
        style: Theme.of(context).textTheme.labelMedium?.copyWith(color: color)),
  );
}
