import 'package:flutter/material.dart';
import 'package:jigsaw_hints/pages/gallery_screen.dart';
import 'package:jigsaw_hints/provider/box_cover.dart';
import 'package:jigsaw_hints/ui/animations.dart';
import 'package:jigsaw_hints/utils/constants.dart';
import 'package:provider/provider.dart';
import 'package:animated_button/animated_button.dart';

void showSelectedBoxCoverDialog(BuildContext context) {
  var boxCoverProvider = Provider.of<BoxCoverProvider>(context, listen: false);
  Color titleBgColor =
      boxCoverProvider.boxCover == null ? Colors.red : Colors.green;
  String titleText = boxCoverProvider.boxCover == null
      ? "No box cover selected"
      : "Selected box cover";

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
            child: Text(titleText,
                style: const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ),
        titlePadding: const EdgeInsets.all(0),
        content: getContent(context, boxCoverProvider),
        actions: getActions(context),
        actionsAlignment: MainAxisAlignment.spaceBetween,
        shape: const RoundedRectangleBorder(
            borderRadius:
                BorderRadius.all(Radius.circular(defaultDialogBorderRadius))),
      );
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
          duration: 100, // Animaton duration, default is 70 Milliseconds
          height: 60, // Button Height, default is 64
          width: 150, // Button width, default is 200
          color: Colors.blue,
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
    return Text("data");
  }
}

List<Widget> getActions(BuildContext context) {
  return <Widget>[Container(), Container()];
}
