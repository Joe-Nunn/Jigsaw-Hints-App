import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:http/http.dart';
import 'package:jigsaw_hints/http/image_converter.dart';
import 'package:jigsaw_hints/http/image_sender.dart';
import 'package:jigsaw_hints/pages/widgets/solved_puzzle.dart';
import 'package:jigsaw_hints/provider/box_cover.dart';
import 'package:jigsaw_hints/settings/default_settings.dart';
import 'package:jigsaw_hints/settings/shared_prefs.dart';
import 'package:jigsaw_hints/ui/dialogs/info_dialogs.dart';
import 'package:jigsaw_hints/utils/constants.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class JigsawPieceDialog extends StatefulWidget {
  final File piece;
  final BoxCover base;

  const JigsawPieceDialog({
    Key? key,
    required this.piece,
    required this.base,
  }) : super(key: key);

  @override
  State<JigsawPieceDialog> createState() => _JigsawPieceDialogState();
}

class _JigsawPieceDialogState extends State<JigsawPieceDialog> {
  final ImageSender imageSender = ImageSender();
  late SharedPreferences sharedPrefs;
  late String serverAddress;
  late bool isDebugMode;
  late String algorithmType;
  late int hintAccuracy;

  Future<Response> sendImageToServer(
      String serverAddress, String algorithmType, int hintAccuracy) async {
    return imageSender.sendImageToFlask(
      piece: ImageConverter.encodeToBase64(widget.piece),
      base: ImageConverter.encodeToBase64(widget.base.getFile),
      serverAddress: serverAddress,
      algorithmType: algorithmType,
      hintAccuracy: hintAccuracy,
      numberOfPieces: widget.base.getNumberOfPieces,
    );
  }

  Future<Response> sendImageToServerTestData(String serverAddress) async {
    return imageSender.sendImageToFlaskTestData(serverAddress: serverAddress);
  }

  @override
  Widget build(BuildContext context) {
    sharedPrefs = context.watch<SharedPreferences>();
    serverAddress = sharedPrefs.getString(SharedPrefsKeys.serverAddress.name) ??
        defaultServerAddress;
    isDebugMode =
        sharedPrefs.getBool(SharedPrefsKeys.debugMode.name) ?? defaultDebugMode;
    algorithmType = describeEnum(AlgorithmType.values[
            sharedPrefs.getInt(SharedPrefsKeys.algorithmType.name) ??
                defaultAlgorithmType])
        .toUpperCase();
    hintAccuracy = sharedPrefs.getInt(SharedPrefsKeys.hintAccuracy.name) ??
        defaultHintAccuracy;

    return FutureBuilder<Response>(
        future: isDebugMode
            ? sendImageToServerTestData(serverAddress)
            : sendImageToServer(serverAddress, algorithmType, hintAccuracy),
        builder: (context, snapshot) {
          bool responseIsSuccess =
              snapshot.hasData && snapshot.data!.statusCode == 200;
          return AlertDialog(
            title: snapshot.hasData
                ? Container(
                    padding: const EdgeInsets.all(defaultDialogPadding),
                    decoration: BoxDecoration(
                      color: responseIsSuccess ? Colors.green : Colors.red,
                      borderRadius: const BorderRadius.only(
                        topLeft:
                            Radius.circular(defaultDialogBorderRadiusSmall),
                        topRight:
                            Radius.circular(defaultDialogBorderRadiusSmall),
                      ),
                    ),
                    child: Center(
                      child: Text(responseIsSuccess ? "Success" : "Error",
                          style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold)),
                    ),
                  )
                : null,
            titlePadding: const EdgeInsets.all(0),
            content: getContent(context, snapshot),
            actions: getActions(context, snapshot),
            actionsAlignment: MainAxisAlignment.spaceBetween,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(defaultDialogBorderRadiusBig),
              ),
            ),
          );
        });
  }

  Widget getContent(BuildContext context, AsyncSnapshot<Response> snapshot) {
    if (snapshot.hasData) {
      final statusCode = snapshot.data!.statusCode;
      String body = snapshot.data?.body ?? "Empty response body";
      if (statusCode == 400) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: const [
            Text("Puzzle couldn't be solved 🤔"),
            Text("Please try again 🧩"),
          ],
        );
      } else if (statusCode != 200 || body.isEmpty || !bodyIsValidJson(body)) {
        body = "HTTP $statusCode: $body";
        return Text(
          body,
          style: Theme.of(context).textTheme.bodyLarge,
        );
      } else {
        Map<String, dynamic> data = jsonDecode(body);
        String base64Image = data["solved_data"] ?? "No image data";
        return SolvedJigsawPuzzle(
          image: base64Image,
        );
      }
    } else if (snapshot.hasError) {
      String textToShow = "";
      if (snapshot.error is SocketException) {
        textToShow = "No Internet connection 😑";
      } else if (snapshot.error is HttpException) {
        textToShow = "Could not find the host 😱";
      } else if (snapshot.error is FormatException) {
        textToShow = "Invalid response format 👎";
      } else {
        textToShow = snapshot.error.toString();
      }
      return Text(
        textToShow,
        style: Theme.of(context).textTheme.bodyLarge,
      );
    } else if (snapshot.connectionState == ConnectionState.waiting) {
      return SizedBox(
          width: desiredPieceSize,
          height: desiredPieceSize,
          child: Image.file(
            widget.piece,
            fit: BoxFit.cover,
          )
              .animate(
                delay: 2.seconds,
                onComplete: (controller) => controller.repeat(),
              )
              .then(delay: 3.seconds)
              .tint(duration: 2.seconds, color: Colors.red, end: 0.3)
              .then(delay: 3.seconds)
              .tint(duration: 2.seconds, color: Colors.green, end: 0.3)
              .then(delay: 3.seconds)
              .tint(duration: 2.seconds, color: Colors.blue, end: 0.3)
              .then(delay: 3.seconds));
    }
    return const SpinKitFadingCircle(
      color: Colors.blue,
      size: 50.0,
    );
  }

  List<Widget> getActions(
      BuildContext context, AsyncSnapshot<Response> snapshot) {
    if (snapshot.hasError) {
      return [Container(), popButton(context)];
    } else if (snapshot.hasData) {
      if (snapshot.data!.statusCode != 200) {
        return [Container(), popButton(context)];
      }
      GlobalKey toolTipKey = GlobalKey();
      return [
        Tooltip(
          showDuration: const Duration(seconds: 3),
          key: toolTipKey,
          triggerMode: TooltipTriggerMode.manual,
          message: "Pinch to zoom in 🤏",
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
        popButton(context)
      ];
    }
    return [
      popButton(context,
          text: "Cancel",
          onPressed: () => showInfoDialog(
                context,
                title: "Stop solving",
                content: "Are you sure?",
                titleBgColor: Colors.redAccent,
                rightButton: popButton(context, text: "Yes", onPressed: () {
                  Navigator.of(context).popUntil(ModalRoute.withName('/'));
                }),
                leftButton: popButton(context, text: "No"),
              )),
      // LoadingBouncingGrid.square(
      //   backgroundColor: themeLightBlue,
      // ).animate().scale(),
      const SpinKitCubeGrid(
        color: themeLightBlue,
      ),
      Text("Solving...", style: Theme.of(context).textTheme.labelMedium),
    ];
  }

  bool bodyIsValidJson(String body) {
    try {
      jsonDecode(body);
      return true;
    } catch (ex) {
      return false;
    }
  }
}
