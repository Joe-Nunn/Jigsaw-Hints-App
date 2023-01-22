import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:jigsaw_hints/pages/gallery_screen.dart';
import 'package:jigsaw_hints/provider/box_cover.dart';
import 'package:jigsaw_hints/ui/animations/animations.dart';
import 'package:jigsaw_hints/ui/dialogs/info_dialog.dart';
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
  return boxCoverProvider.boxCover == null
      ? boxNotSelectedContent(context)
      : boxSelectedContent(context, boxCoverProvider);
}

Column boxSelectedContent(
    BuildContext context, BoxCoverProvider boxCoverProvider) {
  return Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      Stack(
        children: [
          SizedBox(
            width: desiredPieceSize,
            height: desiredPieceSize,
            child: Animate(
              child: Image.file(
                boxCoverProvider.boxCover!,
                fit: BoxFit.cover,
              )
                  .animate(
                    onPlay: (controller) => controller.repeat(),
                  )
                  .shimmer(duration: 3000.ms)
                  .then(delay: 5000.ms),
            ),
          ),
          Positioned(
            right: 0,
            top: 0,
            child: IconButton(
              icon: const Icon(
                Icons.cancel_outlined,
                color: themeLightRed,
              ),
              onPressed: () => showInfoDialog(
                context,
                title: "Resetting box cover",
                content: "Are you sure?",
                titleBgColor: Colors.redAccent,
                rightButton: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: popButton(context, text: "Yes", onPressed: () {
                    boxCoverProvider.boxCover = null;
                    Navigator.pop(context);
                  }),
                ),
                leftButton: popButton(context, text: "No"),
              ),
            ),
          )
        ],
      ),
      const SizedBox(
        height: defaultSmallWhitespace,
      ),
      Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            children: const [Text("📡 Server: Connected "), Icon(Icons.wifi)],
          ),
          Row(
            children: [
              const Text(
                "🧠 AI Model: Active ",
              ),
              const Icon(
                Icons.circle,
                color: Colors.green,
              )
                  .animate(
                    onPlay: (controller) => controller.repeat(),
                  )
                  .tint(
                    color: Colors.greenAccent,
                    duration: const Duration(milliseconds: 300),
                  )
                  .then(delay: 500.ms)
                  .tint(
                      color: Colors.green,
                      duration: const Duration(milliseconds: 300))
                  .then(delay: 500.ms),
            ],
          ),
        ],
      )
    ],
  );
}

Column boxNotSelectedContent(BuildContext context) {
  return Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      SizedBox(
        width: desiredPieceSize / 1.5,
        height: desiredPieceSize / 1.5,
        child: Image.asset("images/jigsaw_box.png")
            .animate()
            .shake(duration: 500.ms),
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
      ).animate(delay: 500.ms).scale()
    ],
  );
}

List<Widget> getActions(BuildContext context) {
  return <Widget>[Container(), Container()];
}
