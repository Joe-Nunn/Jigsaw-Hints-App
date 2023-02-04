import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:http/http.dart';
import 'package:jigsaw_hints/http/image_converter.dart';
import 'package:jigsaw_hints/http/image_sender.dart';
import 'package:jigsaw_hints/pages/widgets/solved_puzzle.dart';
import 'package:jigsaw_hints/ui/dialogs/info_dialog.dart';
import 'package:jigsaw_hints/utils/constants.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class JigsawPieceDialog extends StatefulWidget {
  final File piece;
  final File base;

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
  StreamSubscription<Response>? responseStream;
  Future<Response>? response;

  @override
  void initState() {
    super.initState();
    // Send image to the Flask server
    sendImageToServer();
  }

  void sendImageToServer() async {
    response = imageSender.sendImageToFlask(
      piece: ImageConverter.encodeToBase64(widget.piece),
      base: ImageConverter.encodeToBase64(widget.base),
    );
  }

  void sendImageToServerTestData() async {
    response = imageSender.sendImageToFlaskTestData();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Response>(
        future: response,
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
      String body = snapshot.data!.body;
      if (statusCode != 200) {
        body = "HTTP $statusCode: $body";
        return Text(
          body,
          style: Theme.of(context).textTheme.bodyLarge,
        );
      }
      return SolvedJigsawPuzzle(
        data: jsonDecode(body),
        base: widget.base,
      );
    } else if (snapshot.hasError) {
      String textToShow = "";
      debugPrint("### ERROR ${snapshot.error.toString()}");
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
    }
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

  List<Widget> getActions(
      BuildContext context, AsyncSnapshot<Response> snapshot) {
    if (snapshot.hasData || snapshot.hasError) {
      return [Container(), popButton(context)];
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
}
