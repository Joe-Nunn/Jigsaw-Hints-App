import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jigsaw_hints/provider/box_cover.dart';
import 'package:jigsaw_hints/provider/images.dart';
import 'package:jigsaw_hints/utils/constants.dart';
import 'package:provider/provider.dart';

Widget numberOfPiecesDialog(
    BuildContext context, XFile file, Directory dataDir) {
  bool textFieldHasValidInput = false;
  final TextEditingController controller = TextEditingController();
  final GlobalKey toolTipKey = GlobalKey();
  return StatefulBuilder(
    builder: ((context, setState) {
      return AlertDialog(
        title: const Center(
            child: Text("Puzzle Size",
                style: TextStyle(fontWeight: FontWeight.bold))),
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
                Radius.circular(defaultDialogBorderRadiusBig))),
        content:
            // TextField for numbers only
            TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
              hintText: "Number of pieces",
              hintStyle: Theme.of(context)
                  .textTheme
                  .labelMedium
                  ?.copyWith(color: Colors.black.withOpacity(0.3)),
              hintMaxLines: 2,
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(
                      color: Theme.of(context).colorScheme.secondary,
                      width: 2)),
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(
                      color: Theme.of(context).colorScheme.secondary,
                      width: 2))),
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
          ],
          onChanged: (value) {
            setState(
              () {
                if (value.isNotEmpty &&
                    value.length < 6 &&
                    !value.startsWith("0")) {
                  textFieldHasValidInput = true;
                } else {
                  textFieldHasValidInput = false;
                }
              },
            );
          },
        ),
        actionsAlignment: MainAxisAlignment.spaceBetween,
        actions: [
          Tooltip(
            showDuration: const Duration(seconds: 6),
            key: toolTipKey,
            triggerMode: TooltipTriggerMode.manual,
            message:
                "This can usually be found on the physical box 🧩. \n It must be a whole number (eg. 1000).",
            child: IconButton(
                onPressed: () {
                  final toolTip = toolTipKey.currentState as TooltipState;
                  toolTip.ensureTooltipVisible();
                },
                icon: const Icon(
                  Icons.info_outline,
                  color: Colors.blue,
                  size: defaultIconSize / 1.5,
                )),
          ),
          Visibility(
            visible: textFieldHasValidInput,
            maintainSize: true,
            maintainAnimation: true,
            maintainState: true,
            child: TextButton(
              child: Text(
                "Save box cover",
                style: Theme.of(context)
                    .textTheme
                    .labelMedium
                    ?.copyWith(color: Theme.of(context).colorScheme.tertiary),
              ),
              onPressed: () async {
                int input = int.parse(controller.text);
                var boxCover =
                    BoxCover(image: File(file.path), numberOfPieces: input);
                boxCover.save(dataDir);
                Provider.of<ImagesProvider>(context, listen: false)
                    .capturedImages
                    .add(boxCover);
                Navigator.of(context).pop();
              },
            ),
          ),
        ],
      );
    }),
  );
}
