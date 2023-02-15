import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:jigsaw_hints/provider/box_cover.dart';
import 'package:jigsaw_hints/provider/torch_provider.dart';
import 'package:jigsaw_hints/ui/dialogs/image_preview_dialog.dart';
import 'package:jigsaw_hints/ui/dialogs/jigsaw_piece_dialog.dart';
import 'package:jigsaw_hints/ui/menus/app_bar.dart';
import 'package:jigsaw_hints/provider/camera_mode.dart';
import 'package:jigsaw_hints/ui/dialogs/box_cover_dialog.dart';
import 'package:provider/provider.dart';
import 'package:showcaseview/showcaseview.dart';
import '../utils/constants.dart';
import '../ui/menus/drawer_menu.dart';
import '../ui/overlays/guideline_box.dart';

class CameraScreen extends StatefulWidget {
  final List<CameraDescription> cameras;
  const CameraScreen({
    Key? key,
    required this.cameras,
  }) : super(key: key);

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen>
    with WidgetsBindingObserver {
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // App state changed before we got the chance to initialize.
    if (!_controller.value.isInitialized) {
      return;
    }

    if (state == AppLifecycleState.inactive) {
      _controller.dispose();
    }
    // If the app is paused, and then resumed, reinitialize the camera controller
    else if (state == AppLifecycleState.resumed) {
      initializeCamera();
      if (Provider.of<TorchProvider>(context, listen: false).status) {
        _controller.setFlashMode(FlashMode.torch);
      }
    }
  }

  @override
  void initState() {
    super.initState();
    // Initially selectedCamera = 0
    initializeCamera();
    // Add the observer
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    // Dispose of the controller when the widget is disposed.
    _controller.dispose();
    // Remove the observer
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  late CameraController _controller; //To control the camera
  late Future<void>
      _initializeControllerFuture; //Future to wait until camera initializes
  // Camera properties
  final int selectedCamera = 0;
  final ResolutionPreset resolutionPreset = ResolutionPreset.medium;
  final ImageFormatGroup imageFormatGroup = ImageFormatGroup.jpeg;
  // Create a key for drawer menu
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  // Flag to indicate if the camera is taking a picture
  bool takingPicture = false;

  // Holds the position information of the guideline box
  final Map<String, double> _overlayPos = {
    'x': 0,
    'y': 0,
    'w': desiredPieceSize,
    'h': desiredPieceSize,
  };

  final Map<String, double> _overlaySize = {
    'w_piece': desiredPieceSize,
    'h_piece': desiredPieceSize,
    'w_box': 0,
    'h_box': 0,
  };

  initializeCamera() async {
    _controller = CameraController(
      // Get a specific camera from the list of available cameras.
      widget.cameras[selectedCamera],
      // Define the resolution to use.
      resolutionPreset,
      // Define the image format to use.
      imageFormatGroup: imageFormatGroup,
    );

    setState(() {
      // Next, initialize the controller. This returns a Future.
      _initializeControllerFuture = _controller.initialize();

      // Turn off flash by default
      _controller.setFlashMode(FlashMode.off);
    });
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
    _overlayPos['x'] =
        MediaQuery.of(context).size.width / 2 - desiredPieceSize / 2;
    _overlayPos['y'] =
        MediaQuery.of(context).size.height / 2 - desiredPieceSize;
    _overlaySize['w_box'] = MediaQuery.of(context).size.width;
    _overlaySize['h_box'] = MediaQuery.of(context).size.height / 1.44;

    return Consumer2<CameraModeProvider, BoxCoverProvider>(
      builder: (context, cameraMode, box, child) {
        cameraMode.mode =
            box.boxCover == null ? CameraMode.box : CameraMode.piece;
        return ShowCaseWidget(
          builder: Builder(
            builder: (context) {
              return SafeArea(
                child: Scaffold(
                  resizeToAvoidBottomInset: false,
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
                      GuidelineBox(
                          position: _overlayPos,
                          size: _overlaySize,
                          mode: cameraMode.mode),
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
          cameraPreview(),
          bottomMenu(context, keys, camera, box),
        ],
      );
    });
  }

  FutureBuilder<void> cameraPreview() {
    return FutureBuilder(
      future: _initializeControllerFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          // If the Future is complete, display the preview.
          return Stack(
            alignment: Alignment.center,
            children: [
              CameraPreview(_controller),
              if (takingPicture)
                const SpinKitSpinningLines(
                  size: 100,
                  lineWidth: 3.0,
                  duration: Duration(milliseconds: 4000),
                  color: Colors.white,
                ),
            ],
          );
        } else {
          // Otherwise, display a loading indicator.
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  Widget boxCoverButton(List<GlobalKey<State<StatefulWidget>>> keys,
      BuildContext context, BoxCoverProvider box) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(left: defaultContentPaddingMedium),
        child: Showcase(
          key: keys.elementAt(0),
          description: 'Select the box cover to work with',
          child: IconButton(
            onPressed: () => showBoxCoverDialog(context),
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

  Widget takePictureButton(List<GlobalKey<State<StatefulWidget>>> keys,
      BuildContext context, CameraModeProvider camera, BoxCoverProvider box) {
    return Align(
      child: Showcase(
        key: keys.elementAt(1),
        description: 'Take photo of a box or puzzle',
        child: ElevatedButton(
          onPressed: () async {
            setState(() {
              takingPicture = true;
            });
            // Ensure that the camera is initialized.
            await _initializeControllerFuture;
            // Attempt to take a picture and get the file
            var xFile = await _controller.takePicture();
            setState(() {
              takingPicture = false;
            });
            var path = xFile.path;
            if (!mounted) return;
            // If the box picture was taken, display it in a popup.
            if (camera.mode == CameraMode.box) {
              showDialog(
                  context: context,
                  builder: (_) => imagePreviewDialog(context, path),
                  barrierDismissible: false);
            } else if (camera.mode == CameraMode.piece) {
              // Send image to the server
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (_) => JigsawPieceDialog(
                  piece: File(path),
                  base: box.boxCover!,
                ),
              );
            }
          },
          style: ElevatedButton.styleFrom(
              shape: const CircleBorder(),
              padding: const EdgeInsets.all(32),
              foregroundColor: Theme.of(context).colorScheme.secondary),
          child: const SizedBox(),
        ),
      ),
    );
  }

  Widget flashButton(List<GlobalKey<State<StatefulWidget>>> keys) {
    return Consumer<TorchProvider>(builder: (context, torch, child) {
      return Align(
        alignment: Alignment.centerRight,
        child: Padding(
          padding: const EdgeInsets.only(right: defaultContentPaddingMedium),
          child: Showcase(
            key: keys.elementAt(2),
            description: 'Turn camera flash ON or OFF',
            child: IconButton(
              icon: Icon(
                Icons.flash_on,
                color: torch.status ? Colors.yellow : Colors.white,
                size: defaultIconSize,
              ),
              onPressed: () async {
                setState(() {
                  if (torch.status) {
                    _controller.setFlashMode(FlashMode.off);
                    torch.status = false;
                  } else {
                    _controller.setFlashMode(FlashMode.torch);
                    torch.status = true;
                  }
                });
              },
            ),
          ),
        ),
      );
    });
  }

  Widget bottomMenu(BuildContext context, List<GlobalKey> keys,
      CameraModeProvider camera, BoxCoverProvider box) {
    return Expanded(
      child: Container(
        color: bottomNavBgColour,
        child: Stack(
          children: [
            boxCoverButton(keys, context, box),
            takePictureButton(keys, context, camera, box),
            flashButton(keys),
          ],
        ),
      ),
    );
  }
}
