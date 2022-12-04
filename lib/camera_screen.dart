import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:jigsaw_hints/app_bar.dart';
import 'package:showcaseview/showcaseview.dart';
import 'constants.dart';
import 'drawer_menu.dart';
import 'guideline_box.dart';
import 'popup_dialog.dart';

class CameraScreen extends StatefulWidget {
  final List<CameraDescription> cameras;
  const CameraScreen({
    Key? key,
    required this.cameras,
  }) : super(key: key);

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  @override
  void initState() {
    initializeCamera(selectedCamera); //Initially selectedCamera = 0
    super.initState();
  }

  late CameraController _controller; //To control the camera
  late Future<void>
      _initializeControllerFuture; //Future to wait until camera initializes
  int selectedCamera = 0;
  List<File> capturedImages = [];
  bool flashlightOn = false;
  final GlobalKey<ScaffoldState> _key =
      GlobalKey(); // Create a key for drawer menu

  // Holds the position information of the guideline box
  final Map<String, double> _position = {
    'x': 0,
    'y': 0,
    'w': desiredPieceSize,
    'h': desiredPieceSize,
  };

  initializeCamera(int cameraIndex) async {
    _controller = CameraController(
      // Get a specific camera from the list of available cameras.
      widget.cameras[cameraIndex],
      // Define the resolution to use.
      ResolutionPreset.medium,
    );

    // Next, initialize the controller. This returns a Future.
    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    // Dispose of the controller when the widget is disposed.
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    GlobalKey bottomLeft = GlobalKey();
    GlobalKey bottomCenter = GlobalKey();
    GlobalKey bottomRight = GlobalKey();
    // Center of the screen coordinates
    _position['x'] =
        MediaQuery.of(context).size.width / 2 - desiredPieceSize / 2;
    _position['y'] = MediaQuery.of(context).size.height / 2 - desiredPieceSize;

    return ShowCaseWidget(
      builder: Builder(
        builder: (context) => SafeArea(
          child: Scaffold(
            key: _key,
            appBar: const JigsawAppBar(title: "Jigsaw Hints"),
            drawer: SizedBox(
              width: MediaQuery.of(context).size.width * 0.75,
              child: DrawerMenu(
                images: capturedImages.reversed.toList(),
                globalKeys: [bottomLeft, bottomCenter, bottomRight],
              ),
            ),
            backgroundColor: Colors.black,
            body: Stack(
              children: [
                body(context, [bottomLeft, bottomCenter, bottomRight]),
                GuidelineBox(position: _position),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Column body(BuildContext context, List<GlobalKey> keys) {
    return Column(
      children: [
        FutureBuilder<void>(
          future: _initializeControllerFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              // If the Future is complete, display the preview.
              return CameraPreview(_controller);
            } else {
              // Otherwise, display a loading indicator.
              return const Center(child: CircularProgressIndicator());
            }
          },
        ),
        const Spacer(),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Stack(
            children: [
              Positioned(
                  left: 0,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Showcase(
                      key: keys.elementAt(0),
                      description: 'Feature in progress...',
                      child: IconButton(
                          onPressed: () => dialogBuilder(context, "Disclaimer",
                              "We cannot afford Apple products, so this app only works on Android."),
                          icon: const Icon(
                            Icons.apple,
                            color: Colors.white,
                          )),
                    ),
                  )),
              Align(
                child: Showcase(
                  key: keys.elementAt(1),
                  description: 'Take photo of a puzzle',
                  child: ElevatedButton(
                    onPressed: () async {
                      await _initializeControllerFuture;
                      var xFile = await _controller.takePicture();
                      setState(() {
                        capturedImages.add(File(xFile.path));
                      });
                    },
                    style: ElevatedButton.styleFrom(
                        shape: const CircleBorder(),
                        padding: const EdgeInsets.all(32),
                        foregroundColor: secondaryColour),
                    child: const SizedBox(),
                  ),
                ),
                // child: GestureDetector(
                //   onTap: () async {
                //     await _initializeControllerFuture;
                //     var xFile = await _controller.takePicture();
                //     setState(() {
                //       capturedImages.add(File(xFile.path));
                //     });
                //   },
                //   child: Showcase(
                //     key: keys.elementAt(1),
                //     description: 'Take photo of a puzzle',
                //     child: Container(
                //       height: 60,
                //       width: 60,
                //       decoration: const BoxDecoration(
                //         shape: BoxShape.circle,
                //         color: Colors.white,
                //       ),
                //     ),
                //   ),
                // ),
              ),
              Positioned(
                right: 0,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Showcase(
                    key: keys.elementAt(2),
                    description: 'Turn camera flash ON or OFF',
                    child: IconButton(
                      icon: Icon(
                        Icons.flash_on,
                        color: flashlightOn ? Colors.yellow : Colors.white,
                        size: 30.0,
                      ),
                      onPressed: () {
                        flashlightOn
                            ? _controller.setFlashMode(FlashMode.off)
                            : _controller.setFlashMode(FlashMode.always);
                        setState(() {
                          flashlightOn = !flashlightOn;
                        });
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const Spacer(),
      ],
    );
  }
}
