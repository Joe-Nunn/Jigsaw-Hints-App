import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:jigsaw_hints/ui/dialogs/number_of_pieces_dialog.dart';
import 'package:path_provider/path_provider.dart';

Widget imagePreviewDialog(BuildContext context, XFile file) {
  return Dialog(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8.0, right: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: const Icon(Icons.close_rounded),
                label: const Text("Retake"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(20),
                    ),
                  ),
                ),
              ),
              ElevatedButton.icon(
                onPressed: () async {
                  Navigator.of(context).pop();
                  final dataDir = await getApplicationDocumentsDirectory();
                  showDialog(
                      context: context,
                      builder: (_) =>
                          numberOfPiecesDialog(context, file, dataDir),
                      barrierDismissible: false);
                },
                icon: const Icon(Icons.check_rounded),
                label: const Text("Accept"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(20),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Image.file(
          File(file.path),
          fit: BoxFit.contain,
        ),
      ],
    ),
  );
}