import 'package:flutter/material.dart';
import 'package:jigsaw_hints/pages/gallery_screen.dart';
import 'package:jigsaw_hints/provider/box_cover.dart';
import 'package:jigsaw_hints/ui/animations/animations.dart';
import 'package:jigsaw_hints/utils/constants.dart';
import 'package:provider/provider.dart';
import 'package:animated_button/animated_button.dart';

void showSelectedBoxCoverDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Consumer<BoxCoverProvider>(builder: (context, box, child) {
        return AlertDialog(
          title: Container(
            padding: const EdgeInsets.all(defaultDialogPadding),
            decoration: BoxDecoration(
              color: box.boxCover == null ? Colors.red : Colors.green,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(10.0),
                topRight: Radius.circular(10.0),
              ),
            ),
            child: Center(
              child: Text(
                box.boxCover == null
                    ? "No box cover selected"
                    : "Selected box cover",
                style: const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          titlePadding: const EdgeInsets.all(0),
          content: getContent(context, box),
          actions: getActions(context),
          actionsAlignment: MainAxisAlignment.spaceBetween,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(defaultDialogBorderRadius),
            ),
          ),
        );
      });
    },
  );
}

Widget getContent(BuildContext context, BoxCoverProvider boxCoverProvider) {
  if (boxCoverProvider.boxCover == null) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: desiredPieceSize / 1.5,
          height: desiredPieceSize / 1.5,
          child: Image.asset("images/jigsaw_box.png"),
        ),
        AnimatedButton(
          onPressed: () {
            Navigator.push(context, slideIn(const GalleryScreen()));
          }, // Callback for onTap event
          duration: 100, // Animaton duration
          height: 60, // Button Height
          width: 150, // Button width
          color: themeLightBlue,
          child: Text(
            "Select box cover",
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: Colors.white,
                ),
          ),
        ),
      ],
    );
  } else {
    return const Text("data");
  }
}

List<Widget> getActions(BuildContext context) {
  return <Widget>[Container(), Container()];
}