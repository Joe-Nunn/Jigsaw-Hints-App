import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:jigsaw_hints/provider/box_cover.dart';
import 'package:jigsaw_hints/ui/menus/app_bar.dart';
import 'package:jigsaw_hints/provider/camera_mode.dart';
import 'package:jigsaw_hints/ui/dialogs/box_cover_dialog.dart';
import 'package:provider/provider.dart';
import 'package:showcaseview/showcaseview.dart';
import '../utils/constants.dart';
import '../ui/menus/drawer_menu.dart';
import '../ui/overlays/guideline_box.dart';
import '../ui/dialogs/info_dialog.dart';

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

  @override
  void dispose() {
    // Dispose of the controller when the widget is disposed.
    _controller.dispose();
    super.dispose();
  }

  late CameraController _controller; //To control the camera
  late Future<void>
      _initializeControllerFuture; //Future to wait until camera initializes
  int selectedCamera = 0;
  bool flashlightOn = false;
  // Create a key for drawer menu
  final GlobalKey<ScaffoldState> _key = GlobalKey();

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

    // Turn off flash by default
    _controller.setFlashMode(FlashMode.off);
  }

  @override
  Widget build(BuildContext context) {
    // Create a global key for each of the tutorial segments
    GlobalKey bottomLeftKey = GlobalKey();
    GlobalKey bottomCenterKey = GlobalKey();
    GlobalKey bottomRightKey = GlobalKey();
    var showcaseKeys = [
      bottomLeftKey,
      bottomCenterKey,
      bottomRightKey,
    ];
    // Center of the screen coordinates
    _position['x'] =
        MediaQuery.of(context).size.width / 2 - desiredPieceSize / 2;
    _position['y'] = MediaQuery.of(context).size.height / 2 - desiredPieceSize;

    return Consumer2<CameraModeProvider, BoxCoverProvider>(
      builder: (context, cameraMode, box, child) {
        cameraMode.mode =
            box.boxCover == null ? CameraMode.box : CameraMode.piece;
        return ShowCaseWidget(
          builder: Builder(
            builder: (context) {
              return SafeArea(
                child: Scaffold(
                  key: _key,
                  appBar: const JigsawAppBar(title: "Camera"),
                  drawer: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.75,
                    child: DrawerMenu(
                      globalKeys: [
                        bottomLeftKey,
                        bottomCenterKey,
                        bottomRightKey
                      ],
                    ),
                  ),
                  backgroundColor: Colors.black,
                  body: Stack(
                    children: [
                      body(context, showcaseKeys, cameraMode),
                      GuidelineBox(position: _position, mode: cameraMode.mode),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget body(
      BuildContext context, List<GlobalKey> keys, CameraModeProvider camera) {
    return Consumer<BoxCoverProvider>(builder: (context, box, child) {
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
                boxCoverButton(keys, context, box),
                Align(
                  child: Showcase(
                    key: keys.elementAt(1),
                    description: 'Take photo of a puzzle',
                    child: ElevatedButton(
                      onPressed: () async {
                        // Ensure that the camera is initialized.
                        await _initializeControllerFuture;
                        // Attempt to take a picture and get the file
                        var xFile = await _controller.takePicture();
                        var path = xFile.path;
                        if (!mounted) return;
                        // If the picture was taken, display it in a popup.
                        if (camera.mode == CameraMode.box) {
                          showDialog(
                              context: context,
                              builder: (_) => imageDialog(context, path));
                        }
                      },
                      style: ElevatedButton.styleFrom(
                          shape: const CircleBorder(),
                          padding: const EdgeInsets.all(32),
                          foregroundColor:
                              Theme.of(context).colorScheme.secondary),
                      child: const SizedBox(),
                    ),
                  ),
                ),
                flashButton(keys),
              ],
            ),
          ),
          const Spacer(),
        ],
      );
    });
  }

  Positioned flashButton(List<GlobalKey<State<StatefulWidget>>> keys) {
    return Positioned(
      right: 0,
      child: Padding(
        padding: const EdgeInsets.only(right: defaultMediumContentPadding),
        child: Showcase(
          key: keys.elementAt(2),
          description: 'Turn camera flash ON or OFF',
          child: IconButton(
            icon: Icon(
              Icons.flash_on,
              color: flashlightOn ? Colors.yellow : Colors.white,
              size: defaultIconSize,
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
    );
  }

  Positioned boxCoverButton(List<GlobalKey<State<StatefulWidget>>> keys,
      BuildContext context, BoxCoverProvider box) {
    return Positioned(
      left: 0,
      child: Padding(
        padding: const EdgeInsets.only(left: defaultMediumContentPadding),
        child: Showcase(
          key: keys.elementAt(0),
          description: 'Select the box cover to work with',
          child: IconButton(
            onPressed: () => showSelectedBoxCoverDialog(context),
            icon: Icon(
              Icons.settings_system_daydream,
              color: box.boxCover == null ? Colors.white : Colors.green,
              size: defaultIconSize,
            ),
          ),
        ),
      ),
    );
  }
}
